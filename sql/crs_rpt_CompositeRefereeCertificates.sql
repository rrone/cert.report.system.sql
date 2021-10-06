USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DROP TABLE IF EXISTS `1.CompositeRefereeCertificates`;

CREATE TABLE `1.CompositeRefereeCertificates` SELECT * FROM
    `AdminLicenseGradeRefereeHighest`;
    
ALTER TABLE `ayso1ref_services`.`1.CompositeRefereeCertificates` 
ADD COLUMN `Safe_Haven` TEXT NULL,
ADD COLUMN `Safe_Haven_Date` TEXT NULL,
ADD COLUMN `Concussion_Awareness` TEXT NULL,
ADD COLUMN `Concussion_Awareness_Date` TEXT NULL,
ADD COLUMN `Sudden_Cardiac_Arrest` TEXT NULL,
ADD COLUMN `SCA_Date` TEXT NULL,
ADD COLUMN `RiskStatus` TEXT NULL,
ADD COLUMN `RiskExpireDate` TEXT NULL,    
ADD COLUMN `MY` TEXT NULL;

UPDATE `1.CompositeRefereeCertificates` c SET `Safe_Haven` = (SELECT `CertificateName` FROM `AdminCredentialsStatusDynamic` WHERE c.AdminID = `AdminCredentialsStatusDynamic`.AdminID AND `AdminCredentialsStatusDynamic`.`CertificateName` LIKE '%Safe Haven' LIMIT 1);
UPDATE `1.CompositeRefereeCertificates` c SET `Safe_Haven_Date` = str_to_date((SELECT `CertificateDate` FROM `AdminCredentialsStatusDynamic` WHERE c.AdminID = `AdminCredentialsStatusDynamic`.AdminID AND `AdminCredentialsStatusDynamic`.`CertificateName` LIKE '%Safe Haven' LIMIT 1), '%m/%d/%Y');

UPDATE `1.CompositeRefereeCertificates` c SET `Concussion_Awareness` = (SELECT `CertificateName` FROM `AdminCredentialsStatusDynamic` WHERE c.AdminID = `AdminCredentialsStatusDynamic`.AdminID AND `AdminCredentialsStatusDynamic`.`CertificateName` LIKE '%Concussion%' LIMIT 1);
UPDATE `1.CompositeRefereeCertificates` c SET `Concussion_Awareness_Date` = str_to_date((SELECT `CertificateDate` FROM `AdminCredentialsStatusDynamic` WHERE c.AdminID = `AdminCredentialsStatusDynamic`.AdminID AND `AdminCredentialsStatusDynamic`.`CertificateName` LIKE '%Concussion%' LIMIT 1), '%m/%d/%Y');

UPDATE `1.CompositeRefereeCertificates` c SET `Sudden_Cardiac_Arrest` = (SELECT `CertificateName` FROM `AdminCredentialsStatusDynamic` WHERE c.AdminID = `AdminCredentialsStatusDynamic`.AdminID AND `AdminCredentialsStatusDynamic`.`CertificateName` LIKE '%Cardiac%' LIMIT 1);
UPDATE `1.CompositeRefereeCertificates` c SET `SCA_Date` = str_to_date((SELECT `CertificateDate` FROM `AdminCredentialsStatusDynamic` WHERE c.AdminID = `AdminCredentialsStatusDynamic`.AdminID AND `AdminCredentialsStatusDynamic`.`CertificateName` LIKE '%Cardiac%' LIMIT 1), '%m/%d/%Y');

UPDATE `1.CompositeRefereeCertificates` c SET `RiskStatus` = (SELECT `CertificateName` FROM `AdminCredentialsStatusDynamic` WHERE c.AdminID = `AdminCredentialsStatusDynamic`.AdminID LIMIT 1);
UPDATE `1.CompositeRefereeCertificates` c SET `RiskExpireDate` = str_to_date((SELECT `CertificateDate` FROM `AdminCredentialsStatusDynamic` WHERE c.AdminID = `AdminCredentialsStatusDynamic`.AdminID LIMIT 1), '%m/%d/%Y');

UPDATE `1.CompositeRefereeCertificates` c SET `MY` = (SELECT `MY` FROM `AdminCredentialsStatusDynamic` WHERE c.AdminID = `AdminCredentialsStatusDynamic`.AdminID LIMIT 1);

SELECT 
    *
FROM
    `1.CompositeRefereeCertificates`;