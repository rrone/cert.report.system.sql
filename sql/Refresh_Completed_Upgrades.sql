USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

-- LOAD DATA LOCAL INFILE '/Users/rick/Desktop/completed.csv'
-- 	INTO TABLE `1.Completed_Upgrades`
-- 	FIELDS TERMINATED BY ','   
-- 	OPTIONALLY ENCLOSED BY '"'  
-- 	LINES TERMINATED BY '\n'
-- 	IGNORE 1 ROWS;  

-- ALTER TABLE `ayso1ref_services`.`1.Completed_Upgrades` 
-- CHANGE COLUMN `AYSO_ID` `AdminID` TEXT NULL DEFAULT NULL ;

LOAD DATA LOCAL INFILE '~/.CMVolumes/ayso1sra/s1/upgrades/__database/upgrade.labels.csv'
	INTO TABLE `1.Completed_Upgrades`
	FIELDS TERMINATED BY ','   
	OPTIONALLY ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

UPDATE `1.Completed_Upgrades` c SET `Certification_Date` = str_to_date(`Certification_Date`, '%m/%d/%Y') WHERE `Certification_Date` LIKE '%/%';

-- CREATE INDEX `idx_1.Completed_Upgrades_AdminID`  ON `1.Completed_Upgrades` (AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

/* remove duplicates */
DROP TABLE IF EXISTS `tmp_Completed_Upgrades`;

CREATE TABLE `tmp_Completed_Upgrades` SELECT DISTINCT * FROM
    (SELECT 
        *,
            @rank:=IF(@id = `AdminID`, @rank + 1, 1) AS rank,
            @id:=`AdminID` AS id
    FROM
        (SELECT 
        *
    FROM
        `1.Completed_Upgrades`
    ORDER BY `AdminID` , `Certification_Date` DESC) ordered
    GROUP BY `AdminID` , FIELD(`Certification_Desc`, 'National Referee', 'National 2 Referee', 'Advanced Referee', 'Intermediate Referee', 'Regional Referee', 'Regional Referee & Safe Haven Referee', 'Assistant Referee', 'Assistant Referee & Safe Haven Referee', '8U Official', 'U-8 Official & Safe Haven Referee', 'Z-Online 8U Official', '')) grouped
WHERE
    rank = 1 AND `AdminID` <> ''
ORDER BY FIELD(`Certification_Desc`,
        'National Referee',
        'National 2 Referee',
        'Advanced Referee',
        'Intermediate Referee',
        'Regional Referee',
        'Regional Referee & Safe Haven Referee',
        'Assistant Referee',
        'Asst. Referee',
        'Assistant Referee & Safe Haven Referee',
        '8U Official',
        'U-8 Official & Safe Haven Referee',
        'Z-Online 8U Official',
        '') , `SAR` , `Last_Name`;
        
ALTER TABLE `tmp_Completed_Upgrades`
DROP COLUMN `id`,
DROP COLUMN `rank`;        

DROP TABLE IF EXISTS `1.Completed_Upgrades`;

ALTER TABLE `tmp_Completed_Upgrades`
RENAME TO `1.Completed_Upgrades`;
    
SELECT 
    *
FROM
    `1.Completed_Upgrades`
ORDER BY `Certification_Date`, `AdminID`;    