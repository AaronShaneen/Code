-- Testing

--1
SELECT first_name, last_name, Sections
FROM Instructor i LEFT OUTER JOIN
  (SELECT instructor_id, COUNT(*) AS Sections
  FROM Section
  GROUP BY instructor_id) s
    ON i.instructor_id = s.instructor_id
ORDER BY last_name;

--2
SELECT s.course_no
FROM Section s JOIN Enrollment e
    ON s.section_id = e.section_id
  JOIN Grade g
    ON e.section_id = g.section_id
    AND e.student_id = g.student_id
GROUP BY s.course_no
HAVING COUNT(DISTINCT g.grade_type_code) =
  (SELECT COUNT(*)
  FROM Grade_Type)
ORDER BY s.course_no;

--3
SELECT x.zip, NVL(Students, 0) AS Students
FROM
  (SELECT zip
  FROM Zipcode
  WHERE city = 'Flushing'
    AND state = 'NY') x
    LEFT OUTER JOIN
  (SELECT zip, COUNT(*) AS Students
  FROM
    (SELECT DISTINCT s.zip, s.student_id
    FROM Student s JOIN Enrollment e
        ON s.student_id = e.student_id)
  GROUP BY zip) y
    ON x.zip = y.zip
ORDER BY zip;

--4
SELECT c.course_no, c.description, NVL(Enrollments, 0) AS Enrollments
FROM Course c LEFT OUTER JOIN
  (SELECT c.course_no, description, COUNT(*) AS Enrollments
  FROM Course c JOIN Section s
      ON c.course_no = s.course_no
    JOIN Enrollment e
      ON s.section_id = e.section_id
  WHERE description LIKE '%Java%'
  GROUP BY c.course_no, description) e
    ON c.course_no = e.course_no
WHERE c.description LIKE '%Java%'
ORDER BY c.course_no;

--5
SELECT s.student_id, s.first_name, s.last_name, NVL(TO_CHAR(Enrollments, 0), 'none') AS Enrollments
FROM Student s LEFT OUTER JOIN
(SELECT e.student_id, first_name, last_name, COUNT(*) AS Enrollments
FROM Student s JOIN Enrollment e
    ON s.student_id = e.student_id
WHERE SUBSTR(phone, 1, 3) = 617
GROUP BY e.student_id, first_name, last_name) x
  ON s.student_id = x.student_id
WHERE SUBSTR(phone, 1, 3) = 617
ORDER BY last_name, first_name;