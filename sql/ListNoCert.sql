
SELECT 
    AdminID,
    MY,
    CONCAT(EXTRACTNUMBER(`League`),
            '/',
            RIGHT(`League`, 1),
            '/',
            EXTRACTNUMBER(`Club`)) AS `SAR`,
    FirstName,
    LastName,
    FORMAT_DATE(DOB) AS DOB,
    GenderCode AS Gender,
    email,
    refGrade1 AS CertficationDesc,
    refObtainDate1 AS CertificationDate,
    RiskStatus,
    FORMAT_DATE(RiskExpireDate) AS RiskExpireDate
FROM
    (SELECT 
        *,
            @rank:=IF(@id = `AdminID` AND `MY` < @my, @rank + 1, 1) AS rank,
            @id:=`AdminID`,
            @my:=`MY`
    FROM
        (SELECT DISTINCT
        AdminID,
            MY,
            `League`,
            `Club`,
            FirstName,
            LastName,
            DOB,
            GenderCode,
            email,
            refGrade1,
            refObtainDate1,
            RiskStatus,
            RiskExpireDate
    FROM
        `AdminCredentialsStatusDynamic`
    WHERE
        `AdminID` IN ('79289-849460' , '29777-130409', '94103-160511', '26209-218637', '57617-985253', '71728-252352', '67374-747558', '49850-788658', '85391-336620', '75285-277461', '18958-215243', '19346-312018', '16596-542068', '79289-849460', '29777-130409', '94103-160511', '26209-218637', '57617-985253')
    ORDER BY `AdminID` , `MY` DESC) ordered) ranked
WHERE
    rank = 1
ORDER BY SAR , LastName;

