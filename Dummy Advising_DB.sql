INSERT INTO Advisor (name, email, office, password) VALUES
('John Doe', 'john@example.com', 'Office A', 'password1'),
('Jane Smith', 'jane@example.com', 'Office B', 'password2'),
('Alice Johnson', 'alice@example.com', 'Office C', 'password3'),
('Bob Williams', 'bob@example.com', 'Office D', 'password4'),
('Eva Brown', 'eva@example.com', 'Office E', 'password5'),
('Mike Davis', 'mike@example.com', 'Office F', 'password6'),
('Chris Johnson', NULL, 'Office C', 'advisor789'),
(NULL, NULL, NULL, NULL),
('Sara Miller', 'sara@example.com', 'Office D', 'advisor987');

INSERT INTO Student (f_name, l_name, gpa, faculty, email, major, password, financial_status, semester, acquired_hours, assigned_hours, advisor_id) VALUES
('Emma', 'Johnson', 3.75, 'Science', 'emma@example.com', 'Biology', 'password1', 1, 3, 60, 15, 1),
('James', 'Smith', 3.50, 'Engineering', 'james@example.com', 'Mechanical Engineering', 'password2', 0, 4, 75, 18, 2),
('Olivia', 'Williams', 3.90, 'Arts', 'olivia@example.com', 'History', 'password3', 1, 2, 45, 12, 3),
('William', 'Brown', 3.25, 'Business', 'william@example.com', 'Finance', 'password4', 0, 3, 65, 20, 4),
('Sophia', 'Jones', 3.80, 'Science', 'sophia@example.com', 'Chemistry', 'password5', 1, 4, 80, 22, 5),
('Liam', 'Garcia', 3.60, 'Engineering', 'liam@example.com', 'Computer Science', 'password6', 0, 2, 50, 16, 6),
('Alice', 'Smith', 3.6, 'Science', 'alice@example.com', 'Biology', 'student123', 1, 5, 50, 20, 1),
('Bob', 'Johnson', 3.2, 'Engineering', 'bob@example.com', 'Mechanical Engineering', 'student456', NULL, 70, 25, 2),
('Charlie', 'Garcia', 3.8, 'Arts', 'charlie@example.com', 'History', 'student789', 1, NULL, NULL, 3),
('David', 'Brown', 3.0, 'Business', 'david@example.com', 'Finance', 'studentabc', 0, 3, 30, 15, NULL),
('Eva', 'Davis', 3.5, 'Science', 'eva@example.com', 'Chemistry', 'studentdef', 1, 8, 60, NULL, 2),
('Frank', 'Williams', NULL, 'Engineering', 'frank@example.com', 'Computer Science', 'studentghi', 0, 6, NULL, 25, 3),
(NULL, 'Williams', NULL, 'Engineering', 'frank@example.com', 'Computer Science', 'studentghi', 0, 6, NULL, 25, 3);

-- Inserting records into Student_Phone
INSERT INTO Student_Phone (student_id, phone_number) VALUES
(1, '123-456-7890'),
(2, '987-654-3210'),
(3, '555-123-4567'),
(4, '777-888-9999'),
(5, '444-555-6666'),
(6, '111-222-3333'),
(3, NULL),
(6, NULL),
(NULL, NULL);


-- Inserting dummy data into Course table
INSERT INTO Course (name, major, is_offered, credit_hours, semester) VALUES
('Introduction to Biology', 'Biology', 1, 4, 1),
('Mechanics 101', 'Mechanical Engineering', 1, 3, 2),
('European History', 'History', 1, 3, 3),
('Financial Accounting', 'Finance', 1, 4, 2),
('Organic Chemistry', 'Chemistry', 1, 4, 4),
('Algorithm Design', 'Computer Science', 1, 3, 3),
('Algorithm Analysis', 'Computer Science', NULL, NULL, 3);


-- Inserting records into PreqCourse_course
INSERT INTO PreqCourse_course (prerequisite_course_id, course_id) VALUES
(1, 2),  -- Course ID 1 is a prerequisite for Course ID 2
(3, 4),  -- Course ID 3 is a prerequisite for Course ID 4
(2, 5),  -- Course ID 2 is a prerequisite for Course ID 5
(4, 6),  -- Course ID 4 is a prerequisite for Course ID 6
(1, 3),  -- Course ID 1 is a prerequisite for Course ID 3
(5, 6),
(NULL, 3),
(4, NULL); -- Course ID 5 is a prerequisite for Course ID 6


