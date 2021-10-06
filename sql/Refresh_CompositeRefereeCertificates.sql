USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DROP TABLE IF EXISTS `1.CompositeRefereeCertificates`;

CREATE TABLE `1.CompositeRefereeCertificates` SELECT * FROM
    `1.AdminLicenseGradeRefereeHighest`;
    
CREATE INDEX `idx_1.CompositeRefereeCertificates_AYSOID_AdminID`  ON `1.CompositeRefereeCertificates` (AYSOID, AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

ALTER TABLE `1.CompositeRefereeCertificates` 
ADD COLUMN `SAR` TEXT NULL AFTER `MY`,
ADD COLUMN `Address` TEXT NULL AFTER `Last_Name`,
ADD COLUMN `City` TEXT NULL AFTER `Address`,
ADD COLUMN `State` TEXT NULL AFTER `City`,
ADD COLUMN `Zipcode` TEXT NULL AFTER `State`,
ADD COLUMN `Home_Phone` TEXT NULL AFTER `Zipcode`,
ADD COLUMN `Cell_Phone` TEXT NULL AFTER `Home_Phone`;

UPDATE `1.CompositeRefereeCertificates` c SET `SAR` = `Section`;
UPDATE `1.CompositeRefereeCertificates` c SET `SAR` = CONCAT(`SAR`, '/' , `Area`) WHERE NOT `Area` = '';
UPDATE `1.CompositeRefereeCertificates` c SET `SAR` = CONCAT(`SAR`, '/', `Region`) WHERE NOT `Region` = '';

UPDATE `1.CompositeRefereeCertificates` c SET `Address` = (SELECT `Street` FROM `1.VolunteerReportExport` WHERE c.AYSOID = `1.VolunteerReportExport`.`AYSOID` LIMIT 1);
UPDATE `1.CompositeRefereeCertificates` c SET `City` = (SELECT `City` FROM `1.VolunteerReportExport` WHERE c.AYSOID = `1.VolunteerReportExport`.`AYSOID` LIMIT 1);
UPDATE `1.CompositeRefereeCertificates` c SET `State` = (SELECT `State` FROM `1.VolunteerReportExport`WHERE c.AYSOID = `1.VolunteerReportExport`.`AYSOID` LIMIT 1);
UPDATE `1.CompositeRefereeCertificates` c SET `Zipcode` = (SELECT `Zip` FROM `1.VolunteerReportExport` WHERE c.AYSOID = `1.VolunteerReportExport`.`AYSOID` LIMIT 1);
UPDATE `1.CompositeRefereeCertificates` c SET `Home_Phone` = (SELECT `HomePhone` FROM `1.VolunteerReportExport` WHERE c.AYSOID = `1.VolunteerReportExport`.`AYSOID` LIMIT 1);
UPDATE `1.CompositeRefereeCertificates` c SET `Cell_Phone` = (SELECT `CellPhone` FROM `1.VolunteerReportExport` WHERE c.AYSOID = `1.VolunteerReportExport`.`AYSOID` LIMIT 1);

DROP TABLE IF EXISTS `tmp_sh_cert`;
CREATE TEMPORARY TABLE `tmp_sh_cert` SELECT DISTINCT `AdminID`, `CertificateName`, `CertificateDate` FROM
    `1.AdminCredentialsStatusDynamic`
WHERE
    `1.AdminCredentialsStatusDynamic`.`CertificateName` LIKE '%Safe Haven';
CREATE INDEX `idx_tmp_sh_cert_AdminID`  ON `tmp_sh_cert` (AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

DROP TABLE IF EXISTS `tmp_cdc_cert`;
CREATE TEMPORARY TABLE `tmp_cdc_cert` SELECT DISTINCT `AdminID`, `CertificateName`, `CertificateDate` FROM
    `1.AdminCredentialsStatusDynamic`
WHERE
    `1.AdminCredentialsStatusDynamic`.`CertificateName` LIKE '%Concussion%';
CREATE INDEX `idx_tmp_cdc_cert_AdminID`  ON `tmp_cdc_cert` (AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

DROP TABLE IF EXISTS `tmp_sca_cert`;
CREATE TEMPORARY TABLE `tmp_sca_cert` SELECT DISTINCT `AdminID`, `CertificateName`, `CertificateDate` FROM
    `1.AdminCredentialsStatusDynamic`
WHERE
    `1.AdminCredentialsStatusDynamic`.`CertificateName` LIKE '%Cardiac%';
CREATE INDEX `idx_tmp_sca_cert_AdminID`  ON `tmp_sca_cert` (AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

DROP TABLE IF EXISTS `tmp_risk_cert`;
CREATE TEMPORARY TABLE `tmp_risk_cert` SELECT DISTINCT `AdminID`, `RiskStatus` AS `CertificateName`, `RiskExpireDate` AS `CertificateDate` FROM
    `1.AdminCredentialsStatusDynamic`
WHERE `RiskExpireDate` <> ''    ;
CREATE INDEX `idx_tmp_risk_cert_AdminID`  ON .`tmp_risk_cert` (AdminID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

DROP TABLE IF EXISTS `crs_rpt_ref_certs`;

CREATE TABLE `crs_rpt_ref_certs` SELECT 
    c.*,
    sh.`CertificateDate` AS `Safe_Haven_Date`,
    cdc.`CertificateDate` AS `Concussion_Awareness_Date`,
    sca.`CertificateDate` AS `Sudden_Cardiac_Arrest_Date`,
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
    `tmp_risk_cert` risk ON c.`AdminID` = risk.`AdminID`;

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
    `crs_rpt_ref_certs`;