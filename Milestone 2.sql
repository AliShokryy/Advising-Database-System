CREATE DATABASE Advising_Team_6

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
		gpa DECIMAL(2,2),
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
		CONSTRAINT fk_Student FOREIGN KEY (advisor_id) REFERENCES Advisor(advisor_id) ON DELETE SET NULL ON UPDATE CASCADE, --!!!!!!!!!!
		CONSTRAINT check_financial_status CHECK (financial_status = 1 AND current_timestamp > (SELECT MAX(deadline) FROM Installment WHERE status = 1))

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
		CONSTRAINT fk_PreqCourse_course1 FOREIGN KEY (prerequisite_course_id) REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT fk_PreqCourse_course2 FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE CASCADE
	);

	CREATE TABLE Instructor(
		instructor_id INT,
		name VARCHAR(40),
		email VARCHAR(40),
		faculty VARCHAR(40),
		office VARCHAR(40),
		CONSTRAINT pk_Instructor PRIMARY KEY (instructore_id)
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
		CONSTRAINT pk_Student_Instructor_Course_Take PRIMARY KEY (student_id, course_id, instructor_id),
		CONSTRAINT fk_Student_Instructor_Course_Take1 FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT fk_Student_Instructor_Course_Take2 FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT fk_Student_Instructor_Course_Take3 FOREIGN KEY (instructor_id) REFERENCES Instructor(instructor_id) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT exam_type CHECK (type IN ('Normal','First_makeup','Second_makeup')) --!!!!!!!!!!!!!!!!!!!!!
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
		plan_id INT,
		semester_code VARCHAR(40),
		semester_credit_hours INT,
		expected_grad_semester INT,
		advisor_id INT,
		student_id INT,
		CONSTRAINT pk_Graduation_Plan PRIMARY KEY (plan_id, semester_code),
		CONSTRAINT fk_Graduation_Plan1 FOREIGN KEY (advisor_id) REFERENCES Advisor(advisor_id)ON DELETE SET NULL ON UPDATE CASCADE, --!!!!!!!!
		CONSTRAINT fk_Graduation_Plan2 FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE ON UPDATE CASCADE
	);
	
	CREATE TABLE GradPlan_Course (
		plan_id INT,
		semester_code VARCHAR(40),
		course_id INT,
		CONSTRAINT pk_GradPlan_Course PRIMARY KEY (plan_id, semester_code, course_id),
		CONSTRAINT fk_GradPlan_Course1 FOREIGN KEY (plan_id) REFERENCES Graduation_Plan(plan_id) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT fk_GradPlan_Course2 FOREIGN KEY (semester_code) REFERENCES Graduation_Plan(semester_code) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT fk_GradPlan_Course3 FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE CASCADE
	);

	CREATE TABLE Request (
		request_id INT,
		type VARCHAR(40),
		comment VARCHAR(40),
		status VARCHAR(40) DEFAULT 'pending',
		credit_hours INT,
		student_id INT,
		advisor_id INT,
		course_id INT,
		CONSTRAINT pk_Request PRIMARY KEY (request_id),
		CONSTRAINT fk_Request1 FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT fk_Request2 FOREIGN KEY (advisor_id) REFERENCES Advisor(advisor_id) ON DELETE SET NULL ON UPDATE CASCADE, --!!!!!!!
		CONSTRAINT check_Request_Status CHECK (status IN ('pending','accepted','rejected')) --!!!!!!!
	);

	CREATE TABLE MakeUp_Exam (
		exam_id INT IDENTITY,
		date DATE,
		type VARCHAR(40) DEFAULT 'Normal',
		course_id INT,
		CONSTRAINT pk_MakeUp_Exam PRIMARY KEY (exam_id),
		CONSTRAINT fk_MakeUp_Exam FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE CASCADE ,
		CONSTRAINT exam_type CHECK (type IN ('Normal','First_makeup','Second_makeup'))

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
		amount DECIMAL(10, 2),
		deadline DATE,
		n_installments INT NOT NULL,
		status VARCHAR(40) DEFAULT 'notPaid',
		fund_percentage DECIMAL(5, 2),
		student_id INT,
		semester_code VARCHAR(40),
		start_date DATE,
		CONSTRAINT pk_Payment PRIMARY KEY (payment_id),
		CONSTRAINT fk_Payment1 FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE NO ACTION ON UPDATE CASCADE ,
		CONSTRAINT fk_Payment2 FOREIGN KEY (semester_code) REFERENCES Semester(semester_code) ON DELETE SET NULL ON UPDATE CASCADE, --!!!!!!!!!!!!!!!!!
		CONSTRAINT check_PaymentStatus CHECK ( status IN ('notPaid','Paid'))--,
		--CONSTRAINT check_n_installments CHECK ( n_installments = Month(deadline) - Month(start_date))
	);

	CREATE TABLE Installment (
		payment_id INT,
		deadline DATE,
		amount DECIMAL(10, 2),
		status INT,
		start_date DATE,
		CONSTRAINT pk_Installment PRIMARY KEY (payment_id, deadline),
		CONSTRAINT fk_Installment FOREIGN KEY (payment_id) REFERENCES Payment(payment_id)  ON DELETE CASCADE ON UPDATE CASCADE 
	);
