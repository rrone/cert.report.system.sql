DROP TABLE IF EXISTS `crs_import`;

CREATE TABLE `crs_import` (
  `Program Name` text,
  `Program AYSO Membership Year` int(11) DEFAULT NULL,
  `Volunteer Role` text,
  `AYSO Volunteer ID` int(11) DEFAULT NULL,
  `Volunteer First Name` text,
  `Volunteer Last Name` text,
  `Volunteer Address` text,
  `Volunteer City` text,
  `Volunteer State` text,
  `Volunteer Zip` int(11) DEFAULT NULL,
  `Volunteer Phone` text,
  `Volunteer Cell` text,
  `Volunteer Email` text,
  `AYSO Certifications` text,
  `Date of Last AYSO Certification Update` text,
  `Portal Name` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOAD DATA INFILE 'crs_csv/1b.csv'
INTO TABLE `crs_import`
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\r\n';

LOAD DATA INFILE 'crs_csv/1c.csv'
INTO TABLE `crs_import`
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\r\n';

LOAD DATA INFILE 'crs_csv/1d.csv'
INTO TABLE `crs_import`
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\r\n';

LOAD DATA INFILE 'crs_csv/1f.csv'
INTO TABLE `crs_import`
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\r\n';

LOAD DATA INFILE 'crs_csv/1g.csv'
INTO TABLE `crs_import`
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\r\n';

LOAD DATA INFILE 'crs_csv/1h.csv'
INTO TABLE `crs_import`
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\r\n';

LOAD DATA INFILE 'crs_csv/1n.csv'
INTO TABLE `crs_import`
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\r\n';

LOAD DATA INFILE 'crs_csv/1p.csv'
INTO TABLE `crs_import`
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\r\n';

LOAD DATA INFILE 'crs_csv/1r.csv'
INTO TABLE `crs_import`
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\r\n';

LOAD DATA INFILE 'crs_csv/1s.csv'
INTO TABLE `crs_import`
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\r\n';

LOAD DATA INFILE 'crs_csv/1u.csv'
INTO TABLE `crs_import`
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\r\n';

DELETE FROM `crs_import` WHERE `Program Name` = 'Program Name';


DROP TABLE IF EXISTS `eAYSO.MY2017.certs`;

CREATE TABLE `eAYSO.MY2017.certs` (
  `AYSOID` int(11) DEFAULT NULL,
  `Name` text,
  `Street` text,
  `City` text,
  `State` text,
  `Zip` text,
  `HomePhone` text,
  `BusinessPhone` text,
  `Email` text,
  `CertificationDesc` text,
  `Gender` text,
  `SectionAreaRegion` text,
  `CertDate` text,
  `ReCertDate` text,
  `FirstName` text,
  `LastName` text,
  `SectionName` int(11) DEFAULT NULL,
  `AreaName` text,
  `RegionNumber` int(11) DEFAULT NULL,
  `Membership Year` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOAD DATA INFILE 'crs_csv/MY2017.csv'
INTO TABLE `eAYSO.MY2017.certs`
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\r\n';

DELETE FROM `eAYSO.MY2017.certs` WHERE `Name` = 'Name';
