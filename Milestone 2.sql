CREATE DATABASE Advising_Team_6;

DROP PROCEDURE CreateAllTables

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
		CONSTRAINT fk_Student FOREIGN KEY (advisor_id) REFERENCES Advisor(advisor_id) ON DELETE SET NULL ON UPDATE CASCADE
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
		CONSTRAINT fk_PreqCourse_course1 FOREIGN KEY (prerequisite_course_id) REFERENCES Course(course_id), -- ON DELETE CASCADE , --ON UPDATE CASCADE,
		CONSTRAINT fk_PreqCourse_course2 FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE-- ON UPDATE CASCADE
	);
	--DROP TABLE PreqCourse_course;

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
		CONSTRAINT pk_Student_Instructor_Course_Take PRIMARY KEY (student_id, course_id, instructor_id),
		CONSTRAINT fk_Student_Instructor_Course_Take1 FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT fk_Student_Instructor_Course_Take2 FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT fk_Student_Instructor_Course_Take3 FOREIGN KEY (instructor_id) REFERENCES Instructor(instructor_id) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT exam_type_check CHECK (exam_type IN ('Normal','First_makeup','Second_makeup')) 
	);

	CREATE TABLE Slot (
		slot_id INT IDENTITY,
		day VARCHAR(40),
		time VARCHAR(40),
		location VARCHAR(40),
		course_id INT,
		instructor_id INT,
		CONSTRAINT pk_Slot PRIMARY KEY (slot_id),
		CONSTRAINT fk_Slot1 FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT fk_Slot2 FOREIGN KEY (instructor_id) REFERENCES Instructor(instructor_id) ON DELETE CASCADE ON UPDATE CASCADE
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
		expected_grad_semester VARCHAR(40), 
		advisor_id INT,
		student_id INT,
		CONSTRAINT pk_Graduation_Plan PRIMARY KEY (plan_id, semester_code),
		CONSTRAINT fk_Graduation_Plan1 FOREIGN KEY (advisor_id) REFERENCES Advisor(advisor_id)ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT fk_Graduation_Plan2 FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE-- ON UPDATE CASCADE
	);
	--DROP TABLE Graduation_Plan;
	
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
		CONSTRAINT fk_Request1 FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE,-- ON UPDATE CASCADE,
		CONSTRAINT fk_Request2 FOREIGN KEY (advisor_id) REFERENCES Advisor(advisor_id) ON DELETE CASCADE, -- ON UPDATE CASCADE, 
		CONSTRAINT fk_Request3 FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE, --ON UPDATE CASCADE, 
		CONSTRAINT check_Request_Status CHECK (status IN ('pending','accepted','rejected'))
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
		CONSTRAINT fk_Payment1 FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE NO ACTION ON UPDATE CASCADE ,
		CONSTRAINT fk_Payment2 FOREIGN KEY (semester_code) REFERENCES Semester(semester_code) ON DELETE SET NULL ON UPDATE CASCADE,
		CONSTRAINT check_PaymentStatus CHECK ( status IN ('notPaid','Paid'))
	);

	CREATE TABLE Installment (
		payment_id INT,
		deadline DATETIME, 
		amount INT, 
		status VARCHAR(40) DEFAULT 'NotPaid',
		start_date DATETIME, 
		CONSTRAINT pk_Installment PRIMARY KEY (payment_id, deadline),
		CONSTRAINT fk_Installment FOREIGN KEY (payment_id) REFERENCES Payment(payment_id)  ON DELETE CASCADE ON UPDATE CASCADE 
	);
GO

EXECUTE CreateAllTables;

GO 
CREATE PROC DropAllTables
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
	DROP TABLE PreqCourse_course;
	DROP TABLE Course;
	DROP TABLE Student_Phone;
	DROP TABLE Student;
	DROP TABLE Advisor;
	--DROP TABLE ;
GO

