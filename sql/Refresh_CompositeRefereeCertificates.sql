USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DROP TABLE IF EXISTS `1.CompositeRefereeCertificates`;

CREATE TABLE `1.CompositeRefereeCertificates` SELECT * FROM
    `1.AdminLicenseGradeRefereeHighest`;
    
CREATE INDEX `idx_1.CompositeRefereeCertificates_AdminID`  ON `1.CompositeRefereeCertificates` (AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;
CREATE INDEX `idx_1.CompositeRefereeCertificates_AYSOID_AdminID_Email`  ON `1.CompositeRefereeCertificates` (AYSOID, AdminID, Email) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

ALTER TABLE `1.CompositeRefereeCertificates` 
ADD COLUMN `SAR` TEXT NULL AFTER `MY`,
-- ADD COLUMN `Address` TEXT NULL AFTER `Last_Name`,
ADD COLUMN `City` TEXT NULL AFTER `Last_Name`,
ADD COLUMN `State` TEXT NULL AFTER `City`,
ADD COLUMN `Zipcode` TEXT NULL AFTER `State`,
ADD COLUMN `Cell_Phone` TEXT NULL AFTER `Zipcode`;

UPDATE `1.CompositeRefereeCertificates` c SET `SAR` = `Section`;
UPDATE `1.CompositeRefereeCertificates` c SET `SAR` = CONCAT(`SAR`, '/' , `Area`) WHERE NOT `Area` = '';
UPDATE `1.CompositeRefereeCertificates` c SET `SAR` = CONCAT(`SAR`, '/', `Region`) WHERE NOT `Region` = '';

UPDATE `1.CompositeRefereeCertificates` c
        INNER JOIN
    `1.AdminInfo` ai ON c.`AdminID` = ai.`AdminID` 
SET 
--     c.`Address` = ai.`Address`,
    c.`City` = ai.`City`,
    c.`State` = STATE(ai.`PostalCode`),
    c.`Zipcode` = IF(LENGTH(ai.`PostalCode`)>5,CONCAT(LEFT(ai.`PostalCode`, 5),"-",RIGHT(ai.`PostalCode`, 4)),ai.`PostalCode`);

UPDATE `1.CompositeRefereeCertificates` c
        INNER JOIN
    `1.VolunteerReportExport` vre ON c.`AYSOID` = vre.`AYSOID` 
SET 
    c.`Cell_Phone` = vre.`CellPhone`;
    
DROP TABLE IF EXISTS `tmp_sh_cert`;
CREATE TEMPORARY TABLE `tmp_sh_cert` SELECT DISTINCT `AdminID`, `AYSOID`, `CertificateName`, `CertificateDate` FROM
    `1.AdminCredentialsStatusDynamic`
WHERE
    `1.AdminCredentialsStatusDynamic`.`CertificateName` LIKE '%Safe Haven';
CREATE INDEX `idx_tmp_sh_cert_AdminID`  ON `tmp_sh_cert` (AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

DROP TABLE IF EXISTS `tmp_cdc_cert`;
CREATE TEMPORARY TABLE `tmp_cdc_cert` SELECT DISTINCT `AdminID`, `AYSOID`, `CertificateName`, `CertificateDate` FROM
    `1.AdminCredentialsStatusDynamic`
WHERE
    `1.AdminCredentialsStatusDynamic`.`CertificateName` LIKE '%Concussion%';
CREATE INDEX `idx_tmp_cdc_cert_AdminID`  ON `tmp_cdc_cert` (AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

DROP TEMPORARY TABLE IF EXISTS `tmp_sca_cert`;
CREATE TEMPORARY TABLE `tmp_sca_cert` SELECT DISTINCT `AdminID`, `AYSOID`, `CertificateName`, `CertificateDate` FROM
    `1.AdminCredentialsStatusDynamic`
WHERE
    `1.AdminCredentialsStatusDynamic`.`CertificateName` LIKE '%Cardiac%';
CREATE INDEX `idx_tmp_sca_cert_AdminID`  ON `tmp_sca_cert` (AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

DROP TABLE IF EXISTS `tmp_ss_cert`;
CREATE  TABLE `tmp_ss_cert` SELECT DISTINCT `AdminID`, `AYSOID`, `CertificateName`, `CertificateDate`, `SafeSportExpireDate` FROM
    `1.AdminCredentialsStatusDynamic`
WHERE
    `1.AdminCredentialsStatusDynamic`.`CertificateName` LIKE '%SafeSport%';
CREATE INDEX `idx_tmp_ss_cert_AdminID`  ON `tmp_ss_cert` (AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

DROP TABLE IF EXISTS `tmp_ls_cert`;
CREATE TEMPORARY TABLE `tmp_ls_cert` SELECT DISTINCT `AdminID`, `AYSOID`, `CertificateName`, `CertificateDate` FROM
    `1.AdminCredentialsStatusDynamic`
WHERE
    `1.AdminCredentialsStatusDynamic`.`CertificateName` LIKE '%Fingerprinting';
CREATE INDEX `idx_tmp_ls_cert_AdminID`  ON `tmp_ls_cert` (AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

DROP TABLE IF EXISTS `tmp_risk_cert`;
CREATE TEMPORARY TABLE `tmp_risk_cert` SELECT DISTINCT `AdminID`, `AYSOID`, `RiskStatus` AS `CertificateName`, `RiskExpireDate` AS `CertificateDate` FROM
    `1.AdminCredentialsStatusDynamic`;
CREATE INDEX `idx_tmp_risk_cert_AdminID`  ON .`tmp_risk_cert` (AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

UPDATE `1.CompositeRefereeCertificates`  SET `CertificationDesc` = '8U Official' WHERE `CertificationDesc` LIKE 'U-8 Official%';

DROP TABLE IF EXISTS `crs_rpt_ref_certs`;

CREATE TABLE `crs_rpt_ref_certs` SELECT 
    c.*,
    IFNULL(sh.`CertificateDate`,'') AS `Safe_Haven_Date`,
    IFNULL(cdc.`CertificateDate`,'') AS `Concussion_Awareness_Date`,
    IFNULL(sca.`CertificateDate`,'') AS `Sudden_Cardiac_Arrest_Date`,
    IFNULL(ls.`CertificateDate`,'') AS `LiveScan_Date`,
    IF(ISNULL(ss.`CertificateDate`), '', IF(format_date(ss.`SafeSportExpireDate`) >= NOW(), ss.`CertificateDate`, 'Expired')) AS `SafeSport_Date`,
    IF(ISNULL(ss.`SafeSportExpireDate`), '', format_date(ss.`SafeSportExpireDate`)) AS `SafeSport_Expire_Date`,
    IFNULL(risk.`CertificateName`,'') AS `Risk_Status`,
    IFNULL(risk.`CertificateDate`,'') AS `Risk_Expire_Date`
FROM
    `1.CompositeRefereeCertificates` c
        LEFT JOIN
    `tmp_sh_cert` sh ON c.`AdminID` = sh.`AdminID`
        LEFT JOIN
    `tmp_cdc_cert` cdc ON c.`AdminID` = cdc.`AdminID`
        LEFT JOIN
    `tmp_sca_cert` sca ON c.`AdminID` = sca.`AdminID`
        LEFT JOIN
    `tmp_ss_cert` ss ON c.`AdminID` = ss.`AdminID`
        LEFT JOIN
    `tmp_ls_cert` ls ON c.`AdminID` = ls.`AdminID`
        LEFT JOIN
    `tmp_risk_cert` risk ON c.`AdminID` = risk.`AdminID`
ORDER BY `MY` DESC;

UPDATE `crs_rpt_ref_certs` crs
        INNER JOIN
    `1.Volunteer_Certs_VolunteerReport_InLeague` vc ON crs.`AYSOID` = vc.`AYSOID` AND crs.`AdminID` = ''
SET 
    crs.`Safe_Haven_Date` = vc.`Safe_Haven_Date`,
    crs.`Concussion_Awareness_Date` = vc.`CDC_Date`,
    crs.`Sudden_Cardiac_Arrest_Date` = vc.`SCA_Date`,
    crs.`SafeSport_Date` = vc.`SafeSport_Date`,
    crs.`LiveScan_Date` = vc.`LiveScan_Date`,
	crs.`Risk_Status` = 'InLeague',
	crs.`Risk_Expire_Date`  = CONCAT(CAST(RIGHT(vc.`MY`,4) AS UNSIGNED) + 1, '-07-31');
    
UPDATE `crs_rpt_ref_certs` SET `SAR` = REPLACE(`SAR`, '/0','/');
UPDATE `crs_rpt_ref_certs` SET `SAR` = REPLACE(`SAR`, '/0','/');
UPDATE `crs_rpt_ref_certs` SET `SAR` = REPLACE(`SAR`, '/0','/');
/* fix Matthew Gonzalez-Valenzuela */
UPDATE `crs_rpt_ref_certs` SET `CertificationDesc`='Intermediate Referee', `CertificationDate`='2022-02-22' WHERE AdminID='69526-398429';
/* fix Richard Bronshvag */
UPDATE `crs_rpt_ref_certs` SET `AYSOID` = '69026725' WHERE `AdminID` = '52423-428440';
/* rename Rick Roberts */
UPDATE `crs_rpt_ref_certs` SET `First_Name` = 'Rick' WHERE `AdminID` = '27134-804043';
/* end fixes */

-- Update Tables for Referee Scheduler
DROP TABLE IF EXISTS `rs_refs`;
CREATE TABLE `rs_refs` SELECT * FROM
    `crs_rpt_ref_certs`;
ALTER TABLE `rs_refs` ADD INDEX (`AdminID`);

ALTER TABLE `rs_refs` 
ADD COLUMN `Name` TEXT NULL AFTER `Region`;

UPDATE `rs_refs` SET `Name` = CONCAT(`First_Name`, ' ', `Last_Name`); 

/* fix Nate Nguyen */
UPDATE `rs_refs` SET AYSOID = '66584088' WHERE AYSOID = '203000005';
/* end fixes */

DROP TABLE IF EXISTS tmp_refUpdate;
CREATE TEMPORARY TABLE tmp_refUpdate SELECT 
	*
FROM
	(SELECT 
		r.*
	FROM
		rs_refs r
	LEFT JOIN `rs_refNicknames` n ON r.AdminID = n.AdminID
	WHERE
		n.AdminID IS NULL) new;
				
INSERT INTO `rs_refNicknames` (`AdminID`, `AYSOID`, `Name`, `Nickname`)
SELECT DISTINCT `AdminID`, `AYSOID`, `Name`, `Name` FROM tmp_refUpdate;

/* remove duplicates from `rs_refNicknames` */
DROP TABLE IF EXISTS tmp_refNicknames;
CREATE TABLE tmp_refNicknames SELECT DISTINCT `AdminID`, `AYSOID`, `Name`, `Nickname` FROM `rs_refNicknames`;

TRUNCATE TABLE `rs_refNicknames`;
ALTER TABLE `rs_refNicknames` AUTO_INCREMENT=0;
INSERT INTO `rs_refNicknames` (`AdminID`, `AYSOID`, `Name`, `Nickname`)
SELECT `AdminID`, `AYSOID`, `Name`, `Nickname` FROM tmp_refNicknames;
DROP TABLE IF EXISTS tmp_refNicknames;
/* end remove */

-- Update timestamp table  
SET time_zone='+00:00';
DROP TABLE IF EXISTS `crs_rpt_lastUpdate`;  
CREATE TABLE `crs_rpt_lastUpdate` SELECT NOW() AS timestamp;
ALTER TABLE crs_rpt_lastUpdate
CHANGE COLUMN `timestamp` `timestamp` DATETIME NOT NULL DEFAULT '1901-01-01 00:00:00' ;
ALTER TABLE crs_rpt_lastUpdate ADD UNIQUE (`timestamp`);

ALTER TABLE `crs_rpt_ref_certs`
DROP COLUMN `AYSOID`;
        
SELECT 
    *, HealthSafetyComplete(`Safe_Haven_Date`,`Concussion_Awareness_Date`,`Sudden_Cardiac_Arrest_Date`,`SafeSport_Date`,`Risk_Status`) AS 'Health & Safety'
FROM
    `crs_rpt_ref_certs`
WHERE `MY` >= 'MY2020';

CALL `RefreshRefereeInstructors`('MY2024');

CALL `RefreshRefereeInstructorEvaluators`('MY2024');

CALL `RefreshRefereeAssessors`('MY2024');

CALL `RefreshRefereeSafeSportExpiration`();
