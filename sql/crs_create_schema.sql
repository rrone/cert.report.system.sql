-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jun 21, 2023 at 09:19 AM
-- Server version: 5.7.42-0ubuntu0.18.04.1
-- PHP Version: 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ayso1ref_services`
--
CREATE DATABASE IF NOT EXISTS `ayso1ref_services` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `ayso1ref_services`;

-- --------------------------------------------------------

--
-- Table structure for table `crs_not_available`
--

DROP TABLE IF EXISTS `crs_not_available`;
CREATE TABLE `crs_not_available` (
  `id` int(11) NOT NULL,
  `AYSOID` int(11) DEFAULT NULL,
  `Name` varchar(45) DEFAULT NULL,
  `Reason` varchar(265) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `crs_not_available`
--
ALTER TABLE `crs_not_available`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `crs_not_available`
--
ALTER TABLE `crs_not_available`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
