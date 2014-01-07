--将2010-01-22日参加走进JAVA编程世界的应参加学生形成成绩单
--学号，学生名，考试科目ID，考试成绩


--select stu.StudentNo,stu.StudentName,res.SubjectId,res.StudentResult
--into restemp
--from Student stu
--left join (select StudentNo,SubjectId,StudentResult
--from Result 
--where SubjectId = (select SubjectId from Subject where SubjectName = '走进JAVA编程世界')
--and 
--ExamDate = '2010-01-22') res on res.StudentNo = stu.StudentNo
--where GradeId = (select GradeId from Subject where SubjectName = '走进JAVA编程世界')


select * from restemp

declare @yingdao int
declare @shidao int
declare @jige int
declare @jglv numeric(5,2)

select @yingdao = COUNT(*)
from restemp

select @jige = COUNT(*)
from restemp
where studentresult >= 60

set @jglv = @jige / convert(numeric(5,2),@yingdao) * 100

print '本次及格率为：' + convert(varchar(20),@jglv) + '%'