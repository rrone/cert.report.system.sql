
/*******************************
*
*	Clean up temporary tables
*
********************************/

/* DROP TEMPORARY TABLE IF EXIST */

IF OBJECT_ID('tempdb..#MYList') IS NOT NULL
DROP TABLE #MYList
GO

IF OBJECT_ID('tempdb..#FinalList') IS NOT NULL
DROP TABLE #FinalList
GO

IF OBJECT_ID('tempdb..#RegionList') IS NOT NULL
DROP TABLE #RegionList
GO

IF OBJECT_ID('tempdb..#Temp1') IS NOT NULL
DROP TABLE #Temp1
GO

IF OBJECT_ID('tempdb..#Temp2') IS NOT NULL
DROP TABLE #Temp2
GO

IF OBJECT_ID('tempdb..#RCList') IS NOT NULL
DROP TABLE #RCList
GO

IF OBJECT_ID('tempdb..#ADList') IS NOT NULL
DROP TABLE #ADList
GO 

IF OBJECT_ID('tempdb..#RegistrationSummaryByAge') IS NOT NULL
DROP TABLE #RegistrationSummaryByAge
GO

IF OBJECT_ID('tempdb..#RegistrationSummaryBoysByAge') IS NOT NULL
DROP TABLE #RegistrationSummaryBoysByAge
GO
IF OBJECT_ID('tempdb..#RegistrationSummaryGirlsByAge') IS NOT NULL
DROP TABLE #RegistrationSummaryGirlsByAge
GO

/* Loop Range variables MYID: 42 = 2018, 41 = 2017, ..., 27 = 2003 etc */
DECLARE @myidMax INT = 42
DECLARE @myidMin INT = 27

/* Loop variables */
DECLARE @myid INT
DECLARE @MembershipYear VARCHAR(10)

/* CREATE Ouput Aggregate Table */
CREATE TABLE #FinalList (
id NUMERIC IDENTITY(1,1) PRIMARY KEY,
Section VARCHAR(10),
Area VARCHAR(10),
Region NUMERIC,
RC VARCHAR(200),
[RC Email] VARCHAR(200),
[RC HomePhone] VARCHAR(20),
AD VARCHAR(200),
[AD Email] VARCHAR(200),
[AD HomePhone] VARCHAR(20),
[U04 Boys] NUMERIC,
[U04 Girls] NUMERIC,
[U05 Boys] NUMERIC,
[U05 Girls] NUMERIC,
[U06 Boys] NUMERIC,
[U06 Girls] NUMERIC,
[U08 Boys] NUMERIC,
[U08 Girls] NUMERIC,
[U10 Boys] NUMERIC,
[U10 Girls] NUMERIC,
[U12 Boys] NUMERIC,
[U12 Girls] NUMERIC,
[U14 Boys] NUMERIC,
[U14 Girls] NUMERIC,
[U16 Boys] NUMERIC,
[U16 Girls] NUMERIC,
[U19 Boys] NUMERIC,
[U19 Girls] NUMERIC,
[SP Boys] NUMERIC,
[SP Girls] NUMERIC,
[MYID] NUMERIC,
[MY] VARCHAR(10)
)

/* CREATE MY Table to contain selections and aggregates from #FinalList */
CREATE TABLE #MYList (
id NUMERIC,
Section VARCHAR(10),
Area VARCHAR(10),
Region NUMERIC,
RC VARCHAR(200),
[RC Email] VARCHAR(200),
[RC HomePhone] VARCHAR(20),
AD VARCHAR(200),
[AD Email] VARCHAR(200),
[AD HomePhone] VARCHAR(20),
[U04 Boys] NUMERIC,
[U04 Girls] NUMERIC,
[U04] NUMERIC,
[U05 Boys] NUMERIC,
[U05 Girls] NUMERIC,
[U05] NUMERIC,
[U06 Boys] NUMERIC,
[U06 Girls] NUMERIC,
[U06] NUMERIC,
[U08 Boys] NUMERIC,
[U08 Girls] NUMERIC,
[U08] NUMERIC,
[U10 Boys] NUMERIC,
[U10 Girls] NUMERIC,
[U10] NUMERIC,
[U12 Boys] NUMERIC,
[U12 Girls] NUMERIC,
[U12] NUMERIC,
[U14 Boys] NUMERIC,
[U14 Girls] NUMERIC,
[U14] NUMERIC,
[U16 Boys] NUMERIC,
[U16 Girls] NUMERIC,
[U16] NUMERIC,
[U19 Boys] NUMERIC,
[U19 Girls] NUMERIC,
[U19] NUMERIC,
[VIP Boys] NUMERIC,
[VIP Girls] NUMERIC,
[VIP] NUMERIC,
[MYID] NUMERIC,
[MY] VARCHAR(10)
)

