------select *
------from Student
------where BornDate > (
------select BornDate
------from Student
--------where StudentName = '白燕
------)

------select *
------from Student
------where StudentNo in 
------(select StudentNo from Result 
------where SubjectId = 
------(
------select SubjectId from Subject where SubjectName = '走进JAVA编程世界'
------) and StudentResult > 60)





----select *
----from Student stu
----inner join Result res on stu.StudentNo = res.StudentNo
----inner join Subject sub on res.SubjectId = sub.SubjectId
----where res.StudentResult > 60 and sub.SubjectName = '走进JAVA编程世界'

----select subjectid from Subject where SubjectName = '走进JAVA编程世界'

----select MAX(ExamDate) from Result where SubjectId = (select subjectid from Subject where SubjectName = '走进JAVA编程世界')

----select MAX(StudentResult),MIN(StudentResult)
----from Result
----where SubjectId = 
----(select subjectid from Subject where SubjectName = '走进JAVA编程世界'
----)
----and 
----ExamDate = (
----select MAX(ExamDate)
----from Result
----where SubjectId = (select subjectid from Subject where SubjectName = '走进JAVA编程世界')
----)


--select StudentNo,StudentName
--from Student
--where StudentNo not in (

--select StudentNo
--from Result res 
----inner join Student stu on stu.StudentNo = res.StudentNo
--where SubjectId = (select subjectid from Subject where SubjectName = '走进JAVA编程世界')
-- and ExamDate = (select MAX(ExamDate) from Result where SubjectId = (select subjectid from Subject where SubjectName = '走进JAVA编程世界')))
--and GradeId = (select GradeId from Subject where SubjectName = '走进JAVA编程世界')


select GradeId
from Grade
where GradeName = 's1'

select SubjectName
from Subject
where GradeId = (select GradeId
from Grade
where GradeName = 's1')


select sub.SubjectName
from Subject sub
inner join Grade gra on gra.GradeId = sub.GradeId
where gra.GradeName = 's1'