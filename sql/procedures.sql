DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `RefreshRefereeAssessors`()
BEGIN
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SET @id:= 0;

DROP TABLE IF EXISTS wp_ayso1ref.crs_tmp_ra;

CREATE TABLE wp_ayso1ref.crs_tmp_ra SELECT * FROM
    (SELECT 
		`AYSOID`,
        `Name`,
        `First Name`,
        `Last Name`,
        `Address`,
		`City`,
        `State`,
        `Zip`,
        `Home Phone`,
		`Cell Phone`,
        `Email`,
        `CertificationDesc`,
        `CertDate`,
		`SAR`,
        `Section`,
		`Area`,
        `Region`,
        `Membership Year`
    FROM
        (SELECT 
        *,
            @rank:=IF(@id = `AYSOID`, @rank + 1, 1) AS rank,
            @id:=`AYSOID`
    FROM
        (SELECT 
        *
    FROM
        `crs_refcerts`
    WHERE
        `CertificationDesc` LIKE '%Assessor%'
            AND NOT `CertificationDesc` LIKE '%Instructor%'
            AND NOT `CertificationDesc` LIKE '%Administrator%'
            AND NOT `CertificationDesc` LIKE '%VIP%'
            AND NOT `CertificationDesc` LIKE '%Course%'
            AND NOT `CertificationDesc` LIKE 'Regional Referee'
            AND NOT `CertificationDesc` LIKE 'z-Online'
            AND NOT `CertificationDesc` LIKE '%Safe Haven%'
            AND NOT `CertificationDesc` LIKE 'Assistant%'
            AND NOT `CertificationDesc` LIKE '%Official%'
    GROUP BY `AYSOID` , FIELD(`CertificationDesc`, 'National Referee Assessor', 'Referee Assessor')) ordered) ranked
    WHERE
        rank = 1
    ORDER BY CertificationDesc , SAR , `Last Name` , `First Name` , AYSOID) ra;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `RefreshRefCerts`()
BEGIN
DROP TABLE IF EXISTS wp_ayso1ref.crs_refcerts;

CREATE TABLE wp_ayso1ref.crs_refcerts
SELECT * 
	FROM wp_ayso1ref.crs_certs 
	WHERE 
	`CertificationDesc` LIKE '%Referee%';
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `RefreshRefNoCerts`()
    SQL SECURITY INVOKER
BEGIN    
DROP TABLE IF EXISTS wp_ayso1ref.crs_tmp_nocerts;

CREATE TABLE wp_ayso1ref.crs_tmp_nocerts SELECT * FROM
    (SELECT DISTINCT 
	`AYSOID`, 
	`Name`, 
    `First Name`, 
    `Last Name`, 
    `Address`, 
    `City`, 
    `State`, 
    `Zip`, 
    `Home Phone`, 
    `Cell Phone`, 
    `Email`, 
    `CertificationDesc`, 
    `CertDate`, 
    `SAR`, 
    `Section`, 
    `Area`, 
    `Region`, 
    `Membership Year` 
FROM `crs_certs` 
WHERE `Volunteer Role` LIKE '%Referee%' 
	AND `CertificationDesc` = '' 
ORDER BY `SAR`) nocerts;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `RefreshHighestCertification`()
BEGIN
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SET @id:= 0;
SET @dfields := "'National Referee', 'National 2 Referee', 'Advanced Referee', 'Intermediate Referee', 'Regional Referee', 'Regional Referee & Safe Haven Referee', 'z-Online Regional Referee without Safe Haven', 'Z-Online Regional Referee', 'Assistant Referee', 'Assistant Referee & Safe Haven Referee', 'U-8 Official', 'U-8 Official & Safe Haven Referee', 'Z-Online Safe Haven Referee', 'Safe Haven Referee', ''";

