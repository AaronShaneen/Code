-- Testing 3

--1
SELECT last_name, first_name
FROM Instructor
WHERE instructor_id NOT IN
  (SELECT i.instructor_id
  FROM Instructor i JOIN Section s
      ON i.instructor_id = s.instructor_id
    JOIN Grade_Type_Weight gtw
      ON s.section_id = gtw.section_id
    JOIN Grade g
      ON gtw.section_id = g.section_id
      AND gtw.grade_type_code = g.grade_type_code
  WHERE g.grade_type_code = 'PJ')
ORDER BY last_name, first_name;

--2
SELECT COUNT(Below_AVG) AS Below_Average
FROM
  (SELECT student_id AS Below_AVG
  FROM Grade
  WHERE grade_type_code = 'FI'
    AND section_id = 86
    AND numeric_grade <
      (SELECT ROUND(AVG(numeric_grade), 2)
      FROM Grade
      WHERE grade_type_code = 'FI'
        AND section_id = 86));

--3
SELECT city, state
FROM Enrollment e JOIN Student s
    ON e.student_id = s.student_id
  JOIN Zipcode z
    ON s.zip = z.zip
GROUP BY city, state
HAVING COUNT(*) = 
  (SELECT MAX(Students_Enrolled)
  FROM
    (SELECT city, state, COUNT(*) AS Students_Enrolled
    FROM Enrollment e JOIN Student s
        ON e.student_id = s.student_id
      JOIN Zipcode z
        ON s.zip = z.zip
    GROUP BY city, state));

--4
SELECT g.student_id, first_name, last_name
FROM Student s JOIN Enrollment e
    ON s.student_id = e.student_id
  JOIN Grade g
    ON e.student_id = g.student_id
    AND e.section_id = g.section_id
WHERE g.section_id = 81
  AND grade_type_code = 'FI'
  AND numeric_grade = 
    (SELECT MIN(numeric_grade)
    FROM
      (SELECT numeric_grade
      FROM Grade
      WHERE section_id = 81
        AND grade_type_code = 'FI'));