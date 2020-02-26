USE ayso1ref_services;
SET @table := 'crs_shcertscrs_vol_ids';

SET @s = CONCAT('DELETE FROM ', @table, ' WHERE `AYSOID` = 73895502');
PREPARE stmt FROM @s; 
EXECUTE stmt; 

SET @s = CONCAT('SELECT * FROM ', @table, ' WHERE `AYSOID` = 73895502');
PREPARE stmt FROM @s; 
EXECUTE stmt; 
DEALLOCATE PREPARE stmt; 