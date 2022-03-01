USE `wp_ayso1ref`;

SET @folder = '/Users/frederickroberts/Dropbox/_open/_ayso/s1/reports/20180126/';

SET @s = CONCAT("
	CALL `init_crs_certs`();

	DROP TABLE IF EXISTS `1_certs`;

	CREATE TABLE `1_certs` (
		`Program Name` TEXT,
		`Program AYSO Membership Year` TEXT,
		`Volunteer Role` TEXT,
		`AYSO Volunteer ID` TEXT,
		`Volunteer First Name` TEXT,
		`Volunteer Last Name` TEXT,
		`Volunteer Address` TEXT,
		`Volunteer City` TEXT,
		`Volunteer State` TEXT,
		`Volunteer Zip` TEXT,
		`Volunteer Phone` TEXT,
		`Volunteer Cell` TEXT,
		`Volunteer Email` TEXT,
		`Gender` TEXT,
		`AYSO Certifications` TEXT,
		`Date of Last AYSO Certification Update` TEXT,
		`Portal Name` TEXT
	)  ENGINE=INNODB DEFAULT CHARSET=LATIN1;

	LOAD DATA LOCAL INFILE ", @folder, "'1.csv')
	INTO TABLE `1_certs` 
	FIELDS TERMINATED BY ',' 
	ENCLOSED BY '\"'
	LINES TERMINATED BY '\r'
	IGNORE 1 ROWS;

	CALL `processBSCSV`('1_certs');

	-- Update all eAYSO MY2017 & MY2016 cert exports

	CALL `processEAYSOCSV`('`eAYSO.MY2017.certs`');
	CALL `eAYSOHighestRefCert`('eAYSO.MY2017.certs');

	CALL `processEAYSOCSV`('`eAYSO.MY2016.certs`');
	CALL `eAYSOHighestRefCert`('eAYSO.MY2016.certs');

	-- Apply special cases
	CALL `CertTweaks`();

	-- Refresh all temporary tables
	CALL `RefreshRefCerts`();
	-- Delete regional records duplicated at Area & Section Portals
	-- DELETE n1 FROM crs_refcerts n1, crs_refcerts n2 WHERE n1.`Name` = n2.`Name` AND n1.`Region` = '';
	DELETE n1 FROM crs_refcerts n1,
		crs_refcerts n2 
	WHERE
		n1.`Name` = n2.`Name` AND n1.`Area` = '';

	CALL `RefreshHighestCertification`();
	CALL `RefreshNationalRefereeAssessors`();
	CALL `RefreshRefereeAssessors`();
	CALL `RefreshRefereeInstructors`();
	CALL `RefreshRefereeInstructorEvaluators`();
	CALL `RefreshRefNoCerts`();
	CALL `RefreshRefereeUpgradeCandidates`();
	CALL `RefreshUnregisteredReferees`();
	CALL `RefreshSafeHavenCerts`();
	CALL `RefreshConcussionCerts`();
	CALL `RefreshRefConcussionCerts`();

	-- Update timestamp table
	DROP TABLE IF EXISTS `crs_lastUpdate`;
	CREATE TABLE `crs_lastUpdate` SELECT NOW() AS timestamp;

	CALL `wp_ayso1ref`.`UpdateCompositeMYCerts`();

	SELECT 
		*
	FROM
		`s1_composite_my_certs`
		
	INTO OUTFILE '", @folder, "s1_composite_my_certs.csv'
	FIELDS TERMINATED BY ','
	ENCLOSED BY '\"'
	LINES TERMINATED BY '\n'"
);


PREPARE stmt FROM @s;

EXECUTE stmt;

DEALLOCATE PREPARE stmt;
