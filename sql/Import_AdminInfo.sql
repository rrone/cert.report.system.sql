USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DROP TABLE IF EXISTS `tmp.AdminInfo`;

CREATE TEMPORARY TABLE `tmp.AdminInfo` (
  `﻿Textbox7` text,
  `Textbox80` text,
  `Textbox9` text,
  `Textbox17` text,
  `Section` text,
  `Area` text,
  `Club_ID` text,
  `Admin_ID` text,
  `AdminID` VARCHAR(20),
  `AdminAltID` VARCHAR(20),
  `First_Name` text,
  `Last_Name` text,
  `DOB` text,
  `Gender` text,
  `Email` text,
  `Address` text,
  `City` text,
  `PostalCode` text,
  `LicenseLevel` text,
  `Risk_Submit_Date` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/1.2023.AdminLicenseGrade.csv'
	INTO TABLE `tmp.AdminInfo`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/70.2023.AdminLicenseGrade.csv'
	INTO TABLE `tmp.AdminInfo`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/1.2022.AdminLicenseGrade.csv'
	INTO TABLE `tmp.AdminInfo`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/70.2022.AdminLicenseGrade.csv'
	INTO TABLE `tmp.AdminInfo`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/1.2021.AdminLicenseGrade.csv'
	INTO TABLE `tmp.AdminInfo`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/1.2020.AdminLicenseGrade.csv'
	INTO TABLE `tmp.AdminInfo`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/1.2019.AdminLicenseGrade.csv'
	INTO TABLE `tmp.AdminInfo`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/1.2018.AdminLicenseGrade.csv'
	INTO TABLE `tmp.AdminInfo`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/1.2017.AdminLicenseGrade.csv'
	INTO TABLE `tmp.AdminInfo`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
ALTER TABLE `tmp.AdminInfo` 
DROP COLUMN `Admin_ID`,
DROP COLUMN `AdminAltID`,
DROP COLUMN `Textbox17`,
DROP COLUMN `Textbox9`,
DROP COLUMN `Textbox80`,
DROP COLUMN `﻿Textbox7`,
CHANGE COLUMN `Club_ID` `Region` TEXT NULL DEFAULT NULL,
ADD COLUMN `State` TEXT NULL AFTER `City`,
CHANGE COLUMN `Risk_Submit_Date` `CertificationDate` TEXT NULL DEFAULT NULL,
CHANGE COLUMN `LicenseLevel` `CertificationDesc` TEXT NULL DEFAULT NULL,
CHANGE COLUMN `First_Name` `FirstName` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Last_Name` `LastName` TEXT NULL DEFAULT NULL,
CHANGE COLUMN `AdminID` `AdminID` VARCHAR(20) NULL DEFAULT NULL FIRST;

DROP TABLE IF EXISTS `1.AdminInfo`;

CREATE TABLE `1.AdminInfo` SELECT DISTINCT * FROM
    `tmp.AdminInfo`
ORDER BY `AdminID`;

CREATE INDEX `idx_1.AdminInfo_AdminID`  ON `1.AdminInfo` (AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

UPDATE `1.AdminInfo` 
SET 
    `Section` = EXTRACTNUMBER(`Section`),
    `Area` = RIGHT(`Area`, 1),
    `Region` = EXTRACTNUMBER(`Region`),
    `DOB` = format_date(`DOB`),
    `State` = STATE(`PostalCode`),
    `CertificationDate` = format_date(`CertificationDate`);  

SELECT 
    `Section`, `Area`, `Region`, `FirstName`, `LastName`, `Gender`, `Email`, `Address`, `City`, `State`, `PostalCode`, `CertificationDesc`, `CertificationDate`
FROM
    `1.AdminInfo`    
WHERE `CertificationDate` >= DATE_SUB(NOW(), INTERVAL 35 DAY)
	AND `CertificationDesc` LIKE '%Referee'
	AND `CertificationDesc` IN ('National Referee', 'Advanced Referee', 'Intermediate Referee')
ORDER BY FIELD(`CertificationDesc`, 'National Referee', 'Advanced Referee', 'Intermediate Referee'),`CertificationDate` DESC, `AdminID` DESC;

/*
SET @date = '20230118.all.AdminInfo';

DROP TABLE IF EXISTS `@date`;

CREATE TABLE `@date` SELECT * FROM
    `1.AdminInfo`
WHERE
    `CertificationDate` >= '2022-08-01'
        AND (`CertificationDesc` LIKE '%Referee' OR `CertificationDesc` LIKE '%Official')
        AND `CertificationDesc` IN ('National Referee' , 'Advanced Referee',
        'Intermediate Referee',
        'Regional Referee',
		'Assistant Referee',
        '8U Official')
ORDER BY FIELD(`CertificationDesc`,
        'National Referee',
        'Advanced Referee',
        'Intermediate Referee',
        'Regional Referee',
        'Assistant Referee',
        '8U Official') , `Section`, `Area`, `CertificationDate` DESC , `AdminID` DESC;

SELECT DISTINCT 
   `Section`,
    `Area`,
    `FirstName`,
    `LastName`,
    `Gender`,
    `Email`,
    `Address`,
    `City`,
    `State`,
    `PostalCode`,
    `CertificationDesc`,
    `CertificationDate` 
FROM
    `@date`;
*/