INSERT INTO Instructor (name, email, faculty, office) VALUES
('Professor Smith', 'smith@example.com', 'Science', 'Office A'),
('Dr. Johnson', 'johnson@example.com', 'Engineering', 'Office B'),
('Professor Williams', 'williams@example.com', 'Arts', 'Office C'),
('Dr. Brown', 'brown@example.com', 'Business', 'Office D'),
('Professor Garcia', 'garcia@example.com', 'Science', 'Office E'),
('Dr. Davis', 'davis@example.com', 'Engineering', 'Office F'),
('Professor Grace', NULL, 'Arts', 'Office Z'),
('Dr. Emily', NULL, 'Engineering', 'Office Y'),
('Professor Grace', 'grace@example.com', 'Arts', 'Office Z'),
(NULL, 'unknown@example.com', NULL, 'Office Q');

-- Inserting records into Instructor_Course
INSERT INTO Instructor_Course (course_id, instructor_id) VALUES
(1, 1),  -- Instructor ID 1 is assigned to Course ID 1
(2, 2),  -- Instructor ID 2 is assigned to Course ID 2
(3, 3),  -- Instructor ID 3 is assigned to Course ID 3
(4, 4),  -- Instructor ID 4 is assigned to Course ID 4
(5, 5),  -- Instructor ID 5 is assigned to Course ID 5
(6, 6),
(4, 1),
(5, 2),
(6, 3),
(3, NULL),
(NULL, 4); -- Instructor ID 6 is assigned to Course ID 6


-- Inserting records into Student_Instructor_Course_Take
INSERT INTO Student_Instructor_Course_Take (student_id, course_id, instructor_id, semester_code, exam_type, grade) VALUES
(1, 1, 1, '202301', 'Normal', 'A'),
(2, 2, 2, '202302', 'Normal', 'B'),
(3, 3, 3, '202303', 'Normal', 'B+'),
(4, 4, 4, '202301', 'Normal', 'A-'),
(5, 5, 5, '202302', 'Normal', 'B'),
(6, 6, 6, '202303', 'Normal', 'C'),
(2, 2, 2, NULL, 'First_makeup', 'B'),
(3, NULL, 3, '202303', NULL, 'C'),
(NULL, 4, NULL, '202401', 'Second_makeup', NULL),
(5, 5, 3, NULL, NULL, 'B+'),
(NULL, NULL, NULL, '202402', 'Normal', 'A-');


-- Inserting records into Slot
INSERT INTO Slot (day, time, location, course_id, instructor_id) VALUES
('Monday', '10:00 AM', 'Room A', 1, 1), -- Course ID 1 instructed by Instructor ID 1 on Monday at 10:00 AM in Room A
('Tuesday', '11:30 AM', 'Room B', 2, 2), -- Course ID 2 instructed by Instructor ID 2 on Tuesday at 11:30 AM in Room B
('Wednesday', '1:00 PM', 'Room C', 3, 3), -- Course ID 3 instructed by Instructor ID 3 on Wednesday at 1:00 PM in Room C
('Thursday', '2:30 PM', 'Room D', 4, 4), -- Course ID 4 instructed by Instructor ID 4 on Thursday at 2:30 PM in Room D
('Friday', '4:00 PM', 'Room E', 5, 5), -- Course ID 5 instructed by Instructor ID 5 on Friday at 4:00 PM in Room E
('Saturday', '9:00 AM', 'Room F', 6, 6),-- Course ID 6 instructed by Instructor ID 6 on Saturday at 9:00 AM in Room F
('Wednesday', NULL, 'Room C', 3, 3),
('Thursday', '2:30 PM', NULL, 4, 1),
('Friday', '4:00 PM', 'Room E', NULL, 2),
(NULL, '9:00 AM', 'Room F', 6, 3); 


