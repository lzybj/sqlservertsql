select DATEPART(QQ,hh.HTIME) as 季度,hd.DNAME as 区县,hs.SNAME as 街道,ht.HTNAME as 户型,COUNT(*) as 房屋数量
from hos_house hh
inner join hos_street hs on hs.SID = hh.SID
inner join hos_district hd on hd.DID = hs.SDID
inner join hos_type ht on ht.HTID = hh.HTID
group by DATEPART(QQ,hh.HTIME),hd.DNAME,hs.SNAME,ht.HTNAME

union

select DATEPART(QQ,hh.HTIME) as 季度,hd.DNAME as 区县,' 小计 ','',COUNT(*)
from hos_house hh
inner join hos_street hs on hs.SID = hh.SID
inner join hos_district hd on hd.DID = hs.SDID
group by DATEPART(QQ,hh.HTIME),hd.DNAME

union

select DATEPART(QQ,hh.HTIME) as 季度,' 合计','','',COUNT(*)
from hos_house hh
group by DATEPART(QQ,hh.HTIME) 