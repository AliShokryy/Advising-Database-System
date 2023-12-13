--drop database Advising_system;
Create Database Advising_System;
go
Use Advising_System


-------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////////////////////////////////////////////////
Go

CREATE PROC [CreateAllTables]
     AS  
create table Advisor (
advisor_id int primary key identity, 
advisor_name varchar(40),
email varchar(40),
office varchar(40),
password varchar(40) not null
) 
-----------------------Student Table--------------------------------------

     Create Table Student (
     student_id int primary Key Identity(1,1), 
     f_name Varchar(40),
     l_name Varchar(40),
     password Varchar(40), 
     gpa decimal(10,2),
     faculty Varchar(40),
     email Varchar(40),
     major Varchar(40),
     financial_status bit,
     semester int, 
     acquired_hours int, 
     assigned_hours int, 
     advisor_id int Foreign key references Advisor(advisor_id) on update cascade on delete cascade
   )
 ---------------------------Student_Phone----------------------------------
     Create Table Student_Phone (
     student_id int Foreign key references Student(student_id),
     phone_number varchar(40),
     primary key(student_id, phone_number)
     )

----------------------------------Graduation_Plan-----------------------------------------------
create table Graduation_Plan (
plan_id int not null identity(1,1),
semester_code varchar(40) not null, 
semester_credit_hours int,
expected_grad_date date,
advisor_id int Foreign key references Advisor(advisor_id)  on update cascade  on delete cascade,
student_id int Foreign key references Student(student_id),
primary key(plan_id, semester_code)
)
----------------------------Course--------------------------------------------
     Create Table Course (
     course_id int primary key identity, 
     name varchar(40),
     major varchar(40), 
     is_offered bit, 
     credit_hours int,
     semester int
     )

---------------------------------PreqCourse_course-------------------------------------
     Create Table PreqCourse_course(
     prerequisite_course_id int Foreign key references course(course_id)  on update cascade on delete cascade,
     course_id int Foreign key references course(course_id),
     primary key(prerequisite_course_id,course_id)
     )
---------------------------Instructor------------------------------------
create table Instructor (
instructor_id int primary key,
name varchar(40),
email varchar(40), 
faculty varchar(40), 
office varchar(40)
)

--------------------------------Instructor_Course-----------------------------------
create table Instructor_Course (
course_id int Foreign key references course(course_id)  on update cascade on delete cascade, 
instructor_id int Foreign key references Instructor(instructor_id)  on update cascade on delete cascade,
primary key(course_id, instructor_id)
)
----------------------------Student_Instructor_Course_take-------------------------
create table Student_Instructor_Course_take (
student_id int Foreign key references Student(student_id)  on update cascade on delete cascade,
course_id int Foreign key references course(course_id)  on update cascade on delete cascade, 
instructor_id int Foreign key references Instructor(instructor_id)  on update cascade on delete cascade, 
semester_code varchar(40), 
exam_type varchar(40) Default 'Normal', 
grade varchar(40),
primary key(student_id, course_id, semester_code)
)     
------------------------Semester----------------------------------

create table Semester (
semester_code varchar(40) primary key,
start_date date, 
end_date date
)
------------------------Course_Semester-------------------------------------
create table Course_Semester (
course_id int Foreign key references course(course_id)  on update cascade on delete cascade , 
semester_code varchar(40) references Semester(semester_code)  on update cascade on delete cascade,
primary key(course_id, semester_code)
)

------------------------GradPlan_Course_(include)-------------------------------------

create table GradPlan_Course (
plan_id int,
semester_code varchar(40),
course_id int Foreign key references course(course_id) on update cascade on delete cascade,
constraint FK_Grad  foreign key (plan_id,semester_code) references Graduation_Plan (plan_id, semester_code),
primary key (course_id,plan_id, semester_code)
)
-------------------------------------------------------------
------------------------Slot-------------------------------------

create table Slot (
slot_id int primary key, 
day varchar(40),
time varchar(40), 
location varchar(40), 
course_id int Foreign key references course(course_id)  on update cascade on delete cascade,
instructor_id int Foreign key references Isnstructor(instructor_id) on update cascade on delete cascade
)

---------------------------Request-----------------------------------------
create table Request (
request_id int primary key identity(1,1), 
type varchar(40), 
comment varchar(40), 
status varchar(40) default 'Pending', 
credit_hours int,
course_id int,
student_id int Foreign key references Student(student_id)  on update cascade on delete cascade, 
advisor_id int Foreign key references Advisor(advisor_id)  /*on update cascade on delete cascade*/
)
--------------------------------------------------------------

-------------------------------MakeUp_Exam---------------------------------
create table MakeUp_Exam (
exam_id int primary key identity,
date date,
type varchar(40), 
course_id int Foreign key references course(course_id)  on update cascade on delete cascade
)
-------------------------------Exam_Student-------------------------------

create table Exam_Student (
exam_id int Foreign key references MakeUp_Exam(exam_id)  on update cascade on delete cascade,
student_id int Foreign key references Student(student_id),
course_id int,
primary key(exam_id, student_id)
)
---------------------------Payment-----------------------------------