-- Inserting records into Semester table
INSERT INTO Semester (semester_code, start_date, end_date) VALUES
('202301', '2023-01-15', '2023-05-15'), -- Spring 2023 semester
('202302', '2023-06-01', '2023-09-30'), -- Summer 2023 semester
('202303', '2023-10-15', '2024-01-31'), -- Fall 2023 semester
('202401', '2024-01-15', '2024-05-15'), -- Spring 2024 semester
('202402', '2024-06-01', '2024-09-30'), -- Summer 2024 semester
('202403', '2024-10-15', '2025-01-31'),-- Fall 2024 semester
('202302', NULL, '2023-09-30'),
('202303', '2023-10-15', '2024-01-31'),
(NULL, '2024-01-15', NULL),
('202402', '2024-06-01', '2024-09-30'),
('202403', NULL, NULL); 


-- Inserting records into Course_Semester
INSERT INTO Course_Semester (course_id, semester_code) VALUES
(1, '202301'), -- Course ID 1 associated with Spring 2023 semester
(2, '202302'), -- Course ID 2 associated with Summer 2023 semester
(3, '202303'), -- Course ID 3 associated with Fall 2023 semester
(4, '202401'), -- Course ID 4 associated with Spring 2024 semester
(5, '202402'), -- Course ID 5 associated with Summer 2024 semester
(6, '202403'),-- Course ID 6 associated with Fall 2024 semester
(4, NULL),
(NULL, '202402'); 


-- Inserting records into Graduation_Plan
INSERT INTO Graduation_Plan (semester_code, semester_credit_hours, expected_grad_semester, advisor_id, student_id) VALUES
('202301', 15, '202401', 1, 1), -- Student ID 1's graduation plan for Spring 2023 to Spring 2024, advised by Advisor ID 1
('202302', 18, '202402', 2, 2), -- Student ID 2's graduation plan for Summer 2023 to Summer 2024, advised by Advisor ID 2
('202303', 12, '202403', 3, 3), -- Student ID 3's graduation plan for Fall 2023 to Fall 2024, advised by Advisor ID 3
('202401', 16, '202402', 4, 4), -- Student ID 4's graduation plan for Spring 2024 to Summer 2024, advised by Advisor ID 4
('202402', 14, '202403', 5, 5), -- Student ID 5's graduation plan for Summer 2024 to Fall 2024, advised by Advisor ID 5
('202403', 13, '202404', 6, 6),-- Student ID 6's graduation plan for Fall 2024 to Spring 2025, advised by Advisor ID 6
('202302', 18, NULL, 2, 2),
('202303', 12, '202403', 3, NULL),
('202401', 16, '202402', NULL, 4),
(NULL, NULL, '202403', 5, 5),
('202403', 13, '202404', 6, NULL); 


-- Inserting records into GradPlan_Course
INSERT INTO GradPlan_Course (plan_id, semester_code, course_id) VALUES
(1, '202301', 1), -- Course ID 1 in the Graduation Plan ID 1 for Spring 2023
(2, '202302', 2), -- Course ID 2 in the Graduation Plan ID 2 for Summer 2023
(3, '202303', 3), -- Course ID 3 in the Graduation Plan ID 3 for Fall 2023
(4, '202401', 4), -- Course ID 4 in the Graduation Plan ID 4 for Spring 2024
(5, '202402', 5), -- Course ID 5 in the Graduation Plan ID 5 for Summer 2024
(6, '202403', 6), -- Course ID 6 in the Graduation Plan ID 6 for Fall 2024
(3, '202303', NULL),
(4, NULL, 4),
(NULL, '202402', 5);

-- Inserting records into Request
INSERT INTO Request (type, comment, status, credit_hours, student_id, advisor_id, course_id) VALUES
('Add', 'Request to add a course', 'pending', 3, 1, 1, 1), -- Student ID 1 requesting to add Course ID 1
('Drop', 'Request to drop a course', 'pending', 4, 2, 2, 2), -- Student ID 2 requesting to drop Course ID 2
('Change', 'Request to change a course', 'pending', 3, 3, 3, 3), -- Student ID 3 requesting to change Course ID 3
('Add', 'Request to add a course', 'pending', 4, 4, 4, 4), -- Student ID 4 requesting to add Course ID 4
('Drop', 'Request to drop a course', 'pending', 3, 5, 5, 5), -- Student ID 5 requesting to drop Course ID 5
('Change', 'Request to change a course', 'pending', 4, 6, 6, 6), -- Student ID 6 requesting to change Course ID 6
('Add', NULL, 'pending', 3, 1, 1, 1),
(NULL, 'Request to drop a course', 'pending', 4, 2, NULL, 2),
('Change', 'Request to change a course', 'pending', NULL, 3, 3, NULL),
('Add', 'Request to add a course', NULL, 4, NULL, 4, 4),
('Drop', 'Request to drop a course', 'pending', 3, 5, 5, NULL),
('Change', 'Request to change a course', 'pending', 4, NULL, 6, 6);

