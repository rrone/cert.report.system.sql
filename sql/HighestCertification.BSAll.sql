USE `ayso`;

SET @id = 0;

SELECT 
    *
FROM
    (SELECT 
        `Progra`,
            `MY`,
            `AYSO Volunteer ID`,
            PROPER_CASE(`Volunteer First Name`) AS 'Volunteer First Name',
            PROPER_CASE(`Volunteer Last Name`) AS 'Volunteer Last Name',
            LCASE(`Volunteer Email`) AS Email,
            `AYSO Certifications`,
            `Portal Name`
    FROM
        (SELECT 
        *,
            @rank:=IF(@id = `AYSO Volunteer ID`, @rank + 1, 1) AS rank,
            @id:=`AYSO Volunteer ID`
    FROM
        (SELECT 
        *
    FROM
        `MY2017 - All referee certs`
    WHERE
        `AYSO Certifications` LIKE '%Referee%'
            AND NOT `AYSO Certifications` LIKE '%Assessor%'
            AND NOT `AYSO Certifications` LIKE '%Instructor%'
            AND NOT `AYSO Certifications` LIKE '%Administrator%'
            AND NOT `AYSO Certifications` LIKE '%VIP%'
            AND NOT `AYSO Certifications` LIKE '%Course%'
            AND NOT `AYSO Certifications` LIKE '%Mentor%'
            AND NOT `AYSO Certifications` LIKE '%Assignor%'
            GROUP BY `AYSO Volunteer ID` , FIELD(`AYSO Certifications`, 'National Referee', 'National 2 Referee', 'Advanced Referee', 'Intermediate Referee', 'Regional Referee', 'Regional Referee & Safe Haven Referee', 'z-Online Regional Referee without Safe Haven', 'Assistant Referee', 'Assistant Referee & Safe Haven Referee', 'U-8 Official', 'U-8 Official & Safe Haven Referee', 'Z-Online Safe Haven Referee', 'Safe Haven Referee')) ordered) ranked
    WHERE
        rank = 1) s
GROUP BY `AYSO Volunteer ID`
HAVING COUNT(*) = 1
ORDER BY FIELD(`AYSO Certifications`,
        'National Referee',
        'National 2 Referee',
        'Advanced Referee',
        'Intermediate Referee',
        'Regional Referee',
        'Regional Referee & Safe Haven Referee',
        'z-Online Regional Referee without Safe Haven',
        'Safe Haven Referee',
        'Z-Online Safe Haven Referee',
        'Z-Online Regional Referee',
        'Assistant Referee',
        'Assistant Referee & Safe Haven Referee',
        'U-8 Official & Safe Haven Referee'), `Portal Name`, `Volunteer Last Name` , `Volunteer First Name` , `AYSO Volunteer ID`
