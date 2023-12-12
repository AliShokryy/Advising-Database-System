using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Students
{
    public class ReqCoursesModel : PageModel
    {
        public List<Course> courses = new List<Course>();
        public void OnGet()
        {
        }

        public void OnPost(String? id)
        {
            String semester = Request.Form["semcode"];
            int student_id = int.Parse(id);

            try
            {
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "Procedures_ViewRequiredCourses";

                    using (SqlCommand command = new SqlCommand(commandText, connection) { CommandType = CommandType.StoredProcedure })
                    {
                        command.Parameters.Add(new SqlParameter("@StudentID", student_id));
                        command.Parameters.Add(new SqlParameter("@current_semester_code", semester));

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                Course course = new Course();
                                course.name = reader.GetString(0);
                                course.id = reader.GetInt32(1);
                                courses.Add(course);
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

        public class Course
        {
            public String name;
            public int id;
        }
    }
}
