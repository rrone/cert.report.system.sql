USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DROP TABLE IF EXISTS `e3_reports`;

CREATE TABLE `e3_reports` (
  `Section` int(11) DEFAULT NULL,
  `Area` text,
  `Region` int(11) DEFAULT NULL,
  `AYSOID` int(11) DEFAULT NULL,
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

-- SET @all := true;
-- 
-- IF @all THEN

LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/all.2010.Volunteer_Report_Export.csv'
	INTO TABLE `e3_reports`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/all.2011.Volunteer_Report_Export.csv'
	INTO TABLE `e3_reports`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/all.2012.Volunteer_Report_Export.csv'
	INTO TABLE `e3_reports`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/all.2013.Volunteer_Report_Export.csv'
	INTO TABLE `e3_reports`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/all.2014.Volunteer_Report_Export.csv'
	INTO TABLE `e3_reports`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/all.2015.Volunteer_Report_Export.csv'
	INTO TABLE `e3_reports`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/all.2016.Volunteer_Report_Export.csv'
	INTO TABLE `e3_reports`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/all.2017.Volunteer_Report_Export.csv'
	INTO TABLE `e3_reports`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/all.2018.Volunteer_Report_Export.csv'
	INTO TABLE `e3_reports`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/all.2019.Volunteer_Report_Export.csv'
	INTO TABLE `e3_reports`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/all.2020.Volunteer_Report_Export.csv'
	INTO TABLE `e3_reports`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/all.2021.Volunteer_Report_Export.csv'
	INTO TABLE `e3_reports`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  

-- ELSE

-- LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/1.2016.Volunteer_Report_Export.csv'
-- 	INTO TABLE `e3_reports`   
-- 	FIELDS TERMINATED BY ','   
-- 	ENCLOSED BY ''  
-- 	LINES TERMINATED BY '\n'
-- 	IGNORE 1 ROWS;  
-- 
-- LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/1.2017.Volunteer_Report_Export.csv'
-- 	INTO TABLE `e3_reports`   
-- 	FIELDS TERMINATED BY ','   
-- 	ENCLOSED BY ''  
-- 	LINES TERMINATED BY '\n'
-- 	IGNORE 1 ROWS;  
-- 
-- LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/1.2018.Volunteer_Report_Export.csv'
-- 	INTO TABLE `e3_reports`   
-- 	FIELDS TERMINATED BY ','   
-- 	ENCLOSED BY ''  
-- 	LINES TERMINATED BY '\n'
-- 	IGNORE 1 ROWS;  
-- 
-- LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/1.2019.Volunteer_Report_Export.csv'
-- 	INTO TABLE `e3_reports`   
-- 	FIELDS TERMINATED BY ','   
-- 	ENCLOSED BY ''  
-- 	LINES TERMINATED BY '\n'
-- 	IGNORE 1 ROWS;  
-- 
-- LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/all.2020.Volunteer_Report_Export.csv'
-- 	INTO TABLE `e3_reports`   
-- 	FIELDS TERMINATED BY ','   
-- 	ENCLOSED BY ''  
-- 	LINES TERMINATED BY '\n'
-- 	IGNORE 1 ROWS;  
--     
-- LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/1.2021.Volunteer_Report_Export.csv'
-- 	INTO TABLE `e3_reports`   
-- 	FIELDS TERMINATED BY ','   
-- 	ENCLOSED BY ''  
-- 	LINES TERMINATED BY '\n'
-- 	IGNORE 1 ROWS;  
--     
-- END IF;

UPDATE `e3_reports` SET `Zip` = replace(`Zip`,'''','');
DELETE FROM `e3_reports` WHERE `FirstName` = 'Refer to';
DELETE FROM `e3_reports` WHERE `FirstName` LIKE 'Volunteer%';
DELETE FROM `e3_reports` WHERE `LastName` LIKE 'Volunteer%';
DELETE FROM `e3_reports` WHERE `LastName` = 'Test';
DELETE FROM `e3_reports` WHERE `Email` LIKE '%@test.com';
DELETE FROM `e3_reports` WHERE `AYSOID` = '0';
DELETE FROM `e3_reports` WHERE `Section` = '99';

UPDATE `e3_reports` SET `Street` = '' WHERE `Street` = 'Address';
UPDATE `e3_reports` SET `Street` = '' WHERE `Street` = 'Street';
UPDATE `e3_reports` SET `Street` = '' WHERE `Street` = 'sdf';
UPDATE `e3_reports` SET `Street` = '' WHERE `Street` = 'iou';

UPDATE `e3_reports` SET `City` = '' WHERE `City` = 'City';
UPDATE `e3_reports` SET `City` = '' WHERE `City` = 'sdf';
UPDATE `e3_reports` SET `City` = '' WHERE `City` = 'iou';
UPDATE `e3_reports` SET `City` = '' WHERE `City` = 'lkjlkjlkj';

UPDATE `e3_reports` SET `HomePhone` = '' WHERE `HomePhone` = '1234567890';
UPDATE `e3_reports` SET `CellPhone` = '' WHERE `CellPhone` = '1234567890';

ALTER TABLE `e3_reports` 
DROP `Volunteer Position`;

DROP TABLE IF EXISTS `tmp_e3_reports`;

CREATE TABLE `tmp_e3_reports` SELECT * FROM
    (SELECT 
        *,
            @rank:=IF(@id=`AYSOID`, @rank + 1, 1) AS rank,
            @id:=AYSOID
    FROM
        (SELECT 
        *
    FROM
        `e3_reports`
    ORDER BY `MY` DESC) ordered
    GROUP BY `AYSOID`) grouped
WHERE
    `rank` = 1;

ALTER TABLE `tmp_e3_reports` 
DROP `rank`;

ALTER TABLE `tmp_e3_reports` 
DROP `@id:=AYSOID`;

ALTER TABLE `tmp_e3_reports` 
CHANGE COLUMN `AYSOID` `AYSOID` INT(11) NULL DEFAULT NULL FIRST;

DROP TABLE IF EXISTS `e3_reports`;

ALTER TABLE `tmp_e3_reports` 
RENAME TO  `e3_reports`;
    
SELECT 
    *
FROM
    `e3_reports`
ORDER BY `Section`, `Area`, `Region`,`MY`,`AYSOID`;
