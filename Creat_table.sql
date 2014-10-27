-----------第一步建表-------------------------
Create table ##t1(
masterhotelid int 
,hotelid int
,onlinedate varchar(10)
,CHotel1 int 
,CHotel2 int 
,CHotel3 int 
,CHotel4 int 
,CHotel5 int
)


select * from ##t1



-------------第二步导入数据----------------------------
insert into ##t1 values(86,86,'2014-07-22',457186,426113,481675,430601,457236);
insert into ##t1 values(160,160,'2014-07-25',221,437222,454631,0,0);
insert into ##t1 values(178,178,'2014-07-22',971309,445313,772464,482983,447703);
insert into ##t1 values(213,213,'2014-07-23',79607,46946,825971,474017,0);
insert into ##t1 values(711,711,'2014-07-23',660,640524,640512,455020,428827);
