USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

/***************************************/
--  Load SportsConnect certs`

-- init table crs_certs
DROP TABLE IF EXISTS crs_certs;

CREATE TABLE `crs_certs` (
	`Program Name` text,
	`Membership Year` varchar(200),
	`Volunteer Role` text,
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

DROP TABLE IF EXISTS `crs_1_certs`;  
CREATE TABLE `crs_1_certs` SELECT DISTINCT * FROM `tmp_1_certs`;  

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

-- /***************************************/
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
-- 
/***************************************/
--  Process the lot

-- 2019-03-18: added because eAYSO is now returning blank dates for invalid dates
UPDATE crs_certs 
SET 
    CertDate = '1964-09-15'
WHERE
    CertificationDesc LIKE '%Referee%'
        AND CertDate = '';        

-- -08-07: added because BS is not updating certifications across all portals; each record must be opened for certs to update
UPDATE crs_certs 
SET 
    CertificationDesc = 'Intermediate Referee Instructor'
WHERE
    (CertificationDesc = 'Referee Instructor'
    OR CertificationDesc = 'Basic Referee Instructor')
        AND CertDate <= '2018-08-01';        

UPDATE crs_certs 
SET 
    CertificationDesc = 'Regional Referee Instructor'
WHERE
    (CertificationDesc = 'Referee Instructor'
    OR CertificationDesc = 'Basic Referee Instructor')
        AND CertDate > '2018-08-01';        

-- Apply special cases  
CALL `CertTweaks`('crs_certs');   
CALL `CertTweaks`('crs_shcerts');   

-- Refresh all referee certificates - required to remove duplicate records  
CALL `RefreshRefCerts`();  

-- Delete records duplicated across Membership Years
DROP TABLE IF EXISTS tmp_dupmy;

CREATE TEMPORARY TABLE tmp_dupmy SELECT 
	AYSOID, `Membership Year`
FROM
	(SELECT 
			*,
	@rank:=IF(@id = `AYSOID`, @rank + 1, 1) AS rank,
	@id:=`AYSOID`
	FROM
			(SELECT DISTINCT
			`AYSOID`, `Membership Year`
	FROM
			crs_refcerts
	ORDER BY `Membership Year` DESC) ordered
	GROUP BY AYSOID , `Membership Year`) ranked
WHERE
	rank = 1;

ALTER TABLE tmp_dupmy ADD INDEX (`AYSOID`);
ALTER TABLE tmp_dupmy ADD INDEX (`Membership Year`);

DROP TABLE IF EXISTS tmp_refcerts;

CREATE TEMPORARY TABLE tmp_refcerts SELECT DISTINCT n1.* FROM
	crs_refcerts n1
			INNER JOIN
	tmp_dupmy d ON n1.`AYSOID` = d.`AYSOID`
			AND n1.`Membership Year` = d.`Membership Year`;

DROP TABLE IF EXISTS crs_refcerts;

CREATE TABLE crs_refcerts SELECT * FROM
	tmp_refcerts;
    
DELETE FROM crs_refcerts WHERE AYSOID IN (SELECT AYSOID FROM crs_duplicateIDs);    

-- Removed those that have moved on 
DELETE FROM crs_refcerts WHERE AYSOID IN (SELECT AYSOID FROM crs_not_available WHERE Reason = 'deceased');    

-- Removed those that have indicated they are no longer interested in assessing or instructing 
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
SET @s = CONCAT("UPDATE crs_rpt_hrc SET CertificationDesc = 'Intermediate Referee', CertDate = '-01-12' WHERE `AYSOID` = 74607360;");
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


-- 2021-04-12 : added to update MY from Stack Sports AdminCredentialsStatusDynamic reports

DROP TABLE IF EXISTS `AdminCredentialsStatusDynamic`;

CREATE TABLE `AdminCredentialsStatusDynamic` (
  `﻿Textbox332` text,
  `League1` text,
  `Club1` text,
  `ClubID1` text,
  `IDNUM` text,
  `AltID1` int(11) DEFAULT NULL,
  `FirstName1` text,
  `LastName1` text,
  `DOB1` text,
  `GenderCode1` text,
  `email1` text,
  `RiskSubmitDate1` text,
  `RiskStatus1` text,
  `RiskExpireDate1` text,
  `cardPrinted1` text,
  `photoInDate1` text,
  `licLevel1` text,
  `licNum1` text,
  `LicObtainDate1` text,
  `refGrade` text,
  `refObtainDate` text,
  `refExpDate` text,
  `CertificateName2` text,
  `ccInDate1` text,
  `ccVerified1` text,
  `ccVerifyBy1` text,
  `ccVerifyDate1` text,
  `ExpirationDateC1` text
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
    
ALTER TABLE `ayso1ref_services`.`AdminCredentialsStatusDynamic` 
CHANGE COLUMN `﻿Textbox332` `MY` TEXT NULL DEFAULT NULL;    

-- 2021-06-14: added to update MY from inLeague registrations in 1C & 1P

DROP TABLE IF EXISTS `inLeague_registration`;

CREATE TABLE `inLeague_registration` (
  `Section` int(11) DEFAULT NULL,
  `Area` text,
  `Region` int(11) DEFAULT NULL,
  `AYSOID` int(11) DEFAULT NULL,
  `Membershipyear` text,
  `Volunteer Position` text,
  `LastName` text,
  `FirstName` text,
  `DOB` text,
  `Gender` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2020.Volunteer_Report_Export.csv'
	INTO TABLE `inLeague_registration`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2021.Volunteer_Report_Export.csv'
	INTO TABLE `inLeague_registration`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
DROP TABLE IF EXISTS `tmp_MY`;   

CREATE TEMPORARY TABLE `tmp_MY` (
	`AYSOID` int(11),
    `MY` text,
	`First_Name` text,
	`Last_Name` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `tmp_MY` SELECT DISTINCT `AltID1`, RIGHT(`MY`,6),`FirstName1`, `LastName1` FROM `AdminCredentialsStatusDynamic`;
INSERT INTO `tmp_MY` SELECT 
    `AYSOID`,
    `MY`,
    `FirstName`,
    `LastName`
FROM
    (SELECT 
        *,
            @rankID:=IF(@id = `AYSOID`, @rankID + 1, 1) AS rankID,
            @id:=`AYSOID`
    FROM
        (SELECT DISTINCT
        `Section`,
            `Area`,
            `Region`,
            `AYSOID`,
            `Membershipyear` as 'MY',
            `Volunteer Position`,
            `LastName`,
            `FirstName`,
            `DOB`,
            `Gender`
    FROM
        ayso1ref_services.inLeague_registration
    GROUP BY `AYSOID` , `MY`) grouped) ranked
WHERE
    rankID = 1
ORDER BY `AYSOID`,`MY` DESC;

DELETE FROM `tmp_MY` WHERE `AYSOID` = 0;

-- remove duplicate records
DROP TABLE IF EXISTS `copy_MY`;
CREATE TABLE `copy_MY` LIKE `tmp_MY`;

INSERT INTO `copy_MY`
SELECT * FROM `tmp_MY`
GROUP BY `AYSOID`; 

DROP TABLE `tmp_MY`;

ALTER TABLE `copy_MY` RENAME TO `tmp_MY`;
-- END: remove duplicate records

UPDATE `crs_rpt_ref_certs` SET `Membership Year` = (SELECT `MY` FROM `tmp_MY` WHERE `crs_rpt_ref_certs`.`AYSOID` = `tmp_MY`.`AYSOID`) WHERE `AYSOID` IN (SELECT `AYSOID` FROM `tmp_MY`);
UPDATE `crs_rpt_ref_upgrades` SET `Membership Year` = (SELECT `MY` FROM `tmp_MY` WHERE `crs_rpt_ref_upgrades`.`AYSOID` = `tmp_MY`.`AYSOID`) WHERE `AYSOID` IN (SELECT `AYSOID` FROM `tmp_MY`);
UPDATE `crs_rpt_ri` SET `Membership Year` = (SELECT `MY` FROM `tmp_MY` WHERE `crs_rpt_ri`.`AYSOID` = `tmp_MY`.`AYSOID`) WHERE `AYSOID` IN (SELECT `AYSOID` FROM `tmp_MY`);
UPDATE `crs_rpt_rie` SET `Membership Year` = (SELECT `MY` FROM `tmp_MY` WHERE `crs_rpt_rie`.`AYSOID` = `tmp_MY`.`AYSOID`) WHERE `AYSOID` IN (SELECT `AYSOID` FROM `tmp_MY`);
UPDATE `crs_rpt_nra` SET `Membership Year` = (SELECT `MY` FROM `tmp_MY` WHERE `crs_rpt_nra`.`AYSOID` = `tmp_MY`.`AYSOID`) WHERE `AYSOID` IN (SELECT `AYSOID` FROM `tmp_MY`);
UPDATE `crs_rpt_ra` SET `Membership Year` = (SELECT `MY` FROM `tmp_MY` WHERE `crs_rpt_ra`.`AYSOID` = `tmp_MY`.`AYSOID`) WHERE `AYSOID` IN (SELECT `AYSOID` FROM `tmp_MY`);
UPDATE `crs_rpt_hrc` SET `Membership Year` = (SELECT `MY` FROM `tmp_MY` WHERE `crs_rpt_hrc`.`AYSOID` = `tmp_MY`.`AYSOID`) WHERE `AYSOID` IN (SELECT `AYSOID` FROM `tmp_MY`);
DELETE FROM `crs_rpt_unregistered_refs` WHERE `AYSOID` in (SELECT `AYSOID` FROM `tmp_MY`);

-- 2021-06-20: Updated to drop registrations more then 4 years old
DELETE FROM `crs_rpt_ref_certs` WHERE NOT isMYCurrent(`Membership Year`);
DELETE FROM `crs_rpt_ref_upgrades` WHERE NOT isMYCurrent(`Membership Year`);
DELETE FROM `crs_rpt_ri` WHERE NOT isMYCurrent(`Membership Year`);
DELETE FROM `crs_rpt_rie` WHERE NOT isMYCurrent(`Membership Year`);
DELETE FROM `crs_rpt_nra` WHERE NOT isMYCurrent(`Membership Year`);
DELETE FROM `crs_rpt_ra` WHERE NOT isMYCurrent(`Membership Year`);
DELETE FROM `crs_rpt_hrc` WHERE NOT isMYCurrent(`Membership Year`);
DELETE FROM `crs_rpt_unregistered_refs` WHERE NOT isMYCurrent(`Membership Year`);
-- 2021-06-20: END: Added to drop registrations more then 4 years old

DROP TABLE IF EXISTS `tmp_MY`;

-- 2021-04-12 : END: added to update MY from Stack Sports AdminCredentialsStatusDynamic reports
-- 2021-06-14: END: added to update MY from inLeague registrations in 1C & 1P

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
ORDER BY `Section`, `Area`, `Region`, `Last Name`;
