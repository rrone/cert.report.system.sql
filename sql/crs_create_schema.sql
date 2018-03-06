-- phpMyAdmin SQL Dump
-- version 4.7.9
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Mar 06, 2018 at 05:05 PM
-- Server version: 5.6.33-0ubuntu0.14.04.1
-- PHP Version: 7.1.14-1+ubuntu14.04.1+deb.sury.org+1

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
DROP PROCEDURE IF EXISTS `CertTweaks`$$
CREATE DEFINER=`root`@`%` PROCEDURE `CertTweaks` ()  BEGIN
# rick roberts
UPDATE `crs_certs` SET `Email` = 'ayso1sra@gmail.com' WHERE `AYSOID` = 97815888;

# Chris Call
UPDATE `crs_certs` SET `AYSOID` = 66280719 WHERE `AYSOID` ='200284566';

# Jon Swasey
UPDATE `crs_certs` SET `AYSOID` = 70161548 WHERE `AYSOID` ='202650542';

# Michael Wolff
DELETE FROM `crs_certs` WHERE `AYSOID` = 56234203 AND `SAR` LIKE '1/D/%';

# Michael Raycraft
DELETE FROM `crs_certs` WHERE `Email` = 'mlraycraft.aysoinstructor@gmail.com';
DELETE FROM `crs_certs` WHERE `Name` = 'Michael Raycraft' AND `CertificationDesc` LIKE 'National Referee Assessor';

# Peter Fink
DELETE FROM `crs_certs` WHERE `AYSOID` = 203686950;

# Robert Osborne duplicate eAYSO record
DELETE FROM `eAYSO.MY2016.certs` WHERE `AYSOID` = 79403530;
DELETE FROM `crs_certs` WHERE `AYSOID` = 79403530;
 
# Invalid National Referee Assessors
# Yui-Bin	Chen
DELETE FROM `crs_certs` WHERE `AYSOID` = 57071121 AND `CertificationDesc` LIKE 'National Referee Assessor';
# Geoffrey	Falk
DELETE FROM `crs_certs` WHERE `AYSOID` = 59244326 AND `CertificationDesc` LIKE 'National Referee Assessor';
# Jody	Kinsey
DELETE FROM `crs_certs` WHERE `AYSOID` = 96383441 AND `CertificationDesc` LIKE 'National Referee Assessor';
# Bruce	Hancock
DELETE FROM `crs_certs` WHERE `AYSOID` = 99871834 AND `CertificationDesc` LIKE 'National Referee Assessor';
# Donald Ramsay
DELETE FROM `crs_certs` WHERE `AYSOID` = 204673909 AND `CertificationDesc` LIKE 'Referee Instructor Evaluator';

# Matt Kilroy
DELETE FROM `crs_certs` WHERE `Name` = 'Regional Commissioner';

END$$

DROP PROCEDURE IF EXISTS `compileVolIDs`$$
CREATE DEFINER=`root`@`%` PROCEDURE `compileVolIDs` ()  BEGIN
	DROP TABLE IF EXISTS `crs_vol_ids`;

	CREATE TABLE `crs_vol_ids` SELECT * FROM
		(SELECT DISTINCT
			`AYSO Volunteer ID` AS `AYSOID`
		FROM
			`crs_1_certs` 
		WHERE NOT `AYSO Volunteer ID` IS NULL    
			UNION SELECT DISTINCT
			`AYSOID`
		FROM
			`eAYSO.MY2017.certs` 
		WHERE length(`AYSOID`) > 3
			UNION SELECT DISTINCT
			`AYSOID`
		FROM
			`eAYSO.MY2016.certs`
		WHERE length(`AYSOID`) > 3
		) a
	ORDER BY `AYSOID`;

	SELECT * FROM `crs_vol_ids`;
END$$

