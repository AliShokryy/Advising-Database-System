﻿--2.1
--1
CREATE DATABASE Advising_Team_6;

--2
GO
CREATE PROCEDURE CreateAllTables
AS
	CREATE TABLE Advisor (
		advisor_id INT IDENTITY,
		name VARCHAR(40),
		email VARCHAR(40),
		office VARCHAR(40),
		password VARCHAR(40),
		CONSTRAINT pk_Advisor PRIMARY KEY(advisor_id)
	);

	CREATE TABLE Student(
		student_id INT IDENTITY,
		f_name VARCHAR(40),
		l_name VARCHAR(40),
		gpa DECIMAL(3,2),
		faculty VARCHAR(40),
		email VARCHAR(40),
		major VARCHAR(40),
		password VARCHAR(40),
		financial_status BIT,
		semester INT,
		acquired_hours INT,
		assigned_hours INT,
		advisor_id INT
		CONSTRAINT pk_Student PRIMARY KEY (student_id),
		CONSTRAINT fk_Student FOREIGN KEY (advisor_id) REFERENCES Advisor(advisor_id) ON DELETE SET NULL ON UPDATE CASCADE,
		CONSTRAINT check_assigned_hours CHECK (assigned_hours <= 34  AND assigned_hours >= 0 AND acquired_hours >=34),
		CONSTRAINT check_gpa CHECK (gpa <= 5.0 AND gpa >= 0.7)
		);

	CREATE TABLE Student_Phone(
		student_id INT,
		phone_number VARCHAR(40),
		CONSTRAINT pk_Student_Phone PRIMARY KEY( student_id , phone_number ),
		CONSTRAINT fk_Student_Phone FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE ON UPDATE CASCADE
	);

	CREATE TABLE Course(
		course_id INT IDENTITY,
		name VARCHAR(40),
		major VARCHAR(40),
		is_offered BIT,
		credit_hours INT,
		semester INT,
		CONSTRAINT pk_Course PRIMARY KEY (course_id)
	);

	CREATE TABLE PreqCourse_course(
		prerequisite_course_id INT,
		course_id INT,
		CONSTRAINT pk_PreqCourse_course PRIMARY KEY (prerequisite_course_id, course_id),
		CONSTRAINT fk_PreqCourse_course1 FOREIGN KEY (prerequisite_course_id) REFERENCES Course(course_id), --ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT fk_PreqCourse_course2 FOREIGN KEY (course_id) REFERENCES Course(course_id) -- * ON DELETE CASCADE ON UPDATE CASCADE
	); 
	
	CREATE TABLE Instructor(
		instructor_id INT IDENTITY,
		name VARCHAR(40),
		email VARCHAR(40),
		faculty VARCHAR(40),
		office VARCHAR(40),
		CONSTRAINT pk_Instructor PRIMARY KEY (instructor_id)
	);

	CREATE TABLE Instructor_Course(
		course_id INT,
		instructor_id INT,
		CONSTRAINT pk_Instructor_Course PRIMARY KEY (course_id, instructor_id),
		CONSTRAINT fk_Instructor_Course1 FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT fk_Instructor_Course2 FOREIGN KEY (instructor_id) REFERENCES Instructor(instructor_id) ON DELETE CASCADE ON UPDATE CASCADE
	);

	CREATE TABLE Student_Instructor_Course_Take (
		student_id INT,
		course_id INT,
		instructor_id INT,
		semester_code VARCHAR(40),
		exam_type VARCHAR(40) DEFAULT 'Normal',
		grade VARCHAR(40),
		CONSTRAINT pk_Student_Instructor_Course_Take PRIMARY KEY (student_id, course_id, semester_code),
		CONSTRAINT fk_Student_Instructor_Course_Take1 FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT fk_Student_Instructor_Course_Take2 FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT fk_Student_Instructor_Course_Take3 FOREIGN KEY (instructor_id) REFERENCES Instructor(instructor_id) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT exam_type_check CHECK (exam_type IN ('Normal','First_makeup','Second_makeup')),
		CONSTRAINT chk_grade CHECK (grade IN ('A+' , 'A' , 'A-' , 'B+' , 'B' , 'B-' , 'C+' , 'C' , 'C-' , 'D+' , 'D' , 'F','FF','FA')) 
	);

	CREATE TABLE Slot (
		slot_id INT IDENTITY,
		day VARCHAR(40),
		time VARCHAR(40),
		location VARCHAR(40),
		course_id INT,
		instructor_id INT,
		CONSTRAINT pk_Slot PRIMARY KEY (slot_id),
		CONSTRAINT fk_Slot1 FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE SET NULL ON UPDATE CASCADE,
		CONSTRAINT fk_Slot2 FOREIGN KEY (instructor_id) REFERENCES Instructor(instructor_id) ON DELETE SET NULL ON UPDATE CASCADE
	);

	CREATE TABLE Semester (
		semester_code VARCHAR(40),
		start_date DATE,
		end_date DATE,
		CONSTRAINT pk_Semester PRIMARY KEY (semester_code)
	);

	CREATE TABLE Course_Semester (
		course_id INT,
		semester_code VARCHAR(40),
		CONSTRAINT pk_Course_Semester PRIMARY KEY (course_id, semester_code),
		CONSTRAINT fk_Course_Semester1 FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT fk_Course_Semester2 FOREIGN KEY (semester_code) REFERENCES Semester(semester_code) ON DELETE CASCADE ON UPDATE CASCADE
	);

	CREATE TABLE Graduation_Plan (
		plan_id INT IDENTITY,
		semester_code VARCHAR(40),
		semester_credit_hours INT,
		expected_grad_date DATE, 
		advisor_id INT,
		student_id INT,
		CONSTRAINT pk_Graduation_Plan PRIMARY KEY (plan_id, semester_code),
		CONSTRAINT fk_Graduation_Plan1 FOREIGN KEY (advisor_id) REFERENCES Advisor(advisor_id) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT fk_Graduation_Plan2 FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE -- * ON UPDATE CASCADE
	);
	
	CREATE TABLE GradPlan_Course (
		plan_id INT,
		semester_code VARCHAR(40),
		course_id INT,
		CONSTRAINT pk_GradPlan_Course PRIMARY KEY (plan_id, semester_code, course_id),
		CONSTRAINT fk_GradPlan_Course1 FOREIGN KEY (plan_id,semester_code) REFERENCES Graduation_Plan(plan_id,semester_code) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT fk_GradPlan_Course2 FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE CASCADE
	);

	CREATE TABLE Request (
		request_id INT IDENTITY,
		type VARCHAR(40),
		comment VARCHAR(40),
		status VARCHAR(40) DEFAULT 'pending',
		credit_hours INT,
		student_id INT,
		advisor_id INT,
		course_id INT,
		CONSTRAINT pk_Request PRIMARY KEY (request_id),
		CONSTRAINT fk_Request1 FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE, -- * ON UPDATE CASCADE,
		CONSTRAINT fk_Request2 FOREIGN KEY (advisor_id) REFERENCES Advisor(advisor_id) ON DELETE CASCADE ON UPDATE CASCADE, 
		CONSTRAINT fk_Request3 FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE CASCADE, 
		CONSTRAINT check_Request_Status CHECK (status IN ('pending','accepted','rejected'))--,
		--CONSTRAINT check_credit_hours CHECK ((credit_hours <= 3 AND credit_hours > 0) OR credit_hours IS NULL),
	);


	CREATE TABLE MakeUp_Exam (
		exam_id INT IDENTITY,
		date DATE,
		type VARCHAR(40),
		course_id INT,
		CONSTRAINT pk_MakeUp_Exam PRIMARY KEY (exam_id),
		CONSTRAINT fk_MakeUp_Exam FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE CASCADE ,
		CONSTRAINT exam_type CHECK (type IN ('First_makeup','Second_makeup'))

	);

	CREATE TABLE Exam_Student (
		exam_id INT,
		student_id INT,
		course_id INT,
		CONSTRAINT pk_Exam_Student PRIMARY KEY (exam_id, student_id),
		CONSTRAINT fk_Exam_Student1 FOREIGN KEY (exam_id) REFERENCES MakeUp_Exam(exam_id) ON DELETE CASCADE ON UPDATE CASCADE ,
		CONSTRAINT fk_Exam_Student2 FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE ON UPDATE CASCADE 
	);

	CREATE TABLE Payment (
		payment_id INT IDENTITY,
		amount INT,
		deadline DATETIME, 
		n_installments INT NOT NULL,
		status VARCHAR(40) DEFAULT 'notPaid',
		fund_percentage DECIMAL(5, 2),
		start_date DATETIME, 
		student_id INT,
		semester_code VARCHAR(40),
		CONSTRAINT pk_Payment PRIMARY KEY (payment_id),
		CONSTRAINT fk_Payment1 FOREIGN KEY (student_id) REFERENCES Student(student_id) ON UPDATE CASCADE ,
		CONSTRAINT fk_Payment2 FOREIGN KEY (semester_code) REFERENCES Semester(semester_code) ON UPDATE CASCADE,
		CONSTRAINT check_PaymentStatus CHECK ( status IN ('notPaid','Paid'))
	);




	CREATE TABLE Installment (
		payment_id INT,
		deadline DATETIME, 
		amount INT, 
		status VARCHAR(40) DEFAULT 'notPaid',
		start_date DATETIME, 
		CONSTRAINT pk_Installment PRIMARY KEY (payment_id, deadline),
		CONSTRAINT fk_Installment FOREIGN KEY (payment_id) REFERENCES Payment(payment_id)  ON DELETE CASCADE ON UPDATE CASCADE 
	);