create table Payment(
payment_id int primary key,
amount int,
startdate datetime,
deadline datetime,
n_installments int,
fund_percentage decimal(10,2),
status varchar(40) default 'notPaid',
student_id int Foreign key references Student(student_id)  on update cascade on delete cascade,
semester_code varchar(40) Foreign key references Semester(semester_code) on update cascade on delete cascade
)
----------------------------Installment-------------------------------------
Create table Installment (
payment_id int not null Foreign key references Payment(payment_id) on update cascade on delete cascade,
startdate datetime,
deadline datetime not null,
amount int,
status varchar(40) default 'notPaid',
primary key(payment_id,deadline)
)
  GO
--/////////////////////////////////////////////////////////////////////////////////////------------------------------------------------------------------------------

EXEC CreateAllTables

--///////////////////////////////////////////////////////////

--------------------------Active Students with accepted financial_status-----------------------------------------------------
go
CREATE  VIEW  view_Students AS
Select * from Student where financial_status = 1

---------------------------------courses with their prerequisites--------------------------------------------------------------
go
CREATE  VIEW  view_Course_prerequisites AS
Select C1.*, C2.course_id as preRequsite_course_id, C2.name as preRequsite_course_name 
from Course C1 inner join PreqCourse_course On C1.course_id = PreqCourse_course.course_id
inner join course C2 on PreqCourse_course.prerequisite_course_id = c2.course_id
go
-----------------------------------all Instructors along with their assigned courses------------------------------------------------------

CREATE  VIEW  Instructors_AssignedCourses AS
Select Instructor.instructor_id, Instructor.name as Instructor, Course.course_id, Course.name As Course
from Instructor inner join Student_Instructor_Course_take t on Instructor.instructor_id = t.instructor_id
inner join Course On Course.course_id = t.course_id 

-----------------------------------all payments along with their corresponding student--------------------------------------------------
go

CREATE  VIEW  Student_Payment AS
Select Student.student_id as studentID , Student.f_name, Student.l_name, Payment.* 
from Payment Inner join Student on Payment.student_id = Student.student_id

----------------------------all courses along with their corresponding slots’ details and Instructor----------------------------------------------------------
go
CREATE  VIEW  Courses_Slots_Instructor AS
Select Course.course_id as CourseID , Course.name As Course, Slot.*, Instructor.name as Instructor
from Course inner join Slot on Course.course_id = Slot.course_id
inner join Instructor on Slot.instructor_id = Instructor.instructor_id

go
----------------------all courses along with their exams’ details-----------------------------------------------------------------
CREATE  VIEW  Courses_MakeupExams AS
Select MakeUp_Exam.*, Course.name, Course.semester
from MakeUp_Exam inner join Course on MakeUp_Exam.course_id = Course.course_id 

------------------------All students along with their taken courses details--------------------------------------------------------------------
go
CREATE  VIEW  Students_Courses_transcript AS
Select Student.student_id, student.f_name,student.l_name, t.course_id,Course.name , t.exam_type,t.grade, t.semester_code
from Student inner join Student_Instructor_Course_take t on Student.student_id = t.student_id
inner join Course On Course.course_id = t.course_id
go
--------------------------semesters along with their offered courses-----------------------------------------------------
CREATE  VIEW  Semster_offered_Courses AS
Select Course.course_id, Course.name, Semester.semester_code
from Course inner join Course_Semester on Course.course_id = Course_Semester.course_id
inner join Semester on Course_Semester.semester_code = semester.semester_code
go
-----------------------------graduation plans along with their initiated advisors-----------------------------------------------------

CREATE  VIEW  Advisors_Graduation_Plan AS
Select Graduation_Plan.*, Advisor.advisor_id as AdvisorID, Advisor.advisor_name
from Graduation_Plan inner join Advisor on Graduation_Plan.advisor_id = Advisor.advisor_id

------------------------------------------------------------------------------------

--///////////////////////////////////////////////////////////////////////////////////////////////

--///////////////////////////////As an unregistered user I should be able to////////////////////////////////////////////////

GO
--drop procedure Procedures_StudentRegistration
--------------------------[Procedures_StudentRegistration]---------------------------------------------------
CREATE PROC [Procedures_StudentRegistration]
     @first_name varchar(20), 
     @last_name varchar(20), 
     @password varchar(20), 
     @faculty varchar(20), 
     @email varchar(50), 
     @major varchar(20),
     @Semester int,
     @Student_id int OUTPUT
     AS 
     insert into Student  (f_name,l_name,password, faculty, email, major, semester) 
     values (@first_name, @last_name, @password, @faculty, @email, @major, @Semester)
    
    Select @Student_id =  student_id from Student 
     where f_name = @first_name and
     l_name= @last_name and
     password = @password  and
     email = @email 
    
     Go

   ------------------------------------Advisor Registration----------------------------------------------------

Go
CREATE PROC [Procedures_AdvisorRegistration]
     @advisor_name varchar(20), 
     @password varchar(20), 
     @email varchar(50), 
     @office varchar(20),
     @Advisor_id int OUTPUT
     AS 
     insert into Advisor(advisor_name,password, email, office) 
     values (@advisor_name, @password, @email, @office)
    
    Select @Advisor_id =  advisor_id from Advisor 
     where advisor_name = @advisor_name and
     password = @password  and
     email = @email 
    
     Go

