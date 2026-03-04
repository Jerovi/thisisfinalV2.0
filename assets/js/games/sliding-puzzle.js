/**
 * NIR Agri-Puzzle Game – Scatter & Reassemble Edition
 * - Pick your picture first
 * - Pieces are scattered randomly across the canvas
 * - Freely drag any piece to its correct slot in the grid
 * - Pieces snap in with a satisfying click when close enough
 * - Progressive difficulty: bigger grids each level
 */

'use strict';

// =============================================================================
//  GLOBAL STATE
// =============================================================================
let gameCanvas, ctx;
let gameState = 'picker'; // picker | loading | playing | solved | ended
let score = 0;
let moves = 0;
let gameConfig;
let startTime;
let elapsedTime = 0;
let currentLevelIndex = 0;
let loadedImage = null;
let useFallback = false;
let rafId = null;

// ─── Visual FX ────────────────────────────────────────────────────────────────
let solveFlashStart = null;
let particles = [];

// ─── Lives system ─────────────────────────────────────────────────────────────
const MAX_LIVES = 3;
let lives = MAX_LIVES;
let heartShakeStart = null;   // timestamp – animate lost heart
let lostHeartIndex  = -1;     // which heart was just lost
let wrongDropFlash  = null;   // { x, y, start } – red flash at wrong drop spot
let screenFlashStart = null;  // full-screen red flash timestamp
let lastLifeWarning  = false; // true when on last life (shows banner)

// ─── Picker ───────────────────────────────────────────────────────────────────
let pickerImages   = [];
let pickerSelected = 0;
let pickerHover    = -1;
let pickerCards    = [];

// ─── Difficulty ───────────────────────────────────────────────────────────────
const difficultyLevels = [
    { gridSize: 3, label: '★☆☆  Easy'    },
    { gridSize: 3, label: '★★☆  Medium'  },
    { gridSize: 4, label: '★★★  Hard'    },
    { gridSize: 4, label: '🔥🔥   Expert'  },
    { gridSize: 5, label: '💀💀💀 Insane'  },
];

let puzzleLevels = [];

// ─── Puzzle geometry ──────────────────────────────────────────────────────────
let gridSize      = 3;
let tileSize      = 90;
let puzzleOriginX = 0;
let puzzleOriginY = 0;

// ─── Pieces ───────────────────────────────────────────────────────────────────
// { id, srcRow, srcCol, x, y, targetX, targetY, snapped, rotation, vx, vy }
let pieces = [];

// ─── Drag ─────────────────────────────────────────────────────────────────────
let drag = null;
// { piece, grabOffX, grabOffY, lastX, lastY, velX, velY, lastTime }

const SNAP_DIST = 40; // px – snap radius

// =============================================================================
//  INIT
// =============================================================================
function initGame(container, config) {
    gameConfig = config;
    container.innerHTML = '';

    gameCanvas = document.createElement('canvas');
    gameCanvas.style.cssText = 'width:100%;height:100%;touch-action:none;cursor:default;display:block;';
    container.appendChild(gameCanvas);
    ctx = gameCanvas.getContext('2d');

    resizeCanvas();
    window.addEventListener('resize', resizeCanvas);
    setupInput();

    const rawLevels = [
        { src: '../assets/images/games/farmers.jpg',    label: 'Hardworking Farmers',   emoji: '🧑‍🌾', color1: '#d35400', color2: '#e67e22' },
        { src: '../assets/images/games/Rice field.jpg', label: 'Rice Fields of Negros',  emoji: '🌾',   color1: '#2ecc71', color2: '#27ae60' },
    ];
    const seen = new Set();
    rawLevels.forEach(p => {
        if (!seen.has(p.src)) {
            seen.add(p.src);
            pickerImages.push({ ...p, img: null });
        }
    });
    pickerImages.forEach(pi => {
        const img = new Image();
        img.onload = () => { pi.img = img; };
        img.src = pi.src;
    });

    startLoop();
}

function resizeCanvas() {
    if (!gameCanvas.parentElement) return;
    const r = gameCanvas.parentElement.getBoundingClientRect();
    gameCanvas.width  = r.width;
    gameCanvas.height = r.height;
    if (gameState === 'playing') recalcLayout();
}

// =============================================================================
//  GAME LOOP
// =============================================================================
function startLoop() {
    if (rafId) cancelAnimationFrame(rafId);
    const loop = ts => { render(ts); rafId = requestAnimationFrame(loop); };
    rafId = requestAnimationFrame(loop);
}

