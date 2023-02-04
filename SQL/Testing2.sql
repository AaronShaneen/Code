-- Testing 2

--1
SELECT e.student_id
FROM Enrollment e JOIN Section s
  ON e.section_id = s.section_id
WHERE e.section_id BETWEEN 100 AND 199
GROUP BY e.student_id
HAVING COUNT(*) =
  (SELECT MAX(Num_Enrolled)
  FROM
    (SELECT e.student_id, COUNT(*) AS Num_Enrolled
    FROM Enrollment e JOIN Section s
      ON e.section_id = s.section_id
    WHERE e.section_id BETWEEN 100 AND 199
    GROUP BY e.student_id))
ORDER BY COUNT(*);

--2
SELECT st.student_id, last_name, first_name
FROM Student st JOIN Enrollment e
    ON st.student_id = e.student_id
  JOIN Section se
    ON e.section_id = se.section_id
  JOIN Grade g
    ON g.student_id = e.student_id
    AND g.section_id = e.section_id
WHERE course_no = 230
  AND se.section_id = 100
  AND grade_type_code = 'FI'
  AND numeric_grade =
    (SELECT MAX(numeric_grade)
    FROM Grade g JOIN Enrollment e
        ON g.student_id = e.student_id
        AND g.section_id = e.section_id
      JOIN Section s
        ON e.section_id = s.section_id
    WHERE course_no = 230
      AND s.section_id = 100
      AND grade_type_code = 'FI')
ORDER BY last_name, first_name;

--3
SELECT salutation, first_name, last_name, NVL2(zip, zip, ' ') AS ZIP
FROM Instructor
WHERE instructor_id NOT IN
  (SELECT i.instructor_id
  FROM Instructor i JOIN Section s
    ON i.instructor_id = s.instructor_id)
ORDER BY last_name, first_name;

--4
SELECT last_name, numeric_grade AS Final_Exam_Grade
FROM Student s JOIN Enrollment e
    ON s.student_id = e.student_id
  JOIN Grade g
    ON e.student_id = g.student_id
    AND e.section_id = g.section_id
WHERE grade_type_code = 'FI'
  AND g.section_id = 90
  AND numeric_grade >=
    (SELECT AVG(numeric_grade)
    FROM Grade
    WHERE grade_type_code = 'FI'
      AND section_id = 90)
ORDER BY last_name;

--5
SELECT c.course_no, description
FROM Course c JOIN Section s
    ON c.course_no = s.course_no
  JOIN Enrollment e
    ON s.section_id = e.section_id
GROUP BY c.course_no, description
HAVING COUNT(*) =
  (SELECT MAX(Highest_Enrolled)
  FROM  
    (SELECT s.course_no, COUNT(*) AS Highest_Enrolled
    FROM Course c JOIN Section s
        ON c.course_no = s.course_no
      JOIN Enrollment e
        ON s.section_id = e.section_id
    GROUP BY s.course_no))
ORDER BY c.course_no;

--6
SELECT c.course_no, description
FROM Course c JOIN Section s
  ON c.course_no = s.course_no
GROUP BY c.course_no, description
HAVING c.course_no IN
  (SELECT c.course_no
  FROM Course c JOIN Section s
    ON c.course_no = s.course_no
  WHERE TO_CHAR(start_date_time, 'HH24:MI') = '10:30'
  GROUP BY c.course_no
  HAVING COUNT(*) >= 1)
ORDER BY course_no;

--7
SELECT g.student_id, last_name
FROM Grade g JOIN Enrollment e
    ON g.student_id = e.student_id
    AND g.section_id = e.section_id
  JOIN Student s
    ON e.student_id = s.student_id
WHERE g.section_id = 135
  AND grade_type_code = 'QZ'
  AND grade_code_occurrence = 3
  AND numeric_grade <
    (SELECT AVG(numeric_grade)
    FROM Grade
    WHERE section_id = 135
      AND grade_type_code = 'QZ'
      AND grade_code_occurrence = 3)
ORDER BY last_name;

--8
SELECT first_name, last_name, phone
FROM Student
WHERE student_id IN
  (SELECT st.student_id
  FROM Course c JOIN Section s
      ON c.course_no = s.course_no
    JOIN Enrollment e
      ON s.section_id = e.section_id
    JOIN Student st
      ON e.student_id = st.student_id
WHERE description = 'Systems Analysis')
  AND student_id IN
    (SELECT st.student_id
    FROM Course c JOIN Section s
        ON c.course_no = s.course_no
      JOIN Enrollment e
        ON s.section_id = e.section_id
      JOIN Student st
        ON e.student_id = st.student_id
    WHERE description = 'Project Management')
ORDER BY last_name, first_name;

--9
SELECT first_name, last_name, c.course_no, description
FROM Instructor i JOIN Section s
    ON i.instructor_id = s.instructor_id
  JOIN Course c
    ON s.course_no = c.course_no
WHERE description LIKE '%Java%'
  AND i.instructor_id = 
    (SELECT i.instructor_id
    FROM Course c JOIN Section s
        ON c.course_no = s.course_no
      JOIN Instructor i
        ON s.instructor_id = i.instructor_id
    WHERE description LIKE '%Java%'
    GROUP BY i.instructor_id
    HAVING COUNT(*) = 
      (SELECT MAX(Num_Courses)
      FROM
        (SELECT i.instructor_id, COUNT(*) AS Num_Courses
        FROM Course c JOIN Section s
            ON c.course_no = s.course_no
          JOIN Instructor i
            ON s.instructor_id = i.instructor_id
        WHERE description LIKE '%Java%'
        GROUP BY i.instructor_id)))
ORDER BY first_name, last_name, description;