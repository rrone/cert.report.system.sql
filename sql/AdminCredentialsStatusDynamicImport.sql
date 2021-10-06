USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DROP TABLE IF EXISTS `1.AdminCredentialsStatusDynamic`;

CREATE TABLE `1.AdminCredentialsStatusDynamic` (
    `MY` TEXT,
    `CertificateName` TEXT,
    `League` TEXT,
    `Club` TEXT,
    `ClubID` TEXT,
    `CORIRegDate1` TEXT,
    `AdminID` VARCHAR(20),
    `AYSOID` VARCHAR(20),
    `FirstName` TEXT,
    `LastName` TEXT,
    `DOB` TEXT,
    `GenderCode` TEXT,
    `email` TEXT,
    `IDVerified1` TEXT,
    `IDVerifiedBY1` TEXT,
    `IDVerifiedDate1` TEXT,
    `RiskSubmitDate` TEXT,
    `RiskStatus` TEXT,
    `RiskExpireDate` TEXT,
    `cardPrinted` TEXT,
    `photoInDate` TEXT,
    `licLevel` TEXT,
    `licNum` TEXT,
    `LicObtainDate` TEXT,
    `refGrade1` TEXT,
    `refObtainDate1` TEXT,
    `refExpDate1` TEXT,
    `ccInDate` TEXT,
    `ccVerified` TEXT,
    `ccVerifyBy` TEXT,
    `ccVerifyDate` TEXT,
    `ExpirationDateC` TEXT
)  ENGINE=INNODB DEFAULT CHARSET=LATIN1;


LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2021.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `1.AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2020.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `1.AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2019.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `1.AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2018.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `1.AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2017.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `1.AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
UPDATE `1.AdminCredentialsStatusDynamic` SET `MY` = RIGHT(`MY`,6);

DELETE FROM `1.AdminCredentialsStatusDynamic` WHERE `League` IS NULL;

DROP TABLE IF EXISTS `AdminCredentialsStatusDynamic`;

CREATE TABLE `AdminCredentialsStatusDynamic` (
  `AYSOID` VARCHAR(20),
  `AdminID` VARCHAR(20),
  `MY` text,
  `CertificateName` text,
  `CertificateDate` text,
  `Section` text,
  `Area` text,
  `Region` text,
  `FirstName` text,
  `LastName` text,
  `DOB` text,
  `Gender` text,
  `email` text,
  `RiskStatus` text,
  `RiskExpireDate` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX `idx_AdminCredentialsStatusDynamic_AYSOID_AdminID`  ON `AdminCredentialsStatusDynamic` (AYSOID, AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

INSERT INTO `AdminCredentialsStatusDynamic` (SELECT
  `AYSOID`,
  `AdminID`,
  `MY`,
  `CertificateName` AS `CertificateDesc`,
  `ccVerifyDate` AS `CertificateDate`,
  ExtractNumber(`League`) AS `Section`,
  RIGHT(`League`, 1) AS `Area`,
  ExtractNumber(`Club`) AS `Region`,
  `FirstName`,
  `LastName`,
  format_date(`DOB`) AS `DOB`,
  `GenderCode`,
  `email`,
  `RiskStatus`,
  `RiskExpireDate`
FROM 
    (SELECT 
        *,
            @rank:=IF(@id = `AdminID`, @rank + 1, 1) AS rank,
            @id:=`AdminID`
    FROM
        (SELECT 
        *
    FROM
        `1.AdminCredentialsStatusDynamic`
	WHERE `CertificateName` IN ('AYSOs Safe Haven') 
    AND NOT `ccVerifyDate` = ''
    ORDER BY `AdminID`, `MY` DESC) ordered
    GROUP BY `AdminID`) grouped
WHERE
    rank = 1	
ORDER BY `Area` , `Region` , `LastName`);

INSERT INTO `AdminCredentialsStatusDynamic` (SELECT
  `AYSOID`,
  `AdminID`,
  `MY`,
  `CertificateName` AS `CertificateDesc`,
  `ccVerifyDate` AS `CertificateDate`,
  ExtractNumber(`League`) AS `Section`,
  RIGHT(`League`, 1) AS `Area`,
  ExtractNumber(`Club`) AS `Region`,
  `FirstName`,
  `LastName`,
  format_date(`DOB`) AS `DOB`,
  `GenderCode`,
  `email`,
  `RiskStatus`,
  `RiskExpireDate`
FROM 
    (SELECT 
        *,
            @rank:=IF(@id = `AdminID`, @rank + 1, 1) AS rank,
            @id:=`AdminID`
    FROM
        (SELECT 
        *
    FROM
        `1.AdminCredentialsStatusDynamic`
	WHERE `CertificateName` IN ('Concussion Awareness') 
    AND NOT `ccVerifyDate` = ''
    ORDER BY `AdminID`, `MY` DESC) ordered
    GROUP BY `AdminID`) grouped
WHERE
    rank = 1	
ORDER BY `Area` , `Region` , `LastName`);

INSERT INTO `AdminCredentialsStatusDynamic` (SELECT
  `AYSOID`,
  `AdminID`,
  `MY`,
  `CertificateName` AS `CertificateDesc`,
  `ccVerifyDate` AS `CertificateDate`,
  ExtractNumber(`League`) AS `Section`,
  RIGHT(`League`, 1) AS `Area`,
  ExtractNumber(`Club`) AS `Region`,
  `FirstName`,
  `LastName`,
  format_date(`DOB`) AS `DOB`,
  `GenderCode`,
  `email`,
  `RiskStatus`,
  `RiskExpireDate`
FROM 
    (SELECT 
        *,
            @rank:=IF(@id = `AdminID`, @rank + 1, 1) AS rank,
            @id:=`AdminID`
    FROM
        (SELECT 
        *
    FROM
        `1.AdminCredentialsStatusDynamic`
	WHERE `CertificateName` IN ('Sudden Cardiac Arrest') 
    AND NOT `ccVerifyDate` = ''
    ORDER BY `AdminID`, `MY` DESC) ordered
    GROUP BY `AdminID`) grouped
WHERE
    rank = 1	
ORDER BY `Area` , `Region` , `LastName`);

/* Rich Fichtelman duplicate registration */
DELETE FROM `AdminCredentialsStatusDynamic` WHERE `AdminID` = '55599-730572';
 
UPDATE `AdminCredentialsStatusDynamic` c SET `CertificateDate` = str_to_date(`CertificateDate`, '%m/%d/%Y');
UPDATE `AdminCredentialsStatusDynamic` c SET `RiskExpireDate` = str_to_date(`RiskExpireDate`, '%m/%d/%Y') WHERE `RiskExpireDate` <> '';

DROP TABLE IF EXISTS `1.AdminCredentialsStatusDynamic`;

ALTER TABLE `AdminCredentialsStatusDynamic` 
RENAME TO  `1.AdminCredentialsStatusDynamic`;

SELECT 
    *
FROM
    `1.AdminCredentialsStatusDynamic`;