// =============================================================================
//  PICKER SCREEN
// =============================================================================
function renderPicker(now) {
    const W = gameCanvas.width, H = gameCanvas.height;
    ctx.clearRect(0, 0, W, H);

    // Background
    const bg = ctx.createLinearGradient(0, 0, W, H);
    bg.addColorStop(0, '#0f2417');
    bg.addColorStop(1, '#0d1f12');
    ctx.fillStyle = bg;
    ctx.fillRect(0, 0, W, H);

    // Dot grid overlay
    ctx.fillStyle = 'rgba(255,255,255,0.035)';
    for (let x = 20; x < W; x += 40)
        for (let y = 20; y < H; y += 40) {
            ctx.beginPath(); ctx.arc(x, y, 1.3, 0, Math.PI * 2); ctx.fill();
        }

    // Title
    const titleY = Math.min(64, H * 0.12);
    ctx.textAlign = 'center';
    ctx.fillStyle = '#6BCB77';
    ctx.font = `bold ${Math.min(36, W * 0.07)}px Fredoka One,Nunito,sans-serif`;
    ctx.fillText('🌾 Farm Puzzle', W / 2, titleY);
    ctx.fillStyle = 'rgba(255,255,255,0.5)';
    ctx.font = `${Math.min(14, W * 0.033)}px Nunito,sans-serif`;
    ctx.fillText('Choose a picture — drag the scattered pieces back together!', W / 2, titleY + 26);

    // Cards
    const n = pickerImages.length;
    const cardW = Math.min(190, (W - 60) / n - 18);
    const cardH = cardW * 1.28;
    const gap   = Math.min(22, (W - n * cardW - 40) / (n + 1));
    const totalW = n * cardW + (n - 1) * gap;
    const cx0 = (W - totalW) / 2;
    const cy0 = H / 2 - cardH / 2 - 18;
    pickerCards = [];

    for (let i = 0; i < n; i++) {
        const pi  = pickerImages[i];
        const cx  = cx0 + i * (cardW + gap);
        const cy  = cy0;
        pickerCards.push({ x: cx, y: cy, w: cardW, h: cardH, index: i });

        const hov  = pickerHover === i;
        const sel  = pickerSelected === i;
        const lift = (hov || sel) ? -7 : 0;

        ctx.save();
        ctx.translate(cx + cardW / 2, cy + cardH / 2 + lift);
        ctx.scale(hov ? 1.04 : 1, hov ? 1.04 : 1);

        const rx = -cardW / 2, ry = -cardH / 2;

        if (sel) {
            ctx.shadowColor = 'rgba(107,203,119,0.6)'; ctx.shadowBlur = 26;
            ctx.strokeStyle = '#6BCB77'; ctx.lineWidth = 3;
            ctx.beginPath(); ctx.roundRect(rx - 2, ry - 2, cardW + 4, cardH + 4, 14); ctx.stroke();
            ctx.shadowBlur = 0;
        }

        const cg = ctx.createLinearGradient(rx, ry, rx + cardW, ry + cardH);
        cg.addColorStop(0, sel ? '#1e4028' : '#162a1c');
        cg.addColorStop(1, sel ? '#234d30' : '#1a3322');
        ctx.fillStyle = cg;
        ctx.beginPath(); ctx.roundRect(rx, ry, cardW, cardH, 12); ctx.fill();

        const imgH = cardH * 0.62;
        if (pi.img) {
            ctx.save();
            ctx.beginPath(); ctx.roundRect(rx + 6, ry + 6, cardW - 12, imgH, 8); ctx.clip();
            ctx.drawImage(pi.img, rx + 6, ry + 6, cardW - 12, imgH);
            ctx.restore();
        } else {
            const fg = ctx.createLinearGradient(rx + 6, ry + 6, rx + cardW - 6, ry + 6 + imgH);
            fg.addColorStop(0, pi.color1); fg.addColorStop(1, pi.color2);
            ctx.fillStyle = fg;
            ctx.beginPath(); ctx.roundRect(rx + 6, ry + 6, cardW - 12, imgH, 8); ctx.fill();
            ctx.font = `${cardW * 0.3}px serif`; ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
            ctx.fillStyle = 'rgba(255,255,255,0.9)';
            ctx.fillText(pi.emoji, 0, ry + 6 + imgH / 2);
            ctx.textBaseline = 'alphabetic';
        }

        ctx.fillStyle = sel ? '#6BCB77' : 'rgba(255,255,255,0.8)';
        ctx.font = `bold ${Math.max(11, cardW * 0.1)}px Nunito,sans-serif`;
        ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
        ctx.fillText(pi.label, 0, ry + imgH + (cardH - imgH) * 0.35);

        if (sel) {
            const by = ry + imgH + (cardH - imgH) * 0.72;
            ctx.fillStyle = '#6BCB77';
            ctx.beginPath(); ctx.roundRect(-30, by - 11, 60, 22, 11); ctx.fill();
            ctx.fillStyle = '#0f2417';
            ctx.font = `bold ${Math.max(9, cardW * 0.085)}px Nunito,sans-serif`;
            ctx.fillText('✓ PICKED', 0, by + 2);
        }
        ctx.restore();
    }

    // Difficulty pills
    const pillY = cy0 + cardH + 30;
    if (pillY + 40 < H - 80) {
        ctx.textAlign = 'center'; ctx.fillStyle = 'rgba(255,255,255,0.28)';
        ctx.font = `${Math.min(12, W * 0.027)}px Nunito,sans-serif`;
        ctx.fillText('5 levels of increasing difficulty', W / 2, pillY + 6);
        const pillColors = ['#6BCB77', '#FFD93D', '#FF9F1C', '#FF6B6B', '#cf6679'];
        ctx.font = `bold ${Math.min(11, W * 0.022)}px Nunito,sans-serif`;
        const labels = difficultyLevels.map(d => d.label);
        const widths = labels.map(l => ctx.measureText(l).width + 22);
        const totalPW = widths.reduce((a, b) => a + b, 0) + (labels.length - 1) * 6;
        let px = W / 2 - totalPW / 2;
        labels.forEach((lbl, i) => {
            ctx.fillStyle = 'rgba(255,255,255,0.07)';
            ctx.beginPath(); ctx.roundRect(px, pillY + 16, widths[i], 20, 10); ctx.fill();
            ctx.fillStyle = pillColors[i]; ctx.textAlign = 'left';
            ctx.fillText(lbl, px + 11, pillY + 30);
            px += widths[i] + 6;
        });
    }

    // Start button
    const btnW = Math.min(210, W * 0.48), btnH = 50;
    const btnY = H - 68;
    const pulse = 0.95 + Math.sin(now / 600) * 0.05;
    ctx.save();
    ctx.translate(W / 2, btnY + btnH / 2); ctx.scale(pulse, pulse);
    ctx.shadowColor = 'rgba(107,203,119,0.55)'; ctx.shadowBlur = 18;
    const btnGrad = ctx.createLinearGradient(-btnW / 2, 0, btnW / 2, 0);
    btnGrad.addColorStop(0, '#4CAF50'); btnGrad.addColorStop(1, '#2e7d32');
    ctx.fillStyle = btnGrad;
    ctx.beginPath(); ctx.roundRect(-btnW / 2, -btnH / 2, btnW, btnH, btnH / 2); ctx.fill();
    ctx.shadowBlur = 0; ctx.fillStyle = '#fff';
    ctx.font = `bold ${Math.min(19, btnW * 0.1)}px Fredoka One,Nunito,sans-serif`;
    ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
    ctx.fillText('🎮  Start Puzzle!', 0, 1);
    ctx.restore(); ctx.textBaseline = 'alphabetic';
}

// =============================================================================
//  LOAD LEVEL
// =============================================================================
function beginGameWithSelection() {
    const pi = pickerImages[pickerSelected];
    const descs = [
        `Great job! You assembled the ${pi.label} puzzle!`,
        `Well done! Medium difficulty cleared!`,
        `Impressive! Hard mode complete!`,
        `Expert level — you're amazing!`,
        `💀 INSANE complete! True legend!`,
    ];
    puzzleLevels = difficultyLevels.map((d, i) => ({
        imageSrc: pi.src,
        fallbackEmoji: pi.emoji,
        fallbackColor1: pi.color1,
        fallbackColor2: pi.color2,
        title: i === 0 ? pi.label : `${pi.label} – ${d.label.replace(/.*  /, '')}`,
        description: descs[i],
    }));
    currentLevelIndex = 0; score = 0; moves = 0; lives = MAX_LIVES;
    if (typeof playGameSound === 'function') playGameSound('click');
    loadLevel(0);
}

