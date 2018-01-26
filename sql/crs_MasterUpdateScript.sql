USE `wp_ayso1ref`;

CALL `init_crs_certs`();   

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
DELETE n1 FROM crs_refcerts n1,   crs_refcerts n2   WHERE   n1.`Name` = n2.`Name` AND n1.`Area` = '';   

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
