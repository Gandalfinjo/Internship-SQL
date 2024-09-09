-- 1.	Prikazati sledece podatke iz tabele Firm: Firm.Id, Firm.Name, Ukupan broj povezanih practice area-a (tabela [PracticeAreaFirm]) za svaku firmu

select paf.Firm_Id, f.[Name], count(*) as PracticeAreaCount
from PracticeAreaFirm paf inner join Firm f on f.Id = paf.Firm_Id
group by paf.Firm_Id, f.[Name];

-- 2.	Prikazati sledece podatke iz tabele Firm: Firm.Id, Firm.Name, Ukupan broj povezanih practice area-a (tabela [PracticeAreaFirm]) za sve firme koje imaju vise od 5 povezanih practice area-a

select paf.Firm_Id, f.[Name], count(*) as PracticeAreaCount
from PracticeAreaFirm paf inner join Firm f on f.Id = paf.Firm_Id
group by paf.Firm_Id, f.[Name]
having count(*) > 5;

-- 3.	Prikazati sledece podatke iz tabele Firm: Firm.Id, Firm.Name, Ukupan broj povezanih practice area-a (tabela [PracticeAreaFirm]) za sve firme koje imaju manje od 5 povezanih practice area-a

select paf.Firm_Id, f.[Name], count(*) as PracticeAreaCount
from PracticeAreaFirm paf inner join Firm f on f.Id = paf.Firm_Id
group by paf.Firm_Id, f.[Name]
having count(*) < 5;

-- 4.	Prikazati sledece podatke iz tabele Lawyer L: L.Id, L.FirstName, L.LastName, Ukupan broj povezanih practice area-a (tabela [PracticeAreaLawyer]) za svakog lawyer-a

select pal.Lawyer_Id, l.FirstName, l.LastName, count(*) as PracticeAreaCount
from PracticeAreaLawyer pal inner join Lawyer l on l.Id = pal.Lawyer_Id
group by pal.Lawyer_Id, l.FirstName, l.LastName;

-- 5.	Prikazati 10 najzastupljenijih Practice Area koje su vezane za ceo set firmi

select top 10 paf.PracticeArea_Id, count(*) as FirmCount
from PracticeAreaFirm paf inner join Firm f on paf.Firm_Id = f.Id
group by paf.PracticeArea_Id
order by count(*) desc;

-- 6.	Prikazati 20 najzastupljenijih Practice Area koje su vezane za ceo set lawyer-a.

select top 20 pal.PracticeArea_Id, count(*) as LawyerCount
from PracticeAreaLawyer pal inner join Lawyer l on pal.Lawyer_Id = l.Id
group by pal.PracticeArea_Id
order by count(*) desc;

-- 7.	Prikazati 15 najmanje zastupljenih (ali ne I nezastupljenih) Practice Area koje su vezane za ceo set firmi.

select top 15 paf.PracticeArea_Id, count(*) as FirmCount
from PracticeAreaFirm paf inner join Firm f on paf.Firm_Id = f.Id
group by paf.PracticeArea_Id
having count(*) > 0
order by count(*) asc;

-- 8.	Prikazati spisak zemalja sa ukupnim brojem povezanih firmi

select f.Country_Id, c.[Name], count(*) as FirmCount
from Firm f inner join Country c on f.Country_Id = c.Id
group by f.Country_Id, c.[Name];

-- 9.	Prikazati spisak zemalja sa sledecim kolona: Country.Name, Broj povezanih firmi, Lista povezanih firmi odvojenih zarezom (u jednoj celiji)

select c.[Name], count(*) as FirmCount, string_agg(cast(f.[Name] as varchar(max)), ', ') as FirmList
from Firm f inner join Country c on f.Country_Id = c.Id
group by c.[Name];

-- 10.	Prikazati koliko svaki sponsor (Sponsor_Id) ima vezanih artikala ukupno. Izvestaj treba da ima sledece kolone: Sponsor_Id, Naziv Sponsora, Broj vezanih artikala, Lista coma separated Article id-jeva (u jednoj celiji)

select a.Sponsor_Id, f.[Name], count(*) as ArticleCount, string_agg(cast(a.Id as varchar(max)), ', ') as ArticleIdList
from Article a inner join Firm f on a.Sponsor_Id = f.Id
group by a.Sponsor_Id, f.[Name];

-- 11.	Napraviti izvestaj koji ce da ima sledece kolone: Deal.Year, Deal.Month, ukupan broj deal-ova, ukupan iznos deal-ova (DollarValue), prosecnu vrednost deal-ova (DollarValue), minimalnu vrednost deal-ova (DollarValue), maximalnu vrednost deal-ova (DollarValue) za sve Deal-ove koji imaju EntityStatus = 3

