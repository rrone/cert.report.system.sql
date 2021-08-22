DROP TABLE IF EXISTS `e3_inLeague_reports`;

CREATE TEMPORARY TABLE `e3_inLeague_reports` (
  `Section` int(11) DEFAULT NULL,
  `Area` text,
  `Region` int(11) DEFAULT NULL,
  `AYSOID` int(11) DEFAULT NULL,
  `Membershipyear` text,
  `Volunteer Position` text,
  `LastName` text,
  `FirstName` text,
  `DOB` text,
  `Gender` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2019.Volunteer_Report_Export.csv'
	INTO TABLE `e3_inLeague_reports`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2020.Volunteer_Report_Export.csv'
	INTO TABLE `e3_inLeague_reports`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2021.Volunteer_Report_Export.csv'
	INTO TABLE `e3_inLeague_reports`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

DROP TABLE IF EXISTS `e3_inLeague`;

CREATE TABLE `e3_inLeague` SELECT DISTINCT
    `AYSOID`,
    `Section`,
    `Area`,
    `Region`,
    `Volunteer Position`,
    `LastName`,
    `FirstName`,
    `DOB`,
    `Gender`
FROM
    `ayso1ref_services`.`e3_inLeague_reports`
WHERE
    Region IN (13 , 20, 70, 76, 78);
    
SELECT 
    *
FROM
    `e3_inLeague`;   