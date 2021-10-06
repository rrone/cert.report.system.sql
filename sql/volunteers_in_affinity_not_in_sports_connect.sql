DELETE FROM ayso1ref_services.AdminCredentialsStatusDynamic WHERE email1 LIKE 'taidghsemaildump%';

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
AltID1 NOT IN (SELECT 
            `AYSO Volunteer ID`
        FROM
            ayso1ref_services.crs_1_certs)
ORDER BY League1, Club1, LastName1;