function loadLevel(index) {
    gameState = 'loading';
    elapsedTime = 0; startTime = null;
    drag = null; pieces = []; particles = [];
    solveFlashStart = null; useFallback = false;
    wrongDropFlash = null; heartShakeStart = null; lostHeartIndex = -1;
    screenFlashStart = null; lastLifeWarning = (lives === 1);

    const diff      = difficultyLevels[Math.min(index, difficultyLevels.length - 1)];
    const levelData = puzzleLevels[Math.min(index, puzzleLevels.length - 1)];
    gridSize = diff.gridSize;

    loadedImage = new Image();
    const timeout = setTimeout(() => { useFallback = true; loadedImage = null; startLevel(); }, 1500);
    loadedImage.onload  = () => { clearTimeout(timeout); startLevel(); };
    loadedImage.onerror = () => { clearTimeout(timeout); useFallback = true; loadedImage = null; startLevel(); };
    loadedImage.src = levelData.imageSrc;
}

function startLevel() {
    recalcLayout();
    scatterPieces();
    gameState = 'playing';
    startTime = performance.now();
}

function recalcLayout() {
    const W = gameCanvas.width, H = gameCanvas.height;
    // Target grid: ~52% of smallest dimension, vertically centred
    const gridPx = Math.floor(Math.min(W, H) * 0.52);
    tileSize     = Math.floor(gridPx / gridSize);
    const total  = tileSize * gridSize;
    puzzleOriginX = Math.round(W / 2 - total / 2);
    puzzleOriginY = Math.round(H / 2 - total / 2 + 28);
}

function scatterPieces() {
    const W = gameCanvas.width, H = gameCanvas.height;
    const ts = tileSize;
    const total = ts * gridSize;

    // Exclusion zone around the target grid
    const exL = puzzleOriginX - 12, exR = puzzleOriginX + total + 12;
    const exT = puzzleOriginY - 12, exB = puzzleOriginY + total + 12;

    pieces = [];
    for (let r = 0; r < gridSize; r++) {
        for (let c = 0; c < gridSize; c++) {
            let sx, sy, attempts = 0;
            do {
                sx = Math.random() * (W - ts - 30) + 15;
                sy = Math.random() * (H - ts - 30) + 15;
                attempts++;
            } while (attempts < 60 && (sx + ts > exL && sx < exR && sy + ts > exT && sy < exB));

            pieces.push({
                id: r * gridSize + c,
                srcRow: r, srcCol: c,
                x: sx, y: sy,
                targetX: puzzleOriginX + c * ts,
                targetY: puzzleOriginY + r * ts,
                snapped: false,
                rotation: (Math.random() - 0.5) * 30,
                vx: 0, vy: 0,
            });
        }
    }
    // Randomise draw order so pieces overlap randomly at start
    pieces.sort(() => Math.random() - 0.5);
}

// =============================================================================
//  INPUT
// =============================================================================
function setupInput() {
    gameCanvas.addEventListener('mousedown',  onDown);
    gameCanvas.addEventListener('mousemove',  onMove);
    gameCanvas.addEventListener('mouseup',    onUp);
    gameCanvas.addEventListener('mouseleave', onUp);
    gameCanvas.addEventListener('touchstart', e => { e.preventDefault(); onDown(e.touches[0]); }, { passive: false });
    gameCanvas.addEventListener('touchmove',  e => { e.preventDefault(); onMove(e.touches[0]); }, { passive: false });
    gameCanvas.addEventListener('touchend',   e => { e.preventDefault(); onUp(e.changedTouches[0]); }, { passive: false });

    document.addEventListener('keydown', e => {
        if (gameState === 'picker') {
            if (e.key === 'ArrowRight') pickerSelected = (pickerSelected + 1) % pickerImages.length;
            if (e.key === 'ArrowLeft')  pickerSelected = (pickerSelected - 1 + pickerImages.length) % pickerImages.length;
            if (e.key === 'Enter')      beginGameWithSelection();
        }
        if (gameState === 'solved'   && e.key === 'Enter') nextLevel();
        if (gameState === 'ended'    && e.key === 'Enter') restartGame();
        if (gameState === 'gameover' && e.key === 'Enter') restartGame();
    });
}

function canvasPos(e) {
    const r = gameCanvas.getBoundingClientRect();
    return {
        x: (e.clientX - r.left) * (gameCanvas.width  / r.width),
        y: (e.clientY - r.top)  * (gameCanvas.height / r.height),
    };
}

function onDown(e) {
    const p = canvasPos(e);
    if (gameState === 'picker')   { handlePickerClick(p); return; }
    if (gameState === 'solved')   { nextLevel(); return; }
    if (gameState === 'ended')    { restartGame(); return; }
    if (gameState === 'gameover') { restartGame(); return; }
    if (gameState !== 'playing') return;

    // Pick topmost non-snapped piece (last in array = drawn on top)
    for (let i = pieces.length - 1; i >= 0; i--) {
        const pc = pieces[i];
        if (pc.snapped) continue;
        if (p.x >= pc.x && p.x <= pc.x + tileSize && p.y >= pc.y && p.y <= pc.y + tileSize) {
            // Bring to top
            pieces.splice(i, 1);
            pieces.push(pc);
            drag = {
                piece: pc,
                grabOffX: p.x - pc.x,
                grabOffY: p.y - pc.y,
                lastX: p.x, lastY: p.y,
                velX: 0, velY: 0,
                lastTime: performance.now(),
            };
            pc.rotation = 0;
            gameCanvas.style.cursor = 'grabbing';
            return;
        }
    }
}

function onMove(e) {
    const p = canvasPos(e);
    if (gameState === 'picker') { handlePickerHover(p); return; }

    if (!drag) {
        if (gameState === 'playing') {
            let hit = false;
            for (let i = pieces.length - 1; i >= 0; i--) {
                const pc = pieces[i];
                if (!pc.snapped && p.x >= pc.x && p.x <= pc.x + tileSize && p.y >= pc.y && p.y <= pc.y + tileSize) { hit = true; break; }
            }
            gameCanvas.style.cursor = hit ? 'grab' : 'default';
        }
        return;
    }

    const now = performance.now();
    const dt  = now - drag.lastTime || 1;
    drag.velX = (p.x - drag.lastX) / dt;
    drag.velY = (p.y - drag.lastY) / dt;
    drag.lastX = p.x; drag.lastY = p.y; drag.lastTime = now;

    drag.piece.x = p.x - drag.grabOffX;
    drag.piece.y = p.y - drag.grabOffY;
}

