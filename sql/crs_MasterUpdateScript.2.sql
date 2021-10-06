USE `ayso1ref_services`;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));






/***************************************/
--  Process the lot

-- 2021-08-20: fix S/A/R format to remove leading zeros from Region, e.g. '1/B/0003' should be '1/B/3'
UPDATE crs_certs 
SET SAR = REPLACE(SAR, '/0', '/');
UPDATE crs_certs 
SET SAR = REPLACE(SAR, '/0', '/');
UPDATE crs_certs 
SET SAR = REPLACE(SAR, '/0', '/');
-- END: 2021-08-20: fix S/A/R format to remove leading zeros from Region, e.g. '1/B/0003' should be '1/B/3'

-- 2019-03-18: added because eAYSO is now returning blank dates for invalid dates
UPDATE crs_certs 
SET 
    CertDate = '1964-09-15'
WHERE
    CertificationDesc LIKE '%Referee%'
        AND CertDate = '';        
-- END: 2019-03-18: added because eAYSO is now returning blank dates for invalid dates

-- 2018-08-07: added because BS is not updating certifications across all portals; each record must be opened for certs to update
UPDATE crs_certs 
SET 
    CertificationDesc = 'Intermediate Referee Instructor'
WHERE
    (CertificationDesc = 'Referee Instructor'
    OR CertificationDesc = 'Basic Referee Instructor')
        AND CertDate <= '2018-08-01';        

UPDATE crs_certs 
SET 
    CertificationDesc = 'Regional Referee Instructor'
WHERE
    (CertificationDesc = 'Referee Instructor'
    OR CertificationDesc = 'Basic Referee Instructor')
        AND CertDate > '2018-08-01';        
-- END: 2018-08-07: added because BS is not updating certifications across all portals; each record must be opened for certs to update

-- Apply special cases  
CALL `CertTweaks`('crs_certs');   
CALL `CertTweaks`('crs_shcerts');   

-- Refresh all referee certificates - required to remove duplicate records  
CALL `RefreshRefCerts`();  

-- Delete records duplicated across Membership Years
DROP TABLE IF EXISTS tmp_dupmy;

CREATE TEMPORARY TABLE tmp_dupmy SELECT 
	AYSOID, `Membership Year`
FROM
	(SELECT 
			*,
	@rank:=IF(@id = `AYSOID`, @rank + 1, 1) AS rank,
	@id:=`AYSOID`
	FROM
			(SELECT DISTINCT
			`AYSOID`, `Membership Year`
	FROM
			crs_refcerts
	ORDER BY `Membership Year` DESC) ordered
	GROUP BY AYSOID , `Membership Year`) ranked
WHERE
	rank = 1;

ALTER TABLE tmp_dupmy ADD INDEX (`AYSOID`);
ALTER TABLE tmp_dupmy ADD INDEX (`Membership Year`);

DROP TABLE IF EXISTS tmp_refcerts;

CREATE TEMPORARY TABLE tmp_refcerts SELECT DISTINCT n1.* FROM
	crs_refcerts n1
			INNER JOIN
	tmp_dupmy d ON n1.`AYSOID` = d.`AYSOID`
			AND n1.`Membership Year` = d.`Membership Year`;

DROP TABLE IF EXISTS crs_refcerts;

ALTER TABLE `tmp_refcerts` RENAME TO `crs_refcerts`;
    
DELETE FROM crs_refcerts WHERE AYSOID IN (SELECT AYSOID FROM crs_duplicateIDs);    

-- Removed those that have moved on 
DELETE FROM crs_refcerts WHERE AYSOID IN (SELECT AYSOID FROM crs_not_available WHERE Reason = 'deceased');    

-- Removed those that have indicated they are no longer available for assessing or instructing 
DELETE FROM crs_refcerts 
WHERE
    AYSOID IN (SELECT 
        AYSOID
    FROM
        crs_not_available)
    AND (`CertificationDesc` LIKE '%Assessor%'
    OR `CertificationDesc` LIKE '%Instructor%');    

-- 2021-06-20: Updated to drop registrations more then 4 years old
DELETE FROM `crs_refcerts` WHERE NOT isMYCurrent(`Membership Year`);
-- 2021-06-20: END: Added to drop registrations more then 4 years old

-- Refresh Highest Certification table after deletion of duplicate records
CALL `RefreshHighestCertification`();

