USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DROP TABLE IF EXISTS `1.AdminLicenseGrade`;

CREATE TABLE `1.AdminLicenseGrade` SELECT `AYSOID`,
    `AdminID`,
	`MY`,
	ExtractNumber(`League`) AS `Section`,
	RIGHT(`League`, 1) AS `Area`,
	ExtractNumber(`Club`) AS `Region`,
    `FirstName`,
    `LastName`,
    format_date(`DOB`) AS `DOB`,
    `GenderCode` AS `Gender`,
    `Email`,
    `refGrade1` AS `CertificationDesc`,
    format_date(`refObtainDate1`) AS `CertificationDate`
FROM 
	`AdminCredentialsStatusDynamic`;

CREATE INDEX `idx_1.AdminLicenseGrade_AdminID`  ON `1.AdminLicenseGrade` (AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;
CREATE INDEX `idx_1.AdminLicenseGrade_AYSOID_AdminID`  ON `1.AdminLicenseGrade` (AYSOID, AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

DELETE FROM `1.AdminLicenseGrade` 
WHERE
    `AdminID` IS NULL;  
    
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

UPDATE `1.AdminLicenseGrade`  SET `CertificationDate` = '01/05/2018' WHERE `AdminID` = '56070-301841';
UPDATE `1.AdminLicenseGrade`  SET `CertificationDate` = '09/04/2018' WHERE `AdminID` = '56070-301841';
UPDATE `1.AdminLicenseGrade`  SET `CertificationDate` = '10/29/1997' WHERE `AdminID` = '10177-661663';

DROP TABLE IF EXISTS `AdminLicenseGrade`;

CREATE TABLE `AdminLicenseGrade` SELECT DISTINCT `AYSOID`,
    `AdminID`,
    `Section`,
    `Area`,
    `Region`,
    `FirstName`,
    `LastName`,
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
		AND `AdminID` <> ''
    ORDER BY FIELD(`CertificationDesc`, 'National Referee', 'National 2 Referee', 'Advanced Referee', 'Intermediate Referee', 'Regional Referee', 'Regional Referee & Safe Haven Referee', 'Assistant Referee', 'Asst. Referee', 'Assistant Referee & Safe Haven Referee', '8U Official', 'U-8 Official & Safe Haven Referee', 'Z-Online 8U Official', ''), `Area`, `Region`, `LastName`;

DROP TABLE IF EXISTS `1.AdminLicenseGrade`;

ALTER TABLE `AdminLicenseGrade` 
RENAME TO  `1.AdminLicenseGrade`;

DROP TABLE IF EXISTS `tmp_dup_AdminLicenseGrade`;

CREATE TEMPORARY TABLE `tmp_dup_AdminLicenseGrade` SELECT `AdminID` FROM
    (SELECT 
        *,
            @rank:=IF(@id = `AYSOID`, @rank + 1, 1) AS rank,
            @id:=`AYSOID`
    FROM
        (SELECT 
        *
    FROM
        `1.AdminLicenseGrade`
    ORDER BY `MY` DESC) ordered
    GROUP BY `AYSOID`) grouped
WHERE
    `rank` = 1 AND `AYSOID` <> '';

CREATE INDEX `idx_tmp_dup_AdminLicenseGrade`  ON `tmp_dup_AdminLicenseGrade` (AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

DELETE FROM `1.AdminLicenseGrade` 
WHERE
    `AYSOID` <> ''
    AND `AdminID` NOT IN (SELECT 
        `AdminID`
    FROM
        `tmp_dup_AdminLicenseGrade`);   

SELECT 
    *
FROM
    `1.AdminLicenseGrade`
ORDER BY FIELD(`CertificationDesc`,
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
        'Z-Online 8U Official',
        '') , `Area` , `Region` , `LastName` , `MY`;

/* save as alg_new.csv */
SELECT 
    alg.*
FROM
    `1.AdminLicenseGrade` alg
        LEFT JOIN
    `1.Volunteer_Certs_AdminLicenseGrade` vc ON alg.`AdminID` = vc.`AdminID`
WHERE
    alg.`AYSOID` <> ''
        AND vc.`AdminID` IS NULL;
