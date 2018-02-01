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

ALTER TABLE wp_ayso1ref.crs_certs AUTO_INCREMENT = 0; 

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
  
UPDATE `eAYSO.MY2017.certs` SET `AYSOID` = REPLACE(`AYSOID`, '"', '');
UPDATE `eAYSO.MY2017.certs` SET `AYSOID` = REPLACE(`AYSOID`, unhex('0a'), '');
ALTER TABLE `eAYSO.MY2017.certs` 
CHANGE COLUMN `AYSOID` `AYSOID` INT(11);

-- UPDATE `eAYSO.certs` SET `AYSOID` = REPLACE(`AYSOID`,'"','');
CALL `processEAYSOCSV`('eAYSO.MY2016.certs');

CALL `processEAYSOCSV`('eAYSO.MY2017.certs');  
  
CALL `eAYSOHighestRefCert`('eAYSO.MY2016.certs');   
CALL `eAYSOHighestRefCert`('eAYSO.MY2017.certs');   

-- Apply special cases  
CALL `CertTweaks`();   

-- Refresh all temporary tables  
CALL `RefreshRefCerts`();  

-- Delete regional records duplicated at Area & Section Portals  
DELETE n2.* FROM crs_refcerts n1, crs_refcerts n2 WHERE n1.AYSOID = n2.AYSOID AND n1.`Region` = '' and n2.`Region` <> '';
DELETE n2.* FROM crs_refcerts n1, crs_refcerts n2 WHERE n1.AYSOID = n2.AYSOID AND n1.`Area` = ''and n2.`Area` <> '';

CALL `RefreshHighestCertification`();  
CALL `RefreshRefereeAssessors`();  
-- Must CaLL `RefreshRefereeAssessors` before `RefreshNationalRefereeAssessors`
CALL `RefreshNationalRefereeAssessors`();  
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
   
CALL `UpdateCompositeMYCerts`();  

ALTER TABLE `s1_composite_my_certs` 
CHANGE COLUMN `AYSOID` `AYSOID` INT(11); 
UPDATE `s1_composite_my_certs` SET `Zip` = REPLACE(`Zip`, "'", '');

SELECT 
    *
FROM
    `s1_composite_my_certs`