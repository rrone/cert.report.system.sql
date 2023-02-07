USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

/*

DROP TABLE IF EXISTS `ren.AdminCredentialsStatusDynamic`;

CREATE TABLE `ren.AdminCredentialsStatusDynamic` (
    `MY` VARCHAR(60),
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


LOAD DATA LOCAL INFILE '~/Desktop/retention/_reports/1.2022.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `ren.AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

LOAD DATA LOCAL INFILE '~/Desktop/retention/_reports/1.2021.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `ren.AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '~/Desktop/retention/_reports/1.2020.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `ren.AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '~/Desktop/retention/_reports/1.2019.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `ren.AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '~/Desktop/retention/_reports/1.2018.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `ren.AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '~/Desktop/retention/_reports/1.2017.AdminCredentialsStatusDynamic.csv'
	INTO TABLE `ren.AdminCredentialsStatusDynamic`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

UPDATE `ren.AdminCredentialsStatusDynamic` SET `MY` = RIGHT(`MY`,6);

DELETE FROM `ren.AdminCredentialsStatusDynamic` WHERE `League` IS NULL;
DELETE FROM `ren.AdminCredentialsStatusDynamic` WHERE ExtractNumber(`League`) = -1;

SELECT * FROM `ren.AdminCredentialsStatusDynamic`;

-- Rich Fichtelman duplicate registration 
DELETE FROM `ren.AdminCredentialsStatusDynamic` WHERE `AdminID` = '55599-730572';

-- Dave Story 1/P/20 
UPDATE `ren.AdminCredentialsStatusDynamic` SET `AYSOID` = '58019756' WHERE `AdminID`='11142-092128';
UPDATE `ren.AdminCredentialsStatusDynamic` SET `AdminID` = '11142-092128' WHERE `AdminID`='42518-133787';

-- Yui-Bin Chen registration in Region 779 
DELETE FROM `ren.AdminCredentialsStatusDynamic` WHERE `AdminID` = '82221-973180' AND `Club` LIKE '%779';

DELETE FROM `ren.AdminCredentialsStatusDynamic` WHERE length(`AdminID`) > 12;

*/

/*** all volunteers ***/
DROP TABLE IF EXISTS `tmp_retention`;

CREATE TEMPORARY TABLE `tmp_retention` SELECT 
   DISTINCT `AdminID`, `MY`, `licLevel`  AS `licGrade`, `refGrade1` AS `refGrade`
FROM
    `ren.AdminCredentialsStatusDynamic`
WHERE NOT `licLevel` = ''
	OR NOT `refGrade1` = '';
    
ALTER TABLE `tmp_retention`
ADD COLUMN `Role` TEXT NULL;    

UPDATE `tmp_retention` SET `Role` = '';

UPDATE `tmp_retention` SET `Role` = CONCAT(`Role`, 'Coach')
WHERE `licGrade` LIKE '%Coach%';

UPDATE `tmp_retention` SET `Role` = CONCAT(`Role`, 'Referee')
WHERE `refGrade` LIKE '%Referee%' OR `refGrade` LIKE '%Official%';

ALTER TABLE `tmp_retention`
DROP COLUMN `licGrade`,
DROP COLUMN `refGrade`;    

DROP TABLE IF EXISTS `ayso.rentention`;

CREATE TABLE `ayso.rentention` SELECT 
   DISTINCT `AdminID`, `MY`, `role`
FROM
    `tmp_retention`;
    
SELECT * from `ayso.rentention`;

CREATE INDEX `idx_ayso.rentention_AdminID_MY`  ON `ayso1ref_services`.`ayso.rentention` (AdminID, MY) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;


/*** coach volunteers ***/
DROP TABLE IF EXISTS `ayso.coach.rentention`;

CREATE TABLE `ayso.coach.rentention` (
	`MY` TEXT,
	`MY2017` TEXT,
	`MY2018` TEXT,
	`MY2019` TEXT,
	`MY2020` TEXT,
	`MY2021` TEXT,
	`MY2022` TEXT
)  ENGINE=INNODB DEFAULT CHARSET=LATIN1;

SET @role = '%Coach%';

-- MY2017
SET @17 := (SELECT COUNT(*) as `MY2017` FROM `ayso.rentention`
where `MY`='MY2017'
	AND `Role` LIKE @role
    );
   
-- MY2018   
SET @18 := (SELECT COUNT(*) as `MY20181` FROM `ayso.rentention`
where `MY`='MY2018'
	AND `Role` LIKE @role
    );

SET @18_17 := RETENTION('MY2018','MY2017', @role);

-- MY2019
SET @19 := (SELECT COUNT(*) as `MY2019` FROM `ayso.rentention`
where `MY`='MY2019'
	AND `Role` LIKE @role
    );

SET @19_18 := RETENTION('MY2019','MY2018', @role);

SET @19_17 := RETENTION('MY2019','MY2017', @role);


-- MY2020   
SET @20 := (SELECT COUNT(*) as `MY2020` FROM `ayso.rentention`
where `MY`='MY2020'
	AND `Role` LIKE @role
    );
   
SET @20_19 := RETENTION('MY2020','MY2019', @role);

SET @20_18 := RETENTION('MY2020','MY2018', @role);

