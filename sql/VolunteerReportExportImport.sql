USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

SET sort_buffer_size=1024 * 1024 * 1;

DROP TABLE IF EXISTS `1.VolunteerReportExport`;

CREATE TEMPORARY TABLE `1.VolunteerReportExport` (
  `Section` text,
  `Area` text,
  `Region` int(11),
  `AYSOID` varchar(20) NOT NULL,
  `MY` text,
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

CREATE INDEX `idx_VolunteerReportExport_AYSOID`  ON `1.VolunteerReportExport` (AYSOID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2016.Volunteer_Report_Export.csv'
	INTO TABLE `1.VolunteerReportExport`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2017.Volunteer_Report_Export.csv'
	INTO TABLE `1.VolunteerReportExport`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2018.Volunteer_Report_Export.csv'
	INTO TABLE `1.VolunteerReportExport`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2019.Volunteer_Report_Export.csv'
	INTO TABLE `1.VolunteerReportExport`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2020.Volunteer_Report_Export.csv'
	INTO TABLE `1.VolunteerReportExport`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/1.2021.Volunteer_Report_Export.csv'
	INTO TABLE `1.VolunteerReportExport`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

DELETE FROM `1.VolunteerReportExport` WHERE `LastName` in ('Volunteer1');

/* fix Rich Fichtelman's data */
UPDATE `1.VolunteerReportExport` SET `AYSOID` = '99811580' WHERE `AYSOID` = '203143317';


/* fix wise asses */
UPDATE `1.VolunteerReportExport` SET `Street` = '' WHERE `Street` = 'Street';
UPDATE `1.VolunteerReportExport` SET `City` = '' WHERE `City` = 'City';
UPDATE `1.VolunteerReportExport` SET `HomePhone` = '' WHERE `HomePhone` = '123-456-7890';
UPDATE `1.VolunteerReportExport` SET `CellPhone` = '' WHERE `CellPhone` = '123-456-7890';

DROP TABLE IF EXISTS `VolunteerReportExport`;

CREATE TABLE `VolunteerReportExport` SELECT DISTINCT `AYSOID`,
    `MY`,
    `Section`,
    `Area`,
    EXTRACTNUMBER(`Region`) AS `Region`,
    PROPER_CASE(`LastName`) AS `LastName`,
    PROPER_CASE(`FirstName`) AS `FirstName`,
    `DOB`,
    `Gender`,
    PROPER_CASE(`Street`) AS `Street`,
    PROPER_CASE(`City`) AS `City`,
    `State`,
    EXTRACTNUMBER(`Zip`) AS `Zip`,
    FORMAT_AS_PHONE_NUMBER(`HomePhone`) AS `HomePhone`,
    FORMAT_AS_PHONE_NUMBER(`CellPhone`) AS `CellPhone`,
    LOWER(`Email`) AS `Email` FROM
    (SELECT 
        *,
            @rank:=IF(@id = `AYSOID`, @rank + 1, 1) AS rank,
            @id:=`AYSOID`
    FROM
        (SELECT 
        *
    FROM
        `1.VolunteerReportExport`
    ORDER BY `AYSOID` , `MY` DESC) ordered
    GROUP BY `AYSOID`) grouped
WHERE
    rank = 1
ORDER BY `Area` , `Region` , `LastName`;

DROP TABLE IF EXISTS `1.VolunteerReportExport`;

ALTER TABLE `VolunteerReportExport` 
RENAME TO  `1.VolunteerReportExport`;

DELETE FROM `1.VolunteerReportExport` WHERE `AYSOID` IS NULL;

CREATE INDEX `idx_1.VolunteerReportExport_AYSOID`  ON `1.VolunteerReportExport` (AYSOID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

/* Save as 19-21.VolunteerReport_InLeague.csv */
SELECT 
    vre.*
FROM
    `1.VolunteerReportExport` vre
        LEFT JOIN
    `1.AdminLicenseGrade` alg ON vre.AYSOID = alg.AYSOID
WHERE
    vre.`Region` IN (13 , 20, 70, 76, 78)
        AND vre.`MY` >= 'MY2019';