-- Daniel Gomez fix  
SET @s = CONCAT("UPDATE crs_rpt_hrc SET CertificationDesc = 'Intermediate Referee', CertDate = '2020-02-12' WHERE `AYSOID` = 74607360;");
CALL exec_qry(@s);


CALL `RefreshDupicateRefCerts`();

DELETE FROM crs_refcerts
WHERE `AYSOID` in (SELECT DISTINCT `AYSOID` FROM tmp_duprefcerts);

DELETE FROM crs_rpt_hrc
WHERE `AYSOID` in (SELECT DISTINCT `AYSOID` FROM tmp_duprefcerts);

-- Refresh all temporary tables
CALL `RefreshRefereeAssessors`();  
CALL `RefreshNationalRefereeAssessors`();  
CALL `RefreshRefereeInstructors`();  
CALL `RefreshRefereeInstructorEvaluators`();  
-- CALL `RefreshRefNoCerts`();  
CALL `RefreshRefereeUpgradeCandidates`();  
CALL `RefreshUnregisteredReferees`();  -- depends on current crs_rpt_hrc
CALL `RefreshSafeHavenCerts`();  
CALL `RefreshConcussionCerts`();  
CALL `RefreshRefConcussionCerts`();   
CALL `RefreshSuddenCardiacArrestCerts`();
CALL `RefreshRefSuddenCardiacArrestCerts`();
CALL `RefreshCertDateErrors`();
CALL `RefreshCompositeRefCerts`();


-- 2021-08-30: Added as Sports Connect Volunteer Certification reports no longer being updated
DROP TABLE IF EXISTS `tmp_data`;
CREATE TABLE `tmp_data` SELECT * FROM
    (SELECT 
        `refGrade1`, `refObtainDate1`
    FROM
        `AdminCredentialsStatusDynamic`
    WHERE
        `crs_rpt_ref_certs`.`AYSOID` = `AdminCredentialsStatusDynamic`.`AYSOID`
            AND `AYSOID` IN (SELECT 
                `AYSOID`
            FROM
                `AdminCredentialsStatusDynamic`)) a;
-- UPDATE `crs_rpt_ref_certs` SET `CertificationDesc` = `refGrade1`, `CertDate` = `refObtainDate1` FROM ;


UPDATE `crs_rpt_ref_certs` SET `CertificationDesc` = (SELECT `refGrade1` FROM `AdminCredentialsStatusDynamic` WHERE `crs_rpt_ref_certs`.`AYSOID` = `AdminCredentialsStatusDynamic`.`AltID`) WHERE `AYSOID` IN (SELECT `AltID` FROM `AdminCredentialsStatusDynamic`);
UPDATE `crs_rpt_ref_certs` SET `CertDate` = (SELECT `refObtainDate1` FROM `AdminCredentialsStatusDynamic` WHERE `crs_rpt_ref_certs`.`AYSOID` = `AdminCredentialsStatusDynamic`.`AYSOID`) WHERE `AYSOID` IN (SELECT `AYSOID` FROM `AdminCredentialsStatusDynamic`);
UPDATE `crs_rpt_ref_certs` SET `shCertificationDesc` = (SELECT `CertificationDesc` FROM `AdminCredentialsStatusDynamic` WHERE `CertificationDesc` LIKE '%Safe Haven%' AND `crs_rpt_ref_certs`.`AYSOID` = `AdminCredentialsStatusDynamic`.`AYSOID`) WHERE `AYSOID` IN (SELECT `AYSOID` FROM `AdminCredentialsStatusDynamic`);
UPDATE `crs_rpt_ref_certs` SET `shCertDate` = (SELECT `CertDate` FROM `AdminCredentialsStatusDynamic` WHERE `CertificationDesc` LIKE '%Safe Haven%' AND`crs_rpt_ref_certs`.`AYSOID` = `AdminCredentialsStatusDynamic`.`AYSOID`) WHERE `AYSOID` IN (SELECT `AYSOID` FROM `AdminCredentialsStatusDynamic`);
UPDATE `crs_rpt_ref_certs` SET `CertificationDesc` = (SELECT `CertificationDesc` FROM `AdminCredentialsStatusDynamic` WHERE `crs_rpt_ref_certs`.`AYSOID` = `AdminCredentialsStatusDynamic`.`AYSOID`) WHERE `AYSOID` IN (SELECT `AYSOID` FROM `AdminCredentialsStatusDynamic`);
UPDATE `crs_rpt_ref_certs` SET `CertDate` = (SELECT `CertDate` FROM `AdminCredentialsStatusDynamic` WHERE `crs_rpt_ref_certs`.`AYSOID` = `AdminCredentialsStatusDynamic`.`AYSOID`) WHERE `AYSOID` IN (SELECT `AYSOID` FROM `AdminCredentialsStatusDynamic`);
UPDATE `crs_rpt_ref_certs` SET `CertificationDesc` = (SELECT `CertificationDesc` FROM `AdminCredentialsStatusDynamic` WHERE `crs_rpt_ref_certs`.`AYSOID` = `AdminCredentialsStatusDynamic`.`AYSOID`) WHERE `AYSOID` IN (SELECT `AYSOID` FROM `AdminCredentialsStatusDynamic`);
UPDATE `crs_rpt_ref_certs` SET `CertDate` = (SELECT `CertDate` FROM `AdminCredentialsStatusDynamic` WHERE `crs_rpt_ref_certs`.`AYSOID` = `AdminCredentialsStatusDynamic`.`AYSOID`) WHERE `AYSOID` IN (SELECT `AYSOID` FROM `AdminCredentialsStatusDynamic`);
-- END 2021-08-30: Added as Sports Connect Volunteer Certification reports no longer being updated