GO
EXEC CreateAllTables;
------
--3
GO 
CREATE PROCEDURE DropAllTables
AS
	DROP TABLE Installment;
	DROP TABLE Payment;
	DROP TABLE Exam_Student;
	DROP TABLE MakeUp_Exam;
	DROP TABLE Request;
	DROP TABLE GradPlan_Course;
	DROP TABLE Graduation_Plan;
	DROP TABLE Course_Semester;
	DROP TABLE Semester;
	DROP TABLE Slot;
	DROP TABLE Student_Instructor_Course_Take;
	DROP TABLE Instructor_Course;
	DROP TABLE Instructor;
	DROP TABLE PreqCourse_course;
	DROP TABLE Course;
	DROP TABLE Student_Phone;
	DROP TABLE Student;
	DROP TABLE Advisor;
GO
EXEC DropAllTables;
------
--4
GO
CREATE PROCEDURE clearAllTables
AS
	TRUNCATE TABLE Installment;

	ALTER TABLE Installment DROP CONSTRAINT fk_Installment;
	TRUNCATE TABLE Payment;
	ALTER TABLE Installment ADD CONSTRAINT
		fk_Installment FOREIGN KEY (payment_id) REFERENCES Payment(payment_id)  ON DELETE CASCADE ON UPDATE CASCADE ;

	TRUNCATE TABLE Exam_Student;

	ALTER TABLE Exam_Student DROP CONSTRAINT fk_Exam_Student1;
	TRUNCATE TABLE MakeUp_Exam;
	ALTER TABLE Exam_Student ADD CONSTRAINT
		fk_Exam_Student1 FOREIGN KEY (exam_id) REFERENCES MakeUp_Exam(exam_id) ON DELETE CASCADE ON UPDATE CASCADE ;

	TRUNCATE TABLE Request;
	TRUNCATE TABLE GradPlan_Course;

	ALTER TABLE GradPlan_Course DROP CONSTRAINT fk_GradPlan_Course1;
	TRUNCATE TABLE Graduation_Plan;
	ALTER TABLE GradPlan_Course ADD CONSTRAINT
		fk_GradPlan_Course1 FOREIGN KEY (plan_id,semester_code) REFERENCES Graduation_Plan(plan_id,semester_code)
		ON DELETE CASCADE ON UPDATE CASCADE ;

	TRUNCATE TABLE Course_Semester;

	ALTER TABLE Course_Semester DROP CONSTRAINT fk_Course_Semester2;
	ALTER TABLE Payment DROP CONSTRAINT fk_Payment2;
	TRUNCATE TABLE Semester;
	ALTER TABLE Course_Semester ADD CONSTRAINT
		fk_Course_Semester2 FOREIGN KEY (semester_code) REFERENCES Semester(semester_code) ON DELETE CASCADE ON UPDATE CASCADE;
	ALTER TABLE Payment ADD CONSTRAINT
		fk_Payment2 FOREIGN KEY (semester_code) REFERENCES Semester(semester_code) ON UPDATE CASCADE;

	TRUNCATE TABLE Slot;
	TRUNCATE TABLE Student_Instructor_Course_Take;
	TRUNCATE TABLE Instructor_Course;
	
	ALTER TABLE Instructor_Course DROP CONSTRAINT fk_Instructor_Course2;
	ALTER TABLE Student_Instructor_Course_Take DROP CONSTRAINT fk_Student_Instructor_Course_Take3;
	ALTER TABLE Slot DROP CONSTRAINT fk_Slot2;
	TRUNCATE TABLE Instructor;
	ALTER TABLE Instructor_Course ADD CONSTRAINT
		fk_Instructor_Course2 FOREIGN KEY (instructor_id) REFERENCES Instructor(instructor_id) ON DELETE CASCADE ON UPDATE CASCADE;
	ALTER TABLE Student_Instructor_Course_Take ADD CONSTRAINT
		fk_Student_Instructor_Course_Take3 FOREIGN KEY (instructor_id) REFERENCES Instructor(instructor_id) ON DELETE CASCADE ON UPDATE CASCADE;
	ALTER TABLE Slot ADD CONSTRAINT
		fk_Slot2 FOREIGN KEY (instructor_id) REFERENCES Instructor(instructor_id) ON DELETE CASCADE ON UPDATE CASCADE;

	TRUNCATE TABLE PreqCourse_course;

	ALTER TABLE PreqCourse_course DROP CONSTRAINT fk_PreqCourse_course1, fk_PreqCourse_course2;
	ALTER TABLE Instructor_Course DROP CONSTRAINT fk_Instructor_Course1;
	ALTER TABLE Student_Instructor_Course_Take DROP CONSTRAINT fk_Student_Instructor_Course_Take2;
	ALTER TABLE Course_Semester DROP CONSTRAINT fk_Course_Semester1;
	ALTER TABLE GradPlan_Course DROP CONSTRAINT fk_GradPlan_Course2;
	ALTER TABLE Request DROP CONSTRAINT fk_Request3;
	ALTER TABLE MakeUp_Exam DROP CONSTRAINT fk_MakeUp_Exam;
	ALTER TABLE Slot DROP CONSTRAINT fk_Slot1;
	TRUNCATE TABLE Course;
	ALTER TABLE PreqCourse_course ADD CONSTRAINT
		fk_PreqCourse_course1 FOREIGN KEY (prerequisite_course_id) REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE CASCADE;
	ALTER TABLE PreqCourse_course ADD CONSTRAINT
		fk_PreqCourse_course2 FOREIGN KEY (course_id) REFERENCES Course(course_id);
	ALTER TABLE Instructor_Course ADD CONSTRAINT
		fk_Instructor_Course1 FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE CASCADE;
	ALTER TABLE Student_Instructor_Course_Take ADD CONSTRAINT
		fk_Student_Instructor_Course_Take2 FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE CASCADE;
	ALTER TABLE Course_Semester ADD CONSTRAINT
		fk_Course_Semester1 FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE CASCADE;
	ALTER TABLE GradPlan_Course ADD CONSTRAINT
		fk_GradPlan_Course2 FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE CASCADE;
	ALTER TABLE Request ADD CONSTRAINT
		fk_Request3 FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE CASCADE;
	ALTER TABLE MakeUp_Exam ADD CONSTRAINT
		fk_MakeUp_Exam FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE CASCADE;
	ALTER TABLE Slot ADD CONSTRAINT
		fk_Slot1 FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE CASCADE;

	
	TRUNCATE TABLE Student_Phone;

	ALTER TABLE Request DROP CONSTRAINT fk_Request1;
	ALTER TABLE Exam_Student DROP CONSTRAINT fk_Exam_Student2;
	ALTER TABLE Payment DROP CONSTRAINT fk_Payment1;
	ALTER TABLE Student_Phone DROP CONSTRAINT fk_Student_Phone;
	ALTER TABLE Student_Instructor_Course_Take DROP CONSTRAINT fk_Student_Instructor_Course_Take1;
	ALTER TABLE Graduation_Plan DROP CONSTRAINT fk_Graduation_Plan2;
	TRUNCATE TABLE Student;
	ALTER TABLE Request ADD CONSTRAINT
		fk_Request1 FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE -- * ON UPDATE CASCADE;
	ALTER TABLE Exam_Student ADD CONSTRAINT
		fk_Exam_Student2 FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE ON UPDATE CASCADE;
	ALTER TABLE Payment ADD CONSTRAINT
		fk_Payment1 FOREIGN KEY (student_id) REFERENCES Student(student_id) ON UPDATE CASCADE;
	ALTER TABLE Student_Phone ADD CONSTRAINT
		fk_Student_Phone FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE ON UPDATE CASCADE;
	ALTER TABLE Student_Instructor_Course_Take ADD CONSTRAINT
		fk_Student_Instructor_Course_Take1 FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE ON UPDATE CASCADE;
	ALTER TABLE Graduation_Plan ADD CONSTRAINT
		fk_Graduation_Plan2 FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE -- * ON UPDATE CASCADE;

	ALTER TABLE Request DROP CONSTRAINT fk_Request2;
	ALTER TABLE Graduation_Plan DROP CONSTRAINT fk_Graduation_Plan1;
	ALTER TABLE Student DROP CONSTRAINT fk_Student;
	TRUNCATE TABLE Advisor;
	ALTER TABLE Request ADD CONSTRAINT
		fk_Request2 FOREIGN KEY (advisor_id) REFERENCES Advisor(advisor_id) ON DELETE CASCADE ON UPDATE CASCADE;
	ALTER TABLE Graduation_Plan ADD CONSTRAINT
		fk_Graduation_Plan1 FOREIGN KEY (advisor_id) REFERENCES Advisor(advisor_id) ON DELETE CASCADE ON UPDATE CASCADE;
	ALTER TABLE Student ADD CONSTRAINT
		fk_Student FOREIGN KEY (advisor_id) REFERENCES Advisor(advisor_id) ON DELETE SET NULL ON UPDATE CASCADE;
