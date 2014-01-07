create proc usp_cardid
@cardid varchar(40) output
as
declare @randx numeric(15,8)
declare @randv varchar(20)
declare @randq4 varchar(20)
declare @randh4 varchar(20)

set @randx = RAND(DATEPART(mm,getdate())*100000 + datepart(ss,getdate())*1000 + datepart(ms,getdate()))

set @randv = CONVERT(varchar(20),@randx)

set @randq4 = SUBSTRING(@randv,3,4)

set @randh4 = SUBSTRING(@randv,7,4)

set @cardid = '1010 3576 ' + @randq4 + ' ' + @randh4 


declare @mycardid varchar(40)
exec usp_cardid @mycardid output
print @mycardid
