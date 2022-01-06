USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DROP TABLE IF EXISTS `1.AdminLicenseGradeRefereeHighest`;

CREATE TABLE `1.AdminLicenseGradeRefereeHighest` SELECT DISTINCT `AYSOID`,
    `AdminID`,
    `MY`,
    `Section`,
    `Area`,
    `Region`,
    `First_Name`,
    `Last_Name`,
    `Gender`,
    `Email`,
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

CREATE INDEX `idx_1.AdminLicenseGradeRefereeHighest_AYSOID_AdminID`  ON `1.AdminLicenseGradeRefereeHighest` (AYSOID, AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

/* update MYs in InLeague Regions to fix import errors */
UPDATE `1.AdminLicenseGradeRefereeHighest` h
        INNER JOIN
    `1.Volunteer_Certs_VolunteerReport_InLeague` v ON h.`AYSOID` = v.`AYSOID` 
SET 
    h.`MY` = v.`MY`
WHERE
    h.`AdminID` = ''
    AND v.`MY` > h.`MY`;
    
UPDATE `1.AdminLicenseGradeRefereeHighest` h
        INNER JOIN
    `1.AdminCredentialsStatusDynamic` acsd ON h.`AYSOID` = acsd.`AYSOID` 
SET 
    h.`MY` = acsd.`MY`
WHERE
    h.`MY` IS NULL;

/* update CertDesc in Highest Report */
UPDATE `1.AdminLicenseGradeRefereeHighest` h
        INNER JOIN
    `1.Volunteer_Certs_AdminLicenseGrade` vc ON h.`AYSOID` = vc.`AYSOID` 
SET 
    h.`CertificationDesc` = vc.`e3 Ref Cert Desc`,
    h.`CertificationDate` = vc.`e3 Ref Cert Date`;

INSERT INTO `1.AdminLicenseGradeRefereeHighest`
SELECT vre.`AYSOID`,
    '' AS `AdminID`,
    vre.`MY`,
    vre.`Section`,
    vre.`Area`,
    vre.`Region`,
    vre.`FirstName` AS `First_Name`,
    vre.`LastName` AS`Last_Name`,
    vre.`Gender`,
    vre.`Email`,
    vre.`Ref_Cert_Desc` AS `CertificationDesc`,
    vre.`Ref_Cert_Date` AS `CertificationDate` 
FROM
    `1.Volunteer_Certs_VolunteerReport_InLeague` vre
        LEFT JOIN
    `1.AdminLicenseGrade` alg ON vre.AYSOID = alg.AYSOID
WHERE alg.`AdminID` IS NULL;

DELETE FROM `1.AdminLicenseGradeRefereeHighest` WHERE `CertificationDesc` = '';

SELECT 
    *
FROM
    `1.AdminLicenseGradeRefereeHighest`;