select d.[Year], d.[Month], count(*) as TotalDeals, sum(DollarValue) as TotalValue, avg(DollarValue) as AverageValue, min(DollarValue) as MinimumValue, max(DollarValue) as MaximumValue
from Deal d
where d.EntityStatus = 3
group by d.[Year], d.[Month]
order by d.[Year] desc, d.[Month] desc;

-- 12.	Napraviti izvestaj koji ce da prikaze sledece vrednosti: Deal.Id, Deal.Title, sve povezane PracticeArea-a, sve povezane Lawyer-e s, sve povezane jurisdikcije, sve povezane DealGoverningLaw

select
	d.Id,
	d.Title,
	string_agg(cast(dpaLookup.[Name] as varchar(max)), ', ') as PracticeAreaList,
	string_agg(cast(l.FirstName + ' ' + l.LastName as varchar(max)), ', ') as LawyerList,
	string_agg(cast(djLookup.[Name] as varchar(max)), ', ') as JurisdictionList,
	string_agg(cast(gl.Title as varchar(max)), ', ') as DealGoverningLawList
from Deal d inner join DealPracticeArea dpa		on d.Id = dpa.Deal_Id
inner join [Lookup] dpaLookup					on dpa.PracticeArea_Id = dpaLookup.Id
inner join DealLawyer dl						on d.Id = dl.Deal_Id
inner join Lawyer l								on dl.Lawyer_Id = l.Id
inner join DealJurisdiction dj					on d.Id = dj.Deal_Id
inner join [Lookup] djLookup					on dj.Jurisdiction_Id = djLookup.Id
inner join DealGoverningLaw dgl					on d.Id = dgl.Deal_Id
inner join GoverningLaw gl						on dgl.GoverningLaw_Id = gl.Id
group by d.Id, d.Title;

-- 13.	Napraviti izvestaj koji ce da pokaze sve Deal-ove (Deal.Id, Deal.Title) koji imaju Value veci od ukupne prosecne vrednosti svih Deal-ova iz tabele koji imaju Deal veci od 0.

select Id, Title
from Deal
where [Value] > (
	select avg([Value])
	from Deal
	where [Value] > 0
);

-- 14.	Napraviti izvestaj koji ce da prikaze broj Deal-ova napravljenih na odredjeni dan (koristiti polje [CreatedOn]). Izvestaj treba da ima sledece kolone: CreatedOn, CountDeals. Izvestaj treba da bude sortiran tako da pokaze prvo dane sa najvise napravljenih deal-ova

select cast(d.CreatedOn as date) as CreadedOn, count(*) as CountDeals
from Deal d
group by cast(d.CreatedOn as date)
order by count(*) desc;

-- 15.	Napraviti izvestaj koji ce da prikaze ko je od editora uneo u sistem najvise deal-ova, kako bi 3 editora sa najvise deal-ova dobila bonus.

select top 3 d.Editor_Id, u.Forename, u.Surname, count(*) as DealCount
from Deal d inner join [User] u on d.Editor_Id = u.Id
group by d.Editor_Id, u.Forename, u.Surname
order by count(*) desc;

-- 16.	Napraviti izvestaj koji ce da prikaze u svakoj godini ko je od editora napravio najvise izvestaja.

with DealCounts as (
	select year(d.CreatedOn) as [Year], d.Editor_Id, u.Forename, u.Surname, count(*) as DealCount
	from Deal d inner join [User] u on d.Editor_Id = u.Id
	group by year(d.CreatedOn), d.Editor_Id, u.Forename, u.Surname
),
MaxDealCounts as (
	select dc.[Year], max(dc.DealCount) as MaxDealCount
	from DealCounts dc
	group by dc.[Year]
)
select dc.[Year], dc.Editor_Id, dc.Forename, dc.Surname, mdc.MaxDealCount
from DealCounts dc inner join MaxDealCounts mdc on dc.[Year] = mdc.[Year] and dc.DealCount = mdc.MaxDealCount
order by [Year] desc;

-- 17.	Napraviti izvestaj koji ce da izvuce po Currency-ju koliko svaki Currency ima vezanih Deal-ova. Izvestaj treba da ima sledece kolone: CurrencyId, CurrencyName, Broj vezanih deal-ova, Deals (comma separated list of deal ids). Izvestaj treba da bude sortiran u opadajucem redosledu po broju povezanih Currency-ja.

select c.Id as CurrencyId, l.[Name], count(*) as DealCount, string_agg(cast(d.Id as varchar(max)), ', ') as DealIdList
from Deal d inner join Currency c	on d.Currency_Id = c.Id
inner join [Lookup] l				on c.Id = l.Id
group by c.Id, l.[Name]
order by count(*) desc;