alter proc proc_stu_ffy2
@meiyenum int=10, ----每页显示的条数
@nowpage int=1,  ----当前显示的页码
@pagetotal int output
as
declare @sql varchar(500)
declare @datasize int

select @datasize = COUNT(stuid)
from Student

set @pagetotal = ceiling(@datasize / convert(float,@meiyenum))

set @sql = 'select top '+ CONVERT(varchar(20),@meiyenum) +' stuid,studentno,studentname from student where stuid not in (select top '+ convert(varchar(20),(@nowpage - 1) * @meiyenum) +' stuid from student order by stuid)'
exec (@sql)

declare @pages int
exec proc_stu_ffy2 5,5,@pages output
print @pages

