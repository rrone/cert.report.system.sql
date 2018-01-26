USE `wp_ayso1ref`;

-- init table crs_certs
DROP TABLE IF EXISTS crs_certs;

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
  `Gender` text,
  `CertificationDesc` text,
  `CertDate` varchar(10) CHARACTER SET utf8,
  `SAR` varchar(98) NOT NULL DEFAULT '',
  `Section` varchar(32) NOT NULL,
  `Area` varchar(32) NOT NULL,
  `Region` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE wp_ayso1ref.crs_certs AUTO_INCREMENT = 0; 

-- init import table `crs_1_certs`
DROP TABLE IF EXISTS `crs_1_certs`;   

CREATE TABLE `crs_1_certs` (
  `Program Name` text,
  `Program AYSO Membership Year` text,
  `Volunteer Role` text,
  `AYSO Volunteer ID` text,
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
  LOAD DATA LOCAL INFILE '/Users/frederickroberts/Dropbox/_open/_ayso/s1/reports/20180126/1.csv'  
  INTO TABLE `crs_1_certs`   
  FIELDS TERMINATED BY ','   
  ENCLOSED BY '"'  
  LINES TERMINATED BY '\r'
  IGNORE 1 ROWS;   

CALL `processBSCSV`('crs_1_certs');  

DROP TABLE `eAYSO.MY2017.certs`;
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
  `SectionName` int(11) DEFAULT NULL,
  `AreaName` text,
  `RegionNumber` int(11) DEFAULT NULL,
  `Membership Year` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
  LOAD DATA LOCAL INFILE '/Users/frederickroberts/Dropbox/_open/_ayso/s1/reports/20180126/eAYSO.MY2017.csv'  
  INTO TABLE `eAYSO.MY2017.certs`   
  FIELDS TERMINATED BY ','   
  ENCLOSED BY '"'  
  LINES TERMINATED BY '\r'
  IGNORE 1 ROWS;   

DROP TABLE `eAYSO.MY2016.certs`;
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
  `SectionName` int(11) DEFAULT NULL,
  `AreaName` text,
  `RegionNumber` int(11) DEFAULT NULL,
  `Membership Year` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
  LOAD DATA LOCAL INFILE '/Users/frederickroberts/Dropbox/_open/_ayso/s1/reports/20180126/eAYSO.MY2016.csv'  
  INTO TABLE `eAYSO.MY2017.certs`   
  FIELDS TERMINATED BY ','   
  ENCLOSED BY '"'  
  LINES TERMINATED BY '\r'
  IGNORE 1 ROWS;   

-- Update all eAYSO MY2017 & MY2016 cert exports   
CALL `processEAYSOCSV`('`eAYSO.MY2017.certs`');  
CALL `eAYSOHighestRefCert`('eAYSO.MY2017.certs');   
CALL `processEAYSOCSV`('`eAYSO.MY2016.certs`');  
CALL `eAYSOHighestRefCert`('eAYSO.MY2016.certs');   

-- Apply special cases  
CALL `CertTweaks`();   

-- Refresh all temporary tables  
CALL `RefreshRefCerts`();  

-- Delete regional records duplicated at Area & Section Portals  
-- DELETE n1 FROM crs_refcerts n1, crs_refcerts n2 WHERE n1.`Name` = n2.`Name` AND n1.`Region` = '';  
DELETE n1 
FROM crs_refcerts n1, crs_refcerts n2  
WHERE n1.`Name` = n2.`Name` AND n1.`Area` = '';   

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
CALL `wp_ayso1ref`.`UpdateCompositeMYCerts`();   

SELECT 
    *
FROM
    `s1_composite_my_certs`