EXECUTE DropAllTables;
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
	TRUNCATE TABLE Semester;
	TRUNCATE TABLE Course_Semester;
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
	CREATE VIEW Semester_offered_Courses
	AS
		SELECT C.course_id AS 'Course ID',C.name AS 'Course Name',S.semester_code As 'Semester Code'
		FROM Course C
		INNER JOIN Course_Semester S ON(S.semester_code=C.semester_code);
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
GO
	CREATE PROCEDURE Procedures_StudentRegistration
		@f_name VARCHAR(40),
		@l_name VARCHAR(40),
		@password VARCHAR(40),
		@faculty VARCHAR(40),
		@email VARCHAR(40),
		@major VARCHAR(40),
		@semester INT,
		@student_id INT OUTPUT
	AS
		INSERT INTO Student(f_name,l_name,password,faculty,email,major,semester)
		VALUES(@f_name,@l_name,@password,@faculty,@email,@major,@semester);
		SELECT @student_id = student_id FROM Student WHERE f_name = @f_name AND l_name = @l_name AND password = @password AND faculty = @faculty AND email = @email AND major = @major AND semester = @semester;
GO
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
		VALUES(@advisor_name,@password,@email);
		SELECT @advisor_id = advisor_id FROM Advisor WHERE name = @advisor_name AND password = @password AND email = @email AND office = @office;
GO
-----C
GO 
	CREATE PROCEDURE Procedures_AdminListStudents
	AS
		SELECT * FROM Student;
GO
-----D
GO
	CREATE PROCEDURE Procedures_AdminListAdvisors
	AS
		SELECT * FROM Advisor;
GO
-----E
GO
	CREATE PROCEDURE AdminListStudentsWithAdvisors
	AS	
		SELECT S.*,A.*
		FROM Student S
		INNER JOIN Advisor A ON(S.advisor_id=A.advisor_id);
GO
-----F
GO 
	CREATE PROCEDURE AdminAddingSemeseter
		@start_date DATE,
		@end_date DATE,
		@semester_code VARCHAR(40)
	AS
		INSERT INTO Semester(start_date,end_date,semester_code)
		VALUES(@start_date,@end_date,@semester_code);
GO
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
-----H
GO 
	CREATE PROCEDURE Procedures_AdminLinkInstuctorToCourse
		@instructor_id INT,
		@course_id INT,
		@slot_id INT
		AS
		INSERT INTO Instructor_Course(instructor_id,course_id)
		VALUES(@instructor_id,@course_id);
		UPDATE Slot SET instructor_id = @instructor_id WHERE slot_id = @slot_id;
GO
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
-----K   ask about Exam(makeup)
GO
	CREATE PROC Prcedures_AdminAddExam
		@Type VARCHAR(40),
		@date DATETIME,
		@courseID INT
	AS
		INSERT INTO MakeUp_Exam(date,type,course_id)
		VALUES(@Type,@date,@courseID);
GO
-----L 
GO
	CREATE PROC Prcedures_AdminIssueInstllment
		@payment_id INT
	AS
		DECLARE @start_date DATE ,@end_date DATE, @monthDiff INT , @amount INT , @counter INT

		SELECT @start_date = start_date , @end_date = deadline
		FROM Payment
		WHERE payment_id = @payment_id;

		SET @monthDiff = DATEDIFF(MONTH,@start_date,@end_date);

		UPDATE Payment
		SET n_installments = @monthDiff
		WHERE payment_id = @payment_id;
 	
		SELECT @amount = amount/@monthDiff
		FROM Payment
		WHERE payment_id = @payment_id;

		SET @counter = 1;
		WHILE (@counter <= @monthDiff)
		BEGIN
			INSERT INTO Installment(payment_id,deadline,amount)
			VALUES(@payment_id,DATEADD(MONTH,@counter,@start_date),@amount);
			SET @counter = @counter + 1;
		END
GO
-----M
GO
	CREATE PROC Prcedures_AdminDeleteCourse
		@courseID INT
	AS
		DELETE FROM Course WHERE Course.course_id=@courseID;
		DELETE FROM Slot WHERE  Slot.course_id=@courseID;