/* CREATE intermediate tables */
CREATE TABLE #RegionList
(
ID NUMERIC IDENTITY,
RegionID NUMERIC
)

CREATE TABLE #Temp1
(
DivisionName VARCHAR(10),
Gender CHAR(2),
PCount NUMERIC
)

CREATE TABLE #Temp2
(
DivisionName VARCHAR(10),
Gender CHAR(2),
PCount NUMERIC
)

CREATE TABLE #RCList
(
ID NUMERIC IDENTITY,
RegionID NUMERIC,
RC VARCHAR(200),
Email VARCHAR(200),
HomePhone VARCHAR(20)
)

CREATE TABLE #ADList
(
ID NUMERIC IDENTITY,
RegionID NUMERIC,
AD VARCHAR(200),
Email VARCHAR(200),
HomePhone VARCHAR(20)
)

/* Loop variable */
SET @myid = @myIDMax

/* Loop over MY 42 = 2018, 41 = 2017, etc */
WHILE @myid >= @myidMin
BEGIN

SET @MembershipYear = CONCAT('MY', 1976 + @myid)

/* Empty intermedate tables for each MY */
TRUNCATE TABLE #RegionList
TRUNCATE TABLE #Temp1
TRUNCATE TABLE #Temp2
TRUNCATE TABLE #RCList
TRUNCATE TABLE #ADList

INSERT INTO #RCList
SELECT DISTINCT AYV.RegionID, V.FirstName + ' ' + V.LastName AS [RC], ISNULL(VCI.Email,'') AS Email, ISNULL(CONVERT(VARCHAR(20),VCI.HomePhone),'') AS HomePhone
FROM VolunteerPost VP, Volunteer V, VolunteerContactInfo VCI, Region AYV 
WHERE V.VolunteerID = VP.VolunteerID AND V.VolunteerContactInfoID = VCI.VolunteerContactInfoID AND AYV.RegionID = VP.SARID AND ScopeID = 4 
AND RoleID = 72 AND CONVERT(DATE,EndDate) > CONVERT(DATE,GETDATE()) AND VP.VolunteerPostID NOT IN (3793202,6441436)
AND VP.VolunteerPostID IN (SELECT MIN(VolunteerPostID) FROM VolunteerPost WHERE ScopeID = 4 AND SARID = VP.SARID AND RoleID = 72 AND CONVERT(DATE,EndDate) > CONVERT(DATE,GETDATE()))
AND V.AYSOID NOT IN (20100000,30100000)

INSERT INTO #ADList
SELECT DISTINCT AYV.RegionID, V.FirstName + ' ' + V.LastName AS [AD], ISNULL(VCI.Email,'') AS Email, ISNULL(CONVERT(VARCHAR(20),VCI.HomePhone),'') AS HomePhone
FROM VolunteerPost VP, Volunteer V, VolunteerContactInfo VCI, ayv_SectionAreaRegion AYV 
WHERE V.VolunteerID = VP.VolunteerID AND V.VolunteerContactInfoID = VCI.VolunteerContactInfoID AND AYV.AreaID = VP.SARID AND ScopeID = 3 
AND RoleID = 52 AND CONVERT(DATE,EndDate) > CONVERT(DATE,GETDATE()) AND VP.VolunteerPostID NOT IN (3793202,6441436)
AND VP.VolunteerPostID IN (SELECT MIN(VolunteerPostID) FROM VolunteerPost WHERE ScopeID = 3 AND SARID = VP.SARID AND RoleID = 52 AND CONVERT(DATE,EndDate) > CONVERT(DATE,GETDATE()))
AND V.AYSOID NOT IN (20100000,30100000)

