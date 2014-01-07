----应参加走进JAVA编程世界的学员名单

select stu.StudentNo,StudentName,res.SubjectId,res.StudentResult,res.ExamDate 
into tempres
from Student stu
left join 
(
select *
from Result
where ExamDate = '2010-01-22' and SubjectId = (select SubjectId from Subject where SubjectName = '走进JAVA编程世界')
) res on res.StudentNo = stu.StudentNo
where GradeId = (select GradeId from Subject where SubjectName = '走进JAVA编程世界')


----在2010-01-22参加走进JAVA编程世界的学员成绩单

