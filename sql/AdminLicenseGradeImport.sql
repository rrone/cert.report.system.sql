USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DROP TABLE IF EXISTS `1.AdminLicenseGrade`;

CREATE TABLE `1.AdminLicenseGrade` (
    `Section` TEXT,
    `Area` TEXT,
    `Region` TEXT,
    `Admin_ID` TEXT,
    `AdminID` VARCHAR(20),
    `AYSOID` VARCHAR(20),
    `First_Name` TEXT,
    `Last_Name` TEXT,
    `DOB` TEXT,
    `Gender` TEXT,
    `Email` TEXT,
    `CertificationDesc` TEXT,
    `CertificationDate` TEXT,
    `MY` TEXT
)  ENGINE=INNODB DEFAULT CHARSET=LATIN1;

CREATE INDEX `idx_1.AdminLicenseGrade_AYSOID_AdminID`  ON `1.AdminLicenseGrade` (AYSOID, AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2021.AdminLicenseGrade.csv'
	INTO TABLE `1.AdminLicenseGrade`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;

UPDATE `1.AdminLicenseGrade` SET `MY` = 'MY2021' WHERE `MY` IS NULL;

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2020.AdminLicenseGrade.csv'
	INTO TABLE `1.AdminLicenseGrade`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;

UPDATE `1.AdminLicenseGrade` SET `MY` = 'MY2020' WHERE `MY` IS NULL;

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2019.AdminLicenseGrade.csv'
	INTO TABLE `1.AdminLicenseGrade`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;

UPDATE `1.AdminLicenseGrade` SET `MY` = 'MY2019' WHERE `MY` IS NULL;

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2018.AdminLicenseGrade.csv'
	INTO TABLE `1.AdminLicenseGrade`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;

UPDATE `1.AdminLicenseGrade` SET `MY` = 'MY2018' WHERE `MY` IS NULL;

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2017.AdminLicenseGrade.csv'
	INTO TABLE `1.AdminLicenseGrade`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;

UPDATE `1.AdminLicenseGrade` SET `MY` = 'MY2017' WHERE `MY` IS NULL;

/* Bocanegra erroneous cert */ 
DELETE FROM `1.AdminLicenseGrade` 
WHERE
    `AdminID` = '68354-528194'
    AND `CertificationDesc` = 'National Referee';
    
/*Fichtelman duplicate */
DELETE FROM `1.AdminLicenseGrade` 
WHERE
    `AdminID` = '55599-730572';    
    
DELETE FROM `1.AdminLicenseGrade` 
WHERE NOT `CertificationDesc` LIKE '%Referee%'
	AND NOT `CertificationDesc` LIKE '%Official%';
	
UPDATE `1.AdminLicenseGrade`  SET `CertificationDesc` = 'Assistant Referee' WHERE `CertificationDesc` = 'Asst. Referee';
UPDATE `1.AdminLicenseGrade`  SET `CertificationDesc` = '8U Official' WHERE `CertificationDesc` = 'U-8 Official';

UPDATE `1.AdminLicenseGrade`  SET `CertificationDate` = '08/30/2015' WHERE `AdminID` = '50144-988173';
UPDATE `1.AdminLicenseGrade`  SET `CertificationDate` = '01/05/2018' WHERE `AdminID` = '56070-301841';
UPDATE `1.AdminLicenseGrade`  SET `CertificationDate` = '09/04/2018' WHERE `AdminID` = '56070-301841';
UPDATE `1.AdminLicenseGrade`  SET `CertificationDate` = '09/15/2019' WHERE `AdminID` = '87797-269632';
UPDATE `1.AdminLicenseGrade`  SET `CertificationDate` = '09/18/2016' WHERE `AdminID` = '89012-550811';
UPDATE `1.AdminLicenseGrade`  SET `CertificationDate` = '09/08/2021' WHERE `AdminID` = '45202-107703';
UPDATE `1.AdminLicenseGrade`  SET `CertificationDate` = '11/21/2009' WHERE `AdminID` = '52302-859192';
UPDATE `1.AdminLicenseGrade`  SET `CertificationDate` = '10/29/1997' WHERE `AdminID` = '10177-661663';

UPDATE `1.AdminLicenseGrade`  SET `Section` = ExtractNumber(`Section`);

UPDATE `1.AdminLicenseGrade`  SET `Area` = RIGHT(`Area`, 1);

UPDATE `1.AdminLicenseGrade`  SET `Region` = ExtractNumber(`Region`);

UPDATE `1.AdminLicenseGrade`  SET `Email` = LOWER(`Email`);

UPDATE `1.AdminLicenseGrade`  SET `DOB` = format_date(`DOB`);

UPDATE `1.AdminLicenseGrade`  SET `CertificationDate` = format_date(`CertificationDate`);

DROP TABLE IF EXISTS `AdminLicenseGrade`;

CREATE TABLE `AdminLicenseGrade` SELECT DISTINCT `AYSOID`,
    `AdminID`,
    `Section`,
    `Area`,
    `Region`,
    `First_Name`,
    `Last_Name`,
    `DOB`,
    `Gender`,
    `Email`,
    `CertificationDesc`,
    `CertificationDate`,
    `MY` FROM        
    (SELECT 
        *,
            @rank:=IF(@id = `AdminID`, @rank + 1, 1) AS rank,
            @id:=`AdminID`
    FROM
        (SELECT 
        *
    FROM
        `1.AdminLicenseGrade`
    ORDER BY `AdminID`, `MY` DESC) ordered
    GROUP BY `AdminID`, FIELD(`CertificationDesc`, 'National Referee', 'National 2 Referee', 'Advanced Referee', 'Intermediate Referee', 'Regional Referee', 'Regional Referee & Safe Haven Referee', 'Assistant Referee', 'Assistant Referee & Safe Haven Referee', '8U Official', 'U-8 Official & Safe Haven Referee', 'Z-Online 8U Official', '')) grouped
    WHERE rank = 1
		AND NOT `AYSOID` IS NULL
    ORDER BY FIELD(`CertificationDesc`, 'National Referee', 'National 2 Referee', 'Advanced Referee', 'Intermediate Referee', 'Regional Referee', 'Regional Referee & Safe Haven Referee', 'Assistant Referee', 'Asst. Referee', 'Assistant Referee & Safe Haven Referee', '8U Official', 'U-8 Official & Safe Haven Referee', 'Z-Online 8U Official', ''), `Area`, `Region`, `Last_Name`;
        

DROP TABLE IF EXISTS `1.AdminLicenseGrade`;

ALTER TABLE `AdminLicenseGrade` 
RENAME TO  `1.AdminLicenseGrade`;

-- SELECT 
--     *
-- FROM
--     `1.AdminLicenseGrade`
-- ORDER BY FIELD(`CertificationDesc`,
--         'National Referee',
--         'National 2 Referee',
--         'Advanced Referee',
--         'Intermediate Referee',
--         'Regional Referee',
--         'Regional Referee & Safe Haven Referee',
--         'Assistant Referee',
--         'Assistant Referee & Safe Haven Referee',
--         '8U Official',
--         'U-8 Official & Safe Haven Referee',
--         'Z-Online 8U Official',
--         '') , `Area` , `Region` , `Last_Name` , `MY`;

SELECT 
    alg.*
FROM
    `1.AdminLicenseGrade` alg
        LEFT JOIN
    `1.Volunteer_Certs_AdminLicenseGrade` vc ON alg.`AdminID` = vc.`AdminID`
WHERE
    alg.`AYSOID` <> ''
        AND vc.`AdminID` IS NULL;