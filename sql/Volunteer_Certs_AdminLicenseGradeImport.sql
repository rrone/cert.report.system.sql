USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DROP TABLE IF EXISTS `1.Volunteer_Certs_AdminLicenseGrade`;

CREATE TABLE `1.Volunteer_Certs_AdminLicenseGrade` (
  `AYSOID` varchar(20),
  `Full Name` text,
  `Type` text,
  `SAR` text,
  `MY` text,
  `Safe Haven Date` text,
  `CDC Date` text,
  `SCA Date` text,
  `e3 Ref Cert Desc` text,
  `e3 Ref Cert Date` text,
  `Assessor Cert Desc` text,
  `Assessor Cert Date` text,
  `Inst Cert Desc` text,
  `Inst Cert Date` text,
  `Inst Eval Cert Desc` text,
  `Inst Eval Cert Date` text,
  `Coach Cert Desc` text,
  `Coach Cert Date` text,
  `Data Source` text,
  `AdminID` VARCHAR(20),
  `Section` text,
  `Area` text,
  `Region` text,
  `First_Name` text,
  `Last_Name` text,
  `DOB` text,
  `Gender` text,
  `Email` text,
  `AS_CertificationDesc` text,
  `AS_CertificationDate` text,
    PRIMARY KEY (`AdminID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX `idx_1.Volunteer_Certs_AdminLicenseGrade_AYSOID_AdminID`  ON `1.Volunteer_Certs_AdminLicenseGrade` (AYSOID, AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/Volunteer_Certs_alg1.csv'
	INTO TABLE `1.Volunteer_Certs_AdminLicenseGrade`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/Volunteer_Certs_alg2.csv'
	INTO TABLE `1.Volunteer_Certs_AdminLicenseGrade`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/Volunteer_Certs_alg3.csv'
	INTO TABLE `1.Volunteer_Certs_AdminLicenseGrade`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/Volunteer_Certs_alg4.csv'
	INTO TABLE `1.Volunteer_Certs_AdminLicenseGrade`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/Volunteer_Certs_alg5.csv'
	INTO TABLE `1.Volunteer_Certs_AdminLicenseGrade`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/Volunteer_Certs_alg6.csv'
	INTO TABLE `1.Volunteer_Certs_AdminLicenseGrade`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/Volunteer_Certs_alg_new.csv'
	INTO TABLE `1.Volunteer_Certs_AdminLicenseGrade`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;

DROP TABLE IF EXISTS `1.VolunteerNotFound_e3`;
CREATE TABLE `1.VolunteerNotFound_e3` SELECT * FROM
    `1.Volunteer_Certs_AdminLicenseGrade`
WHERE
    `Full Name` = '*** Volunteer not found ***';

DELETE FROM `1.Volunteer_Certs_AdminLicenseGrade` WHERE `Full Name` = '*** Volunteer not found ***';
UPDATE `1.Volunteer_Certs_AdminLicenseGrade` SET `SAR` = REPLACE(`SAR`, '/0','/');
UPDATE `1.Volunteer_Certs_AdminLicenseGrade` SET `SAR` = REPLACE(`SAR`, '/0','/');
UPDATE `1.Volunteer_Certs_AdminLicenseGrade` SET `SAR` = REPLACE(`SAR`, '/0','/');

UPDATE `1.Volunteer_Certs_AdminLicenseGrade` SET `e3 Ref Cert Date` = LEFT(`e3 Ref Cert Date`, 10);

DROP TABLE IF EXISTS `Volunteer_Certs_AdminLicenseGrade`;

CREATE TABLE `Volunteer_Certs_AdminLicenseGrade` SELECT `AYSOID`,
    `AdminID`,
    `SAR`,
    `First_Name`,
    `Last_Name`,
    `DOB`,
    `Gender`,
    `Email`,
    `e3 Ref Cert Desc`,
    `e3 Ref Cert Date`,
    `AS_CertificationDesc`,
    `AS_CertificationDate` FROM
    `1.Volunteer_Certs_AdminLicenseGrade`;

CREATE INDEX `idx_Volunteer_Certs_AdminLicenseGrade_AYSOID_AdminID`  ON `Volunteer_Certs_AdminLicenseGrade` (AYSOID, AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

DROP TABLE IF EXISTS `1.Volunteer_Certs_AdminLicenseGrade`;

ALTER TABLE `Volunteer_Certs_AdminLicenseGrade` 
RENAME TO  `1.Volunteer_Certs_AdminLicenseGrade`;

UPDATE `1.Volunteer_Certs_AdminLicenseGrade` SET `e3 Ref Cert Desc` = 'Advanced Referee' WHERE `e3 Ref Cert Desc` = 'National 2 Referee';
UPDATE `1.Volunteer_Certs_AdminLicenseGrade` SET `e3 Ref Cert Desc` = 'Advanced Referee' WHERE `e3 Ref Cert Desc` = 'National 2 Referee---National Referee Course';
UPDATE `1.Volunteer_Certs_AdminLicenseGrade` SET `e3 Ref Cert Desc` = 'Advanced Referee' WHERE `e3 Ref Cert Desc` = 'Advanced Referee---National Referee Course';
UPDATE `1.Volunteer_Certs_AdminLicenseGrade` SET `e3 Ref Cert Desc` = 'Intermediate Referee' WHERE `e3 Ref Cert Desc` = 'Intermediate Referee---Advanced Referee Course';
-- UPDATE `1.Volunteer_Certs_AdminLicenseGrade` SET `e3 Ref Cert Desc` = 'Regional Referee' WHERE `e3 Ref Cert Desc` = 'Intermediate Referee Course';
UPDATE `1.Volunteer_Certs_AdminLicenseGrade` SET `e3 Ref Cert Desc` = 'Regional Referee' WHERE `e3 Ref Cert Desc` = 'Regional Referee---Intermediate Referee Course';
UPDATE `1.Volunteer_Certs_AdminLicenseGrade` SET `e3 Ref Cert Desc` = 'Regional Referee' WHERE `e3 Ref Cert Desc` = 'Regional Referee---Advanced Referee Course';
UPDATE `1.Volunteer_Certs_AdminLicenseGrade` SET `e3 Ref Cert Desc` = 'Regional Referee' WHERE `e3 Ref Cert Desc` = 'Regional Referee & Safe Haven Referee';
UPDATE `1.Volunteer_Certs_AdminLicenseGrade` SET `e3 Ref Cert Desc` = 'Regional Referee' WHERE `e3 Ref Cert Desc` = 'Regional Referee & Safe Haven Referee---Advanced Referee Course';
UPDATE `1.Volunteer_Certs_AdminLicenseGrade` SET `e3 Ref Cert Desc` = 'Regional Referee' WHERE `e3 Ref Cert Desc` = 'Regional Referee & Safe Haven Referee---Intermediate Referee Course';
UPDATE `1.Volunteer_Certs_AdminLicenseGrade` SET `e3 Ref Cert Desc` = 'Assistant Referee' WHERE `e3 Ref Cert Desc` = 'Assistant Referee---Z-Online Regional Referee Course';
UPDATE `1.Volunteer_Certs_AdminLicenseGrade` SET `e3 Ref Cert Desc` = 'z-Online Regional Referee Course' WHERE `e3 Ref Cert Desc` = 'z-Online Regional Referee';
UPDATE `1.Volunteer_Certs_AdminLicenseGrade` SET `e3 Ref Cert Desc` = 'z-Online Regional Referee Course' WHERE `e3 Ref Cert Desc` = 'z-Online Regional Referee without Safe Haven';
UPDATE `1.Volunteer_Certs_AdminLicenseGrade` SET `e3 Ref Cert Desc` = 'z-Online Regional Referee Course' WHERE `e3 Ref Cert Desc` = 'z-Online Regional Referee without Safe Haven---Z-Online Regional Referee Course';
UPDATE `1.Volunteer_Certs_AdminLicenseGrade` SET `e3 Ref Cert Desc` = 'z-Online Regional Referee Course' WHERE `e3 Ref Cert Desc` = 'z-Online Regional Referee without Safe Haven---Intermediate Referee Course';
UPDATE `1.Volunteer_Certs_AdminLicenseGrade` SET `e3 Ref Cert Desc` = '8U Official' WHERE `e3 Ref Cert Desc` = 'U-8 Official';
UPDATE `1.Volunteer_Certs_AdminLicenseGrade` SET `e3 Ref Cert Desc` = '8U Official' WHERE `e3 Ref Cert Desc` = 'U-8 Official---Intermediate Referee Course';
UPDATE `1.Volunteer_Certs_AdminLicenseGrade` SET `e3 Ref Cert Desc` = '8U Official' WHERE `e3 Ref Cert Desc` = 'U-8 Official---Z-Online Regional Referee Course';


SELECT 
    *
FROM
    `1.Volunteer_Certs_AdminLicenseGrade`
WHERE
    `e3 Ref Cert Desc` <> `AS_CertificationDesc`
--        OR `e3 Ref Cert Date` <> `AS_CertificationDate`
ORDER BY FIELD(`e3 Ref Cert Desc`,
        'National Referee',
        'National 2 Referee',
        'Advanced Referee',
        'Intermediate Referee',
        'Regional Referee',
        'Regional Referee & Safe Haven Referee',
        'Assistant Referee',
        'Assistant Referee & Safe Haven Referee',
        '8U Official',
        'U-8 Official & Safe Haven Referee',
        'Z-Online Regional Referee Course',
        'Z-Online 8U Official',
        ''), `SAR`,`e3 Ref Cert Date`;
