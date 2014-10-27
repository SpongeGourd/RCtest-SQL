--上线时间有6个，分别是2014年7月18、22-26日

--所有国内现付子酒店   总间夜量	总佣金  总返现
if OBJECT_ID('tempdb..#t1') is not null drop table #t1
select
a.Hotel
,c.HotelName 
,sum(a.cii_quantity) as '订单成交间夜量'
--,sum(a.commission_1st) as '订单成交总佣金'
--,sum(a.CashAmount) as '订单中的总返现'
into #t1
from dim_db..DimHotel (nolock) c
inner join DW_HtlDB..FactHotelOrder (nolock) a on a.hotel = c.Hotel 
inner join dim_db..DimCity (nolock)  d  on c.City  =d.CityID 
where a.orderdate>='2014-07-18' and a.orderdate<'2014-07-25'
and a.orderstatus!='C'
and a.BalanceType = 'FG'
and d.Country = 1
---只取出使用了返现的间夜量
---and a.CashAmount>0
group by 
a.Hotel
,c.HotelName

select SUM(订单成交间夜量)
from #t1

select * from #t1 order by hotel
