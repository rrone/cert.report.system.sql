-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Sep 14, 2021 at 01:22 PM
-- Server version: 5.7.35-0ubuntu0.18.04.1
-- PHP Version: 7.4.23

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

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `BuildIRITable`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `BuildIRITable` ()  BEGIN
DROP TABLE IF EXISTS tmp_intermediate_referee_instructors;
CREATE TEMPORARY TABLE tmp_intermediate_referee_instructors (SELECT DISTINCT 
AYSOID, Name, SAR, CertificationDesc, CertDate FROM crs_rpt_ri WHERE (`CertificationDesc` = 'Basic Referee Instructor' OR `CertificationDesc` = 'Referee Instructor') AND `CertDate` < '2018-09-01');   

DROP TABLE IF EXISTS crs_intermediate_referee_instructors;
CREATE TABLE crs_intermediate_referee_instructors SELECT 
	AYSOID, Name, SAR, CertificationDesc, CertDate 
	FROM 
		(SELECT 
			*,
			@rank:=IF(@id = `AYSOID`, @rank + 1, 1) AS rank,
			@id:=`AYSOID`
		FROM 
			(SELECT * 
				FROM tmp_intermediate_referee_instructors
				GROUP BY `AYSOID`, FIELD(`CertificationDesc`, 'National Referee Instructor', 'Advanced Referee Instructor', 'Referee Instructor', 'Basic Referee Instructor', 'Grade2 Referee Instructor')
				) tmp 
			) ranked
	WHERE
		rank = 1;
ALTER TABLE `crs_intermediate_referee_instructors` ADD INDEX (`aysoid`);


SELECT *
FROM
    crs_intermediate_referee_instructors;
END$$

DROP PROCEDURE IF EXISTS `CertTweaks`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `CertTweaks` (IN `certTable` VARCHAR(128))  BEGIN

SET @certTable = CONCAT("`", certTable, "`");

# 2021-01-27 / Fix corrupted State in Sports Connect data / reference: http://structnet.com/instructions/zip_min_max_by_state.html 
SET @s = CONCAT("UPDATE ", @certTable, " SET `State` = 'Arizona' WHERE `Zip` >= 85001 AND `Zip` <= 86556;");
CALL exec_qry(@s);
SET @s = CONCAT("UPDATE ", @certTable, " SET `State` = 'California' WHERE `Zip` >= 90001 AND `Zip` <= 96162;");
CALL exec_qry(@s);
SET @s = CONCAT("UPDATE ", @certTable, " SET `State` = 'Nevada' WHERE `Zip` >= 88901 AND `Zip` <= 89883;");
CALL exec_qry(@s);
#  end Fix


SET @s = CONCAT("UPDATE ", @certTable, " SET `SAR` = '1', `Area` = '', `Region` = '' WHERE `SAR` = '1/';");
CALL exec_qry(@s);

# rick roberts
SET @s = CONCAT("UPDATE ", @certTable, " SET `Email` = 'ayso1sra@gmail.com' WHERE `AYSOID` = 97815888 AND `Region`= '';");
CALL exec_qry(@s);
SET @s = CONCAT("UPDATE ", @certTable, " SET `Name` = 'Rick Roberts', `First Name` = 'Rick' WHERE `AYSOID` = 97815888;");
CALL exec_qry(@s);
SET @s = CONCAT("DELETE FROM ", @certTable, " WHERE `AYSOID` = 216048241;");
CALL exec_qry(@s);

# Al Prado
SET @s = CONCAT("UPDATE ", @certTable, " SET `AYSOID` = 56097099 WHERE `AYSOID` = 214892296;");
CALL exec_qry(@s);

# Update National Referee Assessors: Jody Kinsey, Spencer Horwitz, Geoffrey Falk, Yui-bin Chen, Bruce Hancock
SET @s = CONCAT("DELETE FROM ", @certTable, " WHERE `AYSOID` in ('96383441','95025758','59244326','57071121','99871834') AND `CertificationDesc` = 'National Referee Assessor';");
CALL exec_qry(@s);

# Update Referee Instructors
#SET @s = CONCAT("UPDATE ", @certTable, " SET `CertificationDesc` = 'Regional Referee Instructor' WHERE `CertificationDesc` = 'Referee Instructor' OR `CertificationDesc` = 'Basic Referee Instructor';");   
#CALL exec_qry(@s);
#SET @s = CONCAT("UPDATE ", @certTable, " SET `CertificationDesc` = 'Intermediate Referee Instructor' WHERE `AYSOID` IN (SELECT AYSOID FROM crs_intermediate_referee_instructors) AND `CertificationDesc` = 'Regional Referee Instructor';"); 
#CALL exec_qry(@s);

# Merge records
# Chris Call
SET @s = CONCAT("UPDATE ", @certTable, " SET `AYSOID` = 200284566 WHERE `AYSOID` = 66280719;");
CALL exec_qry(@s);

# Jon Swasey
SET @s = CONCAT("UPDATE ", @certTable, " SET `AYSOID` = 202650542 WHERE `AYSOID` = 70161548;");
CALL exec_qry(@s);

# Philip Maki
SET @s = CONCAT("UPDATE ", @certTable, " SET `AYSOID` = 201245499 WHERE `AYSOID` = 65397057;");
CALL exec_qry(@s);

# Michael Wolff
SET @s = CONCAT("DELETE FROM ", @certTable, " WHERE `AYSOID` = 56234203 AND `SAR` LIKE '1/F/%';");
CALL exec_qry(@s);

# Rick Ramirez
# SET @s = CONCAT("UPDATE ", @certTable, " SET `AYSOID` = 200019230 WHERE `AYSOID` = 54288898;");
# CALL exec_qry(@s);

# Michael Raycraft
SET @s = CONCAT("DELETE FROM ", @certTable, " WHERE `Name` = 'Michael Raycraft' AND `CertificationDesc` LIKE 'National Referee Assessor';");
CALL exec_qry(@s);

# Peter Fink
CALL exec_qry(@s);
SET @s = CONCAT("DELETE FROM ", @certTable, " WHERE `AYSOID` = 94012088;");
CALL exec_qry(@s);

# Robert Osborne 
# duplicate eAYSO record
SET @s = CONCAT("DELETE FROM ", @certTable, " WHERE `AYSOID` = 79403530;");
CALL exec_qry(@s);

# Jimmy Molinar
SET @s = CONCAT("DELETE FROM ", @certTable, " WHERE `AYSOID` = 56272832;");
CALL exec_qry(@s);

# Dennis Raymond
# SET @s = CONCAT("UPDATE ", @certTable, " SET `Membership Year` = 'MY2018' WHERE `AYSOID` = 55296033 AND `Membership Year` < 'MY2018';");
# CALL exec_qry(@s);
 
# Donald Ramsay
SET @s = CONCAT("DELETE FROM ", @certTable, " WHERE `AYSOID` = 204673909 AND `CertificationDesc` LIKE 'Referee Instructor Evaluator';");
CALL exec_qry(@s);

# Chris Salmon
SET @s = CONCAT("DELETE FROM ", @certTable, " WHERE `AYSOID` = 54261701;");
CALL exec_qry(@s);

# Rafael Rangel
SET @s = CONCAT("DELETE FROM ", @certTable, " WHERE `AYSOID` = 79685757;");
CALL exec_qry(@s);

# Brian Keltie 57182658
SET @s = CONCAT("DELETE FROM ", @certTable, " WHERE `AYSOID` = 57182658;");
CALL exec_qry(@s);

# Gutierrez, Zoë
SET @s = CONCAT("UPDATE ", @certTable, " SET `Name`= 'Zoe Gutierrez', `First Name` = 'Zoe' WHERE AYSOID = 82014699;");
CALL exec_qry(@s);

# Nicholas Jung
SET @s = CONCAT("UPDATE ", @certTable, " SET `AYSOID` = 82124801 WHERE `AYSOID` = 82134170;");
CALL exec_qry(@s);

# Angel Valdez / 64807304
SET @s = CONCAT("DELETE FROM ", @certTable, " WHERE `AYSOID` = 55330327;");
CALL exec_qry(@s);

# Steven Hawkins / 202413390
SET @s = CONCAT("DELETE FROM ", @certTable, " WHERE `AYSOID` = 56049053;");
CALL exec_qry(@s);

# Steve Bodnar
SET @s = CONCAT("UPDATE ", @certTable, " SET `AYSOID` = 202728607 WHERE `AYSOID` = 79647224;");
CALL exec_qry(@s);

# Francisco Diaz
SET @s = CONCAT("UPDATE ", @certTable, " SET `AYSOID` = 58223159 WHERE `AYSOID` = 99561421;");
CALL exec_qry(@s);


END$$

DROP PROCEDURE IF EXISTS `compileVolIDs`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `compileVolIDs` ()  BEGIN
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

DROP PROCEDURE IF EXISTS `distinctRegistrations`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `distinctRegistrations` ()  BEGIN
SELECT DISTINCT `AYSOID`, `Name`, `First Name`, `Last Name`, `Address`, `City`, `State`, `Zip`, `Home Phone`, `Cell Phone`, `Email`, `Gender`,`SAR` FROM crs_certs
UNION
SELECT DISTINCT `AYSOID`, `Name`, `FirstName` AS 'First Name', `LastName` AS 'Last Name', `Street` AS 'Address', `City`, `State`, `Zip`, `HomePhone`, `BusinessPhone` AS 'Cell Phone', `Email`, `Gender`, CONCAT(`SectionName`, '/', `AreaName`, '/', `RegionNumber`) AS 'SAR' FROM `eAYSO.MY2017.certs`
ORDER BY `SAR`, `Last Name`, `First Name`;
END$$

DROP PROCEDURE IF EXISTS `e3_inLeague_reports`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `e3_inLeague_reports` ()  BEGIN

SET @s = "
DROP TABLE IF EXISTS `e3_inLeague_reports`;

