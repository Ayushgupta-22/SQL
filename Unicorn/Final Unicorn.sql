
select * from dbo.Unicorn_Companies

begin tran
update dbo.unicorn_companies set [Select Investors] = REPLACE([Select Investors],',,',',')
select * from dbo.Unicorn_Companies where Company like '%evi%'
commit tran
select * from dbo.Unicorn_Companies where Company like '%evi%'

-- First Co in Test column

select Company as [Company Name], [Select Investors] as [Investors], [Date Joined] as [Date1], CHARINDEX(',', [Select Investors]) as [Integer] into [Test1] from dbo.Unicorn_Companies
select * from [Test1]

update [Test1] set [Integer]= [Integer]-1 

alter table [test1]
add [First Co] varchar(max)


update [Test1] set [First Co] =
LEFT([investors], [Integer]) where Integer > 0


update [Test1] set [First Co] =
LEFT([investors], 50) from [Test1] where Integer <= 0

select * from [Test1]

-- Creating the 2nd Company colummn
select Company as [Company Name2], [Select Investors] as [Investors2], [Date Joined] as [Date2], CHARINDEX(',', [Select Investors]) as [Integer21], CHARINDEX(',', [Select Investors],CHARINDEX(',', [Select Investors])+1) as [Integer22], LEN([Select Investors]) as [Length21] into [Test2] from dbo.Unicorn_Companies

select * from [Test2] order by [Company Name2]

alter table [test2]
add [second Co] varchar(max)

update [Test2] set [Second Co] =
SUBSTRING([Investors2], [Integer21]+1, [Integer22]-[Integer21]-1) where [Integer22] > 0

update [Test2] set [Second Co] =
SUBSTRING([Investors2], [Integer21]+1, Length21-[Integer21]) where [Integer22] = 0 and [Integer21] != 0

-- drop table [Test2]

-- Creating the 3rd Company column

select Company as [Company Name3], [Select Investors] as [Investors3], [Date Joined] as [Date3], CHARINDEX(',', [Select Investors],CHARINDEX(',', [Select Investors])+1) as [Integer32], CHARINDEX(',', [Select Investors],CHARINDEX(',', [Select Investors], CHARINDEX(',', [select investors]))) as [Integer33], LEN([Select Investors]) as [Length31] into [Test3] from dbo.Unicorn_Companies

alter table [test3]
add [third Co] varchar(max)

update [Test3] set [third Co] =
SUBSTRING([Investors3], [Integer32] +2, [Length31]-[Integer32]) where [Integer33] > 0 and [Length31] > [Integer33] and [Integer32] != 0

select * from Test3 where [third co] is null

--drop table [Test3]

-- Creating the 4th and last Company column

select Company as [Company Name4], [Select Investors] as [Investors4], [Date Joined] as [Date4], 
CHARINDEX(',', [Select Investors],(CHARINDEX(',', [Select Investors], (CHARINDEX(',', [select investors], charindex(',', [select investors]))+1)+1)+1)) as [Integer44], 
CHARINDEX(',', [Select Investors], (CHARINDEX(',', [Select Investors], (CHARINDEX(',', [select investors]))))+1) as [Integer43],
CHARINDEX(',', [Select Investors], (CHARINDEX(',', [Select Investors]))) as [Integer42],
LEN([Select Investors]) as [Length41] into [Test4] from dbo.Unicorn_Companies
select * from [Test4]

alter table [test4]
add [fourth Co] varchar(max)


update [Test4] set [fourth Co] =
SUBSTRING([Investors4], [Integer44] +2, [Length41]-[Integer44]) where [Integer44] != [Integer43] and [Integer44] != [integer42] and [Integer44] != 0

select * from Test4


-- Main table plus first Co

select * into [First Co] from dbo.Unicorn_Companies
full outer join [Test1] on dbo.Unicorn_Companies.Company = Test1.[Company Name] and dbo.unicorn_companies.[date joined] = Test1.[Date1]

select * from dbo.Unicorn_Companies

select * from [First Co]

select * from Test2 order by [Company Name2]


--alter table [First Co]
--drop [Integer], [Investor 1], [investor 2], [investor 3], [investor 4]


-- 2 companies

select Company, Valuation, [Date Joined], Industry, City, Country, Continent, [Year_Founded], Funding, [Select Investors], [First Co], test2.[second Co] into [2 Investors]  from [First Co]
full outer join [Test2] on [First Co].[Company Name]= Test2.[Company Name2] and [First Co].[Date Joined] = Test2.[Date2]

select * from [2 Investors] where [second co] is null

--drop table [2 Investors]


-- 3rd company

select * into [3 Investors] from [2 Investors]
full outer join [Test3] on [2 Investors].[Company]= Test3.[Company Name3] and [2 Investors].[date joined] = Test3.[Date3]
select * from [3 Investors]

--drop table [3 Investors]

--4th Co


select Company, Valuation, [Date Joined], Industry, City, Country, Continent, [Year_Founded], Funding, [Select Investors], [First Co], [second Co], [third co], Test4.[fourth Co] into [4 Investors] from [3 Investors]
full outer join [test4] on [3 investors].[COmpany] = test4.[company name4] and [3 investors].[date joined] = Test4.[Date4]

select * from [4 Investors]