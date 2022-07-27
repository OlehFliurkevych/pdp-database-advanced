# pdp-database-advanced

project for resolving tasks from _**Database advanced**_ module in scope of preparing to assesment.

### Consists of the following submodules:
 - Tunning and performance optimization
 - Query Processing
 - SQL for Data Scientists

## Tasks

[task.sql](https://github.com/OlehFliurkevych/pdp-database-advanced/blob/master/task.sql) contains the following queries: 
 - all primary skills that contain more than one word (please note that both ‘-‘ and ‘ ’ could be used as a separator)
 - all students who do not have a second name (it is absent or consists of only one letter/letter with a dot)
 - number of students passed exams for each subject and order result by a number of student descending
 - the number of students with the same exam marks for each subject
 - students who passed at least two exams for different subjects
 - students who passed at least two exams for the same subject
 - all subjects which exams passed only students with the same primary skills
 - all subjects which exams passed only students with the different primary skills. It means that all students passed the exam for the one subject must have different primary skill
 - students who do not pass any exam using each of the following operator: 'outer join', 'not in', 'any'
 - all students whose average mark is bigger than the overall average mark
 - the top 5 students who passed their last exam better than average students
 - the biggest mark for each student and add text description for the mark (use COALESCE and WHEN operators)
 - the number of all marks for each mark type (‘BAD’, ‘AVERAGE’,…)