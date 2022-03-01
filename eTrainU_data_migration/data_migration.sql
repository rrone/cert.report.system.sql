USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DROP TABLE IF EXISTS `1_Course_History_Import`;

CREATE TABLE `1_Course_History_Import` (
  `ID` int(11) NOT NULL,
  `FirstName` text,
  `LastName` text,
  `AYSOID` int(11) DEFAULT NULL,
  `CertificationDesc` text,
  `CertificationID` int(11) DEFAULT NULL,
  `VolunteerCertificationID` int(11) DEFAULT NULL,
  `Cert Date` text,
  `MY` text,
  `DOB` text,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/eTrainU_data_migration/OneDrive_1_6-16-2021/Section_1_-_Course_History_Data_-_06092021.txt'  
	INTO TABLE `1_Course_History_Import`   
	FIELDS TERMINATED BY '\t'   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;   
    
DROP TABLE IF EXISTS `1_Instructor_Import`;

CREATE TABLE `1_Instructor_Import` (
    `ID` VARCHAR(45) NOT NULL,
    `﻿First Name` TEXT,
    `Last Name` TEXT,
    `Email` TEXT,
    `DOB` TEXT,
    `Admin ID` INT(11) DEFAULT NULL,
    `Admin GUID` TEXT,
    `Instructor Course Access` TEXT,
    PRIMARY KEY (`ID`)
)  ENGINE=INNODB DEFAULT CHARSET=LATIN1;

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/eTrainU_data_migration/OneDrive_1_6-16-2021/Section_1_-_Instructor_Import_-_06092021.txt'  
	INTO TABLE `1_Instructor_Import`   
	FIELDS TERMINATED BY '\t'   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;   