DROP TABLE IF EXISTS wp_ayso1ref.crs_tmp_hrc;
SET @s = CONCAT("
CREATE TABLE wp_ayso1ref.crs_tmp_hrc SELECT * FROM
    (SELECT 
        `AYSOID`,
            `Name`,
            `First Name`,
            `Last Name`,
            `Address`,
            `City`,
            `State`,
            `Zip`,
            `Home Phone`,
            `Cell Phone`,
            `Email`,
            `CertificationDesc`,
            `CertDate`,
            `SAR`,
            `Section`,
            `Area`,
            `Region`,
            `Membership Year`
    FROM
        (SELECT 
        *,
            @rank:=IF(@id = `AYSOID`, @rank + 1, 1) AS rank,
            @id:=`AYSOID`
    FROM
        (SELECT 
        *
    FROM
        `crs_refcerts`
    WHERE
        NOT `CertificationDesc` LIKE '%Assessor%'
            AND NOT `CertificationDesc` LIKE '%Instructor%'
            AND NOT `CertificationDesc` LIKE '%Administrator%'
            AND NOT `CertificationDesc` LIKE '%VIP%'
            AND NOT `CertificationDesc` LIKE '%Course%'
            AND NOT `CertificationDesc` LIKE '%Scheduler%'
    GROUP BY `AYSOID` , FIELD(`CertificationDesc`, ", @dfields, ")) ordered) ranked
    WHERE
        rank = 1
    ORDER BY FIELD(`CertificationDesc`, ", @dfields, ") , SAR, `Last Name` , `First Name` , AYSOID) hrc;");
    
PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CertTweaks`()
BEGIN
UPDATE `crs_certs` SET `Email` = 'ayso1sra@gmail.com' WHERE `AYSOID` = '97815888';
DELETE FROM `crs_certs` WHERE `AYSOID` = '56234203' AND `SAR` LIKE '1/D/%';
DELETE FROM `crs_certs` WHERE `Email` = 'mlraycraft.aysoinstructor@gmail.com';
DELETE FROM `crs_certs` WHERE `Name` = 'Michael Raycraft' AND `CertificationDesc` LIKE 'National Referee Assessor';
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `RefreshRefereeInstructorEvaluators`()
BEGIN
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SET @id:= 0;

DROP TABLE IF EXISTS wp_ayso1ref.crs_tmp_rie;

CREATE TABLE wp_ayso1ref.crs_tmp_rie SELECT * FROM
    (SELECT 
        `AYSOID`,
		`Name`,
		`First Name`,
		`Last Name`,
		`Address`,
		`City`,
		`State`,
		`Zip`,
		`Home Phone`,
		`Cell Phone`,
		`Email`,
		`CertificationDesc`,
		`CertDate`,
		`SAR`,
		`Section`,
		`Area`,
		`Region`,
		`Membership Year`
    FROM
        (SELECT 
        *,
            @rank:=IF(@id = `AYSOID`, @rank + 1, 1) AS rank,
            @id:=`AYSOID`
    FROM
        (SELECT 
        *
    FROM
        `crs_refcerts`
    WHERE
        `CertificationDesc` = 'Referee Instructor Evaluator'
    ORDER BY `CertDate` DESC) ordered) ranked
    WHERE
        rank = 1
    ORDER BY Section , Area , Region , `Last Name` , `First Name`) rie;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `RefreshNationalRefereeAssessors`()
BEGIN
DROP TABLE IF EXISTS wp_ayso1ref.crs_tmp_nra;

CREATE TABLE wp_ayso1ref.crs_tmp_nra 
SELECT DISTINCT
--     `AYSOID`,
    `Name`,
--     `Address`,
    `City`,
--   `Home Phone`,
--     `Cell Phone`,
     `Email`,
--     SPLIT_STRING(`Date of Last AYSO Certification Update`,
--             ' ',
--             1) AS CertDate,
    CONCAT(`Section`,'/',`Area`) AS SAR,
    `Membership Year`,
--  `First Name`,
    `Last Name`,
    `CertificationDesc`,
    `State`,
    `Zip`
FROM
    crs_certs
WHERE
    `CertificationDesc` = 'National Referee Assessor'
ORDER BY `Last Name`, SAR;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `eAYSOHighestRefCert`(IN `tableName` VARCHAR(128) CHARSET utf8)
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
BEGIN

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SET @id:= 0;
SET @dfields := "'National Referee', 'National 2 Referee', 'Advanced Referee', 'Intermediate Referee', 'Regional Referee', 'Regional Referee & Safe Haven Referee', 'z-Online Regional Referee without Safe Haven', 'Z-Online Regional Referee', 'Assistant Referee', 'Assistant Referee & Safe Haven Referee', 'U-8 Official', 'U-8 Official & Safe Haven Referee', 'Z-Online Safe Haven Referee', 'Safe Haven Referee', ''";

SET @s = CONCAT("DROP TABLE IF EXISTS `", tableName, "_highestRefCert`");

PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;

SET @s = CONCAT("
CREATE TABLE `", tableName, "_highestRefCert` SELECT * FROM
    (SELECT 
        `AYSOID`,
            `Name`,
            `FirstName` AS `First Name`,
            `LastName` AS `Last Name`,
            `Street` as `Address`,
            `City`,
            `State`,
            `Zip`,
            `HomePhone` AS `Home Phone`,
            `BusinessPhone` AS `Cell Phone`,
            `Email`,
            `CertificationDesc`,
            `CertDate`,
            `SectionAreaRegion` AS `SAR`,
            `SectionName`,
            `AreaName`,
            `RegionNumber`,
            `Membership Year`
    FROM
        (SELECT 
        *,
            @rank:=IF(@id = `AYSOID`, @rank + 1, 1) AS rank,
            @id:=`AYSOID`
    FROM
        (SELECT 
        *
    FROM
        `", tableName, "`
    WHERE
        `CertificationDesc` LIKE '%Referee%'    
        AND NOT `CertificationDesc` LIKE '%Assessor%'
        AND NOT `CertificationDesc` LIKE '%Instructor%'
        AND NOT `CertificationDesc` LIKE '%Administrator%'
        AND NOT `CertificationDesc` LIKE '%VIP%'
        AND NOT `CertificationDesc` LIKE '%Course%'
        AND NOT `CertificationDesc` LIKE '%Scheduler%'
    GROUP BY `AYSOID` , FIELD(`CertificationDesc`, ", @dfields, ")) ordered) ranked
    WHERE
        rank = 1
    ORDER BY FIELD(`CertificationDesc`, ", @dfields, ") , SAR, `Last Name` , `First Name` , AYSOID) hrc;");
    
PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `UpdateS1CRSTables`()
BEGIN

CALL `wp_ayso1ref`.`init_crs_certs`();

-- Update all Area BS cert exports
CALL `wp_ayso1ref`.`processCertCSV`('crs_1b_certs');
CALL `wp_ayso1ref`.`processCertCSV`('crs_1c_certs');
CALL `wp_ayso1ref`.`processCertCSV`('crs_1d_certs');
CALL `wp_ayso1ref`.`processCertCSV`('crs_1f_certs');
CALL `wp_ayso1ref`.`processCertCSV`('crs_1g_certs');
CALL `wp_ayso1ref`.`processCertCSV`('crs_1h_certs');
CALL `wp_ayso1ref`.`processCertCSV`('crs_1n_certs');
CALL `wp_ayso1ref`.`processCertCSV`('crs_1p_certs');
CALL `wp_ayso1ref`.`processCertCSV`('crs_1r_certs');
CALL `wp_ayso1ref`.`processCertCSV`('crs_1s_certs');
CALL `wp_ayso1ref`.`processCertCSV`('crs_1u_certs');

-- Apply special cases
CALL `wp_ayso1ref`.`CertTweaks`();

-- Refresh all temporary tables
CALL `RefreshRefCerts`();
CALL `RefreshHighestCertification`();
CALL `RefreshNationalRefereeAssessors`();
CALL `RefreshRefereeAssessors`();
CALL `RefreshRefereeInstructors`();
CALL `RefreshRefereeInstructorEvaluators`();
CALL `RefreshRefNoCerts`();

-- Update timestamp table
DROP TABLE IF EXISTS `lastUpdate`;
CREATE TABLE lastUpdate SELECT NOW() AS timestamp;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `init_crs_certs`()
BEGIN
DROP TABLE IF EXISTS wp_ayso1ref.crs_certs;
CREATE TABLE `crs_certs` (
  `Program Name` text,
  `Membership Year` varchar(12),
  `Volunteer Role` text,
  `AYSOID` int(12),
  `Name` longtext,
  `First Name` text,
  `Last Name` text,
  `Address` text,
  `City` text,
  `State` text,
  `Zip` int(11),
  `Home Phone` text,
  `Cell Phone` text,
  `Email` text,
  `CertificationDesc` text,
  `CertDate` varchar(10) CHARACTER SET utf8,
  `SAR` varchar(98) NOT NULL DEFAULT '',
  `Section` varchar(32) NOT NULL,
  `Area` varchar(32) NOT NULL,
  `Region` varchar(32) NOT NULL,
  `timestamp` datetime NOT NULL DEFAULT '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE wp_ayso1ref.crs_certs AUTO_INCREMENT = 0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `RefreshRefereeInstructors`()
BEGIN
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SET @id:= 0;

DROP TABLE IF EXISTS wp_ayso1ref.crs_tmp_ri;

CREATE TABLE wp_ayso1ref.crs_tmp_ri SELECT * FROM
    (SELECT 
        `AYSOID`,
		`Name`,
		`First Name`,
		`Last Name`,
		`Address`,
		`City`,
		`State`,
		`Zip`,
		`Home Phone`,
		`Cell Phone`,
		`Email`,
		`CertificationDesc`,
		`CertDate`,
		`SAR`,
		`Section`,
		`Area`,
		`Region`,
		`Membership Year`
    FROM
        (SELECT 
        *,
            @rank:=IF(@id = `AYSOID`, @rank + 1, 1) AS rank,
            @id:=`AYSOID`
    FROM
        (SELECT 
        *
    FROM
        `crs_refcerts`
    WHERE
        `CertificationDesc` LIKE '%Instructor%'
            AND NOT `CertificationDesc` LIKE '%Evaluator%'
            AND NOT `CertificationDesc` LIKE '%Assessor%'
            AND NOT `CertificationDesc` LIKE '%Course%'
            AND NOT `CertificationDesc` LIKE '%Regional%'
            AND NOT `CertificationDesc` LIKE '%Assistant%'
            AND NOT `CertificationDesc` LIKE '%Official%'
            AND NOT `CertificationDesc` LIKE '%Webinar%'
            AND NOT `CertificationDesc` LIKE '%Online%'
            AND NOT `CertificationDesc` LIKE '%Safe Haven%'
    GROUP BY `AYSOID` , FIELD(`CertificationDesc`, 'National Referee Instructor', 'Advanced Referee Instructor', 'Referee Instructor', 'Basic Referee Instructor', 'Grade2 Referee Instructor')) ordered) ranked
    WHERE
        rank = 1
    ORDER BY FIELD(`CertificationDesc`, 'National Referee Instructor', 'Advanced Referee Instructor', 'Referee Instructor', 'Basic Referee Instructor', 'Grade2 Referee Instructor', 'Referee Instructor Evaluator') , Section , Area , Region , `Last Name` , `First Name`) ri;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `processCertCSV`(
	certCSV varchar(128)
)
BEGIN
SET @inTable = certCSV;

SET @empty = '';
SET @space = ' ';
SET @delimTS = '/';
SET @delimDate = '/';

SET @s = CONCAT(' INSERT INTO wp_ayso1ref.crs_certs SELECT 
    `Program Name`,
    CONCAT("MY",`Program AYSO Membership Year`) AS `Membership Year`,
    `Volunteer Role`,
    `AYSO Volunteer ID` AS AYSOID,
	CONCAT(`Volunteer First Name`, @space, `Volunteer Last Name`) AS `Name`,
    `Volunteer First Name` AS `First Name`,
    `Volunteer Last Name` AS `Last Name`,
    `Volunteer Address` AS Address,
    `Volunteer City` AS City,
    `Volunteer State` AS State,
    `Volunteer Zip` AS Zip,
    `Volunteer Phone` AS `Home Phone`,
    `Volunteer Cell` AS `Cell Phone`,
    LCASE(`Volunteer Email`) AS Email,
    `AYSO Certifications` AS CertificationDesc,
    STR_TO_DATE(REPLACE(SPLIT_STRING(`Date of Last AYSO Certification Update`, " ", 1),"/", "."),GET_FORMAT(DATE,"USA")) AS CertDate,
    IF(sar.`region` IS NULL
            OR sar.`region` = @empty,
        CONCAT(sar.`section`, @delimTS, sar.`area`),
        CONCAT(sar.`section`,
                @delimTS,
                sar.`area`,
                @delimTS,
                sar.`region`)) AS SAR,
    sar.`section` AS Section,
    sar.`area` AS Area,
    sar.`region` AS Region,
    NOW() AS `timestamp`
FROM ',
    @inTable,
    ' csv
        INNER JOIN
    rs_sar sar ON csv.`Portal Name` = sar.portalName');

PREPARE stmt FROM @s;  
EXECUTE stmt;  

DEALLOCATE PREPARE stmt;  
END$$
DELIMITER ;
