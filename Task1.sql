-- 1. Poslednjih (CreatedDate) 10 artikala koji su IsSponsored

select top 10 *
from Article
where IsSponsored = 1
order by CreateDate desc;

-- 2. Poslednjih 20 (CreatedDate) artikala koji u svom nazivu (Title) imaju 'Legal'

select top 20 *
from Article
where Title like '%Legal%'
order by CreateDate desc;

-- 3. Poslednjih 10 (CreatedDate) artikala koji u svom nazivu (Title) pocinju sa 'Legal'

select top 10 *
from Article
where Title like 'Legal%'
order by CreateDate desc;

-- 4. Poslednjih 20 (CreatedDate) artikala koji u svom nazivu (Title) zavrsavaju sa 'Legal'

select top 20 *
from Article
where Title like '%Legal'
order by CreateDate desc;

-- 5. Prvih 10 (CreatedDate) artikala kojima se zavrsavaju (ExpireDate) u 2019 godinu

select top 10 *
from Article
where year([ExpireDate]) = '2019'
order by CreateDate asc;

-- 5. Sve artikle kojima je rok zavrsetka u (ExpireDate) u sledecem periodu: 01.09.2018 - 31.12.2018

select *
from Article
where [ExpireDate] between '2018-09-01' and '2018-12-31';

-- 6. Sve artikle kojima je rok zavrsetka u (ExpireDate) u sledecem periodu: 01.01.2019 - 31.12.2020, prikazati samo odredjene kolone: Id, Title, Author, IsSponsored. IsSponsored ne zelimo da prikazemo kao nule i jedinice vec zelimo da ih prikazemo kao Yes/No

select
	Id,
	Title,
	Author,
	case IsSponsored
		when 0 then 'No'
		when 1 then 'Yes'
	end as IsSponsored
from Article
where [ExpireDate] between '2019-01-01' and '2020-12-31';

-- 7. Najvise 10 artikala koji imaju najvecu posecenost (NumberOfVisits) koji su napravljeni 2018 i 2019 godine

select top 10 *
from Article
where year(CreateDate) = '2018' or year(CreateDate) = '2019'
order by NumberOfVisits desc;

-- 8. Poslednjih (CreatedDate) 100 artikala cija duzina Title ne prelazi 30 karaktera

select top 100 *
from Article
where len(Title) <= 30
order by CreateDate desc;

-- 9. Poslednjih (CreatedDate) 200 artikala (zelim sve kolone iz tabele) i ne zelim da vidim nijednu NULL vrednost. Umesto NULL vrednosti prikazati N/A

-- Proverio sam u tabeli koje kolone su nullable i samo sam za njih radio case, da ne bih dzabe za sve radio.

-- Sponsor_Id, Author, Location, Image_Id, ExternalId, CreatedBy_Id, Editor_Id, LastUpdatedBy_Id

select top 200
	Id,
	EntityStatus,
	IsFeatured,
	Title,
	ShortDescription,
	Body,
	Period_Id,
	case
		when Sponsor_Id IS NULL then 'N/A'
		else convert(varchar(10), Sponsor_Id)
	end as Sponsor_Id,
	[Type_Id],
	CreateDate,
	case
		when Author IS NULL then 'N/A'
		else Author
	end as Author,
	case
		when [Location] IS NULL then 'N/A'
		else [Location]
	end as [Location],
	NumberOfVisits,
	case
		when Image_Id IS NULL then 'N/A'
		else convert(varchar(10), Image_Id)
	end as Image_Id,
	[ExpireDate],
	case
		when ExternalId IS NULL then 'N/A'
		else convert(varchar(10), ExternalId)
	end as ExternalId,
	IsSponsored,
	IsTopFeatured,
	CreatedOn,
	LastUpdatedOn,
	case
		when CreatedBy_Id IS NULL then 'N/A'
		else convert(varchar(10), CreatedBy_Id)
	end as CreatedBy_Id,
	case
		when Editor_Id IS NULL then 'N/A'
		else convert(varchar(10), Editor_Id)
	end as Editor_Id,
	case
		when LastUpdatedBy_Id IS NULL then 'N/A'
		else convert(varchar(10), LastUpdatedBy_Id)
	end as LastUpdatedBy_Id
from Article
order by CreateDate desc;

-- 10. Smatramo da su artikli poverljivi ako u svom Title imaju kljucnu rec: Panama. Zelim da prikazem prvih (ExpiryDate) 500 artikala (zelim sve kolone iz tabele, osim Body) koji su poverljivi, da prikazem dodatnu kolonu SecretYear: koja treba da izgleda ovako: Secret {ExpiryDate.Year} number of visits {NumberOfVisits} da budu sortirani po NumberOfVisits u opadajucem redosledu

select top 500
	Id,
	EntityStatus,
	IsFeatured,
	Title,
	ShortDescription,
	Period_Id,
	Sponsor_Id,
	[Type_Id],
	CreateDate,
	Author,
	[Location],
	NumberOfVisits,
	Image_Id,
	[ExpireDate],
	ExternalId,
	IsSponsored,
	IsTopFeatured,
	CreatedOn,
	LastUpdatedOn,
	CreatedBy_Id,
	Editor_Id,
	LastUpdatedBy_Id,
	'Secret ' + convert(varchar(10), year([ExpireDate])) + ' number of visits ' + convert(varchar(10), NumberOfVisits) as SecretYear
