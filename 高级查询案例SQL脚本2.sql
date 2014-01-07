select *
into student2
from Student
where GradeId = (select GradeId from Grade where GradeName = 'S1')


update student2 set gradeid = (select gradeid from Grade where GradeName = 'S2')


SELECT GRADEID
FROM Student2


----------------------------

if(NOT exists
(
select *
from Result
where SubjectId = 
(select SubjectId from Subject where SubjectName = '走进JAVA编程世界')
and 
ExamDate = 
(
select MAX(ExamDate) 
from Result
where SubjectId = (select SubjectId from Subject where SubjectName = '走进JAVA编程世界')
)
and
StudentResult > 90
)
)
begin
print '没有超过90分的'
update Result set StudentResult = StudentResult + 3
where ExamDate = 
(
select MAX(ExamDate) 
from Result
where SubjectId = (select SubjectId from Subject where SubjectName = '走进JAVA编程世界')
) and SubjectId = (select SubjectId from Subject where SubjectName = '走进JAVA编程世界')
end
else
begin
print '有超过90分的'
update Result set StudentResult = StudentResult + 1
where ExamDate = 
(
select MAX(ExamDate) 
from Result
where SubjectId = (select SubjectId from Subject where SubjectName = '走进JAVA编程世界')
) and SubjectId = (select SubjectId from Subject where SubjectName = '走进JAVA编程世界')
end


----------------


declare @subname varchar(20)
declare @examdate datetime
declare @subid int

set @subname = '走进JAVA编程世界'

select @subid=SubjectId 
from Subject 
where SubjectName = @subname


select @examdate=MAX(ExamDate)
from Result
where SubjectId = @subid

if(exists(
select *
from Result
where SubjectId = @subid and ExamDate = @examdate and StudentResult > 80))
begin
print '加2分，且不能超过100分'
update Result set StudentResult = StudentResult + 2
where ExamDate = @examdate and SubjectId = @subid and StudentResult <= 98
end
else
begin
print '加5分，且不能超过100分'
update Result set StudentResult = StudentResult + 5
where ExamDate = @examdate and SubjectId = @subid and StudentResult <= 95

end

-----------------


select *
from Student
where BornDate < 
(
select BornDate
from Student
where StudentName = '白燕'
)



select *
from Subject
where GradeId = 
(
select GradeId
from Grade
where GradeName = 'S1'
)

select *
from Result
where ExamDate = '2010-01-22' and SubjectId in
(
select SubjectId
from Subject
where SubjectName = '走进JAVA编程世界'
)


select *
from Result res
inner join Subject sub on sub.SubjectId = res.SubjectId
where sub.SubjectName = '走进JAVA编程世界' and res.ExamDate = '2010-01-22'






---------------------------


select *
from Student

where StudentNo not in ( 

select StudentNo
from Result
where SubjectId = 
(
select SubjectId
from Subject
where SubjectName = 'SQL BASE'
)
and
ExamDate = 
(
select MAX(ExamDate)
from Result
where SubjectId = (select SubjectId from Subject where SubjectName = 'SQL BASE')
)
) and GradeId = (select GradeId from Subject where SubjectName = 'SQL BASE')







------------------------


select MAX(StudentResult),MIN(StudentResult)
from Result
where SubjectId = 
(
select SubjectId
from Subject
where SubjectName = '走进JAVA编程世界'
) 
and
ExamDate =
(
select MAX(ExamDate)
from Result
where SubjectId = (select SubjectId from Subject where SubjectName = '走进JAVA编程世界')
)

-----------------------

select *
from Student
where StudentNo not in 
(
select StudentNo
from Result
where ExamDate = '2010-01-22' and SubjectId = (select SubjectId from Subject where SubjectName = '走进JAVA编程世界')
) and GradeId = (select GradeId from Subject where SubjectName = '走进JAVA编程世界')