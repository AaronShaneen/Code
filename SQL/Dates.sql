-- Dates

--1
SELECT first_name, last_name, phone
FROM student
WHERE TO_CHAR(registration_date, 'MM/DD/YYYY') = '02/23/2007'
ORDER BY last_name, first_name;

--2
SELECT course_no, section_id, start_date_time
FROM section
WHERE location = 'L211'
ORDER BY start_date_time;

--3
SELECT course_no, section_id, start_date_time, instructor_id, capacity
FROM section
WHERE TO_CHAR(start_date_time, 'MON-YYYY') = 'APR-2007'
ORDER BY start_date_time, course_no;

--4
SELECT student_id, section_id, final_grade
FROM enrollment
WHERE final_grade IS NOT NULL
AND TO_CHAR(enroll_date, 'MON-YYYY') = 'JAN-2007';

--5
SELECT TO_DATE('07-JAN-13', 'DD-MON-YY') + 98 AS Semester_End_Date
FROM Dual;

--6
SELECT course_no
FROM section
WHERE location LIKE 'M%'
AND SUBSTR(location, 4, 1) IN ('1','3','5','7','9')
ORDER BY course_no;

--7
SELECT last_name, first_name
FROM student
WHERE zip = 11214
AND registration_date >= (created_date + 2)
ORDER BY last_name, first_name;

--8
SELECT first_name, last_name,
  TO_CHAR(((SYSDATE - registration_date) / 365), '9999.99') AS Years
FROM student
WHERE SUBSTR(phone, 1, 3) = '203'
ORDER BY Years DESC;

--9
SELECT DISTINCT TO_CHAR(start_date_time, 'HH:MI') AS "Start_Time"
FROM section
ORDER BY "Start_Time";

--10
SELECT student_id, section_id
FROM enrollment
WHERE TO_CHAR(enroll_date, 'HH:MI AM') = '10:20 AM'
ORDER BY student_id;