USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DROP TABLE IF EXISTS `1.upgradesInProgress`;

CREATE TEMPORARY TABLE `1.upgradesInProgress` (
  `First_Name` text,
  `Last_Name` text,
  `AdminID` VARCHAR(100),
  `Email` text,
  `Region` text,
  `Training` text,
  `TrainingStatus` text,
  `TrainingDate` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOAD DATA LOCAL INFILE '/Users/rick/.CMVolumes/ayso1sra/s1/reports/__sports_connect_reports/_eTrainU_Reports/NationalReferee.TrainingStatusReport.csv'
	INTO TABLE `1.upgradesInProgress`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/.CMVolumes/ayso1sra/s1/reports/__sports_connect_reports/_eTrainU_Reports/AdvancedReferee.TrainingStatusReport.csv'
	INTO TABLE `1.upgradesInProgress`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/.CMVolumes/ayso1sra/s1/reports/__sports_connect_reports/_eTrainU_Reports/IntermediateReferee.TrainingStatusReport.csv'
	INTO TABLE `1.upgradesInProgress`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/.CMVolumes/ayso1sra/s1/reports/__sports_connect_reports/_eTrainU_Reports/RegionalRefereeInstructor.TrainingStatusReport.csv'
	INTO TABLE `1.upgradesInProgress`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/.CMVolumes/ayso1sra/s1/reports/__sports_connect_reports/_eTrainU_Reports/AdvancedRefereeInstructor.TrainingStatusReport.csv'
	INTO TABLE `1.upgradesInProgress`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/.CMVolumes/ayso1sra/s1/reports/__sports_connect_reports/_eTrainU_Reports/RefereeInstructorEvaluator.TrainingStatusReport.csv'
	INTO TABLE `1.upgradesInProgress`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/.CMVolumes/ayso1sra/s1/reports/__sports_connect_reports/_eTrainU_Reports/RefereeAssessor.TrainingStatusReport.csv'
	INTO TABLE `1.upgradesInProgress`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
LOAD DATA LOCAL INFILE '/Users/rick/.CMVolumes/ayso1sra/s1/reports/__sports_connect_reports/_eTrainU_Reports/NationalRefereeAssessor.TrainingStatusReport.csv'
	INTO TABLE `1.upgradesInProgress`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;  
    
ALTER TABLE `1.upgradesInProgress` 
CHANGE COLUMN `AdminID` `AdminID` VARCHAR(100) NULL DEFAULT NULL FIRST,
DROP COLUMN `Region`,
DROP COLUMN `Email`;

CREATE INDEX `idx_1.upgradesInProgress`  ON `1.upgradesInProgress` (AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

UPDATE `1.upgradesInProgress` SET `AdminID` = MID(`AdminID`, 6, 12);
UPDATE `1.upgradesInProgress` SET `First_Name` = PROPER_CASE(`First_Name`);
UPDATE `1.upgradesInProgress` SET `Last_Name` = PROPER_CASE(`Last_Name`);
UPDATE `1.upgradesInProgress` SET `TrainingDate` = format_date(`TrainingDate`);
UPDATE `1.upgradesInProgress` SET `Training` = TRIM(`Training`);

-- Noah Gallo / 1/D/17 Youth
DELETE FROM `1.upgradesInProgress` WHERE `AdminID` = '55842-664119' AND NOT `Training` LIKE '%Intermediate Referee%';

UPDATE `1.upgradesInProgress` SET `Training` = 'National Referee Course' WHERE `Training` LIKE '%National Referee Course';
UPDATE `1.upgradesInProgress` SET `Training` = 'Advanced Referee Course' WHERE `Training` LIKE '%Advanced Referee Training';
UPDATE `1.upgradesInProgress` SET `Training` = 'Intermediate Referee Course' WHERE `Training` LIKE '%Intermediate Referee';
UPDATE `1.upgradesInProgress` SET `Training` = 'Referee Instructor Course' WHERE `Training` LIKE '%Referee Instructor Course';
UPDATE `1.upgradesInProgress` SET `Training` = 'Advanced Referee Instructor Course' WHERE `Training` LIKE '%Advanced Referee Instructor Course';
UPDATE `1.upgradesInProgress` SET `Training` = 'Referee Instructor Evaluator Course' WHERE `Training` LIKE '%Referee Instructor Evaluator Course%';
UPDATE `1.upgradesInProgress` SET `Training` = 'National Referee Assessor Course' WHERE `Training` LIKE '%National Referee Assessor';
UPDATE `1.upgradesInProgress` SET `Training` = 'Referee Assessor Course' WHERE `Training` LIKE '%Referee Assessor Course';

INSERT INTO `1.upgradesInProgress` SELECT `AdminID`,
	`First Name` AS `First_Name`,
    `Last Name` AS `Last_Name`,
    `CertificationDesc` AS `Training`,
    '' AS `TrainingStatus`,
    `CertDate` AS `TrainingDate`
FROM `1.RefUpgradeCandidates.20220822`
WHERE `AYSOID` <> '';

DROP TABLE IF EXISTS `tmp_ref_upgrades`;

CREATE TEMPORARY TABLE `tmp_ref_upgrades` SELECT 
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
    AND NOT ref.`CertificationDesc` LIKE '8U%'
    AND (
		(`Training` = 'Intermediate Referee Course' AND ref.`CertificationDesc` = 'Regional Referee')
		OR (`Training` = 'Advanced Referee Course' AND ref.`CertificationDesc` = 'Intermediate Referee')
        OR (`Training` = 'National Referee Course' AND ref.`CertificationDesc` = 'Advanced Referee')
		OR (`Training` = 'Referee Instructor Course' AND ref.`CertificationDesc` IN ('Intermediate Referee', 'Advanced Referee', 'National Referee') AND  ri.`CertificationDesc` IS NULL)
		OR (`Training` = 'Advanced Referee Instructor Course' AND ref.`CertificationDesc` IN ('Advanced Referee', 'National Referee') AND ri.`CertificationDesc` = 'Intermediate Referee Instructor')
		OR (`Training` = 'Referee Instructor Evaluator Course' AND ref.`CertificationDesc` IN ('Advanced Referee', 'National Referee') AND ri.`CertificationDesc` = 'Advanced Referee Instructor' AND rie.`CertificationDesc` IS NULL)
		OR (`Training` = 'Referee Assessor Course' AND ref.`CertificationDesc` IN ('Advanced Referee', 'National Referee') AND NOT ra.`CertificationDesc` IN ('National Referee Assessor', 'Referee Assessor'))
		OR (`Training` = 'National Referee Assessor Course' AND ref.`CertificationDesc` IN ('National Referee') AND NOT ra.`CertificationDesc` = 'National Referee Assessor')
	);
        
DROP TABLE IF EXISTS `crs_rpt_ref_upgrades`;

CREATE TABLE `crs_rpt_ref_upgrades` SELECT DISTINCT * FROM
    `tmp_ref_upgrades`;    
        
SELECT 
    *
FROM
    `crs_rpt_ref_upgrades`
ORDER BY LEFT(`SAR`,3) , FIELD(`Training`,
        'National Referee Course',
        'Advanced Referee Course',
        'Intermediate Referee Course',
        'Referee Instructor Course',
        'Advanced Referee Instructor Course',
        'Referee Instructor Evaluator Course',
        'National Referee Assessor Course',
        'Referee Assessor Course',
        '') , `Last_Name` , `TrainingDate`;     