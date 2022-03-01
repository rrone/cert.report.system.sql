USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

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
ALTER TABLE crs_certs ADD INDEX (`aysoid`);
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

ALTER TABLE crs_shcerts AUTO_INCREMENT = 0; 
ALTER TABLE crs_shcerts ADD INDEX (`aysoid`);

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

LOAD DATA LOCAL INFILE '/Users/rick/Dropbox/_open/_ayso/s1/reports/data/1.txt'  
	INTO TABLE `tmp_1_certs`   
	FIELDS TERMINATED BY '\t'   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\r'
	IGNORE 1 ROWS;   

DELETE FROM ayso1ref_services.tmp_1_certs WHERE `Program Name` like '%Do not use%';

-- Recover from Regions deleting programs & volunteers each season
INSERT INTO `tmp_1_certs` SELECT * FROM `crs_1_201812_certs`;
INSERT INTO `tmp_1_certs` SELECT * FROM `crs_1_201905_certs`;

DROP TABLE IF EXISTS `crs_1_certs`;  
CREATE TABLE `crs_1_certs` SELECT DISTINCT * FROM `tmp_1_certs`;  

-- Clean up imported data
DELETE FROM `crs_1_certs` WHERE `AYSO Volunteer ID` IS NULL;
UPDATE `crs_1_certs` SET `Program Name` = REPLACE(`Program Name`, '"', '');
UPDATE `crs_1_certs` SET `Volunteer Role` = REPLACE(`Volunteer Role`, '"', '');
UPDATE `crs_1_certs` SET `Volunteer Address` = REPLACE(`Volunteer Address`, '"', '');
UPDATE `crs_1_certs` SET `Volunteer City` = REPLACE(`Volunteer City`, '"', '');
UPDATE `crs_1_certs` SET `Portal Name` = REPLACE(`Portal Name`, '"', '');

ALTER TABLE crs_1_certs ADD INDEX (`AYSO Volunteer ID`);
ALTER TABLE crs_1_certs ADD INDEX (`Portal Name`);

CALL `processBSCSV`('crs_1_certs');  

--  Refresh `eAYSO.MY2016.certs`
CALL `prepEAYSOCSVTable`('eAYSO.MY2016.certs');

LOAD DATA LOCAL INFILE '/Users/rick/Dropbox/_open/_ayso/s1/reports/data/eAYSO.MY2016.certs.csv'
	INTO TABLE `eAYSO.MY2016.certs`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\r'
	IGNORE 1 ROWS;   

--  Refresh `eAYSO.MY2017.certs`
CALL `prepEAYSOCSVTable`('eAYSO.MY2017.certs');

LOAD DATA LOCAL INFILE '/Users/rick/Dropbox/_open/_ayso/s1/reports/data/eAYSO.MY2017.certs.csv'
	INTO TABLE `eAYSO.MY2017.certs`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\r'
	IGNORE 1 ROWS;   
	
--  Refresh `eAYSO.MY2018.certs`
CALL `prepEAYSOCSVTable`('eAYSO.MY2018.certs');

LOAD DATA LOCAL INFILE '/Users/rick/Dropbox/_open/_ayso/s1/reports/data/eAYSO.MY2018.certs.csv'
	INTO TABLE `eAYSO.MY2018.certs`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\r'
	IGNORE 1 ROWS;   

--  Refresh `eAYSO.MY2019.certs`
CALL `prepEAYSOCSVTable`('eAYSO.MY2019.certs');

LOAD DATA LOCAL INFILE '/Users/rick/Dropbox/_open/_ayso/s1/reports/data/eAYSO.MY2019.certs.csv'
	INTO TABLE `eAYSO.MY2019.certs`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\r'
	IGNORE 1 ROWS;   

-- UPDATE `eAYSO.certs` SET `AYSOID` = REPLACE(`AYSOID`,'"','');
-- MY2016
UPDATE `eAYSO.MY2016.certs` SET `AYSOID` = REPLACE(`AYSOID`, '"', '');
UPDATE `eAYSO.MY2016.certs` SET `AYSOID` = REPLACE(`AYSOID`, unhex('0a'), '');
DELETE FROM `eAYSO.MY2016.certs` WHERE `AYSOID` = '';
ALTER TABLE `eAYSO.MY2016.certs` CHANGE COLUMN `AYSOID` `AYSOID` INT(11);
CALL `processEAYSOCSV`('eAYSO.MY2016.certs');
CALL `eAYSOHighestRefCert`('eAYSO.MY2016.certs');   

