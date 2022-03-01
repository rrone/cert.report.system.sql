SELECT DISTINCT
    `AYSOID`, `Name`, `CertificationDesc`, `CertDate`
FROM
    ayso1ref_services.crs_refcerts
WHERE
    NOT CertificationDesc IN ('Regional Referee' , 'Safe Haven Referee',
        'U-8 Official',
        'Z-Online Safe Haven Referee',
        'Webinar - Regional Referee Administrator',
        'Webinar - Region Referee Administrator',
        'Regional Referee Administrator',
        'Z-Online Region Referee Administrator',
        'Webinar -  Area Referee Administrator',
        'Area Referee Administrator',
        'Webinar - Referee - VIP - National Games 2014',
        'Z-Online 8U Official',
        'Assistant Referee',
        'National 2 Referee')
        AND NOT `Name` IN ('Stephen Bodnar' , 'Emeka Ikpa',
        'Joseph Ortega',
        'Steven Moss',
        'Jon Swasey',
        'J. Stephen Felice',
        'David Marrujo',
        'Robert Hayes',
        'Bill Guernsey',
        'Hengching Chang')
ORDER BY `AYSOID` , FIELD(`CertificationDesc`,
        'National Referee',
        'National Referee Course',
        'Advanced Referee',
        'Advanced Referee Course',
        'Intermediate Referee',
        'Intermediate Referee Course',
        'Advanced Referee Instructor',
        'Advanced Referee Instructor Course',
        'Intermediate Referee Instructor',
        'Referee Instructor Course',
        'National Referee Assessor',
        'National Referee Assessor Course',
        'Referee Assessor',
        'Referee Assessor Course ');