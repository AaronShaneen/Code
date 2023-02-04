-- Testing 4

--1
INSERT INTO Instructor
  (instructor_id, salutation, first_name, last_name, street_address, zip,
  created_by, created_date, modified_by, modified_date)
VALUES
  ('815', 'Mr', 'Hugo', 'Reyes', '2342 Oceanic Way', '07002', USER, SYSDATE, USER,
  SYSDATE);

--2
INSERT INTO Section
  (section_id, course_no, section_no, start_date_time, location, instructor_id,
  capacity, created_by, created_date, modified_by, modified_date)
VALUES
  (48, 142, 4, TO_DATE('22-SEP-11 08:15 AM', 'DD-MON-YY HH:MI AM'), 
  'L211', 815, 15, USER, SYSDATE, USER, SYSDATE);

--3
INSERT INTO Enrollment
  (student_id, section_id, enroll_date, created_by, created_date, modified_by, 
  modified_date)
(SELECT student_id, 48, SYSDATE, USER, SYSDATE, USER, SYSDATE
FROM Student
WHERE student_id IN (375, 137, 266, 382));

--4
DELETE FROM Grade
WHERE student_id = 147
  AND section_id = 120;

DELETE FROM Enrollment
WHERE student_id = 147
  AND section_id = 120;

--5
DELETE FROM Grade
WHERE student_id = 180
  AND section_id = 119;

DELETE FROM Enrollment
WHERE student_id = 180
  AND section_id = 119;

--6
UPDATE Instructor
SET phone = 4815162342
WHERE instructor_id = 185;

--7
UPDATE Grade
SET numeric_grade = 100
WHERE section_id = 119
  AND grade_type_code = 'HM'
  AND grade_code_occurrence = 1;

--8
UPDATE Grade
SET  numeric_grade = numeric_grade + (numeric_grade * 0.10)
WHERE section_id = 119
  AND grade_type_code = 'FI';

--9
SELECT x.section_id, x.location, NVL(y.Enrolled, 0) AS Enrolled
FROM
  (SELECT s.section_id, location, COUNT(*) AS Enrolled
  FROM Course c LEFT OUTER JOIN Section s
    ON c.course_no = s.course_no
  WHERE description = 'Project Management'
  GROUP BY s.section_id, location) x
LEFT OUTER JOIN
  (SELECT s.section_id, location, COUNT(*) AS Enrolled
  FROM Course c LEFT OUTER JOIN Section s
      ON c.course_no = s.course_no
    JOIN Enrollment e
      ON s.section_id = e.section_id
  WHERE description = 'Project Management'
  GROUP BY s.section_id, location) y
  ON x.section_id = y.section_id
ORDER BY x.section_id;

--10
SELECT first_name, last_name, phone
FROM Course c JOIN Section s
    ON c.course_no = s.course_no
  JOIN Instructor i
    ON s.instructor_id = i.instructor_id
WHERE description = 'Project Management'
ORDER BY first_name, last_name;

--11
SELECT g.student_id, first_name, last_name, ROUND(AVG(numeric_grade), 2) AS AVG
FROM Grade g JOIN Enrollment e
    ON g.student_id = e.student_id
    AND g.section_id = e.section_id
  JOIN Student s
    ON e.student_id = s.student_id
WHERE g.section_id = 119
GROUP BY g.student_id, first_name, last_name
ORDER BY g.student_id;