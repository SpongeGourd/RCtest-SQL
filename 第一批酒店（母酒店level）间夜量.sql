--测试酒店前后7天   总间夜量	总佣金  总返现

--------------------------007表------------------------------------------
if OBJECT_ID('tempdb..#t1') is not null drop table #t1
select
a.masterhotelid
,b.hotel
,b.HotelName
,a.onlinedate
,convert(varchar(10),c.orderdate,120) as orderdate
,sum(c.cii_quantity) as '订单成交间夜量'
,case when c.orderdate>=dateadd(day,-7,a.Onlinedate)  and c.orderdate<a.Onlinedate then 'Before'
when c.orderdate<dateadd(day,7,a.Onlinedate) and c.orderdate>=a.Onlinedate then 'After'
else 'None' end as class

into #t1

from ##t7675 (nolock) a
inner join [Dim_DB].[dbo].[DimHotel] (nolock) b
on a.masterhotelid = case when b.MasterHotelID in (-1,0) then b.hotel else b.MasterHotelID end
inner join [OLAP_HtlDB].[dbo].[O_Htl_007] (nolock) c 
on b.hotel = c.hotel

where 1=1
and convert(varchar(10),c.orderdate,120)>='2014-07-10' and convert(varchar(10),c.orderdate,120)<='2014-08-02'
and c.orderstatus!='C'
---选出母酒店中的现付子酒店情况
--and b.hotelbelongto='HTL'


group by 
a.masterhotelid
,b.hotel
,b.HotelName
,a.onlinedate
,convert(varchar(10),c.orderdate,120)
,case when c.orderdate>=dateadd(day,-7,a.Onlinedate)  and c.orderdate<a.Onlinedate then 'Before'
when c.orderdate<dateadd(day,7,a.Onlinedate) and c.orderdate>=a.Onlinedate then 'After'
else 'None' end


select onlinedate, class, SUM(订单成交间夜量) from #t1
where class != 'None'
group by onlinedate, class
order by 1,2


--select * from #t1

