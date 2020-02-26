USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

-- init table crs_certs
DROP TABLE IF EXISTS crs_Section8_certs;

CREATE TABLE `crs_Section8_certs` (
	`MY` varchar(32),
	`AYSO ID` varchar(11),
	`Volunteer First Name` text,
	`Volunteer Last Name` text,
    `Volunteer Cell` text,
    `Volunteer Email` text,
	`AYSO Certifications` text,
	`Date of Last AYSO Certification Update` text,
	`AYSO Region #` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOAD DATA LOCAL INFILE '/Users/rick/Dropbox/_open/_ayso/s1/reports/data.Section8/s8.txt'  
	INTO TABLE `crs_Section8_certs`   
	FIELDS TERMINATED BY '\t'   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\r'
	IGNORE 1 ROWS;   

ALTER TABLE crs_Section8_certs AUTO_INCREMENT = 0; 
ALTER TABLE crs_Section8_certs ADD INDEX (`AYSO ID`);
ALTER TABLE crs_Section8_certs ADD INDEX (`MY`);

-- 2019-03-18: added because eAYSO is now returning blank dates for invalid dates
UPDATE ayso1ref_services.crs_Section8_certs 
SET 
    `Date of Last AYSO Certification Update` = '1964-09-15'
WHERE
    `AYSO Certifications` LIKE '%Referee%'
        AND `Date of Last AYSO Certification Update` = '';        

-- Refresh all temporary tables
CALL `RefreshSection8RefereeInstructors`();  

SELECT 
	`MY`,
	`AYSO ID`,
	`Volunteer First Name`,
	`Volunteer Last Name`,
    `Volunteer Cell`,
    `Volunteer Email`,
	`AYSO Certifications`,
	str_to_date(`Date of Last AYSO Certification Update`, '%m/%d/%Y') AS `Date of Last AYSO Certification Update`,
	`AYSO Region #` 

FROM
    crs_rpt_s8_ri
ORDER BY FIELD(`AYSO Certifications`,
        'National Referee Instructor',
        'Advanced Referee Instructor',
        'Intermediate Referee Instructor',
        'Referee Instructor',
        'Basic Referee Instructor',
        '') , `AYSO Region #` , `Date of Last AYSO Certification Update`, `Volunteer Last Name` , `Volunteer First Name` , `AYSO ID`;