--/////////////////////////////////////////////////////////////////////////////////

--//////////////////////////////As an admin I should be able to://////////////////////////////////////////////////

-----------------------List all advising students--------------------------------------
Go
CREATE PROC [Procedures_AdminListStudents]
As
Select * from Student

-----------------------List all advisors--------------------------------------
Go
CREATE PROC [Procedures_AdminListAdvisors]
As
Select * from Advisor

-----------------------List all Students with their Advisors--------------------------------------
go
Create Proc [AdminListStudentsWithAdvisors] AS
Select Student.student_id, Student.f_name, Student.l_name, Advisor.advisor_id, Advisor.advisor_name
from Student inner join Advisor on Student.advisor_id = Advisor.advisor_id
go

----------------------------Add new Semester-------------------------------------------
Go
CREATE PROC [AdminAddingSemester]

    @start_date date,
    @end_date date, 
    @semester_code Varchar(40)

     AS 
     IF @start_date IS NULL or @end_date IS NULL or @semester_code IS NULL 
    print 'One of the inputs is null'
    Else
     insert into Semester(start_date, end_date, semester_code) 
     values (@start_date, @end_date, @semester_code)
     
Go


-----------------------------Add new Course---------------------------------------

Go

CREATE PROC [Procedures_AdminAddingCourse]

    @major varchar(20),
    @semester int, 
    @credit_hours int, 
    @name varchar(30),
    @is_offered bit


     AS 
     IF @major IS NULL or @semester IS NULL or @name IS NULL or @credit_hours is Null or
     @is_offered is Null
    print 'One of the inputs is null'
    Else
     insert into Course(name, major,semester,credit_hours,is_offered) 
     values (@name, @major, @semester,@credit_hours,@is_offered)
     
Go

-----------------------------------------------------------------------
--------------------- Link instructor to course on specific slot-----------------------

Go

CREATE PROC [Procedures_AdminLinkInstructor]
@cours_id int,
@instructor_id int, 
@slot_id int
As

IF @cours_id IS NULL or @instructor_id IS NULL or @slot_id IS NULL 
    print 'One of the inputs is null'

Else
update Slot 
set course_id =@cours_id,
instructor_id =@instructor_id 
where slot_id = @slot_id;

Go

---------------------------------------------------------------------------------------------
------------------ Link student to course and instructor -----------------------------

Go
CREATE PROC [Procedures_AdminLinkStudent]
@cours_id int,
@instructor_id int, 
@studentID int,
@semester_code varchar(40)
As

IF @cours_id IS NULL or @instructor_id IS NULL or @studentID IS NULL or @semester_code IS NULL
    print 'One of the inputs is null'

Else
insert into Student_Instructor_Course_take ( instructor_id, course_id,student_id, semester_code) values (@instructor_id,@cours_id,@studentID,@semester_code) 

Go

----------------------------------------------------------------------------------
-------------------------Link student to advisor-----------------------------------------------------------
/*

Link student to advisor
Name: AdminLinkStudentToAdvisor
Input: studentID int, advisorID int

*/
Go

CREATE PROC [Procedures_AdminLinkStudentToAdvisor]

@studentID int, 
@advisorID int

As
IF @studentID IS NULL or @advisorID IS NULL 
    print 'One of the inputs is null'

Else
update Student 
set advisor_id = @advisorID
where student_id = @studentID
Go

--------------------------------AdminAddExam---------------------------------------------------------------
/*
Admin add exam
Name: AdminAddExam
Input: Type varchar(30), date datetime, courseID int
*/
Go

CREATE PROC [Procedures_AdminAddExam]

@Type varchar(40), 
@date datetime,
@courseID int

As
IF @Type IS NULL or @date IS NULL  or @courseID IS Null
    print 'One of the inputs is null'

Else
insert into MakeUp_Exam values (@date, @Type, @courseID)
Go

------------------------Issue installments as per the number of installments for a certain payment---------------------------------------------------------
/*
Issue installments as per the number of installments for a certain payment
Name: AdminIssueInstallment 
Input: paymentID int
Output: Nothing 

 */
 
Go
CREATE PROC [Procedures_AdminIssueInstallment]
@payment_id int

As
Declare 
@payment_amount int,
@startdate datetime,
@deadline datetime,
@num_of_installment int,

@installment_amount int,
@num_of_insertions int,
@install_start_date date,
@install_deadline date,
@add_month int

Select @payment_amount = amount from Payment where payment_id = @payment_id
Select @startdate = payment.startdate from Payment where payment_id = @payment_id
Select @deadline = deadline from Payment where payment_id = @payment_id
Select @num_of_installment = n_installments from Payment where payment_id = @payment_id
-------
set @installment_amount = @payment_amount/ @num_of_installment
set @num_of_insertions = @num_of_installment
set @install_start_date =  @startdate
set @add_month =1

while @num_of_insertions > 0
Begin

Set @install_deadline = DATEADD(month, 1, @install_start_date)  

