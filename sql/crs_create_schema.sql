-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Nov 29, 2018 at 08:42 PM
-- Server version: 5.7.24-0ubuntu0.18.04.1
-- PHP Version: 7.2.10-0ubuntu0.18.04.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
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
-- Table structure for table `crs_rpt_lastUpdate`
--

DROP TABLE IF EXISTS `crs_rpt_lastUpdate`;
CREATE TABLE `crs_rpt_lastUpdate` (
  `timestamp` datetime NOT NULL DEFAULT '1901-01-01 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `crs_rpt_lastUpdate`
--
ALTER TABLE `crs_rpt_lastUpdate`
  ADD UNIQUE KEY `timestamp` (`timestamp`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
