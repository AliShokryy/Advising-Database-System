using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Data;

namespace Team6_Advising.Pages.Admin
{
    public class ListActiveStudentsModel : PageModel
    {
        public List<Student> activeStudents = new List<Student>();
        public void OnGet()
        {

            try
            {
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "SELECT * FROM view_Students";

                    using (SqlCommand command = new SqlCommand(commandText, connection))
                    {

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {

                                Student student = new Student();
                                student.student_id = reader.GetInt32(0);
                                student.fname = reader.GetString(1);
                                student.lname = reader.GetString(2);
                                student.password = reader.GetString(3);
                                student.gpa = reader.GetDecimal(4);
                                student.faculty = reader.GetString(5);
                                student.email = reader.GetString(6);
                                student.major = reader.GetString(7);
                                student.financial_status = reader.GetBoolean(8);
                                student.semester = reader.IsDBNull(9) ? null : reader.GetInt32(9);
                                student.acquired_hours = reader.IsDBNull(10) ? null : reader.GetInt32(10);
                                student.assigned_hours = reader.IsDBNull(11) ? null : reader.GetInt32(11);
                                student.advisor_id = reader.IsDBNull(12) ? null : reader.GetInt32(12);
                                activeStudents.Add(student);
                            }
                        }

                    }
                    connection.Close();
                }
            }

            catch (SqlException e)
            {

                Console.WriteLine(e.ToString());
            }
        }

        public class Student
        {
            public int student_id;
            public string fname;
            public string lname;
            public string password;
            public decimal gpa;
            public string faculty;
            public string email;
            public string major;
            public bool financial_status;
            public int? semester;
            public int? acquired_hours;
            public int? assigned_hours;
            public int? advisor_id;
        }
    }
}