DROP PROCEDURE IF EXISTS `countCerts`$$
CREATE DEFINER=`root`@`%` PROCEDURE `countCerts` ()  BEGIN
SELECT 'crs_1b_certs' as `Certs`, count(*) as 'Count' FROM `crs_certs` WHERE `Area` = 'B'
UNION
SELECT 'crs_1c_certs' as `Certs`, count(*) as 'Count' FROM `crs_certs` WHERE `Area` = 'C'
UNION
SELECT 'crs_1d_certs' as `Certs`, count(*) as 'Count' FROM `crs_certs` WHERE `Area` = 'D'
UNION
SELECT 'crs_1f_certs' as `Certs`, count(*) as 'Count' FROM `crs_certs` WHERE `Area` = 'F'
UNION
SELECT 'crs_1g_certs' as `Certs`, count(*) as 'Count' FROM `crs_certs` WHERE `Area` = 'G'
UNION
SELECT 'crs_1h_certs' as `Certs`, count(*) as 'Count' FROM `crs_certs` WHERE `Area` = 'H'
UNION
SELECT 'crs_1n_certs' as `Certs`, count(*) as 'Count' FROM `crs_certs` WHERE `Area` = 'N'
UNION
SELECT 'crs_1p_certs' as `Certs`, count(*) as 'Count' FROM `crs_certs` WHERE `Area` = 'P'
UNION
SELECT 'crs_1r_certs' as `Certs`, count(*) as 'Count' FROM `crs_certs` WHERE `Area` = 'R'
UNION
SELECT 'crs_1s_certs' as `Certs`, count(*) as 'Count' FROM `crs_certs` WHERE `Area` = 'S'
UNION
SELECT 'crs_1u_certs' as `Certs`, count(*) as 'Count' FROM `crs_certs` WHERE `Area` = 'U'
UNION
SELECT 'eAYSO.MY2017.certs' as `Certs`, count(*) as 'Count' FROM `eAYSO.MY2017.certs`
UNION
SELECT 'eAYSO.MY2016.certs' as `Certs`, count(*) as 'Count' FROM `eAYSO.MY2016.certs`;
END$$

DROP PROCEDURE IF EXISTS `distinctRegistrations`$$
CREATE DEFINER=`root`@`%` PROCEDURE `distinctRegistrations` ()  BEGIN
SELECT DISTINCT `AYSOID`, `Name`, `First Name`, `Last Name`, `Address`, `City`, `State`, `Zip`, `Home Phone`, `Cell Phone`, `Email`, `Gender`,`SAR` FROM wp_ayso1ref.crs_certs
UNION
SELECT DISTINCT `AYSOID`, `Name`, `FirstName` AS 'First Name', `LastName` AS 'Last Name', `Street` AS 'Address', `City`, `State`, `Zip`, `HomePhone`, `BusinessPhone` AS 'Cell Phone', `Email`, `Gender`, CONCAT(`SectionName`, '/', `AreaName`, '/', `RegionNumber`) AS 'SAR' FROM wp_ayso1ref.`eAYSO.MY2017.certs`
ORDER BY `SAR`, `Last Name`, `First Name`;
END$$

DROP PROCEDURE IF EXISTS `eAYSOHighestRefCert`$$
CREATE DEFINER=`root`@`%` PROCEDURE `eAYSOHighestRefCert` (`tableName` VARCHAR(128))  BEGIN

SET @id:= 0;
SET @dfields := "'National Referee', 'National 2 Referee', 'Advanced Referee', 'Intermediate Referee', 'Regional Referee', 'Regional Referee & Safe Haven Referee', 'z-Online Regional Referee without Safe Haven', 'Z-Online Regional Referee', 'Assistant Referee', 'Assistant Referee & Safe Haven Referee', 'U-8 Official', 'U-8 Official & Safe Haven Referee', 'Z-Online Safe Haven Referee', 'Safe Haven Referee', ''";
SET @fromTableName = CONCAT("`", tableName, "`");
SET @newTableName = CONCAT("`", tableName, '_highestRefCert`');

SET @s = CONCAT("DROP TABLE IF EXISTS ", @newTableName);

PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;

