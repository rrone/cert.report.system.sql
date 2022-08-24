USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DROP TABLE IF EXISTS `crs_rpt_ra`;

CREATE TABLE `crs_rpt_ra` SELECT DISTINCT rc.`AdminID`,
    rc.`AYSOID`,
    rc.`MY`,
    rc.`SAR`,
    rc.`Section`,
    rc.`Area`,
    rc.`Region`,
    rc.`First_Name`,
    rc.`Last_Name`,
    rc.`City`,
    rc.`State`,
    rc.`Zipcode`,
    rc.`Cell_Phone`,
    rc.`DOB`,
    rc.`Gender`,
    rc.`Email`,
    ra.`CertificationDesc`,
    ra.`CertificationDate`,
    rc.`Safe_Haven_Date`,
    rc.`Concussion_Awareness_Date`,
    rc.`Sudden_Cardiac_Arrest_Date`,
    rc.`SafeSport_Date`,
    rc.`LiveScan_Date`,
    rc.`RiskStatus`,
    rc.`RiskExpireDate`,
    IF(`MY` >= 'MY2021'
            AND NOT ISNULL(`Safe_Haven_Date`)
            AND NOT ISNULL(`Concussion_Awareness_Date`)
            AND NOT ISNULL(`Sudden_Cardiac_Arrest_Date`)
            AND NOT ISNULL(`SafeSport_Date`)
--             AND NOT ISNULL(`LiveScan_Date`)
            AND NOT ISNULL(`RiskStatus`)
            AND NOT `RiskStatus` IN ('Expired' , 'None'),
        'Yes',
        NULL) AS `Current` FROM
    `crs_rpt_ref_certs` rc
        LEFT JOIN
    `1.RefAssessors.20220815` ra ON ra.AdminID = rc.AdminID
WHERE
    NOT ra.AdminID IS NULL
ORDER BY `Section`, `Area`, FIELD(ra.`CertificationDesc`,
        'National Referee Assessor',
        'Referee Assessor',
        ''), `Region`, `Last_Name`;

SELECT 
    DISTINCT *
FROM
    `crs_rpt_ra`
WHERE ISNULL(`Current`);

SELECT 
    DISTINCT *
FROM
    `crs_rpt_ra`
WHERE NOT ISNULL(`Current`);

SELECT 
    DISTINCT *
FROM
    `crs_rpt_ra`
WHERE NOT ISNULL(`Current`)
 AND `CertificationDesc` LIKE 'National%';