GO
EXEC clearAllTables;
------

--2.2
-----A
GO
	CREATE VIEW view_Students 
	AS 
		SELECT * FROM STUDENT S WHERE S.financial_status=1;
GO
SELECT * FROM view_Students;
-----B
GO
	CREATE VIEW view_Course_prerequisites 
	AS 
		SELECT C1.course_id AS 'Prerequsisite Course Id' , C1.name AS 'Prerequsisite Course Name' , C1.major AS 'Prerequisite Course Major' , C1.is_offered AS 'Prerequisite Course if offered' , C1.credit_hours AS 'Prerequisite Course Credit Hours' , C1.semester AS 'Prerequisite Course Semester' ,C2.course_id AS 'Course Id' , C2.name AS 'Course Name' , C2.major AS 'Course Major' , C2.is_offered AS 'Course if offered' , C2.credit_hours AS 'Course Credit Hours' , C2.semester AS 'Course Semester'  
		FROM Course C1
		INNER JOIN PreqCourse_course P On(C1.course_id=P.prerequisite_course_id)
		INNER JOIN Course C2 ON(P.course_id=C2.course_id);
GO
SELECT * FROM view_Course_prerequisites;
-----C
GO
	CREATE VIEW Instructors_AssignedCourses(instructor_id,instructor_name,instructor_email,instructor_faculty,instructor_office,course_id,course_name,course_major,course_if_offered,course_credit_hours,course_semester)
	AS
		SELECT I.* ,C.* 
		FROM Instructor I
		INNER JOIN Instructor_Course L ON(I.instructor_id=L.instructor_id)
		INNER JOIN Course C ON(L.course_id=C.course_id);
GO
SELECT * FROM Instructors_AssignedCourses;
-----D
GO
	CREATE VIEW Student_Payment
	AS
		SELECT P.* , S.f_name AS 'Student First Name' , S.l_name AS 'Student Last Name'
		FROM Payment P
		INNER JOIN Student S ON(P.student_id=S.student_id);
GO
SELECT * FROM Student_Payment;
-----E
GO
	CREATE VIEW Courses_Slots_Instructor(course_id,course_name,slot_id,slot_day,slot_time,slot_location,instructor_name)
	AS
		SELECT C.course_id  , C.name  , S.slot_id, S.day, S.time , S.location, I.name  
		FROM Course C
		INNER JOIN Slot S ON(S.course_id = C.course_id)
		INNER JOIN Instructor I ON(S.instructor_id = I.instructor_id);