SET @s = CONCAT("
CREATE TABLE ", @newTableName, " SELECT * FROM
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
            `Gender`,
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
        ", @fromTableName, "
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

DROP PROCEDURE IF EXISTS `prepEAYSOCSVTable`$$
CREATE DEFINER=`root`@`%` PROCEDURE `prepEAYSOCSVTable` (`certTable` VARCHAR(128))  BEGIN
SET @eaysoTable = CONCAT("`", certTable, "`");

SET @s = CONCAT("
	DROP TABLE IF EXISTS ", @eaysoTable, ";
");

PREPARE stmt FROM @s;  
EXECUTE stmt;  

DEALLOCATE PREPARE stmt;
    
SET @s = CONCAT("
	CREATE TABLE ", @eaysoTable," (
	  `AYSOID` text,
	  `Name` text,
	  `Street` text,
	  `City` text,
	  `State` text,
	  `Zip` text,
	  `HomePhone` text,
	  `BusinessPhone` text,
	  `Email` text,
	  `CertificationDesc` text,
	  `Gender` text,
	  `SectionAreaRegion` text,
	  `CertDate` text,
	  `ReCertDate` text,
	  `FirstName` text,
	  `LastName` text,
	  `SectionName` text,
	  `AreaName` text,
	  `RegionNumber` text,
	  `Membership Year` text
	) ENGINE=InnoDB DEFAULT CHARSET=latin1;
");

PREPARE stmt FROM @s;  
EXECUTE stmt;  

DEALLOCATE PREPARE stmt;
END$$

DROP PROCEDURE IF EXISTS `processBSCSV`$$
CREATE DEFINER=`root`@`%` PROCEDURE `processBSCSV` (`certCSV` VARCHAR(128))  BEGIN
SET @inTable = CONCAT("`", certCSV, "`");

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
    `Gender`,
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

DROP PROCEDURE IF EXISTS `processEAYSOCSV`$$
CREATE DEFINER=`root`@`%` PROCEDURE `processEAYSOCSV` (`certTable` VARCHAR(128))  BEGIN
SET @inTable = CONCAT("`", certTable, "`");

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
    `Gender`,
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

DROP PROCEDURE IF EXISTS `RefreshCertDateErrors`$$
CREATE DEFINER=`root`@`%` PROCEDURE `RefreshCertDateErrors` ()  BEGIN
DROP TABLE IF EXISTS `crs_tmp_cert_date_errors`;
SET @s = CONCAT("CREATE TABLE `crs_tmp_cert_date_errors`
SELECT 
    *
FROM
    (SELECT DISTINCT
        c.`Membership Year`,
		c.`AYSOID`,
		c.`Name`,
		c.`CertificationDesc` AS `Course Desc`,
		c.`CertDate` AS `Course Date`,
		u.`CertificationDesc` AS `Upgrade Desc`,
		u.`CertDate` AS `Upgrade Date`,
		c.`Section`,
		c.`Area`,
		c.`Region`
    FROM
        crs_certs c
    INNER JOIN crs_certs u ON c.AYSOID = u.AYSOID
        AND ABS(DATEDIFF(c.`CertDate`, u.`CertDate`)) < 7
    WHERE
        c.`CertificationDesc` LIKE 'National Referee Course'
            AND u.`CertificationDesc` LIKE 'National Referee' UNION SELECT DISTINCT
        c.`Membership Year`,
		c.`AYSOID`,
		c.`Name`,
		c.`CertificationDesc` AS `Course Desc`,
		c.`CertDate` AS `Course Date`,
		u.`CertificationDesc` AS `Upgrade Date`,
		u.`CertDate` AS `Upgrade Desc`,
		c.`Section`,
		c.`Area`,
		c.`Region`
    FROM
        crs_certs c
    INNER JOIN crs_certs u ON c.AYSOID = u.AYSOID
        AND ABS(DATEDIFF(c.`CertDate`, u.`CertDate`)) < 7
    WHERE
        c.`CertificationDesc` LIKE 'Advanced Referee Course'
            AND u.`CertificationDesc` LIKE 'Avanced Referee' UNION SELECT DISTINCT
        c.`Membership Year`,
            c.`AYSOID`,
            c.`Name`,
            c.`CertificationDesc` AS `Course Desc`,
            c.`CertDate` AS `Course Date`,
            u.`CertificationDesc` AS `Upgrade Date`,
            u.`CertDate` AS `Upgrade Desc`,
            c.`Section`,
            c.`Area`,
            c.`Region`
    FROM
        crs_certs c
    INNER JOIN crs_certs u ON c.AYSOID = u.AYSOID
        AND ABS(DATEDIFF(c.`CertDate`, u.`CertDate`)) < 7
    WHERE
        c.`CertificationDesc` LIKE 'Intermediate Referee Course'
            AND u.`CertificationDesc` LIKE 'Intermediate Referee' UNION SELECT DISTINCT
        c.`Membership Year`,
		c.`AYSOID`,
		c.`Name`,
		c.`CertificationDesc` AS `Course Desc`,
		c.`CertDate` AS `Course Date`,
		u.`CertificationDesc` AS `Upgrade Date`,
		u.`CertDate` AS `Upgrade Desc`,
		c.`Section`,
		c.`Area`,
		c.`Region`
    FROM
        crs_certs c
    INNER JOIN crs_certs u ON c.AYSOID = u.AYSOID
        AND ABS(DATEDIFF(c.`CertDate`, u.`CertDate`)) < 7
    WHERE
        c.`CertificationDesc` LIKE 'National Referee Assessor Course'
            AND u.`CertificationDesc` LIKE 'National Referee Assessor' UNION SELECT DISTINCT
        c.`Membership Year`,
		c.`AYSOID`,
		c.`Name`,
		c.`CertificationDesc` AS `Course Desc`,
		c.`CertDate` AS `Course Date`,
		u.`CertificationDesc` AS `Upgrade Desc`,
		u.`CertDate` AS `Upgrade Desc`,
		c.`Section`,
		c.`Area`,
		c.`Region`
    FROM
        crs_certs c
    INNER JOIN crs_certs u ON c.AYSOID = u.AYSOID
        AND ABS(DATEDIFF(c.`CertDate`, u.`CertDate`)) < 7
    WHERE
        c.`CertificationDesc` LIKE 'Referee Assessor Course'
            AND u.`CertificationDesc` LIKE 'Referee Assessor' UNION SELECT DISTINCT
        c.`Membership Year`,
            c.`AYSOID`,
            c.`Name`,
            c.`CertificationDesc` AS `Course Desc`,
            c.`CertDate` AS `Course Date`,
            u.`CertificationDesc` AS `Upgrade Date`,
            u.`CertDate` AS `Upgrade Desc`,
            c.`Section`,
            c.`Area`,
            c.`Region`
    FROM
        crs_certs c
    INNER JOIN crs_certs u ON c.AYSOID = u.AYSOID
        AND ABS(DATEDIFF(c.`CertDate`, u.`CertDate`)) < 7
    WHERE
        c.`CertificationDesc` LIKE 'Advanced Referee Instructor Course'
            AND u.`CertificationDesc` LIKE 'Advanced Referee Instructor' UNION SELECT DISTINCT
        c.`Membership Year`,
		c.`AYSOID`,
		c.`Name`,
		c.`CertificationDesc` AS `Course Desc`,
		c.`CertDate` AS `Course Date`,
		u.`CertificationDesc` AS `Upgrade Date`,
		u.`CertDate` AS `Upgrade Desc`,
		c.`Section`,
		c.`Area`,
		c.`Region`
    FROM
        crs_certs c
    INNER JOIN crs_certs u ON c.AYSOID = u.AYSOID
        AND ABS(DATEDIFF(c.`CertDate`, u.`CertDate`)) < 7
    WHERE
        c.`CertificationDesc` LIKE 'Referee Instructor Course'
            AND u.`CertificationDesc` LIKE 'Referee Instructor' UNION SELECT DISTINCT
        c.`Membership Year`,
		c.`AYSOID`,
		c.`Name`,
		c.`CertificationDesc` AS `Course Desc`,
		c.`CertDate` AS `Course Date`,
		u.`CertificationDesc` AS `Upgrade Date`,
		u.`CertDate` AS `Upgrade Desc`,
		c.`Section`,
		c.`Area`,
		c.`Region`
    FROM
        crs_certs c
    INNER JOIN crs_certs u ON c.AYSOID = u.AYSOID
        AND ABS(DATEDIFF(c.`CertDate`, u.`CertDate`)) < 7
    WHERE
        c.`CertificationDesc` LIKE 'Referee Instructor Evaluator Course'
            AND u.`CertificationDesc` LIKE 'Referee Instructor Evaluator') a
GROUP BY `Name`
ORDER BY FIELD(`Upgrade Desc`,
        'National Referee',
        'Advanced Referee',
        'Intermediate Referee',
        'National Referee Assessor',
        'Referee Assessor',
        'Referee Instructor',
        'Advanced Referee Instructor',
        'Referee Instructor Evaluator') , `Section` , `Area` , `Region`");

PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;

END$$

DROP PROCEDURE IF EXISTS `RefreshConcussionCerts`$$
CREATE DEFINER=`root`@`%` PROCEDURE `RefreshConcussionCerts` ()  BEGIN
SET @id:= 0;

DROP TABLE IF EXISTS crs_tmp_cdc;
SET @s = CONCAT("
CREATE TABLE crs_tmp_cdc SELECT 
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
    `Gender`,
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
        crs_certs
    WHERE
        `CertificationDesc` LIKE '%Concussion%' 
    GROUP BY `AYSOID`, `CertDate` DESC, `Membership Year` DESC) con ) ordered) ranked
WHERE
    rank = 1
ORDER BY `Section` , `Area` , `Region` , `Last Name`;");
    
PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;
END$$

DROP PROCEDURE IF EXISTS `RefreshHighestCertification`$$
CREATE DEFINER=`root`@`%` PROCEDURE `RefreshHighestCertification` ()  BEGIN
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SET @id:= 0;
SET @dfields := "'National Referee', 'National 2 Referee', 'Advanced Referee', 'Intermediate Referee', 'Regional Referee', 'Regional Referee & Safe Haven Referee', 'z-Online Regional Referee without Safe Haven', 'Z-Online Regional Referee', 'Assistant Referee', 'Assistant Referee & Safe Haven Referee', 'U-8 Official', 'U-8 Official & Safe Haven Referee', 'Z-Online Safe Haven Referee', 'Safe Haven Referee', ''";

DROP TABLE IF EXISTS crs_tmp_hrc;
SET @s = CONCAT("
	CREATE TABLE wp_ayso1ref.crs_tmp_hrc SELECT * FROM (
		SELECT 
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
				`Gender`,
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
		ORDER BY FIELD(`CertificationDesc`, ", @dfields, "), `Section` , `Area` , `Region`, `Last Name` , `First Name` , AYSOID) hrc;
");

PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;
END$$

DROP PROCEDURE IF EXISTS `RefreshNationalRefereeAssessors`$$
CREATE DEFINER=`root`@`%` PROCEDURE `RefreshNationalRefereeAssessors` ()  BEGIN
SET @id:= 0;

DROP TABLE IF EXISTS wp_ayso1ref.crs_tmp_nra;

CREATE TABLE wp_ayso1ref.crs_tmp_nra SELECT * FROM
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
        `CertificationDesc` LIKE 'National Referee Assessor' AND
        (`Membership Year` = 'MY2018' OR `Membership Year` = 'MY2017')
    GROUP BY `AYSOID` ) ordered) ranked
    WHERE
        rank = 1
	GROUP BY `Email`
    ORDER BY CertificationDesc , `Section` , `Area` , `Region` , `Last Name` , `First Name` , AYSOID) ra;
