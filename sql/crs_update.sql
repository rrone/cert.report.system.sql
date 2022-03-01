-- update scripts
CALL `wp_ayso1ref`.`UpdateS1CRSTables`();
CALL `wp_ayso1ref`.`UpdateCompositeMYCerts`();
SELECT * FROM `crs_certs`;