GO
SELECT * FROM Courses_Slots_Instructor;
-----F
GO
	CREATE VIEW Courses_MakeupExams 
	AS
		SELECT C.name AS 'Course’s Name' , C.semester AS 'Course’s Semester', M.*  
		FROM Course C 
		INNER JOIN MakeUp_Exam M ON M.course_id = C.course_id

GO
SELECT * FROM Courses_MakeupExams;
-----G
GO
	CREATE VIEW Students_Courses_transcript(student_id,student_first_name,student_last_name ,course_id,course_name,exam_type,course_grade,semester,instructor_name)
	AS
		SELECT S.student_id,S.f_name,S.l_name,C.course_id,C.name,SCT.exam_type,SCT.grade,SCT.semester_code,I.name
		FROM Student S
		INNER JOIN Student_Instructor_Course_Take SCT ON SCT.student_id = S.student_id
		INNER JOIN Course C ON C.course_id = SCT.course_id 
		INNER JOIN Instructor I ON I.instructor_id = SCT.instructor_id
GO
SELECT * FROM Students_Courses_transcript;
-----H
GO
	CREATE VIEW Semster_offered_Courses(course_id,course_name,semester_code)
	AS
		SELECT C.course_id ,C.name ,S.semester_code 
		FROM Course C
		INNER JOIN Course_Semester S ON(S.course_id=C.course_id);
GO
SELECT * FROM Semster_offered_Courses;
-----I 
GO
	CREATE VIEW Advisors_Graduation_Plan
	AS
		SELECT G.*,A.name As 'Advisor name'
		FROM Graduation_Plan G
		INNER JOIN Advisor A ON(G.advisor_id=A.advisor_id);
GO
SELECT * FROM Advisors_Graduation_Plan;
--2.3
-----A
GO
	CREATE PROCEDURE Procedures_StudentRegistration
		@FirstName VARCHAR(40),
		@LastName VARCHAR(40),
		@password VARCHAR(40),
		@faculty VARCHAR(40),
		@email VARCHAR(40),
		@major VARCHAR(40),
		@Semester INT,
		@StudentID INT OUTPUT
	AS
		INSERT INTO Student(f_name,l_name,password,faculty,email,major,semester)
		VALUES(@FirstName ,@LastName ,@password, @faculty, @email, @major, @Semester);
		SELECT @StudentID = student_id FROM Student WHERE f_name = @FirstName AND l_name = @LastName AND password = @password AND faculty = @faculty AND email = @email AND major = @major AND semester = @Semester;
GO
DECLARE @StudentID INT
EXEC Procedures_StudentRegistration 'Ahmed','Mohamed','123','Engineering',';','', 1 , @StudentID OUTPUT
PRINT @StudentID;
-----B
GO	
	CREATE PROCEDURE Procedures_AdvisorRegistration
		@advisor_name VARCHAR(40),
		@password VARCHAR(40),
		@email VARCHAR(40),
		@office VARCHAR(40),
		@advisor_id INT OUTPUT
	AS
		INSERT INTO Advisor(name,password,email,office)
		VALUES(@advisor_name,@password,@email,@office);
		SELECT @advisor_id = advisor_id FROM Advisor WHERE name = @advisor_name AND password = @password AND email = @email AND office = @office;
GO
DECLARE @advisor_id INT
EXEC Procedures_AdvisorRegistration 'Ahmed','123','a','b2305',@advisor_id OUTPUT
PRINT @advisor_id;
-----C
GO 
	CREATE PROCEDURE Procedures_AdminListStudents
	AS
		SELECT * FROM Student;
GO
EXEC Procedures_AdminListStudents;
-----D
GO
	CREATE PROCEDURE Procedures_AdminListAdvisors
	AS
		SELECT * FROM Advisor;
GO
EXEC Procedures_AdminListAdvisors;
-----E
GO
	CREATE PROCEDURE AdminListStudentsWithAdvisors
	AS	
		SELECT S.*,A.*
		FROM Student S
		INNER JOIN Advisor A ON(S.advisor_id=A.advisor_id);
GO
EXEC AdminListStudentsWithAdvisors;
-----F
GO 
	CREATE PROCEDURE AdminAddingSemester
		@start_date DATE,
		@end_date DATE,
		@semester_code VARCHAR(40)
	AS
		INSERT INTO Semester(start_date,end_date,semester_code)
		VALUES(@start_date,@end_date,@semester_code);
GO
SELECT * FROM Semester;
EXEC AdminAddingSemester '2024-09-01','2024-12-01','W25';
SELECT * FROM Semester;
-----G
GO
	CREATE PROCEDURE Procedures_AdminAddingCourse
		@major VARCHAR(40),
		@semester INT,
		@credit_hours INT,
		@course_name VARCHAR(40),
		@offered BIT
	AS
		INSERT INTO Course(major,semester,credit_hours,name,is_offered)
		VALUES(@major,@semester,@credit_hours,@course_name,@offered);
GO
SELECT * FROM Course;
EXEC Procedures_AdminAddingCourse 'Engineering',1,3,'Math508',1;
SELECT * FROM Course;
-----H
GO 
	CREATE PROCEDURE  Procedures_AdminLinkInstructor
		@InstructorId INT,
		@courseID INT,
		@slotID INT
		AS
			UPDATE Slot
			SET instructor_id = @InstructorId, course_id = @courseID
			WHERE slot_id = @slotID;
GO
SELECT * FROM Slot;
EXEC Procedures_AdminLinkInstructor 10,1,1;
SELECT * FROM Slot;
-----I
GO
	CREATE PROCEDURE Procedures_AdminLinkStudent
		@instructor_id INT,
		@student_id INT,
		@course_id INT,
		@semester_code VARCHAR(40)
	AS
		INSERT INTO Student_Instructor_Course_Take(instructor_id,student_id,course_id,semester_code) 
		VALUES(@instructor_id,@student_id,@course_id,@semester_code);
GO
EXEC Procedures_AdminLinkStudent 1,2,2,'W26';
SELECT * FROM Student_Instructor_Course_Take;
-----J
GO
	CREATE PROCEDURE Procedures_AdminLinkStudentToAdvisor
		@student_id INT,
		@advisor_id INT
	AS
		UPDATE Student
		SET advisor_id = @advisor_id
		WHERE student_id = @student_id;
GO
SELECT * FROM Student;
EXEC Procedures_AdminLinkStudentToAdvisor 1,10;
SELECT * FROM Student;
-----K
GO
	CREATE PROC Procedures_AdminAddExam
		@Type VARCHAR(40),
		@date DATETIME,
		@courseID INT
	AS
		INSERT INTO MakeUp_Exam(type,date,course_id)
		VALUES(@Type,@date,@courseID);