END$$

DROP PROCEDURE IF EXISTS `RefreshRefCerts`$$
CREATE DEFINER=`root`@`%` PROCEDURE `RefreshRefCerts` ()  BEGIN
DROP TABLE IF EXISTS crs_refcerts;

CREATE TABLE crs_refcerts
SELECT * 
	FROM crs_certs 
	WHERE 
	`CertificationDesc` LIKE '%Referee%';
END$$

DROP PROCEDURE IF EXISTS `RefreshRefConcussionCerts`$$
CREATE DEFINER=`root`@`%` PROCEDURE `RefreshRefConcussionCerts` ()  BEGIN
SET @id:= 0;

DROP TABLE IF EXISTS crs_tmp_ref_cdc;
SET @s = CONCAT("CREATE TABLE crs_tmp_ref_cdc SELECT 
hrc.*, cdc.CertificationDesc AS CDCCert, cdc.CertDate AS CDCCertDate 
FROM `crs_tmp_cdc` cdc
RIGHT JOIN `crs_tmp_hrc` hrc 
ON cdc.AYSOID = hrc.AYSOID
ORDER BY `Section`, `Area`, `Region`;");
    
PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;
END$$

DROP PROCEDURE IF EXISTS `RefreshRefereeAssessors`$$
CREATE DEFINER=`root`@`%` PROCEDURE `RefreshRefereeAssessors` ()  BEGIN
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
    GROUP BY `Email`
    ORDER BY CertificationDesc , `Section` , `Area` , `Region` , `Last Name` , `First Name` , AYSOID) ra;
