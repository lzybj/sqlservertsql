select studentno,studentname,studentresult,examdate,是否缺考=case
when studentresult IS null then '是'
else '否'
end,是否通过考试=case
when studentresult >= 60 then '是'
else '否'
end
from tempres tr 

declare @ydnum int
declare @hege int

select @hege = COUNT(*)
from tempres
where studentresult >= 60

select @ydnum = COUNT(*)
from tempres

select @ydnum as 应到人数,@hege as 通过人数,(convert(varchar(20),(@hege / convert(float,@ydnum))*100)+'%') as 合格率

while(
exists
(
select * from tempres where studentresult < 60
))
update tempres set studentresult = studentresult + 2 where studentresult <= 98

select @hege = COUNT(*)
from tempres 
where studentresult >= 60

select @ydnum as 应到人数,@hege as 通过人数,(convert(varchar(20),(@hege / convert(float,@ydnum))*100)+'%') as 合格率

