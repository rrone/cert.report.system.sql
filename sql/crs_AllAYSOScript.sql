USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

-- init table crs_certs
DROP TABLE IF EXISTS crs_allAYSO_certs;

CREATE TABLE `crs_allAYSO_certs` (
	`MY` varchar(32),
	`AYSO ID` varchar(11),
	`Volunteer First Name` text,
	`Volunteer Last Name` text,
	`AYSO Certifications` text,
	`Date of Last AYSO Certification Update` text,
	`AYSO Region #` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOAD DATA LOCAL INFILE '/Users/rick/Dropbox/_open/_ayso/s1/reports/data.allAYSO/all.txt'  
	INTO TABLE `crs_allAYSO_certs`   
	FIELDS TERMINATED BY '\t'   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\r'
	IGNORE 1 ROWS;   

ALTER TABLE crs_allAYSO_certs AUTO_INCREMENT = 0; 
ALTER TABLE crs_allAYSO_certs ADD INDEX (`AYSO ID`);
ALTER TABLE crs_allAYSO_certs ADD INDEX (`MY`);

-- 2019-03-18: added because eAYSO is now returning blank dates for invalid dates
UPDATE ayso1ref_services.crs_allAYSO_certs 
SET 
    `Date of Last AYSO Certification Update` = '1964-09-15'
WHERE
    `AYSO Certifications` LIKE '%Referee%'
        AND `Date of Last AYSO Certification Update` = '';        

-- Refresh all temporary tables
CALL `RefreshAllAYSOHighestCertification`();  

SELECT 
    *
FROM
    crs_rpt_all_hrc;