function onUp() {
    if (!drag) return;
    const pc = drag.piece;

    const cx  = pc.x + tileSize / 2;
    const cy  = pc.y + tileSize / 2;
    const tcx = pc.targetX + tileSize / 2;
    const tcy = pc.targetY + tileSize / 2;

    if (Math.hypot(cx - tcx, cy - tcy) < SNAP_DIST) {
        // ── Correct slot ──────────────────────────────────────────────────────
        pc.x = pc.targetX; pc.y = pc.targetY;
        pc.snapped = true; pc.rotation = 0; pc.vx = 0; pc.vy = 0;
        moves++;
        spawnSnapParticles(pc.targetX + tileSize / 2, pc.targetY + tileSize / 2);
        if (typeof playGameSound === 'function') playGameSound('click');
        if (pieces.every(p => p.snapped)) handleSolved();
    } else {
        // ── Check if dropped near ANY wrong slot (inside grid area) ──────────
        const totalGrid = tileSize * gridSize;
        const inGridX = cx >= puzzleOriginX && cx <= puzzleOriginX + totalGrid;
        const inGridY = cy >= puzzleOriginY && cy <= puzzleOriginY + totalGrid;

        if (inGridX && inGridY) {
            // Player dropped inside the grid but on the wrong slot → lose a life
            loseLife(pc.x + tileSize / 2, pc.y + tileSize / 2);
        }

        // Bounce the piece back
        pc.vx = drag.velX * 3.5;
        pc.vy = drag.velY * 3.5;
        moves++;
    }

    drag = null;
    gameCanvas.style.cursor = 'default';
}

function loseLife(dropX, dropY) {
    if (lives <= 0) return;
    lostHeartIndex  = lives - 1;
    lives--;
    heartShakeStart  = performance.now();
    screenFlashStart = performance.now();
    wrongDropFlash   = { x: dropX, y: dropY, start: performance.now() };
    lastLifeWarning  = (lives === 1);
    if (typeof playGameSound === 'function') playGameSound('error');
    if (lives <= 0) {
        setTimeout(() => triggerGameOver(), 700);
    }
}

function triggerGameOver() {
    gameState = 'gameover';
    if (typeof playGameSound === 'function') playGameSound('gameover');
    if (typeof submitScore === 'function') {
        submitScore(score, { levels_completed: currentLevelIndex, total_moves: moves }).catch(() => {});
    }
}

function handlePickerClick(p) {
    for (const c of pickerCards) {
        if (p.x >= c.x && p.x <= c.x + c.w && p.y >= c.y && p.y <= c.y + c.h) { pickerSelected = c.index; return; }
    }
    const W = gameCanvas.width, H = gameCanvas.height;
    const btnW = Math.min(210, W * 0.48), btnH = 50, btnY = H - 68;
    if (p.x >= W / 2 - btnW / 2 && p.x <= W / 2 + btnW / 2 && p.y >= btnY && p.y <= btnY + btnH)
        beginGameWithSelection();
}

function handlePickerHover(p) {
    pickerHover = -1;
    for (const c of pickerCards) {
        if (p.x >= c.x && p.x <= c.x + c.w && p.y >= c.y && p.y <= c.y + c.h) { pickerHover = c.index; gameCanvas.style.cursor = 'pointer'; return; }
    }
    const W = gameCanvas.width, H = gameCanvas.height;
    const btnW = Math.min(210, W * 0.48), btnH = 50, btnY = H - 68;
    if (p.x >= W / 2 - btnW / 2 && p.x <= W / 2 + btnW / 2 && p.y >= btnY && p.y <= btnY + btnH) { gameCanvas.style.cursor = 'pointer'; return; }
    gameCanvas.style.cursor = 'default';
}

// =============================================================================
//  SOLVE / LEVEL FLOW
// =============================================================================
function handleSolved() {
    gameState = 'solved';
    solveFlashStart = performance.now();
    if (typeof playGameSound === 'function') playGameSound('success');
    const levelScore = Math.max(100, 1000 - moves * 3 - Math.floor(elapsedTime) * 2);
    score += levelScore;
    const el = document.getElementById('current-score');
    if (el) el.textContent = score;
    spawnConfetti();
}

function nextLevel() {
    currentLevelIndex++;
    // Restore one life as a reward (capped at MAX_LIVES)
    if (lives < MAX_LIVES) lives = Math.min(MAX_LIVES, lives + 1);
    if (typeof playGameSound === 'function') playGameSound('click');
    if (currentLevelIndex < difficultyLevels.length) loadLevel(currentLevelIndex);
    else endGame();
}

function endGame() {
    gameState = 'ended';
    if (typeof playGameSound === 'function') playGameSound('gameover');
    if (typeof submitScore === 'function') {
        submitScore(score, { levels_completed: currentLevelIndex, total_moves: moves }).catch(() => {});
    }
}

function restartGame() { location.reload(); }
window.restartGame = restartGame;

function spawnConfetti() {
    const W = gameCanvas.width, H = gameCanvas.height;
    const colors = ['#6BCB77', '#FFD93D', '#4D96FF', '#FF6B6B', '#ffffff', '#FF9F1C'];
    for (let i = 0; i < 100; i++) {
        particles.push({
            x: W / 2 + (Math.random() - 0.5) * 350,
            y: H / 2 + (Math.random() - 0.5) * 250,
            vx: (Math.random() - 0.5) * 7,
            vy: -Math.random() * 9 - 2,
            rot: Math.random() * 360,
            rotV: (Math.random() - 0.5) * 14,
            w: 9 + Math.random() * 9,
            h: 5 + Math.random() * 5,
            color: colors[Math.floor(Math.random() * colors.length)],
            life: 1,
            decay: 0.007 + Math.random() * 0.011,
        });
    }
}

// Small green star burst when a piece snaps in correctly
function spawnSnapParticles(cx, cy) {
    const colors = ['#6BCB77', '#ffffff', '#FFD93D'];
    for (let i = 0; i < 14; i++) {
        const angle = (i / 14) * Math.PI * 2;
        const speed = 1.5 + Math.random() * 2.5;
        particles.push({
            x: cx, y: cy,
            vx: Math.cos(angle) * speed, vy: Math.sin(angle) * speed,
            rot: 0, rotV: 0,
            w: 4 + Math.random() * 4, h: 4 + Math.random() * 4,
            color: colors[Math.floor(Math.random() * colors.length)],
            life: 1, decay: 0.04 + Math.random() * 0.03,
        });
    }
}

