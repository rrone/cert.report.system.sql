/***************************************/
--  Load SportsConnect certs`

-- init table crs_certs
DROP TABLE IF EXISTS crs_certs;

CREATE TABLE `crs_certs` (
	`Program Name` text,
	`Membership Year` varchar(200),
	`Volunteer Role` text,
    `IDNUM` text,
	`AYSOID` varchar(20),
	`Name` longtext,
	`First Name` text,
	`Last Name` text,
	`Address` text,
	`City` text,
	`State` text,
	`Zip` text,
	`Home Phone` text,
	`Cell Phone` text,
	`Email` text,
	`Gender` text,
	`CertificationDesc` text,
	`CertDate` varchar(10) CHARACTER SET utf8,
	`SAR` varchar(98) NOT NULL DEFAULT '',
	`Section` varchar(32) NOT NULL,
	`Area` varchar(32) NOT NULL,
	`Region` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE crs_certs AUTO_INCREMENT = 0; 
ALTER TABLE crs_certs ADD INDEX (`AYSOID`);
ALTER TABLE crs_certs ADD INDEX (`Membership Year`);

-- init table crs_shcerts
DROP TABLE IF EXISTS crs_shcerts;

CREATE TABLE `crs_shcerts` (
	`Program Name` text,
	`Membership Year` text,
	`Volunteer Role` text,
    `IDNUM` text,
	`AYSOID` varchar(20),
	`Name` longtext,
	`First Name` text,
	`Last Name` text,
	`Address` text,
	`City` text,
	`State` text,
	`Zip` text,
	`Home Phone` text,
	`Cell Phone` text,
	`Email` text,
	`Gender` text,
	`CertificationDesc` text,
	`CertDate` varchar(10) CHARACTER SET utf8,
	`SAR` varchar(98) NOT NULL DEFAULT '',
	`Section` varchar(32) NOT NULL,
	`Area` varchar(32) NOT NULL,
	`Region` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE `crs_shcerts` 
AUTO_INCREMENT = 0, 
ADD INDEX (`aysoid`);

-- Refresh Section BS data table `crs_1_certs`
DROP TABLE IF EXISTS `tmp_1_certs`;   

CREATE TEMPORARY TABLE `tmp_1_certs` (
	`Program Name` text,
	`Program AYSO Membership Year` text,
	`Volunteer Role` text,
    `IDNUM` text,
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

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.txt'  
	INTO TABLE `tmp_1_certs`   
	FIELDS TERMINATED BY '\t'   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;   

DELETE FROM `tmp_1_certs` WHERE `Program Name` like '%Do not use%';

-- Restore Region deleted programs & volunteers in past seasons
INSERT INTO `tmp_1_certs` SELECT * FROM `crs_1_201812_certs`;
INSERT INTO `tmp_1_certs` SELECT * FROM `crs_1_201905_certs`;
INSERT INTO `tmp_1_certs` SELECT * FROM `crs_1_201912_certs`;
INSERT INTO `tmp_1_certs` SELECT * FROM `crs_1_202105_certs`;

# -10-30: Correct cross-id contamination with 97815888  
ALTER TABLE `tmp_1_certs` 
ADD COLUMN `id` INT NOT NULL AUTO_INCREMENT AFTER `Portal Name`,
ADD PRIMARY KEY (`id`);

DELETE FROM `tmp_1_certs` 
WHERE
    `AYSO Volunteer ID` = 97815888
    AND `Gender` = 'F';
        
ALTER TABLE `tmp_1_certs`
DROP COLUMN `id`,
DROP PRIMARY KEY;        
# END: -10-30: Correct cross-id contamination with 97815888 

-- 2021.08.22 remove duplicate records
DROP TABLE IF EXISTS `crs_1_certs`;  
CREATE TABLE `crs_1_certs` SELECT DISTINCT * FROM `tmp_1_certs`;  
-- END: remove duplicate records    

-- Clean up imported data
DELETE FROM `crs_1_certs` WHERE `AYSO Volunteer ID` IS NULL;
UPDATE `crs_1_certs` SET `Program Name` = REPLACE(`Program Name`, '"', '');
UPDATE `crs_1_certs` SET `Volunteer Role` = REPLACE(`Volunteer Role`, '"', '');
UPDATE `crs_1_certs` SET `Volunteer Address` = REPLACE(`Volunteer Address`, '"', '');
UPDATE `crs_1_certs` SET `Volunteer City` = REPLACE(`Volunteer City`, '"', '');
UPDATE `crs_1_certs` SET `Portal Name` = REPLACE(`Portal Name`, '"', '');

ALTER TABLE `crs_1_certs` 
ADD INDEX (`AYSO Volunteer ID`),
ADD INDEX (`Portal Name`);

# Maureen Reid 73895502 registered Section 1 in error lives in Pennsylvania
DELETE FROM `crs_1_certs` WHERE `AYSO Volunteer ID` = 73895502;

CALL `processBSCSV`('crs_1_certs');  

/***************************************/
-- 2021-01-06: eAYSO report files are no longer available.  No need to update.
-- Load eAYSO certs`

-- Load `eAYSO.MY2017.certs`
CALL `prepEAYSOCSVTable`('eAYSO.MY2016.certs');

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/eAYSO.MY2016.certs.csv'
	INTO TABLE `eAYSO.MY2016.certs`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;   

--  Load `eAYSO.MY2017.certs`
CALL `prepEAYSOCSVTable`('eAYSO.MY2017.certs');

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/eAYSO.MY2017.certs.csv'
	INTO TABLE `eAYSO.MY2017.certs`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;   
	
--  Refresh `eAYSO.MY2018.certs`
CALL `prepEAYSOCSVTable`('eAYSO.MY2018.certs');

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/eAYSO.MY2018.certs.csv'
	INTO TABLE `eAYSO.MY2018.certs`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;   

--  Refresh `eAYSO.MY2019.certs`
CALL `prepEAYSOCSVTable`('eAYSO.MY2019.certs');

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/eAYSO.MY2019.certs.csv'
	INTO TABLE `eAYSO.MY2019.certs`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;   
--
-- Still need to add eAYSO certs to crs_certs and crs_shcerts 
CALL `processEAYSOCSV`();