GO
SELECT * FROM MakeUp_Exam;
EXEC Procedures_AdminAddExam 'First_makeup','2028-09-01',1;
SELECT * FROM MakeUp_Exam;
-----L 
GO 
	CREATE PROC Procedures_AdminIssueInstallment
		@payment_id INT
	AS
		DECLARE @n_installments INT, @start_date DATE,@counter INT ,@end_date DATE,@amount INT

		SELECT @n_installments = n_installments
		FROM Payment
		WHERE payment_id = @payment_id;

		SELECT @start_date = start_date , @end_date = deadline
		FROM Payment
		WHERE payment_id = @payment_id;

		-- DECLARE @start_date DATE ,@end_date DATE, @monthDiff INT , @amount INT , @counter INT
		-- UPDATE Payment
		-- SET n_installments = @monthDiff
		-- WHERE payment_id = @payment_id;

		-- SET @monthDiff = DATEDIFF(MONTH,@start_date,@end_date);

		 SELECT @amount = amount/@n_installments
		 FROM Payment
		 WHERE payment_id = @payment_id;

		SET @counter = 1;
		WHILE (@counter <= @n_installments)
		BEGIN
			INSERT INTO Installment(payment_id,deadline,start_date,amount)
			VALUES(@payment_id,DATEADD(MONTH,@counter,@start_date),DATEADD(MONTH,@counter-1,@start_date),@amount);
			SET @counter = @counter + 1;
		END
GO
SELECT * FROM Payment
INSERT INTO Payment (amount,deadline,n_installments,fund_percentage,start_date,student_id,semester_code)
VALUES (1200,'2024-09-01',3,40,'2024-06-01',1,'W23');
EXECUTE Procedures_AdminIssueInstallment 11
SELECT * from Installment where payment_id = 11
-----M
GO
	CREATE PROC Procedures_AdminDeleteCourse
		@courseID INT
	AS
		DELETE FROM PreqCourse_course WHERE PreqCourse_course.course_id=@courseID OR PreqCourse_course.prerequisite_course_id=@courseID;
		DELETE FROM Course WHERE Course.course_id=@courseID;
GO
SELECT * FROM Course;
SELECT * FROM Slot;
SELECT * FROM Course_Semester;
EXEC Procedures_AdminDeleteCourse 2;
-----N
GO
CREATE FUNCTION get_status(@StudentID INT)
	RETURNS BIT
	AS
	BEGIN
		DECLARE @status BIT
		IF EXISTS(
			SELECT I.payment_id 
			FROM Student S 
			INNER JOIN Payment P ON S.student_id=P.student_id 
			INNER JOIN Installment I ON P.payment_id=I.payment_id
			WHERE S.student_id=@StudentID AND CURRENT_TIMESTAMP > I.deadline AND I.status='NotPaid'
			)
		SET @status = 0;
		ELSE
		SET @status = 1;
		RETURN @status;
	END;
GO

GO
	CREATE PROC  Procedure_AdminUpdateStudentStatus 
		@StudentID INT
	AS
		UPDATE Student SET financial_status=  dbo.get_status(@StudentID) WHERE student_id=@StudentID;
GO
EXEC Procedure_AdminUpdateStudentStatus 1;
-----O
GO
	CREATE VIEW all_Pending_Requests(Request_ID,Request_Type,Comment,Request_status,Credit_Hours,Course_ID,Student_ID,Student_First_Name,Student_Last_Name,Advisor_ID,Related_Advisor_Name)
	AS
		SELECT R.request_id,R.type,R.comment,R.status,R.credit_hours,R.course_id,R.student_id,S.f_name,S.l_name,R.advisor_id,A.name
		FROM Request R 
		INNER JOIN Student S ON R.student_id=S.student_id
		INNER JOIN Advisor A ON R.advisor_id=A.advisor_id
		WHERE R.status='Pending';
GO
SELECT * FROM Course;
SELECT * FROM all_Pending_Requests;
-----P
GO
	CREATE PROC Procedures_AdminDeleteSlots
		@current_semester VARCHAR(40)
	As	
		UPDATE Slot
		SET Slot.course_id = NULL, Slot.instructor_id = NULL
		WHERE Slot.course_id IN (
			SELECT C.course_id
			FROM Course_Semester C 
			WHERE C.semester_code<>@current_semester
			);	
GO
select S.slot_id,S.course_id,CS.semester_code from Slot S inner join Course_Semester CS on CS.course_id=S.course_id;
exec Procedures_AdminDeleteSlots 'W23';
select S.slot_id,S.course_id,CS.semester_code from Slot S inner join Course_Semester CS on CS.course_id=S.course_id;
-----Q
GO
	CREATE FUNCTION FN_AdvisorLogin (@iD INT,@password VARCHAR(40))
	RETURNS BIT
	AS
	BEGIN
		DECLARE @Success BIT
		IF EXISTS(SELECT * FROM Advisor WHERE advisor_id = @iD AND password = @password)
			SET @Success = 1;
		ELSE
			SET @Success = 0;
		RETURN @Success;
	END;
GO
PRINT dbo.FN_AdvisorLogin(1,'password1');
-----R
GO 
	CREATE PROCEDURE Procedures_AdvisorCreateGP
		@semester_code VARCHAR(40),
		@expected_grad_date DATE,
		@sem_credit_hours INT,
		@advisor_id INT,
		@student_id INT
	AS
		BEGIN
		DECLARE @acq_hours INT, @expected_advisor_id INT
		SELECT @acq_hours = acquired_hours FROM Student WHERE student_id = @student_id;
		SELECT @expected_advisor_id = advisor_id FROM Student WHERE student_id = @student_id;

		IF (@acq_hours > 157) AND (@expected_advisor_id = @advisor_id)
			INSERT INTO Graduation_Plan(semester_code,expected_grad_date,semester_credit_hours,advisor_id,student_id)
			VALUES(@semester_code,@expected_grad_date,@sem_credit_hours,@advisor_id,@student_id);
		END
GO
insert into Student (f_name,l_name,password,faculty,email,major,semester,advisor_id,acquired_hours)
values ('Ahmed','Mohamed','123','Engineering','a','b',1,1,158);
EXEC Procedures_AdvisorCreateGP 'W23','2024-09-01',3,1,11;
-----S
GO
	CREATE PROCEDURE Procedures_AdvisorAddCourseGP
		@student_id INT,
		@semester_code VARCHAR(40),
		@course_name VARCHAR(40)
	AS
		DECLARE @course_id INT
		SELECT @course_id = course_id FROM Course WHERE name = @course_name;
		DECLARE @plan_id INT
		SELECT @plan_id = plan_id
		FROM Graduation_Plan
		WHERE student_id = @student_id
		INSERT INTO GradPlan_Course(plan_id,semester_code,course_id)
		VALUES(@plan_id,@semester_code,@course_id);
GO
select * from Course
SELECT * FROM GradPlan_Course;
EXEC Procedures_AdvisorAddCourseGP 11,'W23','Database2';
SELECT * FROM GradPlan_Course;
-----T
GO
	CREATE PROCEDURE Procedures_AdvisorUpdateGP
	@expected_grad_date DATE,
	@studentID INT
	AS
		UPDATE Graduation_Plan 
		SET expected_grad_date = @expected_grad_date
		WHERE student_id= @studentID;
GO
SELECT * FROM Graduation_Plan;
EXEC Procedures_AdvisorUpdateGP '2029-09-01',11;
SELECT * FROM Graduation_Plan;

