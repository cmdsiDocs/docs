-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Sep 12, 2025 at 08:56 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.0.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cmdsi`
--

-- --------------------------------------------------------

--
-- Table structure for table `api_menu`
--

CREATE TABLE `api_menu` (
  `menu_id` int(11) NOT NULL,
  `page_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `desc` text DEFAULT NULL,
  `is_main_page` char(1) NOT NULL DEFAULT 'N' CHECK (`is_main_page` in ('Y','N')),
  `parent_menu_id` int(11) DEFAULT NULL,
  `created_on` datetime DEFAULT current_timestamp(),
  `updated_on` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `api_menu`
--

INSERT INTO `api_menu` (`menu_id`, `page_id`, `title`, `desc`, `is_main_page`, `parent_menu_id`, `created_on`, `updated_on`) VALUES
(1, 0, 'luvpark', 'luvpark user', 'Y', NULL, '2025-09-12 11:33:52', '2025-09-12 11:34:21'),
(2, 0, 'Dashboard', 'Test', 'N', 1, '2025-09-12 14:24:01', '2025-09-12 14:24:01'),
(3, 0, 'Login', 'asda', 'N', 1, '2025-09-12 14:52:05', '2025-09-12 14:52:05');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `api_menu`
--
ALTER TABLE `api_menu`
  ADD PRIMARY KEY (`menu_id`),
  ADD KEY `idx_page_id` (`page_id`),
  ADD KEY `idx_parent_menu_id` (`parent_menu_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `api_menu`
--
ALTER TABLE `api_menu`
  MODIFY `menu_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
