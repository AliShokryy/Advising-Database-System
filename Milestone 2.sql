CREATE DATABASE Advising_Team_6

GO
CREATE PROCEDURE CreateAllTables
AS
	CREATE TABLE Student(
		student_id INT IDENTITY,
		f_name VARCHAR(40),
		l_name VARCHAR(40),
		gpa REAL,
		faculty VARCHAR(40),
		email VARCHAR(40),
		major VARCHAR(40),
		password VARCHAR(40),
		financial_status BIT,
		semester INT,
		acquired_hours INT,
		assigned_hours INT,
		advisor_id INT
		);

	CREATE TABLE Student_Phone(
		student_id INT,
		phone_number VARCHAR(40),
		FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE,
		PRIMARY KEY( student_id , phone_number )
		);