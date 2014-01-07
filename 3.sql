select stu.StudentName,gra.GradeName,sub.SubjectName,res.ExamDate,res.StudentResult
from Result res
inner join Student stu on stu.StudentNo = res.StudentNo
inner join Grade gra on stu.GradeId = gra.GradeId
inner join Subject sub on sub.SubjectId = res.SubjectId
where ExamDate in (select MAX(ExamDate) from Result group by SubjectId) 

--select * from Result