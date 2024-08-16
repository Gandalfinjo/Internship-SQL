-- 1.	Prikazati sve vrednosti iz Lookup tabele koje se ne odnose na Jurisdiction (koristiti LEFT JOIN)

select
	l.Id,
	l.[Name],
	l.[Status],
	l.CreatedOn,
	l.LastUpdatedOn,
	l.CreatedBy_Id,
	l.LastUpdatedBy_Id,
	l.Parent_Id,
	l.[Order]
from [Lookup] l left join Jurisdiction j on l.Id = j.Id
where j.Id is null;

-- 2.	Prikazati sve vrednosti iz Lookup tabele koje se ne odnose na Jurisdiction (koristiti RIGHT JOIN)

select
	l.Id,
	l.[Name],
	l.[Status],
	l.CreatedOn,
	l.LastUpdatedOn,
	l.CreatedBy_Id,
	l.LastUpdatedBy_Id,
	l.Parent_Id,
	l.[Order]
from Jurisdiction j right join [Lookup] l on j.Id = l.Id
where j.Id is null;

-- 3.	Prikazati sve vrednosti iz Lookup tabele koje se ne odnose na PracticeArea (koristiti LEFT JOIN)

select
	l.Id,
	l.[Name],
	l.[Status],
	l.CreatedOn,
	l.LastUpdatedOn,
	l.CreatedBy_Id,
	l.LastUpdatedBy_Id,
	l.Parent_Id,
	l.[Order]
from [Lookup] l left join PracticeArea p on l.Id = p.Id
where p.Id is null;

-- 4.	Prikazati sve vrednosti iz Lookup tabele koje se ne odnose na PracticeArea (koristiti RIGHT JOIN)

select
	l.Id,
	l.[Name],
	l.[Status],
	l.CreatedOn,
	l.LastUpdatedOn,
	l.CreatedBy_Id,
	l.LastUpdatedBy_Id,
	l.Parent_Id,
	l.[Order]
from PracticeArea p right join [Lookup] l on l.Id = p.Id
where p.Id is null;

-- 5.	Prikazati sve vrednosti iz Lookup tabele koje se ne odnose na IndustrySector (koristiti LEFT JOIN)

select
	l.Id,
	l.[Name],
	l.[Status],
	l.CreatedOn,
	l.LastUpdatedOn,
	l.CreatedBy_Id,
	l.LastUpdatedBy_Id,
	l.Parent_Id,
	l.[Order]
from [Lookup] l left join IndustrySector i on l.Id = i.Id
where i.Id is null;

-- 6.	Prikazati sve vrednosti iz Lookup tabele koje se ne odnose na IndustrySector (koristiti RIGHT JOIN)

select
	l.Id,
	l.[Name],
	l.[Status],
	l.CreatedOn,
	l.LastUpdatedOn,
	l.CreatedBy_Id,
	l.LastUpdatedBy_Id,
	l.Parent_Id,
	l.[Order]
from IndustrySector i right join [Lookup] l on l.Id = i.Id
where i.Id is null;

-- 9.	Prikazati sve vrednosti iz Lookup tabele koje se ne odnose na LayerTier (koristiti LEFT JOIN)

select
	l.Id,
	l.[Name],
	l.[Status],
	l.CreatedOn,
	l.LastUpdatedOn,
	l.CreatedBy_Id,
	l.LastUpdatedBy_Id,
	l.Parent_Id,
	l.[Order]
from [Lookup] l left join LawyerTier lt on l.Id = lt.Id
where lt.Id is null;

-- 10.	Prikazati sve vrednosti iz Lookup tabele koje se ne odnose na LayerTier (koristiti RIGHT JOIN)

select
	l.Id,
	l.[Name],
	l.[Status],
	l.CreatedOn,
	l.LastUpdatedOn,
	l.CreatedBy_Id,
	l.LastUpdatedBy_Id,
	l.Parent_Id,
	l.[Order]
from LawyerTier lt right join [Lookup] l on l.Id = lt.Id
where lt.Id is null;