-- MY2017
UPDATE `eAYSO.MY2017.certs` SET `AYSOID` = REPLACE(`AYSOID`, '"', '');
UPDATE `eAYSO.MY2017.certs` SET `AYSOID` = REPLACE(`AYSOID`, unhex('0a'), '');
DELETE FROM `eAYSO.MY2017.certs` WHERE `AYSOID` = '';
ALTER TABLE `eAYSO.MY2017.certs` CHANGE COLUMN `AYSOID` `AYSOID` INT(11);
CALL `processEAYSOCSV`('eAYSO.MY2017.certs');    
CALL `eAYSOHighestRefCert`('eAYSO.MY2017.certs');   

-- MY2018
UPDATE `eAYSO.MY2018.certs` SET `AYSOID` = REPLACE(`AYSOID`, '"', '');
UPDATE `eAYSO.MY2018.certs` SET `AYSOID` = REPLACE(`AYSOID`, unhex('0a'), '');
DELETE FROM `eAYSO.MY2018.certs` WHERE `AYSOID` = '';
ALTER TABLE `eAYSO.MY2018.certs` CHANGE COLUMN `AYSOID` `AYSOID` INT(11);
CALL `processEAYSOCSV`('eAYSO.MY2018.certs');    
CALL `eAYSOHighestRefCert`('eAYSO.MY2018.certs');   

-- MY2019
UPDATE `eAYSO.MY2019.certs` SET `AYSOID` = REPLACE(`AYSOID`, '"', '');
UPDATE `eAYSO.MY2019.certs` SET `AYSOID` = REPLACE(`AYSOID`, unhex('0a'), '');
DELETE FROM `eAYSO.MY2019.certs` WHERE `AYSOID` = '';
ALTER TABLE `eAYSO.MY2019.certs` CHANGE COLUMN `AYSOID` `AYSOID` INT(11);
CALL `processEAYSOCSV`('eAYSO.MY2019.certs');    
CALL `eAYSOHighestRefCert`('eAYSO.MY2019.certs');   

-- 2019-03-18: added because eAYSO is now returning blank dates for invalid dates
UPDATE ayso1ref_services.crs_certs 
SET 
    CertDate = '1964-09-15'
WHERE
    CertificationDesc LIKE '%Referee%'
        AND CertDate = '';        

-- Apply special cases  
CALL `CertTweaks`('crs_certs');   
CALL `CertTweaks`('crs_shcerts');   

-- Refresh all referee certificates - requried to remove duplicate records  
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
		
-- Refresh Highest Certification table after deletion of duplicate records
CALL `RefreshHighestCertification`();  

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
CALL `RefreshCertDateErrors`();
CALL `RefreshCompositeRefCerts`();

-- Update Tables for Referee Scheduler
DROP TABLE IF EXISTS rs_s1_refs;
CREATE TABLE rs_s1_refs SELECT 
	* 
FROM crs_rpt_hrc;
ALTER TABLE rs_s1_refs ADD INDEX (`AYSOID`);

DROP TABLE IF EXISTS tmp_refUpdate;
CREATE TEMPORARY TABLE tmp_refUpdate SELECT 
	*
FROM
	(SELECT 
		hrc.*
	FROM
		crs_rpt_hrc hrc
	LEFT JOIN rs_s1_refs s1 ON s1.AYSOID = hrc.AYSOID
	WHERE
		s1.AYSOID IS NULL) new;
				
INSERT INTO rs_refNicknames (`AYSOID`, `Name`, `Nickname`)
SELECT AYSOID, Name, Name FROM tmp_refUpdate;

-- Update timestamp table  
DROP TABLE IF EXISTS `crs_rpt_lastUpdate`;  
CREATE TABLE `crs_rpt_lastUpdate` SELECT NOW() AS timestamp;
ALTER TABLE crs_rpt_lastUpdate
CHANGE COLUMN `timestamp` `timestamp` DATETIME NOT NULL DEFAULT '1901-01-01 00:00:00' ;
ALTER TABLE crs_rpt_lastUpdate ADD UNIQUE (`timestamp`);
 
CALL `UpdateCompositeMYCerts`();  

ALTER TABLE `s1_composite_my_certs` 
CHANGE COLUMN `AYSOID` `AYSOID` INT(11); 
UPDATE `s1_composite_my_certs` SET `Zip` = REPLACE(`Zip`, "'", '');

-- Get the composite results
SELECT 
		*
FROM
		`s1_composite_my_certs`;