SET @20_17 := RETENTION('MY2020','MY2017', @role);


-- MY2021
SET @21 := (SELECT COUNT(*) as `MY2021` FROM `ayso.rentention`
where `MY`='MY2021'
	AND `Role` LIKE @role
    );
   
SET @21_20 := RETENTION('MY2021','MY2020', @role);

SET @21_19 := RETENTION('MY2021','MY2019', @role);

SET @21_18 := RETENTION('MY2021','MY2018', @role);

SET @21_17 := RETENTION('MY2021','MY2017', @role);


-- MY2022
SET @22 := (SELECT COUNT(*) FROM `ayso.rentention`
where `MY`='MY2022'
	AND `Role` LIKE @role
    );

SET @22_21 := RETENTION('MY2022','MY2021', @role);

SET @22_20 := RETENTION('MY2022','MY2020', @role);
   
SET @22_19 := RETENTION('MY2022','MY2019', @role);

SET @22_18 := RETENTION('MY2022','MY2018', @role);

SET @22_17 := RETENTION('MY2022','MY2017', @role);

   
INSERT INTO `ayso.coach.rentention`(`MY`, `MY2017`, `MY2018`, `MY2019`, `MY2020`, `MY2021`, `MY2022`)
   values
   ('MY2017', @17, NULL, NULL, NULL, NULL, NULL),
   ('MY2018', @18_17, @18, NULL, NULL, NULL, NULL),
   ('MY2019', @19_17, @19_18, @19, NULL, NULL, NULL),
   ('MY2020', @20_17, @20_18, @20_19, @20, NULL, NULL),
   ('MY2021', @21_17, @21_18, @21_19, @21_20, @21, NULL),
   ('MY2022', @22_17, @22_18, @22_19, @22_20, @22_21, @22);

SELECT * FROM `ayso.coach.rentention`;


/*** referees volunteers ***/
DROP TABLE IF EXISTS `ayso.referee.rentention`;

CREATE TABLE `ayso.referee.rentention` (
	`MY` TEXT,
	`MY2017` TEXT,
	`MY2018` TEXT,
	`MY2019` TEXT,
	`MY2020` TEXT,
	`MY2021` TEXT,
	`MY2022` TEXT
)  ENGINE=INNODB DEFAULT CHARSET=LATIN1;

SET @role = '%Referee%';

-- MY2017
SET @17 := (SELECT COUNT(*) as `MY2017` FROM `ayso.rentention`
where `MY`='MY2017'
	AND `Role` LIKE @role
    );
   
-- MY2018   
SET @18 := (SELECT COUNT(*) as `MY20181` FROM `ayso.rentention`
where `MY`='MY2018'
	AND `Role` LIKE @role
    );

SET @18_17 := RETENTION('MY2018','MY2017', @role);

-- MY2019
SET @19 := (SELECT COUNT(*) as `MY2019` FROM `ayso.rentention`
where `MY`='MY2019'
	AND `Role` LIKE @role
    );

SET @19_18 := RETENTION('MY2019','MY2018', @role);

SET @19_17 := RETENTION('MY2019','MY2017', @role);


-- MY2020   
SET @20 := (SELECT COUNT(*) as `MY2020` FROM `ayso.rentention`
where `MY`='MY2020'
	AND `Role` LIKE @role
    );
   
SET @20_19 := RETENTION('MY2020','MY2019', @role);

SET @20_18 := RETENTION('MY2020','MY2018', @role);

SET @20_17 := RETENTION('MY2020','MY2017', @role);


-- MY2021
SET @21 := (SELECT COUNT(*) as `MY2021` FROM `ayso.rentention`
where `MY`='MY2021'
	AND `Role` LIKE @role
    );
   
SET @21_20 := RETENTION('MY2021','MY2020', @role);

SET @21_19 := RETENTION('MY2021','MY2019', @role);

SET @21_18 := RETENTION('MY2021','MY2018', @role);

SET @21_17 := RETENTION('MY2021','MY2017', @role);


-- MY2022
SET @22 := (SELECT COUNT(*) FROM `ayso.rentention`
where `MY`='MY2022'
	AND `Role` LIKE @role
    );

SET @22_21 := RETENTION('MY2022','MY2021', @role);

SET @22_20 := RETENTION('MY2022','MY2020', @role);
   
SET @22_19 := RETENTION('MY2022','MY2019', @role);

SET @22_18 := RETENTION('MY2022','MY2018', @role);

SET @22_17 := RETENTION('MY2022','MY2017', @role);

   
INSERT INTO `ayso.referee.rentention`(`MY`, `MY2017`, `MY2018`, `MY2019`, `MY2020`, `MY2021`, `MY2022`)
   values
   ('MY2017', @17, NULL, NULL, NULL, NULL, NULL),
   ('MY2018', @18_17, @18, NULL, NULL, NULL, NULL),
   ('MY2019', @19_17, @19_18, @19, NULL, NULL, NULL),
   ('MY2020', @20_17, @20_18, @20_19, @20, NULL, NULL),
   ('MY2021', @21_17, @21_18, @21_19, @21_20, @21, NULL),
   ('MY2022', @22_17, @22_18, @22_19, @22_20, @22_21, @22);

SELECT * FROM `ayso.referee.rentention`;