-- Inserting records into MakeUp_Exam
INSERT INTO MakeUp_Exam (date, type, course_id) VALUES
('2023-05-01', 'First_makeup', 1), -- First makeup exam for Course ID 1 on May 1, 2023
('2023-07-15', 'Second_makeup', 2), -- Second makeup exam for Course ID 2 on July 15, 2023
('2023-10-20', 'First_makeup', 3), -- First makeup exam for Course ID 3 on October 20, 2023
('2024-03-05', 'Second_makeup', 4), -- Second makeup exam for Course ID 4 on March 5, 2024
('2024-06-10', 'First_makeup', 5), -- First makeup exam for Course ID 5 on June 10, 2024
('2024-09-15', 'Second_makeup', 6), -- Second makeup exam for Course ID 6 on September 15, 2024
('2023-05-01', NULL, 1),
('2023-07-15', 'Second_makeup', NULL),
(NULL, 'First_makeup', 3),
('2024-03-05', 'Second_makeup', NULL),
('2024-06-10', NULL, 5),
(NULL, NULL, NULL);

-- Inserting records into Exam_Student
INSERT INTO Exam_Student (exam_id, student_id, course_id) VALUES
(1, 1, 1), -- Student ID 1 taking the makeup exam ID 1 for Course ID 1
(2, 2, 2), -- Student ID 2 taking the makeup exam ID 2 for Course ID 2
(3, 3, 3), -- Student ID 3 taking the makeup exam ID 3 for Course ID 3
(4, 4, 4), -- Student ID 4 taking the makeup exam ID 4 for Course ID 4
(5, 5, 5), -- Student ID 5 taking the makeup exam ID 5 for Course ID 5
(6, 6, 6), -- Student ID 6 taking the makeup exam ID 6 for Course ID 6
(NULL, 1, 1),
(2, NULL, 2),
(3, 3, NULL),
(4, NULL, 4),
(NULL, 5, 5),
(6, NULL, NULL);

-- Inserting records into Payment
INSERT INTO Payment (amount, deadline, n_installments, status, fund_percentage, start_date, student_id, semester_code) VALUES
(500, '2023-05-15', 3, 'notPaid', 50.00, '2023-03-01', 1, '202301'), -- Student ID 1 payment for Spring 2023
(750, '2023-07-30', 2, 'notPaid', 30.00, '2023-06-01', 2, '202302'), -- Student ID 2 payment for Summer 2023
(600, '2023-11-30', 4, 'notPaid', 70.00, '2023-09-01', 3, '202303'), -- Student ID 3 payment for Fall 2023
(800, '2024-05-15', 2, 'notPaid', 40.00, '2024-03-01', 4, '202401'), -- Student ID 4 payment for Spring 2024
(700, '2024-08-30', 3, 'notPaid', 60.00, '2024-06-01', 5, '202402'), -- Student ID 5 payment for Summer 2024
(900, '2024-12-30', 2, 'notPaid', 80.00, '2024-10-01', 6, '202403'), -- Student ID 6 payment for Fall 2024
(500, '2023-05-15', NULL, 'notPaid', 50.00, '2023-03-01', 1, '202301'),
(NULL, '2023-07-30', 2, 'notPaid', 30.00, '2023-06-01', 2, NULL),
(600, '2023-11-30', NULL, NULL, NULL, '2023-09-01', NULL, '202303'),
(NULL, '2024-05-15', NULL, 'notPaid', NULL, NULL, 4, NULL),
(700, NULL, NULL, 'notPaid', 60.00, '2024-06-01', 5, '202402'),
(900, '2024-12-30', NULL, NULL, 80.00, NULL, 6, NULL);
-----------------------------------------------

