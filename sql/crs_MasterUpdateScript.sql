USE `wp_ayso1ref`;

-- init table crs_certs
DROP TABLE IF EXISTS crs_certs;

CREATE TABLE `crs_certs` (
  `Program Name` text,
  `Membership Year` text,
  `Volunteer Role` text,
  `AYSOID` text,
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

-- Refresh Section BS data table `crs_1_certs`
DROP TABLE IF EXISTS `crs_1_certs`;   

CREATE TABLE `crs_1_certs` (
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
  `Portal Name` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOAD DATA LOCAL INFILE '/Users/frederickroberts/Dropbox/_open/_ayso/s1/reports/data/1.txt'  
  INTO TABLE `crs_1_certs`   
  FIELDS TERMINATED BY '\t'   
  ENCLOSED BY ''  
  LINES TERMINATED BY '\r'
  IGNORE 1 ROWS;   

DELETE FROM `crs_1_certs` WHERE `AYSO Volunteer ID` IS NULL;
UPDATE `crs_1_certs` SET `Program Name` = REPLACE(`Program Name`, '"', '');

CALL `processBSCSV`('crs_1_certs');  

--  Refresh `eAYSO.MY2016.certs`
CALL `prepEAYSOCSVTable`('eAYSO.MY2016.certs');

LOAD DATA LOCAL INFILE '/Users/frederickroberts/Dropbox/_open/_ayso/s1/reports/data/eAYSO.MY2016.certs.csv'
  INTO TABLE `eAYSO.MY2016.certs`   
  FIELDS TERMINATED BY ','   
  ENCLOSED BY '"'  
  LINES TERMINATED BY '\r'
  IGNORE 1 ROWS;   

UPDATE `eAYSO.MY2016.certs` SET `AYSOID` = REPLACE(`AYSOID`, '"', '');
UPDATE `eAYSO.MY2016.certs` SET `AYSOID` = REPLACE(`AYSOID`, unhex('0a'), '');
ALTER TABLE `eAYSO.MY2016.certs` 
CHANGE COLUMN `AYSOID` `AYSOID` INT(11);

--  Refresh `eAYSO.MY2017.certs`
CALL `prepEAYSOCSVTable`('eAYSO.MY2017.certs');

LOAD DATA LOCAL INFILE '/Users/frederickroberts/Dropbox/_open/_ayso/s1/reports/data/eAYSO.MY2017.certs.csv'
  INTO TABLE `eAYSO.MY2017.certs`   
  FIELDS TERMINATED BY ','   
  ENCLOSED BY '"'  
  LINES TERMINATED BY '\r'
  IGNORE 1 ROWS;   
  
--  Refresh `eAYSO.MY2018.certs`
CALL `prepEAYSOCSVTable`('eAYSO.MY2018.certs');

LOAD DATA LOCAL INFILE '/Users/frederickroberts/Dropbox/_open/_ayso/s1/reports/data/eAYSO.MY2018.certs.csv'
  INTO TABLE `eAYSO.MY2018.certs`   
  FIELDS TERMINATED BY ','   
  ENCLOSED BY '"'  
  LINES TERMINATED BY '\r'
  IGNORE 1 ROWS;   

-- UPDATE `eAYSO.certs` SET `AYSOID` = REPLACE(`AYSOID`,'"','');
-- MY2016
UPDATE `eAYSO.MY2016.certs` SET `AYSOID` = REPLACE(`AYSOID`, '"', '');
UPDATE `eAYSO.MY2016.certs` SET `AYSOID` = REPLACE(`AYSOID`, unhex('0a'), '');
ALTER TABLE `eAYSO.MY2016.certs` 
CHANGE COLUMN `AYSOID` `AYSOID` INT(11);
CALL `processEAYSOCSV`('eAYSO.MY2016.certs');
CALL `eAYSOHighestRefCert`('eAYSO.MY2016.certs');   

-- MY2017
UPDATE `eAYSO.MY2017.certs` SET `AYSOID` = REPLACE(`AYSOID`, '"', '');
UPDATE `eAYSO.MY2017.certs` SET `AYSOID` = REPLACE(`AYSOID`, unhex('0a'), '');
ALTER TABLE `eAYSO.MY2017.certs` 
CHANGE COLUMN `AYSOID` `AYSOID` INT(11);
CALL `processEAYSOCSV`('eAYSO.MY2017.certs');    
CALL `eAYSOHighestRefCert`('eAYSO.MY2017.certs');   

-- MY2018
UPDATE `eAYSO.MY2018.certs` SET `AYSOID` = REPLACE(`AYSOID`, '"', '');
UPDATE `eAYSO.MY2018.certs` SET `AYSOID` = REPLACE(`AYSOID`, unhex('0a'), '');
ALTER TABLE `eAYSO.MY2018.certs` 
CHANGE COLUMN `AYSOID` `AYSOID` INT(11);
CALL `processEAYSOCSV`('eAYSO.MY2018.certs');    
CALL `eAYSOHighestRefCert`('eAYSO.MY2018.certs');   

-- Apply special cases  
CALL `CertTweaks`();   

-- Refresh all referee certificates - requried to remove duplicate records  
CALL `RefreshRefCerts`();  

-- Delete records duplicated across Membership Years
DROP TABLE IF EXISTS tmp_dupmy;

CREATE TABLE tmp_dupmy SELECT 
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
    GROUP BY AYSOID , `Membership Year` DESC) ranked) uno
