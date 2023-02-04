-- Joins & Unions

--1
SELECT e.student_id, first_name, last_name
FROM Student s JOIN Enrollment e
  ON s.student_id = e.student_id
GROUP BY e.student_id, first_name, last_name
HAVING COUNT(*) =
(SELECT MAX(Num_Enrolled)
FROM
(SELECT e.student_id, COUNT(*) AS Num_Enrolled
FROM Student s JOIN Enrollment e
  ON s.student_id = e.student_id
GROUP BY e.student_id))
ORDER BY last_name, first_name;

--2
SELECT i.first_name, i.last_name, i.phone
FROM Instructor i JOIN Section s
    ON i.instructor_id = s.instructor_id
  JOIN Enrollment e
    ON s.section_id = e.section_id
  JOIN Student s
    ON e.student_id = s.student_id
WHERE i.zip =
(SELECT zip
FROM Instructor i JOIN Section s
  ON i.instructor_id = s.instructor_id
INTERSECT
SELECT zip
FROM Student s JOIN Enrollment e
  ON s.student_id = e.student_id)
AND s.zip =
(SELECT zip
FROM Instructor i JOIN Section s
  ON i.instructor_id = s.instructor_id
INTERSECT
SELECT zip
FROM Student s JOIN Enrollment e
  ON s.student_id = e.student_id)
ORDER BY i.first_name, i.last_name;

--3
SELECT first_name, last_name, city, 'Student' AS Role
FROM Student s JOIN Zipcode z
  ON s.zip = z.zip
WHERE s.zip = 10025
UNION
SELECT first_name, last_name, city, 'Instructor' AS Role
FROM Instructor i JOIN Zipcode z
  ON i.zip = z.zip
WHERE i.zip = 10025
ORDER BY Role, last_name, first_name;

--4
SELECT location, Num_Sections AS Sections, Num_Students AS Students
FROM
(SELECT location, COUNT(section_id) AS Num_Sections
FROM Section
GROUP BY location)
JOIN
(SELECT location, COUNT(student_id) AS Num_Students
FROM Enrollment e JOIN Section s
  ON e.section_id = s.section_id
GROUP BY location)
  USING(location)
ORDER BY location;

--5
SELECT grade_type_code, TO_CHAR(numeric_grade, '99.99') AS Grade
FROM Grade
WHERE student_id = 127
  AND section_id = 95
UNION ALL
SELECT 'Average for student 127' AS grade_type_code,
  TO_CHAR(ROUND(AVG(numeric_grade), 2), '99.99') AS Grade
FROM Grade
WHERE student_id = 127
  AND section_id = 95
ORDER BY grade_type_code DESC;