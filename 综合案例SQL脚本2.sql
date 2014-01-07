--create proc usp_openAccount
--@cname varchar(20),  -------客户的名
--@cpid varchar(20),   -------客户身份证号码
--@ctel varchar(20),   -------客户联系电话
--@openmoney numeric(8,2),----客户开户金额
--@ctype varchar(20),     ----存款类型
--@caddress varchar(100)= null ---客户联系地址
--as
--declare @errors int  -------事务提交或回滚标志
--declare @cardid varchar(40) -----随机生成卡号
--declare @savingid int  --------存款类型ID
--declare @customerID int -------客户ID

--set @errors = 0

--begin transaction
-----1.创建客户信息，操作userInfo表
--insert into userInfo(customerName,PID,telephone,address)values(@cname,@cpid,@ctel,@caddress)
--set @errors = @errors + @@ERROR
-----2.随机生成银行卡号,调用usp_cardid存储过程
--exec usp_cardid @cardid output
-----3.插入银卡信息，操作cardInfo表
-----3.1 获得存款类型id,即savingID
--select @savingid = savingID from Deposit where savingName = @ctype
-----3.2 获得用户id,即customerID
--select @customerID = customerID from userInfo where PID = @cpid
-----3.3 插入银行卡信息
--insert into cardInfo(cardID,curID,savingID,openMoney,balance,pass,IsReportLoss,customerID)values(@cardid,'RMB',@savingid,@openmoney,@openmoney,'888888',0,@customerID)
--set @errors = @errors + @@ERROR
-----4.插入交易流水,操作tradeInfo表
--insert into tradeInfo(tradeType,cardID,tradeMoney,remark)values('存入',@cardid,@openmoney,'开户')
--set @errors = @errors + @@ERROR
----5.开始事务判断
--if(@errors <> 0)
--begin
--raiserror('对不起，开户失败，请联系发卡行！',16,1)
--rollback transaction
--end
--else
--begin
--print '开户成功，卡号为：' + @cardid + '  ,余额：' + convert(varchar(20),@openmoney)
--commit transaction
--end


-----------------------------------------
create proc usp_CheckSheet
@cardid varchar(40),
@starttime varchar(20)=null,
@endtime varchar(20)=null
as
declare @cname varchar(20) ----客户名
declare @curID varchar(10) ----货币类型
declare @savingname varchar(20) ---存款类型
declare @opendate datetime -----开户时间

----通过卡号取出客户信息 userInfo

select @cname = ui.customerName,@curID=ci.curID,@savingname=dep.savingName,@opendate = ci.openDate
from userInfo ui
inner join cardInfo ci on ci.customerID = ui.customerID
inner join Deposit dep on dep.savingID = ci.savingID
where ci.cardID = @cardid 

print '卡号：' + @cardid
print '姓名：' + @cname
print '货币类型：' + @curID
print '存款类型：' + @savingname
print '开户日期：' + convert(varchar(10),datepart(yyyy,@opendate)) + '年' + convert(varchar(10),datepart(mm,@opendate)) + '月' + convert(varchar(10),datepart(dd,@opendate)) + '日' 

----通过卡号取出交易信息 tradeInfo

if(@starttime is null)
set @starttime = convert(varchar(5),DATEPART(YYYY,GETDATE())) + '-' + convert(varchar(5),DATEPART(mm,GETDATE())) + '-' + '01'
if(@endtime is null)
set @endtime = CONVERT(varchar(20),GETDATE(),20)

select * 
from tradeInfo
where cardID = @cardid and tradeDate >= @starttime and tradeDate <= @endtime

exec usp_checksheet '1010 3576 1212 1134'

------------------------------------

select *
from cardInfo
where cardID not in 
(
select cardID
from tradeInfo
where tradeDate >= '2013-03-01' and tradeDate <= '2013-03-16'
)


------------------------------

select COUNT(*)
from tradeInfo
where tradeType = '存入'



