---select * from hos_house where HMID >= 6 and HMID <=10

select * from hos_house


select top 5 *
from hos_house
where HMID not in (select TOP 5 hmid from hos_house)


select hd.DNAME,hs.SNAME,ht.HTNAME,hh.PRICE,hh.TOPIC,hh.CONTENTS,hh.HTIME
from hos_house hh
inner join hos_street hs on hs.SID = hh.SID
inner join hos_district hd on hd.DID = hs.SDID
inner join hos_type ht on ht.HTID = hh.HTID
where UID = (select UID from sys_user where UNAME = 'ÕÅÈý')

-------------------------------

select *
from hos_house hh
inner join hos_street hs on hs.SID = hh.SID
inner join hos_district hd on hd.DID = hs.SDID
where hd.DID in ( 
select hd.did
from hos_house hh
inner join hos_street hs on hs.SID = hh.SID
inner join hos_district hd on hs.SDID = hd.DID 
group by hd.DID
having COUNT(*) > 1)