GO

GO 
CREATE PROC DropAllTables
AS
	DROP TABLE Student;
	DROP TABLE Student_Phone;
	DROP TABLE Course;
	DROP TABLE PreqCourse_Course;
	DROP TABLE Instructor;
	DROP TABLE Instructor_Course;
	DROP TABLE Student_Instructor_Course_Take;
	DROP TABLE Semster;
	DROP TABLE Course_Semster;
	DROP TABLE Advisor;
	DROP TABLE Slot;
	DROP TABLE Graduation_Plan;
	DROP TABLE GradPlan_Course;
	DROP TABLE Request;
	DROP TABLE MakeUp_Exam;
	DROP TABLE Exam_Student;
	DROP TABLE Payment;
	DROP TABLE Installment;
Go
------
GO
CREATE PROC ClearAllTablesRecords
AS
	TRUNCATE TABLE Student;
	TRUNCATE TABLE Student_Phone;
	TRUNCATE TABLE Course;
	TRUNCATE TABLE PreqCourse_Course;
	TRUNCATE TABLE Instructor;
	TRUNCATE TABLE Instructor_Course;
	TRUNCATE TABLE Student_Instructor_Course_Take;
	TRUNCATE TABLE Semster;
	TRUNCATE TABLE Course_Semster;
	TRUNCATE TABLE Advisor;
	TRUNCATE TABLE Slot;
	TRUNCATE TABLE Graduation_Plan;
	TRUNCATE TABLE GradPlan_Course;
	TRUNCATE TABLE Request;
	TRUNCATE TABLE MakeUp_Exam;
	TRUNCATE TABLE Exam_Student;
	TRUNCATE TABLE Payment;
	TRUNCATE TABLE Installment; 
GO
--2.2
-----A
GO
	CREATE VIEW view_Students 
	AS 
		SELECT * FROM STUDENT S WHERE S.financial_status=1;
GO
-----B
GO
	CREATE VIEW view_Course_prerequisites 
	AS 
		SELECT C1.course_id AS 'Prerequsisite Course Id' , C1.name AS 'Prerequsisite Course Name' , C1.major AS 'Prerequisite Course Major' , C1.is_offered AS 'Prerequisite Course if offered' , C1.credit_hours AS 'Prerequisite Course Credit Hours' , C1.semester AS 'Prerequisite Course Semester' ,C2.course_id AS 'Course Id' , C2.name AS 'Course Name' , C2.major AS 'Course Major' , C2.is_offered AS 'Course if offered' , C2.credit_hours AS 'Course Credit Hours' , C2.semester AS 'Course Semester'  
		FROM Course C1
		INNER JOIN PreqCourse_course P On(C1.course_id=P.prerequisite_course_id)
		INNER JOIN Course C2 ON(P.course_id=C2.course_id);
GO
-----C
GO
	CREATE VIEW Instructors_AssignedCourses
	AS
		SELECT *
		FROM Instructor I
		INNER JOIN Instructor_Course L ON(I.instructor_id=L.instructor_id)
		INNER JOIN Course C ON(L.course_id=C.course_id);
GO
-----D
GO
	CREATE VIEW Student_Payment
	AS
		SELECT P.* , S.f_name + ' ' + S.l_name AS 'Student Name'
		FROM Payment P
		INNER JOIN Student S ON(P.student_id=S.student_id);
GO
-----E
GO
	CREATE VIEW Courses_Slots_Instructor
	AS
		SELECT C.course_id AS 'CourseID' , C.name AS 'Course Name' , S.slot_id, S.day, S.time , S.location, I.name  
		FROM Course C
		INNER JOIN Slot S ON(S.course_id = C.course_id)
		INNER JOIN Instructor I ON(S.intsructor_id = I.intsructor_id);
GO
-----F
GO
	CREATE VIEW Courses_MakeupExams 
	AS
		SELECT C.name AS 'Course’s Name' , C.semester AS 'Course’s Semester', M.*  
		FROM Course C 
		INNER JOIN MakeUp_Exam M ON M.course_id = C.course_id
GO
-----G
GO
	CREATE VIEW Student_Courses_transcript
	AS
		SELECT S.student_id,S.f_name+' '+S.l_name AS student_name,C.course_id,C.name AS course_name,SCT.exam_type,SCT.grade AS 'course grade',SCT.semester_code AS semester,I.name AS 'Instructor Name'
		FROM Student S
		INNER JOIN Student_Instructor_Course_Take SCT ON SCT.student_id = S.id
		INNER JOIN Course C ON C.course_id = SCT.course_id 
		INNER JOIN Instructor I ON I.instructor_id = SCT.instructor_id
GO
-----H
GO
	CREATE VIEW Semster_offered_Courses
	AS
		SELECT C.course_id AS 'Course ID',C.name AS 'Course Name',S.semster_code As 'Semster Code'
		FROM Course C
		INNER JOIN Course_Semster S ON(S.semster_code=C.semster_code);
GO
-----I
GO
	CREATE VIEW Advisors_Graduation_Plan
	AS
		SELECT G.*,A.name As 'Advisor name'
		FROM Graduation_Plan G
		INNER JOIN Advisor A ON(G.advisor_id=A.advisor_id);
GO
--2.3
-----A