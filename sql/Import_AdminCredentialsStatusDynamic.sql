USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DROP TABLE IF EXISTS `AdminCredentialsStatusDynamic`;

CREATE TABLE `AdminCredentialsStatusDynamic` (
    `MY` TEXT,
    `Textbox80` TEXT,
	`Textbox81` TEXT,
	`Textbox82` TEXT,
    `CertificateName` TEXT,
    `League` TEXT,
    `Club` TEXT,
    `ClubID` TEXT,
    `CORIRegDate1` TEXT,
    `AdminID` VARCHAR(20),
    `AYSOID` VARCHAR(20),
    `RegDate` TEXT,
    `FirstName` TEXT,
    `LastName` VARCHAR(60),
    `DOB` VARCHAR(20),
    `GenderCode` TEXT,
    `email` VARCHAR(60),
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
    `rosteredYN` TEXT,
    `ccInDate` TEXT,
    `ccVerified` TEXT,
    `ccVerifyBy` TEXT,
    `ccVerifyDate` TEXT,
    `ExpirationDateC` TEXT
)  ENGINE=INNODB DEFAULT CHARSET=LATIN1;


LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/all.2022.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/all.2021.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/all.2020.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/1.2019.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/1.2018.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/1.2017.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

UPDATE `AdminCredentialsStatusDynamic` SET `MY` = RIGHT(`MY`,6);

DELETE FROM `AdminCredentialsStatusDynamic` WHERE `League` IS NULL;
DELETE FROM `AdminCredentialsStatusDynamic` WHERE ExtractNumber(`League`) = -1;

/* Rich Fichtelman duplicate registration */
DELETE FROM `AdminCredentialsStatusDynamic` WHERE `AdminID` IN ('55599-730572');

/* James Lacey duplicate registration */
UPDATE `AdminCredentialsStatusDynamic` SET `AdminID` = '56536-451818' WHERE `AdminID` IN ('11602-268939');

/* Greg Olson duplicate registration */
UPDATE `AdminCredentialsStatusDynamic` SET `AdminID` = '16220-331952' WHERE `AdminID` IN ('25501-727637');

/* Dave Story 1/P/20 */
UPDATE `AdminCredentialsStatusDynamic` SET `AYSOID` = '58019756' WHERE `AdminID` IN ('11142-092128');
UPDATE `AdminCredentialsStatusDynamic` SET `AdminID` = '11142-092128' WHERE `AdminID` IN ('42518-133787');

/* Nichole Wade 1/P/1031 */
UPDATE `AdminCredentialsStatusDynamic` SET `AdminID` = '14448-208552' WHERE `AdminID` IN ('85599-760850');

/* Yui-Bin Chen registration in Region 779 */
DELETE FROM `AdminCredentialsStatusDynamic` WHERE `AdminID` = '82221-973180' AND `Club` LIKE '%779';

DROP TABLE IF EXISTS `1.AdminCredentialsStatusDynamic`;

CREATE TABLE `1.AdminCredentialsStatusDynamic` (
  `AdminID` VARCHAR(20),
  `AYSOID` VARCHAR(20),
  `MY` text,
  `CertificateName` text,
  `CertificateDate` text,
  `Section` text,
  `Area` text,
  `Region` text,
  `FirstName` text,
  `LastName` text,
  `DOB` VARCHAR(20),
  `Gender` text,
  `email` VARCHAR(60),
  `RiskStatus` text,
  `RiskExpireDate` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX `idx_AdminCredentialsStatusDynamic_AYSOID_AdminID`  ON `1.AdminCredentialsStatusDynamic` (AYSOID, AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

INSERT INTO `1.AdminCredentialsStatusDynamic` (SELECT
  `AdminID`,
  `AYSOID`,
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
        `AdminCredentialsStatusDynamic`
	WHERE `CertificateName` IN ('AYSOs Safe Haven') 
    AND NOT `ccVerifyDate` = ''
    ORDER BY `AdminID`) ordered
    GROUP BY `AdminID`, `MY`) grouped
WHERE
    rank = 1	
ORDER BY `Area` , `Region` , `LastName`);

INSERT INTO `1.AdminCredentialsStatusDynamic` (SELECT
  `AdminID`,
  `AYSOID`,
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
        `AdminCredentialsStatusDynamic`
	WHERE `CertificateName` IN ('Concussion Awareness') 
    AND NOT `ccVerifyDate` = ''
    ORDER BY `AdminID`) ordered
    GROUP BY `AdminID`, `MY`) grouped