insert into Installment values (@payment_id, @install_start_date,@install_deadline,@installment_amount,'NotPaid')

set @install_start_date = DATEADD(month, 1, @install_start_date) --@install_start_date  +1 
set @num_of_insertions = @num_of_insertions -1

End 


GO

------------------------------------------------------------------------------------
 -------------------------------Delete courses-----------------------------------------------
Go

CREATE PROC [Procedures_AdminDeleteCourse]
@courseID int

As
Delete from Course where course_id = @courseID
update Slot 
set course_id = null
where course_id = @courseId

Go
-----------------------------------------------------------------------------------------
 ----------------------------------[FN_AdminCheckStudentStatus]-------------------------------------
/*
Un/Block student based on his/her financial status {
note that student has an attribute status which is updated based on his/her due payments. 
If the student is blocked, he/she can’t login to the system}
Name: AdminCheckStudentStatus
Input: StudentID int
 Output: bit
Type: Function

*/
Go
CREATE FUNCTION [FN_AdminCheckStudentStatus]
(@Student_id int)     --Define Function Input
Returns bit   	  --Define Function Output

AS
Begin
Declare
@status bit,
@install_status varchar(40)

Select @install_status = Installment.status 
from Installment inner join Payment on Payment.payment_id = Installment.payment_id
and Payment.student_id = @Student_id and Installment.deadline < current_timestamp

if @install_status = 'Paid'
set @status =1

Else if @install_status = 'NotPaid'
set @status =0

Return @status 	 --Return Function Output
END
Go

---------------------------------------Procedure_AdminUpdateStudentStatus-------------------------------------
go 
create proc [Procedure_AdminUpdateStudentStatus]
@student_id int
as
 update Student
 set financial_status = dbo.FN_AdminCheckStudentStatus(@student_id)
 where student_id = @student_id
 go
-----------------------------List all pending requests----------------------------------------------------------
/*List all pending requests
Name: AdminListPendingRequests
Input: Nothing
 Output: Table with all the pending requests details in addition to the related student name and advisor name
*/

Create View all_Pending_Requests As
Select * from Request where status = 'Pending';
-------------------------------------------------------------------
---Delete slots of certain courses if the course isn’t offered in the current semester----

Go
CREATE PROC [Procedures_AdminDeleteSlots]
@current_semester varchar(40)

As

Delete from Slot where Slot.course_id NOT IN (Select Slot.course_id from Slot inner join Course_Semester on Slot.course_id = Course_Semester.course_id
and Course_Semester.semester_code = @current_semester)
Go


--/////////////////////////////////////////////////////////////////////////////////////
--/////////////////////////////////As an Advisor////////////////////////////////////////////////////

----------------------------------------------------------------------------
-----------------------------AdvisorLogin---------------------------------
/*
login using my username and password. 
Name: AdvisorLogin
Input: ID int, password varchar(20) 
Output: Success bit
Type: Function
*/
Go
CREATE FUNCTION [FN_AdvisorLogin]
(@advisor_Id int, @password varchar(40))     --Define Function Input
Returns bit   	  --Define Function Output

AS
Begin
Declare
@success bit,
@pass varchar(40)

if(@advisor_Id is null or @password is null)
return 0

select @pass = password from Advisor where advisor_id = @advisor_Id
if(@pass = @password)
set @success = 1 
else 
set @success = 0

Return @success
END
Go
----------------------------------------------------------------------------------------
--------------------------------Insert graduation plan ------------------------------------------------------

Go
CREATE PROC [Procedures_AdvisorCreateGP]

@Semester_code varchar(40), 
@expected_graduation_date date, 
@sem_credit_hours int,
@advisor_id int,
@student_id int

AS
declare @student_acquired int 
Select @student_acquired  =  Student.acquired_hours from  Student where Student.student_id = @student_id
If(@student_acquired >=157)
insert into Graduation_Plan values (@Semester_code, @sem_credit_hours, @expected_graduation_date, @advisor_id, @student_id) 
GO

---------------------------------------------------------------------
------------------------Add course inside certain plan for certin student ---------------------------------
Go
CREATE PROC [Procedures_AdvisorAddCourseGP]
 
@student_id int,
@Semester_code varchar(40),
@course_name varchar(40)
AS
declare 
@graduation_plan int,
@course_id int

select @graduation_plan = Graduation_Plan.plan_id from Graduation_Plan where Graduation_Plan.student_id = @student_id and Graduation_Plan.semester_code = @Semester_code
select @course_id = Course.course_id from Course where Course.name = @course_name

insert into GradPlan_Course values (@graduation_plan, @Semester_code, @course_id) 

GO

------------------------------------------------------------------------------
--------------------Update expected graduation date in a certain graduation plan----------------------
Go
CREATE PROC [Procedures_AdvisorUpdateGP]
@expected_grad_date date,
@studentID int

As 
Update Graduation_Plan
set expected_grad_date = @expected_grad_date
where student_id = @studentID
Go

-------------------------------------------------------------------
--------------------Delete certain course from certain graduation plan of certain student ------------

