USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DELETE FROM `1.Volunteer_Certs_AdminLicenseGrade` WHERE `e3 Ref Cert Desc` = '' ;

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

/* update MYs in InLeague Regions */
UPDATE `1.AdminLicenseGradeRefereeHighest` h SET `MY` = (SELECT `MY` FROM `1.VolunteerReportExport` WHERE h.`AYSOID` = `1.VolunteerReportExport`.`AYSOID`) WHERE `Region` IN (13,20,70,76,78,210,223,300,362,473,611,644,1505);

SELECT 
    *
FROM
    `1.AdminLicenseGradeRefereeHighest`;