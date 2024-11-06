DROP TABLE IF EXISTS `tmp`;

SELECT * FROM `1.RefAssessors` ;

SELECT * FROM `1.RefAssessors.20220815`;

CREATE TABLE `tmp` 
SELECT * from `1.RefAssessors.20220815`;

INSERT IGNORE
  INTO `tmp` 
SELECT *
  FROM `1.RefAssessors`;
    
DROP TABLE IF EXISTS `1.RefAssessors.20240828`;

CREATE TABLE `1.RefAssessors.20240828` 
SELECT `AdminID`, `AYSOID`, `First Name`, `Last Name`,`CertificationDesc`, `CertificationDate`  from `tmp`;

DROP TABLE `tmp`;

SELECT * FROM `1.RefAssessors.20240828`;