-- 11.	Prikazati sledece kolone iz tabele Firm (Id, Name, [Country/GlobalFirm]). Kolona [Country/GlobalFirm] treba da prikaze vezan Country name (Country_Id) za firmu ukoliko firma ima Country. Ukoliko nema, treba da prikaze vezanu globalnu firmu - naziv globalne firme (GlobalFirm_Id). Ukoliko nema Globalnu firmu treba da prikaze 'N/A'.

select
	f.Id,
	f.[Name],
	case
		when f.Country_Id is not null then c.[Name]
		when f.GlobalFirm_Id is not null and f.Country_Id is null then f2.[Name]
		else 'N/A'
	end as 'Country/GlobalFirm'
from Firm f
left join Country c		on f.Country_Id = c.Id
left join Firm f2		on f.GlobalFirm_Id = f2.Id;

-- 12.	Prikazati sledece kolone iz tabele Firm (Id, Name, Address). Kolonu Address pravimo na osnovu spoljnog kljuca Address_Id. Ideja je da prikazemo samo one kolone iz tabele Address koje imaju vrednost u sledecem redosledu: Line1 Line2 Line3 POBox, Country. Ona polja iz tabele Address koja nemaju vrednost ne prikazujemo. Country prikazujemo na osnovu spoljnog kljuca Country_Id (napraviti vezu sa Country) I prikazati naziv zemlje. Naziv zemlje takodje prikazujemo samo ako postoji.

select
	f.Id,
	f.[Name],
	trim(concat(a.Line1, ' ', a.Line2, ' ', a.Line3, ' ', a.POBox, ' ', c.[Name])) as [Address]
from Firm f
inner join [Address] a		on f.Address_Id = a.Id
inner join Country c		on a.Country_Id = c.Id;

-- 13.	Prikazati sledece kolone iz tabele Firm (Id, Name, Logo, IconRecognition, Advert, IconRecognition2). Logo, IconRecognition, Advert, IconRecognition2 izvuci na osnovu njihovih spoljnih kljuceva iz relevantne tabele kao FileName. Ukoliko nemaju vrednosti u spoljnom kljucu, prikazati prazan string.

select
	f.Id,
	f.[Name],
	isnull(f1.OriginalFileName, '') as Logo,
	isnull(f2.OriginalFileName, '') as IconRecognition,
	isnull(a.ImageName, '') as Advert,
	isnull(f3.OriginalFileName, '') as IconRecognition2
from Firm f left join [File] f1		on f.Logo_Id = f1.Id
left join [File] f2					on f.IconRecognition_Id = f2.Id
left join Advert a					on f.Advert_Id = a.Id
left join [File] f3					on f.IconRecognition2_Id = f3.Id;

-- 14.	Prikazati sve kolone iz tabele Firm I umesto spoljnih kljuceva prikazati vrednosti entiteta koji spoljni kljuc pokazuje (prikazati Name, Title, Value, sto god od toga povezani entitet poseduje). Ideja je da ne vidim nikakve spoljne kljuceve u svom izvestaju, vec njihove vrednosti. Nazivi takvih kolona ne treba da imaju _Id kao sufix. Gde nema vrednosti u spoljnom kljucu, prikazati kao prazan string.