// =============================================================================
//  RENDER
// =============================================================================
function render(ts) {
    const now = ts || performance.now();
    const W = gameCanvas.width, H = gameCanvas.height;

    if (gameState === 'picker') { renderPicker(now); return; }
    if (gameState === 'loading') { drawLoading(W, H); return; }

    if (gameState === 'playing' && startTime) elapsedTime = (now - startTime) / 1000;

    // Physics
    if (gameState === 'playing') {
        for (const pc of pieces) {
            if (pc.snapped || (drag && drag.piece === pc)) continue;
            pc.x += pc.vx; pc.y += pc.vy;
            pc.vx *= 0.87; pc.vy *= 0.87;
            if (pc.x < 0)          { pc.x = 0;          pc.vx =  Math.abs(pc.vx) * 0.5; }
            if (pc.x > W - tileSize) { pc.x = W - tileSize; pc.vx = -Math.abs(pc.vx) * 0.5; }
            if (pc.y < 0)          { pc.y = 0;          pc.vy =  Math.abs(pc.vy) * 0.5; }
            if (pc.y > H - tileSize) { pc.y = H - tileSize; pc.vy = -Math.abs(pc.vy) * 0.5; }
        }
    }

    // Confetti physics
    for (const p of particles) {
        p.x += p.vx; p.y += p.vy; p.vy += 0.18;
        p.rot += p.rotV; p.life -= p.decay;
    }
    particles = particles.filter(p => p.life > 0);

    // ── Background ─────────────────────────────────────────────────────────────
    const bg = ctx.createLinearGradient(0, 0, 0, H);
    bg.addColorStop(0, '#1a2e0f'); bg.addColorStop(1, '#0e1a08');
    ctx.fillStyle = bg; ctx.fillRect(0, 0, W, H);

    ctx.fillStyle = 'rgba(255,255,255,0.04)';
    for (let x = 22; x < W; x += 38)
        for (let y = 22; y < H; y += 38) {
            ctx.beginPath(); ctx.arc(x, y, 1.2, 0, Math.PI * 2); ctx.fill();
        }

    const levelData = puzzleLevels[Math.min(currentLevelIndex, puzzleLevels.length - 1)];
    const diff      = difficultyLevels[Math.min(currentLevelIndex, difficultyLevels.length - 1)];
    const totalGrid = tileSize * gridSize;

    // ── Target grid ghost ──────────────────────────────────────────────────────
    drawTargetGrid(levelData, totalGrid);

    // ── Pieces (snapped first, then free, then dragged on top) ─────────────────
    for (const pc of pieces) {
        if (!pc.snapped) continue;
        drawPiece(pc, levelData, false);
    }
    for (const pc of pieces) {
        if (pc.snapped) continue;
        if (drag && drag.piece === pc) continue;
        drawPiece(pc, levelData, false);
    }
    if (drag) drawPiece(drag.piece, levelData, true);

    // ── Confetti ──────────────────────────────────────────────────────────────
    for (const p of particles) {
        ctx.save();
        ctx.globalAlpha = p.life;
        ctx.translate(p.x, p.y);
        ctx.rotate(p.rot * Math.PI / 180);
        ctx.fillStyle = p.color;
        ctx.fillRect(-p.w / 2, -p.h / 2, p.w, p.h);
        ctx.restore();
    }

    // ── Screen flash on life lost ─────────────────────────────────────────────
    if (screenFlashStart !== null) {
        const age = now - screenFlashStart;
        if (age < 400) {
            const alpha = (1 - age / 400) * 0.45;
            ctx.fillStyle = `rgba(220,0,0,${alpha})`;
            ctx.fillRect(0, 0, W, H);
        } else {
            screenFlashStart = null;
        }
    }

    // ── HUD ───────────────────────────────────────────────────────────────────
    drawHUD(W, H, diff, levelData, now);

    // ── Last-life warning banner ──────────────────────────────────────────────
    if (lastLifeWarning && lives === 1 && gameState === 'playing') {
        drawLastLifeBanner(W, H, now);
    }

    // ── Progress bar ──────────────────────────────────────────────────────────
    const snapped = pieces.filter(p => p.snapped).length;
    drawProgressBar(W, H, snapped, pieces.length);

    // ── Wrong-drop flash ──────────────────────────────────────────────────────
    if (wrongDropFlash) {
        const age = now - wrongDropFlash.start;
        if (age < 500) {
            const alpha = (1 - age / 500) * 0.75;
            const radius = 20 + age * 0.12;
            ctx.save();
            ctx.strokeStyle = `rgba(255,60,60,${alpha})`;
            ctx.lineWidth = 4;
            ctx.beginPath();
            ctx.arc(wrongDropFlash.x, wrongDropFlash.y, radius, 0, Math.PI * 2);
            ctx.stroke();
            // ✗ symbol
            ctx.fillStyle = `rgba(255,60,60,${alpha})`;
            ctx.font = `bold ${Math.round(24 * (1 - age/500) + 10)}px sans-serif`;
            ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
            ctx.fillText('✕', wrongDropFlash.x, wrongDropFlash.y - radius - 12);
            ctx.restore();
        } else {
            wrongDropFlash = null;
        }
    }

    // ── Overlays ──────────────────────────────────────────────────────────────
    if (gameState === 'solved')   drawSolvedOverlay(W, H, levelData, now);
    if (gameState === 'ended')    drawEndOverlay(W, H);
    if (gameState === 'gameover') drawGameOverOverlay(W, H, now);
}

// ─── Target grid ghost slots ──────────────────────────────────────────────────
function drawTargetGrid(levelData, totalGrid) {
    const ts = tileSize;

    // Faint full image watermark
    if (!useFallback && loadedImage) {
        ctx.globalAlpha = 0.1;
        ctx.drawImage(loadedImage, puzzleOriginX, puzzleOriginY, totalGrid, totalGrid);
        ctx.globalAlpha = 1;
    }

    // Outer frame
    ctx.strokeStyle = 'rgba(255,255,255,0.12)';
    ctx.lineWidth = 2;
    ctx.strokeRect(puzzleOriginX - 1, puzzleOriginY - 1, totalGrid + 2, totalGrid + 2);

    for (let r = 0; r < gridSize; r++) {
        for (let c = 0; c < gridSize; c++) {
            const x = puzzleOriginX + c * ts;
            const y = puzzleOriginY + r * ts;
            const snappedHere = pieces.some(pc => pc.snapped && pc.srcRow === r && pc.srcCol === c);
            if (!snappedHere) {
                ctx.strokeStyle = 'rgba(255,255,255,0.15)';
                ctx.lineWidth = 1;
                ctx.setLineDash([5, 5]);
                ctx.beginPath(); ctx.roundRect(x + 2, y + 2, ts - 4, ts - 4, 4); ctx.stroke();
                ctx.setLineDash([]);

                // Piece number hint
                ctx.fillStyle = 'rgba(255,255,255,0.08)';
                ctx.font = `bold ${ts * 0.26}px Nunito,sans-serif`;
                ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
                ctx.fillText((r * gridSize + c + 1).toString(), x + ts / 2, y + ts / 2);
                ctx.textBaseline = 'alphabetic';
            }
        }
    }
}