-----U
GO
	CREATE PROC Procedures_AdvisorDeleteFromGP
		@studentID INT,
		@semesterCode VARCHAR(40),
		@courseID INT
	AS
		DELETE FROM GradPlan_Course 
		WHERE GradPlan_Course.course_id=@CourseID AND GradPlan_Course.semester_code=@semesterCode 
		AND GradPlan_Course.plan_id IN 
		(SELECT student_id
		FROM Graduation_Plan 
		WHERE Graduation_Plan.student_id=@StudentID);
GO
SELECT * FROM GradPlan_Course;
EXEC Procedures_AdvisorDeleteFromGP 11,'W23',10;
SELECT * FROM GradPlan_Course;
-----V
GO
	CREATE Function FN_Advisors_Requests (@AdvisorID INT)
	RETURNS TABLE
	AS
	RETURN
	(
		SELECT R.*
		FROM Request R 
		WHERE R.advisor_id=@AdvisorID
	);	
GO
SELECT * FROM Request
SELECT * FROM FN_Advisors_Requests(5);
-----W
GO 
	CREATE PROCEDURE Procedures_AdvisorApproveRejectCHRequest
	@RequestID INT,
	@Current_semester_code VARCHAR (40)
	AS
	BEGIN 
		DECLARE @gpa INT, @student_id INT, @total_credit_hours INT, @credit_hours INT ,  @assigned_hours INT, @type VARCHAR(40),
		@advID INT, @advisor_id INT

		SELECT @type = type FROM Request WHERE request_id = @RequestID;

		SELECT @student_id = student_id, @credit_hours = credit_hours, @advisor_id = advisor_id FROM Request WHERE request_id = @RequestID;

		SELECT @gpa = S.gpa FROM Student S WHERE S.student_id = @student_id;

		SELECT @advID = advisor_id
		FROM Student
		WHERE student_id = @student_id;
		
		SELECT @total_credit_hours = SUM(credit_hours) 
		FROM Student_Instructor_Course_Take SCT 
		INNER JOIN Course C ON (C.course_id = SCT.course_id)
		WHERE SCT.student_id = @student_id AND SCT.semester_code = @Current_semester_code;

		SELECT @assigned_hours = assigned_hours 
		FROM Student
		WHERE student_id = @student_id;

		IF (@type = 'credit_hours')
		BEGIN 
			IF ((@gpa>3.7 OR @credit_hours>3 OR (( @total_credit_hours + @assigned_hours + @credit_hours) >34) OR @advID <> @advisor_id))
			BEGIN
				UPDATE Request
				SET status = 'Rejected'
				WHERE request_id = @RequestID;
			END
			ELSE
			BEGIN
				UPDATE Request
				SET status = 'Accepted'
				WHERE request_id = @RequestID;
				DECLARE @assignHrs INT;

				IF @assigned_hours IS NULL 
					SET @assignHrs = 0;
				ELSE
					SET @assignHrs = @assigned_hours;												

				UPDATE Student
				SET assigned_hours = @assignHrs + @credit_hours
				WHERE student_id = @student_id;

				DECLARE @pid INT , @amount INT
				SELECT @pid = payment_id  , @amount = amount
				FROM Payment 
				WHERE student_id = @student_id AND @Current_semester_code = semester_code AND status = 'notPaid'

				IF @pid IS NOT NULL AND @amount IS NOT NULL
				BEGIN 
					UPDATE Payment 
					SET amount = @amount + 1000* @credit_hours
					WHERE payment_id=@pid

					DECLARE  @instAmount INT, @deadline DATE
					SELECT TOP 1 @instAmount = amount , @deadline = deadline
					FROM Installment
					WHERE payment_id = @pid  AND status = 'notPaid'
					ORDER BY deadline

					UPDATE Installment
					SET amount = @instAmount + 1000* @credit_hours
					WHERE payment_id = @pid AND deadline = @deadline
				END
			END
		END
	END
GO
EXEC Procedures_AdvisorApproveRejectCHRequest 1,'W23';
-----X
GO
	CREATE PROCEDURE Procedures_AdvisorViewAssignedStudents
	@AdvisorID INT,
	@major VARCHAR(40)
	AS
		SELECT S.student_id AS 'Student ID' , S.f_name AS 'Student First Name ' , S.l_name AS 'Student Last Name' , C.name AS 'Course Name'
		FROM Student S INNER JOIN Student_Instructor_Course_Take SCT ON SCT.student_id = S.student_id
		INNER JOIN Course C ON C.course_id = SCT.course_id
		WHERE S.advisor_id = @AdvisorID AND S.major = @major 
GO
select * from Student
select * from Student_Instructor_Course_Take
select * from Course
EXEC Procedures_AdvisorViewAssignedStudents 5,'IET';
-----Y 
GO
	CREATE PROCEDURE Procedures_AdvisorApproveRejectCourseRequest
	@RequestID INT,
	@current_semester_code VARCHAR(40)
	AS
		DECLARE @course_id INT, @student_id INT, @advisor_id INT,
		@crs_credHrs INT, @assigned_hours INT, @advID INT, @tookPREQ BIT, @is_offered_in_sem BIT, @type VARCHAR(40)

		SELECT @type = type FROM Request WHERE request_id = @RequestID;

		SELECT @student_id = student_id, @advisor_id = advisor_id, @course_id = course_id
		FROM Request WHERE request_id = @RequestID;

		SELECT @crs_credHrs = credit_hours
		FROM Course
		WHERE course_id = @course_id;

		SELECT @assigned_hours = assigned_hours
		FROM Student
		WHERE student_id = @student_id;

		SELECT @advID = advisor_id
		FROM Student
		WHERE student_id = @student_id;		
		

		IF EXISTS(
			SELECT * FROM Course_Semester
			WHERE course_id = @course_id AND semester_code = @current_semester_code
			)
			SET @is_offered_in_sem = 1;
		ELSE
			SET @is_offered_in_sem = 0;

		IF (NOT EXISTS( 
						(SELECT P.prerequisite_course_id
						FROM PreqCourse_course P
						WHERE P.course_id = @course_id
						)
						EXCEPT
						(SELECT SCT.course_id
						FROM Student_Instructor_Course_Take SCT
						WHERE SCT.student_id = @student_id AND SCT.grade NOT LIKE 'F%')
						))
			SET @tookPREQ = 1;
		ELSE
			SET @tookPREQ = 0;

		IF (@type = 'course')
		BEGIN
			IF (@course_id IS NOT NULL AND @is_offered_in_sem = 1 AND @advID = @advisor_id AND @assigned_hours >= @crs_credHrs AND @tookPREQ =1)
			BEGIN
				UPDATE Request
				SET status = 'Accepted'
				WHERE request_id = @RequestID;

				INSERT INTO Student_Instructor_Course_Take(student_id,course_id,semester_code)
				VALUES(@student_id,@course_id,@current_semester_code);

				UPDATE Student
				SET assigned_hours = @assigned_hours - @crs_credHrs
				WHERE student_id = @student_id;
			END
			ELSE
			BEGIN
				UPDATE Request
				SET status = 'Rejected'
				WHERE request_id = @RequestID;
			END
		END