DROP TABLE IF EXISTS tmp_e3_certs;

CREATE TABLE tmp_e3_certs SELECT crs.`AYSOID`, `scaCertificationDesc`, `scaCertDate`, `SCA Date` FROM
    `crs_rpt_ref_certs` crs
        LEFT JOIN
    `e3_InLeague_certifications` e3 ON crs.`AYSOID` = e3.`AYSOID`;

UPDATE `tmp_e3_certs` 
SET 
    `scaCertificationDesc` = 'e3 Sudden Cardiac Arrest Training',
    `scaCertDate` = `SCA Date`
WHERE 
    `tmp_e3_certs`.`SCA Date` <> '';

UPDATE `crs_rpt_ref_certs` 
SET 
    `scaCertificationDesc` = (SELECT `scaCertificationDesc` FROM `tmp_e3_certs` WHERE `crs_rpt_ref_certs`.`AYSOID` = `tmp_e3_certs`.`AYSOID`),
    `scaCertDate` = (SELECT `scaCertDate` FROM `tmp_e3_certs` WHERE `crs_rpt_ref_certs`.`AYSOID` = `tmp_e3_certs`.`AYSOID`);

DROP TABLE IF EXISTS tmp_e3_certs;
                
-- 2021-08-21: END: modified to update MY from inLeague registrations and certifications from e3

-- Update Tables for Referee Scheduler
DROP TABLE IF EXISTS rs_refs;
CREATE TABLE rs_refs SELECT 
	* 
FROM crs_rpt_hrc;
ALTER TABLE rs_refs ADD INDEX (`AYSOID`);

DROP TABLE IF EXISTS tmp_refUpdate;
CREATE TEMPORARY TABLE tmp_refUpdate SELECT 
	*
FROM
	(SELECT 
		hrc.*
	FROM
		crs_rpt_hrc hrc
	LEFT JOIN rs_refs r ON r.AYSOID = hrc.AYSOID
	WHERE
		r.AYSOID IS NULL) new;
				
INSERT INTO rs_refNicknames (`AYSOID`, `Name`, `Nickname`)
SELECT AYSOID, Name, Name FROM tmp_refUpdate;

-- Update timestamp table  
SET time_zone='+00:00';
DROP TABLE IF EXISTS `crs_rpt_lastUpdate`;  
CREATE TABLE `crs_rpt_lastUpdate` SELECT NOW() AS timestamp;
ALTER TABLE crs_rpt_lastUpdate
CHANGE COLUMN `timestamp` `timestamp` DATETIME NOT NULL DEFAULT '1901-01-01 00:00:00' ;
ALTER TABLE crs_rpt_lastUpdate ADD UNIQUE (`timestamp`);
 
-- Update Composite Cert table  
CALL `UpdateCompositeMYCerts`();  

UPDATE `s1_composite_my_certs` SET `Zip` = REPLACE(`Zip`, "'", '');
UPDATE `s1_composite_my_certs` SET `AYSOID` = REPLACE(`AYSOID`, " ", "");
ALTER TABLE `s1_composite_my_certs` 
CHANGE COLUMN `AYSOID` `AYSOID` INT(11); 

-- Select the composite results for download
SELECT 
		*
FROM
		`s1_composite_my_certs`
ORDER BY `Section`, `Area`, `Region`, `Last Name`;
