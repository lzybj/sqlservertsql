--select substring(convert(varchar(20),CONVERT(numeric(15,8),RAND(DATEPART(ms,getdate())*1000))),3,8)



declare @rand numeric(15,8)
declare @randStr varchar(20)
declare @dateStr varchar(30)
declare @jycode varchar(30)
declare @errors int

set @errors = 0

----通过RAND()函数生成随机数0=1
set @rand = convert(numeric(15,8),RAND(DATEPART(ms,getdate())))

----将numeric类型转换为字符串类型
set @randStr = convert(varchar(20),@rand)

----截取8位小数
set @randStr = substring(@randStr,3,8)

----将当前时间转换为字符串类型（注意样式为20）
set @dateStr = convert(varchar(30),getdate(),20)

----截取时间中的年，月，日，小时，分，秒
set @dateStr = SUBSTRING(@dateStr,1,4) + SUBSTRING(@dateStr,6,2) + SUBSTRING(@dateStr,9,2) + SUBSTRING(@dateStr,12,2) + SUBSTRING(@dateStr,15,2) + SUBSTRING(@dateStr,18,2)

----将时间串和随机数生成一个字符串
set @jycode = @dateStr + @randStr


-------------------------开始做交易

begin transaction

---A账户-98元，B账户+98元

update CardInfo set cardyu = cardyu - 98 where cardid = '1234 4567 9876 2345'
set @errors = @errors + @@ERROR
update CardInfo set cardyu = cardyu + 98 where cardid = '9876 4567 1234 6543'
set @errors = @errors + @@ERROR

----插入交易流水表，A插入支取，B插入存入

insert into YJLog(jycode,cardid,jytcode,jymoney)values(@jycode,'1234 4567 9876 2345',2,98)
set @errors = @errors + @@ERROR

----通过RAND()函数生成随机数0=1
set @rand = convert(numeric(15,8),RAND(DATEPART(mm,getdate())))

----将numeric类型转换为字符串类型
set @randStr = convert(varchar(20),@rand)

----截取8位小数
set @randStr = substring(@randStr,3,8)

----将当前时间转换为字符串类型（注意样式为20）
set @dateStr = convert(varchar(30),getdate(),20)

----截取时间中的年，月，日，小时，分，秒
set @dateStr = SUBSTRING(@dateStr,1,4) + SUBSTRING(@dateStr,6,2) + SUBSTRING(@dateStr,9,2) + SUBSTRING(@dateStr,12,2) + SUBSTRING(@dateStr,15,2) + SUBSTRING(@dateStr,18,2)

----将时间串和随机数生成一个字符串
set @jycode = @dateStr + @randStr


insert into YJLog(jycode,cardid,jytcode,jymoney)values(@jycode,'9876 4567 1234 6543',1,98)
set @errors = @errors + @@ERROR

if(@errors <> 0)
rollback transaction
else
commit transaction