from Article
where Title like '%Panama%'
order by [ExpireDate] asc, NumberOfVisits desc;

-- 11. Zelim da napravim izvestaj i da tekstualno opisem kakva je posecenost artikala bila (NumberOfVisits). Smatram da je artikal slabo posecen ako je imao manje od 1000 pregleda. Smatram da je artikal srednje posecen ako je imao izmedju 1000 i 2000 pregleda. Smatram da je artikal visoko posecen ako je imao vise od 3000 pregleda. Dodatna kolona u kojoj je opisana posecenost treba da se zove 'NumberOfVisitsDescriptive'. Kolone koje zelim da prikazem su: Id, Title, NumberOfVisitsDescriptive. Izvestaj treba da bude sortiran po Article.Title u rastucem redosledu.

-- Stavio sam 'nepoznato' u slucaju izmedju 2000 i 3000 posto tu nista nije receno.

select
	Id,
	Title,
	case
		when NumberOfVisits < 1000 then 'slabo posecen'
		when NumberOfVisits between 1000 and 2000 then 'srednje posecen'
		when NumberOfVisits > 3000 then 'visoko posecen'
		else 'nepoznato'
	end as NumberOfVisitsDescriptive
from Article
order by Title asc;

-- 12. Prikazati sve firme (tabela Firm) koje imaju email adresu (Email). Smatra se da firma ima email adresu AKKO polje nije null i ako polje ima vrednost

select *
from Firm
where Email is not null and Email != '';

-- 13. Prikazati sve firme koje imaju u isto vreme email adresu i web adresu (Web).

select *
from Firm
where Email is not null and Email != '' and Web is not null and Web != '';

-- 14. Prikazati sve firme koje nemaju email adresu (Email).

select *
from Firm
where Email is null or Email = '';

-- 15. Prikazati sve firme koje nemaju email adresu i nemaju web adresu (Web).

select *
from Firm
where (Email is null or Email = '') and (Web is null or Web = '');

-- 16. Prikazati sve firme koje imaju web adresu ali nemaju email adresu.

select *
from Firm
where (Email is null or Email = '') and (Web is not null and Web != '');

-- 17. Prikazati sve firme koje imaju Logo (Logo_Id)

select *
from Firm
where Logo_Id is not null;

-- 18. Prikazati sve firme koje nemaju Logo (Logo_Id)

select *
from Firm
where Logo_Id is null;

-- 19. Prikazati sve firme koje imaju Logo i koje su update-ovane u poslednje 3 godine

select *
from Firm
where Logo_Id is not null and LastUpdatedOn >= dateadd(year, -3, getdate());

-- 20. Prikazati sve Artikle koji imaju ExpireDate u poslednja 3 meseca od trenutka izvrsenja querija

select *
from Article
where [ExpireDate] >= dateadd(month, -3, getdate()) and [ExpireDate] < getdate();

-- 21. Prikazati sve Artikle koji imaju ExpireDate u poslednjih 30 dana od trenutka izvrsenja querija

select *
from Article
where [ExpireDate] >= dateadd(day, -30, getdate()) and [ExpireDate] < getdate();

-- 22. Prikazati sve Artikle koji imaju ExpireDate u buducnosti od trenutka izvrsenja querija

-- Ako ne ogranicim broj redova, predugo se izvrsava query.

select top 300 *
from Article
where [ExpireDate] >= getdate();

-- 23. Prikazati sve artikle koji se odnose na Mexico (Location) i koji imaju NumberOfVisits veci od 100

select *
from Article
where Location = 'Mexico' and NumberOfVisits > 100;

-- 24. Napraviti izvestaj koji ima sledece kolone: Id, TitleAuthorNumberOfVisits Kolona TitleAuthorNumberOfVisits treba da bude u sledecem formatu: {Title} - Author: {Author}, number of visits: {NumberOfVisits} za sve artikle koji nisu istekli (ExpireDate)

select
	Id,
	Title + ' - Author: ' + Author + ', number of visits: ' + convert(varchar(10), NumberOfVisits) as TitleAuthorNumberOfVisits
from Article
where [ExpireDate] >= getdate();

-- 25. Prikazati koji sve razliciti domeni postoje medju advokatima (Layer) na osnovu njihove email adrese (gde email adresa postoji)

select distinct 
	substring(Email, charindex('@', Email) + 1, len(Email) - charindex('@', Email)) as Domain
from Lawyer
where Email is not null and Email != '';

-- 26. Prikazati sve razlicite domene email adresa medju advokatima (Layer) od advokata koji su poslednji put update-ovani u poslednjem kvartalu 2023 godine

select distinct 
	substring(Email, charindex('@', Email) + 1, len(Email) - charindex('@', Email)) as Domain
from Lawyer
where Email is not null and Email != '' and LastUpdatedOn >= '2023-10-01' and LastUpdatedOn < '2024-01-01';