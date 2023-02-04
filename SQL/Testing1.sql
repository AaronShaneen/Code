-- Testing 1

--1
SELECT c.course_no, description, cost
FROM Course c JOIN Section s
    ON c.course_no = s.course_no
  JOIN Instructor i
    ON s.instructor_id = i.instructor_id
WHERE last_name = 'Lowry'
  AND first_name = 'Charles'
ORDER BY course_no;

--2
SELECT MAX(numeric_grade) AS Highest_Final_Grade
FROM Grade g, Enrollment e, Section s
WHERE g.student_id = e.student_id
  AND g.section_id = e.section_id
  AND e.section_id = s.section_id
  AND course_no = 130
  AND grade_type_code = 'FI';

--3
SELECT first_name, last_name, phone
FROM Student JOIN Zipcode
  USING (zip)
WHERE city = 'New York'
  AND state = 'NY'
ORDER BY last_name, first_name;

--4
SELECT grade_type_code, description, number_per_section
FROM Section JOIN Grade_Type_Weight
    USING(section_id)
  JOIN Grade_type
    USING(grade_type_code)
WHERE course_no = 220
ORDER BY description;

--5
SELECT s.student_id, last_name || ', ' || first_name AS Student_Name
FROM Student s JOIN Enrollment e
    ON s.student_id = e.student_id
  JOIN Grade g
    ON (e.student_id = g.student_id
      AND e.section_id = g.section_id)
GROUP BY s.student_id, last_name, first_name
HAVING AVG(numeric_grade) < 80
ORDER BY s.last_name, s.first_name;

--6
SELECT cost, COUNT(*) AS Courses
FROM Course
GROUP BY cost
HAVING COUNT(*) > 2
ORDER BY cost;

--7
SELECT course_no, COUNT(*) AS Enrolled
FROM Enrollment JOIN Section
    USING(section_id)
  JOIN Course
    USING(course_no)
WHERE prerequisite IS NULL
GROUP BY course_no 
ORDER BY Enrolled;

--8
SELECT DISTINCT first_name, last_name,
  TO_CHAR(enroll_date, 'DD-MON-YYYY HH:MI AM') AS Enrollment_Date
FROM Zipcode z, Student s, Enrollment e
WHERE z.zip = s.zip
  AND s.student_id = e.student_id
  AND city = 'Stamford'
  AND state = 'CT'
  AND enroll_date > TO_DATE('19-FEB-07 10:20 AM', 'DD-MON-YY HH:MI AM')
ORDER BY last_name, first_name;

--9
SELECT c.course_no, c.description
FROM Course c JOIN Section s
    ON c.course_no = s.course_no
  JOIN Grade_Type_Weight gtw
    ON s.section_id = gtw.section_id
  JOIN Grade_Type gt
    ON gtw.grade_type_code = gt.grade_type_code
WHERE gt.description = 'Project'
ORDER BY course_no;

--10
SELECT c.course_no, p.course_no AS Prerequisite, p.description
FROM Course c JOIN Course p
  ON c.prerequisite = p.course_no
WHERE c.course_no BETWEEN 300 AND 399
ORDER BY c.course_no;