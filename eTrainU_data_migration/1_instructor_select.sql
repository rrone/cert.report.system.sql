SELECT `ID`,
    `﻿First Name`,
    `Last Name`,
    `Email`,
    `yyTOyyyy`(`DOB`) as `DOB`,
    `Admin ID`,
    `Admin GUID`,
    `Instructor Course Access`
FROM
    `ayso1ref_services`.`1_Instructor_Import`
ORDER BY `DOB`;
