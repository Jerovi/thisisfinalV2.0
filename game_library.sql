-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 23, 2026 at 09:43 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `game_library`
--

-- --------------------------------------------------------

--
-- Table structure for table `achievements`
--

CREATE TABLE `achievements` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `badge_image` varchar(255) DEFAULT 'default-badge.png',
  `criteria_type` enum('total_score','games_played','points_earned','streak','specific_game','custom') NOT NULL,
  `criteria_value` int(10) UNSIGNED NOT NULL,
  `criteria_game_id` int(10) UNSIGNED DEFAULT NULL,
  `points_bonus` int(10) UNSIGNED DEFAULT 0,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `achievements`
--

INSERT INTO `achievements` (`id`, `name`, `description`, `badge_image`, `criteria_type`, `criteria_value`, `criteria_game_id`, `points_bonus`, `status`, `created_at`, `updated_at`) VALUES
(1, 'First Steps', 'Play your first game! Everyone starts somewhere.', 'ach-first-game.png', 'games_played', 1, NULL, 10, 'active', '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(2, 'Getting Started', 'Play 10 games total. You\'re getting the hang of this!', 'ach-10-games.png', 'games_played', 10, NULL, 25, 'active', '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(3, 'Dedicated Player', 'Play 50 games total. Gaming is in your blood!', 'ach-50-games.png', 'games_played', 50, NULL, 100, 'active', '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(4, 'Gaming Legend', 'Play 100 games total. You\'re a true gaming legend!', 'ach-100-games.png', 'games_played', 100, NULL, 250, 'active', '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(5, 'Point Collector', 'Earn 500 total points. Building your fortune!', 'ach-500-points.png', 'points_earned', 500, NULL, 50, 'active', '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(6, 'Point Master', 'Earn 2,000 total points. You\'re rich in points!', 'ach-2000-points.png', 'points_earned', 2000, NULL, 100, 'active', '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(7, 'Point Tycoon', 'Earn 10,000 total points. A true points mogul!', 'ach-10000-points.png', 'points_earned', 10000, NULL, 500, 'active', '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(8, 'High Scorer', 'Get a score of 1,000 or more in any single game.', 'ach-high-score.png', 'total_score', 1000, NULL, 75, 'active', '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(9, 'Score Champion', 'Get a score of 2,500 or more in any single game.', 'ach-score-champion.png', 'total_score', 2500, NULL, 150, 'active', '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(10, 'Score Legend', 'Get a score of 5,000 or more in any single game. Incredible!', 'ach-score-legend.png', 'total_score', 5000, NULL, 300, 'active', '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(11, 'Fruit Frenzy', 'Score 2,000+ in Fruit Catch. Fruit catching master!', 'ach-fruit-frenzy.png', 'specific_game', 2000, 1, 100, 'active', '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(12, 'Word Wizard', 'Score 800+ in Word Scramble. Your vocabulary is impressive!', 'ach-word-wizard.png', 'specific_game', 800, 2, 100, 'active', '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(13, 'Quiz Genius', 'Score 900+ in Quiz Master (90%+ accuracy). Brilliant!', 'ach-quiz-genius.png', 'specific_game', 900, 3, 125, 'active', '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(14, 'Puzzle Prodigy', 'Score 5,000+ in Sliding Puzzle (fast completion). Amazing!', 'ach-puzzle-prodigy.png', 'specific_game', 5000, 4, 150, 'active', '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(15, 'Memory Master', 'Score 2,000+ in Memory Match. Perfect recall!', 'ach-memory-master.png', 'specific_game', 2000, 5, 100, 'active', '2026-02-02 19:56:33', '2026-02-02 19:56:33');

-- --------------------------------------------------------

--
-- Table structure for table `activity_log`
--

CREATE TABLE `activity_log` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  `extra_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`extra_data`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `activity_log`
--

INSERT INTO `activity_log` (`id`, `user_id`, `action`, `description`, `ip_address`, `user_agent`, `extra_data`, `created_at`) VALUES
(1, 1, 'login', 'Admin logged in', '127.0.0.1', NULL, NULL, '2026-02-02 18:56:33'),
(2, 2, 'login', 'User logged in', '192.168.1.100', NULL, NULL, '2026-02-02 17:56:33'),
(3, 2, 'game_played', 'Played Fruit Catch - Score: 850', '192.168.1.100', NULL, NULL, '2026-02-02 17:56:33'),
(4, 3, 'login', 'User logged in', '192.168.1.101', NULL, NULL, '2026-02-02 14:56:33'),
(5, 4, 'register', 'New user registered', '192.168.1.102', NULL, NULL, '2026-01-03 19:56:33'),
(6, 4, 'login', 'User logged in', '192.168.1.102', NULL, NULL, '2026-02-02 16:56:33'),
(7, 4, 'redemption', 'Redeemed: Premium Avatar Pack', '192.168.1.102', NULL, NULL, '2026-01-23 19:56:33'),
(8, 6, 'register', 'New user registered', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-03 16:35:37'),
(9, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-03 16:35:53'),
(10, 6, 'redemption_created', 'User #6 redeemed reward #8', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-03 17:04:21'),
(11, 6, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-03 17:07:13'),
(12, 7, 'register', 'New user registered', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-03 17:12:18'),
(13, 7, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-03 17:13:25'),
(14, 7, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-03 17:21:46'),
(15, 7, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-03 17:22:00'),
(16, 7, 'redemption_fulfilled', 'Fulfilled redemption #4 for hero', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-03 17:27:27'),
(17, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-03 19:02:52'),
(18, 6, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-03 19:05:24'),
(19, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-03 19:05:46'),
(20, 6, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-03 19:07:01'),
(21, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-03 19:07:26'),
(22, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 03:17:34'),
(23, 6, 'redemption_created', 'User #6 redeemed reward #1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 03:20:08'),
(24, 6, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 03:21:07'),
(25, 7, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 03:21:24'),
(26, 7, 'redemption_fulfilled', 'Fulfilled redemption #5 for hero', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 03:23:24'),
(27, 7, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 03:26:25'),
(28, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 03:27:00'),
(29, 6, 'redemption_created', 'User #6 redeemed reward #13', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 03:29:07'),
(30, 6, 'redemption_created', 'User #6 redeemed reward #13', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 03:29:25'),
(31, 6, 'redemption_created', 'User #6 redeemed reward #5', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 03:29:58'),
(32, 6, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 03:30:59'),
(33, 7, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 03:31:15'),
(34, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 11:22:22'),
(35, 7, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 15:53:16'),
(36, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 17:21:30'),
(37, 7, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 17:52:51'),
(38, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 17:57:35'),
(39, 6, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 18:00:10'),
(40, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 18:00:20'),
(41, 6, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 18:02:14'),
(42, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 18:02:58'),
(43, 6, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 18:03:09'),
(44, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 18:03:23'),
(45, 6, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 18:05:54'),
(46, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 18:06:08'),
(47, 6, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 18:06:51'),
(48, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 18:07:04'),
(49, 6, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 18:07:53'),
(50, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 18:11:20'),
(51, 6, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 18:12:00'),
(52, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 18:12:10'),
(53, 6, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 18:50:33'),
(54, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 18:50:43'),
(55, 6, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 18:51:50'),
(56, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 18:52:00'),
(57, 6, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 18:52:28'),
(58, 7, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 18:53:19'),
(59, 7, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 19:03:46'),
(60, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-04 19:25:22'),
(61, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-10 12:10:20'),
(62, 6, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-10 12:14:40'),
(63, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-10 12:15:14'),
(64, 7, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-10 14:26:42'),
(65, 7, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-10 14:34:50'),
(66, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-10 14:36:48'),
(67, 6, 'redemption_created', 'User #6 redeemed reward #7', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-10 14:37:17'),
(68, 6, 'redemption_created', 'User #6 redeemed reward #3', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-10 14:37:59'),
(69, 6, 'redemption_created', 'User #6 redeemed reward #6', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-10 14:38:42'),
(70, 6, 'redemption_created', 'User #6 redeemed reward #4', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-10 14:39:07'),
(71, 6, 'redemption_created', 'User #6 redeemed reward #8', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-10 14:40:52'),
(72, 7, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-11 02:51:31'),
(73, 7, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-11 03:03:25'),
(74, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-11 03:03:37'),
(75, 6, 'redemption_created', 'User #6 redeemed reward #1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-11 03:03:45'),
(76, 7, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 12:42:39'),
(77, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 13:52:24'),
(78, 6, 'redemption_created', 'User #6 redeemed reward #1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 13:56:22'),
(79, 6, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 13:57:59'),
(80, 7, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 13:58:13'),
(81, 7, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 15:24:51'),
(82, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 15:25:08'),
(83, 6, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 15:43:10'),
(84, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 15:44:56'),
(85, 6, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 16:03:20'),
(86, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 16:22:42'),
(87, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 17:37:44'),
(88, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 17:51:00'),
(89, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 17:53:06'),
(90, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 17:59:12'),
(91, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 18:08:49'),
(92, 6, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 18:10:42'),
(93, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 18:20:49'),
(94, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 18:26:29'),
(95, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 18:34:55'),
(96, 6, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 18:35:08'),
(97, 7, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 18:35:59'),
(98, 7, 'redemption_created', 'User #7 redeemed reward #1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 18:45:11'),
(99, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 19:15:12'),
(100, 7, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 19:29:08'),
(101, 7, 'redemption_approved', 'Approved redemption #7 for PogiHero', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 19:30:15'),
(102, 6, 'redemption_created', 'User #6 redeemed reward #13', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 19:49:08'),
(103, 7, 'redemption_approved', 'Approved redemption #17 for PogiHero', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 19:49:35'),
(104, 7, 'redemption_rejected', 'Rejected redemption #6 for PogiHero, points refunded', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 19:50:54'),
(105, 7, 'redemption_fulfilled', 'Fulfilled redemption #17 for PogiHero', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 19:51:06'),
(106, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 20:22:49'),
(107, 6, 'redemption_created', 'User #6 redeemed reward #18', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 20:23:19'),
(108, 7, 'redemption_fulfilled', 'Fulfilled redemption #18 for PogiHero', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 20:23:52'),
(109, 6, 'redemption_created', 'User #6 redeemed reward #20', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 20:24:33'),
(110, 6, 'redemption_created', 'User #6 redeemed reward #14', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-18 20:25:32'),
(111, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 03:56:29'),
(112, 6, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 04:21:22'),
(113, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 04:21:59'),
(114, 6, 'redemption_created', 'User #6 redeemed reward #19', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 04:23:28'),
(115, 6, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 04:26:42'),
(116, 7, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 04:26:58'),
(117, 7, 'redemption_fulfilled', 'Fulfilled redemption #21 for PogiHero', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 04:29:50'),
(118, 7, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 04:30:28'),
(119, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 14:45:58'),
(120, 6, 'redemption_created', 'User #6 redeemed reward #19', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 14:57:36'),
(121, 7, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 14:59:10'),
(122, 7, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 14:59:29'),
(123, 7, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 14:59:44'),
(124, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 15:17:29'),
(125, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 15:29:26'),
(126, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 15:36:44'),
(127, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 15:48:33'),
(128, 6, 'suspicious_score', 'User 6 submitted suspicious score: Score exceeds maximum possible', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 16:35:31'),
(129, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 16:58:22'),
(130, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 17:23:46'),
(131, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 17:32:20'),
(132, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 18:20:08'),
(133, 6, 'redemption_created', 'User #6 redeemed reward #14', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 18:30:07'),
(134, 7, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 18:30:45'),
(135, 6, 'redemption_created', 'User #6 redeemed reward #14', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 18:33:29'),
(136, 6, 'redemption_created', 'User #6 redeemed reward #21', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 18:33:53'),
(137, 6, 'redemption_created', 'User #6 redeemed reward #21', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 18:34:50'),
(138, 6, 'redemption_created', 'User #6 redeemed reward #20', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 18:51:22'),
(139, 6, 'redemption_created', 'User #6 redeemed reward #19', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 18:59:33'),
(140, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 19:00:04'),
(141, 6, 'redemption_created', 'User #6 redeemed reward #19', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 19:00:08'),
(142, 6, 'redemption_created', 'User #6 redeemed reward #19', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 19:01:45'),
(143, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 19:02:25'),
(144, 6, 'redemption_created', 'User #6 redeemed reward #19', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 19:02:29'),
(145, 6, 'redemption_created', 'User #6 redeemed reward #19', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 19:03:42'),
(146, 6, 'redemption_created', 'User #6 redeemed reward #19', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 19:06:05'),
(147, 6, 'redemption_created', 'User #6 redeemed reward #19', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 19:12:55'),
(148, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 19:13:33'),
(149, 6, 'redemption_created', 'User #6 redeemed reward #19', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 19:13:52'),
(150, 6, 'redemption_created', 'User #6 redeemed reward #19', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 19:15:06'),
(151, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 19:15:38'),
(152, 6, 'redemption_created', 'User #6 redeemed reward #19', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 19:15:43'),
(153, 6, 'redemption_created', 'User #6 redeemed reward #14', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 19:18:18'),
(154, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 19:19:21'),
(155, 6, 'redemption_created', 'User #6 redeemed reward #19', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 19:43:53'),
(156, 6, 'redemption_created', 'User #6 redeemed reward #14', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 19:46:36'),
(157, 6, 'redemption_created', 'User #6 redeemed reward #22', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 19:47:38'),
(158, 6, 'redemption_created', 'User #6 redeemed reward #19', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 20:00:46'),
(159, 6, 'redemption_created', 'User #6 redeemed reward #14', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 20:07:52'),
(160, 6, 'redemption_created', 'User #6 redeemed reward #19', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 20:26:24'),
(161, 6, 'redemption_created', 'User #6 redeemed reward #14', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, '2026-02-19 20:26:34'),
(162, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-20 03:54:25'),
(163, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-20 04:34:30'),
(164, 8, 'register', 'New user registered', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-20 23:42:02'),
(165, 8, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-20 23:42:24'),
(166, 8, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-23 04:41:18'),
(167, 7, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-23 15:59:13'),
(168, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-23 17:29:38'),
(169, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-23 17:36:09'),
(170, 6, 'redemption_created', 'User #6 redeemed reward #19', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-23 19:08:21'),
(171, 6, 'redemption_created', 'User #6 redeemed reward #19', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-23 19:14:02'),
(172, 7, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-23 19:14:24'),
(173, 6, 'redemption_created', 'User #6 redeemed reward #23', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-23 19:15:07'),
(174, 6, 'redemption_created', 'User #6 redeemed reward #23', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-23 19:17:11'),
(175, 6, 'redemption_created', 'User #6 redeemed reward #19', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-23 19:19:32'),
(176, 6, 'redemption_created', 'User #6 redeemed reward #23', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-23 19:21:21'),
(177, 6, 'redemption_created', 'User #6 redeemed reward #23', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-23 19:24:39'),
(178, 6, 'redemption_created', 'User #6 redeemed reward #23', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-23 19:31:43'),
(179, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-23 19:40:07'),
(180, 6, 'redemption_created', 'User #6 redeemed reward #19', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-23 19:40:15'),
(181, 6, 'redemption_created', 'User #6 redeemed reward #23', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-23 19:41:56'),
(182, 6, 'redemption_created', 'User #6 redeemed reward #19', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-23 19:42:05'),
(183, 6, 'redemption_created', 'User #6 redeemed reward #23', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-23 19:49:20'),
(184, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-23 19:53:48'),
(185, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-23 19:56:38'),
(186, 6, 'logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-23 19:59:57'),
(187, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-23 20:00:15'),
(188, 6, 'redemption_created', 'User #6 redeemed reward #23', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-23 20:00:26'),
(189, 7, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-23 20:00:47'),
(190, 7, 'redemption_rejected', 'Rejected redemption #54 for PogiHero, points refunded', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-23 20:01:05'),
(191, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-23 20:06:04'),
(192, 6, 'redemption_created', 'User #6 redeemed reward #23', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-23 20:06:08'),
(193, 6, 'login', 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-23 20:39:15'),
(194, 6, 'redemption_created', 'User #6 redeemed reward #23', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-02-23 20:39:20');

-- --------------------------------------------------------

--
-- Table structure for table `daily_play_limits`
--

CREATE TABLE `daily_play_limits` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `game_id` int(10) UNSIGNED NOT NULL,
  `play_date` date NOT NULL,
  `play_count` int(10) UNSIGNED DEFAULT 1,
  `points_earned` int(10) UNSIGNED DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `daily_play_limits`
--

INSERT INTO `daily_play_limits` (`id`, `user_id`, `game_id`, `play_date`, `play_count`, `points_earned`) VALUES
(1, 6, 1, '2026-02-03', 1, 122),
(2, 7, 1, '2026-02-03', 2, 299),
(4, 6, 1, '2026-02-04', 3, 24),
(6, 7, 2, '2026-02-04', 1, 53),
(8, 6, 1, '2026-02-10', 3, 386),
(11, 6, 5, '2026-02-18', 3, 228),
(12, 6, 2, '2026-02-18', 2, 305),
(13, 6, 1, '2026-02-18', 9, 637),
(24, 7, 3, '2026-02-18', 1, 233),
(25, 7, 4, '2026-02-18', 2, 1060),
(28, 6, 1, '2026-02-19', 6, 474),
(29, 6, 2, '2026-02-19', 3, 289),
(31, 6, 3, '2026-02-19', 3, 254),
(40, 6, 5, '2026-02-19', 1, 670),
(41, 6, 1, '2026-02-20', 1, 63),
(42, 8, 1, '2026-02-23', 2, 169),
(44, 7, 1, '2026-02-23', 3, 162),
(47, 6, 1, '2026-02-23', 11, 65);

-- --------------------------------------------------------

--
-- Table structure for table `games`
--

CREATE TABLE `games` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `instructions` text DEFAULT NULL,
  `thumbnail` varchar(255) NOT NULL DEFAULT 'default-game.png',
  `game_file` varchar(255) NOT NULL,
  `category` enum('action','puzzle','word','memory','quiz','arcade') DEFAULT 'arcade',
  `points_reward` int(10) UNSIGNED DEFAULT 10,
  `points_multiplier` decimal(3,2) DEFAULT 1.00,
  `difficulty` enum('easy','medium','hard') DEFAULT 'medium',
  `min_score_for_points` int(10) UNSIGNED DEFAULT 0,
  `max_plays_per_day` int(10) UNSIGNED DEFAULT 10,
  `play_count` int(10) UNSIGNED DEFAULT 0,
  `status` enum('active','inactive','maintenance') DEFAULT 'active',
  `featured` tinyint(1) DEFAULT 0,
  `sort_order` int(10) UNSIGNED DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `games`
--

INSERT INTO `games` (`id`, `title`, `slug`, `description`, `instructions`, `thumbnail`, `game_file`, `category`, `points_reward`, `points_multiplier`, `difficulty`, `min_score_for_points`, `max_plays_per_day`, `play_count`, `status`, `featured`, `sort_order`, `created_at`, `updated_at`) VALUES
(1, 'Fruit Catch', 'fruit-catch', 'Catch falling fruits in your basket! The more you catch, the higher your score. Watch out for rotten fruits - they will cost you lives! Collect special golden fruits for bonus points.', 'Use LEFT and RIGHT arrow keys or move your mouse to control the basket. On mobile, touch and drag to move. Catch fresh fruits to earn points. Avoid the skull (💀) rotten fruits - catching them costs a life! Catch the diamond (💎) for bonus points. Game ends when you lose all 3 lives.', 'game_1770734011_698b41bb456f3.png', 'fruit-catch.php', 'arcade', 15, 1.00, 'easy', 50, 20, 1400, 'active', 1, 1, '2026-02-02 19:56:33', '2026-02-23 19:49:43'),
(2, 'Word Scramble', 'word-scramble', 'Unscramble the letters to form words before time runs out! Test your vocabulary and quick thinking skills. The faster you solve, the more points you earn!', 'Look at the scrambled letters displayed on screen. Type the correct word using your keyboard. Press ENTER to submit your answer. Complete as many words as possible before the 60-second timer runs out. Correct answers add bonus time. Build streaks for multiplier bonuses!', 'game_1771418630_6995b40664b88.png', 'word-scramble.php', 'word', 20, 1.00, 'easy', 100, 15, 926, 'active', 0, 2, '2026-02-02 19:56:33', '2026-02-23 15:59:56'),
(3, 'Quiz Master', 'quiz-master', 'Test your general knowledge with our trivia quiz! Answer multiple choice questions correctly to score points. Challenge yourself across various categories including science, history, geography, and more.', 'Read each question carefully. Click on one of the four answer options or press 1-4 on your keyboard. You have 15 seconds per question. Correct answers earn points - faster answers earn bonus points! Complete all 10 questions to finish the quiz.', 'game_1771418709_6995b455667e4.webp', 'quiz-master.php', 'quiz', 25, 1.00, 'medium', 60, 10, 2198, 'active', 0, 3, '2026-02-02 19:56:33', '2026-02-23 16:00:10'),
(4, 'Sliding Puzzle', 'sliding-puzzle', 'Arrange the tiles in the correct order by sliding them! A classic 15-puzzle game that tests your problem-solving skills and spatial reasoning. Can you solve it in the fewest moves?', 'Click on a tile adjacent to the empty space to slide it. Alternatively, use arrow keys to move tiles. Arrange all tiles in numerical order (1-15) with the empty space in the bottom-right corner. Fewer moves and faster completion = higher score!', 'game_1771419293_6995b69dc87aa.png', 'sliding-puzzle.php', 'puzzle', 30, 1.00, 'hard', 1, 10, 745, 'active', 0, 4, '2026-02-02 19:56:33', '2026-02-23 18:47:42'),
(5, 'Memory Match', 'memory-match', 'Find matching pairs of cards! Test your memory and concentration in this classic card matching game. Flip cards to reveal hidden symbols and remember their positions to find matches.', 'Click on cards to flip them over. Find all matching pairs by remembering card positions. Match all 8 pairs to complete the game. Fewer moves = higher score! Time bonus awarded for quick completion.', 'game_1771418669_6995b42db28b2.webp', 'memory-match.php', 'memory', 20, 1.00, 'easy', 1, 15, 1861, 'active', 1, 5, '2026-02-02 19:56:33', '2026-02-23 19:07:02'),
(6, 'Snake Classic', 'snake-classic', 'The classic snake game! Eat food to grow longer, but don\'t hit the walls or yourself. How long can you survive?', 'Use arrow keys to control the snake direction. Eat the food to grow and earn points. Avoid hitting walls and your own tail!', 'snake-classic.png', 'snake-classic.php', 'arcade', 15, 1.00, 'medium', 100, 20, 1, 'inactive', 0, 10, '2026-02-02 19:56:33', '2026-02-19 04:28:02'),
(7, 'Math Challenge', 'math-challenge', 'Test your arithmetic skills! Solve math problems as fast as you can. Addition, subtraction, multiplication, and division await!', 'Solve the math problem displayed on screen. Type your answer and press ENTER. Answer as many questions as you can before time runs out!', 'math-challenge.png', 'math-challenge.php', 'quiz', 25, 1.00, 'medium', 80, 15, 0, 'inactive', 0, 11, '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(8, 'Quiz BEE', 'quiz-bee', 'about the crops that you can find in NIR only', 'play the game, choose a correct answers, goodluck!!!', 'quiz', 'medium', 'arcade', 1, 1.00, 'medium', 0, 10, 2, 'inactive', 0, 0, '2026-02-10 14:32:21', '2026-02-18 15:08:59');

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `id` int(10) UNSIGNED NOT NULL,
  `email` varchar(100) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `expires_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `used_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `redemptions`
--

CREATE TABLE `redemptions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `reward_id` int(10) UNSIGNED NOT NULL,
  `points_spent` int(10) UNSIGNED NOT NULL,
  `status` enum('pending','approved','fulfilled','rejected','cancelled') NOT NULL DEFAULT 'pending',
  `admin_notes` text DEFAULT NULL,
  `user_notes` text DEFAULT NULL,
  `processed_by` int(10) UNSIGNED DEFAULT NULL,
  `processed_at` timestamp NULL DEFAULT NULL,
  `fulfilled_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `redemptions`
--

INSERT INTO `redemptions` (`id`, `user_id`, `reward_id`, `points_spent`, `status`, `admin_notes`, `user_notes`, `processed_by`, `processed_at`, `fulfilled_at`, `created_at`, `updated_at`) VALUES
(18, 6, 18, 2500, 'pending', 'come to my office, code done', '', 7, '2026-02-18 20:23:52', '2026-02-18 20:23:52', '2026-02-18 20:23:19', '2026-02-19 18:50:47'),
(19, 6, 20, 3000, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-18 20:24:33', '2026-02-19 18:51:06'),
(20, 6, 14, 1000, 'pending', NULL, 'aaaaaaaaa', NULL, NULL, NULL, '2026-02-18 20:25:32', '2026-02-23 19:41:39'),
(21, 6, 19, 500, 'pending', '', '', 7, '2026-02-19 04:29:50', '2026-02-19 04:29:50', '2026-02-19 04:23:28', '2026-02-23 20:40:17'),
(22, 6, 19, 500, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-19 14:57:36', '2026-02-23 19:41:39'),
(23, 6, 14, 1000, 'pending', NULL, 'adasdadda', NULL, NULL, NULL, '2026-02-19 18:30:07', '2026-02-23 19:41:39'),
(24, 6, 14, 1000, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-19 18:33:29', '2026-02-23 19:41:39'),
(25, 6, 21, 2000, 'pending', NULL, 'can i have po', NULL, NULL, NULL, '2026-02-19 18:33:53', '2026-02-23 19:41:39'),
(26, 6, 21, 2000, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-19 18:34:50', '2026-02-23 19:41:39'),
(27, 6, 20, 3000, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-19 18:51:22', '2026-02-23 19:41:39'),
(28, 6, 19, 500, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-19 18:59:33', '2026-02-23 19:41:39'),
(29, 6, 19, 500, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-19 19:00:08', '2026-02-23 19:41:39'),
(30, 6, 19, 500, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-19 19:01:45', '2026-02-23 19:41:39'),
(31, 6, 19, 500, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-19 19:02:29', '2026-02-23 19:41:39'),
(32, 6, 19, 500, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-19 19:03:42', '2026-02-23 19:41:39'),
(33, 6, 19, 500, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-19 19:06:05', '2026-02-23 19:41:39'),
(34, 6, 19, 500, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-19 19:12:55', '2026-02-23 19:41:39'),
(35, 6, 19, 500, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-19 19:13:52', '2026-02-23 19:41:39'),
(36, 6, 19, 500, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-19 19:15:06', '2026-02-23 19:41:39'),
(37, 6, 19, 500, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-19 19:15:43', '2026-02-23 19:41:39'),
(38, 6, 14, 1000, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-19 19:18:18', '2026-02-23 19:41:39'),
(39, 6, 19, 500, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-19 19:43:53', '2026-02-23 19:41:39'),
(40, 6, 14, 1000, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-19 19:46:36', '2026-02-23 19:41:39'),
(42, 6, 19, 500, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-19 20:00:46', '2026-02-23 19:41:39'),
(43, 6, 14, 1000, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-19 20:07:52', '2026-02-23 19:41:39'),
(44, 6, 19, 500, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-19 20:26:24', '2026-02-23 19:41:39'),
(45, 6, 14, 1000, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-19 20:26:34', '2026-02-23 19:41:39'),
(46, 6, 19, 500, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-23 19:08:21', '2026-02-23 19:41:39'),
(47, 6, 19, 500, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-23 19:14:02', '2026-02-23 19:41:39'),
(48, 6, 23, 1, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-23 19:15:07', '2026-02-23 19:41:39'),
(49, 6, 23, 1, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-23 19:17:11', '2026-02-23 19:41:39'),
(50, 6, 19, 500, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-23 19:19:32', '2026-02-23 19:41:39'),
(51, 6, 23, 1, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-23 19:21:21', '2026-02-23 19:41:39'),
(52, 6, 23, 1, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-23 19:24:39', '2026-02-23 19:41:39'),
(53, 6, 23, 1, 'pending', NULL, '', NULL, NULL, NULL, '2026-02-23 19:31:43', '2026-02-23 19:41:39'),
(54, 6, 19, 500, 'rejected', 'sorry not available', '', 7, '2026-02-23 20:01:05', NULL, '2026-02-23 19:40:15', '2026-02-23 20:01:05'),
(55, 6, 23, 1, 'approved', NULL, '', NULL, NULL, NULL, '2026-02-23 19:41:56', '2026-02-23 19:41:56'),
(56, 6, 19, 500, 'approved', NULL, '', NULL, NULL, NULL, '2026-02-23 19:42:05', '2026-02-23 19:42:05'),
(57, 6, 23, 1, 'approved', NULL, '', NULL, NULL, NULL, '2026-02-23 19:49:20', '2026-02-23 19:49:20'),
(58, 6, 23, 1, 'approved', NULL, '', NULL, NULL, NULL, '2026-02-23 20:00:26', '2026-02-23 20:00:26'),
(59, 6, 23, 1, 'approved', NULL, '', NULL, NULL, NULL, '2026-02-23 20:06:08', '2026-02-23 20:06:08'),
(60, 6, 23, 1, 'approved', NULL, '', NULL, NULL, NULL, '2026-02-23 20:39:20', '2026-02-23 20:39:20');

-- --------------------------------------------------------

--
-- Table structure for table `rewards`
--

CREATE TABLE `rewards` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `points_cost` int(10) UNSIGNED NOT NULL,
  `category` enum('digital','physical','voucher','badge','other') DEFAULT 'digital',
  `image` varchar(255) DEFAULT 'default-reward.png',
  `quantity` int(11) DEFAULT NULL,
  `max_per_user` int(10) UNSIGNED DEFAULT 1,
  `requires_approval` tinyint(1) DEFAULT 0,
  `status` enum('active','inactive','out_of_stock') DEFAULT 'active',
  `valid_from` timestamp NULL DEFAULT NULL,
  `valid_until` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `rewards`
--

INSERT INTO `rewards` (`id`, `name`, `description`, `points_cost`, `category`, `image`, `quantity`, `max_per_user`, `requires_approval`, `status`, `valid_from`, `valid_until`, `created_at`, `updated_at`) VALUES
(14, 'paperclip', 'for paper to clip', 1000, 'voucher', 'reward_1770223676_6983783c1341d.png', 3, 1, 0, 'active', NULL, NULL, '2026-02-03 18:42:19', '2026-02-19 20:26:34'),
(18, 'PEN', '0.5 tip', 2500, 'physical', 'reward_1771445217_69961be1a9598.png', 4, 1, 0, 'active', NULL, NULL, '2026-02-18 20:06:57', '2026-02-18 20:23:19'),
(19, 'Yellow Pad', '10pcs', 500, 'physical', 'reward_1771445531_69961d1ba7141.png', NULL, 5, 0, 'active', NULL, NULL, '2026-02-18 20:12:11', '2026-02-18 20:12:11'),
(20, 'Marker', 'Permanent Marker', 3000, 'physical', 'reward_1771445883_69961e7b23dcf.png', 3, 1, 0, 'active', NULL, NULL, '2026-02-18 20:18:03', '2026-02-19 18:51:22'),
(21, 'Cartolina', 'w/ different color', 2000, 'voucher', 'reward_1771446138_69961f7a1541d.png', 8, 1, 0, 'active', NULL, NULL, '2026-02-18 20:22:18', '2026-02-19 18:34:50'),
(23, 'asa', 'adad', 1, 'digital', 'default-reward.png', NULL, 10, 0, 'active', NULL, NULL, '2026-02-23 19:14:59', '2026-02-23 19:14:59');

-- --------------------------------------------------------

--
-- Table structure for table `scores`
--

CREATE TABLE `scores` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `game_id` int(10) UNSIGNED NOT NULL,
  `score` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `points_earned` int(10) UNSIGNED DEFAULT 0,
  `play_time` int(10) UNSIGNED DEFAULT 0,
  `completed` tinyint(1) DEFAULT 0,
  `game_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`game_data`)),
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  `session_token` varchar(64) DEFAULT NULL,
  `validated` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `scores`
--

INSERT INTO `scores` (`id`, `user_id`, `game_id`, `score`, `points_earned`, `play_time`, `completed`, `game_data`, `ip_address`, `user_agent`, `session_token`, `validated`, `created_at`) VALUES
(1, 2, 1, 850, 40, 125, 1, NULL, NULL, NULL, NULL, 0, '2026-01-24 19:56:33'),
(2, 2, 3, 420, 25, 180, 1, NULL, NULL, NULL, NULL, 0, '2026-01-25 19:56:33'),
(3, 2, 1, 620, 30, 98, 1, NULL, NULL, NULL, NULL, 0, '2026-01-26 19:56:33'),
(4, 2, 5, 1100, 45, 145, 1, NULL, NULL, NULL, NULL, 0, '2026-01-27 19:56:33'),
(5, 3, 5, 1200, 50, 132, 1, NULL, NULL, NULL, NULL, 0, '2026-01-19 19:56:33'),
(6, 3, 4, 980, 55, 245, 1, NULL, NULL, NULL, NULL, 0, '2026-01-21 19:56:33'),
(7, 3, 2, 650, 35, 60, 1, NULL, NULL, NULL, NULL, 0, '2026-01-23 19:56:33'),
(8, 3, 1, 1100, 45, 156, 1, NULL, NULL, NULL, NULL, 0, '2026-01-25 19:56:33'),
(9, 3, 3, 580, 30, 195, 1, NULL, NULL, NULL, NULL, 0, '2026-01-28 19:56:33'),
(10, 4, 1, 2500, 75, 180, 1, NULL, NULL, NULL, NULL, 0, '2026-01-05 19:56:33'),
(11, 4, 3, 950, 60, 200, 1, NULL, NULL, NULL, NULL, 0, '2026-01-08 19:56:33'),
(12, 4, 5, 1800, 65, 95, 1, NULL, NULL, NULL, NULL, 0, '2026-01-11 19:56:33'),
(13, 4, 4, 3200, 80, 180, 1, NULL, NULL, NULL, NULL, 0, '2026-01-15 19:56:33'),
(14, 4, 2, 890, 45, 60, 1, NULL, NULL, NULL, NULL, 0, '2026-01-18 19:56:33'),
(15, 4, 1, 3100, 85, 210, 1, NULL, NULL, NULL, NULL, 0, '2026-01-23 19:56:33'),
(16, 4, 3, 880, 55, 190, 1, NULL, NULL, NULL, NULL, 0, '2026-01-26 19:56:33'),
(17, 4, 5, 2200, 70, 88, 1, NULL, NULL, NULL, NULL, 0, '2026-01-30 19:56:33'),
(18, 5, 1, 320, 15, 65, 1, NULL, NULL, NULL, NULL, 0, '2026-02-01 19:56:33'),
(19, 5, 5, 450, 20, 180, 1, NULL, NULL, NULL, NULL, 0, '2026-02-02 19:56:33'),
(20, 6, 1, 815, 122, 0, 1, '{\"level\":2,\"play_time\":47,\"fruits_caught\":81}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2a3d17afc608869985e496cf0318ac54095c181623ca964d1c62a8a1b98dedd0', 1, '2026-02-03 17:05:20'),
(21, 7, 1, 0, 0, 0, 1, '{\"level\":1,\"play_time\":3,\"fruits_caught\":0}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '1d56397dbdb5c1eeae481dfa3fd18ac985a17be4ae88879d3d3449a741ee3064', 1, '2026-02-03 17:41:06'),
(22, 7, 1, 1995, 299, 0, 1, '{\"level\":4,\"play_time\":91,\"fruits_caught\":199}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 'd16716d47f24b25c7926fac42a72ae8273368be2608b2207dd9d0322c881a35d', 1, '2026-02-03 18:39:57'),
(23, 6, 1, 15, 0, 0, 1, '{\"level\":1,\"play_time\":8,\"fruits_caught\":1}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '87e29b05a278596e14acf3f9e308fe6749b19d5c6f90c884322ae630b378de77', 1, '2026-02-04 03:19:10'),
(24, 6, 1, 65, 10, 0, 1, '{\"level\":1,\"play_time\":9,\"fruits_caught\":6}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 'bed95e2e41e54d4acdf11c1d0d1159ae12af89cab62c0e892637744be62e5fb3', 1, '2026-02-04 03:28:03'),
(25, 7, 2, 175, 53, 0, 1, '{\"words_completed\":3,\"highest_streak\":0,\"difficulty\":\"medium\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '168780dd2da6b840aaa2f8a279d7ef539132ff07f0ebe32bd47376da91dabebd', 1, '2026-02-04 03:36:46'),
(26, 6, 1, 95, 14, 0, 1, '{\"level\":1,\"play_time\":11,\"fruits_caught\":9}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 'fdc3be5869c249c597635d7c725cf0bddfa9ed09f6177fcbdfdb65104150382f', 1, '2026-02-04 11:23:13'),
(27, 6, 1, 350, 53, 0, 1, '{\"level\":1,\"play_time\":12,\"fruits_caught\":35}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 'b5a7f9617092cb09f97598f66c4407a5ac4dcfd03a570b57bd064b313b4fbf41', 1, '2026-02-10 12:15:32'),
(28, 6, 1, 860, 129, 0, 1, '{\"level\":2,\"play_time\":45,\"fruits_caught\":86}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 'ea2aaff428e68ea58d086f5c8250d99a98404c361bd444952216ac7d164a6132', 1, '2026-02-10 14:41:57'),
(29, 6, 1, 1360, 204, 0, 1, '{\"level\":3,\"play_time\":63,\"fruits_caught\":136}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '93677be75049aa43842a68a0b62d4fe9132ef6748218d91029d279ce179f242f', 1, '2026-02-10 14:43:10'),
(30, 6, 5, 961, 192, 0, 1, '{\"moves\":17,\"play_time\":39,\"pairs_found\":8}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '20682de027934386e246efdeef3ab591cb2626aeb9899f2f50cd088af6c163a1', 1, '2026-02-18 13:54:09'),
(31, 6, 2, 470, 141, 0, 1, '{\"words_completed\":6,\"highest_streak\":1,\"difficulty\":\"medium\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '798154ae81edea54725ffded1c09c60534105ab7097c69e6552ac9682c0e219c', 1, '2026-02-18 13:56:09'),
(32, 6, 1, 200, 30, 0, 1, '{\"level\":1,\"play_time\":19,\"fruits_caught\":20}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 'a66f596326f7cc787468c5a2cfac754c450f1b764e04d7c72d08cf1f797a2cb6', 1, '2026-02-18 15:56:44'),
(33, 6, 1, 65, 10, 0, 1, '{\"level\":1,\"play_time\":8,\"fruits_caught\":6}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 'b71010a78fb10b6cc37e928fef61e446388c656eeae63e8bb741baf56ad31260', 1, '2026-02-18 15:57:06'),
(34, 6, 1, 355, 53, 0, 1, '{\"level\":1,\"play_time\":21,\"fruits_caught\":35}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 'd06012ca9f6b3023e4cf076cc79b5a9845a36a371c21e490c1c1728f8c080130', 1, '2026-02-18 16:23:08'),
(35, 6, 5, 20, 4, 0, 1, '{\"level_reached\":1,\"total_moves\":11}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 'dac4cb2796320c4b8b008e96f4074b9c356258cc01215c73ab258c4c82fbdef1', 1, '2026-02-18 16:24:06'),
(36, 6, 5, 160, 32, 0, 1, '{\"level_reached\":2,\"total_moves\":27}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '37640ef6eb99e34fea8f9996b0ae12286819f4e15de0909a1885bfe63525565d', 1, '2026-02-18 17:33:14'),
(37, 6, 1, 480, 72, 0, 1, '{\"level\":1,\"play_time\":21,\"fruits_caught\":48}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 'ded1abea8abda558f157df9db7fd9bcc3cbf49f342156b86fe096d47976e18f4', 1, '2026-02-18 17:51:30'),
(38, 6, 1, 420, 63, 0, 1, '{\"level\":1,\"play_time\":29,\"fruits_caught\":42}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 'f7c847684a9707c41783b9d012115daf928ca5cfbdd5f5590015a78ded5a3615', 1, '2026-02-18 17:52:11'),
(39, 6, 1, 515, 77, 0, 1, '{\"level\":2,\"play_time\":30,\"fruits_caught\":51}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '7399b4606f836c46b9d5e91b6fc38faf81e81cc58c048f28db58b43ea9568ef9', 1, '2026-02-18 17:53:42'),
(40, 6, 1, 1585, 238, 0, 1, '{\"level\":3,\"play_time\":83,\"fruits_caught\":158}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 'f74c1da2c7fed8e1cfdf4332210e5d1d4bc51d4a49ca3c5d7f0975dced30cbfe', 1, '2026-02-18 17:55:22'),
(41, 6, 1, 235, 35, 0, 1, '{\"level\":4,\"play_time\":99,\"fruits_caught\":23}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '3c5b27f17a6d69c36c8acd2b0b7bf4e65ea428af6fc97be49cdf74ad42b6c802', 1, '2026-02-18 17:55:30'),
(42, 6, 2, 545, 164, 0, 1, '{\"words_completed\":6,\"highest_streak\":0,\"difficulty\":\"medium\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '980a0723748378a8333afac42cbc7c9a1bdbf3a8aa62af60047c069faa69ae95', 1, '2026-02-18 18:29:35'),
(43, 7, 3, 622, 233, 0, 1, '{\"correct_answers\":9,\"total_questions\":10,\"accuracy\":90}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '30aba32dc4377e842002d07fbdfca2929b744bed7a2601a6e8660e2045624624', 1, '2026-02-18 18:39:39'),
(44, 7, 4, 5380, 1000, 0, 1, '{\"moves\":80,\"play_time\":62,\"grid_size\":4}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 'd9c7f1ee6695fd6277acd6a01418080cf695df722b56918a6fd4053a4b66ffad', 1, '2026-02-18 18:44:51'),
(45, 7, 4, 100, 60, 0, 1, '{\"moves\":238,\"play_time\":188,\"grid_size\":4}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '91a5fbcaf5c710a406581e8d93eaea4865fb954bbe0ab0ca26552637a0d0fc91', 1, '2026-02-18 18:57:55'),
(46, 6, 1, 390, 59, 0, 1, '{\"level\":1,\"play_time\":23,\"fruits_caught\":39}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '8fe7cb0e02d0dcdfd2a69dd03dc965562a327e63d5162384efe9981c680c725c', 1, '2026-02-18 20:26:14'),
(47, 6, 1, 885, 133, 0, 1, '{\"level\":2,\"play_time\":55,\"fruits_caught\":88}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 'a0ec61f566e0c37cf08ea70be6ace664b5818b75771e0237b4193665cbc91aa1', 1, '2026-02-19 03:57:36'),
(48, 6, 2, 785, 236, 0, 1, '{\"words_completed\":9,\"highest_streak\":0,\"difficulty\":\"medium\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '8176da86b0f65354dc454c8f4ad316ffc6f9ea3e0794451d403bc4ee262b33a4', 1, '2026-02-19 04:00:10'),
(49, 6, 1, 300, 45, 0, 1, '{\"level\":1,\"play_time\":19,\"fruits_caught\":30}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '759d91b5f8c8438ad15367445799b870116124b51c6180fb1f43cf0c912ab3b7', 1, '2026-02-19 04:25:40'),
(50, 6, 3, 226, 85, 0, 1, '{\"correct_answers\":4,\"total_questions\":10,\"accuracy\":40}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 'c1b341daee51ead8ebc058c8e018527160a7a99e7b83debafab6a7e3585d5103', 1, '2026-02-19 15:19:53'),
(51, 6, 1, 170, 26, 0, 1, '{\"level\":1,\"play_time\":12,\"fruits_caught\":17}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '9c9401aa53fe2d78beafe3787526f7a0da28bfec59ad30fef260e54810d984b2', 1, '2026-02-19 15:23:38'),
(52, 6, 2, 0, 0, 0, 1, '{\"words_completed\":0,\"highest_streak\":0,\"difficulty\":\"medium\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '3ddf050b7b8fe5f97c6c9c85fb144d7dbaefb1b1e6f30190db0434c29c7822be', 1, '2026-02-19 15:25:08'),
(53, 6, 1, 615, 92, 0, 1, '{\"level\":2,\"play_time\":39,\"fruits_caught\":61}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '8c96bab21a1f598e060c24ede499354c4e204fa9e1ae472cd3af589bc02166b2', 1, '2026-02-19 15:35:50'),
(54, 6, 1, 1050, 158, 0, 1, '{\"level\":3,\"play_time\":60,\"fruits_caught\":105}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '819dedf2337cdd54fdec94eb344e0bd5f060dc1c95235ef7fdddf3ddb0e84d33', 1, '2026-02-19 15:40:03'),
(55, 6, 1, 135, 20, 0, 1, '{\"level\":1,\"play_time\":12,\"fruits_caught\":13}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 'dac9e4eff443abe2c9208483658d84cca90347095fbd580ee146afc3da546d7c', 1, '2026-02-19 15:48:51'),
(56, 6, 2, 175, 53, 0, 1, '{\"words_completed\":2,\"highest_streak\":0,\"difficulty\":\"medium\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '015b0e22572e2c155e0a35a8a06afd5530607041cec910b3742ae25daa316461', 1, '2026-02-19 16:14:59'),
(57, 6, 3, 450, 169, 0, 1, '{\"correct_answers\":7,\"total_questions\":10,\"accuracy\":70}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 'a126d9406201528e5f6d49c9c988e7a095850d0eb17413ef2532c68716e5f993', 1, '2026-02-19 16:22:24'),
(58, 6, 3, 1030, 0, 0, 1, '{\"correct_answers\":11,\"level_reached\":3,\"accuracy\":79}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '516ad3e8495d999f3fbc60d2d91d56a7e997e2791339081b7c838c366267aff9', 1, '2026-02-19 16:35:31'),
(59, 6, 5, 3350, 670, 0, 1, '{\"levels_completed\":4,\"total_pairs\":10}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '845673473d6ec952582cec7eff2efee4cb5f687242d04e33f1d81555c0da1352', 1, '2026-02-19 18:26:58'),
(60, 6, 1, 420, 63, 0, 1, '{\"level\":1,\"play_time\":16,\"fruits_caught\":42}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '5fcd1544bebe269e42868153cf01cdee84a7949d838f513d2cbc54cbdf136330', 1, '2026-02-20 04:35:04'),
(61, 8, 1, 550, 83, 0, 1, '{\"level\":2,\"play_time\":33,\"fruits_caught\":55}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '084995ceb5c84df7c22f59242fcf6c2a3447e0e19990b73feb5fb24d475f0610', 1, '2026-02-23 05:34:44'),
(62, 8, 1, 570, 86, 0, 1, '{\"level\":2,\"play_time\":35,\"fruits_caught\":57}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '145ac0a2d3699d12632681d3e78d49803714bc4e371d9a48b57040be75737ff4', 1, '2026-02-23 05:35:27'),
(63, 7, 1, 250, 38, 0, 1, '{\"level\":1,\"play_time\":13,\"fruits_caught\":25}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'baf9bae93ff98ac24573c36c4fd8bb47d5e7e19e871bae4caefc5a0aac1ba467', 1, '2026-02-23 17:05:53'),
(64, 7, 1, 195, 29, 0, 1, '{\"level\":1,\"play_time\":10,\"fruits_caught\":19}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '390cc425f909fbad4ba28dc2f906de1f34b80f907b5c1098de31b089cb118a95', 1, '2026-02-23 17:09:53'),
(65, 7, 1, 630, 95, 0, 1, '{\"level\":2,\"play_time\":30,\"fruits_caught\":63}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '3fdc29082aa041da19cb6a52e526658b5fc2ccde04cc46579f41226d62cf6769', 1, '2026-02-23 17:22:24'),
(66, 6, 1, 10, 0, 0, 1, '{\"level\":1,\"play_time\":4,\"fruits_caught\":1}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '55cff3d8ef2628d788cb4770b3f3d5a0ddee9e462c5664f4f0aa210e67b637e8', 1, '2026-02-23 17:29:50'),
(67, 6, 1, 0, 0, 0, 1, '{\"level\":1,\"play_time\":4,\"fruits_caught\":0}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2f74389538c1ff4a455d070172a08fdd2e288eb8cf4ad8a7b11f840e8aa0f770', 1, '2026-02-23 17:31:21'),
(68, 6, 1, 0, 0, 0, 1, '{\"level\":1,\"play_time\":3,\"fruits_caught\":0}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '47aa37366485e611dd4ab359c07b125ce34c56f558e98e120f6a60aba1d85bc7', 1, '2026-02-23 17:31:33'),
(69, 6, 1, 0, 0, 0, 1, '{\"level\":1,\"play_time\":3,\"fruits_caught\":0}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '0ebba4e696fd86f376ed4732fc226db4868efcf2a1e79c8f3c05bf21dde7793a', 1, '2026-02-23 17:35:31'),
(70, 6, 1, 30, 0, 0, 1, '{\"level\":1,\"play_time\":6,\"fruits_caught\":3}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'f8315af4814ff61de192432829adb92cd5ea11d8bd091105abeeb64862a42228', 1, '2026-02-23 17:36:20'),
(71, 6, 1, 0, 0, 0, 1, '{\"level\":1,\"play_time\":3,\"fruits_caught\":0}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '6ac6aab5fb6d582f9fdb8d67e15ede54c09c277ea712a8156a7fa8b283eba11e', 1, '2026-02-23 17:36:33'),
(72, 6, 1, 0, 0, 0, 1, '{\"level\":1,\"play_time\":5,\"fruits_caught\":0}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'd9197e167d51dbf63cac47d4076801525b91c15f93274f09f7ce8fb2bcd5c75e', 1, '2026-02-23 17:39:20'),
(73, 6, 1, 0, 0, 0, 1, '{\"level\":1,\"play_time\":4,\"fruits_caught\":0}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'e9c41ddbbf16a613975992cbf2508ea2b753b3f3228b4a7564508d0a66d20eb9', 1, '2026-02-23 17:46:32'),
(74, 6, 1, 45, 0, 0, 1, '{\"level\":1,\"play_time\":7,\"fruits_caught\":4}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'c24971bac1fd7f274ecfe496b21ac954fdc0e7ff09fbdf208b1a0027b1350df5', 1, '2026-02-23 18:27:01'),
(75, 6, 1, 185, 28, 12, 1, '{\"level\":1,\"play_time\":12,\"fruits_caught\":18}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '002aa230a22d165b896171de18d748dd1105e23e8ed78ef3dc98d82d49dc7c07', 1, '2026-02-23 19:07:18'),
(76, 6, 1, 245, 37, 11, 1, '{\"level\":1,\"play_time\":11,\"fruits_caught\":24}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '941992860443cefece04d7a451b20abcfcce983164e9e8c9c9fe8e16e8e6b3df', 1, '2026-02-23 19:49:41');

--
-- Triggers `scores`
--
DELIMITER $$
CREATE TRIGGER `after_score_insert` AFTER INSERT ON `scores` FOR EACH ROW BEGIN
    UPDATE games SET play_count = play_count + 1 WHERE id = NEW.game_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(128) NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` text NOT NULL,
  `last_activity` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` int(10) UNSIGNED NOT NULL,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text DEFAULT NULL,
  `setting_type` enum('string','integer','boolean','json') DEFAULT 'string',
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `setting_key`, `setting_value`, `setting_type`, `description`, `created_at`, `updated_at`) VALUES
(1, 'site_name', 'Game Library', 'string', 'The name of the website', '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(2, 'site_description', 'Play games, earn points, win rewards!', 'string', 'Site meta description', '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(3, 'welcome_bonus', '100', 'integer', 'Points given to new users', '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(4, 'max_daily_plays_default', '10', 'integer', 'Default max plays per game per day', '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(5, 'maintenance_mode', 'false', 'boolean', 'Enable maintenance mode', '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(6, 'registration_enabled', 'true', 'boolean', 'Allow new user registration', '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(7, 'leaderboard_limit', '100', 'integer', 'Maximum entries shown on leaderboard', '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(8, 'min_password_length', '8', 'integer', 'Minimum password length for registration', '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(9, 'points_expiry_days', '0', 'integer', '0 = never expire, otherwise days until points expire', '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(10, 'contact_email', 'support@gamelibrary.com', 'string', 'Support contact email', '2026-02-02 19:56:33', '2026-02-02 19:56:33');

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `wallet_id` int(10) UNSIGNED NOT NULL,
  `type` enum('earn','spend','bonus','penalty','refund','adjustment') NOT NULL,
  `amount` int(11) NOT NULL,
  `balance_after` int(10) UNSIGNED NOT NULL,
  `description` varchar(255) NOT NULL,
  `reference_type` enum('game','redemption','admin','bonus','other') DEFAULT NULL,
  `reference_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`id`, `wallet_id`, `type`, `amount`, `balance_after`, `description`, `reference_type`, `reference_id`, `created_at`) VALUES
(1, 1, 'bonus', 10000, 10000, 'Admin initial balance', 'admin', NULL, '2026-02-02 19:56:33'),
(2, 2, 'bonus', 100, 100, 'Welcome bonus for new registration', 'bonus', NULL, '2026-01-23 19:56:33'),
(3, 2, 'earn', 400, 500, 'Earned from playing Fruit Catch (Score: 850)', 'game', NULL, '2026-01-24 19:56:33'),
(4, 2, 'earn', 250, 750, 'Earned from playing Quiz Master (Score: 420)', 'game', NULL, '2026-01-25 19:56:33'),
(5, 2, 'spend', -250, 500, 'Redeemed: Bronze Badge', 'redemption', NULL, '2026-01-28 19:56:33'),
(6, 3, 'bonus', 100, 100, 'Welcome bonus for new registration', 'bonus', NULL, '2026-01-18 19:56:33'),
(7, 3, 'earn', 600, 700, 'Earned from playing Memory Match (Score: 1200)', 'game', NULL, '2026-01-19 19:56:33'),
(8, 3, 'earn', 500, 1200, 'Earned from playing Sliding Puzzle (Score: 980)', 'game', NULL, '2026-01-21 19:56:33'),
(9, 3, 'earn', 300, 1500, 'Earned from playing Word Scramble (Score: 650)', 'game', NULL, '2026-01-23 19:56:33'),
(10, 3, 'spend', -300, 1200, 'Redeemed: Silver Badge', 'redemption', NULL, '2026-01-26 19:56:33'),
(11, 4, 'bonus', 100, 100, 'Welcome bonus for new registration', 'bonus', NULL, '2026-01-03 19:56:33'),
(12, 4, 'earn', 900, 1000, 'Earned from playing Fruit Catch (Score: 2500)', 'game', NULL, '2026-01-05 19:56:33'),
(13, 4, 'earn', 800, 1800, 'Earned from playing Quiz Master (Score: 950)', 'game', NULL, '2026-01-08 19:56:33'),
(14, 4, 'earn', 700, 2500, 'Earned from playing Memory Match (Score: 1800)', 'game', NULL, '2026-01-11 19:56:33'),
(15, 4, 'earn', 1000, 3500, 'Earned from playing Sliding Puzzle (Score: 3200)', 'game', NULL, '2026-01-15 19:56:33'),
(16, 4, 'earn', 500, 4000, 'Earned from playing Word Scramble (Score: 890)', 'game', NULL, '2026-01-18 19:56:33'),
(17, 4, 'spend', -500, 3500, 'Redeemed: Premium Avatar Pack', 'redemption', NULL, '2026-01-23 19:56:33'),
(18, 5, 'bonus', 100, 100, 'Welcome bonus for new registration', 'bonus', NULL, '2026-02-01 19:56:33'),
(19, 6, 'bonus', 100, 100, 'Welcome bonus for new registration', 'bonus', NULL, '2026-02-03 16:35:37'),
(20, 6, 'spend', -2500, 9997500, 'Redeemed: Double Points Boost (24hr)', 'redemption', NULL, '2026-02-03 17:04:21'),
(21, 6, 'earn', 122, 9997622, 'Earned from playing Fruit Catch (Score: 815)', 'game', 20, '2026-02-03 17:05:20'),
(22, 7, 'bonus', 100, 100, 'Welcome bonus for new registration', 'bonus', NULL, '2026-02-03 17:12:18'),
(23, 7, 'earn', 299, 399, 'Earned from playing Fruit Catch (Score: 1995)', 'game', 22, '2026-02-03 18:39:57'),
(24, 6, 'spend', -100, 9997522, 'Redeemed: Bronze Badge', 'redemption', NULL, '2026-02-04 03:20:08'),
(25, 6, 'earn', 10, 9997532, 'Earned from playing Fruit Catch (Score: 65)', 'game', 24, '2026-02-04 03:28:03'),
(26, 6, 'spend', -8000, 9989532, 'Redeemed: Gaming Mouse Pad', 'redemption', NULL, '2026-02-04 03:29:07'),
(27, 6, 'spend', -8000, 9981532, 'Redeemed: Gaming Mouse Pad', 'redemption', NULL, '2026-02-04 03:29:25'),
(28, 6, 'spend', -2000, 9979532, 'Redeemed: Premium Avatar Pack', 'redemption', NULL, '2026-02-04 03:29:58'),
(29, 7, 'earn', 53, 452, 'Earned from playing Word Scramble (Score: 175)', 'game', 25, '2026-02-04 03:36:46'),
(30, 6, 'earn', 14, 9979546, 'Earned from playing Fruit Catch (Score: 95)', 'game', 26, '2026-02-04 11:23:13'),
(31, 6, 'earn', 53, 9979599, 'Earned from playing Fruit Catch (Score: 350)', 'game', 27, '2026-02-10 12:15:32'),
(32, 6, 'spend', -1500, 9978099, 'Redeemed: Profile Banner', 'redemption', NULL, '2026-02-10 14:37:17'),
(33, 6, 'spend', -1000, 9977099, 'Redeemed: Gold Badge', 'redemption', NULL, '2026-02-10 14:37:59'),
(34, 6, 'spend', -3000, 9974099, 'Redeemed: Custom Username Color', 'redemption', NULL, '2026-02-10 14:38:42'),
(35, 6, 'spend', -5000, 9969099, 'Redeemed: Diamond Badge', 'redemption', NULL, '2026-02-10 14:39:07'),
(36, 6, 'spend', -2500, 9966599, 'Redeemed: Double Points Boost (24hr)', 'redemption', NULL, '2026-02-10 14:40:52'),
(37, 6, 'earn', 129, 9966728, 'Earned from playing Fruit Catch (Score: 860)', 'game', 28, '2026-02-10 14:41:57'),
(38, 6, 'earn', 204, 9966932, 'Earned from playing Fruit Catch (Score: 1360)', 'game', 29, '2026-02-10 14:43:10'),
(39, 6, 'spend', -100, 9966832, 'Redeemed: Bronze Badge', 'redemption', NULL, '2026-02-11 03:03:45'),
(40, 6, 'earn', 192, 9967024, 'Earned from playing Memory Match (Score: 961)', 'game', 30, '2026-02-18 13:54:09'),
(41, 6, 'earn', 141, 9967165, 'Earned from playing Word Scramble (Score: 470)', 'game', 31, '2026-02-18 13:56:09'),
(42, 6, 'spend', -100, 9967065, 'Redeemed: Bronze Badge', 'redemption', NULL, '2026-02-18 13:56:22'),
(43, 6, 'earn', 30, 9967095, 'Earned from playing Fruit Catch (Score: 200)', 'game', 32, '2026-02-18 15:56:44'),
(44, 6, 'earn', 10, 9967105, 'Earned from playing Fruit Catch (Score: 65)', 'game', 33, '2026-02-18 15:57:06'),
(45, 6, 'earn', 53, 9967158, 'Earned from playing Fruit Catch (Score: 355)', 'game', 34, '2026-02-18 16:23:08'),
(46, 6, 'earn', 4, 9967162, 'Earned from playing Memory Match (Score: 20)', 'game', 35, '2026-02-18 16:24:06'),
(47, 6, 'earn', 32, 9967194, 'Earned from playing Memory Match (Score: 160)', 'game', 36, '2026-02-18 17:33:14'),
(48, 6, 'earn', 72, 9967266, 'Earned from playing Fruit Catch (Score: 480)', 'game', 37, '2026-02-18 17:51:30'),
(49, 6, 'earn', 63, 9967329, 'Earned from playing Fruit Catch (Score: 420)', 'game', 38, '2026-02-18 17:52:11'),
(50, 6, 'earn', 77, 9967406, 'Earned from playing Fruit Catch (Score: 515)', 'game', 39, '2026-02-18 17:53:42'),
(51, 6, 'earn', 238, 9967644, 'Earned from playing Fruit Catch (Score: 1585)', 'game', 40, '2026-02-18 17:55:22'),
(52, 6, 'earn', 35, 9967679, 'Earned from playing Fruit Catch (Score: 235)', 'game', 41, '2026-02-18 17:55:30'),
(53, 6, 'earn', 164, 9967843, 'Earned from playing Word Scramble (Score: 545)', 'game', 42, '2026-02-18 18:29:35'),
(54, 7, 'earn', 233, 685, 'Earned from playing Quiz Master (Score: 622)', 'game', 43, '2026-02-18 18:39:39'),
(55, 7, 'earn', 1000, 1685, 'Earned from playing Sliding Puzzle (Score: 5380)', 'game', 44, '2026-02-18 18:44:51'),
(56, 7, 'spend', -100, 1585, 'Redeemed: Bronze Badge', 'redemption', NULL, '2026-02-18 18:45:11'),
(57, 7, 'earn', 60, 1645, 'Earned from playing Sliding Puzzle (Score: 100)', 'game', 45, '2026-02-18 18:57:55'),
(58, 6, 'spend', -8000, 9959843, 'Redeemed: Gaming Mouse Pad', 'redemption', NULL, '2026-02-18 19:49:08'),
(59, 6, 'earn', 8000, 9967843, 'Refund: Redemption rejected - Gaming Mouse Pad', 'redemption', 6, '2026-02-18 19:50:54'),
(60, 6, 'spend', -2500, 9965343, 'Redeemed: PEN', 'redemption', NULL, '2026-02-18 20:23:19'),
(61, 6, 'spend', -3000, 9962343, 'Redeemed: Marker', 'redemption', NULL, '2026-02-18 20:24:33'),
(62, 6, 'spend', -1000, 9961343, 'Redeemed: paperclip', 'redemption', NULL, '2026-02-18 20:25:32'),
(63, 6, 'earn', 59, 9961402, 'Earned from playing Fruit Catch (Score: 390)', 'game', 46, '2026-02-18 20:26:14'),
(64, 6, 'earn', 133, 9961535, 'Earned from playing Fruit Catch (Score: 885)', 'game', 47, '2026-02-19 03:57:36'),
(65, 6, 'earn', 236, 9961771, 'Earned from playing Word Scramble (Score: 785)', 'game', 48, '2026-02-19 04:00:10'),
(66, 6, 'spend', -500, 9961271, 'Redeemed: Yellow Pad', 'redemption', NULL, '2026-02-19 04:23:28'),
(67, 6, 'earn', 45, 9961316, 'Earned from playing Fruit Catch (Score: 300)', 'game', 49, '2026-02-19 04:25:40'),
(68, 6, 'spend', -500, 9960816, 'Redeemed: Yellow Pad', 'redemption', NULL, '2026-02-19 14:57:36'),
(69, 6, 'earn', 85, 9960901, 'Earned from playing Quiz Master (Score: 226)', 'game', 50, '2026-02-19 15:19:53'),
(70, 6, 'earn', 26, 9960927, 'Earned from playing Fruit Catch (Score: 170)', 'game', 51, '2026-02-19 15:23:38'),
(71, 6, 'earn', 92, 9961019, 'Earned from playing Fruit Catch (Score: 615)', 'game', 53, '2026-02-19 15:35:50'),
(72, 6, 'earn', 158, 9961177, 'Earned from playing Fruit Catch (Score: 1050)', 'game', 54, '2026-02-19 15:40:03'),
(73, 6, 'earn', 20, 9961197, 'Earned from playing Fruit Catch (Score: 135)', 'game', 55, '2026-02-19 15:48:51'),
(74, 6, 'earn', 53, 9961250, 'Earned from playing Word Scramble (Score: 175)', 'game', 56, '2026-02-19 16:14:59'),
(75, 6, 'earn', 169, 9961419, 'Earned from playing Quiz Master (Score: 450)', 'game', 57, '2026-02-19 16:22:24'),
(76, 6, 'earn', 670, 9962089, 'Earned from playing Memory Match (Score: 3350)', 'game', 59, '2026-02-19 18:26:58'),
(77, 6, 'spend', -1000, 9961089, 'Redeemed: paperclip', 'redemption', NULL, '2026-02-19 18:30:07'),
(78, 6, 'spend', -1000, 9960089, 'Redeemed: paperclip', 'redemption', NULL, '2026-02-19 18:33:29'),
(79, 6, 'spend', -2000, 9958089, 'Redeemed: Cartolina', 'redemption', NULL, '2026-02-19 18:33:53'),
(80, 6, 'spend', -2000, 9956089, 'Redeemed: Cartolina', 'redemption', NULL, '2026-02-19 18:34:50'),
(81, 6, 'spend', -3000, 9953089, 'Redeemed: Marker', 'redemption', NULL, '2026-02-19 18:51:22'),
(82, 6, 'spend', -500, 9952589, 'Redeemed: Yellow Pad', 'redemption', NULL, '2026-02-19 18:59:33'),
(83, 6, 'spend', -500, 9952089, 'Redeemed: Yellow Pad', 'redemption', NULL, '2026-02-19 19:00:08'),
(84, 6, 'spend', -500, 9951589, 'Redeemed: Yellow Pad', 'redemption', NULL, '2026-02-19 19:01:45'),
(85, 6, 'spend', -500, 9951089, 'Redeemed: Yellow Pad', 'redemption', NULL, '2026-02-19 19:02:29'),
(86, 6, 'spend', -500, 9950589, 'Redeemed: Yellow Pad', 'redemption', NULL, '2026-02-19 19:03:42'),
(87, 6, 'spend', -500, 9950089, 'Redeemed: Yellow Pad', 'redemption', NULL, '2026-02-19 19:06:05'),
(88, 6, 'spend', -500, 9949589, 'Redeemed: Yellow Pad', 'redemption', NULL, '2026-02-19 19:12:55'),
(89, 6, 'spend', -500, 9949089, 'Redeemed: Yellow Pad', 'redemption', NULL, '2026-02-19 19:13:52'),
(90, 6, 'spend', -500, 9948589, 'Redeemed: Yellow Pad', 'redemption', NULL, '2026-02-19 19:15:06'),
(91, 6, 'spend', -500, 9948089, 'Redeemed: Yellow Pad', 'redemption', NULL, '2026-02-19 19:15:43'),
(92, 6, 'spend', -1000, 9947089, 'Redeemed: paperclip', 'redemption', NULL, '2026-02-19 19:18:18'),
(93, 6, 'spend', -500, 9946589, 'Redeemed: Yellow Pad', 'redemption', NULL, '2026-02-19 19:43:53'),
(94, 6, 'spend', -1000, 9945589, 'Redeemed: paperclip', 'redemption', NULL, '2026-02-19 19:46:36'),
(95, 6, 'spend', -1, 9945588, 'Redeemed: asa', 'redemption', NULL, '2026-02-19 19:47:38'),
(96, 6, 'spend', -500, 9945088, 'Redeemed: Yellow Pad', 'redemption', NULL, '2026-02-19 20:00:46'),
(97, 6, 'spend', -1000, 9944088, 'Redeemed: paperclip', 'redemption', NULL, '2026-02-19 20:07:52'),
(98, 6, 'spend', -500, 9943588, 'Redeemed: Yellow Pad', 'redemption', NULL, '2026-02-19 20:26:24'),
(99, 6, 'spend', -1000, 9942588, 'Redeemed: paperclip', 'redemption', NULL, '2026-02-19 20:26:34'),
(100, 6, 'earn', 63, 9942651, 'Earned from playing Fruit Catch (Score: 420)', 'game', 60, '2026-02-20 04:35:04'),
(101, 8, 'bonus', 100, 100, 'Welcome bonus for new registration', 'bonus', NULL, '2026-02-20 23:42:02'),
(102, 8, 'earn', 83, 183, 'Earned from playing Fruit Catch (Score: 550)', 'game', 61, '2026-02-23 05:34:44'),
(103, 8, 'earn', 86, 269, 'Earned from playing Fruit Catch (Score: 570)', 'game', 62, '2026-02-23 05:35:27'),
(104, 7, 'earn', 38, 1683, 'Earned from playing Fruit Catch (Score: 250)', 'game', 63, '2026-02-23 17:05:53'),
(105, 7, 'earn', 29, 1712, 'Earned from playing Fruit Catch (Score: 195)', 'game', 64, '2026-02-23 17:09:53'),
(106, 7, 'earn', 95, 1807, 'Earned from playing Fruit Catch (Score: 630)', 'game', 65, '2026-02-23 17:22:24'),
(107, 6, 'earn', 28, 9942679, 'Earned from playing Fruit Catch (Score: 185)', 'game', 75, '2026-02-23 19:07:18'),
(108, 6, 'spend', -500, 9942179, 'Redeemed: Yellow Pad', 'redemption', NULL, '2026-02-23 19:08:21'),
(109, 6, 'spend', -500, 9941679, 'Redeemed: Yellow Pad', 'redemption', NULL, '2026-02-23 19:14:02'),
(110, 6, 'spend', -1, 9941678, 'Redeemed: asa', 'redemption', NULL, '2026-02-23 19:15:07'),
(111, 6, 'spend', -1, 9941677, 'Redeemed: asa', 'redemption', NULL, '2026-02-23 19:17:11'),
(112, 6, 'spend', -500, 9941177, 'Redeemed: Yellow Pad', 'redemption', NULL, '2026-02-23 19:19:32'),
(113, 6, 'spend', -1, 9941176, 'Redeemed: asa', 'redemption', NULL, '2026-02-23 19:21:21'),
(114, 6, 'spend', -1, 9941175, 'Redeemed: asa', 'redemption', NULL, '2026-02-23 19:24:39'),
(115, 6, 'spend', -1, 9941174, 'Redeemed: asa', 'redemption', NULL, '2026-02-23 19:31:43'),
(116, 6, 'spend', -500, 9940674, 'Redeemed: Yellow Pad', 'redemption', NULL, '2026-02-23 19:40:15'),
(117, 6, 'spend', -1, 9940673, 'Redeemed: asa', 'redemption', NULL, '2026-02-23 19:41:56'),
(118, 6, 'spend', -500, 9940173, 'Redeemed: Yellow Pad', 'redemption', NULL, '2026-02-23 19:42:05'),
(119, 6, 'spend', -1, 9940172, 'Redeemed: asa', 'redemption', NULL, '2026-02-23 19:49:20'),
(120, 6, 'earn', 37, 9940209, 'Earned from playing Fruit Catch (Score: 245)', 'game', 76, '2026-02-23 19:49:41'),
(121, 6, 'spend', -1, 9940208, 'Redeemed: asa', 'redemption', NULL, '2026-02-23 20:00:26'),
(122, 6, 'earn', 500, 9940708, 'Refund: Redemption rejected - Yellow Pad', 'redemption', 54, '2026-02-23 20:01:05'),
(123, 6, 'spend', -1, 9940707, 'Redeemed: asa', 'redemption', NULL, '2026-02-23 20:06:08'),
(124, 6, 'spend', -1, 9940706, 'Redeemed: asa', 'redemption', NULL, '2026-02-23 20:39:20');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('player','admin') DEFAULT 'player',
  `avatar` varchar(255) DEFAULT 'default-avatar.png',
  `status` enum('active','banned','suspended') DEFAULT 'active',
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `last_login` timestamp NULL DEFAULT NULL,
  `login_attempts` int(10) UNSIGNED DEFAULT 0,
  `locked_until` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `role`, `avatar`, `status`, `email_verified_at`, `remember_token`, `last_login`, `login_attempts`, `locked_until`, `created_at`, `updated_at`) VALUES
(1, 'admin', 'admin@gamelibrary.com', 'Admin@123', 'admin', 'default-avatar.png', 'active', '2026-02-02 19:56:33', NULL, NULL, 5, '2026-02-03 09:24:05', '2026-02-02 19:56:33', '2026-02-03 17:09:05'),
(2, 'player1', 'player1@gamelibrary.com', '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'player', 'default-avatar.png', 'active', '2026-02-02 19:56:33', NULL, NULL, 0, NULL, '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(3, 'player2', 'player2@gamelibrary.com', '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'player', 'default-avatar.png', 'active', '2026-02-02 19:56:33', NULL, NULL, 0, NULL, '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(4, 'gamer_pro', 'gamer@gamelibrary.com', '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'player', 'default-avatar.png', 'active', '2026-02-02 19:56:33', NULL, NULL, 0, NULL, '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(5, 'newbie', 'newbie@gamelibrary.com', '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'player', 'default-avatar.png', 'active', '2026-02-02 19:56:33', NULL, NULL, 0, NULL, '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(6, 'PogiHero', 'hero@gmail.com', '$2y$12$yiVAsHoD7fF52IuTEzTQ9u6avptopYxt7fz4/Wj8I1QkzZ.PX86Ae', 'player', 'avatar_6_1770225749.jpg', 'active', NULL, NULL, '2026-02-23 20:39:15', 0, NULL, '2026-02-03 16:35:37', '2026-02-23 20:39:15'),
(7, 'justadmin', 'admin@admin.com', '$2y$12$xmBUHbvvYnPbW0/gvLPryeoYgsPghzW/ZxVY990U6qJPT5n18U9Uu', 'admin', 'avatar_7_1770225216.jpg', 'active', NULL, NULL, '2026-02-23 20:00:47', 0, NULL, '2026-02-03 17:12:18', '2026-02-23 20:00:47'),
(8, 'ririroro', 'ririroro@gmail.com', '$2y$12$PZM7jls6TBqenvx74Jv.q.LtXkiT7B7R3vUax5EJzyIhBjrNRe7Rq', 'player', 'avatar_8_1771821772.jpg', 'active', NULL, NULL, '2026-02-23 04:41:18', 0, NULL, '2026-02-20 23:42:02', '2026-02-23 04:42:58');

-- --------------------------------------------------------

--
-- Table structure for table `user_achievements`
--

CREATE TABLE `user_achievements` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `achievement_id` int(10) UNSIGNED NOT NULL,
  `earned_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_achievements`
--

INSERT INTO `user_achievements` (`id`, `user_id`, `achievement_id`, `earned_at`) VALUES
(1, 2, 1, '2026-01-24 19:56:33'),
(2, 2, 5, '2026-01-26 19:56:33'),
(3, 3, 1, '2026-01-19 19:56:33'),
(4, 3, 2, '2026-01-23 19:56:33'),
(5, 3, 5, '2026-01-25 19:56:33'),
(6, 3, 8, '2026-01-21 19:56:33'),
(7, 4, 1, '2026-01-03 19:56:33'),
(8, 4, 2, '2026-01-08 19:56:33'),
(9, 4, 5, '2026-01-11 19:56:33'),
(10, 4, 6, '2026-01-18 19:56:33'),
(11, 4, 8, '2026-01-05 19:56:33'),
(12, 4, 9, '2026-01-15 19:56:33'),
(13, 4, 11, '2026-01-23 19:56:33'),
(14, 4, 15, '2026-01-11 19:56:33'),
(15, 5, 1, '2026-02-01 19:56:33');

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_game_stats`
-- (See below for the actual view)
--
CREATE TABLE `v_game_stats` (
`id` int(10) unsigned
,`title` varchar(100)
,`slug` varchar(100)
,`category` enum('action','puzzle','word','memory','quiz','arcade')
,`difficulty` enum('easy','medium','hard')
,`play_count` int(10) unsigned
,`points_reward` int(10) unsigned
,`avg_score` decimal(14,4)
,`high_score` decimal(10,0)
,`total_points_awarded` decimal(32,0)
,`unique_players` bigint(21)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_leaderboard_points`
-- (See below for the actual view)
--
CREATE TABLE `v_leaderboard_points` (
`id` int(10) unsigned
,`username` varchar(50)
,`avatar` varchar(255)
,`balance` int(10) unsigned
,`total_earned` int(10) unsigned
,`games_played` bigint(21)
,`last_played` timestamp
);

-- --------------------------------------------------------

--
-- Table structure for table `wallet`
--

CREATE TABLE `wallet` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `balance` int(10) UNSIGNED DEFAULT 0,
  `total_earned` int(10) UNSIGNED DEFAULT 0,
  `total_spent` int(10) UNSIGNED DEFAULT 0,
  `last_transaction_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `wallet`
--

INSERT INTO `wallet` (`id`, `user_id`, `balance`, `total_earned`, `total_spent`, `last_transaction_at`, `created_at`, `updated_at`) VALUES
(1, 1, 10000, 10000, 0, NULL, '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(2, 2, 500, 750, 250, NULL, '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(3, 3, 1200, 1500, 300, NULL, '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(4, 4, 3500, 4000, 500, NULL, '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(5, 5, 100, 100, 0, NULL, '2026-02-02 19:56:33', '2026-02-02 19:56:33'),
(6, 6, 9940706, 12117, 71311, '2026-02-23 20:39:20', '2026-02-03 16:35:37', '2026-02-23 20:39:20'),
(7, 7, 1807, 1907, 100, '2026-02-23 17:22:24', '2026-02-03 17:12:18', '2026-02-23 17:22:24'),
(8, 8, 269, 269, 0, '2026-02-23 05:35:27', '2026-02-20 23:42:02', '2026-02-23 05:35:27');

-- --------------------------------------------------------

--
-- Structure for view `v_game_stats`
--
DROP TABLE IF EXISTS `v_game_stats`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_game_stats`  AS SELECT `g`.`id` AS `id`, `g`.`title` AS `title`, `g`.`slug` AS `slug`, `g`.`category` AS `category`, `g`.`difficulty` AS `difficulty`, `g`.`play_count` AS `play_count`, `g`.`points_reward` AS `points_reward`, coalesce(avg(`s`.`score`),0) AS `avg_score`, coalesce(max(`s`.`score`),0) AS `high_score`, coalesce(sum(`s`.`points_earned`),0) AS `total_points_awarded`, count(distinct `s`.`user_id`) AS `unique_players` FROM (`games` `g` left join `scores` `s` on(`g`.`id` = `s`.`game_id`)) GROUP BY `g`.`id`, `g`.`title`, `g`.`slug`, `g`.`category`, `g`.`difficulty`, `g`.`play_count`, `g`.`points_reward` ;

-- --------------------------------------------------------

--
-- Structure for view `v_leaderboard_points`
--
DROP TABLE IF EXISTS `v_leaderboard_points`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_leaderboard_points`  AS SELECT `u`.`id` AS `id`, `u`.`username` AS `username`, `u`.`avatar` AS `avatar`, `w`.`balance` AS `balance`, `w`.`total_earned` AS `total_earned`, (select count(0) from `scores` where `scores`.`user_id` = `u`.`id`) AS `games_played`, (select max(`scores`.`created_at`) from `scores` where `scores`.`user_id` = `u`.`id`) AS `last_played` FROM (`users` `u` join `wallet` `w` on(`u`.`id` = `w`.`user_id`)) WHERE `u`.`status` = 'active' AND `u`.`role` = 'player' ORDER BY `w`.`total_earned` DESC ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `achievements`
--
ALTER TABLE `achievements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_achievements_game` (`criteria_game_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_criteria_type` (`criteria_type`);

--
-- Indexes for table `activity_log`
--
ALTER TABLE `activity_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_action` (`action`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_ip_address` (`ip_address`);

--
-- Indexes for table `daily_play_limits`
--
ALTER TABLE `daily_play_limits`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_game_date` (`user_id`,`game_id`,`play_date`),
  ADD KEY `fk_daily_limits_game` (`game_id`),
  ADD KEY `idx_play_date` (`play_date`),
  ADD KEY `idx_user_game` (`user_id`,`game_id`);

--
-- Indexes for table `games`
--
ALTER TABLE `games`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_slug` (`slug`),
  ADD KEY `idx_slug` (`slug`),
  ADD KEY `idx_category` (`category`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_featured` (`featured`),
  ADD KEY `idx_sort_order` (`sort_order`),
  ADD KEY `idx_difficulty` (`difficulty`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_token` (`token`),
  ADD KEY `idx_expires_at` (`expires_at`);

--
-- Indexes for table `redemptions`
--
ALTER TABLE `redemptions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_redemptions_admin` (`processed_by`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_reward_id` (`reward_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Indexes for table `rewards`
--
ALTER TABLE `rewards`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_points_cost` (`points_cost`),
  ADD KEY `idx_category` (`category`);

--
-- Indexes for table `scores`
--
ALTER TABLE `scores`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_game_id` (`game_id`),
  ADD KEY `idx_score` (`score`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_user_game` (`user_id`,`game_id`),
  ADD KEY `idx_user_game_date` (`user_id`,`game_id`,`created_at`),
  ADD KEY `idx_points_earned` (`points_earned`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_last_activity` (`last_activity`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_setting_key` (`setting_key`),
  ADD KEY `idx_setting_key` (`setting_key`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_wallet_id` (`wallet_id`),
  ADD KEY `idx_type` (`type`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_reference` (`reference_type`,`reference_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_username` (`username`),
  ADD UNIQUE KEY `unique_email` (`email`),
  ADD KEY `idx_username` (`username`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_role` (`role`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Indexes for table `user_achievements`
--
ALTER TABLE `user_achievements`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_achievement` (`user_id`,`achievement_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_achievement_id` (`achievement_id`),
  ADD KEY `idx_earned_at` (`earned_at`);

--
-- Indexes for table `wallet`
--
ALTER TABLE `wallet`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_wallet` (`user_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_balance` (`balance`),
  ADD KEY `idx_total_earned` (`total_earned`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `achievements`
--
ALTER TABLE `achievements`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `activity_log`
--
ALTER TABLE `activity_log`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=195;

--
-- AUTO_INCREMENT for table `daily_play_limits`
--
ALTER TABLE `daily_play_limits`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;

--
-- AUTO_INCREMENT for table `games`
--
ALTER TABLE `games`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `password_resets`
--
ALTER TABLE `password_resets`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `redemptions`
--
ALTER TABLE `redemptions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT for table `rewards`
--
ALTER TABLE `rewards`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `scores`
--
ALTER TABLE `scores`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=125;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `user_achievements`
--
ALTER TABLE `user_achievements`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `wallet`
--
ALTER TABLE `wallet`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `achievements`
--
ALTER TABLE `achievements`
  ADD CONSTRAINT `fk_achievements_game` FOREIGN KEY (`criteria_game_id`) REFERENCES `games` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `activity_log`
--
ALTER TABLE `activity_log`
  ADD CONSTRAINT `fk_activity_log_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `daily_play_limits`
--
ALTER TABLE `daily_play_limits`
  ADD CONSTRAINT `fk_daily_limits_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_daily_limits_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redemptions`
--
ALTER TABLE `redemptions`
  ADD CONSTRAINT `fk_redemptions_admin` FOREIGN KEY (`processed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_redemptions_reward` FOREIGN KEY (`reward_id`) REFERENCES `rewards` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_redemptions_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `scores`
--
ALTER TABLE `scores`
  ADD CONSTRAINT `fk_scores_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_scores_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `sessions`
--
ALTER TABLE `sessions`
  ADD CONSTRAINT `fk_sessions_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `fk_transactions_wallet` FOREIGN KEY (`wallet_id`) REFERENCES `wallet` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user_achievements`
--
ALTER TABLE `user_achievements`
  ADD CONSTRAINT `fk_user_achievements_achievement` FOREIGN KEY (`achievement_id`) REFERENCES `achievements` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_achievements_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `wallet`
--
ALTER TABLE `wallet`
  ADD CONSTRAINT `fk_wallet_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
