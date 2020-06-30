
DROP TABLE IF EXISTS crs_1_201912_certs;

CREATE TABLE crs_1_201912_certs (
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

LOAD DATA LOCAL INFILE '/Users/rick/Dropbox/_open/_ayso/s1/reports/data/1_201912.txt'  
	INTO TABLE crs_1_201912_certs   
	FIELDS TERMINATED BY '\t'   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;   


DELETE FROM crs_1_201912_certs WHERE `Program Name` like '%Do not use%';

Update crs_1_201912_certs
SET `Date of Last AYSO Certification Update` =  SPLIT_STRING(`Date of Last AYSO Certification Update`, ' ' , 1);

-- Update crs_1_201912_certs

-- Update crs_1_201912_certs

SELECT * FROM crs_1_201912_certs;