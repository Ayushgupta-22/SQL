
-- Get data 'Superstore' and import using the import wizard

select * from dbo.Orders$

-- Populate Profit %
alter table dbo.orders$
add [Profit %] float

update Superstore.dbo.Orders$ set [Profit %] = round(Profit/Sales *100,2)
select * from Superstore.dbo.Orders$

-- Region wise Profits and Profits %

select region as Region, round(AVG(Sales),2) as [Average of Sales], round(avg(Profit),2) as [Average of Profits] into [Region and Profit] from dbo.Orders$ where region is not null group by Region

alter table [Region and Profit]
add [Profit %] float

select * from [Region and Profit]

update [Region and Profit] set [Profit %] =  
ROUND([Average of Profits] / [average of Sales] * 100,2) from [Region and Profit] 

select * from [Region and Profit] order by [Profit %] desc


-- Region and Category wise Profits

select region as Region, Category as [Category], round(AVG(Sales),2) as [Average of Sales], round(avg(Profit),2) as [Average of Profits]  into [Region and Category with Profit] from dbo.Orders$ where region is not null group by Region, Category

alter table [Region and category with Profit]
add [Profit %] float

update [Region and Category with Profit] set [Profit %] =  
ROUND([Average of Profits] / [average of Sales] * 100,2) from [Region and Category with Profit] 

select * from [Region and Category with Profit] order by [Profit %] desc


-- State wise Profits

select State as States, round(AVG(Sales),2) as [Average of Sales], round(avg(Profit),2) as [Average of Profits]  into [State with Profits] from dbo.Orders$ where State is not null group by State

select * from [State with Profits]

alter table [State with Profits]
add [Profit %] float

update [State with Profits] set [Profit %] =  
ROUND([Average of Profits] / [average of Sales] * 100,2) from [State with Profits] 

select * from [State with Profits] order by [Profit %] desc


-- Adding Returns to the Orders table

select * from dbo.Orders$
select * from dbo.Returns$

--rename Returns$.Order ID to Returns$.Order_ID
sp_rename 'Returns$.[Order Id]', 'Order_ID' , 'Column'

select * into [Orders and Returns] from dbo.Orders$  full outer join dbo.returns$ on orders$.[Order ID] = returns$.[Order_ID] 

select * from [Orders and Returns]
update [Orders and Returns] set [Returned] = 'No' where [Returned] is null

select * from [Orders and Returns]

-- States and Count of Returns

-- drop table if already exists; can be ignored
drop table if exists dbo.[States and Returns]

select State as [State], COUNT(state) as [No of Orders] into [States and Returns] 
from [Orders and Returns] group by State

alter table [States and Returns]
add [Number of Returns] int

select COUNT(Returned) as [No of Returns], state as [States] into [Temp.State.Return] from [Orders and Returns] where [Returned] like '%Y%' group by State 

select * into [States Orders and Returns] from dbo.[States and Returns] full outer join [Temp.State.Return] on [Temp.State.Return].[States] = [States and Returns].[State]

select * from [States Orders and Returns]
update [States Orders and Returns] set [No of Returns] = 0 where [No of Returns] is null

alter table [States Orders and Returns]
drop column [States], [Number of Returns]

select * from [States Orders and Returns]

alter table [States Orders and REturns]
add [Return %] float

update [States Orders and Returns] set [Return %] = 
round(Cast([No of Returns] *100 as float) / cast([No of Orders] as float),2) 

select * from [States Orders and Returns] order by [Return %] desc


-- Segment and Sales

select Segment as Segment, round(AVG(Sales),2) as [Average of Sales], round(avg(Profit),2) as [Average of Profits]  into [Segments with Profit] from dbo.Orders$ where Segment is not null group by Segment

alter table [segments with Profit]
add [Profit %] float

update [Segments with Profit] set [Profit %] =  
ROUND([Average of Profits] / [average of Sales] * 100,2) from [Segments with Profit] 

select * from [Segments with Profit] order by [Profit %] desc


-- Table with Salesperson

--alter column name
sp_rename 'People$.Region', 'Region2' , 'Column'

select * into [Orders and People] from dbo.Orders$ full outer join dbo.People$ on Orders$.Region = People$.REgion2 

select * from [Orders and People]

select Person as [Person], COUNT(distinct [Customer ID]) as [No of Customers] into [Persons and Customers] from dbo.[orders and People] group by person

select * from [Persons and Customers]


--END RESULT TABLES:
select * from Superstore.dbo.Orders$
select * from [Region and Profit] order by [Profit %] desc
select * from [Region and Category with Profit] order by [Profit %] desc
select * from [State with Profits] order by [Profit %] desc
select * from [Orders and Returns]
select * from [States Orders and Returns] order by [Return %] desc
select * from [Segments with Profit] order by [Profit %] desc
select * from [Persons and Customers]


--END