WHERE
    rank = 1	
ORDER BY `Area` , `Region` , `LastName`);

INSERT INTO `1.AdminCredentialsStatusDynamic` (SELECT
  `AdminID`,
  `AYSOID`,
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
        `AdminCredentialsStatusDynamic`
	WHERE `CertificateName` IN ('Sudden Cardiac Arrest') 
    AND NOT `ccVerifyDate` = ''
    ORDER BY `AdminID`) ordered
    GROUP BY `AdminID`, `MY`) grouped
WHERE
    rank = 1	
ORDER BY `Area` , `Region` , `LastName`);

INSERT INTO `1.AdminCredentialsStatusDynamic` (SELECT
  `AdminID`,
  `AYSOID`,
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
        `AdminCredentialsStatusDynamic`
	WHERE `CertificateName` IN ('SafeSport') 
    AND NOT `ccVerifyDate` = ''
    ORDER BY `AdminID`) ordered
    GROUP BY `AdminID`, `MY`) grouped
WHERE
    rank = 1	
ORDER BY `Area` , `Region` , `LastName`);

INSERT INTO `1.AdminCredentialsStatusDynamic` (SELECT
  `AdminID`,
  `AYSOID`,
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
        `AdminCredentialsStatusDynamic`
	WHERE `CertificateName` IN ('CA Mandated Fingerprinting') 
    AND NOT `ccVerifyDate` = ''
    ORDER BY `AdminID`) ordered
    GROUP BY `AdminID`, `MY`) grouped
WHERE
    rank = 1	
ORDER BY `Area` , `Region` , `LastName`);
 
UPDATE `1.AdminCredentialsStatusDynamic` c SET `CertificateDate` = str_to_date(`CertificateDate`, '%m/%d/%Y');
UPDATE `1.AdminCredentialsStatusDynamic` c SET `RiskExpireDate` = str_to_date(`RiskExpireDate`, '%m/%d/%Y') WHERE `RiskExpireDate` <> '';

DROP TABLE IF EXISTS `tmp_dup_AdminCredentialsStatusDynamic`;

CREATE TEMPORARY TABLE `tmp_dup_AdminCredentialsStatusDynamic` SELECT `AdminID` FROM
    (SELECT 
        *,
            @rank:=IF(@id = `AYSOID`, @rank + 1, 1) AS rank,
            @id:=`AYSOID`
    FROM
        (SELECT 
        *
    FROM
        `1.AdminCredentialsStatusDynamic`
    ORDER BY `MY` DESC) ordered
    GROUP BY `AYSOID`) grouped
WHERE
    `rank` = 1 AND `AYSOID` <> '';

CREATE INDEX `idx_tmp_dup_AdminCredentialsStatusDynamic`  ON `tmp_dup_AdminCredentialsStatusDynamic` (AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

DELETE FROM `1.AdminCredentialsStatusDynamic` 
WHERE
    `AYSOID` <> ''
    AND `AdminID` NOT IN (SELECT 
        `AdminID`
    FROM
        `tmp_dup_AdminCredentialsStatusDynamic`);   

DROP TABLE IF EXISTS `tmp_AdminCredentialsStatusDynamic`;

CREATE TABLE `tmp_AdminCredentialsStatusDynamic` SELECT `AdminID`,
    `AYSOID`,
    `MY`,
    `CertificateName`,
    `CertificateDate`,
    `Section`,
    `Area`,
    `Region`,
    `FirstName`,
    `LastName`,
    `DOB`,
    `Gender`,
    `email`,
    `RiskStatus`,
    `RiskExpireDate` FROM
    (SELECT 
        *,
            @rank:=IF(@id = CONCAT(`AdminID`, `CertificateName`), @rank + 1, 1) AS rank,
            @id:=CONCAT(`AdminID`, `CertificateName`)
    FROM
        (SELECT 
        *
    FROM
        `1.AdminCredentialsStatusDynamic`
    ORDER BY `AYSOID` , `MY` DESC) ordered
    GROUP BY `AdminID` , `CertificateName`) grouped
WHERE
    rank = 1
ORDER BY `Section` , `Area` , `Region` , `LastName`;

DROP TABLE IF EXISTS `1.AdminCredentialsStatusDynamic`;

ALTER TABLE `tmp_AdminCredentialsStatusDynamic` 
RENAME TO  `1.AdminCredentialsStatusDynamic`;

SELECT 
    *
FROM
    `1.AdminCredentialsStatusDynamic`;