END$$

DROP PROCEDURE IF EXISTS `RefreshRefereeInstructorEvaluators`$$
CREATE DEFINER=`root`@`%` PROCEDURE `RefreshRefereeInstructorEvaluators` ()  BEGIN
SET @id:= 0;

DROP TABLE IF EXISTS wp_ayso1ref.crs_tmp_rie;

CREATE TABLE wp_ayso1ref.crs_tmp_rie SELECT DISTINCT * FROM
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
		`CertificationDesc` AS 'InstructorEvaluatorCert',
		`CertDate` AS 'InstructorEvaluatorCertDate',
		`ARCert` AS 'RefereeInstructorCert',
        `ARCertDate` AS 'RefereeInstructorCertDate',
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
        rc.*,
		ar.`CertificationDesc` AS 'ARCert',
        ar.`CertDate` AS 'ARCertDate'
    FROM
        `crs_refcerts` rc INNER JOIN `crs_refcerts` ar ON rc.AYSOID = ar.AYSOID
    WHERE
        rc.`CertificationDesc` = 'Referee Instructor Evaluator'
            AND (rc.`Membership Year` = 'MY2018' OR rc.`Membership Year` = 'MY2017')
            AND ar.`CertificationDesc` LIKE '%Referee Instructor'
    ORDER BY rc.`CertDate` DESC) ordered) ranked
    WHERE
        rank = 1
    ORDER BY `Section`, `Area`, `Region`, `Last Name`, `First Name`) rie;

END$$

DROP PROCEDURE IF EXISTS `RefreshRefereeInstructors`$$
CREATE DEFINER=`root`@`%` PROCEDURE `RefreshRefereeInstructors` ()  BEGIN
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
    ORDER BY FIELD(`CertificationDesc`, 'National Referee Instructor', 'Advanced Referee Instructor', 'Referee Instructor', 'Basic Referee Instructor', 'Grade2 Referee Instructor', 'Referee Instructor Evaluator') , `Section` , `Area` , `Region` , `Last Name` , `First Name`) ri;
END$$

DROP PROCEDURE IF EXISTS `RefreshRefereeUpgradeCandidates`$$
CREATE DEFINER=`root`@`%` PROCEDURE `RefreshRefereeUpgradeCandidates` ()  BEGIN
DROP TABLE IF EXISTS tmp_ref_upgrades;

