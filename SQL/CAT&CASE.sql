-- Cat & CASE

--1
SELECT first_name || ' ' || last_name AS "Student Name", phone
  FROM student
  WHERE employer = 'Board Utilities'
  ORDER BY last_name;

--2
SELECT DISTINCT employer
  FROM Student
  WHERE INSTR(employer, 'Systems') > 0
  ORDER BY employer;

--3
SELECT UPPER(last_name) || ', ' || SUBSTR(INITCAP(first_name), 1, 1) || '.' AS "Student Name", phone 
  FROM student
  WHERE SUBSTR(phone, 1, 3) = 212
  ORDER BY last_name;

--4
SELECT first_name || ' ' || last_name AS "Student", street_address, zip
  FROM student
  WHERE phone IS NULL;

--5
SELECT zip
  FROM zipcode
  WHERE city = 'Jersey City' AND state = 'NJ'
  ORDER BY zip;

--6
SELECT course_no, location
  FROM section
  WHERE location LIKE 'M%'
  ORDER BY course_no;

--7
SELECT
  CASE
    WHEN state = 'MA' THEN 'Massachusetts'
    WHEN state = 'FL' THEN 'Florida'
    WHEN state = 'GA' THEN 'Georgia'
  END AS "State Name", state, city
  FROM zipcode
  WHERE state IN ('MA', 'FL', 'GA')
  ORDER BY city;

--8
SELECT salutation || '. ' || first_name || ' ' || last_name || ' ' || street_address || ' ' || zip AS "Instructor Address"
  FROM Instructor
  WHERE zip = 10025
  ORDER BY first_name, last_name;

--9
SELECT student_id, numeric_grade
  FROM grade
  WHERE section_id = 87
  AND grade_type_code = 'FI'
  ORDER BY numeric_grade DESC;

--10
SELECT student_id, numeric_grade,
  CASE 
    WHEN numeric_grade >= 85 THEN 'PASS'
    ELSE 'FAIL'
  END AS "RESULT"
  FROM grade
  WHERE section_id = 103 
  AND grade_type_code = 'FI'
  ORDER BY numeric_grade;