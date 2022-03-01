
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

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.rick.roberts.9/_ayso/s1/reports/stack_sports_reporting/_stack/1B.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.rick.roberts.9/_ayso/s1/reports/stack_sports_reporting/_stack/1C.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.rick.roberts.9/_ayso/s1/reports/stack_sports_reporting/_stack/1D.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.rick.roberts.9/_ayso/s1/reports/stack_sports_reporting/_stack/1F.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.rick.roberts.9/_ayso/s1/reports/stack_sports_reporting/_stack/1G.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.rick.roberts.9/_ayso/s1/reports/stack_sports_reporting/_stack/1H.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.rick.roberts.9/_ayso/s1/reports/stack_sports_reporting/_stack/1N.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.rick.roberts.9/_ayso/s1/reports/stack_sports_reporting/_stack/1P.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.rick.roberts.9/_ayso/s1/reports/stack_sports_reporting/_stack/1R.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.rick.roberts.9/_ayso/s1/reports/stack_sports_reporting/_stack/1S.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.rick.roberts.9/_ayso/s1/reports/stack_sports_reporting/_stack/1U.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
DROP TABLE IF EXISTS `crs_MY2020`;   

CREATE TABLE `tmp_MY2020` (
	`AYSOID` int(11),
	`First_Name` text,
	`Last_Name` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `crs_MY2020` SELECT DISTINCT `AltID1`, `FirstName1`, `LastName1` FROM `AdminCredentialsStatusDynamic`;
     