Go
Create PROC [Procedures_AdvisorDeleteFromGP]
@studentID int,
@sem_code varchar(40),
@courseID int


As
declare @gp_plan int
select @gp_plan = Graduation_Plan.plan_id from Graduation_Plan where Graduation_Plan.student_id = @studentID and Graduation_Plan.semester_code = @sem_code

delete from GradPlan_Course
where GradPlan_Course.plan_id = @gp_plan and GradPlan_Course.course_id= @courseID and GradPlan_Course.semester_code = @sem_code

Go
-----------------------------------------------------------------------------------------
------------------------retrieve requests for certain advisor---------------------------------

CREATE FUNCTION [FN_Advisors_Requests]
     (@advisor_id int)
   RETURNs table
   AS
   RETURN (SELECT R.* FROM Request R inner join Advisor A 
   on R.advisor_id = A.advisor_id and A.advisor_id = @advisor_id)
   
------------------------Accept/Reject Credit hours request ---------------------------------
--drop PROC Procedures_AdvisorApproveRejectCHRequest
Go
Create PROC [Procedures_AdvisorApproveRejectCHRequest]
@requestID int,
@current_sem_code varchar(40)

As 

declare 
@requestCreditHours int,
@type varchar(40),  -- 0 ch
@studentGPA decimal(10,2),
@studentCH  int,
@stat varchar(40),
@new_studentCH int,
@studentid int,
@paymentid int,
@nextinstalldate date

select @studentid = Request.student_id from Request where Request.request_id = @requestID
select @studentGPA = Student.gpa from Student where Student.student_id = @studentid
select @studentCH = Student.assigned_hours from Student where Student.student_id = @studentid
select @requestCreditHours = Request.credit_hours from Request where Request.request_id = @requestID
select @type = Request.type from Request where Request.request_id = @requestID
set @new_studentCH = @studentCH

if @type like '%credit%' and @studentCH + @requestCreditHours<=34 and @studentGPA < 3.7 and @requestCreditHours<=3
Begin
set @stat = 'Accept' 
set @new_studentCH = @studentCH + @requestCreditHours

update Student
set student.assigned_hours = @new_studentCH
where Student.student_id = @studentid

select @paymentid = payment.payment_id from Payment where payment.student_id = @studentid and semester_code = @current_sem_code
Select Top 1 @nextinstalldate =  Installment.startdate from Installment where installment.status = 'notPaid' order by Installment.startdate ASC 

update installment
set installment.amount = installment.amount + (1000*@requestCreditHours)
where payment_id = @paymentid and Installment.startdate =@nextinstalldate

update Payment
set payment.amount = payment.amount + (1000*@requestCreditHours)
where payment_id = @paymentid
END
Else
set @stat = 'Reject'

update Request
set request.status = @stat
where Request.request_id = @requestID




Go
----------------------------AdvisorViewAssignedStudents----------------------------------------------------------------
/*
View all students assigned to him/her from a certain major along with their current course
{current courses = courses taken by the student in the current semester}
Type: Stored Procedure
Name: AdvisorViewAssignedStudents
Input: AdvisorID int and major varchar(40)
Output: Table 
*/
Go
--drop proc Procedures_AdvisorViewAssignedStudents;
Create PROC [Procedures_AdvisorViewAssignedStudents]
@AdvisorID int,
@major varchar(40)
As

Select Student.student_id, Student.f_name+' ' + Student.l_name as Student_name, Student.major, Course.name as Course_name
from Student left outer join Student_Instructor_Course_take on Student.student_id = Student_Instructor_Course_take.student_id
left outer join Course on Student_Instructor_Course_take.course_id = Course.course_id
where Student.advisor_id = @AdvisorID and Student.major = @major
Go
-------------------------------------------------------------------------------------
------------------------FUNCTION [FN_FN_check_prerequiste]-------------------------
Go
CREATE FUNCTION [FN_check_prerequiste]
(@studentid int, @requestcourse_id varchar(40))
returns bit
Begin
declare 
@success bit,
@student_id_target int

set @student_id_target = -1

Select @student_id_target = Student.student_id
from Student 
where Student.student_id = @studentid AND  Student.student_id In(
SELECT Student.student_id
FROM Student
WHERE NOT EXISTS (
    (SELECT PreqCourse_course.prerequisite_course_id
    FROM PreqCourse_course
    WHERE PreqCourse_course.course_id = @requestcourse_id)

    EXCEPT

    (SELECT Student_Instructor_Course_take.course_id
    FROM Student_Instructor_Course_take
    INNER JOIN PreqCourse_course ON Student_Instructor_Course_take.course_id = PreqCourse_course.prerequisite_course_id
    where Student_Instructor_Course_take.student_id =  Student.student_id)
)
)
if @student_id_target = -1
set @success = 0
else
set @success = 1
return @success
End



-------------------------------Approve/Reject courses request based on the student’s assigned credit hours -------------------------------------------------------
/*
Name: AdvisorApproveRejectCourseRequest
Input: RequestID int
Output: nothing
*/

Go
Create PROC [Procedures_AdvisorApproveRejectCourseRequest]
@requestID int,
@current_semester_code varchar(40)

As 