// ─── Draw a single puzzle piece ───────────────────────────────────────────────
function drawPiece(pc, levelData, isLifted) {
    const ts = tileSize;
    ctx.save();

    const cx = pc.x + ts / 2;
    const cy = pc.y + ts / 2;
    ctx.translate(cx, cy);

    const rot = pc.snapped ? 0 : pc.rotation * Math.PI / 180;
    ctx.rotate(rot);
    if (isLifted) ctx.scale(1.08, 1.08);

    if (isLifted) {
        ctx.shadowColor = 'rgba(0,0,0,0.65)'; ctx.shadowBlur = 30;
        ctx.shadowOffsetX = 6; ctx.shadowOffsetY = 10;
    } else if (!pc.snapped) {
        ctx.shadowColor = 'rgba(0,0,0,0.4)'; ctx.shadowBlur = 12;
        ctx.shadowOffsetX = 2; ctx.shadowOffsetY = 4;
    }

    const rx = -ts / 2, ry = -ts / 2;
    const radius = pc.snapped ? 2 : (isLifted ? 10 : 7);

    if (!useFallback && loadedImage) {
        const srcW = loadedImage.width  / gridSize;
        const srcH = loadedImage.height / gridSize;

        ctx.save();
        ctx.beginPath(); ctx.roundRect(rx, ry, ts, ts, radius); ctx.clip();
        ctx.drawImage(loadedImage, pc.srcCol * srcW, pc.srcRow * srcH, srcW, srcH, rx, ry, ts, ts);
        ctx.restore();

        // Border
        ctx.lineWidth = pc.snapped ? 2 : (isLifted ? 3 : 1.5);
        ctx.strokeStyle = pc.snapped ? 'rgba(107,203,119,0.7)'
                        : isLifted   ? 'rgba(255,255,150,0.95)'
                        :              'rgba(255,255,255,0.35)';
        ctx.beginPath(); ctx.roundRect(rx, ry, ts, ts, radius); ctx.stroke();

    } else {
        const g = ctx.createLinearGradient(rx, ry, rx + ts, ry + ts);
        if (pc.snapped)   { g.addColorStop(0, '#6BCB77'); g.addColorStop(1, '#4CAF50'); }
        else if (isLifted){ g.addColorStop(0, '#fff176'); g.addColorStop(1, '#ffd54f'); }
        else              { g.addColorStop(0, levelData.fallbackColor1); g.addColorStop(1, levelData.fallbackColor2); }
        ctx.fillStyle = g;
        ctx.beginPath(); ctx.roundRect(rx, ry, ts, ts, radius); ctx.fill();

        ctx.fillStyle = 'rgba(255,255,255,0.9)';
        ctx.font = `bold ${ts * 0.34}px Fredoka One,sans-serif`;
        ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
        ctx.fillText((pc.srcRow * gridSize + pc.srcCol + 1).toString(), 0, 0);
        ctx.textBaseline = 'alphabetic';
    }

    ctx.restore();
}

// ─── HUD ──────────────────────────────────────────────────────────────────────
function drawHUD(W, H, diff, levelData, now) {
    // Title
    ctx.textAlign = 'center';
    ctx.fillStyle = 'rgba(0,0,0,0.5)';
    ctx.beginPath(); ctx.roundRect(W / 2 - 145, 6, 290, 38, 10); ctx.fill();
    ctx.fillStyle = '#fff';
    ctx.font = `bold ${Math.min(19, W * 0.038)}px Nunito,sans-serif`;
    ctx.fillText(levelData.title, W / 2, 31);

    // Thumbnail
    if (!useFallback && loadedImage) {
        const ts = 110, tx = 12, ty = 12;
        ctx.shadowColor = 'rgba(0,0,0,0.4)'; ctx.shadowBlur = 10; ctx.shadowOffsetY = 3;
        ctx.fillStyle = '#fff';
        ctx.beginPath(); ctx.roundRect(tx - 3, ty - 3, ts + 6, ts + 6, 8); ctx.fill();
        ctx.shadowBlur = 0; ctx.shadowOffsetY = 0;
        ctx.save(); ctx.beginPath(); ctx.roundRect(tx, ty, ts, ts, 6); ctx.clip();
        ctx.drawImage(loadedImage, tx, ty, ts, ts); ctx.restore();
        ctx.fillStyle = '#ccc'; ctx.font = 'bold 12px Nunito,sans-serif';
        ctx.textAlign = 'center'; ctx.fillText('TARGET', tx + ts / 2, ty + ts + 16);
    }

    // Difficulty badge
    ctx.fillStyle = 'rgba(0,0,0,0.55)';
    ctx.beginPath(); ctx.roundRect(12, 138, 180, 34, 10); ctx.fill();
    ctx.fillStyle = '#FFD93D'; ctx.font = 'bold 17px Nunito,sans-serif';
    ctx.textAlign = 'left'; ctx.fillText(diff.label, 20, 161);

    // ── Hearts (lives) – top right, above timer ─────────────────────────────
    drawHearts(W, now);

    // Timer
    const secs = Math.floor(elapsedTime), ms = Math.floor((elapsedTime % 1) * 100);
    const min = Math.floor(secs / 60), sec = secs % 60;
    const tStr = `${min}:${sec.toString().padStart(2, '0')}.${ms.toString().padStart(2, '0')}`;
    const alert = secs >= 120, pulse = alert ? (Math.sin(now / 250) * 0.3 + 0.7) : 1;
    ctx.fillStyle = alert ? `rgba(${Math.floor(180 * pulse)},0,0,0.6)` : 'rgba(0,0,0,0.4)';
    ctx.beginPath(); ctx.roundRect(W - 158, 62, 150, 44, 10); ctx.fill();
    ctx.fillStyle = alert ? '#ff6b6b' : '#FFD93D';
    ctx.font = 'bold 21px monospace'; ctx.textAlign = 'right';
    ctx.fillText(`⏱ ${tStr}`, W - 14, 88);
    ctx.fillStyle = '#fff'; ctx.font = 'bold 15px Nunito,sans-serif';
    ctx.fillText(`Moves: ${moves}`, W - 14, 108);
}