select
	f.Id,
	f.[Name],
	case
		when c.Id is null then ''
		else c.[Name]
	end as Country,
	case
		when gf.Id is null then ''
		else trim(concat(f.Id, ' ', f.[Name], ' ', f.Country_Id, ' ', f.GlobalFirm_Id, ' ', f.IsSponsored, ' ', f.[Description], ' ', f.EntityStatus, ' ', f.Address_Id, ' ', f.Phone, ' ', f.Fax, ' ', f.Email, ' ', f.Web, ' ', f.FirmType, ' ', f.Editor_Id, ' ', f.Logo_Id, ' ', f.IconRecognition_Id, ' ', f.Advert_Id, ' ', f.IconRecognition2_Id, ' ', f.CreatedOn, ' ', f.LastUpdatedOn, ' ', f.CreatedBy_Id, ' ', f.LastUpdatedBy_Id, ' ', f.UpdatedForNextYear, ' ', f.EMLUpgrade, ' ', f.InsightUrl, ' ', f.InsightImage_Id, ' ', f.ProfileType, ' ', 	f.SubmissionToolId))
	end as GlobalFirm,
	f.IsSponsored,
	f.[Description],
	f.EntityStatus,
	case
		when a.Id is null then ''
		else trim(concat(a.Line1, ' ', a.Line2, ' ', a.Line3, ' ', a.POBox, ' ', c.[Name]))
	end as [Address],
	f.Phone,
	f.Fax,
	f.Email,
	f.Web,
	f.FirmType,
	case
		when e.Id is null then ''
		else trim(concat(e.Email, ' ', e.Forename, ' ', e.Surname, ' ', e.[Role]))
	end as Editor,
	case
		when logo.Id is null then ''
		else trim(concat(logo.StorageFileId, ' ', logo.OriginalFileName, ' ', logo.Category, ' ', logo.Active))
	end as Logo,
	case
		when ir.Id is null then ''
		else trim(concat(ir.StorageFileId, ' ', ir.OriginalFileName, ' ', ir.Category, ' ', ir.Active))
	end as IconRecognition,
	case
		when ad.Id is null then ''
		else trim(concat(ad.ImageName, ' ', ad.[Url], ' ', ad.Active))
	end as Advert,
	case
		when ir2.Id is null then ''
		else trim(concat(ir2.StorageFileId, ' ', ir2.OriginalFileName, ' ', ir2.Category, ' ', ir2.Active))
	end as IconRecognition2,
	f.CreatedOn,
	f.LastUpdatedOn,
	case
		when cr.Id is null then ''
		else trim(concat(cr.Email, ' ', cr.Forename, ' ', cr.Surname, ' ', cr.[Role]))
	end as CreatedBy,
	case
		when lu.Id is null then ''
		else trim(concat(lu.Email, ' ', lu.Forename, ' ', lu.Surname, ' ', lu.[Role]))
	end as LastUpdatedBy,
	f.UpdatedForNextYear,
	f.EMLUpgrade,
	f.InsightUrl,
	case
		when ins.Id is null then ''
		else trim(concat(ins.StorageFileId, ' ', ins.OriginalFileName, ' ', ins.Category, ' ', ins.Active))
	end as InsightImage,
	f.ProfileType,
	f.SubmissionToolId
from Firm f
left join Country c			on f.Country_Id = c.Id
left join Firm gf			on f.GlobalFirm_Id = gf.Id
left join [Address] a		on f.Address_Id = a.Id
left join [User] e			on f.Editor_Id = e.Id
left join [File] logo		on f.Logo_Id = logo.Id
left join [File] ir			on f.IconRecognition_Id = ir.Id
left join Advert ad			on f.Advert_Id = ad.Id
left join [File] ir2		on f.IconRecognition2_Id = ir2.Id
left join [User] cr			on f.CreatedBy_Id = cr.Id
left join [User] lu			on f.LastUpdatedBy_Id = lu.Id
left join [File] ins		on f.InsightImage_Id = ins.Id;

-- 15.	Prikazati sve kolone iz tabele LawyerReview. Umesto spoljnih kljuceva prikazati vrednosti entiteta koji spoljni kljuc pokazuje. Gde nema vrednosti u spoljnom kljucu, prikazati kao prazan string.

select
	lr.Id,
	lr.EntityStatus,
	lr.Overview,
	case
		when j.Id is null then ''
		else trim(concat(jl.[Name], ' ', jl.[Status], ' ', jl.CreatedOn, ' ', jl.LastUpdatedOn, ' ', jl.CreatedBy_Id, ' ', jl.LastUpdatedBy_Id, ' ', jl.Parent_Id, ' ', jl.[Order]))
	end as Jurisdiction,
	case
		when l.Id is null then ''
		else trim(concat(l.Id, ' ',	l.FirstName, ' ', l.LastName, ' ', l.Phone, ' ', l.Fax, ' ', l.Email, ' ', l.Web, ' ', l.[Language], ' ', l.EntityStatus, ' ', l.Address_Id, ' ', l.Advert_Id, ' ',	l.Country_Id, ' ', l.Editor_Id, ' ', l.IconRecognition_Id, ' ', l.IconRecognition2_Id, ' ',	l.Logo_Id, ' ', l.JobPosition, ' ',	l.IsSponsored, ' ', l.LinkedInUrl, ' ', l.CreatedOn, ' ', l.LastUpdatedOn, ' ', l.CreatedBy_Id, ' ', l.LastUpdatedBy_Id, ' ', l.AdminEmail, ' ', l.Tier_Id, ' ', l.SourceOfInformation, ' ', l.IsNotificationSent, ' ', l.InsightUrl, ' ', l.InsightImage_Id))
	end as Lawyer,
	case
		when p.Id is null then ''
		else p.[Year]
	end as [Period],
	lr.CreatedOn,
	lr.LastUpdatedOn,
	case
		when cr.Id is null then ''
		else trim(concat(cr.Email, ' ', cr.Forename, ' ', cr.Surname, ' ', cr.[Role]))
	end as CreatedBy,
	case
		when e.Id is null then ''
		else trim(concat(e.Email, ' ', e.Forename, ' ', e.Surname, ' ', e.[Role]))
	end as Editor,
	case
		when lu.Id is null then ''
		else trim(concat(lu.Email, ' ', lu.Forename, ' ', lu.Surname, ' ', lu.[Role]))
	end as LastUpdatedBy
