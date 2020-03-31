SELECT 
    *
FROM
    (SELECT 
        a.`AYSOID` AS `AYSOID.1`,
            b.`AYSOID` AS `AYSOID.2`,
            a.`Name`,
            a.`First Name`,
            a.`Last Name`,
            a.`Address`,
            a.`City`,
            a.`State`,
            a.`Zip`,
            a.`Home Phone`,
            a.`Cell Phone`,
            a.`Email`,
            a.`Gender`,
            a.`CertificationDesc`,
            a.`CertDate`,
            a.`SAR`,
            a.`Section`,
            a.`Area`,
            a.`Region`,
            a.`Membership Year`,
            a.`shCertificationDesc`,
            a.`shCertDate`,
            a.`cdcCertficationDesc`,
            a.`cdcCertDate`
    FROM
        `crs_rpt_ref_certs` a
    LEFT JOIN .`crs_rpt_ref_certs` b ON a.`Name` = b.`Name`
        AND a.`CertificationDesc` = b.`CertificationDesc`
        AND a.`CertDate` = b.`CertDate`
        -- AND a.`Email` = b.`Email`
        AND a.`AYSOID` <> b.`AYSOID`
-- 	WHERE a.`shCertificationDesc` = b.`shCertificationDesc`
--         AND a.`shCertDate` = b.`shCertDate`
--         AND a.`cdcCertficationDesc` = b.`cdcCertficationDesc`
--         AND a.`cdcCertDate` = b.`cdcCertDate`
        ) c
WHERE
    NOT `AYSOID.2` IS NULL
    ORDER BY `Name`, `SAR`; 


