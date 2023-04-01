USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DROP TABLE IF EXISTS `1.upgradesInProgress`;

CREATE TABLE `1.upgradesInProgress` (
  `First_Name` text,
  `Last_Name` text,
  `AdminID` VARCHAR(100),
  `Training` text,
  `TrainingStatus` text,
  `AccessDate` text,
  `TrainingDate` text,
  `Course Expiry Date` text,
  `AccreditationExpiryDate` text,
  `Progress` text,
  `Email` text,
  `Region` text  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOAD DATA LOCAL INFILE '/Users/rick/.CMVolumes/ayso1sra/s1/reports/__sports_connect_reports/_eTrainU_Reports/1B.TrainingStatusReport.csv'
	INTO TABLE `1.upgradesInProgress`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/.CMVolumes/ayso1sra/s1/reports/__sports_connect_reports/_eTrainU_Reports/1C.TrainingStatusReport.csv'
	INTO TABLE `1.upgradesInProgress`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/.CMVolumes/ayso1sra/s1/reports/__sports_connect_reports/_eTrainU_Reports/1D.TrainingStatusReport.csv'
	INTO TABLE `1.upgradesInProgress`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/.CMVolumes/ayso1sra/s1/reports/__sports_connect_reports/_eTrainU_Reports/1F.TrainingStatusReport.csv'
	INTO TABLE `1.upgradesInProgress`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/.CMVolumes/ayso1sra/s1/reports/__sports_connect_reports/_eTrainU_Reports/1G.TrainingStatusReport.csv'
	INTO TABLE `1.upgradesInProgress`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/.CMVolumes/ayso1sra/s1/reports/__sports_connect_reports/_eTrainU_Reports/1H.TrainingStatusReport.csv'
	INTO TABLE `1.upgradesInProgress`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/.CMVolumes/ayso1sra/s1/reports/__sports_connect_reports/_eTrainU_Reports/1N.TrainingStatusReport.csv'
	INTO TABLE `1.upgradesInProgress`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/.CMVolumes/ayso1sra/s1/reports/__sports_connect_reports/_eTrainU_Reports/1P.TrainingStatusReport.csv'
	INTO TABLE `1.upgradesInProgress`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/.CMVolumes/ayso1sra/s1/reports/__sports_connect_reports/_eTrainU_Reports/1R.TrainingStatusReport.csv'
	INTO TABLE `1.upgradesInProgress`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/.CMVolumes/ayso1sra/s1/reports/__sports_connect_reports/_eTrainU_Reports/1S.TrainingStatusReport.csv'
	INTO TABLE `1.upgradesInProgress`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/.CMVolumes/ayso1sra/s1/reports/__sports_connect_reports/_eTrainU_Reports/1U.TrainingStatusReport.csv'
	INTO TABLE `1.upgradesInProgress`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
ALTER TABLE `1.upgradesInProgress` 
CHANGE COLUMN `AdminID` `AdminID` VARCHAR(100) NULL DEFAULT NULL FIRST,
DROP COLUMN `Course Expiry Date`,
DROP COLUMN `AccreditationExpiryDate`,
DROP COLUMN `Progress`,
DROP COLUMN `Email`,
DROP COLUMN `Region`;

CREATE INDEX `idx_1.upgradesInProgress`  ON `1.upgradesInProgress` (AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

UPDATE `1.upgradesInProgress` SET `AdminID` = MID(`AdminID`, 6, 12);
UPDATE `1.upgradesInProgress` SET `First_Name` = PROPER_CASE(`First_Name`);
UPDATE `1.upgradesInProgress` SET `Last_Name` = PROPER_CASE(`Last_Name`);
UPDATE `1.upgradesInProgress` SET `AccessDate` = format_date(LEFT(`AccessDate`,10));
UPDATE `1.upgradesInProgress` SET `TrainingDate` = format_date(LEFT(`TrainingDate`,10));
UPDATE `1.upgradesInProgress` SET `Training` = TRIM(`Training`);

-- Noah Gallo / 1/D/17 Youth
DELETE FROM `1.upgradesInProgress` WHERE `AdminID` = '55842-664119' AND NOT `Training` LIKE '%Intermediate Referee%';

UPDATE `1.upgradesInProgress` SET `Training` = 'National Referee Course' WHERE `Training` LIKE '%National Referee Course%';
UPDATE `1.upgradesInProgress` SET `Training` = 'Advanced Referee Course' WHERE `Training` LIKE '%Advanced Referee Training%';
UPDATE `1.upgradesInProgress` SET `Training` = 'Intermediate Referee Course' WHERE `Training` LIKE '%Intermediate Referee%';
UPDATE `1.upgradesInProgress` SET `Training` = 'Advanced Referee Instructor Course' WHERE `Training` LIKE '%Advanced Referee Instructor Course%';
UPDATE `1.upgradesInProgress` SET `Training` = 'Intermediate Referee Instructor Course' WHERE `Training` LIKE '%Intermediate Referee Instructor Course%';
UPDATE `1.upgradesInProgress` SET `Training` = 'Regional Referee Instructor Course' WHERE `Training` LIKE '%Regional Referee Instructor%';
UPDATE `1.upgradesInProgress` SET `Training` = 'Referee Instructor Evaluator Course' WHERE `Training` LIKE '%Referee Instructor Evaluator Course%';
UPDATE `1.upgradesInProgress` SET `Training` = 'National Referee Assessor Course' WHERE `Training` LIKE '%National Referee Assessor%';
UPDATE `1.upgradesInProgress` SET `Training` = 'Referee Assessor Course' WHERE `Training` LIKE '%Referee Assessor Course%';

DELETE FROM `1.upgradesInProgress` WHERE `TrainingStatus` = 'COMPLETE';

INSERT INTO `1.upgradesInProgress` SELECT `AdminID`,
	`First Name` AS `First_Name`,
    `Last Name` AS `Last_Name`,
    `Training`,
    '' AS `TrainingStatus`,
    '' AS `AccessDate`,
    `TrainingDate`
FROM `1.RefUpgradeCandidates.20220822`
WHERE `AYSOID` <> '';

DROP TABLE IF EXISTS `tmp_ref_upgrades`;

CREATE  TABLE `tmp_ref_upgrades` SELECT 
    ref.`AdminID`,
    ref.`AYSOID`,
    ref.`MY`,
    ref.`SAR`,
    ref.`Section`,
    ref.`Area`,
    ref.`Region`,
    ref.`First_Name`,
    ref.`Last_Name`,
    ref.`DOB`,
    ref.`Gender`,
    ref.`Email`,
    `Training`,
    `AccessDate`,
    `TrainingDate`,
    ref.`CertificationDesc` AS `RefereeCert`,
    ref.`CertificationDate` AS `RefereeDate`,
	ri.`CertificationDesc` AS `InstructorCert`,
	ri.`CertificationDate` AS `InstructorDate`,
	rie.`CertificationDesc`AS `EvaluatorCert`,
	rie.`CertificationDate`AS `EvaluatorDate`,
	ra.`CertificationDesc` AS `AssessorCert`,
	ra.`CertificationDate` AS `AssessorDate`
FROM
    `1.upgradesInProgress` up 
        LEFT JOIN
    `crs_rpt_ref_certs` ref ON ref.`AdminID` = up.`AdminID`
        LEFT JOIN
	`crs_rpt_ri` ri ON ri.`AdminID` = up.`AdminID`
        LEFT JOIN
	`crs_rpt_rie` rie ON rie.`AdminID` = up.`AdminID`
        LEFT JOIN
	`crs_rpt_ra` ra ON ra.`AdminID` = up.`AdminID`
WHERE
	NOT `Training` IS NULL 
--     AND NOT `TrainingDate` = ""
    AND NOT ref.`CertificationDesc` LIKE '8U%'
--  	AND `AccessDate` >= DATE_SUB(NOW(), INTERVAL 8 YEAR)
	AND ref.`MY` >= CONCAT('MY', YEAR(DATE_SUB(NOW(), INTERVAL 4 YEAR)))
    AND (
		(`Training` = 'Intermediate Referee Course' AND ref.`CertificationDesc` = 'Regional Referee')
		OR (`Training` = 'Advanced Referee Course' AND ref.`CertificationDesc` = 'Intermediate Referee')
        OR (`Training` = 'National Referee Course' AND ref.`CertificationDesc` = 'Advanced Referee')
		OR (`Training` = 'Regional Referee Instructor Course' AND ref.`CertificationDesc` IN ('Intermediate Referee', 'Advanced Referee', 'National Referee') AND  ri.`CertificationDesc` IS NULL)
		OR (`Training` = 'Intermediate Referee Instructor Course' AND ref.`CertificationDesc` IN ('Intermediate Referee', 'Advanced Referee', 'National Referee') AND  ri.`CertificationDesc` IS NULL)
		OR (`Training` = 'Advanced Referee Instructor Course' AND ref.`CertificationDesc` IN ('Advanced Referee', 'National Referee') AND ri.`CertificationDesc` = 'Intermediate Referee Instructor')
		OR (`Training` = 'Referee Instructor Evaluator Course' AND ref.`CertificationDesc` IN ('Advanced Referee', 'National Referee') AND ri.`CertificationDesc` = 'Advanced Referee Instructor' AND rie.`CertificationDesc` IS NULL)
		OR (`Training` = 'Referee Assessor Course' AND ref.`CertificationDesc` IN ('Advanced Referee', 'National Referee') AND NOT ra.`CertificationDesc` IN ('National Referee Assessor', 'Referee Assessor'))
		OR (`Training` = 'National Referee Assessor Course' AND ref.`CertificationDesc` IN ('National Referee') AND NOT ra.`CertificationDesc` = 'National Referee Assessor')
	);
        
DROP TABLE IF EXISTS `crs_rpt_ref_upgrades`;

CREATE TABLE `crs_rpt_ref_upgrades` SELECT DISTINCT * FROM
    `tmp_ref_upgrades`
WHERE `Section` = 1;    
        
SELECT 
    *
FROM
    `crs_rpt_ref_upgrades`
ORDER BY LEFT(`SAR`,3), `Region`, FIELD(`Training`,
        'National Referee Course',
        'Advanced Referee Course',
        'Intermediate Referee Course',
        'Advanced Referee Instructor Course',
        'Intermediate Referee Instructor Course',
        'Regional Referee Instructor Course',
        'Referee Instructor Evaluator Course',
        'National Referee Assessor Course',
        'Referee Assessor Course',
        ''),  `Last_Name` , `TrainingDate`;     