// ─── Hearts row ───────────────────────────────────────────────────────────────
function drawHearts(W, now) {
    const heartSize = 32;
    const spacing   = 42;
    const totalW    = MAX_LIVES * spacing - (spacing - heartSize);
    const startX    = W - 14 - totalW;
    const heartY    = 14;
    const isLastLife = lives === 1;
    const shakeAge   = heartShakeStart ? now - heartShakeStart : 9999;

    // Pill background — red tint when on last life
    const pillAlpha = isLastLife ? (0.55 + Math.sin(now / 300) * 0.2) : 0.45;
    const pillColor = isLastLife ? `rgba(140,0,0,${pillAlpha})` : `rgba(0,0,0,${pillAlpha})`;
    ctx.fillStyle = pillColor;
    ctx.beginPath();
    ctx.roundRect(startX - 12, heartY - 8, totalW + 24, heartSize + 22, heartSize / 2 + 6);
    ctx.fill();

    // Red border glow on last life
    if (isLastLife) {
        const borderAlpha = 0.4 + Math.sin(now / 300) * 0.35;
        ctx.strokeStyle = `rgba(255,60,60,${borderAlpha})`;
        ctx.lineWidth = 2.5;
        ctx.beginPath();
        ctx.roundRect(startX - 12, heartY - 8, totalW + 24, heartSize + 22, heartSize / 2 + 6);
        ctx.stroke();
    }

    for (let i = 0; i < MAX_LIVES; i++) {
        const hx = startX + i * spacing + heartSize / 2;
        const hy = heartY + heartSize / 2 + 4;
        const isLost    = i >= lives;
        const isNewest  = i === lostHeartIndex; // the heart just broken
        const isShaking = isNewest && shakeAge < 700;
        const isOnlyHeart = (i === 0 && lives === 1); // last surviving heart

        ctx.save();
        ctx.translate(hx, hy);

        // ── Shake animation on the just-broken heart ────────────────────────
        if (isShaking) {
            const decay = 1 - shakeAge / 700;
            const sx = Math.sin(shakeAge * 0.07) * 8 * decay;
            const sy = Math.cos(shakeAge * 0.09) * 5 * decay;
            const sc = 1 + Math.sin(shakeAge * 0.04) * 0.3 * decay;
            ctx.translate(sx, sy);
            ctx.scale(sc, sc);
            // Red glow burst on shake
            ctx.shadowColor = `rgba(255,0,0,${0.8 * (1 - shakeAge/700)})`;
            ctx.shadowBlur = 20;
        }

        // ── Last surviving heart: big urgent pulse ────────────────────────
        if (isOnlyHeart) {
            const urgentScale = 1 + Math.sin(now / 200) * 0.18; // fast big pulse
            ctx.scale(urgentScale, urgentScale);
            const urgentGlow = 0.5 + Math.sin(now / 200) * 0.4;
            ctx.shadowColor = `rgba(255,30,30,${urgentGlow})`;
            ctx.shadowBlur = 22;
        } else if (!isLost) {
            // Normal hearts: gentle pulse
            const normalScale = 1 + Math.sin(now / 800 + i) * 0.06;
            ctx.scale(normalScale, normalScale);
            ctx.shadowColor = `rgba(255,60,80,0.5)`;
            ctx.shadowBlur = 8;
        }

        ctx.font = `${heartSize}px serif`;
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';

        if (isLost) {
            ctx.globalAlpha = 0.2;
            ctx.fillText('🖤', 0, 0);
        } else {
            ctx.globalAlpha = 1;
            ctx.fillText('❤️', 0, 0);
        }

        ctx.globalAlpha = 1;
        ctx.shadowBlur = 0;
        ctx.restore();
    }

    // Label — "LAST LIFE!" in red when critical, normal otherwise
    ctx.textAlign = 'center';
    if (isLastLife) {
        const labelAlpha = 0.7 + Math.sin(now / 300) * 0.3;
        ctx.fillStyle = `rgba(255,80,80,${labelAlpha})`;
        ctx.font = 'bold 11px Nunito,sans-serif';
        ctx.fillText('⚠ LAST LIFE!', startX + totalW / 2, heartY + heartSize + 18);
    } else {
        ctx.fillStyle = 'rgba(255,255,255,0.4)';
        ctx.font = 'bold 10px Nunito,sans-serif';
        ctx.fillText('LIVES', startX + totalW / 2, heartY + heartSize + 18);
    }
}

// ─── Last-life warning banner (appears briefly after losing 2nd life) ─────────
function drawLastLifeBanner(W, H, now) {
    // Only show for first 3 seconds after entering last life
    if (!heartShakeStart) return;
    const age = now - heartShakeStart;
    if (age > 3000) { lastLifeWarning = false; return; }

    const fadeIn  = Math.min(1, age / 150);
    const fadeOut = age > 2400 ? Math.max(0, 1 - (age - 2400) / 600) : 1;
    const alpha   = fadeIn * fadeOut;

    const bannerH = 54;
    const bannerY = H / 2 - bannerH / 2;

    ctx.save();
    ctx.globalAlpha = alpha;

    // Background bar
    const bgGrad = ctx.createLinearGradient(0, bannerY, W, bannerY);
    bgGrad.addColorStop(0,   'rgba(0,0,0,0)');
    bgGrad.addColorStop(0.15,'rgba(160,0,0,0.88)');
    bgGrad.addColorStop(0.85,'rgba(160,0,0,0.88)');
    bgGrad.addColorStop(1,   'rgba(0,0,0,0)');
    ctx.fillStyle = bgGrad;
    ctx.fillRect(0, bannerY, W, bannerH);

    // Red border lines
    ctx.strokeStyle = 'rgba(255,80,80,0.7)';
    ctx.lineWidth = 2;
    ctx.beginPath(); ctx.moveTo(0, bannerY); ctx.lineTo(W, bannerY); ctx.stroke();
    ctx.beginPath(); ctx.moveTo(0, bannerY + bannerH); ctx.lineTo(W, bannerY + bannerH); ctx.stroke();

    // Text
    ctx.fillStyle = '#ffffff';
    ctx.font = `bold ${Math.min(26, W * 0.055)}px Fredoka One,Nunito,sans-serif`;
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText('⚠️  LAST LIFE — Be Careful!  ⚠️', W / 2, bannerY + bannerH / 2);

    ctx.restore();
    ctx.textBaseline = 'alphabetic';
}

// ─── Progress bar ─────────────────────────────────────────────────────────────
function drawProgressBar(W, H, snapped, total) {
    const bw = 210, bh = 14, bx = W / 2 - bw / 2, by = H - 26;
    ctx.fillStyle = 'rgba(0,0,0,0.4)';
    ctx.beginPath(); ctx.roundRect(bx, by, bw, bh, bh / 2); ctx.fill();

    const pct = total > 0 ? snapped / total : 0;
    if (pct > 0) {
        const fg = ctx.createLinearGradient(bx, 0, bx + bw, 0);
        fg.addColorStop(0, '#6BCB77'); fg.addColorStop(1, '#FFD93D');
        ctx.fillStyle = fg;
        ctx.beginPath(); ctx.roundRect(bx, by, bw * pct, bh, bh / 2); ctx.fill();
    }

    ctx.fillStyle = 'rgba(255,255,255,0.72)'; ctx.font = 'bold 11px Nunito,sans-serif';
    ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
    ctx.fillText(`${snapped} / ${total} pieces placed`, W / 2, by + bh / 2 + 1);
    ctx.textBaseline = 'alphabetic';
}

