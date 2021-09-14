USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

-- UNCOMMENT TO REFRESH crs_certs & crs_shcerts
/***************************************
-- 2021-09-10: SportConnet report files are no longer updating.  No need to refresh.

--  Load SportsConnect certs`

-- init table crs_certs
DROP TABLE IF EXISTS crs_2020_certs;

CREATE TABLE `crs_2020_certs` (
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

ALTER TABLE crs_2020_certs AUTO_INCREMENT = 0; 
ALTER TABLE crs_2020_certs ADD INDEX (`AYSOID`);
ALTER TABLE crs_2020_certs ADD INDEX (`Membership Year`);

-- init table crs_shcerts
DROP TABLE IF EXISTS crs_2020_shcerts;

CREATE TABLE `crs_2020_shcerts` (
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

ALTER TABLE `crs_2020_shcerts` 
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
UPDATE `crs_1_certs` SET `Program Name` = REPLACE(`Program Name`, '"', '');
UPDATE `crs_1_certs` SET `Volunteer Role` = REPLACE(`Volunteer Role`, '"', '');
UPDATE `crs_1_certs` SET `Volunteer Address` = REPLACE(`Volunteer Address`, '"', '');
UPDATE `crs_1_certs` SET `Volunteer City` = REPLACE(`Volunteer City`, '"', '');
UPDATE `crs_1_certs` SET `Portal Name` = REPLACE(`Portal Name`, '"', '');

ALTER TABLE `crs_1_certs` 
ADD INDEX (`AYSO Volunteer ID`),
ADD INDEX (`Portal Name`);

# Maureen Reid 73895502 registered Section 1 in error lives in Pennsylvania
DELETE FROM `crs_1_certs` WHERE `AYSO Volunteer ID` = 73895502;

CALL `processBSCSV`('crs_1_certs');  

-- 2021-01-06: eAYSO report files are no longer available.  No need to update.
--  Load eAYSO certs`

--  Load `eAYSO.MY2017.certs`
-- CALL `prepEAYSOCSVTable`('eAYSO.MY2016.certs');
-- 
-- LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/eAYSO.MY2016.certs.csv'
-- 	INTO TABLE `eAYSO.MY2016.certs`   
-- 	FIELDS TERMINATED BY ','   
-- 	ENCLOSED BY '"'  
-- 	LINES TERMINATED BY '\n'
-- 	IGNORE 1 ROWS;   
-- 
-- --  Load `eAYSO.MY2017.certs`
-- CALL `prepEAYSOCSVTable`('eAYSO.MY2017.certs');
-- 
-- LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/eAYSO.MY2017.certs.csv'
-- 	INTO TABLE `eAYSO.MY2017.certs`   
-- 	FIELDS TERMINATED BY ','   
-- 	ENCLOSED BY '"'  
-- 	LINES TERMINATED BY '\n'
-- 	IGNORE 1 ROWS;   
-- 	
-- --  Refresh `eAYSO.MY2018.certs`
-- CALL `prepEAYSOCSVTable`('eAYSO.MY2018.certs');
-- 
-- LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/eAYSO.MY2018.certs.csv'
-- 	INTO TABLE `eAYSO.MY2018.certs`   
-- 	FIELDS TERMINATED BY ','   
-- 	ENCLOSED BY '"'  
-- 	LINES TERMINATED BY '\n'
-- 	IGNORE 1 ROWS;   
-- 
-- --  Refresh `eAYSO.MY2019.certs`
-- CALL `prepEAYSOCSVTable`('eAYSO.MY2019.certs');
-- 
-- LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/eAYSO.MY2019.certs.csv'
-- 	INTO TABLE `eAYSO.MY2019.certs`   
-- 	FIELDS TERMINATED BY ','   
-- 	ENCLOSED BY '"'  
-- 	LINES TERMINATED BY '\n'
-- 	IGNORE 1 ROWS;   
--
-- Still need to add eAYSO certs to crs_certs and crs_shcerts 
CALL `processEAYSOCSV`();

-- 2021-08-20: fix S/A/R format to remove leading zeros from Region, e.g. '1/B/0003' should be '1/B/3'
UPDATE crs_2020_certs 
SET SAR = REPLACE(SAR, '/0', '/');
UPDATE crs_2020_certs 
SET SAR = REPLACE(SAR, '/0', '/');
UPDATE crs_2020_certs 
SET SAR = REPLACE(SAR, '/0', '/');
-- END: 2021-08-20: fix S/A/R format to remove leading zeros from Region, e.g. '1/B/0003' should be '1/B/3'

-- 2019-03-18: added because eAYSO is now returning blank dates for invalid dates
UPDATE crs_2020_certs 
SET 
    CertDate = '1964-09-15'
WHERE
    CertificationDesc LIKE '%Referee%'
        AND CertDate = '';        
-- END: 2019-03-18: added because eAYSO is now returning blank dates for invalid dates

-- 2018-08-07: added because BS is not updating certifications across all portals; each record must be opened for certs to update
UPDATE crs_2020_certs 
SET 
    CertificationDesc = 'Intermediate Referee Instructor'
WHERE
    (CertificationDesc = 'Referee Instructor'
    OR CertificationDesc = 'Basic Referee Instructor')
        AND CertDate <= '2018-08-01';        

UPDATE crs_2020_certs 
SET 
    CertificationDesc = 'Regional Referee Instructor'
WHERE
    (CertificationDesc = 'Referee Instructor'
    OR CertificationDesc = 'Basic Referee Instructor')
        AND CertDate > '2018-08-01';        
-- END: 2018-08-07: added because BS is not updating certifications across all portals; each record must be opened for certs to update

-- Apply special cases  
CALL `CertTweaks`('crs_2020_certs');   
CALL `CertTweaks`('crs_2020_shcerts');   

DROP TABLE IF EXISTS `crs_certs`;
CREATE TABLE `crs_certs` (SELECT * FROM
    `crs_2020_certs`);
DROP TABLE IF EXISTS `crs_shcerts`;
CREATE TABLE `crs_shcerts` (SELECT * FROM
    `crs_2020_shcerts`);

**************************************/

