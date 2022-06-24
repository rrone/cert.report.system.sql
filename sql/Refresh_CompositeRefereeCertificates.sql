USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DROP TABLE IF EXISTS `1.CompositeRefereeCertificates`;

CREATE TABLE `1.CompositeRefereeCertificates` SELECT * FROM
    `1.AdminLicenseGradeRefereeHighest`;
    
CREATE INDEX `idx_1.CompositeRefereeCertificates_AdminID`  ON `1.CompositeRefereeCertificates` (AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;
CREATE INDEX `idx_1.CompositeRefereeCertificates_AYSOID_AdminID_Email`  ON `1.CompositeRefereeCertificates` (AYSOID, AdminID, Email) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

ALTER TABLE `1.CompositeRefereeCertificates` 
ADD COLUMN `SAR` TEXT NULL AFTER `MY`,
ADD COLUMN `Address` TEXT NULL AFTER `Last_Name`,
ADD COLUMN `City` TEXT NULL AFTER `Address`,
ADD COLUMN `State` TEXT NULL AFTER `City`,
ADD COLUMN `Zipcode` TEXT NULL AFTER `State`,
ADD COLUMN `Cell_Phone` TEXT NULL AFTER `Zipcode`;

UPDATE `1.CompositeRefereeCertificates` c SET `SAR` = `Section`;
UPDATE `1.CompositeRefereeCertificates` c SET `SAR` = CONCAT(`SAR`, '/' , `Area`) WHERE NOT `Area` = '';
UPDATE `1.CompositeRefereeCertificates` c SET `SAR` = CONCAT(`SAR`, '/', `Region`) WHERE NOT `Region` = '';

UPDATE `1.CompositeRefereeCertificates` c
        INNER JOIN
    `1.VolunteerReportExport` vre ON c.`AYSOID` = vre.`AYSOID` 
SET 
    c.`Address` = vre.`Street`,
    c.`City` = vre.`City`,
    c.`State` = vre.`State`,
    c.`Zipcode` = vre.`Zip`,
    c.`Cell_Phone` = vre.`CellPhone`;
    
UPDATE `1.CompositeRefereeCertificates` c
        INNER JOIN
    `1.Volunteer_Contact_Information` vci ON c.`Email` = vci.`Email` 
SET 
    c.`Address` = vci.`Address`,
    c.`City` = vci.`City`,
    c.`State` = vci.`State`,
    c.`Zipcode` = vci.`Zip_Code`,
    c.`Cell_Phone` = vci.`Cell_Phone`;
    
DROP TABLE IF EXISTS `tmp_sh_cert`;
CREATE TEMPORARY TABLE `tmp_sh_cert` SELECT DISTINCT `AYSOID`, `AdminID`, `CertificateName`, `CertificateDate` FROM
    `1.AdminCredentialsStatusDynamic`
WHERE
    `1.AdminCredentialsStatusDynamic`.`CertificateName` LIKE '%Safe Haven';
CREATE INDEX `idx_tmp_sh_cert_AdminID`  ON `tmp_sh_cert` (AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

DROP TABLE IF EXISTS `tmp_cdc_cert`;
CREATE TEMPORARY TABLE `tmp_cdc_cert` SELECT DISTINCT `AYSOID`, `AdminID`, `CertificateName`, `CertificateDate` FROM
    `1.AdminCredentialsStatusDynamic`
WHERE
    `1.AdminCredentialsStatusDynamic`.`CertificateName` LIKE '%Concussion%';
CREATE INDEX `idx_tmp_cdc_cert_AdminID`  ON `tmp_cdc_cert` (AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

DROP TABLE IF EXISTS `tmp_sca_cert`;
CREATE TEMPORARY TABLE `tmp_sca_cert` SELECT DISTINCT `AYSOID`, `AdminID`, `CertificateName`, `CertificateDate` FROM
    `1.AdminCredentialsStatusDynamic`
WHERE
    `1.AdminCredentialsStatusDynamic`.`CertificateName` LIKE '%Cardiac%';
CREATE INDEX `idx_tmp_sca_cert_AdminID`  ON `tmp_sca_cert` (AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

DROP TABLE IF EXISTS `tmp_ss_cert`;
CREATE TEMPORARY TABLE `tmp_ss_cert` SELECT DISTINCT `AYSOID`, `AdminID`, `CertificateName`, `CertificateDate` FROM
    `1.AdminCredentialsStatusDynamic`
WHERE
    `1.AdminCredentialsStatusDynamic`.`CertificateName` LIKE '%SafeSport%';
CREATE INDEX `idx_tmp_ss_cert_AdminID`  ON `tmp_ss_cert` (AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

DROP TABLE IF EXISTS `tmp_ls_cert`;
CREATE TEMPORARY TABLE `tmp_ls_cert` SELECT DISTINCT `AYSOID`, `AdminID`, `CertificateName`, `CertificateDate` FROM
    `1.AdminCredentialsStatusDynamic`
WHERE
    `1.AdminCredentialsStatusDynamic`.`CertificateName` LIKE '%Fingerprinting';
CREATE INDEX `idx_tmp_ls_cert_AdminID`  ON `tmp_ls_cert` (AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

DROP TABLE IF EXISTS `tmp_risk_cert`;
CREATE TEMPORARY TABLE `tmp_risk_cert` SELECT DISTINCT `AYSOID`, `AdminID`, `RiskStatus` AS `CertificateName`, `RiskExpireDate` AS `CertificateDate` FROM
    `1.AdminCredentialsStatusDynamic`;
CREATE INDEX `idx_tmp_risk_cert_AdminID`  ON .`tmp_risk_cert` (AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

UPDATE `1.CompositeRefereeCertificates`  SET `CertificationDesc` = '8U Official' WHERE `CertificationDesc` LIKE 'U-8 Official%';

DROP TABLE IF EXISTS `crs_rpt_ref_certs`;

CREATE TABLE `crs_rpt_ref_certs` SELECT 
    c.*,
    sh.`CertificateDate` AS `Safe_Haven_Date`,
    cdc.`CertificateDate` AS `Concussion_Awareness_Date`,
    sca.`CertificateDate` AS `Sudden_Cardiac_Arrest_Date`,
    ss.`CertificateDate` AS `SafeSport_Date`,
    ls.`CertificateDate` AS `LiveScan_Date`,
    risk.`CertificateName` AS `RiskStatus`,
    risk.`CertificateDate` AS `RiskExpireDate`
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
    `tmp_risk_cert` risk ON c.`AdminID` = risk.`AdminID`;

-- Add InLeague certs
-- INSERT INTO `crs_rpt_ref_certs` SELECT vcv.`AYSOID`,
--   '' AS `AdminID`,
--   vcv.`MY`,
--   REPLACE(REPLACE(REPLACE(vcv.`SAR`, '/0','/'), '/0','/'), '/0','/') AS `SAR`,
--   vcv.`Section`,
--   vcv.`Area`,
--   vcv.`Region`,
--   `FirstName` AS `First_Name`,
--   `LastName` AS `Last_Name`,
--   `Street` AS `Address`,
--   vcv.`City`,
--   vcv.`State`,
--   `Zip` AS `Zipcode`,
--   `CellPhone` AS `Cell_Phone`,
--   vcv.`Gender`,
--   vcv.`Email`,
--   `Ref_Cert_Desc` AS `CertificationDesc`,
--   `Ref_Cert_Date` AS `CertificationDate`,
--   vcv.`Safe_Haven_Date`,
--   `CDC_Date` AS `Concussion_Awareness_Date`,
--   `SCA_Date` AS `Sudden_Cardiac_Arrest_Date`,
--   vcv.`SafeSport_Date` AS `SafeSport_Date`,
--   vcv.`LiveScan_Date` AS `LiveScan_Date`,
--   'InLeague' AS `RiskStatus`,
--   CONCAT(CAST(RIGHT(vcv.`MY`,4) AS UNSIGNED) + 1, '-07-31') AS `RiskExpireDate` 
-- FROM
--     `1.Volunteer_Certs_VolunteerReport_InLeague` vcv
--         LEFT JOIN
--     crs_rpt_ref_certs rc ON vcv.AYSOID = rc.AYSOID
-- WHERE vcv.`MY` > rc.`MY`;

/* 2021-01-03: Add InLeague volunteers to crs_rpt_ref_certs */
UPDATE `crs_rpt_ref_certs` crs
        INNER JOIN
    `1.Volunteer_Certs_VolunteerReport_InLeague` vc ON crs.`AYSOID` = vc.`AYSOID` AND crs.`AdminID` = ''
SET 
    crs.`Safe_Haven_Date` = vc.`Safe_Haven_Date`,
    crs.`Concussion_Awareness_Date` = vc.`CDC_Date`,
    crs.`Sudden_Cardiac_Arrest_Date` = vc.`SCA_Date`,
    crs.`SafeSport_Date` = vc.`SafeSport_Date`,
    crs.`LiveScan_Date` = vc.`LiveScan_Date`,
	crs.`RiskStatus` = 'InLeague',
	crs.`RiskExpireDate`  = CONCAT(CAST(RIGHT(vc.`MY`,4) AS UNSIGNED) + 1, '-07-31');
    
UPDATE `crs_rpt_ref_certs` SET `SAR` = REPLACE(`SAR`, '/0','/');
UPDATE `crs_rpt_ref_certs` SET `SAR` = REPLACE(`SAR`, '/0','/');
UPDATE `crs_rpt_ref_certs` SET `SAR` = REPLACE(`SAR`, '/0','/');
/* fix Matthew Gonzalez-Valenzuela */
UPDATE `crs_rpt_ref_certs` SET `CertificationDesc`='Intermediate Referee', `CertificationDate`='2022-02-22' WHERE AdminID='69526-398429';
/* fix Richard Bronshvag */
UPDATE `crs_rpt_ref_certs` SET `AYSOID` = '69026725' WHERE `AdminID` = '52423-428440';
/* end fixes */

-- Update Tables for Referee Scheduler
DROP TABLE IF EXISTS `rs_refs`;
CREATE TABLE `rs_refs` SELECT * FROM
    `crs_rpt_ref_certs`;
ALTER TABLE `rs_refs` ADD INDEX (`AYSOID`);

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
	LEFT JOIN `rs_refNicknames` n ON r.AYSOID = n.AYSOID
	WHERE
		n.AYSOID IS NULL) new;
				
INSERT INTO `rs_refNicknames` (`AYSOID`, `Name`, `Nickname`)
SELECT DISTINCT `AYSOID`, `Name`, `Name` FROM tmp_refUpdate;

/* remove duplicates from `rs_refNicknames` */
DROP TABLE IF EXISTS tmp_refNicknames;
CREATE TABLE tmp_refNicknames SELECT DISTINCT `AYSOID`, `Name`, `Nickname` FROM `rs_refNicknames`;

TRUNCATE TABLE `rs_refNicknames`;
ALTER TABLE `rs_refNicknames` AUTO_INCREMENT=0;
INSERT INTO `rs_refNicknames` (`AYSOID`, `Name`, `Nickname`)
SELECT `AYSOID`, `Name`, `Nickname` FROM tmp_refNicknames;
DROP TABLE IF EXISTS tmp_refNicknames;
/* end remove */

-- Update timestamp table  
SET time_zone='+00:00';
DROP TABLE IF EXISTS `crs_rpt_lastUpdate`;  
CREATE TABLE `crs_rpt_lastUpdate` SELECT NOW() AS timestamp;
ALTER TABLE crs_rpt_lastUpdate
CHANGE COLUMN `timestamp` `timestamp` DATETIME NOT NULL DEFAULT '1901-01-01 00:00:00' ;
ALTER TABLE crs_rpt_lastUpdate ADD UNIQUE (`timestamp`);
        
SELECT 
    *
FROM
    `crs_rpt_ref_certs`
ORDER BY `RiskExpireDate` , `AYSOID` , `AdminID` DESC;
