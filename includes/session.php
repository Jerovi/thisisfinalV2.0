<?php
/**
 * Secure Session Handler
 * Manages PHP sessions with security best practices
 */

class Session {
    private static bool $started = false;
    
    /**
     * Start secure session
     */
    public static function start(): void {
        if (self::$started || session_status() === PHP_SESSION_ACTIVE) {
            return;
        }

        // FIX: Guard against "headers already sent" — the root cause of the warning.
        // This happens when something outputs content (even a blank line or BOM)
        // before this file is included. Check and log exactly which file caused it.
        if (headers_sent($file, $line)) {
            error_log("Session::start() failed — headers already sent in $file on line $line");
            return;
        }
        
        // Configure secure session settings
        ini_set('session.use_strict_mode', 1);
        ini_set('session.use_only_cookies', 1);
        ini_set('session.cookie_httponly', 1);
        ini_set('session.cookie_samesite', 'Lax');
        
        // Use secure cookies in production
        if (APP_ENV === 'production' || isset($_SERVER['HTTPS'])) {
            ini_set('session.cookie_secure', 1);
        }
        
        // Set session lifetime
        ini_set('session.gc_maxlifetime', SESSION_LIFETIME);
        
        // session_name() must be called BEFORE session_start()
        session_name('GLSESSION');
        
        // Start session
        session_start();
        
        // Regenerate session ID periodically
        self::regenerateIfNeeded();
        
        // Validate session
        self::validate();
        
        self::$started = true;
    }
    
    /**
     * Regenerate session ID if needed
     */
    private static function regenerateIfNeeded(): void {
        $regenerateInterval = 300; // 5 minutes

        // FIX: Always check headers_sent() before session_regenerate_id().
        // If any output was sent before this point, regeneration throws a warning.
        if (headers_sent()) {
            return;
        }
        
        if (!isset($_SESSION['_last_regenerate'])) {
            $_SESSION['_last_regenerate'] = time();
            session_regenerate_id(true);
        } elseif (time() - $_SESSION['_last_regenerate'] > $regenerateInterval) {
            $_SESSION['_last_regenerate'] = time();
            session_regenerate_id(true);
        }
    }
    
    /**
     * Validate session integrity
     */
    private static function validate(): void {
        $userAgent = $_SERVER['HTTP_USER_AGENT'] ?? '';

        // Store fingerprint on first visit
        if (!isset($_SESSION['_fingerprint'])) {
            $_SESSION['_fingerprint'] = self::createFingerprint($userAgent);
            $_SESSION['_created'] = time();
        }
        
        // Use createFingerprint() consistently for both storing and comparing
        $currentFingerprint = self::createFingerprint($userAgent);

        if (isset($_SESSION['_ua_hash']) && $_SESSION['_ua_hash'] !== $currentFingerprint) {
            // Possible session hijacking — destroy and restart clean
            self::destroy();
            self::start();
            return;
        }
        
        $_SESSION['_ua_hash'] = $currentFingerprint;
        
        // Check session age
        if (isset($_SESSION['_created']) && (time() - $_SESSION['_created']) > SESSION_LIFETIME) {
            self::destroy();
            self::start();
            return;
        }
        
        // Update last activity
        $_SESSION['_last_activity'] = time();
    }
    
    /**
     * Create session fingerprint
     */
    private static function createFingerprint(string $userAgent): string {
        return hash('sha256', $userAgent . APP_SECRET);
    }
    
    /**
     * Set session value
     */
    public static function set(string $key, mixed $value): void {
        $_SESSION[$key] = $value;
    }
    
    /**
     * Get session value
     */
    public static function get(string $key, mixed $default = null): mixed {
        return $_SESSION[$key] ?? $default;
    }
    
    /**
     * Check if session key exists
     */
    public static function has(string $key): bool {
        return isset($_SESSION[$key]);
    }
    
    /**
     * Remove session key
     */
    public static function remove(string $key): void {
        unset($_SESSION[$key]);
    }
    
    /**
     * Clear all session data
     */
    public static function clear(): void {
        $_SESSION = [];
    }
    
    /**
     * Destroy session completely
     */
    public static function destroy(): void {
        $_SESSION = [];
        
        // FIX: Only attempt to clear the cookie if headers haven't been sent yet
        if (!headers_sent() && ini_get('session.use_cookies')) {
            $params = session_get_cookie_params();
            setcookie(
                session_name(),
                '',
                1, // timestamp of 1 = already expired in all browsers
                $params['path'],
                $params['domain'],
                $params['secure'],
                $params['httponly']
            );
        }
        
        session_destroy();
        self::$started = false;
    }
    
    /**
     * Regenerate session ID (public method)
     */
    public static function regenerate(): void {
        // FIX: Guard here too — this is line 164 from your error, the direct cause
        if (headers_sent($file, $line)) {
            error_log("Session::regenerate() failed — headers already sent in $file on line $line");
            return;
        }
        session_regenerate_id(true);
        $_SESSION['_last_regenerate'] = time();
    }
}

// Start session automatically when this file is included
Session::start();