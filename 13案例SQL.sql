----注册

--王款，牟鑫，盖文辉

insert into TBL_User(username,password,email)values('wk','123456','x@i.com')

insert into TBL_User(username,password,email)values('mx','qaz123','y@i.com')

insert into TBL_User(username,password,email)values('gwh','234567','z@i.com')

----登陆(wk登陆)

select * from TBL_User where username = 'wk'

----显示wk的短信息列表

select * from TBL_MESSAGE where sento = 'wk'

---查看wk短信列表中的某一个详细短信息

declare @msgid int

select * from TBL_MESSAGE where msgid = @msgid

--更新当前这个短信息的状态

update TBL_MESSAGE set state = 1 where msgid = @msgid

---删除WK短信息列表中的某个短信

delete from TBL_MESSAGE where msgid = @msgid

---wk发送短信给mx


---显示下拉列表框

select username from TBL_User where username <> 'wk'

---发送信息的相关内容

insert into TBL_MESSAGE(username,title,msgcontent,sento)values('wk','王款测试一条记录给牟鑫','哈哈，发送给牟鑫，你看到了吗？','mx')

insert into TBL_MESSAGE(username,title,msgcontent,sento)values('wk','王款测试二条记录给牟鑫','哈哈，发送给牟鑫，你看到了吗2？','mx')

insert into TBL_MESSAGE(username,title,msgcontent,sento)values('wk','王款测试三条记录给牟鑫','哈哈，发送给牟鑫，你看到了吗3？','mx')

insert into TBL_MESSAGE(username,title,msgcontent,sento)values('gwh','盖文辉测试一条记录给王款','哈哈，发送给王款，你看到了吗？','wk')

insert into TBL_MESSAGE(username,title,msgcontent,sento)values('gwh','盖文辉试二条记录给王款','哈哈，发送给王款，你看到了吗2？','wk')

insert into TBL_MESSAGE(username,title,msgcontent,sento)values('gwh','盖文辉试三条记录给王款','哈哈，发送给王款，你看到了吗3？','wk')


----回复

select * from TBL_MESSAGE where msgid = @msgid

declare @sento varchar(20)
declare @title varchar(200)

set @title = '回复：' + @title

insert into TBL_MESSAGE(username,title,msgcontent,sento)values('wk',@title,'回复的信息',@sento)


