SELECT 
    *
FROM
    1_Instructor_Import i
        LEFT JOIN
    crs_rpt_ri c ON c.`AYSOID` = i.`Admin ID`
WHERE
    i.`Instructor Course Access` LIKE '%Instructor%'

ORDER BY i.`Admin ID`;



SELECT 
    *
FROM
    1_Instructor_Import i
        LEFT JOIN
    crs_rpt_ra c ON c.`AYSOID` = i.`Admin ID`
WHERE
    i.`Instructor Course Access` LIKE '%Assessor%'

ORDER BY i.`Admin ID`;
