SELECT 
    ri.*,
    ra.CertificationDesc,
    ra.CertificationDate,
    rie.AdminID as 'RIE'
FROM
    crs_rpt_ri ri
        INNER JOIN
    crs_rpt_ra ra ON ri.AdminID = ra.AdminID
        LEFT JOIN
    crs_rpt_rie rie ON ri.AdminID = rie.AdminID
WHERE
    ri.CertificationDesc IN ('Advanced Referee Instructor', 'National Referee Instructor')
        AND rie.AdminID IS NULL
        AND ri.`Current`  = 'Yes'
        AND ri.MY IN ('MY2021' , 'MY2022');