declare 
@type varchar(40),  -- 1 course
@studentah  int,
@status varchar(40),
@studentid int,
@requestcourse_id int,
@course_hours int,
@new_studentah int,
@isoffered bit,
@prerequiste bit,
@instructor_id int

select @studentid = Request.student_id from Request where Request.request_id = @requestID
select @studentah = Student.assigned_hours from Student where Student.student_id = @studentid
select @requestcourse_id = Request.course_id from Request where Request.request_id = @requestID
select @type = Request.type from Request where Request.request_id = @requestID
select @course_hours = Course.credit_hours from course where Course.course_id = @requestcourse_id
select @isoffered = Course.is_offered from course where Course.course_id = @requestcourse_id

set @prerequiste = dbo.FN_check_prerequiste(@studentid,@requestcourse_id)
set @new_studentah = @studentah

if @type like '%course%' and @studentah >= @course_hours and @isoffered = 1 and @prerequiste = 1
Begin
set @status = 'Accept' 
set @new_studentah = @new_studentah - @course_hours
insert into Student_Instructor_Course_take (student_id, course_id,semester_code) values (@studentid,@requestcourse_id,@current_semester_code)
select *
from Student_Instructor_Course_take
END
Else
set @status = 'Reject'

update Request
set request.status = @status
where Request.request_id = @requestID

update Student
set student.assigned_hours = @new_studentah
where Student.student_id = @studentid
Go

------------------------------------------------------------------------------
---------View pending requests of his/her students--------------------------------------------------
/*View pending requests of his/her students
Name:AdvisorViewPendingRequests
Input: Advisor ID int {this advisor should be the one advising the student}
Output: Table of pending requests
*/
Go
Create PROC [Procedures_AdvisorViewPendingRequests]
@Advisor_ID int 
As 
select *
from Request where Request.advisor_id = @Advisor_ID and Request.status = 'Pending'
Go


--//////////////////////////////////////////////////////////////////////////////////////////////////////
--/////////////////////As a Student I should be able to /////////////////////////////////////////////////////////////////////////

