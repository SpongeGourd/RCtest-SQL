--竞争圈 酒店前后7天   总间夜量	总佣金  总返现

---------------------将##t7675表中的目标酒店和竞争酒店全部放在一列中(竞争圈数据)--------------------------
if OBJECT_ID('tempdb..#jzq') is not null drop table #jzq
select * 
into #jzq
from 
(
--select masterhotelid as jzqid ,onlinedate from ##t7675
--union all
select Com1 as jzqid ,onlinedate from ##t7675
union all
select Com2 as jzqid ,onlinedate from ##t7675
union all
select Com3 as jzqid ,onlinedate from ##t7675
union all
select Com4 as jzqid ,onlinedate from ##t7675
union all
select Com5 as jzqid ,onlinedate from ##t7675
) a
where a.jzqid !=0


----------------------将同一上线日期的所有竞争圈数据（包括目标酒店和竞争酒店）去重-----------------------
if OBJECT_ID('tempdb..#jzq2') is not null drop table #jzq2
select distinct * into #jzq2 from #jzq 

--------------------------007表------------------------------------------
if OBJECT_ID('tempdb..#t1') is not null drop table #t1
select
a.jzqid
,b.hotel
,b.HotelName
,a.onlinedate
,convert(varchar(10),c.orderdate,120) as orderdate
,sum(c.cii_quantity) as '订单成交间夜量'
,case when c.orderdate>=dateadd(day,-7,a.Onlinedate)  and c.orderdate<a.Onlinedate then 'Before'
when c.orderdate<dateadd(day,7,a.Onlinedate) and c.orderdate>=a.Onlinedate then 'After'
else 'None' end as class

into #t1

from #jzq2 (nolock) a
inner join [Dim_DB].[dbo].[DimHotel] (nolock) b
on a.jzqid = case when b.MasterHotelID in (-1,0) then b.hotel else b.MasterHotelID end
inner join [OLAP_HtlDB].[dbo].[O_Htl_007] (nolock) c 
on b.hotel = c.hotel

where 1=1
and convert(varchar(10),c.orderdate,120)>='2014-07-10' and convert(varchar(10),c.orderdate,120)<='2014-08-02'
and c.orderstatus!='C'
---选出竞争圈酒店中的现付子酒店情况
and b.hotelbelongto='HTL'


group by 
a.jzqid
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

