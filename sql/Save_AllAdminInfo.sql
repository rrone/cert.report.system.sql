USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DROP TABLE IF EXISTS `20230118.all.AdminInfo`;

CREATE TABLE `20230118.all.AdminInfo` SELECT * FROM
    `1.AdminInfo`
WHERE
    `CertificationDate` >= '2022-08-01'
        AND (`CertificationDesc` LIKE '%Referee' OR `CertificationDesc` LIKE '%Official')
        AND `CertificationDesc` IN ('National Referee' , 'Advanced Referee',
        'Intermediate Referee',
        'Regional Referee',
		'Assistant Referee',
        '8U Official')
ORDER BY FIELD(`CertificationDesc`,
        'National Referee',
        'Advanced Referee',
        'Intermediate Referee',
        'Regional Referee',
        'Assistant Referee',
        '8U Official') , `CertificationDate` DESC , `AdminID` DESC;

SELECT DISTINCT 
   `Section`,
    `Area`,
    `FirstName`,
    `LastName`,
    `Gender`,
    `Email`,
    `Address`,
    `City`,
    `State`,
    `PostalCode`,
    `CertificationDesc`,
    `CertificationDate` 
FROM
    `20230118.all.AdminInfo`;