------------login using my username and password. {refer to un/block students in the admin section-------- 
Go
CREATE FUNCTION [FN_StudentLogin]
(@Student_id int, @password varchar(40))     --Define Function Input
Returns bit   	  --Define Function Output

AS
Begin
Declare
@success bit,
@pass varchar(40)

if(@Student_id is null or @password is null)
return 0

select @pass = password from Student where Student.student_id = @Student_id and Student.financial_status = 1
if(@pass = @password)
set @success = 1 
else 
set @success = 0

Return @success
END
Go
----------------------------------------------------------------------------------------
--------------------------Student mobile number(s)---------------------------------------------------------------

Go
Create PROC [Procedures_StudentaddMobile]
@StudentID int, @mobile_number varchar(40)
As
Insert into Student_Phone values (@StudentID, @mobile_number)
Go

-----------------------------------------------------------------------------------
-------------------------- available courses in the current semester----------------------------
--Output: Table of available courses within the student’s current semester
Go
CREATE FUNCTION [FN_SemsterAvailableCourses]
     (@semstercode varchar(40))
   RETURNs table
   AS
   RETURN (
   Select Course.name, Course.course_id 
   from Course inner join Course_Semester 
   on Course.course_id = Course_Semester.course_id and Course_Semester.semester_code = @semstercode
   )

---------------------------------------------------------------------------
-----------------------------Sending course request-----------------

Go
Create PROC [Procedures_StudentSendingCourseRequest]
@courseID int, 
@StudentID int, 
@type varchar(40), 
@comment varchar(40)
AS
declare
@advisorID int

Select @advisorID = Student.advisor_id from student where Student.student_id = @StudentID

Insert into Request (type,comment,course_id, student_id,advisor_id) values (@type, @comment, @courseID, @StudentID, @advisorID)
Go
-----------------------------------------------------------------------------------------------------
-----------------------------Sending extra credit hours request-----------------

Go
Create PROC [Procedures_StudentSendingCHRequest]
@StudentID int, 
@credit_hours int, 
@type varchar(40), 
@comment varchar(40)
AS
declare
@advisorID int

Select @advisorID = Student.advisor_id from student where Student.student_id = @StudentID

Insert into Request (type,comment,credit_hours, student_id,advisor_id) values (@type, @comment, @credit_hours, @StudentID, @advisorID)
Go
--------------------------------------------------------------------
---------------------View graduation plan of certin student with the assigned courses --------------------------------------------------

--Output:  Complete Graduation plan details

CREATE FUNCTION [FN_StudentViewGP]
     (@student_ID int)
   RETURNs table
   AS
   RETURN (
   Select Student.f_name +' '+ Student.l_name as Student_name , Graduation_Plan.*, GradPlan_Course.course_id, Course.name
   from Student inner join Graduation_Plan on Student.student_id = Graduation_Plan.student_id and Student.student_id = @student_ID
   inner join GradPlan_Course on Graduation_Plan.plan_id = GradPlan_Course.plan_id and Graduation_Plan.semester_code = GradPlan_Course.semester_code
   inner join Course on Course.course_id = GradPlan_Course.course_id
   )
--------------------------------------------------------------------
---------------------View first upcoming installment deadline --------------------------------------------------
--Output: deadline date of first upcoming installment
go 
CREATE FUNCTION [FN_StudentUpcoming_installment]
     (@student_ID int)
   RETURNs date
  Begin
  declare @installdeadline date 
  Select top 1 @installdeadline = Installment.deadline from Installment inner join Payment
  on Payment.payment_id = Installment.payment_id and Payment.student_id = @student_ID and Installment.status='notpaid'
  where Installment.deadline > CURRENT_TIMESTAMP
 
  Order by Installment.deadline ASC

  return @installdeadline
  End

  -------------------------------------------------------------
  -----------View slot of certain course that is taught by a certain instructor--------------------

--Output: table of slots details (ID,location,time,day) with course name and Instructor name
go
CREATE FUNCTION [FN_StudentViewSlot]
     (@CourseID int, @InstructorID int)
   RETURNs table
   AS
   RETURN ( Select * from Courses_Slots_Instructor 
   where Courses_Slots_Instructor.course_id = @CourseID and Courses_Slots_Instructor.instructor_id = @InstructorID
   )
--------------------------------------------------------------------------------------------------
----------Register for first makeup exam {refer to eligibility section (2.4.1) in the description}-------

Go
Create PROC [Procedures_StudentRegisterFirstMakeup]
@StudentID int, @courseID int, @studentCurr_sem varchar(40)
AS
declare 
@exam_id int,
@instructor_id int


If(not exists( Select * from Student_Instructor_Course_take where Student_Instructor_Course_take.student_id = @StudentID and Student_Instructor_Course_take.course_id
= @courseID and Student_Instructor_Course_take.exam_type in ('First_makeup','Second_makeup')))
begin 
If(exists(Select * from Student_Instructor_Course_take where Student_Instructor_Course_take.student_id = @StudentID and Student_Instructor_Course_take.course_id
= @courseID  and Student_Instructor_Course_take.exam_type = 'Normal' and Student_Instructor_Course_take.grade in ('F','FF',null)))
begin 
Select @exam_id = MakeUp_Exam.exam_id from MakeUp_Exam where MakeUp_Exam.course_id = @courseID
Select @instructor_id = Student_Instructor_Course_take.instructor_id from Student_Instructor_Course_take 
where Student_Instructor_Course_take.student_id = @StudentID and Student_Instructor_Course_take.course_id = @courseID 
insert into Exam_Student values (@exam_id, @StudentID, @courseID)
Update Student_Instructor_Course_take 
Set exam_type = 'first_makeup' , grade= null
where  student_id = @StudentID and course_id = @courseID and
 semester_code = @studentCurr_sem
end
end
Go
---------------------------------------------------------------------------------
-----------------Second makeup Eligibility Check {refer to eligibility section (2.4.1) in the description}

CREATE FUNCTION [FN_SemesterCodeCheck]
     (@SemesterCode varchar(40))
   RETURNs varchar(40)
   begin
   declare @output varchar(40)
if @SemesterCode like '%R1%' or  @SemesterCode like '%W%'
set @output = 'Odd'
else 
set @output =  'Even'
return @output
end

--Output: Eligible bit {0 → not eligible, 1 → eligible }
go
CREATE FUNCTION [FN_StudentCheckSMEligibility]
     (@CourseID int, @StudentID int)
   RETURNs bit
Begin
declare 
@eligable bit,
@countOfRows int,
@Student_semester int,
@course_semester varchar(40),
@StudentSemesterCode varchar(40),
@failedGradesCount int

select @countOfRows = COUNT(*) 
from Student_Instructor_Course_take where Student_Instructor_Course_take.exam_type In ( 'First_Makeup', 'Normal') and
Student_Instructor_Course_take.grade in ('F','FF',NULL) 
AND Student_Instructor_Course_take.course_id = @CourseID
AND Student_Instructor_Course_take.student_id = @StudentID

if @countOfRows = 0
return 0

else

begin
select @Student_semester = Student.semester from Student where  Student.student_id = @StudentID

if (@Student_semester % 2) = 0
set @StudentSemesterCode = 'Even'
Else 
set @StudentSemesterCode = 'Odd'

select @failedGradesCount = count(*)
from Student_Instructor_Course_take
where dbo.FN_SemesterCodeCheck(Student_Instructor_Course_take.semester_code) = @StudentSemesterCode and 
Student_Instructor_Course_take.student_id = @StudentID and Student_Instructor_Course_take.grade in ('F','FF')
group by Student_Instructor_Course_take.grade

end

if @failedGradesCount <=2
begin
set @eligable = 1
end
else
set @eligable = 0

return @eligable
END

-------------------------------------------
----------Register for second makeup exam {refer to eligibility section (2.4.1) in the description}-------
Go
Create PROC [Procedures_StudentRegisterSecondMakeup]
@StudentID int, @courseID int, @studentCurr_sem varchar(40)
AS
declare 
@exam_id int,
@instructor_id int
if dbo.FN_StudentCheckSMEligibility(@StudentID, @courseID) = 0
Print 'Your are not eligible to take 2nd makeup'

else
begin
Select @exam_id = MakeUp_Exam.exam_id from MakeUp_Exam where MakeUp_Exam.course_id = @courseID
Select @instructor_id = Student_Instructor_Course_take.instructor_id from Student_Instructor_Course_take 
where Student_Instructor_Course_take.student_id = @StudentID and Student_Instructor_Course_take.course_id = @courseID
insert into Exam_Student values (@exam_id, @StudentID, @courseID)
Update Student_Instructor_Course_take 
Set exam_type = 'Second_makeup' , grade= null
where  student_id = @StudentID and course_id = @courseID and
 semester_code = @studentCurr_sem
end
Go

--------------------------------------------------------------------------------------
----------Function return table that have the courses ids that the student took and failed in them-------

CREATE FUNCTION [FN_StudentFailedAndNotEligibleCourse]
     (@StudentID int, @current_semester_code varchar(40))
   RETURNs table
   AS
   RETURN ( select Student_Instructor_Course_take.course_id
    from Student_Instructor_Course_take inner join Course_Semester on Student_Instructor_Course_take.course_id = Course_Semester.course_id
    where Student_Instructor_Course_take.student_id = @StudentID and 
    Student_Instructor_Course_take.grade in ('F','FF') and
    dbo.FN_StudentCheckSMEligibility(@StudentID,Student_Instructor_Course_take .course_id) = 0 
    and Course_Semester.semester_code = @current_semester_code
    )
---------------------------------------------------------------------------------------------
-----------------[FN_StudentUnattendedCourses]----------------------------------------------

go
CREATE FUNCTION [FN_StudentUnattendedCourses]
     (@StudentID int,@current_semester_code varchar(40),@student_semester int)
   RETURNs table
   AS
   RETURN ( select Course_Semester.course_id
from Course_Semester inner join Course on Course_Semester.course_id = Course.course_id 
inner join Student on Student.major = Course.major
where  Student.student_id= @StudentID and   Course_Semester.semester_code = @current_semester_code and course.semester < @student_semester and Course_Semester.course_id Not In (
select Student_Instructor_Course_take.course_id
from Student_Instructor_Course_take
where Student_Instructor_Course_take.student_id = @StudentID
   ) or Course_Semester.course_id
   In (select Student_Instructor_Course_take.course_id
from Student_Instructor_Course_take
where Student_Instructor_Course_take.student_id = @StudentID and Student_Instructor_Course_take.grade = 'FA' ))
------------------------------------------------------------------------------------------
----------View required courses  {refer to eligibility section (2.2) in the description}-------
go
Go
Create PROC [Procedures_ViewRequiredCourses]
@StudentID int,
@current_semester_code varchar(40)
As
declare @student_semester int

select @student_semester = Student.semester FROM Student where Student.student_id = @StudentID
select Course.name, Course.course_id
from Course 
where Course.course_id in (select * from dbo.FN_StudentFailedAndNotEligibleCourse(@StudentID,@current_semester_code)) 
or Course.course_id in (select * from dbo.FN_StudentUnattendedCourses(@StudentID,@current_semester_code,@student_semester))
GO

------------------------------------------------------------------------------------------
----------View optional courses  {refer to eligibility section (2.2) in the description}-------
Go
Create PROC [Procedures_ViewOptionalCourse]
@StudentID int,
@current_semester_code varchar(40)
As
declare @student_semester int
select @student_semester = Student.semester FROM Student where Student.student_id = @StudentID

select Course_Semester.course_id, Course.name
from Course_Semester inner join Course on Course_Semester.course_id = Course.course_id
where Course_Semester.semester_code = @current_semester_code AND  (Course.semester >= @student_semester and dbo.FN_check_prerequiste(@StudentID, Course_Semester.course_id) = 1 )
GO 
------------------------------------------------------------------------------------------
----------View missing/remaining courses to specific student-------
Go

Create PROC [Procedures_ViewMS]
@StudentID int
As
declare @student_major varchar(40)
Select @student_major = major from Student where student_id = @StudentID 
select Course.course_id, Course.name
from Course 
where  Course.major = @student_major and   Course.course_id not in (select Student_Instructor_Course_take.course_id
from Student_Instructor_Course_take
where Student_Instructor_Course_take.student_id = @StudentID) OR course.course_id in (select Student_Instructor_Course_take.course_id
from Student_Instructor_Course_take
where Student_Instructor_Course_take.student_id = @StudentID AND grade in ('F','FF'))
GO


------------------------------------------------------------------------------------------
----------choose instructor for certain course you already choose-------

Go
Create PROC [Procedures_Chooseinstructor]
@StudentID int,
@instrucorID int,
@CourseID int,
@current_semester_code varchar(40)
AS
update Student_Instructor_Course_take
set Student_Instructor_Course_take.instructor_id = @instrucorID
where Student_Instructor_Course_take.student_id = @StudentID and Student_Instructor_Course_take.course_id = @CourseID 
and Student_Instructor_Course_take.semester_code = @current_semester_code 
GO


--//////////////////////////////////////////////////////////////////////////////////////////////
--EXEC Procedures_CreateAllTables




