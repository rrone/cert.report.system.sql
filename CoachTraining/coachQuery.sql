USE RMS;

SELECT DISTINCT 
	V.AYSOID, 
	V.FirstName, 
	V.LastName, 
	DATEDIFF(hour,V.DOB,GETDATE())/8766 AS Age,
	C.CertificationDesc,
	VC.CertificationDate

FROM [VolunteerCertification] VC, [Certification] C, [Volunteer] V
WHERE V.VolunteerID = VC.VolunteerID
AND C.DisciplineID = 1
AND VC.CertificationID = C.CertificationID
AND DATEDIFF(month,VC.CertificationDate , GETDATE()) <= 12
/* AND V.AYSOID=97815888 */