from LawyerReview lr
left join Jurisdiction j		on lr.Jurisdiction_Id = j.Id
left join [Lookup] jl			on j.Id = jl.Id
left join Lawyer l				on lr.Lawyer_Id = l.Id
left join [Period] p			on lr.Period_Id = p.Id
left join [User] cr				on lr.CreatedBy_Id = cr.Id
left join [User] e				on lr.Editor_Id = e.Id
left join [User] lu				on lr.LastUpdatedBy_Id = lu.Id;

-- 16.	Prikazati sve jurisdikcije [Jurisdiction] za koje ne postoji nijedan [LawyerReview].

select j.Id
from Jurisdiction j left join LawyerReview l on j.Id = l.Jurisdiction_Id
where l.Jurisdiction_Id is null;

-- 17.	Prikazati sve [Lawyer] entitete za koje ne postiji nijedan LawyerReview

select
	l.Id,
	l.FirstName,
	l.LastName,
	l.Phone,
	l.Fax,
	l.Email,
	l.Web,
	l.[Language],
	l.EntityStatus,
	l.Address_Id,
	l.Advert_Id,
	l.Country_Id,
	l.Editor_Id,
	l.IconRecognition_Id,
	l.IconRecognition2_Id,
	l.Logo_Id,
	l.JobPosition,
	l.IsSponsored,
	l.LinkedInUrl,
	l.CreatedOn,
	l.LastUpdatedOn,
	l.CreatedBy_Id,
	l.LastUpdatedBy_Id,
	l.AdminEmail,
	l.Tier_Id,
	l.SourceOfInformation,
	l.IsNotificationSent,
	l.InsightUrl,
	l.InsightImage_Id
from Lawyer l left join LawyerReview lr on l.Id = lr.Lawyer_Id
where lr.Lawyer_Id is null;

-- 18.	Prikazati sledece kolone iz tabele [LawyerReview]: Id, Lawyer.FirstName, Lawyer.LastName, JurisdictionName koji se odnose na 2020 I 2018 godinu.

select
	lr.Id,
	l.FirstName,
	l.LastName,
	lk.[Name] as JurisdictionName
from LawyerReview lr
inner join Lawyer l			on lr.Lawyer_Id = l.Id
inner join Jurisdiction j	on lr.Jurisdiction_Id = j.Id
inner join [Lookup] lk		on j.Id = lk.Id
where year(lr.CreatedOn) = '2020' or year(lr.CreatedOn) = '2018';

-- 19.	Prikazati sledece kolone iz tabele [PracticeAreaLawyer]: Sledece podatke iz tabele lawyer: FirstName, LastName, Email, Address, JobPosition. Sledeci podatak iz tabele PracticeArea: Name

select
	l.FirstName,
	l.LastName,
	l.Email,
	trim(concat(a.Line1, ' ', a.Line2, ' ', a.Line3, ' ', a.POBox)) as [Address],
	l.JobPosition,
	lk.[Name]
from PracticeAreaLawyer pl
inner join Lawyer l				on pl.Lawyer_Id = l.Id
inner join [Address] a			on l.Address_Id = a.Id
inner join PracticeArea p		on pl.PracticeArea_Id = p.Id
inner join [Lookup] lk			on p.Id = lk.Id;