// ─── Solved overlay ────────────────────────────────────────────────────────────
function drawSolvedOverlay(W, H, levelData, now) {
    ctx.fillStyle = 'rgba(0,0,0,0.83)'; ctx.fillRect(0, 0, W, H);

    ctx.fillStyle = '#6BCB77';
    ctx.font = `bold ${Math.min(40, W * 0.09)}px Fredoka One,Nunito,sans-serif`;
    ctx.textAlign = 'center';
    ctx.fillText('✅ PUZZLE SOLVED!', W / 2, H / 2 - 100);

    ctx.fillStyle = '#FFD93D'; ctx.font = 'bold 24px Nunito,sans-serif';
    ctx.fillText(levelData.title, W / 2, H / 2 - 62);

    const s = Math.floor(elapsedTime), m = Math.floor(s / 60);
    ctx.fillStyle = '#a0e0ff'; ctx.font = 'bold 19px Nunito,sans-serif';
    ctx.fillText(`⏱ ${m}:${(s % 60).toString().padStart(2,'0')}  •  📦 ${moves} moves`, W / 2, H / 2 - 24);

    ctx.fillStyle = '#fff'; ctx.font = '18px Nunito,sans-serif';
    wrapText(ctx, levelData.description, W / 2, H / 2 + 16, W - 60, 26);

    const isLast = currentLevelIndex >= difficultyLevels.length - 1;
    const pulse  = 0.94 + Math.sin(now / 600) * 0.06;
    const btnW = Math.min(240, W * 0.5), btnH = 52;

    ctx.save();
    ctx.translate(W / 2, H / 2 + 88); ctx.scale(pulse, pulse);
    ctx.shadowColor = 'rgba(77,150,255,0.5)'; ctx.shadowBlur = 18;
    const grad = ctx.createLinearGradient(-btnW / 2, 0, btnW / 2, 0);
    grad.addColorStop(0, '#4D96FF'); grad.addColorStop(1, '#1565C0');
    ctx.fillStyle = grad;
    ctx.beginPath(); ctx.roundRect(-btnW / 2, -btnH / 2, btnW, btnH, btnH / 2); ctx.fill();
    ctx.shadowBlur = 0; ctx.fillStyle = '#fff';
    ctx.font = 'bold 20px Fredoka One,Nunito,sans-serif';
    ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
    ctx.fillText(isLast ? '🏆 Finish' : 'Next Level →', 0, 1);
    ctx.restore(); ctx.textBaseline = 'alphabetic';
}

// ─── Game Over overlay ────────────────────────────────────────────────────────
function drawGameOverOverlay(W, H, now) {
    // Dark red vignette
    ctx.fillStyle = 'rgba(0,0,0,0.88)'; ctx.fillRect(0, 0, W, H);

    // Red glow pulse
    const pulse = 0.3 + Math.sin(now / 500) * 0.12;
    const radial = ctx.createRadialGradient(W/2, H/2, 40, W/2, H/2, Math.max(W, H) * 0.6);
    radial.addColorStop(0, `rgba(180,0,0,${pulse})`);
    radial.addColorStop(1, 'rgba(0,0,0,0)');
    ctx.fillStyle = radial; ctx.fillRect(0, 0, W, H);

    // Broken heart
    ctx.font = `${Math.min(72, W * 0.14)}px serif`;
    ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
    ctx.fillText('💔', W / 2, H / 2 - 110);
    ctx.textBaseline = 'alphabetic';

    ctx.fillStyle = '#ff4444';
    ctx.font = `bold ${Math.min(44, W * 0.09)}px Fredoka One,Nunito,sans-serif`;
    ctx.textAlign = 'center';
    ctx.fillText('GAME OVER', W / 2, H / 2 - 38);

    ctx.fillStyle = 'rgba(255,255,255,0.6)';
    ctx.font = '18px Nunito,sans-serif';
    ctx.fillText('You ran out of lives!', W / 2, H / 2 + 4);

    ctx.fillStyle = '#FFD93D';
    ctx.font = 'bold 26px Nunito,sans-serif';
    ctx.fillText(`Score: ${score}`, W / 2, H / 2 + 46);

    ctx.fillStyle = 'rgba(255,255,255,0.45)';
    ctx.font = '16px Nunito,sans-serif';
    ctx.fillText(`Level ${currentLevelIndex + 1}  •  ${moves} moves`, W / 2, H / 2 + 76);

    // Retry button
    const btnW = Math.min(220, W * 0.48), btnH = 50;
    const btnPulse = 0.94 + Math.sin(now / 600) * 0.06;
    ctx.save();
    ctx.translate(W / 2, H / 2 + 120); ctx.scale(btnPulse, btnPulse);
    ctx.shadowColor = 'rgba(255,80,80,0.5)'; ctx.shadowBlur = 18;
    const grad = ctx.createLinearGradient(-btnW/2, 0, btnW/2, 0);
    grad.addColorStop(0, '#c0392b'); grad.addColorStop(1, '#8e1010');
    ctx.fillStyle = grad;
    ctx.beginPath(); ctx.roundRect(-btnW/2, -btnH/2, btnW, btnH, btnH/2); ctx.fill();
    ctx.shadowBlur = 0; ctx.fillStyle = '#fff';
    ctx.font = 'bold 20px Fredoka One,Nunito,sans-serif';
    ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
    ctx.fillText('🔄  Try Again', 0, 1);
    ctx.restore(); ctx.textBaseline = 'alphabetic';
}

// ─── End overlay ──────────────────────────────────────────────────────────────
function drawEndOverlay(W, H) {
    ctx.fillStyle = 'rgba(0,0,0,0.92)'; ctx.fillRect(0, 0, W, H);
    ctx.fillStyle = '#fff';
    ctx.font = `bold ${Math.min(44, W * 0.09)}px Fredoka One,sans-serif`;
    ctx.textAlign = 'center';
    ctx.fillText('🏆 ALL LEVELS DONE!', W / 2, H / 2 - 80);
    ctx.fillStyle = '#FFD93D'; ctx.font = 'bold 32px Nunito,sans-serif';
    ctx.fillText(`Final Score: ${score}`, W / 2, H / 2 - 20);
    ctx.fillStyle = '#4D96FF'; ctx.font = 'bold 22px Nunito,sans-serif';
    ctx.fillText('Click or ENTER to Play Again', W / 2, H / 2 + 60);
}

function drawLoading(W, H) {
    const bg = ctx.createLinearGradient(0, 0, 0, H);
    bg.addColorStop(0, '#1a2e0f'); bg.addColorStop(1, '#0e1a08');
    ctx.fillStyle = bg; ctx.fillRect(0, 0, W, H);
    ctx.fillStyle = '#fff'; ctx.font = '24px Nunito,sans-serif';
    ctx.textAlign = 'center'; ctx.fillText('Loading…', W / 2, H / 2);
}

// =============================================================================
//  UTILITIES
// =============================================================================
function wrapText(context, text, x, y, maxWidth, lineHeight) {
    const words = text.split(' '); let line = '';
    for (let n = 0; n < words.length; n++) {
        const test = line + words[n] + ' ';
        if (context.measureText(test).width > maxWidth && n > 0) { context.fillText(line, x, y); line = words[n] + ' '; y += lineHeight; }
        else line = test;
    }
    context.fillText(line, x, y);
}