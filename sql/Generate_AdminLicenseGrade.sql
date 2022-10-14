USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DROP TABLE IF EXISTS `1.AdminLicenseGrade`;

CREATE TABLE `1.AdminLicenseGrade` SELECT `AdminID`,
    `AYSOID`,
    `MY`,
    EXTRACTNUMBER(`League`) AS `Section`,
    RIGHT(`League`, 1) AS `Area`,
    EXTRACTNUMBER(`Club`) AS `Region`,
    `FirstName`,
    `LastName`,
    FORMAT_DATE(`DOB`) AS `DOB`,
    `GenderCode` AS `Gender`,
    `Email`,
    `refGrade1` AS `CertificationDesc`,
    FORMAT_DATE(`refObtainDate1`) AS `CertificationDate` FROM
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
    
/* Nichole Wade 1/P/1031 */
UPDATE `1.AdminLicenseGrade` 
SET 
    `MY` = 'MY2022'
WHERE
    `AdminID` = '14448-208552';

/*Ricardo Gonzalez Jr duplicate */
UPDATE `1.AdminLicenseGrade` 
SET
    `AdminID` = '11844-920039'
WHERE 
`AdminID` IN ('53239-880774', '74625-322435', '42548-339555');

/* Al Prado test account */
DELETE FROM `1.AdminLicenseGrade`
WHERE 
	`AdminID` = '89820-005656';
    
DELETE FROM `1.AdminLicenseGrade` 
WHERE NOT `CertificationDesc` LIKE '%Referee%'
	AND NOT `CertificationDesc` LIKE '%Official%';
	
UPDATE `1.AdminLicenseGrade`  SET `CertificationDesc` = 'Assistant Referee' WHERE `CertificationDesc` = 'Asst. Referee';
UPDATE `1.AdminLicenseGrade`  SET `CertificationDesc` = '8U Official' WHERE `CertificationDesc` = 'U-8 Official';

DROP TABLE IF EXISTS `AdminLicenseGrade`;

CREATE TABLE `AdminLicenseGrade` SELECT DISTINCT `AdminID`,
	`AYSOID`,
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
            @rank:=IF(@id = `AdminID` AND `MY` < @my, @rank + 1, 1) AS rank,
            @id:=`AdminID`,
            @my:=`MY`
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
