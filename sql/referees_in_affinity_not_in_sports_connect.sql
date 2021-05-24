SELECT DISTINCT
    MY,
    League1,
    Club1,
    ClubID1,
    IDNUM,
    AltID1,
    FirstName1,
    LastName1,
    DOB1,
    GenderCode1,
    email1,
    refGrade,
    refObtainDate
FROM
    ayso1ref_services.AdminCredentialsStatusDynamic
WHERE
    refGrade LIKE '%Referee%'
        AND AltID1 NOT IN (SELECT 
            AYSOID
        FROM
            ayso1ref_services.crs_rpt_ref_certs)
ORDER BY League1, Club1, LastName1;