-- Select National Referee Candidates / Course but not Referee
DROP TABLE IF EXISTS tmp_NatRC;

CREATE TABLE tmp_NatRC SELECT * FROM
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
        `CertificationDesc` = 'National Referee Course'
    GROUP BY `AYSOID` , `Membership Year` DESC) ordered) ranked
WHERE
    rank = 1;

DROP TABLE IF EXISTS tmp_NatR;

CREATE TABLE tmp_NatR SELECT `AYSOID`, `CertDate` FROM
    crs_refcerts
WHERE
    `CertificationDesc` = 'National Referee';

CREATE TABLE tmp_ref_upgrades SELECT DISTINCT course.`AYSOID`,
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
    course.`Gender`,
    course.`CertificationDesc`,
    course.`CertDate`,
    course.`SAR`,
    course.`Section`,
    course.`Area`,
    course.`Region`,
    course.`Membership Year` FROM
    tmp_NatRC course
        LEFT JOIN
    tmp_NatR upgraded ON course.`AYSOID` = upgraded.`AYSOID`
WHERE
    upgraded.`CertDate` IS NULL;
        
DROP TABLE IF EXISTS tmp_NatRC;
DROP TABLE IF EXISTS tmp_NatR;

-- Select Advanced Referee Candidates / Course but not Referee
DROP TABLE IF EXISTS tmp_AdvRC;

CREATE TABLE tmp_AdvRC SELECT * FROM
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
        `CertificationDesc` = 'Advanced Referee Course'
    GROUP BY `AYSOID` , `Membership Year` DESC) ordered) ranked
WHERE
    rank = 1;

DROP TABLE IF EXISTS tmp_AdvR;

CREATE TABLE tmp_AdvR SELECT `AYSOID`, `CertDate` FROM
    crs_refcerts
WHERE
    `CertificationDesc` = 'Advanced Referee';

INSERT INTO tmp_ref_upgrades SELECT DISTINCT
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
		course.`Gender`,
		course.`CertificationDesc`,
		course.`CertDate`,
		course.`SAR`,
		course.`Section`,
		course.`Area`,
		course.`Region`, 
		course.`Membership Year`
    FROM
        tmp_AdvRC course LEFT JOIN tmp_AdvR upgraded ON course.`AYSOID` = upgraded.`AYSOID`
    WHERE
        upgraded.`CertDate` IS NULL;
        
DROP TABLE IF EXISTS tmp_AdvRC;
DROP TABLE IF EXISTS tmp_AdvR;

-- Select Intermediate Referee Candidates / Course but not Referee
DROP TABLE IF EXISTS tmp_IntRC;

CREATE TABLE tmp_IntRC SELECT * FROM
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
        `CertificationDesc` = 'Intermediate Referee Course'
    GROUP BY `AYSOID` , `Membership Year` DESC) ordered) ranked
WHERE
    rank = 1;

DROP TABLE IF EXISTS tmp_IntR;

CREATE TABLE tmp_IntR SELECT `AYSOID`, `CertDate` FROM
    crs_refcerts
WHERE
    `CertificationDesc` = 'Intermediate Referee';

INSERT INTO tmp_ref_upgrades SELECT DISTINCT
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
		course.`Gender`,
		course.`CertificationDesc`,
		course.`CertDate`,
		course.`SAR`,
		course.`Section`,
		course.`Area`,
		course.`Region`, 
		course.`Membership Year`
    FROM
        tmp_IntRC course LEFT JOIN tmp_IntR upgraded ON course.`AYSOID` = upgraded.`AYSOID`
    WHERE
        upgraded.`CertDate` IS NULL;
        
DROP TABLE IF EXISTS tmp_IntRC;
DROP TABLE IF EXISTS tmp_IntR;     

DROP TABLE IF EXISTS crs_tmp_ref_upgrades;

CREATE TABLE crs_tmp_ref_upgrades SELECT DISTINCT * FROM
    tmp_ref_upgrades
ORDER BY FIELD(`CertificationDesc`,
        'National Referee Course',
        'Advanced Referee Course',
        'Intermediate Referee Course'), `Section` , `Area` , `Region` , `CertDate`;
        
DROP TABLE IF EXISTS tmp_ref_upgrades;



END$$

DROP PROCEDURE IF EXISTS `RefreshRefNoCerts`$$
CREATE DEFINER=`root`@`%` PROCEDURE `RefreshRefNoCerts` ()  SQL SECURITY INVOKER
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
    `Gender`,
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
ORDER BY `Section`, `Area`, `Region`) nocerts;

END$$

