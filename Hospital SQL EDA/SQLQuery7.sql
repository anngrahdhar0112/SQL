-- Write a query in SQL to find all the information of the nurses who are yet to be registered.
SELECT * FROM Nurse
WHERE Registered='false';


-- Write a query in SQL to find the name of the nurse who are the head of their department.
SELECT * FROM Nurse
WHERE Position = 'Head Nurse';


-- Write a query in SQL to obtain the name of the physicians who are the head of each department.
SELECT p.Name AS 'Name of the Physician', d.name AS 'Department Name'
FROM Physician p, Department d
WHERE d.head = p.employeeid;


-- Write a query in SQL to count the number of patients who booked an appointment with at least one physician
SELECT COUNT(DISTINCT patient) as 'Count of patients who took atleast one test'
FROM Appointment;


-- Write a query in SQL to find the floor and block where the room number 212 belongs to
SELECT blockfloor as Floor, blockcode as Code
FROM room
WHERE number =212;


-- Write a query in SQL to count the number available rooms
SELECT COUNT(*) as 'No. of Available Rooms' FROM Room
WHERE unavailable = 'false';


-- Write a query in SQL to count the number of unavailable rooms
SELECT COUNT(*) as 'No. of Unavailable Rooms' FROM Room
WHERE unavailable = 'true';


-- Write a query in SQL to obtain the name of the physician and the departments they are affiliated with.
SELECT p.name, d.name
FROM Physician p, Department d, Affiliated_With a
WHERE p.employeeid = a.physician 
AND
	  d.departmentid = a.department;


-- Write a query in SQL to obtain the name of the physicians who are trained for a special treatement.
SELECT p.name, pro.name
FROM physician p, procedures pro, trained_in t
WHERE p.employeeid = t.physician
AND
	  pro.code = t.treatment;


-- Write a query in SQL to obtain the name of the physicians with department who are yet to be affiliated
SELECT p.name, d.name
FROM physician p, department d, Affiliated_With a
WHERE p.employeeid = a.physician
AND
	  d.departmentid = a.department
AND
      a.primaryaffiliation = 'false'


-- Write a query in SQL to obtain the name of the physicians who are not a specialized physician
SELECT p.name as Name, p.position as Position
FROM physician p
LEFT JOIN trained_in t
ON 
p.employeeid = t.physician
WHERE t.Treatment is NULL;


--  Write a query in SQL to obtain the name of the patients with their physicians by whom they got their preliminary treatement
SELECT pt.name, phy.name
FROM patient pt, physician phy
WHERE pt.pcp = phy.employeeid;


-- Write a query in SQL to count number of unique patients who got an appointment for examination room C.
SELECT COUNT(DISTINCT patient)
FROM appointment
WHERE examinationroom = 'C';


-- Write a query in SQL to find the name of the patients and the number of the room where they have to go for their treatment.
SELECT pt.name, a.examinationroom
FROM appointment a
INNER JOIN patient pt
ON a.patient = pt.ssn;


-- 16. Write a query in SQL to find the name of the nurses and the room scheduled, where they will assist the physicians.
SELECT n.name, a.examinationroom
FROM appointment a
INNER JOIN nurse n
ON
a.prepnurse = n.employeeid; 


-- Write a query in SQL to find the name of the patients who taken the appointment on the 25th of April at 10 am, 
-- and also display their physician, assisting nurses and room no.
SELECT pt.name AS 'Patient Name', phy.name AS 'Physician Name', n.name AS 'Name of the Nurse', a.examinationroom AS 'ROOM',
a.start_Date AS 'Date'
FROM appointment a
INNER JOIN patient pt 
ON a.patient = pt.ssn

INNER JOIN nurse n 
ON a.prepnurse = n.employeeid 

INNER JOIN physician phy 
ON a.physician = phy.employeeid

WHERE a.start_Date = '2008-04-25 10:00:00';


-- Write a query in SQL to find the name of patients and their physicians who does not require any assistance of a nurse
SELECT pt.name AS 'Patient Name', phy.name AS 'Physician name'
FROM appointment a
INNER JOIN physician phy 
ON a.physician=phy.employeeid

INNER JOIN patient pt
ON a.patient=pt.ssn

WHERE a.prepnurse IS NULL;


-- Write a query in SQL to find the name of the patients, their treating physicians and medication
SELECT pt.name AS 'Name of the patient', phy.name AS 'Name of the physician', m.name AS 'Name of the medication'
FROM prescribes p

INNER JOIN patient pt
ON p.patient = pt.ssn

INNER JOIN physician phy
ON p.physician = phy.employeeid

INNER JOIN medication m
ON p.medication = m.code;


