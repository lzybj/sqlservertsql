if
(
exists(select *
from student where gradeid = (select gradeid from Grade where GradeName = 's1'))
)
begin
--将这些学生放入到新表
select *
INTO student3
from Student
where GradeId = (select GradeId from Grade where GradeName = 'S1')
--同时，更新年级
update student3 set gradeid = (select gradeid from Grade where GradeName = 'S2')
end

