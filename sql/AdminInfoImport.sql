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

LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/1.2022.AdminLicenseGrade.csv'
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
DROP COLUMN `Risk_Submit_Date`,
DROP COLUMN `LicenseLevel`,
DROP COLUMN `Admin_ID`,
DROP COLUMN `Textbox17`,
DROP COLUMN `Textbox9`,
DROP COLUMN `Textbox80`,
DROP COLUMN `﻿Textbox7`,
CHANGE COLUMN `Club_ID` `Region` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `AdminAltID` `AYSOID` VARCHAR(20) NULL DEFAULT NULL ,
CHANGE COLUMN `First_Name` `FirstName` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Last_Name` `LastName` TEXT NULL DEFAULT NULL;

DROP TABLE IF EXISTS `1.AdminInfo`;

CREATE TABLE `1.AdminInfo` SELECT DISTINCT * FROM
    `tmp.AdminInfo`
WHERE NOT `Section` IS NULL
ORDER BY `Area` , `Region` , `LastName`;

UPDATE `1.AdminInfo` 
SET 
    `Section` = EXTRACTNUMBER(`Section`),
    `Area` = RIGHT(`Area`, 1),
    `Region` = EXTRACTNUMBER(`Region`),
    `DOB` = format_date(`DOB`);  

CREATE INDEX `idx_1.AdminInfo_AYSOID_AdminID`  ON `1.AdminInfo` (AYSOID, AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

SELECT 
    *
FROM
    `1.AdminInfo`;