GO
exec Procedures_AdvisorApproveRejectCourseRequest 1,'W23';
-----Z
GO
	CREATE PROC Procedures_AdvisorViewPendingRequests
		@AdvisorID INT
	AS
		SELECT R.*
		FROM Request R   
		WHERE R.status='Pending' AND R.advisor_id=@AdvisorID;
GO
SELECT * FROM Request;
EXEC Procedures_AdvisorViewPendingRequests 3;
-----AA
GO

CREATE FUNCTION FN_StudentLogin
(
	@StudentID INT,
	@password VARCHAR(40)
)
RETURNS BIT
AS
BEGIN
	DECLARE @Success BIT

	IF EXISTS(SELECT * FROM Student WHERE student_id = @StudentID AND password = @password)
		SET @Success = 1;
	ELSE
		SET @Success = 0;

	RETURN @Success;
END;

GO
select * from Student
PRINT dbo.FN_StudentLogin(1,'password123');
-----BB 
GO
CREATE PROCEDURE Procedures_StudentaddMobile
	@StudentID INT,
	@mobile_number VARCHAR(40)
	AS
		INSERT INTO Student_Phone(student_id,phone_number)
		VALUES(@StudentID,@mobile_number);
GO
SELECT * FROM Student_Phone;
EXEC Procedures_StudentaddMobile 1,'010';
-----CC 
GO

CREATE FUNCTION  FN_SemsterAvailableCourses(@semster_code VARCHAR(40))
RETURNS TABLE
AS
RETURN
(
	SELECT C.*
	FROM Course C
	INNER JOIN Course_Semester CS ON(C.course_id = CS.course_id)
	WHERE CS.semester_code = @semster_code
);

GO
SELECT * from Course_Semester 
SELECT * FROM FN_SemsterAvailableCourses('W23');
-----DD
GO

CREATE PROCEDURE Procedures_StudentSendingCourseRequest
	@StudentID INT,
	@CourseID INT,
	@type VARCHAR(40),
	@comment VARCHAR(40)
	AS
		DECLARE @advisor_id INT
		
		SELECT @advisor_id = advisor_id FROM Student WHERE student_id = @StudentID;

		INSERT INTO Request(type,comment,course_id,student_id, advisor_id)
		VALUES(@type,@comment,@CourseID,@StudentID, @advisor_id);
GO
SELECT * FROM Request;
EXEC Procedures_StudentSendingCourseRequest 1,5,'course','PLEASE';
-----EE
GO
CREATE PROCEDURE Procedures_StudentSendingCHRequest
	@StudentID INT,
	@credit_hours INT,
	@type VARCHAR(40),
	@comment VARCHAR(40)
	
	AS
		DECLARE @advisor_id INT
		
		SELECT @advisor_id = advisor_id FROM Student WHERE student_id = @StudentID;

		INSERT INTO Request(type,comment,credit_hours,student_id, advisor_id)
		VALUES(@type,@comment,@credit_hours,@StudentID, @advisor_id);
GO
EXEC Procedures_StudentSendingCHRequest 1,4,'credit_hours','PLEASE';
SELECT * FROM Request;
-----FF
GO
CREATE FUNCTION FN_StudentViewGP(@student_id INT)
RETURNS TABLE
AS
RETURN
(
	SELECT S.Student_id , S.f_name , S.l_name , GP.plan_id , C.course_id , C.name , GP.semester_code , GP.expected_grad_date , GP.semester_credit_hours , GP.advisor_id
	FROM Graduation_Plan GP
		INNER JOIN Student S On GP.student_id= S.student_id
		INNER JOIN GradPlan_Course GC ON (GP.plan_id= GC.plan_id AND GP.semester_code=GC.semester_code)
		INNER JOIN Course C on GC.course_id= C.course_id
	WHERE S.student_id = @student_id
);		
GO
SELECT * FROM FN_StudentViewGP(5);
-----GG
GO
CREATE FUNCTION FN_StudentUpcoming_installment(@student_id INT)
RETURNS DATETIME
AS
BEGIN
	DECLARE @upcoming_installment DATETIME

	SELECT TOP 1 @upcoming_installment = I.deadline
	FROM Installment I 
	INNER JOIN Payment P ON I.payment_id = P.payment_id
	WHERE P.student_id = @student_id
	AND I.status = 'NotPaid'
	ORDER BY I.deadline ASC
	RETURN @upcoming_installment
END;
GO
DECLARE @upcoming_installment DATETIME
SELECT @upcoming_installment = dbo.FN_StudentUpcoming_installment(6);
PRINT @upcoming_installment;
-----HH
GO
	CREATE FUNCTION FN_StudentViewSlot (@CourseID INT,@InstructorID INT)
	RETURNS TABLE 
	AS
	RETURN
	(
		SELECT S.slot_id AS 'Slot ID',S.location AS 'location',S.time AS 'time',S.day AS 'day',C.name AS 'Course name',I.name AS 'Instructor name'
		FROM Slot S
		INNER JOIN Course C ON S.course_id=C.course_id
		INNER JOIN Instructor I ON S.instructor_id=I.instructor_id
		WHERE S.course_id=@CourseID AND S.instructor_id=@InstructorID
	);
GO
SELECT * FROM Slot;
SELECT * FROM FN_StudentViewSlot(5,5);
-----II
GO
CREATE PROCEDURE Procedures_StudentRegisterFirstMakeup
	@StudentID INT,
	@course_id INT,
	@studentCurrentSemester VARCHAR(40)
	AS
		DECLARE @course INT
		SELECT @course = course_id
		FROM Student_Instructor_Course_Take 
		WHERE semester_code = @studentCurrentSemester AND (grade = 'F' OR grade = 'FF' OR grade IS NULL) AND student_id = @StudentID AND course_id = @course_id AND exam_type = 'Normal';
		IF @course IS NOT NULL
		BEGIN
			DECLARE @exam_id INT

			SELECT @exam_id = exam_id
			FROM MakeUp_Exam
			WHERE course_id = @course_id AND type = 'First_makeup';

			INSERT INTO Exam_Student(exam_id,student_id,course_id)
			VALUES(@exam_id,@StudentID,@course_id);

			UPDATE Student_Instructor_Course_Take
			SET exam_type = 'First_makeup' , grade = NULL
			WHERE student_id = @StudentID AND course_id = @course_id AND semester_code = @studentCurrentSemester;
		END
