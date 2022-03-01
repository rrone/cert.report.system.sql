SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DROP TABLE IF EXISTS tmp_not_basic;

CREATE TEMPORARY TABLE tmp_not_basic SELECT DISTINCT `AYSO Volunteer ID` FROM
    ayso1ref_services.crs_1_certs
WHERE
    `AYSO Certifications` LIKE '%Instructor%'
        AND NOT `AYSO Certifications` LIKE '%Basic%';
SELECT 
    `Program AYSO Membership Year`,
    `AYSO Volunteer ID`,
    `Volunteer First Name`,
    `Volunteer Last Name`,
    `AYSO Certifications`,
    `Date of Last AYSO Certification Update`,
    `Portal Name`
FROM
    (SELECT 
        *,
            @rankID:=IF(@id = `AYSO Volunteer ID`, @rankID + 1, 1) AS rankID,
            @id:=`AYSO Volunteer ID`
    FROM
        (SELECT DISTINCT
        `Program AYSO Membership Year`,
            `AYSO Volunteer ID`,
            `Volunteer First Name`,
            `Volunteer Last Name`,
            `AYSO Certifications`,
            `Date of Last AYSO Certification Update`,
            `Portal Name`
    FROM
        ayso1ref_services.crs_1_certs
    WHERE
        `AYSO Certifications` LIKE '%Instructor%'
            AND NOT `AYSO Volunteer ID` IN (SELECT 
                *
            FROM
                tmp_not_basic)
            AND NOT `AYSO Certifications` LIKE '%Course'
    GROUP BY `AYSO Volunteer ID` , `Program AYSO Membership Year` DESC) grouped) ranked
WHERE
    rankID = 1
ORDER BY `Program AYSO Membership Year` DESC , `AYSO Volunteer ID` , `Date of Last AYSO Certification Update` DESC;
