USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

-- DROP TABLE IF EXISTS `1.Completed_Upgrades`;
-- 
-- CREATE TABLE `1.Completed_Upgrades` (
--   `AdminID` varchar(16) DEFAULT NULL,
--   `AYSO_ID` text,
--   `BSID` text,
--   `FIRST_NAME` text,
--   `MI` text,
--   `LAST_NAME` text,
--   `ADDRESS` text,
--   `CITY` text,
--   `STATE` text,
--   `ZIP` text,
--   `SAR` text,
--   `Certification_Desc` text,
--   `Certification_Date` text,
--   `Course_Roster_Number` text,
--   `Day` text,
--   `Month` text,
--   `Year` text
-- ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
-- 
-- 
-- LOAD DATA LOCAL INFILE '~/.CMVolumes/ayso1sra/s1/upgrades/__database/completed.20230830.csv'
-- 	INTO TABLE `1.Completed_Upgrades`
-- 	FIELDS TERMINATED BY ','   
-- 	OPTIONALLY ENCLOSED BY '"'  
-- 	LINES TERMINATED BY '\n'
-- 	IGNORE 1 ROWS;  

LOAD DATA LOCAL INFILE '~/.CMVolumes/ayso1sra/s1/upgrades/__database/upgrade.labels.csv'
	INTO TABLE `1.Completed_Upgrades`
	FIELDS TERMINATED BY ','   
	OPTIONALLY ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

UPDATE `1.Completed_Upgrades` c SET `Certification_Date` = str_to_date(`Certification_Date`, '%m/%d/%Y') WHERE `Certification_Date` LIKE '%/%';

/* remove duplicates */
DROP TABLE IF EXISTS `tmp_Completed_Upgrades`;

CREATE TABLE `tmp_Completed_Upgrades` SELECT DISTINCT * 
    FROM
        `1.Completed_Upgrades`
WHERE
    `AdminID` <> '';
-- ORDER BY `AdminID`,
-- 	FIELD(`Certification_Desc`,
--         'National Referee',
--         'National 2 Referee',
--         'Advanced Referee',
--         'Intermediate Referee',
--         'Regional Referee',
--         'Regional Referee & Safe Haven Referee',
--         'Assistant Referee',
--         'Asst. Referee',
--         'Assistant Referee & Safe Haven Referee',
--         '8U Official',
--         'U-8 Official & Safe Haven Referee',
--         'Z-Online 8U Official',
--         '') , `SAR` , `Last_Name`;

SELECT * FROM `tmp_Completed_Upgrades`;
        
DROP TABLE IF EXISTS `1.Completed_Upgrades`;

ALTER TABLE `tmp_Completed_Upgrades`
RENAME TO `1.Completed_Upgrades`;
    
SELECT 
    *
FROM
    `1.Completed_Upgrades`
ORDER BY `AdminID`;    
