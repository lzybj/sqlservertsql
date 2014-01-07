declare @yingkao int ----应参加人数
declare @hege int ----合格人数
declare @subname varchar(20) ---课程名称

set @subname = '走进JAVA编程世界'

select @yingkao = COUNT(*)
from Student
where GradeId = (select GradeId from Subject where SubjectName = @subname)

select @hege = COUNT(*)
from Result
where ExamDate = 
(
select MAX(ExamDate)
from Result
where SubjectId = (select SubjectId from Subject where SubjectName = @subname)
)
and StudentResult >=60 
and SubjectId = (select SubjectId from Subject where SubjectName = @subname)

print '合格率为：' + convert(varchar(20),@hege / convert(float,@yingkao)*100)+'%' 