-- 20.	Prikazati sve laywer-e iz tabele [LawyerRanking] koji imaju Ranking Tier: Expert consultant

select
	l.Id,
	l.FirstName,
	l.LastName,
	l.Phone,
	l.Fax,
	l.Email,
	l.Web,
	l.[Language],
	l.EntityStatus,
	l.Address_Id,
	l.Advert_Id,
	l.Country_Id,
	l.Editor_Id,
	l.IconRecognition_Id,
	l.IconRecognition2_Id,
	l.Logo_Id,
	l.JobPosition,
	l.IsSponsored,
	l.LinkedInUrl,
	l.CreatedOn,
	l.LastUpdatedOn,
	l.CreatedBy_Id,
	l.LastUpdatedBy_Id,
	l.AdminEmail,
	l.Tier_Id,
	l.SourceOfInformation,
	l.IsNotificationSent,
	l.InsightUrl,
	l.InsightImage_Id,
	lk.[Name]
from Lawyer l
inner join LawyerRanking lr	on l.Id = lr.Lawyer_Id
inner join LawyerTier lt	on lr.Tier_Id = lt.Id
inner join [Lookup] lk		on lt.Id = lk.Id
where lk.[Name] = 'Expert consultant';

-- 21.	Prikazati sve laywer-e iz tabele [LawyerRanking] koji imaju Ranking Tier: Rising star partner

select
	l.Id,
	l.FirstName,
	l.LastName,
	l.Phone,
	l.Fax,
	l.Email,
	l.Web,
	l.[Language],
	l.EntityStatus,
	l.Address_Id,
	l.Advert_Id,
	l.Country_Id,
	l.Editor_Id,
	l.IconRecognition_Id,
	l.IconRecognition2_Id,
	l.Logo_Id,
	l.JobPosition,
	l.IsSponsored,
	l.LinkedInUrl,
	l.CreatedOn,
	l.LastUpdatedOn,
	l.CreatedBy_Id,
	l.LastUpdatedBy_Id,
	l.AdminEmail,
	l.Tier_Id,
	l.SourceOfInformation,
	l.IsNotificationSent,
	l.InsightUrl,
	l.InsightImage_Id,
	lk.[Name]
from Lawyer l
inner join LawyerRanking lr	on l.Id = lr.Lawyer_Id
inner join LawyerTier lt	on lr.Tier_Id = lt.Id
inner join [Lookup] lk		on lt.Id = lk.Id
where lk.[Name] = 'Rising star partner';

-- 22.	Prikazati sve laywer-e iz tabele [LawyerRanking] koji nemaju Ranking Tier: Women Leaders

select
	l.Id,
	l.FirstName,
	l.LastName,
	l.Phone,
	l.Fax,
	l.Email,
	l.Web,
	l.[Language],
	l.EntityStatus,
	l.Address_Id,
	l.Advert_Id,
	l.Country_Id,
	l.Editor_Id,
	l.IconRecognition_Id,
	l.IconRecognition2_Id,
	l.Logo_Id,
	l.JobPosition,
	l.IsSponsored,
	l.LinkedInUrl,
	l.CreatedOn,
	l.LastUpdatedOn,
	l.CreatedBy_Id,
	l.LastUpdatedBy_Id,
	l.AdminEmail,
	l.Tier_Id,
	l.SourceOfInformation,
	l.IsNotificationSent,
	l.InsightUrl,
	l.InsightImage_Id,
	lk.[Name]
from Lawyer l
inner join LawyerRanking lr	on l.Id = lr.Lawyer_Id
inner join LawyerTier lt	on lr.Tier_Id = lt.Id
inner join [Lookup] lk		on lt.Id = lk.Id
where lk.[Name] = 'Women Leaders';

-- 23.	Prikazati sve laywer-r koji nemaju Ranking uopste