DROP PROCEDURE IF EXISTS `RefreshSafeHavenCerts`$$
CREATE DEFINER=`root`@`%` PROCEDURE `RefreshSafeHavenCerts` ()  BEGIN
SET @id:= 0;

DROP TABLE IF EXISTS crs_tmp_safehaven;
SET @s = CONCAT("
CREATE TABLE crs_tmp_safehaven SELECT 
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
    `Gender`,
	`CertificationDesc`,
	`CertDate`,
	`SAR`,
	`Section`,
	`Area`,
	`Region`,
	`Membership Year`
FROM
    (SELECT 
        *
    FROM
        (SELECT 
        *,
            @rank:=IF(@id = `AYSOID`, @rank + 1, 1) AS rank,
            @id:=`AYSOID`
    FROM (SELECT * FROM 
        crs_certs
    WHERE
        `CertificationDesc` LIKE '%Safe Haven%' AND `CertificationDesc` LIKE '%Referee%'
    GROUP BY `AYSOID`, `CertDate` DESC, 
    FIELD(`CertificationDesc`, 'Z-Online AYSOs Safe Haven', 'Safe Haven Referee', 'Regional Referee & Safe Haven Referee', 'Assistant Referee & Safe Haven Referee', 'U-8 Official & Safe Haven Referee'),
    `Membership Year` DESC ) ordered) ranked
WHERE
    rank = 1
ORDER BY `Section`, `Area`, `Region`, `Last Name`, `First Name`) sh;");
    
PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;
END$$

DROP PROCEDURE IF EXISTS `RefreshUnregisteredReferees`$$
CREATE DEFINER=`root`@`%` PROCEDURE `RefreshUnregisteredReferees` ()  BEGIN
SET @dfields := "'National Referee', 'National 2 Referee', 'Advanced Referee', 'Intermediate Referee', 'Regional Referee', 'Regional Referee & Safe Haven Referee', 'z-Online Regional Referee without Safe Haven', 'Z-Online Regional Referee', 'Assistant Referee', 'Assistant Referee & Safe Haven Referee', 'U-8 Official', 'U-8 Official & Safe Haven Referee', 'Z-Online Safe Haven Referee', 'Safe Haven Referee', ''";

DROP TABLE IF EXISTS crs_tmp_unregistered_refs;

CREATE TABLE crs_tmp_unregistered_refs SELECT * FROM
    (SELECT 
        *
    FROM
        crs_tmp_hrc
    WHERE
        `Membership Year` <> 'MY2018' AND `Membership Year` <> 'MY2017') unreg
ORDER BY `Section`, `Area`, `Region`, FIELD(`CertificationDesc`, @dfields);
END$$

DROP PROCEDURE IF EXISTS `rs_ar1AssignmentMap`$$
CREATE DEFINER=`root`@`%` PROCEDURE `rs_ar1AssignmentMap` (IN `projectKey` VARCHAR(45), `has4th` VARCHAR(45))  BEGIN
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

DROP PROCEDURE IF EXISTS `rs_ar2AssignmentMap`$$
CREATE DEFINER=`root`@`%` PROCEDURE `rs_ar2AssignmentMap` (IN `projectKey` VARCHAR(45), IN `has4th` VARCHAR(45))  BEGIN
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

DROP PROCEDURE IF EXISTS `rs_crAssignmentMap`$$
CREATE DEFINER=`root`@`%` PROCEDURE `rs_crAssignmentMap` (IN `projectKey` VARCHAR(45), IN `has4th` VARCHAR(45))  BEGIN
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

DROP PROCEDURE IF EXISTS `rs_r4thAssignmentMap`$$
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

DROP PROCEDURE IF EXISTS `UpdateCompositeMYCerts`$$
CREATE DEFINER=`root`@`%` PROCEDURE `UpdateCompositeMYCerts` ()  BEGIN
SET @id:= 0;
SET @dfields := "'National Referee', 'National 2 Referee', 'Advanced Referee', 'Intermediate Referee', 'Regional Referee', 'Regional Referee & Safe Haven Referee', 'z-Online Regional Referee without Safe Haven', 'Z-Online Regional Referee', 'Assistant Referee', 'Assistant Referee & Safe Haven Referee', 'U-8 Official', 'U-8 Official & Safe Haven Referee', 'Z-Online Safe Haven Referee', 'Safe Haven Referee', ''";

DROP TABLE IF EXISTS `s1_composite_my_certs`;
	SET @s = CONCAT("
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
				`Gender`,
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
		FROM (
		
		SELECT 
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
				`Gender`,
				CertificationDesc,
				CertDate,
				SAR,
				Section,
				Area,
				Region,
				`Membership Year`
		FROM
			wp_ayso1ref.`eAYSO.MY2017.certs_highestRefCert` 
	UNION SELECT 
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
				`Gender`,
				CertificationDesc,
				CertDate,
				SAR,
				Section,
				Area,
				Region,
				`Membership Year`
		FROM
			wp_ayso1ref.`eAYSO.MY2016.certs_highestRefCert` 
	UNION SELECT 
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
				`Gender`,
				CertificationDesc,
				CertDate,
				SAR,
				Section,
				Area,
				Region,
				`Membership Year`
		FROM
			wp_ayso1ref.crs_tmp_hrc) hrc
		GROUP BY `AYSOID` , FIELD(`CertificationDesc`, @dfields, 'MY2018', 'MY2017', 'MY2016', `Membership Year`)) ordered) ranked
		WHERE
			rank = 1
		ORDER BY SAR) composite;
