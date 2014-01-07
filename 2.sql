--select subjectid from Subject where SubjectName = 'C#语言和数据库技术'

--select MAX(ExamDate) from Result where SubjectId = (select subjectid from Subject where SubjectName = 'C#语言和数据库技术')

if(
not exists(
select *
from Result
where SubjectId = (select subjectid from Subject where SubjectName = 'C#语言和数据库技术')
  and 
ExamDate = (select MAX(ExamDate) from Result where SubjectId = (select subjectid from Subject where SubjectName = 'C#语言和数据库技术'))
 and StudentResult >= 60))
begin
	print '每人加三分'
	update Result set StudentResult = StudentResult + 3 where SubjectId = (select SubjectId from Subject where SubjectName='C#语言和数据库技术') and ExamDate = (select MAX(ExamDate) from Result where SubjectId = (select subjectid from Subject where SubjectName = 'C#语言和数据库技术'))
end
else
begin
	print '每人加1分'
	update Result set StudentResult = StudentResult + 1 where SubjectId = (select SubjectId from Subject where SubjectName='C#语言和数据库技术') and ExamDate = (select MAX(ExamDate) from Result where SubjectId = (select subjectid from Subject where SubjectName = 'C#语言和数据库技术')) and StudentResult <= 99
end


select GradeId from Grade where GradeName = 's1'

if(
exists(
select * from Student where GradeId = (select GradeId from Grade where GradeName = 's1')
)
)
begin
 update Student set GradeId = (select GradeId from Grade where GradeName = 's2') where GradeId = (select GradeId from Grade where GradeName = 's1')
end


