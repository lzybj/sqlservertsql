--insert into Customer(cname,cpwd,yuer)values('老李','123456',1000)
--declare @cid int
--select @cid = cid from Customer where cname = '老李'
--insert into TradeLog(tradeinfo,trademoney,cid)values('存款',1000,@cid)

--insert into Customer(cname,cpwd,yuer)values('老郑','qaz123',100)
--select @cid = cid from Customer where cname = '老郑'
--insert into TradeLog(tradeinfo,trademoney,cid)values('存款',100,@cid)

----delete Customer

--delete TradeLog where tid > 4


declare @cid int
declare @errors int -----错误编号累加
declare @nexti int

set @errors = 0
set @nexti = 0

--开启事务

begin transaction

while(@nexti < 5)
begin

update  Customer set yuer = yuer - 100 where cname = '老李'

set @errors = @errors + @@ERROR

select @cid = cid from Customer where cname = '老李'

insert into TradeLog(tradeinfo,trademoney,cid)values('取款',100,@cid)

set @errors = @errors + @@ERROR

update Customer set yuer = yuer + 100 where cname = '老郑'

set @errors = @errors + @@ERROR

select @cid = cid from Customer where cname = '老郑'

insert into TradeLog(tradeinfo,trademoney,cid)values('存款',100,@cid)

set @errors = @errors + @@ERROR

set @nexti = @nexti + 1

end

if(@errors != 0)
begin
	print '转账失败！'
	rollback transaction
end
else
begin
	print '转账成功！'
	commit transaction
end