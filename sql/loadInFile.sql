USE `ayso1ref_services`;

DROP TABLE IF EXISTS `crs_1_201905_certs`;   

CREATE TABLE `crs_1_201905_certs` (
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

LOAD DATA LOCAL INFILE '/Volumes/Secomba/rick/Boxcryptor/Google Drive/s1/reports_encrypted/20190524_encrypted/1.txt'  
	INTO TABLE `crs_1_201905_certs`   
	FIELDS TERMINATED BY '\t'   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\r'
	IGNORE 1 ROWS; 