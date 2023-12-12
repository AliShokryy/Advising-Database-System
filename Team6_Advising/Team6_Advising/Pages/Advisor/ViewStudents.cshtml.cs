using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Advisor
{
    public class ViewStudentsModel : PageModel
    {
        public List<Student> studentList = new List<Student>();
        public class Student
        {
            public int studentId;
            public string name;
            //public string l_name;
            public string email;
            public string major;
            public string faculty;
            public int semester;
        }
        public void OnGet()
        {
        }

        public void OnPost(String? id)
        {
            int advisorId = int.Parse(id);
            try
            {
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "SELECT * FROM Student WHERE advisor_id = @advisor_Id";

                    using (SqlCommand command = new SqlCommand(commandText, connection))
                    {
                        command.Parameters.Add(new SqlParameter("@advisor_Id", advisorId));
                        SqlDataReader reader = command.ExecuteReader();
                        while (reader.Read())
                        {
                            Student student = new Student();
                            student.studentId = reader.GetInt32(0);
                            student.name = reader.GetString(1) + " " + reader.GetString(2);
                            //student.l_name = reader.GetString(2);
                            student.email = reader.GetString(6);
                            student.major = reader.GetString(7);
                            student.faculty = reader.GetString(5);
                            student.semester = reader.GetInt32(8);
                            studentList.Add(student);
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
    }
}
