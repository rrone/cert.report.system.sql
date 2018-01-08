-- phpMyAdmin SQL Dump
-- version 4.7.6
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jan 08, 2018 at 06:15 PM
-- Server version: 5.6.33-0ubuntu0.14.04.1
-- PHP Version: 7.1.12-3+ubuntu14.04.1+deb.sury.org+1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `wp_ayso1ref`
--
CREATE DATABASE IF NOT EXISTS `wp_ayso1ref` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `wp_ayso1ref`;

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `CertTweaks` ()  BEGIN
# rick roberts
UPDATE `crs_certs` SET `Email` = 'ayso1sra@gmail.com' WHERE `AYSOID` = '97815888';

# Chris Call
UPDATE `crs_certs` SET `AYSOID` = '66280719' WHERE `AYSOID` ='200284566';

# Jon Swasey
UPDATE `crs_certs` SET `AYSOID` = '70161548' WHERE `AYSOID` ='202650542';

# Michael Wolff
DELETE FROM `crs_certs` WHERE `AYSOID` = '56234203' AND `SAR` LIKE '1/D/%';

# Michael Raycraft
DELETE FROM `crs_certs` WHERE `Email` = 'mlraycraft.aysoinstructor@gmail.com';
DELETE FROM `crs_certs` WHERE `Name` = 'Michael Raycraft' AND `CertificationDesc` LIKE 'National Referee Assessor';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `countCerts` ()  BEGIN
SELECT 'crs_1b_certs' as `Certs`, count(*) as 'Count' FROM `crs_1b_certs`
UNION
SELECT 'crs_1c_certs' as `Certs`, count(*) as 'Count' FROM `crs_1c_certs`
UNION
SELECT 'crs_1d_certs' as `Certs`, count(*) as 'Count' FROM `crs_1d_certs`
UNION
SELECT 'crs_1f_certs' as `Certs`, count(*) as 'Count' FROM `crs_1f_certs`
UNION
SELECT 'crs_1g_certs' as `Certs`, count(*) as 'Count' FROM `crs_1g_certs`
UNION
SELECT 'crs_1h_certs' as `Certs`, count(*) as 'Count' FROM `crs_1h_certs`
UNION
SELECT 'crs_1n_certs' as `Certs`, count(*) as 'Count' FROM `crs_1n_certs`
UNION
SELECT 'crs_1p_certs' as `Certs`, count(*) as 'Count' FROM `crs_1p_certs`
UNION
SELECT 'crs_1r_certs' as `Certs`, count(*) as 'Count' FROM `crs_1r_certs`
UNION
SELECT 'crs_1s_certs' as `Certs`, count(*) as 'Count' FROM `crs_1s_certs`
UNION
SELECT 'crs_1u_certs' as `Certs`, count(*) as 'Count' FROM `crs_1u_certs`
UNION
SELECT 'eAYSO.MY2017.certs' as `Certs`, count(*) as 'Count' FROM `eAYSO.MY2017.certs`;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `distinctRegistrations` ()  BEGIN
SELECT DISTINCT `AYSOID`, `Name`, `First Name`, `Last Name`, `Address`, `City`, `State`, `Zip`, `Home Phone`, `Cell Phone`, `Email`, `SAR` FROM wp_ayso1ref.crs_certs
UNION
SELECT DISTINCT `AYSOID`, `Name`, `FirstName` AS 'First Name', `LastName` AS 'Last Name', `Street` AS 'Address', `City`, `State`, `Zip`, `HomePhone`, `BusinessPhone` AS 'Cell Phone', `Email`, CONCAT(`SectionName`, '/', `AreaName`, '/', `RegionNumber`) AS 'SAR' FROM wp_ayso1ref.`eAYSO.MY2017.certs`
ORDER BY `SAR`, `Last Name`, `First Name`;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eAYSOHighestRefCert` (IN `tableName` VARCHAR(128) CHARSET utf8)  MODIFIES SQL DATA
    SQL SECURITY INVOKER
BEGIN

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SET @id:= 0;
SET @dfields := "'National Referee', 'National 2 Referee', 'Advanced Referee', 'Intermediate Referee', 'Regional Referee', 'Regional Referee & Safe Haven Referee', 'z-Online Regional Referee without Safe Haven', 'Z-Online Regional Referee', 'Assistant Referee', 'Assistant Referee & Safe Haven Referee', 'U-8 Official', 'U-8 Official & Safe Haven Referee', 'Z-Online Safe Haven Referee', 'Safe Haven Referee', ''";

SET @s = CONCAT("DROP TABLE IF EXISTS `", tableName, "_highestRefCert`");

PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;

SET @s = CONCAT("
CREATE TABLE `", tableName, "_highestRefCert` SELECT * FROM
    (SELECT 
        `AYSOID`,
            `Name`,
            `FirstName` AS `First Name`,
            `LastName` AS `Last Name`,
            `Street` as `Address`,
            `City`,
            `State`,
            `Zip`,
            `HomePhone` AS `Home Phone`,
            `BusinessPhone` AS `Cell Phone`,
            `Email`,
            `CertificationDesc`,
            `CertDate`,
            `SectionAreaRegion` AS `SAR`,
            `SectionName` AS `Section`,
            `AreaName` AS `Area`,
            `RegionNumber` AS `Region`,
            `Membership Year`
    FROM
        (SELECT 
        *,
            @rank:=IF(@id = `AYSOID`, @rank + 1, 1) AS rank,
            @id:=`AYSOID`
    FROM
        (SELECT 
        *
    FROM
        `", tableName, "`
    WHERE
        `CertificationDesc` LIKE '%Referee%'    
        AND NOT `CertificationDesc` LIKE '%Assessor%'
        AND NOT `CertificationDesc` LIKE '%Instructor%'
        AND NOT `CertificationDesc` LIKE '%Administrator%'
        AND NOT `CertificationDesc` LIKE '%VIP%'
        AND NOT `CertificationDesc` LIKE '%Course%'
        AND NOT `CertificationDesc` LIKE '%Scheduler%'
    GROUP BY `AYSOID` , FIELD(`CertificationDesc`, ", @dfields, ")) ordered) ranked
    WHERE
        rank = 1
    ORDER BY FIELD(`CertificationDesc`, ", @dfields, ") , SAR, `Last Name` , `First Name` , AYSOID) hrc;");
    
PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `init_crs_certs` ()  BEGIN
DROP TABLE IF EXISTS wp_ayso1ref.crs_certs;
CREATE TABLE `crs_certs` (
  `Program Name` text,
  `Membership Year` varchar(12),
  `Volunteer Role` text,
  `AYSOID` int(12),
  `Name` longtext,
  `First Name` text,
  `Last Name` text,
  `Address` text,
  `City` text,
  `State` text,
  `Zip` int(11),
  `Home Phone` text,
  `Cell Phone` text,
  `Email` text,
  `CertificationDesc` text,
  `CertDate` varchar(10) CHARACTER SET utf8,
  `SAR` varchar(98) NOT NULL DEFAULT '',
  `Section` varchar(32) NOT NULL,
  `Area` varchar(32) NOT NULL,
  `Region` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE wp_ayso1ref.crs_certs AUTO_INCREMENT = 0;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `processBSCSV` (`certCSV` VARCHAR(128))  BEGIN
SET @inTable = certCSV;

SET @empty = '';
SET @space = ' ';
SET @delimTS = '/';
SET @delimDate = '/';

SET @s = CONCAT(' INSERT INTO wp_ayso1ref.crs_certs SELECT 
    `Program Name`,
    CONCAT("MY",`Program AYSO Membership Year`) AS `Membership Year`,
    `Volunteer Role`,
    `AYSO Volunteer ID` AS AYSOID,
	PROPER_CASE(CONCAT(`Volunteer First Name`, @space, `Volunteer Last Name`)) AS `Name`,
    PROPER_CASE(`Volunteer First Name`) AS `First Name`,
    PROPER_CASE(`Volunteer Last Name`) AS `Last Name`,
    PROPER_CASE(`Volunteer Address`) AS Address,
    PROPER_CASE(`Volunteer City`) AS City,
    `Volunteer State` AS State,
    `Volunteer Zip` AS Zip,
    `Volunteer Phone` AS `Home Phone`,
    `Volunteer Cell` AS `Cell Phone`,
    LCASE(`Volunteer Email`) AS Email,
    `AYSO Certifications` AS CertificationDesc,
    IF(`Date of Last AYSO Certification Update` = "" OR `Date of Last AYSO Certification Update` IS NULL, "", STR_TO_DATE(REPLACE(SPLIT_STRING(`Date of Last AYSO Certification Update`, " ", 1),"/", "."),GET_FORMAT(DATE,"USA"))) AS `CertDate`,
    IF(sar.`region` IS NULL
            OR sar.`region` = @empty,
        CONCAT(sar.`section`, @delimTS, sar.`area`),
        CONCAT(sar.`section`,
                @delimTS,
                sar.`area`,
                @delimTS,
                sar.`region`)) AS SAR,
    sar.`section` AS Section,
    sar.`area` AS Area,
    sar.`region` AS Region
FROM ',
    @inTable,
    ' csv
        INNER JOIN
    rs_sar sar ON csv.`Portal Name` = sar.`portalName`'
    );

PREPARE stmt FROM @s;  
EXECUTE stmt;  

DEALLOCATE PREPARE stmt;  
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `processEAYSOCSV` (`certCSV` VARCHAR(128))  BEGIN
SET @inTable = certCSV;

SET @s = CONCAT(' INSERT INTO wp_ayso1ref.crs_certs SELECT 
	`Membership Year` AS `Program Name`,
    `Membership Year`,
    "Volunteer" AS `Volunteer Role`,
    `AYSOID`,
	PROPER_CASE(`Name`) AS `Name`,
    PROPER_CASE(`FirstName`) AS `First Name`,
    PROPER_CASE(`LastName`) AS `Last Name`,
    PROPER_CASE(`Street`) AS Address,
    PROPER_CASE(`City`) AS `City`,
    `State`,
    REPLACE(`Zip`,"\'", "") AS `Zip`,
    `HomePhone` AS `Home Phone`,
    `BusinessPhone` AS `Cell Phone`,
    LCASE(`Email`) AS Email,
    `CertificationDesc`,
    IF(`CertDate` = "" OR `CertDate` IS NULL, "", STR_TO_DATE(REPLACE(SPLIT_STRING(`CertDate`, " ", 1),"/", "."),GET_FORMAT(DATE,"USA"))) AS `CertDate`,
    `SectionAreaRegion` AS SAR,
    `SectionName` AS Section,
    `AreaName` AS Area,
    `RegionNumber` AS Region
FROM ',
    @inTable);

PREPARE stmt FROM @s;  
EXECUTE stmt;  

DEALLOCATE PREPARE stmt;  
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `RefreshConcussionCerts` ()  BEGIN
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SET @id:= 0;

DROP TABLE IF EXISTS wp_ayso1ref.crs_tmp_cdc;
SET @s = CONCAT("
CREATE TABLE wp_ayso1ref.crs_tmp_cdc SELECT 
	`Program Name`,
	`Membership Year`,
	`Volunteer Role`,
	`AYSOID`,
	`Name`,
	`First Name`,
	`Last Name`,
	`Address`,
	`City`,
	`State`,
	`Zip`,
	`Home Phone`,
	`Cell Phone`,
	`Email`,
	`CertificationDesc`,
	`CertDate`,
	`SAR`,
	`Section`,
	`Area`,
	`Region`
FROM
    (SELECT 
        *
    FROM
        (SELECT 
        *,
            @rank:=IF(@id = `AYSOID`, @rank + 1, 1) AS rank,
            @id:=`AYSOID`
    FROM (SELECT * FROM 
        wp_ayso1ref.crs_certs
    WHERE
        `CertificationDesc` LIKE '%Concussion%' 
    GROUP BY `AYSOID`, `CertDate` DESC, 
    FIELD(`Program Name`, 'Volunteer Registration - MY17', 'National Volunteer Application (MY2017)', '2017 Fall Core', '2017 Fall Soccer') ) ordered) ranked
WHERE
    rank = 1
ORDER BY `SAR`, `Last Name`) sh;");
    
PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `RefreshHighestCertification` ()  BEGIN
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SET @id:= 0;
SET @dfields := "'National Referee', 'National 2 Referee', 'Advanced Referee', 'Intermediate Referee', 'Regional Referee', 'Regional Referee & Safe Haven Referee', 'z-Online Regional Referee without Safe Haven', 'Z-Online Regional Referee', 'Assistant Referee', 'Assistant Referee & Safe Haven Referee', 'U-8 Official', 'U-8 Official & Safe Haven Referee', 'Z-Online Safe Haven Referee', 'Safe Haven Referee', ''";

DROP TABLE IF EXISTS wp_ayso1ref.crs_tmp_hrc;
SET @s = CONCAT("
CREATE TABLE wp_ayso1ref.crs_tmp_hrc SELECT * FROM
    (SELECT 
        `AYSOID`,
            `Name`,
            `First Name`,
            `Last Name`,
            `Address`,
            `City`,
            `State`,
            `Zip`,
            `Home Phone`,
            `Cell Phone`,
            `Email`,
            `CertificationDesc`,
            `CertDate`,
            `SAR`,
            `Section`,
            `Area`,
            `Region`,
            `Membership Year`
    FROM
        (SELECT 
        *,
            @rank:=IF(@id = `AYSOID`, @rank + 1, 1) AS rank,
            @id:=`AYSOID`
    FROM
        (SELECT 
        *
    FROM
        `crs_refcerts`
    WHERE
        NOT `CertificationDesc` LIKE '%Assessor%'
            AND NOT `CertificationDesc` LIKE '%Instructor%'
            AND NOT `CertificationDesc` LIKE '%Administrator%'
            AND NOT `CertificationDesc` LIKE '%VIP%'
            AND NOT `CertificationDesc` LIKE '%Course%'
            AND NOT `CertificationDesc` LIKE '%Scheduler%'
    GROUP BY `AYSOID` , FIELD(`CertificationDesc`, ", @dfields, ")) ordered) ranked
    WHERE
        rank = 1
    ORDER BY FIELD(`CertificationDesc`, ", @dfields, ") , SAR, `Last Name` , `First Name` , AYSOID) hrc;");
    
PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RefreshNationalRefereeAssessors` ()  BEGIN
DROP TABLE IF EXISTS wp_ayso1ref.crs_tmp_nra;

