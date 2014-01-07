create proc proc_getroominfo
@roomid int = -1
as
if(@roomid = -1)
select * from Room
else
select * from Room where RoomID = @roomid

exec proc_getroominfo 1008


select * from Room
print @@rowcount