-- 2021-04-12 : added to update MY from Stack Sports AdminCredentialsStatusDynamic reports

DROP TABLE IF EXISTS `AdminCredentialsStatusDynamic`;

CREATE TABLE `AdminCredentialsStatusDynamic` (
  `﻿Textbox332` text,
  `CertificateName` text,
  `League` text,
  `Club` text,
  `ClubID` text,
  `CORIRegDate1` text,
  `IDNUM1` text,
  `AltID` int(11) DEFAULT NULL,
  `FirstName` text,
  `LastName` text,
  `DOB1` text,
  `GenderCode` text,
  `email` text,
  `IDVerified1` text,
  `IDVerifiedBY1` text,
  `IDVerifiedDate1` text,
  `RiskSubmitDate` text,
  `RiskStatus` text,
  `RiskExpireDate` text,
  `cardPrinted` text,
  `photoInDate` text,
  `licLevel` text,
  `licNum` text,
  `LicObtainDate` text,
  `refGrade1` text,
  `refObtainDate1` text,
  `refExpDate1` text,
  `ccInDate` text,
  `ccVerified` text,
  `ccVerifyBy` text,
  `ccVerifyDate` text,
  `ExpirationDateC` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1B.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1C.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1D.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1F.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1G.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1H.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1N.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1P.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1R.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1S.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1U.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
ALTER TABLE `AdminCredentialsStatusDynamic` 
CHANGE COLUMN `﻿Textbox332` `MY` TEXT NULL DEFAULT NULL;   

DELETE FROM ayso1ref_services.AdminCredentialsStatusDynamic 
WHERE
    `Club` IS NULL; 
-- Format date for MYSQL
UPDATE `AdminCredentialsStatusDynamic`  SET `ccInDate`=STR_TO_DATE(`ccInDate`, "%m/%d/%Y") WHERE `ccInDate` <> ''; 
-- Fix AltID1 error for Blanca Bocanegra
UPDATE `AdminCredentialsStatusDynamic`  SET `AltID`='63106447' WHERE `IDNUM1` = '68354-528194'; 

CALL `ayso1ref_services`.`mergeAdminCredentialsStatusDynamic`();

CALL `ayso1ref_services`.`RefreshCurrentMY`();

-- Refresh all referee certificates
CALL `RefreshRefCerts`();  

-- 2021-04-12 : END: added to update MY from Stack Sports AdminCredentialsStatusDynamic reports

-- 2021-06-14: added to update MY from inLeague registrations in 1C & 1P from e3
DROP TABLE IF EXISTS `e3_InLeague_certifications`;

CREATE TABLE `e3_InLeague_certifications` (
  `AYSOID` int(11) DEFAULT NULL,
  `Full Name` text,
  `Type` text,
  `SAR` text,
  `MY` text,
  `Safe Haven Date` text,
  `CDC Date` text,
  `SCA Date` text,
  `Ref Cert Desc` text,
  `Ref Cert Date` text,
  `Assessor Cert Desc` text,
  `Assessor Cert Date` text,
  `Inst Cert Desc` text,
  `Inst Cert Date` text,
  `Inst Eval Cert Desc` text,
  `Inst Eval Cert Date` text,
  `Coach Cert Desc` text,
  `Coach Cert Date` text,
  `Data Source` text,
  `Section` int(11) DEFAULT NULL,
  `Area` text,
  `Region` int(11) DEFAULT NULL,
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

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/Volunteer_Certs_InLeague.txt'
	INTO TABLE `e3_InLeague_certifications`   
	FIELDS TERMINATED BY '\t'   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

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

UPDATE `crs_rpt_ref_certs` 
SET 
    `scaCertificationDesc` = (SELECT `scaCertificationDesc` FROM `tmp_e3_certs` WHERE `crs_rpt_ref_certs`.`AYSOID` = `tmp_e3_certs`.`AYSOID`),
    `scaCertDate` = (SELECT `scaCertDate` FROM `tmp_e3_certs` WHERE `crs_rpt_ref_certs`.`AYSOID` = `tmp_e3_certs`.`AYSOID`);

DROP TABLE IF EXISTS tmp_e3_certs;
                
-- 2021-08-21: END: modified to update MY from inLeague registrations and certifications from e3


-- END: remove duplicate records
-- 2021-06-20: Updated to drop registrations more then 4 years old
DELETE FROM `crs_refcerts` WHERE NOT isMYCurrent(`Membership Year`);
-- 2021-06-20: END: Added to drop registrations more then 4 years old

/***************************************/
--  Process the lot

-- Delete records duplicated across Membership Years
-- DROP TABLE IF EXISTS tmp_dupmy;
-- 
-- CREATE TEMPORARY TABLE tmp_dupmy SELECT 
-- 	AYSOID, `Membership Year`
-- FROM
-- 	(SELECT 
-- 			*,
-- 	@rank:=IF(@id = `AYSOID`, @rank + 1, 1) AS rank,
-- 	@id:=`AYSOID`
-- 	FROM
-- 			(SELECT DISTINCT
-- 			`AYSOID`, `Membership Year`
-- 	FROM
-- 			crs_refcerts
-- 	ORDER BY `Membership Year` DESC) ordered
-- 	GROUP BY AYSOID , `Membership Year`) ranked
-- WHERE
-- 	rank = 1;
-- 
-- ALTER TABLE tmp_dupmy ADD INDEX (`AYSOID`);
-- ALTER TABLE tmp_dupmy ADD INDEX (`Membership Year`);
-- 
-- DROP TABLE IF EXISTS tmp_refcerts;
-- 
-- CREATE TEMPORARY TABLE tmp_refcerts SELECT DISTINCT n1.* FROM
-- 	crs_refcerts n1
-- 			INNER JOIN
-- 	tmp_dupmy d ON n1.`AYSOID` = d.`AYSOID`
-- 			AND n1.`Membership Year` = d.`Membership Year`;
-- 
-- DROP TABLE IF EXISTS crs_refcerts;
-- 
-- ALTER TABLE `tmp_refcerts` RENAME TO `crs_refcerts`;
--     
DELETE FROM crs_refcerts WHERE AYSOID IN (SELECT AYSOID FROM crs_duplicateIDs);    

-- Removed those that have moved on 
DELETE FROM crs_refcerts WHERE AYSOID IN (SELECT AYSOID FROM crs_not_available WHERE Reason = 'deceased');    

-- Removed those that have indicated they are no longer available for assessing or instructing 
DELETE FROM crs_refcerts 
WHERE
    AYSOID IN (SELECT 
        AYSOID
    FROM
        crs_not_available)
    AND (`CertificationDesc` LIKE '%Assessor%'
    OR `CertificationDesc` LIKE '%Instructor%');    

-- Refresh Highest Certification table after deletion of duplicate records
CALL `RefreshHighestCertification`();

-- Daniel Gomez fix  
SET @s = CONCAT("UPDATE crs_rpt_hrc SET CertificationDesc = 'Intermediate Referee', CertDate = '2020-02-12' WHERE `AYSOID` = 74607360;");
CALL exec_qry(@s);
--

CALL `RefreshDupicateRefCerts`();

DELETE FROM crs_refcerts
WHERE `AYSOID` in (SELECT DISTINCT `AYSOID` FROM tmp_duprefcerts);

DELETE FROM crs_rpt_hrc
WHERE `AYSOID` in (SELECT DISTINCT `AYSOID` FROM tmp_duprefcerts);

-- Refresh all temporary tables
CALL `RefreshRefereeAssessors`();  
CALL `RefreshNationalRefereeAssessors`();  
CALL `RefreshRefereeInstructors`();  
CALL `RefreshRefereeInstructorEvaluators`();  
-- CALL `RefreshRefNoCerts`();  
CALL `RefreshRefereeUpgradeCandidates`();  
CALL `RefreshUnregisteredReferees`();  -- depends on current crs_rpt_hrc
CALL `RefreshSafeHavenCerts`();  
CALL `RefreshConcussionCerts`();  
CALL `RefreshRefConcussionCerts`();   
CALL `RefreshSuddenCardiacArrestCerts`();
CALL `RefreshRefSuddenCardiacArrestCerts`();
CALL `RefreshCertDateErrors`();
CALL `RefreshCompositeRefCerts`();


-- Update Tables for Referee Scheduler
DROP TABLE IF EXISTS rs_refs;
CREATE TABLE rs_refs SELECT 
	* 
FROM crs_rpt_hrc;
ALTER TABLE rs_refs ADD INDEX (`AYSOID`);

DROP TABLE IF EXISTS tmp_refUpdate;
CREATE TEMPORARY TABLE tmp_refUpdate SELECT 
	*
FROM
	(SELECT 
		hrc.*
	FROM
		crs_rpt_hrc hrc
	LEFT JOIN rs_refs r ON r.AYSOID = hrc.AYSOID
	WHERE
		r.AYSOID IS NULL) new;
				
INSERT INTO rs_refNicknames (`AYSOID`, `Name`, `Nickname`)
SELECT AYSOID, Name, Name FROM tmp_refUpdate;

-- Update timestamp table  
SET time_zone='+00:00';
DROP TABLE IF EXISTS `crs_rpt_lastUpdate`;  
CREATE TABLE `crs_rpt_lastUpdate` SELECT NOW() AS timestamp;
ALTER TABLE crs_rpt_lastUpdate
CHANGE COLUMN `timestamp` `timestamp` DATETIME NOT NULL DEFAULT '1901-01-01 00:00:00' ;
ALTER TABLE crs_rpt_lastUpdate ADD UNIQUE (`timestamp`);
 
-- Update Composite Cert table  
CALL `UpdateCompositeMYCerts`();  

UPDATE `s1_composite_my_certs` SET `Zip` = REPLACE(`Zip`, "'", '');
UPDATE `s1_composite_my_certs` SET `AYSOID` = REPLACE(`AYSOID`, " ", "");
ALTER TABLE `s1_composite_my_certs` 
CHANGE COLUMN `AYSOID` `AYSOID` INT(11); 

-- Select the composite results for download
SELECT 
    *
FROM
    `s1_composite_my_certs`
ORDER BY `Section` , `Area` , `Region` , `Last Name`;
