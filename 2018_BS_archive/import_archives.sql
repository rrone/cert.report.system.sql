TRUNCATE TABLE `crs_1_201812_certs`;
 
LOAD DATA LOCAL INFILE '/Users/frederickroberts/Dropbox/_open/_ayso/s1/reports/2018_BS_archive/1.20181212.txt'  
	INTO TABLE `crs_1_201812_certs`   
	FIELDS TERMINATED BY '\t'   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\r'
	IGNORE 1 ROWS;   

TRUNCATE TABLE `crs_1_201905_certs`;

LOAD DATA LOCAL INFILE '/Users/frederickroberts/Dropbox/_open/_ayso/s1/reports/2018_BS_archive/1.20190501.txt'  
	INTO TABLE `crs_1_201905_certs`   
	FIELDS TERMINATED BY '\t'   
	ENCLOSED BY ''  
	LINES TERMINATED BY '\r'
	IGNORE 1 ROWS;   

SELECT 
    *
FROM
    ayso1ref_services.crs_1_201812_certs;

SELECT 
    *
FROM
    ayso1ref_services.crs_1_201905_certs;

