--1

SELECT DISTINCT primary_skill
FROM student s
WHERE primary_skill like '% %'
  OR primary_skill like '%-%';

--2

SELECT *
FROM student s
WHERE surname like '%.%'
  OR length(surname) = 1;

--3

SELECT phone_numbers
FROM student s
INNER JOIN results r ON s.id = r.student_id
WHERE mark > 7
ORDER BY phone_numbers DESC  

--4

SELECT subquery2.std_id
FROM
  (SELECT rst.student_id AS std_id,
          COUNT (rst.mark) AS count_mark
   FROM results rst
   GROUP BY rst.student_id,
            rst.mark) subquery1
INNER JOIN
  (SELECT rst.student_id AS std_id,
          COUNT (rst.mark) AS count_mark
   FROM results rst
   GROUP BY rst.student_id) subquery2 ON subquery1.std_id = subquery2.std_id
AND subquery1.count_mark = subquery2.count_mark
WHERE subquery2.count_mark > 1
ORDER BY subquery2.std_id ASC

--5

SELECT st.id AS student_id
FROM student st
INNER JOIN results rs ON st.id = rs.student_id
WHERE rs.mark > 7 GROUP  BY st.id
HAVING Count(rs.student_id) >= 2

--6
                         
SELECT rst.student_id AS std_id
FROM results rst
WHERE rst.mark > 7
GROUP BY rst.subject_id,
         rst.student_id
HAVING count(rst.mark) > 1
                   
--7
                   
SELECT rst.subject_id AS sbj_id
FROM student std
INNER JOIN results rst ON std.id = rst.student_id
WHERE rst.mark > 7
GROUP BY rst.subject_id
HAVING COUNT (rst.student_id) > 1
AND count(DISTINCT std.primary_skill) = 1
                   
--8

SELECT sbj_id
FROM
  (SELECT count(DISTINCT std.primary_skill) AS count_skills,
          rst.subject_id AS sbj_id,
          COUNT (rst.student_id) AS count_students
   FROM student std
   INNER JOIN results rst ON std.id = rst.student_id
   WHERE rst.mark > 7
   GROUP BY rst.subject_id
   ORDER BY count_skills DESC) AS subquery
WHERE subquery.count_skills = subquery.count_students            
               
--9

--outer join

SELECT s
FROM
  (SELECT rs.student_id AS student_id,
          Count(rs.student_id) AS count_marks
   FROM results rs
   WHERE rs.mark <= 7
   GROUP BY rs.student_id) subquary1
FULL
  OUTER JOIN
  (SELECT rs.student_id AS student_id,
          Count(rs.student_id) AS count_marks
   FROM results rs
   GROUP BY rs.student_id) subquary2 ON (subquary1.student_id = subquary2.student_id
                                         AND subquary1.count_marks = subquary2.count_marks)
FULL
  OUTER JOIN student s ON subquary1.student_id = s.id
WHERE (subquary1.student_id IS NOT NULL
       OR subquary1.count_marks IS NOT NULL)
  AND (subquary2.student_id IS NOT NULL
       OR subquary2.count_marks IS NOT NULL)
 
--not in

SELECT std
FROM student std
INNER JOIN results rst ON std.id = rst.student_id
WHERE std.id not in
    (SELECT rs.student_id AS student_id
     FROM results rs
     WHERE rs.mark > 7
     GROUP BY rs.student_id)
GROUP BY std.id

--any 

SELECT std
FROM student std
INNER JOIN results rst ON std.id = rst.student_id
WHERE std.id = any
    (SELECT rs.student_id AS student_id
     FROM results rs
     WHERE rs.mark <= 7
     GROUP BY rs.student_id)
GROUP BY std.id

--10

SELECT st
FROM student st
INNER JOIN
  (SELECT rst.student_id AS std_id,
          avg(rst.mark) AS avg_std_mark
   FROM results rst
   GROUP BY rst.student_id) subquery ON st.id = subquery.std_id
WHERE subquery.avg_std_mark >
    (SELECT avg(rs.mark)
     FROM results rs)

--11 

SELECT st
FROM student st
INNER JOIN
  (SELECT rst.student_id AS std_id,
          max(rst.mark) AS std_mark
   FROM results rst
   WHERE rst.mark > 7
   GROUP BY rst.student_id,
            rst.mark
   ORDER BY rst.mark ASC) subquery ON st.id = subquery.std_id
WHERE subquery.std_mark >
    (SELECT avg(rs.mark)
     FROM results rs)
LIMIT 5
     
--12

SELECT std.id,
       coalesce((CASE
                     WHEN subquery.std_mark = 1
                          OR subquery.std_mark = 2
                          OR subquery.std_mark = 3 THEN 'bad'
                     WHEN subquery.std_mark = 4
                          OR subquery.std_mark = 5
                          OR subquery.std_mark = 6 THEN 'average'
                     WHEN subquery.std_mark = 7
                          OR subquery.std_mark = 8 THEN 'good'
                     WHEN subquery.std_mark = 9
                          OR subquery.std_mark = 10 THEN 'excellent'
                 END), 'not passed') AS mark_desc
FROM student std
LEFT JOIN
  (SELECT rst.student_id AS std_id,
          max(rst.mark) AS std_mark
   FROM results rst
   GROUP BY rst.student_id) subquery ON std.id = subquery.std_id

--13

SELECT mark_desc,
       count(mark_desc)
FROM
  (SELECT std.id,
          (CASE
               WHEN subquery.std_mark = 1
                    OR subquery.std_mark = 2
                    OR subquery.std_mark = 3 THEN 'bad'
               WHEN subquery.std_mark = 4
                    OR subquery.std_mark = 5
                    OR subquery.std_mark = 6 THEN 'average'
               WHEN subquery.std_mark = 7
                    OR subquery.std_mark = 8 THEN 'good'
               WHEN subquery.std_mark = 9
                    OR subquery.std_mark = 10 THEN 'excellent'
               ELSE 'not passed'
           END) AS mark_desc
   FROM student std
   LEFT JOIN
     (SELECT rst.student_id AS std_id,
             max(rst.mark) AS std_mark
      FROM results rst
      GROUP BY rst.student_id) subquery ON std.id = subquery.std_id) subquery1
GROUP BY mark_desc