GO
-----N
GO
	CREATE PROC Prcedures_AdminUpdateStudentStatus 
		@StudentID INT
	AS
		IF EXISTS(
			SELECT I.payment_id 
			FROM Student S 
			INNER JOIN Payment P ON S.student_id=P.student_id 
			INNER JOIN Installment I ON P.payment_id=I.payment_id
			WHERE student_id=@StudentID AND CURRENT_TIMESTAMP > I.deadline AND I.status='NotPaid'
			)
		UPDATE Student SET financial_status=0 WHERE student_id=@StudentID;
		ELSE
		UPDATE Student SET financial_status=1 WHERE student_id=@StudentID;
GO
-----O
GO
	CREATE VIEW all_Pending_Requests
	AS
		SELECT R.Request_id AS 'Request ID',R.type AS 'Type',R.comment AS 'Comment',R.status AS 'Request status',R.credit_hours AS 'Credit Hours',R.course_id AS 'Course ID',R.student_id AS 'Student ID', S.f_name+''+S.l_name AS 'Student Name',R.advisor_id AS 'Advisor ID', A.name AS 'Related Advisor Name'
		FROM Request R 
		INNER JOIN Student S ON R.student_id=S.student_id
		INNER JOIN Advisor A ON R.advisor_id=A.advisor_id
		WHERE R.status='Pending';
GO
-----P
GO
	CREATE PROC Prcedures_AdminDeleteSlots
		@current_semester VARCHAR(40)
	As
		DELETE FROM Slot WHERE Slot.course_id IN (
			SELECT C.course_id
			FROM Course_Semester C 
			WHERE C.semester_code<>@current_semester
			);	
Go
-----Q
GO
	CREATE FUNCTION FN_AdvisorLogin (@iD iNT,@password VARCHAR(40))
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
-----R
GO 
	CREATE PROCEDURE Procedures_AdvisorCreateGP
		@semester_code VARCHAR(40),
		@expected_grad_date DATE,
		@sem_credit_hours INT,
		@advisor_id INT,
		@student_id INT
	AS
		DECLARE @semester VARCHAR(40)
		SELECT @expected_semester = semester_code FROM Semester WHERE start_date <= @expected_grad_date AND end_date >= @expected_grad_date;
		INSERT INTO Graduation_Plan(semester_code,expected_grad_semester,semester_credit_hours,advisor_id,student_id)
		VALUES(@semester_code,@expected_semester,@sem_credit_hours,@advisor_id,@student_id);
GO
-----S
GO
	CREATE PROCEDURE Procedures_AdvisorAddCourseGP
		@student_id INT,
		@semester_code VARCHAR(40),
		@course_name VARCHAR(40)
	AS
		DECLARE @course_id INT
		SELECT @course_id = course_id FROM Course WHERE name = @course_name;
		INSERT INTO GradPlan_Course(student_id,semester_code,course_id)
		VALUES(@student_id,@semester_code,@course_id);
GO
-----T
GO
	CREATE PROCEDURE Procedures_AdvisorUpdateGP
	@expected_grad_semster VARCHAR (40),
	@studentID INT
	AS
		UPDATE Graduation_Plan 
		SET expected_grad_semester = @expected_grad_semster
		WHERE student_id= @id
GO

-----U
GO
	CREATE PROC Prcedures_AdvisorDeleteFromGP
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
-----V
GO
	CREATE Function FN_Advisors_Request (@AdvisorID INT)
	RETURNS TABLE
	AS
	RETURN
	(
		SELECT R.*
		FROM Request R 
		WHERE R.advisor_id=@AdvisorID
	);	
GO
-----W  
GO 
	CREATE PROCEDURE Procedures_AdvisorApproveRejectCHRequest
	@RequestID INT,
	@Current_semester_code VARCHAR (40)
	AS
	BEGIN 
		DECLARE @gpa INT, @student_id INT, @total_credit_hours INT, @credit_hours INT ,  @assigned_hours INT
		SELECT @student_id = student_id, @credit_hours = credit_hours FROM Request WHERE request_id = @RequestID;

		SELECT @gpa = S.gpa FROM Student S WHERE S.student_id = @student_id;
		
		SELECT @total_credit_hours = SUM(credit_hours) 
		FROM Student_Instructor_Course_Take SCT 
		INNER JOIN Course C ON (C.semester_code = SCT.semester_code)
		WHERE SCT.student_id = @student_id AND SCT.semester_code = @Current_semester_code;

		SELECT @assigned_hours = assigned_hours 
		FROM Student
		WHERE student_id = @student_id;
		IF (@gpa>3.7 AND (@total_credit_hours + @assigned_hours + @credit_hours >34))
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
		END
	END