CREATE TEMPORARY TABLE `e3_inLeague_reports` (
  `Section` int(11) DEFAULT NULL,
  `Area` text,
  `Region` int(11) DEFAULT NULL,
  `AYSOID` int(11) DEFAULT NULL,
  `Membershipyear` text,
  `Volunteer Position` text,
  `LastName` text,
  `FirstName` text,
  `DOB` text,
  `Gender` text,
  `Street` text,
  `City` text,
  `State` text,
  `Zip` text,
  `HomePhone` text,
  `CellPhone` text,
  `Email` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2016.Volunteer_Report_Export.csv'
	INTO TABLE `e3_inLeague_reports`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2017.Volunteer_Report_Export.csv'
	INTO TABLE `e3_inLeague_reports`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2018.Volunteer_Report_Export.csv'
	INTO TABLE `e3_inLeague_reports`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2019.Volunteer_Report_Export.csv'
	INTO TABLE `e3_inLeague_reports`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2020.Volunteer_Report_Export.csv'
	INTO TABLE `e3_inLeague_reports`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2021.Volunteer_Report_Export.csv'
	INTO TABLE `e3_inLeague_reports`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

UPDATE `e3_inLeague_reports` SET `Zip` = replace(`Zip`,'''','');

DROP TABLE IF EXISTS `e3_inLeague`;

CREATE TABLE `e3_inLeague` SELECT DISTINCT
  `AYSOID`,
  `Section`,
  `Area`,
  `Region`,
  `Membershipyear`,
  `Volunteer Position`,
  `LastName`,
  `FirstName`,
  `DOB`,
  `Gender`,
  `Street`,
  `City`,
  `State`,
  `Zip`,
  FORMAT_AS_PHONE_NUMBER(`HomePhone`) AS `HomePhone`,
  FORMAT_AS_PHONE_NUMBER(`CellPhone`) AS `CellPhone`,
  `Email`

FROM
    `ayso1ref_services`.`e3_inLeague_reports`
WHERE
    Region IN (13 , 20, 70, 76, 78);
    
SELECT 
    *
FROM
    `e3_inLeague`;   
";

END$$

DROP PROCEDURE IF EXISTS `eAYSOHighestRefCert`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `eAYSOHighestRefCert` (IN `tableName` VARCHAR(128))  BEGIN

SET @id:= 0;
SET @dfields := "'National Referee', 'National 2 Referee', 'Advanced Referee', 'Intermediate Referee', 'Regional Referee', 'Regional Referee & Safe Haven Referee', 'Assistant Referee', 'Assistant Referee & Safe Haven Referee', 'U-8 Official', 'U-8 Official & Safe Haven Referee', ''";
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
        AND NOT `CertificationDesc` = 'z-Online Regional Referee without Safe Haven' 
        AND NOT `CertificationDesc` = 'Z-Online Safe Haven Referee' 
        AND NOT `CertificationDesc` = 'Safe Haven Referee'
        AND NOT `CertificationDesc` = 'Z-Online Regional Referee'
    GROUP BY `AYSOID` , FIELD(`CertificationDesc`, 'National Referee', 'National 2 Referee', 'Advanced Referee', 'Intermediate Referee', 'Regional Referee', 'Regional Referee & Safe Haven Referee', 'Assistant Referee', 'Assistant Referee & Safe Haven Referee', 'U-8 Official', 'U-8 Official & Safe Haven Referee', '')) ordered) ranked
    WHERE
        rank = 1
    ORDER BY FIELD(`CertificationDesc`, 'National Referee', 'National 2 Referee', 'Advanced Referee', 'Intermediate Referee', 'Regional Referee', 'Regional Referee & Safe Haven Referee', 'Assistant Referee', 'Assistant Referee & Safe Haven Referee', 'U-8 Official', 'U-8 Official & Safe Haven Referee', '') , SAR, `Last Name` , `First Name` , AYSOID) hrc;");
    
PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;
    

END$$

DROP PROCEDURE IF EXISTS `exec_qry`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `exec_qry` (IN `p_sql` TEXT)  BEGIN
SET @tquery = p_sql;
  PREPARE stmt FROM @tquery;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;
END$$

DROP PROCEDURE IF EXISTS `load_historical_certs`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `load_historical_certs` ()  BEGIN

SET @@global.sql_mode= '';

/***************************************/
--  Load SportsConnect certs`

-- init table crs_certs
SET @s = "
DROP TABLE IF EXISTS crs_certs;

CREATE TABLE `crs_certs` (
	`Program Name` text,
	`Membership Year` varchar(200),
	`Volunteer Role` text,
    `IDNUM` text,
	`AYSOID` varchar(20),
	`Name` longtext,
	`First Name` text,
	`Last Name` text,
	`Address` text,
	`City` text,
	`State` text,
	`Zip` text,
	`Home Phone` text,
	`Cell Phone` text,
	`Email` text,
	`Gender` text,
	`CertificationDesc` text,
	`CertDate` varchar(10) CHARACTER SET utf8,
	`SAR` varchar(98) NOT NULL DEFAULT '',
	`Section` varchar(32) NOT NULL,
	`Area` varchar(32) NOT NULL,
	`Region` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE crs_certs AUTO_INCREMENT = 0; 
ALTER TABLE crs_certs ADD INDEX (`AYSOID`);
ALTER TABLE crs_certs ADD INDEX (`Membership Year`);

-- init table crs_shcerts
DROP TABLE IF EXISTS crs_shcerts;

CREATE TABLE `crs_shcerts` (
	`Program Name` text,
	`Membership Year` text,
	`Volunteer Role` text,
    `IDNUM` text,
	`AYSOID` varchar(20),
	`Name` longtext,
	`First Name` text,
	`Last Name` text,
	`Address` text,
	`City` text,
	`State` text,
	`Zip` text,
	`Home Phone` text,
	`Cell Phone` text,
	`Email` text,
	`Gender` text,
	`CertificationDesc` text,
	`CertDate` varchar(10) CHARACTER SET utf8,
	`SAR` varchar(98) NOT NULL DEFAULT '',
	`Section` varchar(32) NOT NULL,
	`Area` varchar(32) NOT NULL,
	`Region` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE `crs_shcerts` 
AUTO_INCREMENT = 0, 
ADD INDEX (`aysoid`);

-- Refresh Section BS data table `crs_1_certs`
DROP TABLE IF EXISTS `tmp_1_certs`;   

CREATE TEMPORARY TABLE `tmp_1_certs` (
	`Program Name` text,
	`Program AYSO Membership Year` text,
	`Volunteer Role` text,
    `IDNUM` text,
	`AYSO Volunteer ID` int(11),
	`Volunteer First Name` text,
	`Volunteer Last Name` text,
	`Volunteer Address` text,
	`Volunteer City` text,
	`Volunteer State` text,
	`Volunteer Zip` text,
	`Volunteer Phone` text,
	`Volunteer Cell` text,
	`Volunteer Email` text,
	`Gender` text,
	`AYSO Certifications` text,
	`Date of Last AYSO Certification Update` text,
	`Portal Name` varchar(250)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.txt'  
	INTO TABLE `tmp_1_certs`   
	FIELDS TERMINATED BY '\t'   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;   

DELETE FROM `tmp_1_certs` WHERE `Program Name` like '%Do not use%';

-- Restore Region deleted programs & volunteers in past seasons
INSERT INTO `tmp_1_certs` SELECT * FROM `crs_1_201812_certs`;
INSERT INTO `tmp_1_certs` SELECT * FROM `crs_1_201905_certs`;
INSERT INTO `tmp_1_certs` SELECT * FROM `crs_1_201912_certs`;
INSERT INTO `tmp_1_certs` SELECT * FROM `crs_1_202105_certs`;

# -10-30: Correct cross-id contamination with 97815888  
ALTER TABLE `tmp_1_certs` 
ADD COLUMN `id` INT NOT NULL AUTO_INCREMENT AFTER `Portal Name`,
ADD PRIMARY KEY (`id`);

DELETE FROM `tmp_1_certs` 
WHERE
    `AYSO Volunteer ID` = 97815888
    AND `Gender` = 'F';
        
ALTER TABLE `tmp_1_certs`
DROP COLUMN `id`,
DROP PRIMARY KEY;        
# END: -10-30: Correct cross-id contamination with 97815888 

-- 2021.08.22 remove duplicate records
DROP TABLE IF EXISTS `crs_1_certs`;  
CREATE TABLE `crs_1_certs` SELECT DISTINCT * FROM `tmp_1_certs`;  
-- END: remove duplicate records    

-- Clean up imported data
DELETE FROM `crs_1_certs` WHERE `AYSO Volunteer ID` IS NULL;
UPDATE `crs_1_certs` SET `Program Name` = REPLACE(`Program Name`, '\"', '');
UPDATE `crs_1_certs` SET `Volunteer Role` = REPLACE(`Volunteer Role`, '\"', '');
UPDATE `crs_1_certs` SET `Volunteer Address` = REPLACE(`Volunteer Address`, '\"', '');
UPDATE `crs_1_certs` SET `Volunteer City` = REPLACE(`Volunteer City`, '\"', '');
UPDATE `crs_1_certs` SET `Portal Name` = REPLACE(`Portal Name`, '\"', '');

ALTER TABLE `crs_1_certs` 
ADD INDEX (`AYSO Volunteer ID`),
ADD INDEX (`Portal Name`);

# Maureen Reid 73895502 registered Section 1 in error lives in Pennsylvania
DELETE FROM `crs_1_certs` WHERE `AYSO Volunteer ID` = 73895502;

CALL `processBSCSV`('crs_1_certs');  

/***************************************/
-- 2021-01-06: eAYSO report files are no longer available.  No need to update.
-- Load eAYSO certs`

-- Load `eAYSO.MY2017.certs`
CALL `prepEAYSOCSVTable`('eAYSO.MY2016.certs');

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/eAYSO.MY2016.certs.csv'
	INTO TABLE `eAYSO.MY2016.certs`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '\"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;   

--  Load `eAYSO.MY2017.certs`
CALL `prepEAYSOCSVTable`('eAYSO.MY2017.certs');

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/eAYSO.MY2017.certs.csv'
	INTO TABLE `eAYSO.MY2017.certs`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '\"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;   
	
--  Refresh `eAYSO.MY2018.certs`
CALL `prepEAYSOCSVTable`('eAYSO.MY2018.certs');

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/eAYSO.MY2018.certs.csv'
	INTO TABLE `eAYSO.MY2018.certs`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '\"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;   

--  Refresh `eAYSO.MY2019.certs`
CALL `prepEAYSOCSVTable`('eAYSO.MY2019.certs');

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/eAYSO.MY2019.certs.csv'
	INTO TABLE `eAYSO.MY2019.certs`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '\"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;   
--
-- Still need to add eAYSO certs to crs_certs and crs_shcerts 
CALL `processEAYSOCSV`();";

CALL exec_qry(@s);

END$$

DROP PROCEDURE IF EXISTS `mergeAdminCredentialsStatusDynamic`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `mergeAdminCredentialsStatusDynamic` ()  BEGIN

DROP TABLE IF EXISTS `temp1`;

CREATE TABLE `temp1` (SELECT DISTINCT `AYSOID`,
    `Address`,
    `City`,
    `State`,
    `Zip`,
    `Home Phone`,
    `Cell Phone`
    FROM
    (SELECT 
        *,
            @rank:=IF(@id = `AYSOID` AND @my <> `Membership Year`, @rank + 1, 1) AS rank,
            @id:=`AYSOID`,
            @my:=`Membership Year`
    FROM
        (SELECT DISTINCT
        `AYSOID`,
            `Membership Year`,
            `Address`,
            `City`,
            `State`,
            `Zip`,
            `Home Phone`,
            `Cell Phone`
    FROM
        crs_certs t
	ORDER BY `Membership Year` DESC) ordered
    GROUP BY `AYSOID`) ranked
WHERE
    rank = 1);

INSERT INTO `crs_certs`(
SELECT 
    `MY` AS `Program Name`,
    RIGHT(`MY`, 6) AS `Membership Year`,
    'Volunteer' AS 'Volunteer Role',
    `IDNUM1`,
    `AltID` AS `AYSOID`,
    CONCAT(`FirstName`, ' ', `LastName`) AS `Name`,
    `FirstName` AS `First Name`,
    `LastName` AS `Last Name`,
    `Address`,
    `City`,
    `State`,
    `Zip`,
    `Home Phone`,
    `Cell Phone`,
    `email` AS `Email`,
    `GenderCode` AS `Gender`,
    `CertificateName` AS `CertificationDesc`,
    `ccInDate` AS `CertDate`,
    CONCAT(ExtractNumber(`League`),
            '/',
            ExtractAlpha(SUBSTRING_INDEX(TRIM(`League`), ' ', -1)),
            '/',
            ExtractNumber(`Club`)) AS `SAR`,
    ExtractNumber(`League`) AS `Section`,
    ExtractAlpha(SUBSTRING_INDEX(TRIM(`League`), ' ', -1)) AS `Area`,
    ExtractNumber(`Club`) AS `Region`
FROM
    ayso1ref_services.AdminCredentialsStatusDynamic a INNER JOIN temp1 t ON a.`AltID` = t.`AYSOID`
WHERE `ccInDate` <> '' 
	AND NOT `CertificateName` IN ('CEUs eCompleted', 'Instructor Completed', 'Management Training', '')
ORDER BY `IDNUM1` , `Membership Year`);    
   
   
INSERT INTO `crs_certs`(
SELECT DISTINCT
    `MY` AS `Program Name`,
    RIGHT(`MY`, 6) AS `Membership Year`,
    'Volunteer' AS 'Volunteer Role',
    `IDNUM1`,
    `AltID` AS `AYSOID`,
    CONCAT(`FirstName`, ' ', `LastName`) AS `Name`,
    `FirstName` AS `First Name`,
    `LastName` AS `Last Name`,
    `Address`,
    `City`,
    `State`,
    `Zip`,
    `Home Phone`,
    `Cell Phone`,
    `email` AS `Email`,
    `GenderCode` AS `Gender`,
    `refGrade1` AS `CertificationDesc`,
    STR_TO_DATE(`refObtainDate1`, "%m/%d/%Y") as `CertDate`,
    CONCAT(ExtractNumber(`League`),
            '/',
            ExtractAlpha(SUBSTRING_INDEX(TRIM(`League`), ' ', -1)),
            '/',
            ExtractNumber(`Club`)) AS `SAR`,
    ExtractNumber(`League`) AS `Section`,
    ExtractAlpha(SUBSTRING_INDEX(TRIM(`League`), ' ', -1)) AS `Area`,
    ExtractNumber(`Club`) AS `Region`
FROM
    ayso1ref_services.AdminCredentialsStatusDynamic a INNER JOIN temp1 t ON a.`AltID` = t.`AYSOID`
    WHERE `refObtainDate1` <> ''
ORDER BY `IDNUM1` , `Membership Year`);

DROP TABLE IF EXISTS `temp1`;

-- remove duplicate records
DROP TABLE IF EXISTS `copy_crs_certs`;
CREATE TABLE `copy_crs_certs` LIKE `crs_certs`;
 
INSERT INTO `copy_crs_certs`
SELECT DISTINCT * FROM `crs_certs`; 

DELETE FROM crs_certs 
WHERE
    AYSOID IN (SELECT 
        AYSOID
    FROM
        crs_not_available); 
DROP TABLE IF EXISTS `crs_certs`;
 
ALTER TABLE `copy_crs_certs` RENAME TO `crs_certs`;
-- END: remove duplicate records


END$$

DROP PROCEDURE IF EXISTS `prepEAYSOCSVTable`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `prepEAYSOCSVTable` (IN `certTable` VARCHAR(128))  BEGIN
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
	  `Membership Year` varchar(50)
	) ENGINE=InnoDB DEFAULT CHARSET=latin1;
");

PREPARE stmt FROM @s;  
EXECUTE stmt;  

DEALLOCATE PREPARE stmt;
END$$

DROP PROCEDURE IF EXISTS `processBSCSV`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `processBSCSV` (IN `certCSV` VARCHAR(128))  BEGIN

SET @inTable = CONCAT('`', certCSV, '`');

SET @empty = "";
SET @space = " ";
SET @delim = "/";

SET @s = CONCAT("DELETE FROM ",@inTable," WHERE
NOT (`AYSO Certifications` LIKE '%Referee%'
OR `AYSO Certifications` LIKE '%Official%'
OR `AYSO Certifications` LIKE '%Concussion%'
OR `AYSO Certifications` LIKE '%Cardiac Arrest%'
OR `AYSO Certifications` LIKE '%AYSOs Safe Haven'
OR `AYSO Certifications` LIKE '%Refugio Seguro de AYSO'
);"
);

PREPARE stmt FROM @s;  
EXECUTE stmt;  

DEALLOCATE PREPARE stmt; 

SET @s = CONCAT(" INSERT INTO crs_2020_certs SELECT 
    `Program Name`,
    CONCAT('MY',`Program AYSO Membership Year`) AS `Membership Year`,
    `Volunteer Role`,
    '' AS IDNUM,
    TRIM(`AYSO Volunteer ID`) AS AYSOID,
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
    IF(`Date of Last AYSO Certification Update` = '' OR `Date of Last AYSO Certification Update` IS NULL, '', `Date of Last AYSO Certification Update`) AS `CertDate`,
    IF(sar.`region` IS NULL
            OR sar.`region` = @empty,
        CONCAT(sar.`section`, @delim, sar.`area`),
        CONCAT(sar.`section`,
                @delim,
                sar.`area`,
                @delim,
                sar.`region`)) AS SAR,
    sar.`section` AS Section,
    sar.`area` AS Area,
    sar.`region` AS Region
FROM ", @inTable, " csv
        INNER JOIN
    rs_sar sar ON csv.`Portal Name` = sar.`portalName`;"
    );

PREPARE stmt FROM @s;  
EXECUTE stmt;  

DEALLOCATE PREPARE stmt;  

SET @s = CONCAT(" INSERT INTO crs_2020_shcerts SELECT 
    `Program Name`,
    CONCAT('MY',`Program AYSO Membership Year`) AS `Membership Year`,
    `Volunteer Role`,
    '' AS IDNUM,
    TRIM(`AYSO Volunteer ID`) AS AYSOID,
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
        IF(`Date of Last AYSO Certification Update` = '' OR `Date of Last AYSO Certification Update` IS NULL, '', `Date of Last AYSO Certification Update`) AS `CertDate`,
    IF(sar.`region` IS NULL
            OR sar.`region` = @empty,
        CONCAT(sar.`section`, @delim, sar.`area`),
        CONCAT(sar.`section`,
                @delim,
                sar.`area`,
                @delim,
                sar.`region`)) AS SAR,
    sar.`section` AS Section,
    sar.`area` AS Area,
    sar.`region` AS Region
FROM ", @inTable, " csv
        INNER JOIN
    rs_sar sar ON csv.`Portal Name` = sar.`portalName`
WHERE `AYSO Certifications` LIKE '%Safe Haven%' AND NOT `AYSO Certifications` LIKE '%without Safe Haven%'"
    );

PREPARE stmt FROM @s;  
EXECUTE stmt;  

DEALLOCATE PREPARE stmt;  
END$$

DROP PROCEDURE IF EXISTS `processEAYSOCSV`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `processEAYSOCSV` ()  BEGIN

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

-- 2021-01-06: eAYSO report files are no longer available.  No need to update.

-- DROP TABLE IF EXISTS `tmp_eAYSO_certs`;
-- 
-- CREATE TEMPORARY TABLE `tmp_eAYSO_certs` SELECT
--  * FROM (
--  SELECT * FROM `eAYSO.MY2016.certs`
--  UNION
--  SELECT * FROM `eAYSO.MY2017.certs`
--  UNION 
--  SELECT * FROM `eAYSO.MY2018.certs`
--  UNION
--  SELECT * FROM `eAYSO.MY2019.certs`
--  ) e;
-- 
-- UPDATE `tmp_eAYSO_certs` SET `AYSOID` = REPLACE(`AYSOID`, '"', '');
-- UPDATE `tmp_eAYSO_certs` SET `AYSOID` = REPLACE(`AYSOID`, unhex('0a'), '');
-- DELETE FROM `tmp_eAYSO_certs` WHERE `AYSOID` = '';
-- ALTER TABLE `tmp_eAYSO_certs` CHANGE COLUMN `AYSOID` `AYSOID` INT(11);
-- 
-- DELETE FROM `tmp_eAYSO_certs`  WHERE
-- NOT (`CertificationDesc` LIKE '%Referee%'
-- OR `CertificationDesc` LIKE '%Official%'
-- OR `CertificationDesc` LIKE '%Concussion%'
-- OR `CertificationDesc` LIKE '%Cardiac Arrest%'
-- OR `CertificationDesc` LIKE '%AYSOs Safe Haven'
-- OR `CertificationDesc` LIKE '%Refugio Seguro de AYSO'
-- );
-- 
-- DROP TABLE IF EXISTS `eAYSO_certs`;
-- 
-- CREATE TABLE `eAYSO_certs` SELECT 
--     TRIM(BOTH ' ' FROM `AYSOID`) as 'AYSOID',
--     `Name`,
--     `Street`,
--     `City`,
--     `State`,
--     `Zip`,
--     `HomePhone`,
--     `BusinessPhone`,
--     `Email`,
--     `CertificationDesc`,
--     `Gender`,
--     `SectionAreaRegion`,
--     `CertDate`,
--     `ReCertDate`,
--     `FirstName`,
--     `LastName`,
--     `SectionName`,
--     `AreaName`,
--     `RegionNumber`,
--     `Membership Year`
-- FROM
--     (SELECT 
--         *,
--             @rankID:=IF(@id = CONCAT(`AYSOID`, `CertificationDesc`), @rankID + 1, 1) AS rankID,
--             @id:=CONCAT(`AYSOID`, `CertificationDesc`)
--     FROM
--         (SELECT 
--         *
--     FROM
--         `tmp_eAYSO_certs`
--     ORDER BY `CertificationDesc` , `AYSOID` , `Membership Year` DESC) tmp) ranked
-- WHERE
--     rankID = 1
-- GROUP BY `AYSOID` , `Membership Year` , `CertificationDesc`
-- ORDER BY `SectionName` , `AreaName` , `RegionNumber` , AYSOID , `LastName` , `FirstName`,`CertificationDesc`;
-- 
-- 
-- DROP TABLE IF EXISTS `eAYSO.MY2016.certs`;
-- DROP TABLE IF EXISTS `eAYSO.MY2017.certs`;
-- DROP TABLE IF EXISTS `eAYSO.MY2018.certs`;
-- DROP TABLE IF EXISTS `eAYSO.MY2019.certs`;
-- 
-- DELETE FROM `eAYSO_certs` WHERE AYSOID = 0;

INSERT INTO `crs_2020_certs` SELECT 
	`Membership Year` AS `Program Name`,
    `Membership Year`,
    'Volunteer' AS `Volunteer Role`,
	'' AS IDNUM,
    TRIM(BOTH ' ' FROM `AYSOID`) as `AYSOID`,
	PROPER_CASE(`Name`) AS `Name`,
    PROPER_CASE(`FirstName`) AS `First Name`,
    PROPER_CASE(`LastName`) AS `Last Name`,
    PROPER_CASE(`Street`) AS Address,
    PROPER_CASE(`City`) AS `City`,
    `State`,
    REPLACE(`Zip`,"'", '') AS `Zip`,
    `HomePhone` AS `Home Phone`,
    `BusinessPhone` AS `Cell Phone`,
    LCASE(`Email`) AS Email,
    `Gender`,
    `CertificationDesc`,
    IF(`CertDate` = "" OR `CertDate` IS NULL, "", `CertDate`) AS `CertDate`,
    `SectionAreaRegion` AS SAR,
    `SectionName` AS Section,
    `AreaName` AS Area,
    `RegionNumber` AS Region
FROM `eAYSO_certs`;


INSERT INTO `crs_2020_shcerts` SELECT 
	`Membership Year` AS `Program Name`,
    `Membership Year`,
    'Volunteer' AS `Volunteer Role`,
	'' AS IDNUM,
    TRIM(BOTH ' ' FROM `AYSOID`) as `AYSOID`,
	PROPER_CASE(`Name`) AS `Name`,
    PROPER_CASE(`FirstName`) AS `First Name`,
    PROPER_CASE(`LastName`) AS `Last Name`,
    PROPER_CASE(`Street`) AS Address,
    PROPER_CASE(`City`) AS `City`,
    `State`,
    REPLACE(`Zip`,"'", '') AS `Zip`,
    `HomePhone` AS `Home Phone`,
    `BusinessPhone` AS `Cell Phone`,
    LCASE(`Email`) AS Email,
    `Gender`,
    `CertificationDesc`,
    IF(`CertDate` = "" OR `CertDate` IS NULL, "", `CertDate`) AS `CertDate`,
    `SectionAreaRegion` AS SAR,
    `SectionName` AS Section,
    `AreaName` AS Area,
    `RegionNumber` AS Region
FROM `eAYSO_certs` WHERE (`CertificationDesc` LIKE '%Refugio Seguro de AYSO'
            OR `CertificationDesc` LIKE '%AYSOs Safe Haven'
            OR `CertificationDesc` LIKE '%Concussion%'
            OR `CertificationDesc` LIKE '%Sudden Cardiac Arrest Training'
    ) AND NOT `CertificationDesc` LIKE '%without Safe Haven%';

END$$

DROP PROCEDURE IF EXISTS `RefreshAllAYSOHighestCertification`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `RefreshAllAYSOHighestCertification` ()  BEGIN
SET sql_mode=(SELECT REPLACE(@@GLOBAL.sql_mode,'ONLY_FULL_GROUP_BY',''));

SET @id:= 0;

DROP TABLE IF EXISTS crs_rpt_all_hrc;

SET @s = CONCAT("
	CREATE TABLE crs_rpt_all_hrc SELECT DISTINCT
	`MY`, 
    `AYSO ID`, 
    `Volunteer First Name`, 
    `Volunteer Last Name`, 
    `AYSO Certifications`, 
    IF(`Date of Last AYSO Certification Update` = '' OR `Date of Last AYSO Certification Update` IS NULL, '', STR_TO_DATE(REPLACE(SPLIT_STRING(`Date of Last AYSO Certification Update`, ' ', 1),'/', '.'),GET_FORMAT(DATE,'USA'))) AS `Date of Last AYSO Certification Update`, 
    `AYSO Region #`
FROM
    (SELECT 
        *,
            @rankID:=IF(@id = `AYSO ID` AND @sar = `AYSO Region #`, @rankID + 1, 1) AS rankID,
            @id:=`AYSO ID`,
            @sar:=`AYSO Region #`
    FROM
        (SELECT 
        *
    FROM
        `crs_allAYSO_certs`
    WHERE
        NOT `AYSO Certifications` LIKE '%Assessor%'
            AND NOT `AYSO Certifications` LIKE '%Instructor%'
            AND NOT `AYSO Certifications` LIKE '%Administrator%'
            AND NOT `AYSO Certifications` LIKE '%VIP%'
            AND NOT `AYSO Certifications` LIKE '%Course%'
            AND NOT `AYSO Certifications` LIKE '%Scheduler%'
            AND `AYSO Certifications` <> 'z-Online Regional Referee without Safe Haven'
            AND `AYSO Certifications` <> 'Z-Online Regional Referee'
            AND `AYSO Certifications` <> 'Z-Online Safe Haven Referee'
            AND `AYSO Certifications` <> 'Safe Haven Referee'
    GROUP BY `AYSO ID`, FIELD(`AYSO Certifications`, 'National Referee', 'National 2 Referee', 'Advanced Referee', 'Intermediate Referee', 'Regional Referee', 'Regional Referee & Safe Haven Referee', 'Assistant Referee', 'Assistant Referee & Safe Haven Referee', 'U-8 Official', 'U-8 Official & Safe Haven Referee', '')) grouped ) ranked
    WHERE
        rankID = 1
    ORDER BY `AYSO ID`, `MY` DESC, `AYSO Region #`, FIELD(`AYSO Certifications`, 'National Referee', 'National 2 Referee', 'Advanced Referee', 'Intermediate Referee', 'Regional Referee', 'Regional Referee & Safe Haven Referee', 'Assistant Referee', 'Assistant Referee & Safe Haven Referee', 'U-8 Official', 'U-8 Official & Safe Haven Referee', ''), `AYSO Region #`, `Volunteer Last Name`, `Volunteer First Name`, `AYSO ID`;
");

PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;

ALTER TABLE `crs_rpt_hrc` ADD INDEX (`AYSOID`);

END$$

DROP PROCEDURE IF EXISTS `RefreshCertDateErrors`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `RefreshCertDateErrors` ()  BEGIN
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
        c.`CertificationDesc` LIKE 'Advanced Referee Course'
            AND u.`CertificationDesc` LIKE 'Avanced Referee' UNION SELECT DISTINCT
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
        c.`CertificationDesc` LIKE 'Intermediate Referee Course'
            AND u.`CertificationDesc` LIKE 'Intermediate Referee' UNION SELECT DISTINCT
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
        c.`CertificationDesc` LIKE 'National Referee Assessor Course'
            AND u.`CertificationDesc` LIKE 'National Referee Assessor' UNION SELECT DISTINCT
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
        c.`CertificationDesc` LIKE 'Referee Assessor Course'
            AND u.`CertificationDesc` LIKE 'Referee Assessor' UNION SELECT DISTINCT
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
        c.`CertificationDesc` LIKE 'Advanced Referee Instructor Course'
            AND u.`CertificationDesc` LIKE 'Advanced Referee Instructor' UNION SELECT DISTINCT
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
        c.`CertificationDesc` LIKE 'Referee Instructor Course'
            AND u.`CertificationDesc` LIKE 'Referee Instructor' UNION SELECT DISTINCT
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
        'Referee Instructor Evaluator') , `Section` , `Area` , `Region`"
);

PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;

END$$

DROP PROCEDURE IF EXISTS `RefreshCompositeRefCerts`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `RefreshCompositeRefCerts` ()  BEGIN
DROP TABLE IF EXISTS crs_rpt_ref_certs;

CREATE TABLE crs_rpt_ref_certs SELECT * FROM
    (SELECT DISTINCT
        hrc.*,
		sh.CertificationDesc AS shCertificationDesc,
		sh.CertDate AS shCertDate,
		cdc.CDCCert AS cdcCertificationDesc,
		cdc.CDCCertDate AS cdcCertDate, 
		sca.SCACert AS scaCertificationDesc,
		sca.SCACertDate AS scaCertDate 
    FROM
        crs_rpt_hrc hrc
			LEFT JOIN 
        crs_rpt_safehaven sh ON hrc.aysoid = sh.aysoid
			LEFT JOIN
		crs_rpt_ref_cdc cdc ON hrc.AYSOID = cdc.aysoid
			LEFT JOIN
		crs_rpt_ref_sca sca ON hrc.AYSOID = sca.aysoid) a
ORDER BY SAR;

END$$

DROP PROCEDURE IF EXISTS `RefreshConcussionCerts`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `RefreshConcussionCerts` ()  BEGIN
SET @id:= 0;

DROP TABLE IF EXISTS crs_cdc;
SET @s = CONCAT("
CREATE TABLE crs_cdc SELECT 
	`Program Name`,
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
        `CertificationDesc` LIKE '%Concussion%' 
    GROUP BY `AYSOID`, `Membership Year` DESC, `CertDate` DESC, `SAR`) con ) ordered) ranked
WHERE
    rank = 1
ORDER BY `Section` , `Area` , `Region` , `Last Name`;
");
    
PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;

ALTER TABLE crs_cdc ADD INDEX (`AYSOID`);

END$$

DROP PROCEDURE IF EXISTS `RefreshCurrentMY`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `RefreshCurrentMY` ()  BEGIN

DROP TABLE IF EXISTS `crs_current_my`;

CREATE TABLE `crs_current_my`
SELECT 
    DISTINCT `AYSOID`, `Membership Year`
FROM
    (SELECT 
        *,
            @rank:=IF(@id = `AYSOID` AND `Membership Year` < @my, @rank + 1, 1) AS rank,
            @id:=`AYSOID`,
            @my:=`Membership Year`
    FROM
        (SELECT DISTINCT
        `AYSOID`, `Membership Year`
    FROM
        crs_refcerts
    ORDER BY AYSOID, `Membership Year` DESC) ordered
    GROUP BY AYSOID, `Membership Year`) ranked
WHERE
    rank = 1;
END$$

DROP PROCEDURE IF EXISTS `RefreshDupicateRefCerts`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `RefreshDupicateRefCerts` ()  BEGIN


DROP TABLE IF EXISTS tmp_duprefcerts;

CREATE TEMPORARY TABLE tmp_duprefcerts SELECT 
    *
FROM
    (SELECT 
        e.`AYSOID`,
        bs.`AYSOID` AS `bsAYSOID`,
		bs.`Name`,
		bs.`First Name`,
		bs.`Last Name`,
		bs.`Address`,
		bs.`City`,
		bs.`Email`,
        bs.`Gender`,
        bs.`CertDate`

    FROM
        crs_rpt_hrc e
    LEFT JOIN crs_rpt_hrc bs USING (`Email`, `Gender`, `CertDate`)
 ) g
WHERE
    `AYSOID` - `bsAYSOID` < 0
        AND `AYSOID` <= 99999999
        AND `bsAYSOID` > 99999999;
END$$

DROP PROCEDURE IF EXISTS `RefreshHighestAYSOCertification`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `RefreshHighestAYSOCertification` ()  BEGIN
SET sql_mode=(SELECT REPLACE(@@GLOBAL.sql_mode,'ONLY_FULL_GROUP_BY',''));

SET @id:= 0;

DROP TABLE IF EXISTS crs_rpt_all_hrc;

SET @s = CONCAT("
	CREATE TABLE crs_rpt_all_hrc SELECT DISTINCT
	`MY` text,
	`AYSO ID` text,
	`Volunteer First Name` text,
	`Volunteer Last Name` text,
	`AYSO Certifications` text,
	`Date of Last AYSO Certification Update` text,
	`AYSO Region #` text
FROM
    (SELECT 
        *,
            @rankID:=IF(@id = `AYSO ID` AND @region = `AYSO Region #`, @rankID + 1, 1) AS rankID,
            @id:=`AYSO ID`,
            @region:=`AYSO Region #`
    FROM
        (SELECT 
        *
    FROM
        `crs_refcerts`
    WHERE
        NOT `AYSO Certifications` LIKE '%Assessor%'
            AND NOT `AYSO Certifications` LIKE '%Instructor%'
            AND NOT `AYSO Certifications` LIKE '%Administrator%'
            AND NOT `AYSO Certifications` LIKE '%VIP%'
            AND NOT `AYSO Certifications` LIKE '%Course%'
            AND NOT `AYSO Certifications` LIKE '%Scheduler%'
            AND `AYSO Certifications` <> 'z-Online Regional Referee without Safe Haven'
            AND `AYSO Certifications` <> 'Z-Online Regional Referee'
            AND `AYSO Certifications` <> 'Z-Online Safe Haven Referee'
            AND `AYSO Certifications` <> 'Safe Haven Referee'
    GROUP BY `AYSOID`, FIELD(`AYSO Certifications`, 'National Referee', 'National 2 Referee', 'Advanced Referee', 'Intermediate Referee', 'Regional Referee', 'Regional Referee & Safe Haven Referee', 'Assistant Referee', 'Assistant Referee & Safe Haven Referee', 'U-8 Official', 'U-8 Official & Safe Haven Referee', '')) grouped ) ranked
    WHERE
        rankID = 1
    ORDER BY FIELD(`AYSO Certifications`, 'National Referee', 'National 2 Referee', 'Advanced Referee', 'Intermediate Referee', 'Regional Referee', 'Regional Referee & Safe Haven Referee', 'Assistant Referee', 'Assistant Referee & Safe Haven Referee', 'U-8 Official', 'U-8 Official & Safe Haven Referee', ''), `AYSO Region #`, `Volunteer Last Name`, `Volunteer First Name`, `AYSO ID`;
");

PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;

ALTER TABLE `crs_rpt_all_hrc` ADD INDEX (`AYSO ID`);

END$$

DROP PROCEDURE IF EXISTS `RefreshHighestCertification`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `RefreshHighestCertification` ()  BEGIN
SET sql_mode=(SELECT REPLACE(@@GLOBAL.sql_mode,'ONLY_FULL_GROUP_BY',''));

SET @id:= 0;

DROP TABLE IF EXISTS crs_rpt_hrc;

SET @s = CONCAT("
	CREATE TABLE crs_rpt_hrc SELECT DISTINCT
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
            @rankID:=IF(@id = `AYSOID`, @rankID + 1, 1) AS rankID,
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
            AND `CertificationDesc` <> 'z-Online Regional Referee without Safe Haven'
            AND `CertificationDesc` <> 'Z-Online Regional Referee'
            AND `CertificationDesc` <> 'Z-Online Safe Haven Referee'
            AND `CertificationDesc` <> 'Safe Haven Referee'
    GROUP BY `AYSOID`, `Membership Year` DESC, `SAR`, FIELD(`CertificationDesc`, 'National Referee', 'National 2 Referee', 'Advanced Referee', 'Intermediate Referee', 'Regional Referee', 'Regional Referee & Safe Haven Referee', 'Assistant Referee', 'Assistant Referee & Safe Haven Referee', 'U-8 Official', '8U Official', 'U-8 Official & Safe Haven Referee', 'Z-Online 8U Official', '')) grouped ) ranked
    WHERE
        rankID = 1
    ORDER BY `AYSOID`, `Membership Year` DESC, `Section`, `Area`, `Region`, FIELD(`CertificationDesc`, 'National Referee', 'National 2 Referee', 'Advanced Referee', 'Intermediate Referee', 'Regional Referee', 'Regional Referee & Safe Haven Referee', 'Assistant Referee', 'Assistant Referee & Safe Haven Referee', 'U-8 Official', '8U Official', 'U-8 Official & Safe Haven Referee', 'Z-Online 8U Official', ''), `Section`, `Area`, `Region`, `Last Name`, `First Name`, AYSOID;
");

PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;

ALTER TABLE `crs_rpt_hrc` ADD INDEX (`AYSOID`);

END$$

DROP PROCEDURE IF EXISTS `RefreshIntermediateRefereeInstructors`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `RefreshIntermediateRefereeInstructors` ()  BEGIN
UPDATE tmp_rpt_ri SET `CertificationDesc` = 'Regional Referee Instructor' WHERE `CertificationDesc` = 'Referee Instructor' OR `CertificationDesc` = 'Basic Referee Instructor';   

# Voluteer updates
UPDATE tmp_rpt_ri SET `CertificationDesc` = 'Intermediate Referee Instructor' WHERE `AYSOID` IN (SELECT AYSOID FROM crs_intermediate_referee_instructors); 
END$$

DROP PROCEDURE IF EXISTS `RefreshNationalRefereeAssessors`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `RefreshNationalRefereeAssessors` ()  BEGIN
SET @id:= 0;
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DROP TABLE IF EXISTS `crs_rpt_nra`;

CREATE TEMPORARY TABLE `crs_rpt_nra` SELECT * FROM
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
        `CertificationDesc` LIKE 'National Referee Assessor' 
    ORDER BY `Membership Year` DESC, `SAR`) ordered
    GROUP BY `AYSOID` 
    ) ranked
    WHERE
        rank = 1
	GROUP BY `Email`
    ORDER BY CertificationDesc , `Section` , `Area` , `Last Name` , `First Name` , `AYSOID`) ra;
    
    UPDATE `crs_rpt_nra` SET `Membership Year` = (SELECT `Membership Year` FROM `crs_current_my` my WHERE `crs_rpt_nra`.`AYSOID` = my.`AYSOID`);
    
END$$

DROP PROCEDURE IF EXISTS `RefreshRefCerts`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `RefreshRefCerts` ()  BEGIN
DROP TABLE IF EXISTS crs_refcerts;

CREATE TABLE crs_refcerts SELECT * FROM
    crs_certs
WHERE
    (`CertificationDesc` LIKE '%Referee%'
    OR `CertificationDesc` LIKE '%Official%')
        AND NOT `CertificationDesc` LIKE 'Z-Online Regional Referee%'
        AND NOT `CertificationDesc` LIKE 'Regional Referee online%'
        AND NOT `CertificationDesc` LIKE '%Annual Referee Update'
        AND `Volunteer Role` <> 'General Volunteer (Not Coach, Referee or Manager)'
		AND `Volunteer Role` <> 'TEST ONLY - Referee';
        
UPDATE `crs_refcerts` 
SET 
    `CertificationDesc` = 'Regional Referee'
WHERE
    `CertificationDesc` = 'Regional Referee & Safe Haven Referee';

UPDATE `crs_refcerts` 
SET 
    `CertificationDesc` = 'Assistant Referee'
WHERE
    `CertificationDesc` = 'Assistant Referee & Safe Haven Referee';

UPDATE `crs_refcerts` 
SET 
    `CertificationDesc` = '8U Official'
WHERE
    `CertificationDesc` = 'U-8 Official & Safe Haven Referee';
END$$

DROP PROCEDURE IF EXISTS `RefreshRefConcussionCerts`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `RefreshRefConcussionCerts` ()  BEGIN
SET @id:= 0;

DROP TABLE IF EXISTS crs_rpt_ref_cdc;
SET @s = CONCAT("CREATE TABLE crs_rpt_ref_cdc SELECT 
hrc.*, cdc.CertificationDesc AS cdcCert, cdc.CertDate AS cdcCertDate 
FROM `crs_cdc` cdc
RIGHT JOIN `crs_rpt_hrc` hrc 
ON cdc.AYSOID = hrc.AYSOID
ORDER BY `Section`, `Area`, `Region`;
");
    
PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;

ALTER TABLE crs_rpt_ref_cdc ADD INDEX (`AYSOID`);

END$$

DROP PROCEDURE IF EXISTS `RefreshRefereeAssessors`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `RefreshRefereeAssessors` ()  BEGIN
SET @id:= 0;

DROP TABLE IF EXISTS crs_rpt_ra;

CREATE TABLE crs_rpt_ra SELECT * FROM
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
  	ORDER BY `AYSOID`, `Membership Year` DESC, `SAR`, FIELD(`CertificationDesc`, 'National Referee Assessor', 'Referee Assessor') ) ordered         
    GROUP BY `AYSOID` , FIELD(`CertificationDesc`, 'National Referee Assessor', 'Referee Assessor')) ranked
    WHERE
        rank = 1
    GROUP BY `Email`
    ORDER BY CertificationDesc , `Section` , `Area` , `Region` , `Last Name` , `First Name` , AYSOID) ra;
    
	UPDATE `crs_rpt_ra` SET `Membership Year` = (SELECT `Membership Year` FROM `crs_current_my` my WHERE `crs_rpt_ra`.`AYSOID` = my.`AYSOID`);

END$$

DROP PROCEDURE IF EXISTS `RefreshRefereeInstructorEvaluators`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `RefreshRefereeInstructorEvaluators` ()  BEGIN
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

SET @id:= 0;

DROP TABLE IF EXISTS crs_rpt_rie;

CREATE TABLE crs_rpt_rie SELECT DISTINCT * FROM
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
            AND ar.`CertificationDesc` LIKE '%Referee Instructor'
    GROUP BY `AYSOID`, `SAR`, FIELD(ar.`CertificationDesc`, 'National Referee Instructor', 'Advanced Referee Instructor', 'Intermediate Referee Instructor', 'Referee Instructor', ''), `Membership Year` DESC) grouped ) ranked 
    WHERE
        rank = 1
    ORDER BY `Section`, `Area`, `Region`, `Membership Year` DESC, `Last Name`, `First Name`) rie;

    UPDATE `crs_rpt_rie` SET `Membership Year` = (SELECT `Membership Year` FROM `crs_current_my` my WHERE `crs_rpt_rie`.`AYSOID` = my.`AYSOID`);

END$$

DROP PROCEDURE IF EXISTS `RefreshRefereeInstructors`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `RefreshRefereeInstructors` ()  BEGIN
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

SET @id:= 0;

DROP TABLE IF EXISTS crs_rpt_ri;

CREATE TABLE crs_rpt_ri SELECT * FROM
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
        `CertificationDesc` LIKE '%Referee Instructor%'
            AND NOT `CertificationDesc` LIKE '%Evaluator%'
            AND NOT `CertificationDesc` LIKE '%Assessor%'
            AND NOT `CertificationDesc` LIKE '%Course%'
            AND NOT `CertificationDesc` LIKE '%Assistant%'
            AND NOT `CertificationDesc` LIKE '%Official%'
            AND NOT `CertificationDesc` LIKE '%Webinar%'
            AND NOT `CertificationDesc` LIKE '%Online%'
            AND NOT `CertificationDesc` LIKE '%Safe Haven%'
		ORDER BY `AYSOID`, `Membership Year` DESC, `SAR`, FIELD(`CertificationDesc`, 'National Referee Instructor', 'Advanced Referee Instructor', 'Intermediate Referee Instructor', 'Regional Referee Instructor', 'Referee Instructor', 'Basic Referee Instructor', 'Grade2 Referee Instructor')) ordered 
    GROUP BY `AYSOID` , FIELD(`CertificationDesc`, 'National Referee Instructor', 'Advanced Referee Instructor', 'Intermediate Referee Instructor', 'Regional Referee Instructor', 'Referee Instructor', 'Basic Referee Instructor', 'Grade2 Referee Instructor')) ranked
    WHERE
        rank = 1) ri;

    UPDATE `crs_rpt_ri` SET `Membership Year` = (SELECT `Membership Year` FROM `crs_current_my` my WHERE `crs_rpt_ri`.`AYSOID` = my.`AYSOID`);
    
END$$

DROP PROCEDURE IF EXISTS `RefreshRefereeUpgradeCandidates`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `RefreshRefereeUpgradeCandidates` ()  BEGIN
DROP TABLE IF EXISTS tmp_NatRC;

CREATE TEMPORARY TABLE tmp_NatRC SELECT * FROM
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
        LOWER(`CertificationDesc`) = LOWER('National Referee Course')
    GROUP BY `AYSOID` , `Membership Year` DESC, `SAR`) ordered) ranked
WHERE
    rank = 1;

DROP TABLE IF EXISTS tmp_NatR;

CREATE TEMPORARY TABLE tmp_NatR SELECT `AYSOID`, `CertDate` FROM
    crs_refcerts
WHERE
    LOWER(`CertificationDesc`) = LOWER('National Referee');

DROP TABLE IF EXISTS tmp_ref_upgrades;

CREATE TEMPORARY TABLE tmp_ref_upgrades SELECT DISTINCT course.`AYSOID`,
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
    tmp_NatRC course
        LEFT JOIN
    tmp_NatR upgraded ON course.`AYSOID` = upgraded.`AYSOID`
WHERE
    upgraded.`CertDate` IS NULL;
        

DROP TABLE IF EXISTS tmp_AdvRC;

CREATE TEMPORARY TABLE tmp_AdvRC SELECT * FROM
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
        LOWER(`CertificationDesc`) = LOWER('Advanced Referee Course')
    GROUP BY `AYSOID`, `Membership Year` DESC, `SAR`) ordered) ranked 
WHERE
    rank = 1;

DROP TABLE IF EXISTS tmp_AdvR;

CREATE TEMPORARY TABLE tmp_AdvR SELECT `AYSOID`, `CertDate` FROM
    crs_refcerts
WHERE
    LOWER(`CertificationDesc`) = LOWER('Advanced Referee');

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
        

DROP TABLE IF EXISTS tmp_IntRC;

CREATE TEMPORARY TABLE tmp_IntRC SELECT * FROM
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
        LOWER(`CertificationDesc`) = LOWER('Intermediate Referee Course')
    GROUP BY `AYSOID`, `Membership Year` DESC, `SAR`) ordered) ranked 
WHERE
    rank = 1;

DROP TABLE IF EXISTS tmp_IntR;

CREATE TEMPORARY TABLE tmp_IntR SELECT `AYSOID`, `CertDate` FROM
    crs_refcerts
WHERE
    LOWER(`CertificationDesc`) = LOWER('Intermediate Referee');

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
        
DROP TABLE IF EXISTS tmp_IntR;
DROP TABLE IF EXISTS tmp_IntRC;     


DROP TABLE IF EXISTS tmp_RAC;

CREATE TEMPORARY TABLE tmp_RAC SELECT * FROM
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
        LOWER(`CertificationDesc`) = LOWER('Referee Assessor Course')
    GROUP BY `AYSOID`, `Membership Year` DESC, `SAR`) ordered) ranked 
WHERE
    rank = 1;

DROP TABLE IF EXISTS tmp_RA;

CREATE TEMPORARY TABLE tmp_RA SELECT `AYSOID`, `CertDate` FROM
    crs_refcerts
WHERE
    LOWER(`CertificationDesc`) = LOWER('Referee Assessor');

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
        tmp_RAC course LEFT JOIN tmp_RA upgraded ON course.`AYSOID` = upgraded.`AYSOID`
    WHERE
        upgraded.`CertDate` IS NULL;
        
DROP TABLE IF EXISTS tmp_NRAC;

CREATE TEMPORARY TABLE tmp_NRAC SELECT * FROM
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
        LOWER(`CertificationDesc`) = LOWER('National Referee Assessor Course')
    GROUP BY `AYSOID`, `Membership Year` DESC, `SAR`) ordered) ranked 
WHERE
    rank = 1;

DROP TABLE IF EXISTS tmp_NRA;

CREATE TEMPORARY TABLE tmp_NRA SELECT `AYSOID`, `CertDate` FROM
    crs_refcerts
WHERE
    LOWER(`CertificationDesc`) = LOWER('National Referee Assessor');

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
        tmp_NRAC course LEFT JOIN tmp_NRA upgraded ON course.`AYSOID` = upgraded.`AYSOID`
    WHERE
        upgraded.`CertDate` IS NULL;
        
DROP TABLE IF EXISTS tmp_RIC;

CREATE TEMPORARY TABLE tmp_RIC SELECT * FROM
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
        LOWER(`CertificationDesc`) = LOWER('Referee Instructor Course')
    GROUP BY `AYSOID`, `Membership Year` DESC, `SAR`) ordered) ranked 
WHERE
    rank = 1;

DROP TABLE IF EXISTS tmp_RI;

CREATE TEMPORARY TABLE tmp_RI SELECT `AYSOID`, `CertDate` FROM
    crs_refcerts
WHERE
    LOWER(`CertificationDesc`) = LOWER('Referee Instructor') OR 
    LOWER(`CertificationDesc`) = LOWER('Regional Referee Instructor') OR 
    LOWER(`CertificationDesc`) = LOWER('Intermediate Referee Instructor');

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
        tmp_RIC course LEFT JOIN tmp_RI upgraded ON course.`AYSOID` = upgraded.`AYSOID`
    WHERE
        upgraded.`CertDate` IS NULL;
        
DROP TABLE IF EXISTS tmp_ARIC;

CREATE TEMPORARY TABLE tmp_ARIC SELECT * FROM
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
        LOWER(`CertificationDesc`) = LOWER('Advanced Referee Instructor Course')
    GROUP BY `AYSOID`, `Membership Year` DESC, `SAR`) ordered) ranked 
WHERE
    rank = 1;

DROP TABLE IF EXISTS tmp_ARI;

CREATE TEMPORARY TABLE tmp_ARI SELECT `AYSOID`, `CertDate` FROM
    crs_refcerts
WHERE
    (`CertificationDesc`) = ('Advanced Referee Instructor');

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
        tmp_ARIC course LEFT JOIN tmp_ARI upgraded ON course.`AYSOID` = upgraded.`AYSOID`
    WHERE
        upgraded.`CertDate` IS NULL;
        

DROP TABLE IF EXISTS tmp_RIEC;

CREATE TEMPORARY TABLE tmp_RIEC SELECT * FROM
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
        LOWER(`CertificationDesc`) = LOWER('Referee Instructor Evaluator Course')
    GROUP BY `AYSOID`, `Membership Year` DESC, `SAR`) ordered) ranked 
WHERE
    rank = 1;

DROP TABLE IF EXISTS tmp_RIE;

CREATE TEMPORARY TABLE tmp_RIE SELECT `AYSOID`, `CertDate` FROM
    crs_refcerts
WHERE
    LOWER(`CertificationDesc`) = LOWER('Referee Instructor Evaluator');

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
        tmp_RIEC course LEFT JOIN tmp_RIE upgraded ON course.`AYSOID` = upgraded.`AYSOID`
    WHERE
        upgraded.`CertDate` IS NULL;
        
DROP TABLE IF EXISTS crs_rpt_ref_upgrades;

CREATE TABLE crs_rpt_ref_upgrades SELECT DISTINCT * FROM
    tmp_ref_upgrades
ORDER BY FIELD(`CertificationDesc`,
        'National Referee Course',
        'Advanced Referee Course',
        'Intermediate Referee Course',
        'Referee Assessor Course',
        'National Referee Assessor Course',
        'Referee Instructor Course',
        'Advanced Referee Instructor Course',
        'Referee Instructor Evaluator Course'), `Section` , `Area` , `Region` , `CertDate`;

    UPDATE `crs_rpt_ref_upgrades` SET `Membership Year` = (SELECT `Membership Year` FROM `crs_current_my` my WHERE `crs_rpt_ref_upgrades`.`AYSOID` = my.`AYSOID`);
        
END$$

DROP PROCEDURE IF EXISTS `RefreshRefNoCerts`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `RefreshRefNoCerts` ()  SQL SECURITY INVOKER
BEGIN   
SET sql_mode = "STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION";
 
DROP TABLE IF EXISTS crs_rpt_nocerts;

CREATE TABLE crs_rpt_nocerts SELECT 
    *
FROM
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
            `Volunteer Role`,
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
    GROUP BY `AYSOID`, `Membership Year` DESC, `SAR`) ordered) ranked
    WHERE
        rank = 1) s1
WHERE `Volunteer Role` LIKE '%Referee' 
	AND `CertificationDesc` = '' 
    AND NOT `Volunteer Role` LIKE 'TEST%'
ORDER BY `Section`, `Area`, `Region`;

UPDATE `crs_rpt_nocerts` SET `Membership Year` = (SELECT `Membership Year` FROM `crs_current_my` my WHERE `crs_rpt_nocerts`.`AYSOID` = my.`AYSOID`);

END$$

DROP PROCEDURE IF EXISTS `RefreshRefSuddenCardiacArrestCerts`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `RefreshRefSuddenCardiacArrestCerts` ()  BEGIN
SET @id:= 0;

DROP TABLE IF EXISTS crs_rpt_ref_sca;
SET @s = CONCAT("CREATE TABLE crs_rpt_ref_sca SELECT 
hrc.*, sca.CertificationDesc AS scaCert, sca.CertDate AS scaCertDate 
FROM `crs_sca` sca
RIGHT JOIN `crs_rpt_hrc` hrc 
ON sca.AYSOID = hrc.AYSOID
ORDER BY `Section`, `Area`, `Region`;
");
    
PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;

ALTER TABLE crs_rpt_ref_sca ADD INDEX (`AYSOID`);

END$$

DROP PROCEDURE IF EXISTS `RefreshSafeHavenCerts`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `RefreshSafeHavenCerts` ()  BEGIN
SET @id:= 0;

DROP TABLE IF EXISTS crs_rpt_safehaven;

SET @s = CONCAT("
CREATE TABLE crs_rpt_safehaven SELECT 
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
    FROM (SELECT 
    	sh.`Program Name`,
		sh.`Membership Year`,
		sh.`Volunteer Role`,
		sh.`AYSOID`,
		sh.`Name`,
		sh.`First Name`,
		sh.`Last Name`,
		sh.`Address`,
		sh.`City`,
		sh.`State`,
		sh.`Zip`,
		sh.`Home Phone`,
		sh.`Cell Phone`,
		sh.`Email`,
		sh.`Gender`,
		sh.`CertificationDesc`,
		sh.`CertDate`,
		sh.`SAR`,
		sh.`Section`,
		sh.`Area`,
		sh.`Region`
    FROM 
        crs_shcerts sh RIGHT JOIN crs_rpt_hrc hrc USING (`AYSOID`)
	WHERE sh.`CertificationDesc` LIKE '%AYSOs Safe Haven'
		OR sh.`CertificationDesc` LIKE '%Refugio Seguro de AYSO'
    ORDER BY `AYSOID`, sh.`CertDate` DESC, `SAR`) ordered
    GROUP BY `AYSOID`, `CertDate`) ranked
WHERE
    rank = 1
ORDER BY `Section`, `Area`, `Region`, `Last Name`, `First Name`");
    
PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;

ALTER TABLE crs_rpt_safehaven ADD INDEX (`AYSOID`);

UPDATE `crs_rpt_safehaven` SET `Membership Year` = (SELECT `Membership Year` FROM `crs_current_my` my WHERE `crs_rpt_safehaven`.`AYSOID` = my.`AYSOID`);

END$$

DROP PROCEDURE IF EXISTS `RefreshSection8RefereeInstructors`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `RefreshSection8RefereeInstructors` ()  BEGIN
SET sql_mode=(SELECT REPLACE(@@GLOBAL.sql_mode,'ONLY_FULL_GROUP_BY',''));

SET @id:= 0;

DROP TABLE IF EXISTS crs_rpt_s8_ri;

SET @s = CONCAT("
	CREATE TABLE crs_rpt_s8_ri SELECT DISTINCT
	`AYSO ID`,
	`Volunteer First Name`,
	`Volunteer Last Name`,
	`Volunteer Cell`,
    `Volunteer Email`,
	`AYSO Certifications`,
	`Date of Last AYSO Certification Update`,
	`AYSO Region #`
FROM
    (SELECT 
	`MY`,
	`AYSO ID`,
	`Volunteer First Name`,
	`Volunteer Last Name`,
	`Volunteer Cell`,
    `Volunteer Email`,
	`AYSO Certifications`,
	`Date of Last AYSO Certification Update`,
	`AYSO Region #`,
            @rankID:=IF(@id = `AYSO ID`, @rankID + 1, 1) AS rankID,
            @id:=`AYSO ID`,
            @region:=`AYSO Region #`
    FROM
        (SELECT 
        *
    FROM
        `crs_Section8_certs`
    WHERE
        NOT `AYSO Certifications` LIKE '%Assessor%'
            AND `AYSO Certifications` LIKE '%Instructor%'
            AND NOT `AYSO Certifications` LIKE '%Evaluator%'
            AND NOT `AYSO Certifications` LIKE '%Administrator%'
            AND NOT `AYSO Certifications` LIKE '%VIP%'
            AND NOT `AYSO Certifications` LIKE '%Course%'
            AND NOT `AYSO Certifications` LIKE '%Scheduler%'
            AND `AYSO Certifications` <> 'z-Online Regional Referee without Safe Haven'
            AND `AYSO Certifications` <> 'Z-Online Regional Referee'
            AND `AYSO Certifications` <> 'Z-Online Safe Haven Referee'
            AND `AYSO Certifications` <> 'Safe Haven Referee'
    GROUP BY `AYSO ID`, FIELD(`AYSO Certifications`, 'National Referee Instructor', 'Advanced Referee Instructor', 'Intermediate Referee Instructor', 'Referee Instructor', 'Basic Referee Instructor', '')) grouped ) ranked
    WHERE
        rankID = 1
    ORDER BY FIELD(`AYSO Certifications`, 'National Referee Instructor', 'Advanced Referee Instructor', 'Intermediate Referee Instructor', 'Referee Instructor', 'Basic Referee Instructor', ''), `AYSO Region #`, `Volunteer Last Name`, `Volunteer First Name`, `AYSO ID`;
");

PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;

ALTER TABLE `crs_rpt_s8_ri` ADD INDEX (`AYSO ID`);

END$$

DROP PROCEDURE IF EXISTS `RefreshSuddenCardiacArrestCerts`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `RefreshSuddenCardiacArrestCerts` ()  BEGIN
SET @id:= 0;
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DROP TABLE IF EXISTS crs_sca;

SET @s = CONCAT("
CREATE TABLE crs_sca SELECT 
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
            @rank:=IF(@id = `AYSOID`, @my <>  @rank + 1, 1) AS rank,
            @id:=`AYSOID`,
            @my:=`Membership Year`
    FROM (SELECT * FROM 
        crs_certs
    WHERE
        `CertificationDesc` LIKE '%Sudden Cardiac Arrest%' 
	ORDER BY `Membership Year`, `AYSOID`, `CertDate` DESC) ordered 
    GROUP BY `AYSOID`, `SAR`) ranked
WHERE
    rank = 1) s
ORDER BY `Section` , `Area` , `Region` , `Last Name`;
");
    
PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;

ALTER TABLE crs_sca ADD INDEX (`AYSOID`);

UPDATE `crs_sca` SET `Membership Year` = (SELECT `Membership Year` FROM `crs_current_my` my WHERE NOT my.`Membership Year` IS NULL AND `crs_sca`.`AYSOID` = my.`AYSOID`);

-- 2021-08-30: Added as Sports Connect Volunteer Certification reports no longer being updated
DROP TABLE IF EXISTS tmp_e3_certs;

CREATE TABLE tmp_e3_certs SELECT crs.`AYSOID`, `scaCertificationDesc`, `scaCertDate`, `SCA Date` FROM
    `crs_rpt_ref_certs` crs
        LEFT JOIN
    `e3_InLeague_certifications` e3 ON crs.`AYSOID` = e3.`AYSOID`;

UPDATE `tmp_e3_certs` 
SET 
    `scaCertificationDesc` = 'e3 Sudden Cardiac Arrest Training',
    `scaCertDate` = `SCA Date`
WHERE 
    `tmp_e3_certs`.`SCA Date` <> '';

UPDATE `crs_sca` 
SET 
    `CertificationDesc` = (SELECT `scaCertificationDesc` FROM `tmp_e3_certs` WHERE `crs_sca`.`AYSOID` = `tmp_e3_certs`.`AYSOID`),
    `CertDate` = (SELECT `scaCertDate` FROM `tmp_e3_certs` WHERE `crs_sca`.`AYSOID` = `tmp_e3_certs`.`AYSOID`);
                
-- 2021-08-21: END: modified to update MY from inLeague registrations and certifications from e3

DROP TABLE IF EXISTS tmp_e3_certs;


END$$

DROP PROCEDURE IF EXISTS `RefreshUnregisteredReferees`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `RefreshUnregisteredReferees` ()  BEGIN
SET @dfields := "'National Referee', 'National 2 Referee', 'Advanced Referee', 'Intermediate Referee', 'Regional Referee', 'Regional Referee & Safe Haven Referee', 'z-Online Regional Referee without Safe Haven', 'Z-Online Regional Referee', 'Assistant Referee', 'Assistant Referee & Safe Haven Referee', 'U-8 Official', 'U-8 Official & Safe Haven Referee', 'Z-Online Safe Haven Referee', 'Safe Haven Referee', ''";

SET @currentMY = currentMY();

DROP TABLE IF EXISTS crs_rpt_unregistered_refs;

CREATE TABLE crs_rpt_unregistered_refs SELECT * FROM
    (SELECT 
        *
    FROM
        ayso1ref_services.crs_rpt_hrc
    WHERE
        `Membership Year` < @currentMY) unreg
ORDER BY `Section` , `Area` , `Region` , FIELD(`CertificationDesc`,
        'National Referee',
        'National 2 Referee',
        'Advanced Referee',
        'Intermediate Referee',
        'Regional Referee',
        'Regional Referee & Safe Haven Referee',
        'z-Online Regional Referee without Safe Haven',
        'Z-Online Regional Referee',
        'Assistant Referee',
        'Assistant Referee & Safe Haven Referee',
        'U-8 Official',
        'U-8 Official & Safe Haven Referee',
        'Z-Online Safe Haven Referee',
        'Safe Haven Referee',
        '');
END$$

DROP PROCEDURE IF EXISTS `rs_ar1AssignmentMap`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `rs_ar1AssignmentMap` (IN `projectKey` VARCHAR(45), IN `has4th` VARCHAR(45))  BEGIN
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
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `rs_ar2AssignmentMap` (IN `projectKey` VARCHAR(45), IN `has4th` VARCHAR(45))  BEGIN
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
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `rs_crAssignmentMap` (IN `projectKey` VARCHAR(45), IN `has4th` VARCHAR(45))  BEGIN
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
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `rs_r4thAssignmentMap` (IN `projectKey` VARCHAR(45), IN `has4th` VARCHAR(45))  BEGIN
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
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` PROCEDURE `UpdateCompositeMYCerts` ()  BEGIN

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DROP TABLE IF EXISTS `tmp_composite`;

CREATE TEMPORARY TABLE `tmp_composite` SELECT * FROM
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
			TRIM(AYSOID) AS AYSOID,
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
			crs_rpt_hrc) hrc
		GROUP BY `AYSOID` , Field(`Membership Year`, 'MY2020', 'MY2019', 'MY2018', 'MY2017', 'MY2016'), `Section`, `Area`) grouped ) ranked
		ORDER BY AYSOID, `Membership Year` DESC) composite;

DROP TABLE IF EXISTS `s1_composite_my_certs`;

CREATE TABLE s1_composite_my_certs SELECT DISTINCT * FROM (
		SELECT 
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
				@rankID:=IF(@id = `AYSOID`, @rankID + 1, 1) AS rankID,
				@id:=`AYSOID`,
				@rankMY:=IF(@my=`Membership Year` OR @rankID=1, 1, @rankMY + 1) AS rankMY,
				@my:=`Membership Year`
			FROM tmp_composite) ranked
            
		WHERE rankMY = 1) s1;
        
END$$

--
-- Functions
--
DROP FUNCTION IF EXISTS `currentMY`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` FUNCTION `currentMY` () RETURNS CHAR(12) CHARSET latin1 BEGIN
SET @year = year(now());

IF month(now()) < 8 THEN
	SET @year = @year - 1;
END IF;

SET @currentMY = CONCAT('MY', @year);

RETURN @currentMY;
END$$

DROP FUNCTION IF EXISTS `ExtractAlpha`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` FUNCTION `ExtractAlpha` (`in_string` VARCHAR(50)) RETURNS TEXT CHARSET latin1 BEGIN

    DECLARE ctrNumber varchar(50);
    DECLARE finText text default ' ';
    DECLARE sChar varchar(2);
    DECLARE inti INTEGER default 1;

    IF length(in_string) > 0 THEN

        WHILE(inti <= length(in_string)) DO
            SET sChar= SUBSTRING(in_string,inti,1);
            SET ctrNumber= FIND_IN_SET(sChar,'0,1,2,3,4,5,6,7,8,9');

            IF ctrNumber = 0 THEN
               SET finText=CONCAT(finText,sChar);
            ELSE
               SET finText=CONCAT(finText,'');
            END IF;
            SET inti=inti+1;
        END WHILE;
        RETURN TRIM(finText);
    ELSE
        RETURN '';
    END IF;
END$$

DROP FUNCTION IF EXISTS `ExtractNumber`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` FUNCTION `ExtractNumber` (`in_string` VARCHAR(50)) RETURNS INT(11) NO SQL
BEGIN
    DECLARE ctrNumber VARCHAR(50);
    DECLARE finNumber VARCHAR(50) DEFAULT '';
    DECLARE sChar VARCHAR(1);
    DECLARE inti INTEGER DEFAULT 1;

    IF LENGTH(in_string) > 0 THEN
        WHILE(inti <= LENGTH(in_string)) DO
            SET sChar = SUBSTRING(in_string, inti, 1);
            SET ctrNumber = FIND_IN_SET(sChar, '0,1,2,3,4,5,6,7,8,9'); 
            IF ctrNumber > 0 THEN
                SET finNumber = CONCAT(finNumber, sChar);
            END IF;
            SET inti = inti + 1;
        END WHILE;
        IF LENGTH(finNumber) > 0 THEN
			RETURN CAST(finNumber AS UNSIGNED);
		END IF;
    END IF;    
	
    RETURN -1;
END$$

DROP FUNCTION IF EXISTS `format_as_phone_number`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` FUNCTION `format_as_phone_number` (`Phone` TEXT) RETURNS TEXT CHARSET latin1 BEGIN
DECLARE n text;
IF Phone = '' THEN RETURN ''; END IF; 
SET n = CONCAT(LEFT(Phone, 3), '-', SUBSTRING(Phone, 4,3), '-', RIGHT(Phone,4));
RETURN n;
END$$

DROP FUNCTION IF EXISTS `isMYCurrent`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` FUNCTION `isMYCurrent` (`strMY` VARCHAR(11)) RETURNS TINYINT(1) BEGIN
SET @MY = YEAR(STR_TO_DATE(CONCAT(RIGHT(strMY, 4), '0801'),'%Y%m%d'));
SET @cutoffYear = YEAR(DATE_SUB(CURRENT_DATE(), INTERVAL 5 YEAR));
RETURN @MY >= @cutoffYear;
END$$

DROP FUNCTION IF EXISTS `loadAdminCredentialStatusDynamic`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` FUNCTION `loadAdminCredentialStatusDynamic` (`csvFile` VARCHAR(128)) RETURNS VARCHAR(128) CHARSET latin1 BEGIN

RETURN CONCAT('/Users/rick/Google_Drive.rick.roberts.9/_ayso/s1/reports/stack_sports_reporting/_stack/', csvFile, '.AdminCredentialsStatusDynamic.csv');

/*
SET @s = CONCAT("
LOAD DATA LOCAL INFILE '", @inCSV, "'
	INTO TABLE `AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
");

PREPARE stmt FROM @s;  
EXECUTE stmt;  

DEALLOCATE PREPARE stmt;
*/

END$$

DROP FUNCTION IF EXISTS `multiTrim`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` FUNCTION `multiTrim` (`string` TEXT, `remove` CHAR(63)) RETURNS TEXT CHARSET latin1 BEGIN
  
  WHILE length(string)>0 and remove LIKE concat('%',substring(string,-1),'%') DO
    set string = substring(string,1,length(string)-1);
  END WHILE;

  
  WHILE length(string)>0 and remove LIKE concat('%',left(string,1),'%') DO
    set string = substring(string,2);
  END WHILE;

  RETURN string;
END$$

DROP FUNCTION IF EXISTS `PROPER_CASE`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` FUNCTION `PROPER_CASE` (`str` VARCHAR(255)) RETURNS VARCHAR(255) CHARSET utf8 BEGIN 
  DECLARE c CHAR(1); 
  DECLARE s VARCHAR(255); 
  DECLARE i INT DEFAULT 1; 
  DECLARE bool INT DEFAULT 1; 
  DECLARE punct CHAR(18) DEFAULT ' ()[]{},.-_!@;:?/';
  SET s = LCASE( str ); 
  WHILE i <= LENGTH( str ) DO 
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
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` FUNCTION `SPLIT_STRING` (`str` VARCHAR(255), `delim` VARCHAR(12), `pos` INT) RETURNS VARCHAR(255) CHARSET utf8 BEGIN
RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(str, delim, pos),
       LENGTH(SUBSTRING_INDEX(str, delim, pos-1)) + 1),
       delim, '');
RETURN 1;
END$$

DROP FUNCTION IF EXISTS `stdSAR`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` FUNCTION `stdSAR` (`pStr` TEXT) RETURNS VARCHAR(20) CHARSET utf8 BEGIN

SET @result = '';
CALL explode(pStr);

SELECT GROUP_CONCAT(TRIM(LEADING '0' FROM word) SEPARATOR '/') as stdSAR
FROM temp_explode GROUP BY k INTO @result;

RETURN @result;
END$$

DROP FUNCTION IF EXISTS `yyTOyyyy`$$
CREATE DEFINER=`s2vzjyga9n1ho`@`localhost` FUNCTION `yyTOyyyy` (`mmddyy` TEXT) RETURNS TEXT CHARSET latin1 BEGIN

SET @yymmdd:= DATE_FORMAT(STR_TO_DATE(mmddyy, '%m/%d/%y'),'%Y%m%d');

IF @yymmdd > CURRENT_DATE()+1 THEN

	SET @yymmdd = @yymmdd - 1000000;

END IF;


RETURN DATE_FORMAT(STR_TO_DATE(@yymmdd, '%Y%m%d'),'%Y-%m-%d');
END$$

DELIMITER ;

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
