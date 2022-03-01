SELECT DISTINCT
    #`Membership Year`,
    AYSOID,
    `First Name`,
    `Last Name`,
    Gender,
    CertificationDesc,
    CertDate,
    Section,
    Area
FROM
    ayso1ref_services.crs_certs
WHERE
    `CertificationDesc` LIKE '%Course'
        AND `CertificationDesc` LIKE '%Referee%'
        AND YEAR(`CertDate`) = 2019
ORDER BY `CertificationDesc` , `Section` , `Area` , `Last Name`;


-- SELECT DISTINCT
--     #`Membership Year`,
--     AYSOID
-- FROM
--     ayso1ref_services.crs_certs
-- WHERE
--     `CertificationDesc` LIKE '%Course'
--         AND `CertificationDesc` LIKE '%Referee%'
--         AND YEAR(`CertDate`) = 2019;
-- 