select
	l.Id,
	l.FirstName,
	l.LastName,
	l.Phone,
	l.Fax,
	l.Email,
	l.Web,
	l.[Language],
	l.EntityStatus,
	l.Address_Id,
	l.Advert_Id,
	l.Country_Id,
	l.Editor_Id,
	l.IconRecognition_Id,
	l.IconRecognition2_Id,
	l.Logo_Id,
	l.JobPosition,
	l.IsSponsored,
	l.LinkedInUrl,
	l.CreatedOn,
	l.LastUpdatedOn,
	l.CreatedBy_Id,
	l.LastUpdatedBy_Id,
	l.AdminEmail,
	l.Tier_Id,
	l.SourceOfInformation,
	l.IsNotificationSent,
	l.InsightUrl,
	l.InsightImage_Id
from Lawyer l
left join LawyerRanking lr on l.Id = lr.Lawyer_Id
where lr.Lawyer_Id is null;

-- 24.	Prikazati sledece kolone iz tabele [RankingTierFirm]: Firm.Id, Firm.Name, Jurisdiction.Name, Period, PracticeArea, Tier.Name

select
	f.Id as FirmId,
	f.[Name] as FirmName,
	l1.[Name] as JuristictionName,
	p.[Year] as [Period],
	l2.[Name] as PracticeArea,
	l3.[Name] as TierName
from RankingTierFirm r
inner join Firm f			on r.Firm_Id = f.Id
inner join FirmRanking fr	on r.FirmRanking_Id = fr.Id
inner join Jurisdiction j	on fr.Jurisdiction_Id = j.Id
inner join [Lookup] l1		on j.Id = l1.Id
inner join [Period] p		on fr.Period_Id = p.Id
inner join PracticeArea pa	on fr.PracticeArea_Id = pa.Id
inner join [Lookup] l2		on pa.Id = l2.Id
inner join FirmTier ft		on r.Tier_Id = ft.Id
inner join [Lookup] l3		on ft.Id = l3.Id;

-- 25.	Prikazati iz samo firme koje imaju ranking 'Tier 1' u jurisdikciji 'Australia' (glavne dve tabele - ne I jedine neophodne za ovaj upit: [RankingTierFirm], FirmRanking)

select
	f.Id,
	f.[Name],
	f.Country_Id,
	f.GlobalFirm_Id,
	f.IsSponsored,
	f.[Description],
	f.EntityStatus,
	f.Address_Id,
	f.Phone,
	f.Fax,
	f.Email,
	f.Web,
	f.FirmType,
	f.Editor_Id,
	f.Logo_Id,
	f.IconRecognition_Id,
	f.Advert_Id,
	f.IconRecognition2_Id,
	f.CreatedOn,
	f.LastUpdatedOn,
	f.CreatedBy_Id,
	f.LastUpdatedBy_Id,
	f.UpdatedForNextYear,
	f.EMLUpgrade,
	f.InsightUrl,
	f.InsightImage_Id,
	f.ProfileType,
	f.SubmissionToolId,
	l1.[Name] as Tier,
	l2.[Name] as Jurisdiction
from Firm f
inner join RankingTierFirm rtf	on f.Id = rtf.Firm_Id
inner join FirmTier ft			on rtf.Tier_Id = ft.Id
inner join [Lookup] l1			on ft.Id = l1.Id
inner join FirmRanking fr		on rtf.FirmRanking_Id = fr.Id
inner join Jurisdiction j		on fr.Jurisdiction_Id = j.Id
inner join [Lookup] l2			on j.Id = l2.Id
where l1.[Name] = 'Tier 1' and l2.[Name] = 'Australia';

-- 26.	Prikazati iz samo firme koje imaju ranking 'Tier 3' u jurisdikciji 'China' (glavne dve tabele - ne I jedine neophodne za ovaj upit: [RankingTierFirm], FirmRanking)

select
	f.Id,
	f.[Name],
	f.Country_Id,
	f.GlobalFirm_Id,
	f.IsSponsored,
	f.[Description],
	f.EntityStatus,
	f.Address_Id,
	f.Phone,
	f.Fax,
	f.Email,
	f.Web,
	f.FirmType,
	f.Editor_Id,
	f.Logo_Id,
	f.IconRecognition_Id,
	f.Advert_Id,
	f.IconRecognition2_Id,
	f.CreatedOn,
	f.LastUpdatedOn,
	f.CreatedBy_Id,
	f.LastUpdatedBy_Id,
	f.UpdatedForNextYear,
	f.EMLUpgrade,
	f.InsightUrl,
	f.InsightImage_Id,
	f.ProfileType,
	f.SubmissionToolId,
	l1.[Name] as Tier,
	l2.[Name] as Jurisdiction
