USE `s1_referees`;

SET @id = 0;

	SELECT *,
		@rank := IF(@id = `AYSO Volunteer ID`, @rank + 1, 1) AS rank,
		@id := `AYSO Volunteer ID`
	 FROM (
	 SELECT * FROM `20171031.s1refs`
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
			'Z-Online Safe Haven Referee',
			'Assistant Referee',
			'Assistant Referee & Safe Haven Referee',
			'U-8 Official',
			'U-8 Official & Safe Haven Referee',
            'Safe Haven Referee'
		) 
	) ordered
