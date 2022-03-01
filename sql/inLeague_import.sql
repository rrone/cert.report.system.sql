SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

SELECT 
    `AYSOID`, `MY`, `FirstName`, `LastName`
FROM
    (SELECT 
        *,
            @rankID:=IF(@id = `AYSOID`, @rankID + 1, 1) AS rankID,
            @id:=`AYSOID`
    FROM
        (SELECT DISTINCT
        `Section`,
            `Area`,
            `Region`,
            `AYSOID`,
            `Membershipyear` AS 'MY',
            `Volunteer Position`,
            `LastName`,
            `FirstName`,
            `DOB`,
            `Gender`
    FROM
        ayso1ref_services.inLeague_registration
    GROUP BY `AYSOID` , `MY` DESC) grouped) ranked
WHERE
    rankID = 1
ORDER BY `AYSOID` , `MY` DESC;