");

PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;
END$$

--
-- Functions
--
DROP FUNCTION IF EXISTS `multiTrim`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `multiTrim` (`string` TEXT, `remove` CHAR(63)) RETURNS TEXT CHARSET latin1 BEGIN
  -- Remove trailing chars
  WHILE length(string)>0 and remove LIKE concat('%',substring(string,-1),'%') DO
    set string = substring(string,1,length(string)-1);
  END WHILE;

  -- Remove leading chars
  WHILE length(string)>0 and remove LIKE concat('%',left(string,1),'%') DO
    set string = substring(string,2);
  END WHILE;

  RETURN string;
END$$

DROP FUNCTION IF EXISTS `PROPER_CASE`$$
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

DROP FUNCTION IF EXISTS `SPLIT_STRING`$$
CREATE DEFINER=`root`@`%` FUNCTION `SPLIT_STRING` (`str` VARCHAR(255), `delim` VARCHAR(12), `pos` INT) RETURNS VARCHAR(255) CHARSET utf8 BEGIN
RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(str, delim, pos),
       LENGTH(SUBSTRING_INDEX(str, delim, pos-1)) + 1),
       delim, '');
RETURN 1;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `certCount`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `certCount`;
CREATE TABLE `certCount` (
);

-- --------------------------------------------------------

--
-- Table structure for table `eAYSO.MY2016.certs`
--

DROP TABLE IF EXISTS `eAYSO.MY2016.certs`;
CREATE TABLE `eAYSO.MY2016.certs` (
  `AYSOID` int(11) DEFAULT NULL,
  `Name` text,
  `Street` text,
  `City` text,
  `State` text,
  `Zip` text,
  `HomePhone` text,
  `BusinessPhone` text,
  `Email` text,
  `CertificationDesc` text,
  `Gender` text,
  `SectionAreaRegion` text,
  `CertDate` text,
  `ReCertDate` text,
  `FirstName` text,
  `LastName` text,
  `SectionName` text,
  `AreaName` text,
  `RegionNumber` text,
  `Membership Year` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `eAYSO.MY2017.certs`
--

DROP TABLE IF EXISTS `eAYSO.MY2017.certs`;
CREATE TABLE `eAYSO.MY2017.certs` (
  `AYSOID` int(11) DEFAULT NULL,
  `Name` text,
  `Street` text,
  `City` text,
  `State` text,
  `Zip` text,
  `HomePhone` text,
  `BusinessPhone` text,
  `Email` text,
  `CertificationDesc` text,
  `Gender` text,
  `SectionAreaRegion` text,
  `CertDate` text,
  `ReCertDate` text,
  `FirstName` text,
  `LastName` text,
  `SectionName` text,
  `AreaName` text,
  `RegionNumber` text,
  `Membership Year` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure for view `certCount`
--
DROP TABLE IF EXISTS `certCount`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `certCount`  AS  select '1B' AS `Area`,count(0) AS `NumCerts` from `crs_1b_certs` union select '1C' AS `Area`,count(0) AS `NumCerts` from `crs_1c_certs` union select '1D' AS `Area`,count(0) AS `NumCerts` from `crs_1d_certs` union select '1F' AS `Area`,count(0) AS `NumCerts` from `crs_1f_certs` union select '1G' AS `Area`,count(0) AS `NumCerts` from `crs_1g_certs` union select '1H' AS `Area`,count(0) AS `NumCerts` from `crs_1h_certs` union select '1N' AS `Area`,count(0) AS `NumCerts` from `crs_1n_certs` union select '1P' AS `Area`,count(0) AS `NumCerts` from `crs_1p_certs` union select '1R' AS `Area`,count(0) AS `NumCerts` from `crs_1r_certs` union select '1S' AS `Area`,count(0) AS `NumCerts` from `crs_1s_certs` union select '1U' AS `Area`,count(0) AS `NumCerts` from `crs_1u_certs` union select 'All' AS `Total`,count(0) AS `NumCerts` from `crs_certs` ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
