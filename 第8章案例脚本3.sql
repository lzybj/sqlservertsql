alter proc proc_roomtype_del
@roomtypename varchar(20),
@res int output
as
--判断此房间类型是否有入住信息

if(exists(
select * 
from Room r
inner join RoomType rt on r.RoomTypeID = rt.TypeID 
where rt.TypeName = @roomtypename))
begin
set @res = -1
end
else
begin
delete from RoomType where TypeName = @roomtypename
set @res = @@ROWCOUNT
end


declare @res2 int
exec proc_roomtype_del '标准间',@res2 output

if(@res2 = -1)
print '删除失败'
else
print '删除成功'+ convert(varchar(20),@res2)