WHERE
    rank = 1;

DROP TABLE IF EXISTS tmp_refcerts;

CREATE TABLE tmp_refcerts SELECT DISTINCT n1.* FROM
    crs_refcerts n1
        INNER JOIN
    tmp_dupmy d ON n1.`AYSOID` = d.`AYSOID`
        AND n1.`Membership Year` = d.`Membership Year`;

DROP TABLE IF EXISTS crs_refcerts;

CREATE TABLE crs_refcerts SELECT * FROM
    tmp_refcerts;
    
DROP TABLE IF EXISTS tmp_refcerts;

DROP TABLE IF EXISTS tmp_dupmy;
    
-- Delete regional records duplicated at Area Portals  
DELETE n1.* FROM crs_refcerts n1, crs_refcerts n2 WHERE n1.AYSOID = n2.AYSOID AND n1.`Region` = '' and n2.`Region` <> '';
-- Delete regional records duplicated at Section Portals  
DELETE n1.* FROM crs_refcerts n1, crs_refcerts n2 WHERE n1.AYSOID = n2.AYSOID AND n1.`Area` = ''and n2.`Area` <> '';


-- Refresh Highest Certification table after deletion of duplicate records
CALL `RefreshHighestCertification`();  

-- remove refcerts with multiple IDs in eAYSO and BS based on Highest Certification
-- not perfect / fails if volunteer registers with new email or new last name or regisgters multiple times in BS
DROP TABLE IF EXISTS tmp_duprefcerts;

CREATE TABLE tmp_duprefcerts SELECT 
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
		bs.`Email`

    FROM
        crs_tmp_hrc e
    LEFT JOIN crs_tmp_hrc bs USING (`Last Name`, `Email`)
 ) g
WHERE
    `AYSOID` - `bsAYSOID` < 0
        AND `AYSOID` <= 99999999
        AND `bsAYSOID` > 99999999;

DELETE FROM crs_refcerts
WHERE `AYSOID` in (SELECT DISTINCT `AYSOID` FROM tmp_duprefcerts);

DELETE FROM crs_tmp_hrc
WHERE `AYSOID` in (SELECT DISTINCT `AYSOID` FROM tmp_duprefcerts);

-- DROP TABLE IF EXISTS tmp_duprefcerts;

-- Refresh all temporary tables
CALL `RefreshRefereeAssessors`();  
CALL `RefreshNationalRefereeAssessors`();  
CALL `RefreshRefereeInstructors`();  
CALL `RefreshRefereeInstructorEvaluators`();  
CALL `RefreshRefNoCerts`();  
CALL `RefreshRefereeUpgradeCandidates`();  
CALL `RefreshUnregisteredReferees`();  
CALL `RefreshSafeHavenCerts`();  
CALL `RefreshConcussionCerts`();  
CALL `RefreshRefConcussionCerts`();   
CALL `RefreshCertDateErrors`();

-- Update timestamp table  
DROP TABLE IF EXISTS `crs_lastUpdate`;  
CREATE TABLE `crs_lastUpdate` SELECT NOW() AS timestamp;
   
CALL `UpdateCompositeMYCerts`();  

ALTER TABLE `s1_composite_my_certs` 
CHANGE COLUMN `AYSOID` `AYSOID` INT(11); 
UPDATE `s1_composite_my_certs` SET `Zip` = REPLACE(`Zip`, "'", '');

SELECT 
    *
FROM
    `s1_composite_my_certs`