-- 1.	Napraviti view na osnovu SQL upita iz prethodne vezbe broj 1 sa nazivom [vFirmPracticeAreasStats_VaseImePrezime]. Napraviti select iz tako napravljenog view-a. Rezultate view-a prepuniti u #temp tabelu. Napraviti select iz tako napravljene #temp tabele. Obrisati temp tabelu.

create view [dbo].[vFirmPracticeAreasStats_DraganPeric] as
select paf.Firm_Id, f.[Name], count(*) as PracticeAreaCount
from PracticeAreaFirm paf inner join Firm f on f.Id = paf.Firm_Id
group by paf.Firm_Id, f.[Name]

go

select *
into #tempFirmPracticeAreasStats
from [dbo].[vFirmPracticeAreasStats_DraganPeric];

select *
from #tempFirmPracticeAreasStats;

drop table #tempFirmPracticeAreasStats

go

-- 2.	Napraviti view na osnovu SQL upita iz prethodne vezbe broj 10 sa nazivom [vCountryRelatedFirms_VaseImePrezime]. Napraviti select iz tako napravljenog view-a. Napraviti select is napravljenog view-a, za sve zemlje koje imaju vise od 1000 povezanih firmi. Takav select prepuniti u #temp tabelu. Obrisati temp tabelu

create view [dbo].[vCountryRelatedFirms_DraganPeric] as
select c.[Name], count(*) as FirmCount, string_agg(cast(f.[Name] as varchar(max)), ', ') as FirmList
from Firm f inner join Country c on f.Country_Id = c.Id
group by c.[Name]

go

select *
into #tempCountryRelatedFirms
from [dbo].[vCountryRelatedFirms_DraganPeric]
where FirmCount > 1000;

select *
from #tempCountryRelatedFirms;

drop table #tempCountryRelatedFirms

go

-- 3.	Napraviti kopiju postojeceg view-a [vFirmPracticeAreasStats] sa sledecim nazivom: [vFirmPracticeAreasStats_VaseImePrezime]

create view [dbo].[vFirmPracticeAreasStats_DraganPeric_v2] as
select *
from [dbo].[vFirmPracticeAreasStats]

go

select *
from [dbo].[vFirmPracticeAreasStats_DraganPeric_v2]

go

-- 4.	Update-ovati view: [vFirmPracticeAreasStats_VaseImePrezime] - dodati bilo kakvu kolonu, moze I fiksni string, svejedno.

alter view [dbo].[vFirmPracticeAreasStats_DraganPeric_v2] as
select Id, [Name], [Ukupan broj povezanih practice area-a], 'Dragan' as NewColumn
from [dbo].[vFirmPracticeAreasStats]

go

select *
from [dbo].[vFirmPracticeAreasStats_DraganPeric_v2]

go

-- 5.	Napraviti view na osnovu SQL upita iz prethodne vezbe broj 14 sa nazivom [vDealWithValueGreaterThanAverage_VaseImePrezime]. Tako napravljeni view iskoristiti za novi upit I povezati sa DealLawyer-ima, na nacin da izvestaj ima isti broj redova kao I sam view, a lawyer-e zelim da prikazem grupisane po Deal-u {FirstName} {LastName} kao comma separated vrednosti.

create view [dbo].[vDealWithValueGreaterThanAverage_DraganPeric] as
select Id, Title
from Deal
where [Value] > (
	select avg([Value])
	from Deal
	where [Value] > 0
);

go

select v.Id, v.Title, string_agg(cast(l.FirstName + ' ' + l.LastName as varchar(max)), ', ') as LawyerList
from [dbo].[vDealWithValueGreaterThanAverage_DraganPeric] v
left join (DealLawyer dl inner join Lawyer l on dl.Lawyer_Id = l.Id) on v.Id = dl.Deal_Id
group by v.Id, v.Title

-- 6.	Napraviti skalarnu funkciju koja spaja dva stringa.

-- ======================================================
-- Create Scalar Function Template for Azure SQL Database
-- ======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Dragan Peric
-- Create Date: 12.9.2024.
-- Description: Spajanje dva stringa
-- =============================================
CREATE FUNCTION [dbo].[fnConcatenateTwoStrings_DraganPeric]
(
    @string1 nvarchar(max),
	@string2 nvarchar(max)
)
RETURNS nvarchar(max)
AS
BEGIN
    RETURN @string1 + @string2
END
GO

select [dbo].[fnConcatenateTwoStrings_DraganPeric]('Concatenated', 'String!') as ConcatenatedString;

-- 7.	Napraviti skalarnu funkciju ce na dati datetime da dodaje odredjen broj dana I vraca rezultat kao novi datetime.

-- ======================================================
-- Create Scalar Function Template for Azure SQL Database
-- ======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Dragan Peric
-- Create Date: 12.9.2024.
-- Description: Dodavanje dana na dati datetime
-- =============================================
CREATE FUNCTION [dbo].[fnAddDaysDatetime_DraganPeric]
(
    @startDate datetime,
	@days int
)
RETURNS datetime
AS
BEGIN
    return dateadd(day, @days, @startDate)
