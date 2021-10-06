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
-- 2021-04-12 : END: added to update MY from Stack Sports AdminCredentialsStatusDynamic reports