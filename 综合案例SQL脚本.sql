--update cardInfo set IsReportLoss = 1 where customerID = (select customerID from userInfo where customerName = '李四')

select ci.cardID,ci.curID,dt.savingName,ci.openDate,ci.openMoney,ci.balance,ci.pass,是否挂失=case
when IsReportLoss = 0 then '未挂失'
else '挂失'
end,ui.customerName
from cardInfo ci
inner join Deposit dt on dt.savingID = ci.savingID
inner join userInfo ui on ui.customerID = ci.customerID 


---------------
declare @cunru numeric(10,2)
declare @quchu numeric(10,2)
declare @zjltye numeric(10,2)   ----资金流通余额
declare @yyjs numeric(10,2)     ----盈余结算
declare @ckll numeric(10,3)     ----存款利率
declare @dkll numeric(10,3)     ----贷款利率

set @ckll = 0.003
set @dkll = 0.008

select @cunru = SUM(tradeMoney)
from tradeInfo
where tradeType = '存入'

select @quchu = SUM(tradeMoney)
from tradeInfo
where tradeType = '支取'


set @zjltye = @cunru - @quchu

set @yyjs = @quchu * @dkll - @cunru * @ckll

print '银行流通余额' + convert(varchar(20),@zjltye) + 'RMB'

print '盈利结算' + convert(varchar(20),@yyjs) + 'RMB'


--------------------------------

select *
from cardInfo
where DATEPART(WW,openDate) = DATEPART(ww,GETDATE())

------------------------
select *
from userInfo ui 
inner join cardInfo ci on ci.customerID = ui.customerID 
where ci.cardID = (
select top 1 cardID
from tradeInfo
group by cardID
order by SUM(tradeMoney) desc)

---------------------------
select *
from userInfo
where customerID in (
select customerID
from cardInfo
where balance < 200)


----------------

create proc bankdb_login
@cname varchar(20),
@cpass varchar(20)
as

if(EXISTS(select *
from cardInfo
where customerID = (
select customerID
from userInfo
where customerName = @cname) and pass = @cpass))
begin
select *
from cardInfo
where customerID = (
select customerID
from userInfo
where customerName = @cname) and pass = @cpass
end
else
begin
raiserror('对不起，你的用户名或密码不存在',16,1)
end

exec bankdb_login 'liss','sdfsdf'


create view vi_userinfo
as
select customerID as 客户编号,customerName as 开户名,PID as 身份证,telephone as 联系电话,address as 居住地址
from userInfo

select * from vi_userinfo


-----------------------------------------
alter proc usp_takemoney
@cname varchar(20),
@cpass varchar(20) = null,
@jymoney numeric(15,2),
@jytype int -------0,存；1，取
as
----获取户名对应的卡号
declare @cardid varchar(50)
declare @cipass varchar(20)
declare @errors int -----------事务标志变量
declare @blances numeric(15,2) ----卡余额
declare @cardstate bit  
set @errors = 0

select @cardid=ci.cardID,@cipass=ci.pass,@blances = ci.balance,@cardstate = ci.IsReportLoss
from cardInfo ci
inner join userInfo ui on ui.customerID = ci.customerID
where ui.customerName = @cname 

if(@jytype = 0)
begin
--存款不必验证密码,并在记账时开启事务
begin transaction
update cardInfo set balance = balance + @jymoney where cardID = @cardid
set @errors = @errors + @@ERROR
insert into tradeInfo(tradeType,cardID,tradeMoney,remark)values('存入',@cardid,@jymoney,'sdfsd')
set @errors = @errors + @@ERROR
if(@errors <> 0)
rollback transaction
else
commit transaction
end
else
begin
if(@cpass = @cipass)
begin
if(@cardstate = 1)
begin
raiserror('该账号已经冻结',16,1)
return
end
if(@jymoney < @blances + 1)
begin
begin transaction
update cardInfo set balance = balance - @jymoney where cardID = @cardid
set @errors = @errors + @@ERROR
insert into tradeInfo(tradeType,cardID,tradeMoney,remark)values('支取',@cardid,@jymoney,'sd')
set @errors = @errors + @@ERROR
if(@errors <> 0)
rollback transaction
else
commit transaction
end
else
begin
raiserror('对不起，余额不足',16,1)
print '卡号：' + @cardid + '   余额：' + convert(varchar(20),@blances)
end
end
else
begin
raiserror('对不起，密码错误',16,1)
end
end

exec usp_takemoney '丁六','888888',200,1

select * from cardInfo

select * from tradeInfo


select * from userInfo



