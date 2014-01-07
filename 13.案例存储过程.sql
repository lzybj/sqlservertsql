---注册的存储过程proc_sms_register

create proc proc_sms_register
@username varchar(50),
@password varchar(50),
@email varchar(100)
as
insert into TBL_User(username,password,email)values(@username,@password,@email)

--登陆的存储过程proc_sms_findByUserName

create proc proc_sms_findByUserName
@username varchar(50),
@password varchar(50) = '' output
as

select @password = password from TBL_User where username = @username

--declare @pwd varchar(20)

--exec proc_sms_findByUserName 'wkx',@pwd output

--print @pwd

-----查看当前用户的短信息列表 proc_sms_findSmsListByUserName

create proc proc_sms_findSmsListBySento
@sento varchar(50)
as
select * from TBL_MESSAGE where sento = @sento

exec proc_sms_findSmsListBySento 'wk'

----查看某个短信息proc_sms_findByMsgid
create proc proc_sms_findByMsgidOrDel
@msgid int,
@oper int = 0
as
if(@oper=0)
begin
select * from TBL_MESSAGE where msgid = @msgid
update TBL_MESSAGE set state = 1 where msgid = @msgid
end
else
begin
delete from TBL_MESSAGE where msgid = @msgid
end

--exec proc_sms_findByMsgidOrDel 2,1

--发送信息proc_sms_sendsms

create proc proc_sms_sendsms
@username varchar(50),
@title varchar(200),
@msgcontent text,
@sento varchar(50)
as
insert into TBL_MESSAGE(username,title,msgcontent,sento)values(@username,@title,@msgcontent,@sento)

--exec proc_sms_sendsms 'wk','补充一条信息给牟鑫','补充的信息给牟鑫','mx'

--回复proc_sms_msgreply

create proc proc_sms_msgreply
@msgid int,
@msgcontent text
as
declare @username varchar(50)
declare @sento varchar(50)
declare @title varchar(200)
declare @replytitle varchar(200)

select @username=sento,@sento=username,@title=title from TBL_MESSAGE where msgid = @msgid

set @replytitle = '回复：' + @title

insert into TBL_MESSAGE(username,title,msgcontent,sento)values(@username,@replytitle,@msgcontent,@sento)


--exec proc_sms_msgreply 1,'这是用存储过程回复的一条短信息'

select * from TBL_MESSAGE