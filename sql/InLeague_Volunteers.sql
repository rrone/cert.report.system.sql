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
  `Gender` text,
  `Street` text,
  `City` text,
  `State` text,
  `Zip` text,
  `HomePhone` text,
  `CellPhone` text,
  `Email` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2016.Volunteer_Report_Export.csv'
	INTO TABLE `e3_inLeague_reports`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2017.Volunteer_Report_Export.csv'
	INTO TABLE `e3_inLeague_reports`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2018.Volunteer_Report_Export.csv'
	INTO TABLE `e3_inLeague_reports`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

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

UPDATE `e3_inLeague_reports` SET `Zip` = replace(`Zip`,'''','');

DROP TABLE IF EXISTS `e3_inLeague`;

CREATE TABLE `e3_inLeague` SELECT DISTINCT
  `AYSOID`,
  `Section`,
  `Area`,
  `Region`,
  `Membershipyear`,
  `Volunteer Position`,
  `LastName`,
  `FirstName`,
  `DOB`,
  `Gender`,
  `Street`,
  `City`,
  `State`,
  `Zip`,
  FORMAT_AS_PHONE_NUMBER(`HomePhone`) AS `HomePhone`,
  FORMAT_AS_PHONE_NUMBER(`CellPhone`) AS `CellPhone`,
  `Email`

FROM
    `ayso1ref_services`.`e3_inLeague_reports`
WHERE
    Region IN (13 , 20, 70, 76, 78);
    
SELECT 
    *
FROM
    `e3_inLeague`;   