GO

-----X
GO
	CREATE PROCEDURE Procedures_AdvisorViewAssignedStudents
	@AdvisorID INT,
	@major VARCHAR(40)
	AS
		SELECT S.student_id AS 'Student ID' , S.f_name + ' ' + S.l_name AS 'Student Full Name' , C.name AS 'Course Name'
		FROM Student S INNER JOIN Student_Instructor_Take T ON T.student_id = S.student_id
					   INNER JOIN Course C ON C.course_id = T.course_id
		WHERE S.advisor_id = @AdvisorID AND S.major = @major 
GO
-----Y  --not done -- Ask should I check that the advisor is the one who is assigned to the student or not?
GO
	CREATE PROCEDURE Procedures_AdvisorApproveRejectCourseRequest
	@RequestID INT,
	@studentID INT,
	@advisorID INT
	AS
		DECLARE @course_id INT , @crs_credHrs INT , @assigned_hours INT , @advID INT , @tookPREQ BIT

		SELECT @course_id = course_id 
		FROM Request
		WHERE request_id = @RequestID;

		SELECT @crs_credHrs = credit_hours
		FROM Course
		WHERE course_id = @course_id;

		SELECT @assigned_hours = assigned_hours
		FROM Student
		WHERE student_id = @studentID;

		SELECT @advID = advisor_id
		FROM Student
		WHERE student_id = @studentID;

		SELECT @help = course_id
		FROM Student_Instructor_Course_Take
		
		
		IF (NOT EXISTS( 
						(SELECT P.prerequisite_course_id
						FROM PreqCourse_course P
						WHERE P.course_id = @course_id
						)
						EXCEPT
						(SELECT SCT.course_id
						FROM Student_Instructor_Take SCT
						WHERE SCT.student_id = @student_id AND SCT.grade NOT LIKE 'F')
						))
			SET @tookPREQ = 1;
		ELSE
			SET @tookPREQ = 0;

		IF (@courseID IS NOT NULL AND @advID = @advisor_id AND @assigned_hours >= @crs_credHrs AND @tookPREQ =1)
		BEGIN
			UPDATE Request
			SET status = 'Accepted'
			WHERE request_id = @RequestID;

			INSERT INTO Student_Instructor_Course_Take(student_id,course_id,instructor_id,semester_code)
			VALUES(@studentID,@course_id,@advisorID,@current_semester_code);

			UPDATE Student
			SET assigned_hours = @assigned_hours - @crs_credHrs
			WHERE student_id = @studentID;
		END
		ELSE
		BEGIN
			UPDATE Request
			SET status = 'Rejected'
			WHERE request_id = @RequestID;
		END
GO
-----Z
GO
	CREATE PROC Procedures_AdvisorViewPendingRequests
		@AdvisorID INT
	AS
		SELECT R.*
		FROM Request R   
		WHERE R.status='Pending' AND R.advisor_id=@AdvisorID;
GO
-----AA (REVIEW)
GO

CREATE FUNCTION FN_StudentLogin
(
	@student_id INT,
	@password VARCHAR(40)
)
RETURNS BIT
AS
BEGIN
	DECLARE @Success BIT

	IF EXISTS(SELECT * FROM Student WHERE student_id = @student_id AND password = @password)
		SET @Success = 1;
	ELSE
		SET @Success = 0;

	RETURN @Success;
END;

GO
-----BB 
GO
CREATE PROCEDURE Prodceures_StudentaddMobile
	@StudentID INT,
	@mobile_number VARCHAR(40)
	AS
		INSERT INTO Student_Phone(student_id,phone_number)
		VALUES(@student_id,@mobile_number);
GO
-----CC (REVIEW) --> 
GO