GO
EXECUTE Procedures_StudentRegisterFirstMakeup 1,5,'W23';
-----JJ
GO 
	CREATE FUNCTION FN_StudentCheckSMEligiability(@CourseID INT,@StudentID INT)
	RETURNS BIT
	AS
	BEGIN
	DECLARE @countFailed INT
	SELECT @countFailed = COUNT(DISTINCT course_id)
		FROM Student_Instructor_Course_Take 
		WHERE grade LIKE 'F%' AND student_id = @StudentID 
	
	DECLARE @firstMakeup BIT
	IF EXISTS(
	SELECT course_id
		FROM Student_Instructor_Course_Take 
		WHERE  student_id = @StudentID AND course_id = @CourseID AND exam_type IN ('Normal', 'First_makeup') AND (grade = 'F' OR grade = 'FF' OR grade IS NULL) 
	)
	SET @firstMakeup = 1;
	ELSE
	SET @firstMakeup = 0;
	RETURN CASE WHEN  (@countFailed > 2 OR @firstMakeup = 0) THEN 0 ELSE 1
				END
	END
GO

PRINT dbo.FN_StudentCheckSMEligiability(5,1);

-----KK
GO
	CREATE PROCEDURE Procedures_StudentRegisterSecondMakeup
		@student_id INT,
		@course_id INT,
		@student_current_semester VARCHAR(40)
		AS
			DECLARE @isEligible BIT
			SELECT @isEligible = dbo.FN_StudentCheckSMEligiability(@course_id,@student_id)
			IF  @isEligible = 1
			BEGIN
				DECLARE @exam_id INT

				SELECT @exam_id = exam_id
				FROM MakeUp_Exam
				WHERE course_id = @course_id AND type = 'Second_makeup';

				INSERT INTO Exam_Student(exam_id,student_id,course_id)
				VALUES(@exam_id,@student_id,@course_id);

				UPDATE Student_Instructor_Course_Take
				SET exam_type = 'Second_makeup' , grade = NULL
				WHERE student_id = @student_id AND course_id = @course_id AND semester_code = @student_current_semester;
			END
GO
EXECUTE Procedures_StudentRegisterSecondMakeup 1,5,'W23';
-----LL 
GO 
CREATE PROCEDURE Procedures_ViewRequiredCourses
	@StudentID INT,
	@Current_semester_code VARCHAR(40)
	AS
		((SELECT C.* 
			FROM Course C
			INNER JOIN Student_Instructor_Course_Take SCT ON (C.course_id = SCT.course_id AND SCT.student_id = @StudentID)
			WHERE (SCT.grade = 'F' OR SCT.grade = 'FF') AND dbo.FN_StudentCheckSMEligiability(C.course_id, @StudentID) = 0)
			UNION
			(
			(SELECT C.*
			FROM Course C
			WHERE C.semester < (SELECT S.semester
								FROM Student S
								WHERE S.student_id = @StudentID AND S.major = C.major))
			EXCEPT 
			(SELECT C.* 
			FROM Course C
			INNER JOIN Student_Instructor_Course_Take SCT ON (C.course_id = SCT.course_id AND SCT.student_id = @StudentID)
			WHERE SCT.grade NOT LIKE 'F%')
			)
			INTERSECT
			(SELECT C.*
			FROM Course_Semester CS INNER JOIN Course C ON (C.course_id = CS.course_id)
			WHERE CS.semester_code = @Current_semester_code)
			)

GO
EXEC Procedures_ViewRequiredCourses 1,'W23';
-----MM
GO  
 	CREATE PROCEDURE Procedures_ViewOptionalCourse
 		@StudentID INT,
 		@Current_semester_code VARCHAR(40)
 		AS
			((SELECT C.*
		FROM Course C
		WHERE C.semester >= (SELECT S.semester
							FROM Student S
							WHERE S.student_id = @StudentID AND S.major = C.major)
			AND NOT EXISTS( 
						(SELECT P.prerequisite_course_id
						FROM PreqCourse_course P
						WHERE P.course_id = C.course_id
						)
						EXCEPT
						(SELECT SCT.course_id
						FROM Student_Instructor_Course_Take SCT
						WHERE SCT.student_id = @StudentID AND SCT.grade NOT LIKE 'F%')
		))
			EXCEPT (SELECT C.*
					FROM Course C
					INNER JOIN Student_Instructor_Course_Take SCT ON (C.course_id = SCT.course_id AND SCT.student_id = @StudentID)
					WHERE SCT.grade NOT LIKE 'F%')
			 INTERSECT
			(SELECT C.*
			FROM Course_Semester CS INNER JOIN Course C ON (C.course_id = CS.course_id)
			WHERE CS.semester_code = @current_semester_code)
			)
			
GO
EXEC Procedures_ViewOptionalCourse 1,'W23';
-----NN  
GO
	CREATE PROCEDURE Procedures_ViewMS
		@StudentID INT
		AS
			(SELECT C.*
			FROM Course C
			WHERE C.major = (SELECT S.major
							FROM Student S
							WHERE S.student_id = @StudentID))
			EXCEPT
			(SELECT C.*
			FROM Course C
					INNER JOIN Student_Instructor_Course_Take SCT ON C.course_id = SCT.course_id 
			WHERE (SCT.grade NOT LIKE 'F%' OR SCT.grade IS NULL) AND SCT.student_id = @StudentID)	
			EXCEPT ((SELECT C.* 
			FROM Course C
			INNER JOIN Student_Instructor_Course_Take SCT ON (C.course_id = SCT.course_id AND SCT.student_id = @StudentID)
			WHERE (SCT.grade = 'F' OR SCT.grade = 'FF') AND dbo.FN_StudentCheckSMEligiability(C.course_id, @StudentID) = 0)
			UNION
			(
			(SELECT C.*
			FROM Course C
			WHERE C.semester < (SELECT S.semester
								FROM Student S
								WHERE S.student_id = @StudentID AND S.major = C.major))
			EXCEPT 
			(SELECT C.* 
			FROM Course C
			INNER JOIN Student_Instructor_Course_Take SCT ON (C.course_id = SCT.course_id AND SCT.student_id = @StudentID)
			WHERE SCT.grade NOT LIKE 'F%')
			))
			EXCEPT
			((SELECT C.*
		FROM Course C
		WHERE C.semester >= (SELECT S.semester
							FROM Student S
							WHERE S.student_id = @StudentID AND S.major = C.major)
			AND NOT EXISTS( 
						(SELECT P.prerequisite_course_id
						FROM PreqCourse_course P
						WHERE P.course_id = C.course_id
						)
						EXCEPT
						(SELECT SCT.course_id
						FROM Student_Instructor_Course_Take SCT
						WHERE SCT.student_id = @StudentID AND SCT.grade NOT LIKE 'F%')
		))
			EXCEPT (SELECT C.*
					FROM Course C
					INNER JOIN Student_Instructor_Course_Take SCT ON (C.course_id = SCT.course_id AND SCT.student_id = @StudentID)
					WHERE SCT.grade NOT LIKE 'F%'))
GO
EXEC Procedures_ViewMS 1;
-----OO  
GO	
CREATE PROCEDURE Procedures_ChooseInstructor
	@StudentID INT,
	@InstructorID INT,
	@CourseID INT,
	@current_semester_code varchar(40)
	AS
		UPDATE Student_Instructor_Course_Take
		SET instructor_id = @InstructorID
		WHERE student_id = @StudentID AND course_id = @CourseID AND semester_code = @current_semester_code;
GO
EXEC Procedures_ChooseInstructor 5,1,5,'W23';