DECLARE @I NUMERIC, @Count NUMERIC, @RegionID NUMERIC
INSERT INTO #RegionList 
SELECT RegionID FROM ayv_SectionAreaRegion ORDER BY RegionNumber

SET @I = 1
SET @Count = (SELECT COUNT(*) FROM #RegionList) 

WHILE(@I <= @Count) 
BEGIN
	SELECT @RegionID = RegionID FROM #RegionList WHERE ID = @I


--SELECT @RegionID = RegionID FROM region WHERE adultleague <> 'A' AND RegionNumber = @RegionID

PRINT @RegionID

INSERT INTO #Temp1
SELECT  CASE D.DivisionName
          WHEN 'U-07' THEN 'U-08'
          WHEN 'U-09' THEN 'U-10'
          WHEN 'U-11' THEN 'U-12'
          WHEN 'U-13' THEN 'U-14'				
          WHEN 'U-15' THEN 'U-16'
          WHEN 'U-17' THEN 'U-19'
          ELSE D.DivisionName
        END AS DivisionName,
        Gender,
        COUNT(*) AS [Count]
FROM    Player P,
        dbo.PlayerMembershipYear PMY,
        dbo.RegionDivision RD,
        dbo.Division D,
        dbo.ayv_SectionAreaRegion A
WHERE   P.PlayerID = PMY.PlayerID
        AND PMY.PlayerStatus NOT IN ( 'A' )
        AND PMY.MembershipYearID = @myid
        AND RD.RegionDivisionID = PMY.RegionDivisionID
        AND D.DivisionID = RD.DivisionID
        AND A.RegionID = PMY.RegionID
        AND (D.DivisionID < 10 or D.DivisionID = 27)
        AND A.RegionID = @RegionID
        AND D.DivisionName <> 'VIP'
GROUP BY Gender,
        CASE D.DivisionName
          WHEN 'U-07' THEN 'U-08'
          WHEN 'U-09' THEN 'U-10'
          WHEN 'U-11' THEN 'U-12'
          WHEN 'U-13' THEN 'U-14'
          WHEN 'U-15' THEN 'U-16'
          WHEN 'U-17' THEN 'U-19'
          ELSE D.DivisionName
        END 
ORDER BY DivisionName


INSERT INTO #Temp2
SELECT  CASE WHEN ( D.DivisionName LIKE 'SP%' OR D.DivisionName LIKE 'VIP' ) THEN 'SP'
          ELSE D.DivisionName
        END AS DivisionName,
        Gender,
        COUNT(*) AS [Count]
FROM    Player P,
        dbo.PlayerMembershipYear PMY,
        dbo.RegionDivision RD,
        dbo.Division D,
        ayv_SectionAreaRegion A
WHERE   P.PlayerID = PMY.PlayerID
        AND PMY.PlayerStatus NOT IN ( 'A')
        AND PMY.MembershipYearID = @myid
        AND RD.RegionDivisionID = PMY.RegionDivisionID
        AND D.DivisionID = RD.DivisionID
           AND A.RegionID = PMY.RegionID
        AND D.DivisionID >=9 AND D.DivisionID <=19
        AND A.RegionID = @RegionID
GROUP BY Gender,
        CASE WHEN ( D.DivisionName LIKE 'SP%' OR D.DivisionName LIKE 'VIP' ) THEN 'SP'
          ELSE D.DivisionName
        END 
ORDER BY DivisionName

/* update final list with this MY data */
INSERT INTO #FinalList ([Section],[Area],[Region],[RC],[RC Email],[RC HomePhone],[AD],[AD Email],[AD HomePhone],[U04 Boys],[U04 Girls],[U05 Boys],[U05 Girls],[U06 Boys],[U06 Girls],[U08 Boys],[U08 Girls],[U10 Boys],[U10 Girls],[U12 Boys],[U12 Girls],[U14 Boys],[U14 Girls],[U16 Boys],[U16 Girls],[U19 Boys],[U19 Girls],[SP Boys],[SP Girls],[MYID],[MY])

SELECT (SELECT TOP 1 SectionName FROM ayv_SectionAreaRegion WHERE RegionID = @RegionID),
(SELECT TOP 1 AreaName FROM ayv_SectionAreaRegion WHERE RegionID = @RegionID),
(SELECT RegionNumber FROM Region WHERE RegionID = @RegionID),
(SELECT TOP 1 ISNULL(RC,'') FROM #RCList WHERE RegionID = @RegionID ORDER BY ID),
(SELECT TOP 1 ISNULL(Email,'') FROM #RCList WHERE RegionID = @RegionID ORDER BY ID),
(SELECT TOP 1 ISNULL(HomePhone,'') FROM #RCList WHERE RegionID = @RegionID ORDER BY ID),
(SELECT TOP 1 ISNULL(AD,'') FROM #ADList WHERE RegionID = @RegionID ORDER BY ID),
(SELECT TOP 1 ISNULL(Email,'') FROM #ADList WHERE RegionID = @RegionID ORDER BY ID),
(SELECT TOP 1 ISNULL(HomePhone,'') FROM #ADList WHERE RegionID = @RegionID ORDER BY ID),
ISNULL((SELECT PCount FROM #Temp1 WHERE DivisionName = 'U-04' AND Gender = 'B'),'0') AS [U-04 Boys Count],
ISNULL((SELECT PCount FROM #Temp1 WHERE DivisionName = 'U-04' AND Gender = 'G'),'0') AS [U-04 Girls Count],
ISNULL((SELECT PCount FROM #Temp1 WHERE DivisionName = 'U-05' AND Gender = 'B'),'0') AS [U-05 Boys Count],
ISNULL((SELECT PCount FROM #Temp1 WHERE DivisionName = 'U-05' AND Gender = 'G'),'0') AS [U-05 Girls Count],
ISNULL((SELECT PCount FROM #Temp1 WHERE DivisionName = 'U-06' AND Gender = 'B'),'0') AS [U-06 Boys Count],
ISNULL((SELECT PCount FROM #Temp1 WHERE DivisionName = 'U-06' AND Gender = 'G'),'0') AS [U-06 Girls Count],
ISNULL((SELECT PCount FROM #Temp1 WHERE DivisionName = 'U-08' AND Gender = 'B'),'0') AS [U-08 Boys Count],
ISNULL((SELECT PCount FROM #Temp1 WHERE DivisionName = 'U-08' AND Gender = 'G'),'0') AS [U-08 Girls Count],
ISNULL((SELECT PCount FROM #Temp1 WHERE DivisionName = 'U-10' AND Gender = 'B'),'0') AS [U-10 Boys Count],
ISNULL((SELECT PCount FROM #Temp1 WHERE DivisionName = 'U-10' AND Gender = 'G'),'0') AS [U-10 Girls Count],
ISNULL((SELECT PCount FROM #Temp1 WHERE DivisionName = 'U-12' AND Gender = 'B'),'0') AS [U-12 Boys Count],
ISNULL((SELECT PCount FROM #Temp1 WHERE DivisionName = 'U-12' AND Gender = 'G'),'0') AS [U-12 Girls Count],
ISNULL((SELECT PCount FROM #Temp1 WHERE DivisionName = 'U-14' AND Gender = 'B'),'0') AS [U-14 Boys Count],
ISNULL((SELECT PCount FROM #Temp1 WHERE DivisionName = 'U-14' AND Gender = 'G'),'0') AS [U-14 Girls Count],
ISNULL((SELECT PCount FROM #Temp1 WHERE DivisionName = 'U-16' AND Gender = 'B'),'0') AS [U-16 Boys Count],
ISNULL((SELECT PCount FROM #Temp1 WHERE DivisionName = 'U-16' AND Gender = 'G'),'0') AS [U-16 Girls Count],
ISNULL((SELECT PCount FROM #Temp1 WHERE DivisionName = 'U-19' AND Gender = 'B'),'0') AS [U-19 Boys Count],
ISNULL((SELECT PCount FROM #Temp1 WHERE DivisionName = 'U-19' AND Gender = 'G'),'0') AS [U-19 Girls Count],
ISNULL((SELECT PCount FROM #Temp2 WHERE DivisionName = 'SP' AND Gender = 'B'),'0') AS [SP Boys Count],
ISNULL((SELECT PCount FROM #Temp2 WHERE DivisionName = 'SP' AND Gender = 'G'),'0') AS [SP Girls Count],
@myid AS [MYID],
@MembershipYear AS [MY]  

	SET @I = @I + 1
	DELETE FROM #Temp1
	DELETE FROM #Temp2

END  /* #RegionList loop */

/* next myid */
SET @myid = @myid - 1
END

/* update #MYList with combined gender columns */
INSERT INTO #MYList
SELECT 
id,
Section, 
Area, 
Region, 
ISNULL(RC,'') AS RC, 
ISNULL([RC Email],'') AS [RC Email], 
ISNULL([RC HomePhone],'') AS [RC HomePhone], 
ISNULL(AD,'') AS AD, 
ISNULL([AD Email],'') AS [AD Email], 
ISNULL([AD HomePhone],'') AS [AD HomePhone],
[U04 Boys], [U04 Girls], [U04 Boys] + [U04 Girls] AS [U04],
[U05 Boys], [U05 Girls], [U05 Boys] + [U05 Girls] AS [U05],
[U06 Boys], [U06 Girls], [U06 Boys] + [U06 Girls] AS [U06],
[U08 Boys], [U08 Girls], [U08 Boys] + [U08 Girls] AS [U08],
[U10 Boys], [U10 Girls], [U10 Boys] + [U10 Girls] AS [U10],
[U12 Boys], [U12 Girls], [U12 Boys] + [U12 Girls] AS [U12],
[U14 Boys], [U14 Girls], [U14 Boys] + [U14 Girls] AS [U14],
[U16 Boys], [U16 Girls], [U16 Boys] + [U16 Girls] AS [U16],
[U19 Boys], [U19 Girls], [U19 Boys] + [U19 Girls] AS [U19],
[SP Boys] AS [VIP Boys], [SP Girls] AS [VIP Girls], [SP Boys] + [SP Girls] AS [VIP],
[MYID],
[MY]  
FROM #FinalList

/* show the final list: export by "Copy with Headers" in Results window. Paste into file MYList.csv */
SELECT * FROM #MYList

/*******************************
*
*	Analysis code
*
********************************/

DECLARE @MY VARCHAR(10)

/*******************************
*
*	Registration Summary by MY by Age
*
********************************/

CREATE TABLE #RegistrationSummaryByAge(
  id NUMERIC IDENTITY(1,1) PRIMARY KEY,
  MY VARCHAR(10) DEFAULT NULL,
  [U-04] int DEFAULT 0,
  [U-05] int DEFAULT 0,
  [U-06] int DEFAULT 0,
  [U-08] int DEFAULT 0,
  [U-10] int DEFAULT 0,
  [U-12] int DEFAULT 0,
  [U-14] int DEFAULT 0,
  [U-16] int DEFAULT 0,
  [U-19] int DEFAULT 0
)

/* Initialize Loop variable */
SET @myid = @myIDMax

/* Loop over MY 42 = 2018, 41 = 2017, etc for #RegistrationSummaryByAge */
WHILE @myid >= @myidMin
BEGIN

SET @MY = CONCAT('MY', 1976 + @myid)

INSERT INTO #RegistrationSummaryByAge ([MY], [U-04], [U-05], [U-06], [U-08], [U-10], [U-12], [U-14], [U-16], [U-19]) 

SELECT
    @MY 'MY',
    SUM([U04]) [U-04],
    SUM([U05]) [U-05],
    SUM([U06]) [U-06],
    SUM([U08]) AS [U-08],
    SUM([U10]) AS [U-10],
    SUM([U12]) AS [U-12],
    SUM([U14]) AS [U-14],
    SUM([U16]) AS [U-16],
    SUM([U19]) AS [U-19]
FROM
    #MYList
WHERE
    [Section]< 15 AND [MY] = @MY;

SET @myid = @myid -1
END	/* Loop #RegistrationSummaryByAge */

SELECT * FROM #RegistrationSummaryByAge;

/*******************************
*
*	Registration Summary Boys by MY by Age
*
********************************/

CREATE TABLE #RegistrationSummaryBoysByAge(
  id NUMERIC IDENTITY(1,1) PRIMARY KEY,
  MY VARCHAR(10) DEFAULT NULL,
  [U-04B] int DEFAULT 0,
  [U-05B] int DEFAULT 0,
  [U-06B] int DEFAULT 0,
  [U-08B] int DEFAULT 0,
  [U-10B] int DEFAULT 0,
  [U-12B] int DEFAULT 0,
  [U-14B] int DEFAULT 0,
  [U-16B] int DEFAULT 0,
  [U-19B] int DEFAULT 0
)

/* Initialize Loop variable */
SET @myid = @myIDMax

/* Loop over MY 42 = 2018, 41 = 2017, etc for #RegistrationSummaryByAge */
WHILE @myid >= @myidMin
BEGIN

SET @MY = CONCAT('MY', 1976 + @myid)

INSERT INTO #RegistrationSummaryBoysByAge ([MY], [U-04B], [U-05B], [U-06B], [U-08B], [U-10B], [U-12B], [U-14B], [U-16B], [U-19B]) 

SELECT
    @MY 'MY',
    SUM([U04 Boys]) [U-04B],
    SUM([U05 Boys]) [U-05B],
    SUM([U06 Boys]) [U-06B],
    SUM([U08 Boys]) [U-08B],
    SUM([U10 Boys]) [U-10B],
    SUM([U12 Boys]) [U-12B],
    SUM([U14 Boys]) [U-14B],
    SUM([U16 Boys]) [U-16B],
    SUM([U19 Boys]) [U-19B]
FROM
    #MYList
WHERE
    [Section]< 15 AND [MY] = @MY;

SET @myid = @myid -1
END	/* Loop ##RegistrationSummaryBoysByAge */

SELECT * FROM #RegistrationSummaryBoysByAge;

/*******************************
*
*	Registration Summary Girls by MY by Age
*
********************************/

CREATE TABLE #RegistrationSummaryGirlsByAge(
  id NUMERIC IDENTITY(1,1) PRIMARY KEY,
  MY VARCHAR(10) DEFAULT NULL,
  [U-04G] int DEFAULT 0,
  [U-05G] int DEFAULT 0,
  [U-06G] int DEFAULT 0,
  [U-08G] int DEFAULT 0,
  [U-10G] int DEFAULT 0,
  [U-12G] int DEFAULT 0,
  [U-14G] int DEFAULT 0,
  [U-16G] int DEFAULT 0,
  [U-19G] int DEFAULT 0
)

/* Initialize Loop variable */
SET @myid = @myIDMax

/* Loop over MY 42 = 2018, 41 = 2017, etc for #RegistrationSummaryByAge */
WHILE @myid >= @myidMin
BEGIN

SET @MY = CONCAT('MY', 1976 + @myid)

INSERT INTO #RegistrationSummaryGirlsByAge ([MY], [U-04G], [U-05G], [U-06G], [U-08G], [U-10G], [U-12G], [U-14G], [U-16G], [U-19G]) 

SELECT
    @MY 'MY',
    SUM([U04 Girls]) [U-04G],
    SUM([U05 Girls]) [U-05G],
    SUM([U06 Girls]) [U-06G],
    SUM([U08 Girls]) [U-08G],
    SUM([U10 Girls]) [U-10G],
    SUM([U12 Girls]) [U-12G],
    SUM([U14 Girls]) [U-14G],
    SUM([U16 Girls]) [U-16G],
    SUM([U19 Girls]) [U-19G]
FROM
    #MYList
WHERE
    [Section]< 15 AND [MY] = @MY;

SET @myid = @myid -1
END	/* Loop ##RegistrationSummaryGirlsByAge */

SELECT * FROM #RegistrationSummaryGirlsByAge;

