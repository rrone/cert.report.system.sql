USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DROP TABLE IF EXISTS `VCI`;

CREATE TEMPORARY TABLE `VCI` (
  `First_Name` text,
  `Last_Name` text,
  `Address` text,
  `Address_2` text,
  `City` text,
  `State` text,
  `Zip_Code` text,
  `Email` VARCHAR(255),
  `Cell_Phone` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/1.Volunteer_Details.csv'
	INTO TABLE `VCI`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

SELECT 
    *
FROM
    `VCI`;
 
DROP TABLE IF EXISTS `1.Volunteer_Contact_Information`;

CREATE TABLE `1.Volunteer_Contact_Information` SELECT DISTINCT * FROM `VCI`;
    
CREATE INDEX `idx_1_Email`  ON `1.Volunteer_Contact_Information` (Email) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

SELECT 
    *
FROM
    `1.Volunteer_Contact_Information`;