CREATE TABLE wp_ayso1ref.crs_tmp_nra 
SELECT DISTINCT
--     `AYSOID`,
    `Name`,
--     `Address`,
    `City`,
--   `Home Phone`,
--     `Cell Phone`,
     `Email`,
--     SPLIT_STRING(`Date of Last AYSO Certification Update`,
--             ' ',
--             1) AS CertDate,
    CONCAT(`Section`,'/',`Area`) AS SAR,
    `Membership Year`,
--  `First Name`,
    `Last Name`,
    `CertificationDesc`
FROM
    crs_certs
WHERE
    `CertificationDesc` = 'National Referee Assessor'
ORDER BY `Last Name`, SAR;

END$$

CREATE DEFINER=`root`@`%` PROCEDURE `RefreshRefCerts` ()  BEGIN
DROP TABLE IF EXISTS wp_ayso1ref.crs_refcerts;

CREATE TABLE wp_ayso1ref.crs_refcerts
SELECT * 
	FROM wp_ayso1ref.crs_certs 
	WHERE 
	`CertificationDesc` LIKE '%Referee%';
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `RefreshRefConcussionCerts` ()  BEGIN
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SET @id:= 0;

DROP TABLE IF EXISTS wp_ayso1ref.crs_tmp_ref_cdc;
SET @s = CONCAT("CREATE TABLE wp_ayso1ref.crs_tmp_ref_cdc SELECT 
hrc.*, cdc.CertificationDesc AS CDCCert, cdc.CertDate AS CDCCertDate 
FROM `crs_tmp_cdc` cdc
RIGHT JOIN `crs_tmp_hrc` hrc 
ON cdc.AYSOID = hrc.AYSOID
ORDER BY SAR;");
    
PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `RefreshRefereeAssessors` ()  BEGIN
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SET @id:= 0;

DROP TABLE IF EXISTS wp_ayso1ref.crs_tmp_ra;

CREATE TABLE wp_ayso1ref.crs_tmp_ra SELECT * FROM
    (SELECT 
		`AYSOID`,
        `Name`,
        `First Name`,
        `Last Name`,
        `Address`,
		`City`,
        `State`,
        `Zip`,
        `Home Phone`,
		`Cell Phone`,
        `Email`,
        `CertificationDesc`,
        `CertDate`,
		`SAR`,
        `Section`,
		`Area`,
        `Region`,
        `Membership Year`
    FROM
        (SELECT 
        *,
            @rank:=IF(@id = `AYSOID`, @rank + 1, 1) AS rank,
            @id:=`AYSOID`
    FROM
        (SELECT 
        *
    FROM
        `crs_refcerts`
    WHERE
        `CertificationDesc` LIKE '%Assessor%'
            AND NOT `CertificationDesc` LIKE '%Instructor%'
            AND NOT `CertificationDesc` LIKE '%Administrator%'
            AND NOT `CertificationDesc` LIKE '%VIP%'
            AND NOT `CertificationDesc` LIKE '%Course%'
            AND NOT `CertificationDesc` LIKE 'Regional Referee'
            AND NOT `CertificationDesc` LIKE 'z-Online'
            AND NOT `CertificationDesc` LIKE '%Safe Haven%'
            AND NOT `CertificationDesc` LIKE 'Assistant%'
            AND NOT `CertificationDesc` LIKE '%Official%'
    GROUP BY `AYSOID` , FIELD(`CertificationDesc`, 'National Referee Assessor', 'Referee Assessor')) ordered) ranked
    WHERE
        rank = 1
    ORDER BY CertificationDesc , SAR , `Last Name` , `First Name` , AYSOID) ra;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `RefreshRefereeInstructorEvaluators` ()  BEGIN
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SET @id:= 0;

DROP TABLE IF EXISTS wp_ayso1ref.crs_tmp_rie;

CREATE TABLE wp_ayso1ref.crs_tmp_rie SELECT * FROM
    (SELECT 
        `AYSOID`,
		`Name`,
		`First Name`,
		`Last Name`,
		`Address`,
		`City`,
		`State`,
		`Zip`,
		`Home Phone`,
		`Cell Phone`,
		`Email`,
		`CertificationDesc`,
		`CertDate`,
		`SAR`,
		`Section`,
		`Area`,
		`Region`,
		`Membership Year`
    FROM
        (SELECT 
        *,
            @rank:=IF(@id = `AYSOID`, @rank + 1, 1) AS rank,
            @id:=`AYSOID`
    FROM
        (SELECT 
        *
    FROM
        `crs_refcerts`
    WHERE
        `CertificationDesc` = 'Referee Instructor Evaluator'
    ORDER BY `CertDate` DESC) ordered) ranked
    WHERE
        rank = 1
    ORDER BY Section , Area , Region , `Last Name` , `First Name`) rie;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `RefreshRefereeInstructors` ()  BEGIN
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SET @id:= 0;

DROP TABLE IF EXISTS wp_ayso1ref.crs_tmp_ri;

CREATE TABLE wp_ayso1ref.crs_tmp_ri SELECT * FROM
    (SELECT 
        `AYSOID`,
		`Name`,
		`First Name`,
		`Last Name`,
		`Address`,
		`City`,
		`State`,
		`Zip`,
		`Home Phone`,
		`Cell Phone`,
		`Email`,
		`CertificationDesc`,
		`CertDate`,
		`SAR`,
		`Section`,
		`Area`,
		`Region`,
		`Membership Year`
    FROM
        (SELECT 
        *,
            @rank:=IF(@id = `AYSOID`, @rank + 1, 1) AS rank,
            @id:=`AYSOID`
    FROM
        (SELECT 
        *
    FROM
        `crs_refcerts`
    WHERE
        `CertificationDesc` LIKE '%Instructor%'
            AND NOT `CertificationDesc` LIKE '%Evaluator%'
            AND NOT `CertificationDesc` LIKE '%Assessor%'
            AND NOT `CertificationDesc` LIKE '%Course%'
            AND NOT `CertificationDesc` LIKE '%Regional%'
            AND NOT `CertificationDesc` LIKE '%Assistant%'
            AND NOT `CertificationDesc` LIKE '%Official%'
            AND NOT `CertificationDesc` LIKE '%Webinar%'
            AND NOT `CertificationDesc` LIKE '%Online%'
            AND NOT `CertificationDesc` LIKE '%Safe Haven%'
    GROUP BY `AYSOID` , FIELD(`CertificationDesc`, 'National Referee Instructor', 'Advanced Referee Instructor', 'Referee Instructor', 'Basic Referee Instructor', 'Grade2 Referee Instructor')) ordered) ranked
    WHERE
        rank = 1
    ORDER BY FIELD(`CertificationDesc`, 'National Referee Instructor', 'Advanced Referee Instructor', 'Referee Instructor', 'Basic Referee Instructor', 'Grade2 Referee Instructor', 'Referee Instructor Evaluator') , Section , Area , Region , `Last Name` , `First Name`) ri;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `RefreshRefereeUpgradeCandidates` ()  BEGIN
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DROP TABLE IF EXISTS crs_tmp_ref_upgrades;

CREATE TABLE crs_tmp_ref_upgrades SELECT DISTINCT
    *
FROM
    (SELECT DISTINCT
        course.`Membership Year`,
            course.`AYSOID`,
            course.`Name`,
            course.`First Name`,
            course.`Last Name`,
            course.`Address`,
            course.`City`,
            course.`State`,
            course.`Zip`,
            course.`Home Phone`,
            course.`Cell Phone`,
            course.`Email`,
            course.`CertificationDesc`,
            course.`CertDate`,
            course.`SAR`,
            course.`Section`,
            course.`Area`,
            course.`Region`
    FROM
        (SELECT 
        `Membership Year`,
            `AYSOID`,
            `Name`,
            `First Name`,
            `Last Name`,
            `Address`,
            `City`,
            `State`,
            `Zip`,
            `Home Phone`,
            `Cell Phone`,
            `Email`,
            `CertificationDesc`,
            `CertDate`,
            `SAR`,
            `Section`,
            `Area`,
            `Region`
    FROM
        crs_refcerts
    WHERE
        `CertificationDesc` = 'National Referee Course') course
    LEFT JOIN (SELECT 
        `Membership Year`,
            `AYSOID`,
            `Name`,
            `First Name`,
            `Last Name`,
            `Address`,
            `City`,
            `State`,
            `Zip`,
            `Home Phone`,
            `Cell Phone`,
            `Email`,
            `CertificationDesc`,
            `CertDate`,
            `SAR`,
            `Section`,
            `Area`,
            `Region`
    FROM
        crs_refcerts
    WHERE
        `CertificationDesc` = 'National Referee') upgrade ON course.`AYSOID` = upgrade.`AYSOID`
    WHERE
        upgrade.`CertDate` IS NULL UNION SELECT DISTINCT
        course.`Membership Year`,
            course.`AYSOID`,
            course.`Name`,
            course.`First Name`,
            course.`Last Name`,
            course.`Address`,
            course.`City`,
            course.`State`,
            course.`Zip`,
            course.`Home Phone`,
            course.`Cell Phone`,
            course.`Email`,
            course.`CertificationDesc`,
            course.`CertDate`,
            course.`SAR`,
            course.`Section`,
            course.`Area`,
            course.`Region`
    FROM
        (SELECT 
        `Membership Year`,
            `AYSOID`,
            `Name`,
            `First Name`,
            `Last Name`,
            `Address`,
            `City`,
            `State`,
            `Zip`,
            `Home Phone`,
            `Cell Phone`,
            `Email`,
            `CertificationDesc`,
            `CertDate`,
            `SAR`,
            `Section`,
            `Area`,
            `Region`
    FROM
        crs_refcerts
    WHERE
        `CertificationDesc` = 'Advanced Referee Course') course
    LEFT JOIN (SELECT 
        `Membership Year`,
            `AYSOID`,
            `Name`,
            `First Name`,
            `Last Name`,
            `Address`,
            `City`,
            `State`,
            `Zip`,
            `Home Phone`,
            `Cell Phone`,
            `Email`,
            `CertificationDesc`,
            `CertDate`,
            `SAR`,
            `Section`,
            `Area`,
            `Region`
    FROM
        crs_refcerts
    WHERE
        `CertificationDesc` = 'Advanced Referee') upgrade ON course.`AYSOID` = upgrade.`AYSOID`
    WHERE
        upgrade.`CertDate` IS NULL UNION SELECT DISTINCT
        course.`Membership Year`,
            course.`AYSOID`,
            course.`Name`,
            course.`First Name`,
            course.`Last Name`,
            course.`Address`,
            course.`City`,
            course.`State`,
            course.`Zip`,
            course.`Home Phone`,
            course.`Cell Phone`,
            course.`Email`,
            course.`CertificationDesc`,
            course.`CertDate`,
            course.`SAR`,
            course.`Section`,
            course.`Area`,
            course.`Region`
    FROM
        (SELECT 
        `Membership Year`,
            `AYSOID`,
            `Name`,
            `First Name`,
            `Last Name`,
            `Address`,
            `City`,
            `State`,
            `Zip`,
            `Home Phone`,
            `Cell Phone`,
            `Email`,
            `CertificationDesc`,
            `CertDate`,
            `SAR`,
            `Section`,
            `Area`,
            `Region`
    FROM
        crs_refcerts
    WHERE
        `CertificationDesc` = 'Intermediate Referee Course') course
    LEFT JOIN (SELECT 
        `Membership Year`,
            `AYSOID`,
            `Name`,
            `First Name`,
            `Last Name`,
            `Address`,
            `City`,
            `State`,
            `Zip`,
            `Home Phone`,
            `Cell Phone`,
            `Email`,
            `CertificationDesc`,
            `CertDate`,
            `SAR`,
            `Section`,
            `Area`,
            `Region`
    FROM
        crs_refcerts
    WHERE
        `CertificationDesc` = 'Intermediate Referee') upgrade ON course.`AYSOID` = upgrade.`AYSOID`
    WHERE
        upgrade.`CertDate` IS NULL) candidates
ORDER BY FIELD(`CertificationDesc`,
        'National Referee Course',
        'Advanced Referee Course',
        'Intermediate Referee Course'), `CertDate`;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RefreshRefNoCerts` ()  SQL SECURITY INVOKER
BEGIN    
DROP TABLE IF EXISTS wp_ayso1ref.crs_tmp_nocerts;

CREATE TABLE wp_ayso1ref.crs_tmp_nocerts SELECT * FROM
    (SELECT DISTINCT 
	`AYSOID`, 
	`Name`, 
    `First Name`, 
    `Last Name`, 
    `Address`, 
    `City`, 
    `State`, 
    `Zip`, 
    `Home Phone`, 
    `Cell Phone`, 
    `Email`, 
    `CertificationDesc`, 
    `CertDate`, 
    `SAR`, 
    `Section`, 
    `Area`, 
    `Region`, 
    `Membership Year` 
FROM `crs_certs` 
WHERE `Volunteer Role` LIKE '%Referee%' 
	AND `CertificationDesc` = '' 
ORDER BY `SAR`) nocerts;

END$$

CREATE DEFINER=`root`@`%` PROCEDURE `RefreshSafeHavenCerts` ()  BEGIN
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SET @id:= 0;

DROP TABLE IF EXISTS wp_ayso1ref.crs_tmp_safehaven;
SET @s = CONCAT("
CREATE TABLE wp_ayso1ref.crs_tmp_safehaven SELECT 
	`Program Name`,
	`Membership Year`,
	`Volunteer Role`,
	`AYSOID`,
	`Name`,
	`First Name`,
	`Last Name`,
	`Address`,
	`City`,
	`State`,
	`Zip`,
	`Home Phone`,
	`Cell Phone`,
	`Email`,
	`CertificationDesc`,
	`CertDate`,
	`SAR`,
	`Section`,
	`Area`,
	`Region`
FROM
    (SELECT 
        *
    FROM
        (SELECT 
        *,
            @rank:=IF(@id = `AYSOID`, @rank + 1, 1) AS rank,
            @id:=`AYSOID`
    FROM (SELECT * FROM 
        wp_ayso1ref.crs_certs
    WHERE
        `CertificationDesc` LIKE '%Safe Haven%' AND `CertificationDesc` LIKE '%Referee'
    GROUP BY `AYSOID`, `CertDate` DESC, 
    FIELD(`CertificationDesc`, 'Z-Online AYSOs Safe Haven', 'Safe Haven Referee', 'Regional Referee & Safe Haven Referee', 'Assistant Referee & Safe Haven Referee', 'U-8 Official & Safe Haven Referee'),
    FIELD(`Program Name`, 'Volunteer Registration - MY17', 'National Volunteer Application (MY2017)', '2017 Fall Core', '2017 Fall Soccer') ) ordered) ranked
WHERE
    rank = 1
ORDER BY `SAR`, `Last Name`) sh;");
    
PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `RefreshUnregisteredReferees` ()  BEGIN
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SET @dfields := "'National Referee', 'National 2 Referee', 'Advanced Referee', 'Intermediate Referee', 'Regional Referee', 'Regional Referee & Safe Haven Referee', 'z-Online Regional Referee without Safe Haven', 'Z-Online Regional Referee', 'Assistant Referee', 'Assistant Referee & Safe Haven Referee', 'U-8 Official', 'U-8 Official & Safe Haven Referee', 'Z-Online Safe Haven Referee', 'Safe Haven Referee', ''";


DROP TABLE IF EXISTS crs_tmp_unregistered_refs;

CREATE TABLE crs_tmp_unregistered_refs SELECT eayso.* FROM
    `eAYSO.MY2016.certs_highestRefCert` eayso
        LEFT JOIN
    `crs_tmp_hrc` bs ON eayso.`AYSOID` = bs.`AYSOID`
WHERE
    bs.`AYSOID` IS NULL
ORDER BY `SAR` , FIELD(eayso.`CertificationDesc`, @dfields);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rs_ar1AssignmentMap` (IN `projectKey` VARCHAR(45), `has4th` VARCHAR(45))  BEGIN
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

SET @s = CONCAT("
SELECT ar1 as name, assignor, date, time, division, 0 as crCount, COUNT(ar1) as ar1Count, 0 as ar2Count", has4th, "
FROM `rs_games`
WHERE `projectKey` = '", projectKey, "' 
	AND `ar1` <> ''
GROUP BY `ar1`, `date`, `division`
");

PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rs_ar2AssignmentMap` (IN `projectKey` VARCHAR(45), `has4th` VARCHAR(45))  BEGIN
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

SET @s = CONCAT("
SELECT ar2 as name, assignor, date, time, division, 0 as crCount,  0 as ar1Count, COUNT(ar2) as ar2Count", has4th, "
FROM `rs_games`
WHERE `projectKey` = '", projectKey, "' 
	AND `ar2` <> ''
GROUP BY `ar2`, `date`, `division`
");

PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `rs_crAssignmentMap` (IN `projectKey` VARCHAR(45), `has4th` VARCHAR(45))  BEGIN
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

SET @s = CONCAT("
SELECT cr as name, assignor, date, time, division, COUNT(cr) as crCount, 0 as ar1Count, 0 as ar2Count", has4th, "
FROM `rs_games`
WHERE `projectKey` = '", projectKey, "' 
	AND `cr` <> ''
GROUP BY `cr`, `date`, `division`
");

PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `rs_r4thAssignmentMap` (IN `projectKey` VARCHAR(45), `has4th` VARCHAR(45))  BEGIN
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

SET @s = CONCAT("
SELECT cr as name, assignor, date, time, division, 0 as crCount, 0 as ar1Count, 0 as ar2Count, COUNT(r4th) as r4thCount
FROM `rs_games`
WHERE `projectKey` = '", projectKey, "' 
	AND `r4th` <> ''
GROUP BY `r4th`, `date`, `division`
");

PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateCompositeMYCerts` ()  BEGIN
SET @id:= 0;

DROP TABLE IF EXISTS `s1_composite_my_certs`;

CREATE TABLE `s1_composite_my_certs` SELECT * FROM
    (SELECT 
        AYSOID,
            `Name`,
            `First Name`,
            `Last Name`,
            Address,
            City,
            State,
            Zip,
            `Home Phone`,
            `Cell Phone`,
            Email,
            CertificationDesc,
            CertDate,
            SAR,
            Section,
            Area,
            Region,
            `Membership Year`
    FROM
        (SELECT 
        *,
            @rank:=IF(@id = `AYSOID`, @rank + 1, 1) AS rank,
            @id:=`AYSOID`
    FROM
        (SELECT 
        *
    FROM
        (SELECT 
        AYSOID,
            `Name`,
            `First Name`,
            `Last Name`,
            Address,
            City,
            State,
            REPLACE(`Zip`, '\'', '') AS Zip,
            `Home Phone`,
            `Cell Phone`,
            Email,
            CertificationDesc,
            CertDate,
            SAR,
            Section,
            Area,
            Region,
            `Membership Year`
    FROM
        wp_ayso1ref.`eAYSO.MY2016.certs_highestRefCert` UNION SELECT 
        AYSOID,
            `Name`,
            `First Name`,
            `Last Name`,
            Address,
            City,
            State,
            Zip,
            `Home Phone`,
            `Cell Phone`,
            Email,
            CertificationDesc,
            CertDate,
            SAR,
            Section,
            Area,
            Region,
            `Membership Year`
    FROM
        wp_ayso1ref.crs_tmp_hrc) hrc
    GROUP BY `AYSOID` , FIELD(`Membership Year`, 'MY2018', 'MY2017', 'MY2016')) ordered) ranked
    WHERE
        rank = 1
    ORDER BY SAR) composite;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `UpdateS1CRSTables` ()  BEGIN

CALL `init_crs_certs`();

-- Update all Area BS cert exports
CALL `processBSCSV`('crs_1b_certs');
CALL `processBSCSV`('crs_1c_certs');
CALL `processBSCSV`('crs_1d_certs');
CALL `processBSCSV`('crs_1f_certs');
CALL `processBSCSV`('crs_1g_certs');
CALL `processBSCSV`('crs_1h_certs');
CALL `processBSCSV`('crs_1n_certs');
CALL `processBSCSV`('crs_1p_certs');
CALL `processBSCSV`('crs_1r_certs');
CALL `processBSCSV`('crs_1s_certs');
CALL `processBSCSV`('crs_1u_certs');

-- Update all eAYSO My2017 cert exports

CALL `processEAYSOCSV`('`eAYSO.MY2017.certs`');

-- Apply special cases
CALL `CertTweaks`();

-- Refresh all temporary tables
CALL `RefreshRefCerts`();
-- Delete regional records duplicated at Area & Section Portals
-- DELETE n1 FROM crs_refcerts n1, crs_refcerts n2 WHERE n1.`Name` = n2.`Name` AND n1.`Region` = '';
DELETE n1 FROM crs_refcerts n1, crs_refcerts n2 WHERE n1.`Name` = n2.`Name` AND n1.`Area` = '';

CALL `RefreshHighestCertification`();
CALL `RefreshNationalRefereeAssessors`();
CALL `RefreshRefereeAssessors`();
CALL `RefreshRefereeInstructors`();
CALL `RefreshRefereeInstructorEvaluators`();
CALL `RefreshRefNoCerts`();
CALL `RefreshRefereeUpgradeCandidates`();
CALL `RefreshUnregisteredReferees`();
CALL `RefreshSafeHavenCerts`();
CALL `RefreshConcussionCerts`();
CALL `RefreshRefConcussionCerts`();

-- Update timestamp table
DROP TABLE IF EXISTS `crs_lastUpdate`;
CREATE TABLE `crs_lastUpdate` SELECT NOW() AS timestamp;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `UpdateS1CRSTablesFromImport` ()  BEGIN

CALL `wp_ayso1ref`.`init_crs_certs`();

-- Update all Area BS cert exports
-- CALL `wp_ayso1ref`.`processBSCSV`('crs_1b_certs');
-- CALL `wp_ayso1ref`.`processBSCSV`('crs_1c_certs');
-- CALL `wp_ayso1ref`.`processBSCSV`('crs_1d_certs');
-- CALL `wp_ayso1ref`.`processBSCSV`('crs_1f_certs');
-- CALL `wp_ayso1ref`.`processBSCSV`('crs_1g_certs');
-- CALL `wp_ayso1ref`.`processBSCSV`('crs_1h_certs');
-- CALL `wp_ayso1ref`.`processBSCSV`('crs_1n_certs');
-- CALL `wp_ayso1ref`.`processBSCSV`('crs_1p_certs');
-- CALL `wp_ayso1ref`.`processBSCSV`('crs_1r_certs');
-- CALL `wp_ayso1ref`.`processBSCSV`('crs_1s_certs');
-- CALL `wp_ayso1ref`.`processBSCSV`('crs_1u_certs');

CALL `wp_ayso1ref`.`processBSCSV`('crs_import');

-- Update all eAYSO My2017 cert exports

CALL `wp_ayso1ref`.`processEAYSOCSV`('`eAYSO.MY2017.certs`');

-- Apply special cases
CALL `wp_ayso1ref`.`CertTweaks`();

-- Refresh all temporary tables
CALL `RefreshRefCerts`();
-- Delete regional records duplicated at Area & Section Portals
DELETE n1 FROM crs_refcerts n1, crs_refcerts n2 WHERE n1.`Name` = n2.`Name` AND n1.`Region` = '';
DELETE n1 FROM crs_refcerts n1, crs_refcerts n2 WHERE n1.`Name` = n2.`Name` AND n1.`Area` = '';

CALL `RefreshHighestCertification`();
CALL `RefreshNationalRefereeAssessors`();
CALL `RefreshRefereeAssessors`();
CALL `RefreshRefereeInstructors`();
CALL `RefreshRefereeInstructorEvaluators`();
CALL `RefreshRefNoCerts`();

-- Update timestamp table
DROP TABLE IF EXISTS `crs_lastUpdate`;
CREATE TABLE `crs_lastUpdate` SELECT NOW() AS timestamp;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `zUpdate_MasterScript` ()  BEGIN

CALL `wp_ayso1ref`.`UpdateS1CRSTables`();

CALL `wp_ayso1ref`.`UpdateCompositeMYCerts`();

SELECT * FROM `s1_composite_my_certs`;

END$$

--
-- Functions
--
CREATE DEFINER=`root`@`%` FUNCTION `PROPER_CASE` (`str` VARCHAR(255)) RETURNS VARCHAR(255) CHARSET utf8 BEGIN 
  DECLARE c CHAR(1); 
  DECLARE s VARCHAR(255); 
  DECLARE i INT DEFAULT 1; 
  DECLARE bool INT DEFAULT 1; 
  DECLARE punct CHAR(18) DEFAULT ' ()[]{},.-_!@;:?/';
  SET s = LCASE( str ); 
  WHILE i <= LENGTH( str ) DO -- Jesse Palmer corrected from < to <= for last char 
    BEGIN 
      SET c = SUBSTRING( s, i, 1 ); 
      IF LOCATE( c, punct ) > 0 THEN 
        SET bool = 1; 
      ELSEIF bool=1 THEN  
        BEGIN 
          IF c >= 'a' AND c <= 'z' THEN  
            BEGIN 
              SET s = CONCAT(LEFT(s,i-1),UCASE(c),SUBSTRING(s,i+1)); 
              SET bool = 0; 
            END; 
          ELSEIF c >= '0' AND c <= '9' THEN 
            SET bool = 0; 
          END IF; 
        END; 
      END IF; 
      SET i = i+1; 
    END; 
  END WHILE; 
  RETURN s; 
END$$

CREATE DEFINER=`root`@`%` FUNCTION `SPLIT_STRING` (`str` VARCHAR(255), `delim` VARCHAR(12), `pos` INT) RETURNS VARCHAR(255) CHARSET utf8 BEGIN
RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(str, delim, pos),
       LENGTH(SUBSTRING_INDEX(str, delim, pos-1)) + 1),
       delim, '');
RETURN 1;
END$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