CREATE FUNCTION FN_SemesterAvailabeCourses(@semester_code VARCHAR(40))
RETURNS TABLE
AS
RETURN
(
	SELECT C.*
	FROM Course C
	INNER JOIN Course_Semester CS ON(C.course_id = CS.course_id)
	WHERE status = 'Available' AND CS.semester_code = @semester_code
);

GO
-----DD
GO

CREATE PROCEDURE Procedures_StudentSendingCourseRequest
	@StudentID INT,
	@CourseID INT,
	@type VARCHAR(40),
	@comment VARCHAR(40)
	AS
		INSERT INTO Request(type,comment,course_id,student_id)
		VALUES(@type,@comment,@CourseID,@StudentID);

GO
-----EE
GO

CREATE PROCEDURE Procedures_StudentSendingCHRequest
	@StudentID INT,
	@credit_hours INT,
	@type VARCHAR(40),
	@comment VARCHAR(40)
	
	AS
		INSERT INTO Request(type,comment,credit_hours,student_id)
		VALUES(@type,@comment,@credit_hours,@StudentID);

GO
-----FF
GO
CREATE FUNCTION FN_StudentViewGP(@student_id INT)
RETURNS TABLE
AS
RETURN
(
	SELECT S.Student_id , S.name , GP.plan_id , C.course_id , C.name , GP.semester_code , SEM.end_date , GP.semester_credit_hours , GP.advisor_id
	FROM Graduation_Plan GP
		INNER JOIN Student S On GP.student_id= S.student_id
		INNER JOIN GradPlan_Course GC ON (GP.plan_id= GC.plan_id AND GP.semester_code=GC.semester_code)
		INNER JOIN Course C on GC.course_id= C.course_id
		INNER JOIN Semester SEM ON GP.expected_grad_semester=SEM.semester_code
	WHERE S.student_id = @student_id
);		
GO
-----GG
CREATE FUNCTION FN_StudentUpcoming_installment(@student_id INT)
RETURNS DATETIME
AS
BEGIN
	DECLARE @upcoming_installment DATETIME

	SELECT TOP 1 @upcoming_installment = deadline
	FROM Installment
	WHERE student_id = @student_id
	AND payment_status = 'NotPaid'
	ORDER BY deadline ASC
	RETURN @upcoming_installment
END;
GO
-----HH
GO
	CREATE FUNCTION FN_StudentViewSlot (@CourseID INT,@InstructorID INT)
	RETURNS TABLE 
	AS
	RETURN
	(
		SELECT S.slot_id AS 'Slot ID',S.location AS'Location',S.time AS 'Time',S.day AS 'Day',C.name AS 'Course name',I.name AS 'Instructor name'
		FROM Slot S
		INNER JOIN Course C ON S.course_id=C.course_id
		INNER JOIN Instructor I ON S.instructor_id=I.instructor_id
		WHERE S.course_id=@CourseID AND S.instructor_id=@InstructorID
	);
GO
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
		WHERE semester_code = @studentCurrentSemester AND (grade LIKE 'F%' ) AND student_id = @StudentID AND course_id = @course_id AND exam_type = 'Normal';
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
-----JJ
GO
	CREATE FUNCTION FN_StudentCheckSMEligibility(@courseID INT,@Student_id INT)
	RETURNS BIT
	AS
	BEGIN
	DECLARE @countFailed INT
	SELECT @countFailed = COUNT(DISTINCT course_id)
		FROM Student_Instructor_Course_Take 
		WHERE grade = 'F' AND student_id = @StudentID 
	
	DECLARE @firstMakeup INT
	SELECT @firstMakeup = course_id
		FROM Student_Instructor_Course_Take 
		WHERE  student_id = @StudentID AND course_id = @course_id AND exam_type = 'First_makeup' AND (grade LIKE 'F%' OR grade IS NULL) 

	RETURN CASE WHEN  (@countFailed > 2 OR @firstMakeup IS NULL) THEN 0
																 ELSE 1
				END
	END
