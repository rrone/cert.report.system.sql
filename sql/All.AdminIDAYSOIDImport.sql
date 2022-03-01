USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DROP TABLE IF EXISTS `all.AdminCredentialsStatusDynamic`;

CREATE TEMPORARY TABLE `all.AdminCredentialsStatusDynamic` (
    `AdminID` VARCHAR(20),
    `AYSOID` VARCHAR(20),
    `FirstName` TEXT,
    `LastName` TEXT
)  ENGINE=INNODB DEFAULT CHARSET=LATIN1;


LOAD DATA LOCAL INFILE '/Users/rick/_data.allAYSO/all.2021.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `all.AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/_data.allAYSO/all.2020.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `all.AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/_data.allAYSO/all.2019.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `all.AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/_data.allAYSO/all.2018.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `all.AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/_data.allAYSO/all.2017.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `all.AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
        
DROP TABLE IF EXISTS `all.AdminIDAYSOID`;

CREATE TABLE `all.AdminIDAYSOID` SELECT DISTINCT
  `AdminID`,
  `AYSOID`,
  `FirstName`,
  `LastName`
FROM `all.AdminCredentialsStatusDynamic`;

CREATE INDEX `idx_all.AdminIDAYSOID_AYSOID_AdminID`  ON `all.AdminIDAYSOID` (AYSOID, AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

SELECT 
    *
FROM
    `all.AdminIDAYSOID` LIMIT 5;
