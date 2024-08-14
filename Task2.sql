-- 1. Napraviti novu tabelu (Firm_{ImePrezime}) po uzoru na postojecu u koju cemo presuti samo Firme koje su sponzorisane (IsSponsored)

select *
into Firm_DraganPeric
from Firm
where IsSponsored = 1;

select *
from Firm_DraganPeric;

-- 2. Napraviti novu tabelu (FirmArticle_{ImePrezime}) koja ce imate kolone Id, Type, Title u koju cemo presuti sve firme i article. Type kolonu u slucaju ako je firma popuniti sa 'Firm', ako je u pitanju Article popuniti sa 'Article'

select
	Id,
	case [Type]
		when 'Firm' then 'Firm'
		when 'Arti' then 'Article'
	end as [Type],
	Title
into FirmArticle_DraganPeric
from FirmArticle;

-- 4. Napraviti novu tabelu, kopiju tabele Firm u tabelu koja ce da nam sluzi za vezbanje update statementa. Nova tabela treba da se zove (FirmForPractice_{ImePrezime}). Isto uraditi i za tabelu Article. Nova tabela treba da se zove (ArticleForPractice_{ImePrezime}). Sve dalje INSERT, UPDATE i DELETE statement-e raditi nad novim tabelama

select *
into FirmForPractice_DraganPeric
from Firm;

select *
into ArticleForPractice_DraganPeric
from Article;

-- 5. Napraviti update statement koji ce da ispravi prazna polja (prazne stringove) u kolona Email i Web tako sto ce da postavi NULL na njih. Polja koja imaju vrednosti ne diramo.

begin transaction

update FirmForPractice_DraganPeric
set Email = NULL
where Email = '';

update FirmForPractice_DraganPeric
set Web = NULL
where Web = '';

rollback
commit

-- 6. Napraviti update statement koji ce da proveri da li su Phone i Fax kolona ista (imaju istu vrednost) ukoliko imaju istu vrednost, kolona Fax treba da se podesi na NULL. Kolonu Phone ne diramo.

begin transaction

update FirmForPractice_DraganPeric
set Fax = NULL
where Phone = Fax;

rollback
commit

-- 7. Napraviti update statement koji ce da ispegla kolonu [Web] na nacin tako sto ce da svaku vrednost koja se zavrsava sa / (http://www.google.com/) da ukloni krajnji / i ostane vrednost npr http://www.google.com

begin transaction

update FirmForPractice_DraganPeric
set Web = substring(Web, 1, len(Web) - 1)
where Web like '%/';

rollback
commit

--8. Ubaciti novi red u tabelu [ArticleForPractice_{ImePrezime}]. Novi red treba da bude kopija vec postojeceg reda koji ima ID 41. Sve numericke vrednosti ostaju iste, sve tekstualne vrednosti treba da imaju dodatu vrednost 'Copy' na kraju svojih vrednosti. Sve datumske vrednosti treba da budu vece za 3 dana u odnosu na inicijalni red. Isprisati u konzoli ID reda koji smo dodali. Skripta treba da bude idempotentna.

begin transaction

declare @lastId int

insert into ArticleForPractice_DraganPeric
select
	EntityStatus,
	IsFeatured,
	concat(Title, ' Copy'),
	concat(ShortDescription, ' Copy'),
	concat(Body, ' Copy'),
	Period_Id,
	Sponsor_Id,
	[Type_Id],
	dateadd(day, 3, CreateDate),
	concat(Author, ' Copy'),
	concat([Location], ' Copy'),
	NumberOfVisits,
	Image_Id,
	dateadd(day, 3, [ExpireDate]),
	ExternalId,
	IsSponsored,
	IsTopFeatured,
	dateadd(day, 3, CreatedOn),
	dateadd(day, 3, LastUpdatedOn),
	CreatedBy_Id,
	Editor_Id,
	LastUpdatedBy_Id
from ArticleForPractice_DraganPeric
where Id = 41

set @lastId = scope_identity()

select @lastId

rollback
commit

-- 9. Update-ovati Article sa ID-jem 59. Title treba da bude 'ŠĐČĆŽ šđčćž ШЂЧЋЖ шђчћж'

begin transaction

update ArticleForPractice_DraganPeric
set Title = N'ŠĐČĆŽ šđčćž ШЂЧЋЖ шђчћж'
where Id = 59;

rollback
commit

-- 10. Iskopirati redove iz tabele Firm i dodati ih kao nove. Redove koje zelimo da iskopiramo imaju sledece ID-jeve (3, 4, 5, 6, 7, 8, 9, 10). Sva tekstualna polja treba da imaju sufix Copy
begin transaction

insert into FirmForPractice_DraganPeric
select
	concat([Name], ' Copy'),
	Country_Id,
	GlobalFirm_Id,
	IsSponsored,
	concat([Description], ' Copy'),
	EntityStatus,
	Address_Id,
	concat(Phone, ' Copy'),
	concat(Fax, ' Copy'),
	concat(Email, ' Copy'),
	concat(Web, ' Copy'),
	FirmType,
	Editor_Id,
	Logo_Id,
	IconRecognition_Id,
	Advert_Id,
	IconRecognition2_Id,
	CreatedOn,
	LastUpdatedOn,
	CreatedBy_Id,
	LastUpdatedBy_Id,
	UpdatedForNextYear,
	EMLUpgrade,
	concat(InsightUrl, ' Copy'),
	InsightImage_Id,
	ProfileType,
	SubmissionToolId
from Firm
where Id in (3, 4, 5, 6, 7, 8, 9, 10)

rollback
commit

-- 11. Napraviti privremenu praznu (temp) tabelu na osnovu Tabele Firm

select top 0 *
into #FirmTemp
from Firm;

select *
from #FirmTemp;

-- 12. Napraviti privremenu temp tabelu sa sledecim kolonama (Identifikator, NazivFirme) u tu tabelu insertovati sve redove iz tabele [Firm]. Firm.Id -> Identifikator, Firm.Name -> NazivFirme. Insertovani redovi treba da budu sortirani po nazivu firme.

select Id as Identifikator, [Name] as NazivFirme
into #FirmTemp2
from Firm
order by [Name];

select *
from #FirmTemp2
order by NazivFirme;