END
GO

select [dbo].[fnAddDaysDatetime_DraganPeric]('2024-09-30 10:18:00', 3);

-- 8.	Iskoristiti funkciju koja spaja dva stringa, I izlistati sve lawyer-e iz baze. Izvestaj treba da ima sledece kolone: Lawyer.Id, FirstNameLastName.

select l.Id, [dbo].[fnConcatenateTwoStrings_DraganPeric](l.FirstName, l.LastName) as FirstNameLastName
from Lawyer l;

-- 9.	Iskoristiti funkciju iz tacke 8, da se prikazu svi artikli kojima ExpireDate istekao pre nedelju dana.

select *
from Article
where [ExpireDate] = [dbo].[fnAddDaysDatetime_DraganPeric](current_date, -7);

-- 10.	Napraviti tabelarnu funkciju koja vraca sve Practice Area entitete u sledecem obliku: Id, Name

-- ===========================================================================================
-- Create Inline Function Template for Azure SQL Database and Azure Synapse Analytics Database
-- ===========================================================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Dragan Peric
-- Create date: 12.9.2024.
-- Description:	Practice Area u obliku: Id, Name
-- =============================================
CREATE FUNCTION [dbo].[fnPracticeArea_DraganPeric]
()
RETURNS TABLE 
AS
RETURN 
(
	select pa.Id, l.[Name]
	from PracticeArea pa inner join [Lookup] l on pa.Id = l.Id
)
GO

select *
from [dbo].[fnPracticeArea_DraganPeric]();

-- 11.	Iskoristiti tabelarnu funkciju iz tacke 11 I napraviti izvestaj da se prikazu sve firme koje su vezane za navedenu practice area. Izvestaj treba da ima isto redova kao I funkcija. Firme prikazati kao pipe separated.

select fn.Id, fn.[Name], string_agg(cast(f.[Name] as nvarchar(max)), ' | ') as FirmList
from [dbo].[fnPracticeArea_DraganPeric]() fn
left join (Firm f inner join PracticeAreaFirm paf on f.Id = paf.Firm_Id) on fn.Id = paf.PracticeArea_Id
group by fn.Id, fn.[Name];

-- 12.	Napraviti sp za zadatak broj 1 iz group by unit-a; Procedura treba da se zove [spFirmPracticeAreas_VaseImePrezime]

-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Dragan Peric
-- Create Date: 12.9.2024.
-- Description: Firme sa brojem povezanih Practice Area
-- =============================================
CREATE PROCEDURE [dbo].[spFirmPracticeAreas_DraganPeric]
AS
BEGIN
    SET NOCOUNT ON

	select paf.Firm_Id, f.[Name], count(*) as PracticeAreaCount
	from PracticeAreaFirm paf inner join Firm f on f.Id = paf.Firm_Id
	group by paf.Firm_Id, f.[Name];
END
GO

exec [dbo].[spFirmPracticeAreas_DraganPeric]

-- 13.	Napraviti sp za zadatak broj 1 iz group by unit-a; Procedura rezultate iz query-ja treba da napuni u tabelu [ReportFirmPracticeAreas_VaseImePrezime]. Procedura na pocetku izvrsenja treba da proveri da li tabela vec postoji. Ukoliko tabela postoji, procedura treba da je obrise I ponovo kreira I napuni podacima

-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Dragan Peric
-- Create Date: 12.9.2024.
-- Description: 
-- =============================================
CREATE PROCEDURE [dbo].[spReportFirmPracticeAreas_DraganPeric]
AS
BEGIN
    SET NOCOUNT ON

	if object_id(N'dbo.ReportFirmPracticeAreas_DraganPeric', N'U') is not null
		drop table [dbo].[ReportFirmPracticeAreas_DraganPeric];  

    select paf.Firm_Id, f.[Name], count(*) as PracticeAreaCount
	into ReportFirmPracticeAreas_DraganPeric
	from PracticeAreaFirm paf inner join Firm f on f.Id = paf.Firm_Id
	group by paf.Firm_Id, f.[Name];
END
GO

exec [dbo].[spReportFirmPracticeAreas_DraganPeric];

select *
from [dbo].[ReportFirmPracticeAreas_DraganPeric];

-- 14.	Napraviti sp za zadatak broj 14 iz group by unit-a; Procedura treba da se zove [spDealsGreaterThanAverage_VaseImePrezime]. Procedura treba da rezultate iz tabele napuni u novu tabelu [ReportDealsGreaterThanAverage_VaseImePrezime]. Procedura na pocetku izvrsenja treba da proveri da li tabela vec postoji. Ukoliko tabela postoji, procedura treba da je obrise I ponovo kreira I napuni podacima