from Firm f
inner join RankingTierFirm rtf	on f.Id = rtf.Firm_Id
inner join FirmTier ft			on rtf.Tier_Id = ft.Id
inner join [Lookup] l1			on ft.Id = l1.Id
inner join FirmRanking fr		on rtf.FirmRanking_Id = fr.Id
inner join Jurisdiction j		on fr.Jurisdiction_Id = j.Id
inner join [Lookup] l2			on j.Id = l2.Id
where l1.[Name] = 'Tier 3' and l2.[Name] = 'China';

-- 27.	Prikazati iz samo firme koje imaju ranking 'Tier 3' u jurisdikciji 'China' (glavne dve tabele - ne I jedine neophodne za ovaj upit: [RankingTierFirm], FirmRanking)

select
	f.Id,
	f.[Name],
	f.Country_Id,
	f.GlobalFirm_Id,
	f.IsSponsored,
	f.[Description],
	f.EntityStatus,
	f.Address_Id,
	f.Phone,
	f.Fax,
	f.Email,
	f.Web,
	f.FirmType,
	f.Editor_Id,
	f.Logo_Id,
	f.IconRecognition_Id,
	f.Advert_Id,
	f.IconRecognition2_Id,
	f.CreatedOn,
	f.LastUpdatedOn,
	f.CreatedBy_Id,
	f.LastUpdatedBy_Id,
	f.UpdatedForNextYear,
	f.EMLUpgrade,
	f.InsightUrl,
	f.InsightImage_Id,
	f.ProfileType,
	f.SubmissionToolId,
	l1.[Name] as Tier,
	l2.[Name] as Jurisdiction
from Firm f
inner join RankingTierFirm rtf	on f.Id = rtf.Firm_Id
inner join FirmTier ft			on rtf.Tier_Id = ft.Id
inner join [Lookup] l1			on ft.Id = l1.Id
inner join FirmRanking fr		on rtf.FirmRanking_Id = fr.Id
inner join Jurisdiction j		on fr.Jurisdiction_Id = j.Id
inner join [Lookup] l2			on j.Id = l2.Id
where l1.[Name] = 'Tier 3' and l2.[Name] = 'China';

--28.	Prikazati iz samo firme koje imaju ranking 'Tier 1' u jurisdikciji 'Barbados' u 2014. godini (glavne dve tabele - ne I jedine neophodne za ovaj upit: [RankingTierFirm], FirmRanking)

select
	f.Id,
	f.[Name],
	f.Country_Id,
	f.GlobalFirm_Id,
	f.IsSponsored,
	f.[Description],
	f.EntityStatus,
	f.Address_Id,
	f.Phone,
	f.Fax,
	f.Email,
	f.Web,
	f.FirmType,
	f.Editor_Id,
	f.Logo_Id,
	f.IconRecognition_Id,
	f.Advert_Id,
	f.IconRecognition2_Id,
	f.CreatedOn,
	f.LastUpdatedOn,
	f.CreatedBy_Id,
	f.LastUpdatedBy_Id,
	f.UpdatedForNextYear,
	f.EMLUpgrade,
	f.InsightUrl,
	f.InsightImage_Id,
	f.ProfileType,
	f.SubmissionToolId,
	l1.[Name] as Tier,
	l2.[Name] as Jurisdiction,
	p.[Year]
from Firm f
inner join RankingTierFirm rtf	on f.Id = rtf.Firm_Id
inner join FirmTier ft			on rtf.Tier_Id = ft.Id
inner join [Lookup] l1			on ft.Id = l1.Id
inner join FirmRanking fr		on rtf.FirmRanking_Id = fr.Id
inner join Jurisdiction j		on fr.Jurisdiction_Id = j.Id
inner join [Lookup] l2			on j.Id = l2.Id
inner join [Period] p			on fr.Period_Id = p.Id
where l1.[Name] = 'Tier 1' and l2.[Name] = 'Barbados' and p.[Year] = '2014';