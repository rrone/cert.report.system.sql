USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DROP TABLE IF EXISTS `1.AdminLicenseGradeRefereeHighest`;

CREATE TABLE `1.AdminLicenseGradeRefereeHighest` SELECT DISTINCT `AdminID`,
    `AYSOID`,
    `MY`,
    `Section`,
    `Area`,
    `Region`,
    `FirstName` AS `First_Name`,
    `LastName` AS `Last_Name`,
    `DOB`,
    `Gender`,
    LOWER(`Email`) AS `Email`,
    `CertificationDesc`,
    `CertificationDate` FROM
    `1.AdminLicenseGrade`
ORDER BY FIELD(`CertificationDesc`,
        'National Referee',
        'National 2 Referee',
        'Advanced Referee',
        'Intermediate Referee',
        'Regional Referee',
        'Regional Referee & Safe Haven Referee',
        'Assistant Referee',
        'Asst. Referee',
        'Assistant Referee & Safe Haven Referee',
        'U-8 Official',
        '8U Official',
        'U-8 Official & Safe Haven Referee',
        'Z-Online 8U Official',
        '') , `Area` , `Region` , `Last_Name`;

ALTER TABLE `1.AdminLicenseGradeRefereeHighest` 
CHANGE COLUMN `DOB` `DOB` VARCHAR(20) NULL DEFAULT NULL ;

CREATE INDEX `idx_1.AdminLicenseGradeRefereeHighest_AYSOID_AdminID`  ON `1.AdminLicenseGradeRefereeHighest` (AYSOID, AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;
CREATE INDEX `idx_1.AdminLicenseGradeRefereeHighest_Last_Name_DOB`  ON `1.AdminLicenseGradeRefereeHighest` (Last_Name, DOB) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;
    
DROP TABLE IF EXISTS `tmpAdminLicenseGradeRefereeHighest`;

CREATE TABLE `tmpAdminLicenseGradeRefereeHighest` SELECT 
        `AdminID`, 
        `AYSOID`, 
        `MY`, 
        `Section`, 
        `Area`,
        `Region`, 
        `First_Name`,
        `Last_Name`, 
        `DOB`, 
        `Gender`, 
        LOWER(`Email`) AS `Email`, 
        `CertificationDesc`, 
        `CertificationDate`
        FROM (SELECT *,
            @rank:=IF(@id = `AdminID`, @rank + 1, 1) AS rank,
            @id:=`AdminID`
    FROM
        (SELECT 
        *
    FROM
        `1.AdminLicenseGradeRefereeHighest`
	WHERE NOT `AYSOID` = ''
    ORDER BY `AdminID` DESC) ordered
    GROUP BY `AdminID`) grouped
WHERE
    rank = 1
ORDER BY `Section` , `Area` , `Region` , `Last_Name`;

INSERT INTO `tmpAdminLicenseGradeRefereeHighest` SELECT * 
FROM `1.AdminLicenseGradeRefereeHighest`
WHERE `AYSOID` = '';

DROP TABLE IF EXISTS `1.AdminLicenseGradeRefereeHighest`;

ALTER TABLE `tmpAdminLicenseGradeRefereeHighest` 
RENAME TO  `1.AdminLicenseGradeRefereeHighest`;

DELETE FROM `1.AdminLicenseGradeRefereeHighest` WHERE `CertificationDesc` = '';

SELECT 
    *
FROM
    `1.AdminLicenseGradeRefereeHighest`;
    
    