-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Dragan Peric
-- Create Date: 12.9.2024.
-- Description: Deal-ovi koji imaju Value veci od ukupne prosecne vrednosti svih Deal-ova iz tabele koji imaju Deal veci od 0.
-- =============================================
CREATE PROCEDURE [dbo].[spDealsGreaterThanAverage_DraganPeric]
AS
BEGIN
    SET NOCOUNT ON

	if object_id(N'dbo.ReportDealsGreaterThanAverage_DraganPeric', N'U') is not null
		drop table [dbo].[ReportDealsGreaterThanAverage_DraganPeric]; 

    select Id, Title
	into ReportDealsGreaterThanAverage_DraganPeric
	from Deal
	where [Value] > (
		select avg([Value])
		from Deal
		where [Value] > 0
	);
END
GO

exec [dbo].[spDealsGreaterThanAverage_DraganPeric]

select *
from [dbo].[ReportDealsGreaterThanAverage_DraganPeric]

-- 15.	Napraviti sp koja ce da prima sledece parametre: DealIds, DealValueFrom, DealValueTo I koja ce da izvuce sve deal-ove (Id, Title, Value) za listu dostavljenih comma separated deal-ova (DealIds) gde je [Value] izmedju dosavljenih parametara (DealValueFrom AND DealValueTo). Procedura treba da se zove [spDealByIdsAndValueRange_VaseImePrezime]. Napraviti nekoliko poziva store procedure za razlicite vrednosti parametara

-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Dragan Peric
-- Create Date: 12.9.2024.
-- Description: Deal-ovi sa datim Id-evima sa Value izmedju datih Value-ova
-- =============================================
CREATE PROCEDURE [dbo].[spDealByIdsAndValueRange_DraganPeric]
(
    @DealIds varchar(max),
	@DealValueFrom decimal,
	@DealValueTo decimal
)
AS
BEGIN
    SET NOCOUNT ON

    select Id, Title, [Value]
	from Deal
	where Id in(
		select cast(value as int)
		from string_split(@DealIds, ',')
	) and [Value] between @DealValueFrom and @DealValueTo
END
GO

exec [dbo].[spDealByIdsAndValueRange_DraganPeric] '1,2,3,4,5,6,7,8,9,10', 300000, 1000000

-- Dobijam error: Invalid object name 'string_split'. Na internetu kaze da je to zbog database compatibility-a, pa nisam znao da li to ja smem da diram ovde.

select value
from string_split('1,2,3,4,5,6', ',')

-- 16.	Napraviti proceduru koja ce da se zove [spPopulateNotExpiredArticles_VaseImePrezime]. Procedura treba da proveri da li postoji tabela [reportNotExpiredArticles_VaseImePrezime]. Ukoliko postoji sp treba da je obrise. Sp treba da napravi upit koji treba da ima sledece kolone: a.Id, a.Title, a.ExpiresIn iz tabele [Article]. ExpiresIn predstavlja broj dana od trenutnog vremena do datuma isteka artikla. Rezultat query-ja treba da napuni tabelu [reportNotExpiredArticles_VaseImePrezime].

-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Dragna Peric
-- Create Date: 12.9.2024.
-- Description: Artikli sa brojem dana do njihovog isteka
-- =============================================
CREATE PROCEDURE [dbo].[spPopulateNotExpiredArticles_DraganPeric]
AS
BEGIN
    SET NOCOUNT ON

	drop table if exists [dbo].[reportNotExpiredArticles_DragnaPeric]

	select Id, Title, datediff(day, current_date, [ExpireDate]) as ExpiresIn
	from Article
	where [ExpireDate] > current_date
END
GO

exec [dbo].[spPopulateNotExpiredArticles_DraganPeric]

-- 17. Napraviti sp koja za izvestaj koji je radjen u jednoj od prethodnih vezbi: Prikazati iz samo firme koje imaju ranking 'Tier 1' u jurisdikciji 'Barbados' u 2014. godini (glavne dve tabele - ne I jedine neophodne za ovaj upit: [RankingTierFirm], FirmRanking) sp treba da prima sledece parametre (tierName, jurisdictionName, year) I  da uradi istu stvar kao I upit samo koristeci dostavljene parametere. Napraviti nekoliko primera poziva ka takvoj sp.

-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Dragna Peric
-- Create Date: 12.9.2024.
-- Description: Firme koje imaju dati ranking u datoj jurisdikciji u datoj godini
-- =============================================
CREATE PROCEDURE [dbo].[spFirmRankingJurisdictionYear_DraganPeric]
(
    @tierName nvarchar(max),
	@jurisdictionName nvarchar(max),
	@year nvarchar(max)
)
AS
BEGIN
    SET NOCOUNT ON

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
where l1.[Name] = @tierName and l2.[Name] = @jurisdictionName and p.[Year] = @year;    
END
GO

exec [dbo].[spFirmRankingJurisdictionYear_DraganPeric] 'Tier 1', 'Barbados', '2014'
exec [dbo].[spFirmRankingJurisdictionYear_DraganPeric] 'Tier 3', 'China', '2017'
exec [dbo].[spFirmRankingJurisdictionYear_DraganPeric] 'Tier 2', 'Spain', '2020'
exec [dbo].[spFirmRankingJurisdictionYear_DraganPeric] 'Tier 6', 'Italy', '2013'