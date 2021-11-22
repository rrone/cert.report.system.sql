USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DROP TABLE IF EXISTS `1.ROCC_AYSOU_Learning_Folder`;

CREATE TABLE `1.ROCC_AYSOU_Learning_Folder` (
  `UserName` varchar(255),
  `Completion` text,
  `CompletionDate` text,
  `Success` text,
  `Score` text,
  `LastAttempt` text,
  `LearningElements` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX `idx_1.ROCC_AYSOU_Learning_Folder_UserName`  ON `ayso1ref_services`.`1.ROCC_AYSOU_Learning_Folder` (UserName) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

LOAD DATA LOCAL INFILE '/Users/rick/Google_Drive.ayso1sra/s1/reports/_data/ROCC.Learning_Folder_with_Learner_Detail.csv'
	INTO TABLE `1.ROCC_AYSOU_Learning_Folder`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;