-- Write a query in SQL to find the name of the patients who taken an advanced appointment, 
-- and also display their physicians and medication.
SELECT pt.name AS 'Patient', phy.name AS 'Physician', m.name AS 'Medication'
FROM patient pt
INNER JOIN prescribes p 
ON p.patient=pt.ssn

INNER JOIN physician phy 
ON p.physician=phy.employeeid

INNER JOIN medication m 
ON p.medication=m.code

WHERE p.appointment IS NOT NULL;


-- Write a query in SQL to find the name and medication for those patients who did not take any appointment
SELECT pt.name AS 'Patient', m.name AS 'Medication'
FROM patient pt
INNER JOIN prescribes p
ON pt.ssn = p.patient

INNER JOIN medication m
ON p.medication = m.code

WHERE p.appointment IS NULL;


-- Write a query in SQL to count the number of available rooms in each block
SELECT BlockCode, COUNT(*) AS 'No. of Available Rooms'
FROM Room
WHERE Unavailable = 'false'
GROUP BY BlockCode;


-- Write a query in SQL to count the number of available rooms in every floor of each block.
SELECT BlockCode, BlockFloor, COUNT(*) AS 'No. of Available Rooms'
FROM Room
WHERE Unavailable = 'false'
GROUP BY BlockCode, BlockFloor
ORDER BY BlockCode;


-- Write a query in SQL to count the number of unavailable rooms in each block
SELECT BlockCode, COUNT(*) AS 'No. of Un-Available Rooms'
FROM Room
WHERE Unavailable = 'true'
GROUP BY BlockCode;


-- Write a query in SQL to count the number of unavailable rooms in every floor of each block.
SELECT BlockCode, BlockFloor, COUNT(*) AS 'No. of Un-Available Rooms'
FROM Room
WHERE Unavailable = 'true'
GROUP BY BlockCode, BlockFloor
ORDER BY BlockCode; 


-- Write a query in SQL to obtain the name of the patients, their block, floor, and room number where they are admitted.
SELECT pt.name AS 'Name of the Patient', r.blockcode AS 'Block', r.blockfloor AS 'Floor No.', r.number AS 'Room Number',
s.Start_Date AS 'Day of Admission'
FROM stay s

INNER JOIN patient pt
ON s.patient = pt.ssn

INNER JOIN room r
ON s.room = r.number;



--  Write a query in SQL to obtain the nurses and the block where they are booked for attending the patients on call.
SELECT n.name, o.blockcode
FROM nurse n
INNER JOIN on_call o
ON n.employeeid = o.nurse;


-- Write a query in SQL to make a report which will show - a) name of the patient, 
-- b) name of the physician who is treating him or her, c) name of the nurse who is attending him or her, 
-- d) which treatement is going on to the patient, e) the date of release, 
-- f) in which room the patient has admitted and which floor and block the room belongs to respectively.
SELECT pt.name AS 'Patient', phy.name AS 'Physician', n.name AS 'Nurse', pr.name AS 'Treatment', s.End_Dtae AS 'Release Time', 
r.number AS 'Room Number', r.blockcode AS 'Block Code', r.blockfloor AS 'Block Floor'
FROM undergoes u

INNER JOIN patient pt
ON u.patient = pt.ssn

INNER JOIN physician phy
ON u.physician = phy.employeeid

INNER JOIN stay s
ON u.patient = s.patient

INNER JOIN room r
ON s.room = r.number

INNER JOIN procedures pr
ON u.procedures = pr.code


LEFT JOIN nurse n
ON u.AssistingNurse = n.EmployeeID;


-- Write a SQL query to obtain the names of all the physicians performed a medical procedure but they are not ceritifed 
-- to perform.
SELECT phy.name
FROM Physician phy
WHERE employeeid IN
	(
		SELECT u.physician 
		FROM undergoes u
		LEFT JOIN Trained_In t
		ON u.Physician = t.Physician AND u.procedures =  t.Treatment
		WHERE treatment is NULL
	); 


-- Write a query in SQL to obtain the name and position of all physicians who completed a medical procedure 
-- with certification after the date of expiration of their certificate.
SELECT phy.name, phy.position
FROM physician phy
WHERE employeeid IN
	(
		SELECT physician
		FROM undergoes u
		WHERE date >
			(
				SELECT certificationExpires
				FROM trained_in t
				WHERE t.physician = u.physician 
				AND
				t.treatment = u.procedures 
			)
	);


-- Write a query in SQL to Obtain the names of all patients whose primary care is taken by a physician who is not the 
-- head of any department and name of that physician along with their primary care physician.
SELECT pt.name AS 'Patient', phy.name AS "Primary care Physician"
FROM Patient pt
INNER JOIN physician phy
ON pt.pcp = phy.EmployeeID
WHERE pt.pcp NOT IN
	(
		SELECT head
		FROM department
	);
