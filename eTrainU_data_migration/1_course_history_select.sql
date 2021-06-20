
SELECT 
    `ID`,
    `FirstName`,
    `LastName`,
    `AYSOID`,
    `CertificationDesc`,
    `CertificationID`,
    `VolunteerCertificationID`,
    `yyTOyyyy`(`Cert Date`) as `CertDate`, 
    `MY`,
    `yyTOyyyy`(`DOB`) AS `DOB`
FROM
    `ayso1ref_services`.`1_Course_History_Import`
ORDER BY `DOB`;
