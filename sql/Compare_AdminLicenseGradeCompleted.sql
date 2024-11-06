USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

/* Save as ./yyyymmdd/yyyymmdd.import_errors.csv */
SELECT 
    *
FROM
    (SELECT 
        alg.`AdminID`,
            `SAR`,
            `First_Name`,
            `Last_Name`,
            `DOB`,
            `Gender`,
            `Email`,
            `Certification_Desc` AS `CertificationDesc`,
            `Certification_Date` AS `CertificationDate`,
            alg.`CertificationDesc` AS `AS_CertificationDesc`,
            alg.`CertificationDate` AS `AS_CertificationDate`
    FROM
        `1.Completed_Upgrades` cu
    RIGHT JOIN `1.AdminLicenseGrade` alg ON cu.`AdminID` = alg.`AdminID` AND cu.`Certification_Desc` = alg.`CertificationDesc`
    ORDER BY `CertificationDate`, FIELD(`CertificationDesc`,
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
        '') , `SAR` ) j
WHERE
    `CertificationDesc` LIKE '%Referee'
        AND `CertificationDesc` <> `AS_CertificationDesc`;

