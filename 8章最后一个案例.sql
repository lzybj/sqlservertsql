alter proc proc_hotel_addguest
@upid varchar(20)=null,----身份证
@uname varchar(20),----登记身份证姓名
@rtypename varchar(20),----房间类型
@rznum int=1,----入住人数
@yjmoney numeric(15,2)=1000.00 -----押金
as
declare @roomprice numeric(15,2)
declare @roomid int
declare @errors int 
----判断身份证是否为空
if(@upid is null)
begin
raiserror('对不起，必须有身份证',16,1)
return
end
----判断身份证是否是18位
if(LEN(@upid) <> 18)
begin
raiserror('对不起，身份证输入有误',16,1)
return
end
----判断押金是否大于0
if(@yjmoney <= 0)
begin
raiserror('对不起，必须有押金！',16,1)
return
end
---判断押金是否大于所住房间价格的2倍
---1.通过房间类型获得该房间的价格
select @roomprice=TypePrice
from RoomType
where TypeName = @rtypename
---2.判断押金是否大于房费2倍
if(@yjmoney < (@roomprice * 2))
begin
raiserror('对不起，押金需要至少需要房费的2倍',16,1)
return
end
--------以下开始做交易---------
--1.通过用户输入的房间类型，获得一个空闲房间号

print 'fffffffffffffff'

select @roomid = r.RoomID
from Room r
inner join RoomType rt on rt.TypeID = r.RoomTypeID
where rt.TypeName = @rtypename and r.RoomStateID = 2

print @roomid

print 'dsfsddddddd'


--2.事务开启
begin transaction
---更新room表中的两个字段，入住人数和房间状态
update Room set GuestNum = @rznum,RoomStateID = 1 where RoomID = @roomid
set @errors = @errors + @@ERROR
--如果没有此房间，即更新条数为0，则认为出错
if(@@ROWCOUNT <= 0)
begin
set @errors = 1
end
---插入一条记录到客户记录表中（guestrecord）
insert into GuestRecord(IdentityID,GuestName,RoomID,ResideID,ResideDate,Deposit)values(@upid,@uname,@roomid,1,GETDATE(),@yjmoney)
set @errors = @errors + @@ERROR
if(@errors <> 0)
begin
raiserror('失败了',16,1)
rollback transaction
end
else
begin
print '成功入住,入住的房间号是：' + convert(varchar(20),@roomid)
commit transaction
end


--exec proc_hotel_addguest '234243423423431231','老郑','标准间',2,2000