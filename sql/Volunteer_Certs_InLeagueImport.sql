USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DROP TABLE IF EXISTS `1.Volunteer_Certs_VolunteerReport_InLeague`;

CREATE TABLE `1.Volunteer_Certs_VolunteerReport_InLeague` (
  `AYSOID` VARCHAR(20),
  `AdminID` VARCHAR(20),
  `Full_Name` text,
  `Type` text,
  `SAR` text,
  `MY` text,
  `Safe_Haven_Date` text,
  `CDC_Date` text,
  `SCA_Date` text,
  `Ref_Cert_Desc` text,
  `Ref_Cert_Date` text,
  `Assessor_Cert_Desc` text,
  `Assessor_Cert_Date` text,
  `Inst_Cert_Desc` text,
  `Inst_Cert_Date` text,
  `Inst_Eval_Cert_Desc` text,
  `Inst_Eval_Cert_Date` text,
  `Coach_Cert_Desc` text,
  `Coach_Cert_Date` text,
  `Data_Source` text,
  `_MY_` text,
  `Section` Text,
  `Area` text,
  `Region` text,
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

CREATE INDEX `idx_1.Volunteer_Certs_VolunteerReport_InLeague_AYSOID`  ON `1.Volunteer_Certs_VolunteerReport_InLeague` (AYSOID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;
CREATE INDEX `idx_1.Volunteer_Certs_VolunteerReport_InLeague_AdminID`  ON `1.Volunteer_Certs_VolunteerReport_InLeague` (AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

LOAD DATA LOCAL INFILE '/Users/rick/Soccer/_data/19-21.Volunteer_Certs_VolunteerReport_InLeague.csv'
	INTO TABLE `1.Volunteer_Certs_VolunteerReport_InLeague`   
	FIELDS TERMINATED BY ','   
	ENCLOSED BY '"'  
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;

ALTER TABLE `1.Volunteer_Certs_VolunteerReport_InLeague` 
CHANGE COLUMN `Section` `Section` TEXT AFTER `SAR`,
CHANGE COLUMN `Area` `Area` TEXT AFTER `Section`,
CHANGE COLUMN `Region` `Region` TEXT AFTER `Area`,
ADD COLUMN `SafeSport_Date` TEXT NULL AFTER `SCA_Date`,
ADD COLUMN `LiveScan_Date` TEXT NULL AFTER `SafeSport_Date`;

UPDATE `1.Volunteer_Certs_VolunteerReport_InLeague` SET `Section` = SPLIT_STRING(`SAR`,'/',1), `Area` = SPLIT_STRING(`SAR`,'/',2), `Region` = ExtractNumber(SPLIT_STRING(`SAR`,'/',3));
    
UPDATE `1.Volunteer_Certs_VolunteerReport_InLeague` SET `Ref_Cert_Desc` = SUBSTRING_INDEX(`Ref_Cert_Desc`,'---',1), `Ref_Cert_Date` = SUBSTRING_INDEX(`Ref_Cert_Date`,'---',1);

UPDATE `1.Volunteer_Certs_VolunteerReport_InLeague` SET `Ref_Cert_Desc` = '8U Official' WHERE `Ref_Cert_Desc` = 'U-8 Official';
UPDATE `1.Volunteer_Certs_VolunteerReport_InLeague` SET `Ref_Cert_Desc` = '8U Official' WHERE `Ref_Cert_Desc` = 'Z-Online 8U Official';

UPDATE `1.Volunteer_Certs_VolunteerReport_InLeague` SET `Ref_Cert_Desc` = 'Regional Referee' WHERE `Ref_Cert_Desc` = 'Regional Referee & Safe Haven Referee';
UPDATE `1.Volunteer_Certs_VolunteerReport_InLeague` SET `Ref_Cert_Desc` = 'Regional Referee' WHERE `Ref_Cert_Desc` = 'Z-Online Regional Referee Without Safe Haven' AND `Safe_Haven_Date` <> '';
UPDATE `1.Volunteer_Certs_VolunteerReport_InLeague` SET `Ref_Cert_Desc` = '' WHERE `Ref_Cert_Desc` = 'Z-Online Regional Referee Without Safe Haven' AND `Safe_Haven_Date` = '';
UPDATE `1.Volunteer_Certs_VolunteerReport_InLeague` SET `Ref_Cert_Desc` = 'Regional Referee' WHERE `Ref_Cert_Desc` = 'Regional Referee & Safe Haven Referee';
UPDATE `1.Volunteer_Certs_VolunteerReport_InLeague` SET `Ref_Cert_Desc` = '' WHERE `Ref_Cert_Desc` LIKE '%Course';

UPDATE `1.Volunteer_Certs_VolunteerReport_InLeague` c SET `DOB` = str_to_date(`DOB`, '%m/%d/%Y') WHERE `DOB` <> '';

DELETE FROM `1.Volunteer_Certs_VolunteerReport_InLeague` WHERE `Ref_Cert_Desc` = '';

SELECT 
    *
FROM
    `1.Volunteer_Certs_VolunteerReport_InLeague`;
