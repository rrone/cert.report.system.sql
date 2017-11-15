USE `wp_ayso1ref`;

SET @id = 0;

SELECT 
	`AYSO Volunteer ID` AS AYSOID,
    PROPER_CASE(concat(`Volunteer First Name`,' ',`Volunteer Last Name`)) AS 'Name',
    PROPER_CASE(`Volunteer First Name`) AS 'First Name',
    PROPER_CASE(`Volunteer Last Name`) AS 'Last Name',
	PROPER_CASE(`Volunteer Address`) AS Address,
    PROPER_CASE(`Volunteer City`) AS City,
    `Volunteer State` AS State,
    `Volunteer Zip` AS Zip,
	`Volunteer Phone` AS 'Home Phone',
    `Volunteer Cell` AS 'Cell Phone',
	LCASE(`Volunteer Email`) AS Email,
    `AYSO Certifications` AS CertificationDesc,
    SPLIT_STRING(`Date of Last AYSO Certification Update`, ' ', 1) AS CertDate,
    `Portal Name` AS Region,
    `SAR`,
    SPLIT_STRING(`SAR`, '/', 1) AS Section,
    SPLIT_STRING(`SAR`, '/', 2) AS Area,
    SPLIT_STRING(`SAR`, '/', 3) AS Region,
    `Program AYSO Membership Year` AS MY
    FROM (
		SELECT *,
			@rank := IF(@id = `AYSO Volunteer ID`, @rank + 1, 1) AS rank,
			@id := `AYSO Volunteer ID`
		 FROM (
		 SELECT * FROM `rs_s1certs`
			WHERE 
				`AYSO Certifications` LIKE '%Referee%' AND
				NOT `AYSO Certifications` LIKE '%Assessor%' AND
				NOT `AYSO Certifications` LIKE '%Instructor%' AND
				NOT `AYSO Certifications` LIKE '%Administrator%' AND
				NOT `AYSO Certifications` LIKE '%VIP%' AND
				NOT `AYSO Certifications` LIKE '%Course%' 
			
			GROUP BY `AYSO Volunteer ID`, FIELD(`AYSO Certifications`,
				'National Referee',
				'National 2 Referee',
				'Advanced Referee',
				'Intermediate Referee',
				'Regional Referee',
				'Regional Referee & Safe Haven Referee',
				'z-Online Regional Referee without Safe Haven',
				'Assistant Referee',
				'Assistant Referee & Safe Haven Referee',
				'U-8 Official',
				'U-8 Official & Safe Haven Referee',
				'Z-Online Safe Haven Referee',
				'Safe Haven Referee'
			) 
		) ordered
	) ranked  WHERE rank = 1
    ORDER BY Section, Area, `Last Name`, `First Name`, AYSOID;

-- INTO OUTFILE '/Users/frederickroberts/Dropbox/_open/_ayso/s1/reports/20171031.s1refs.highest.csv'
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'; 
