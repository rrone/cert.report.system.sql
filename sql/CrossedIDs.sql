DROP TABLE IF EXISTS `1`;
CREATE TABLE `1` (
	`Program Name` text,
	`Program AYSO Membership Year` text,
	`Volunteer Role` text,
	`AYSO Volunteer ID` int(11),
	`Volunteer First Name` text,
	`Volunteer Last Name` text,
	`Volunteer Address` text,
	`Volunteer City` text,
	`Volunteer State` text,
	`Volunteer Zip` text,
	`Volunteer Phone` text,
	`Volunteer Cell` text,
	`Volunteer Email` text,
	`Gender` text,
	`AYSO Certifications` text,
	`Date of Last AYSO Certification Update` text,
	`Portal Name` varchar(250)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.rick.roberts.9/_ayso/s1/reports/data/1.txt'  
	INTO TABLE `1`   
	FIELDS TERMINATED BY '\t'   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;   
    
-- SELECT 
--     *
-- FROM
--     `ayso1ref_services`.`1`;
    
SELECT DISTINCT
    a.`Program AYSO Membership Year`,
    a.`Volunteer Last Name`,
    a.`Volunteer First Name`,
    a.`AYSO Volunteer ID`,
    b.`AYSO Volunteer ID`,
    CONCAT (a.`Portal Name`, '/', b.`Portal Name`) as `Portals`
FROM
    ayso1ref_services.`1` a,
    ayso1ref_services.`1` b
WHERE
    b.`Program AYSO Membership Year` = 2020
        AND a.`Volunteer First Name` = b.`Volunteer First Name`
        AND a.`Volunteer Last Name` = b.`Volunteer Last Name`
        AND a.`Program AYSO Membership Year` = 2020
        AND b.`Program AYSO Membership Year` = 2020
        AND a.`AYSO Volunteer ID` <> b.`AYSO Volunteer ID`
        AND a.`Portal Name` <> b.`Portal Name`;    
    