GO
-----KK
GO
	CREATE PROCEDURE Procedures_StudentRegisterSecondMakeup
		@StudentID INT,
		@course_id INT,
		@studentCurrentSemester VARCHAR(40)
		AS
			DECLARE @isEligible BIT
			SELECT @isEligible = dbo.FN_StudentCheckSMEligibility(@course_id,@StudentID)
			DECLARE @course INT
			SELECT @course = course_id
			FROM Student_Instructor_Course_Take 
			WHERE semester_code = @studentCurrentSemester AND grade = 'F' AND student_id = @StudentID AND course_id = @course_id AND exam_type = 'First_makeup';
			IF @course IS NOT NULL AND @isEligible = 1
			BEGIN
				DECLARE @exam_id INT

				SELECT @exam_id = exam_id
				FROM MakeUp_Exam
				WHERE course_id = @course_id AND type = 'Second_makeup';

				INSERT INTO Exam_Student(exam_id,student_id,course_id)
				VALUES(@exam_id,@StudentID,@course_id);

				UPDATE Student_Instructor_Course_Take
				SET exam_type = 'Second_makeup' , grade = NULL
				WHERE student_id = @StudentID AND course_id = @course_id AND semester_code = @studentCurrentSemester;
			END
-----LL 
GO
CREATE PROCEDURE Procedures_ViewRequiredCourses
	@student_id INT,
	@current_semester_code VARCHAR(40)
	AS
		((SELECT C.* 
		FROM Course C
		INNER JOIN Student_Instructor_Course_Take SCT ON (C.course_id = SCT.course_id AND SCT.student_id = @student_id)
		WHERE SCT.grade = 'F' AND dbo.FN_StudentCheckSMEligibility(C.course_id, @student_id) = 0)
		UNION
		((SELECT C.*
		FROM Course C
		WHERE C.semester < (SELECT S.semester
							FROM Student S
							WHERE S.student_id = @student_id AND S.major = C.major)
		EXCEPT 
		(SELECT C.* 
		FROM Course C
		INNER JOIN Student_Instructor_Course_Take SCT ON (C.course_id = SCT.course_id AND SCT.student_id = @student_id)
		WHERE SCT.grade NOT LIKE 'F%' )
		))
		INTERSECT
		(SELECT C.*
		FROM Course_Semester CS
		WHERE CS.semester_code = @current_semester_code)
		)


GO
-----MM  
 GO 
 	CREATE PROCEDURE Procedures_ViewOptionalCourse
 		@student_id INT,
 		@current_semester_code VARCHAR(40)
 		AS
		((SELECT C.*
		FROM Course C
		WHERE C.semester >= (SELECT S.semester
							FROM Student S
							WHERE S.student_id = @student_id AND S.major = C.major)
			 AND NOT EXISTS( 
						(SELECT P.prerequisite_course_id
						FROM PreqCourse_course P
						WHERE P.course_id = C.course_id
						)
						EXCEPT
						(SELECT SCT.course_id
						FROM Student_Instructor_Take SCT
						WHERE SCT.student_id = @student_id AND SCT.grade NOT LIKE 'F')
			 ))
			 INTERSECT
			(SELECT C.*
			FROM Course_Semester CS
			WHERE CS.semester_code = @current_semester_code)
			)

		
 GO
-----NN  
GO
	CREATE PROCEDURE Procedures_viewMS
		@student_id INT
		AS
			(SELECT C.*
			FROM Course C
			WHERE C.major = (SELECT S.major
							FROM Student S
							WHERE S.student_id = @student_id))
			EXCEPT
			(SELECT C.*
			FROM Course C
					INNER JOIN Student_Instructor_Course_Take SCT ON C.course_id = SCT.course_id 
			WHERE SCT.grade NOT LIKE 'F%' AND SCT.student_id = @student_id
			)
			
GO
-----OO  
GO	
CREATE PROCEDURE Procedures_ChooseInstructor
	@student_id INT,
	@instructor_id INT,
	@course_id INT
	AS
		UPDATE Student_Instructor_Course_Take
		SET instructor_id = @instructor_id
		WHERE student_id = @student_id AND course_id = @course_id;
GO