using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Students
{
    public class CoursesModel : PageModel
    {
        public List<Course> availableCourses = new List<Course>();
        public void OnGet()
        {
        }

        public void OnPost()
        {
            String semester = Request.Form["semcode"];
            getAvailableCourses(semester);
        }

        public void getAvailableCourses(String sem)
        {
            String semester = sem;
            try
            {
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "SELECT * FROM FN_SemsterAvailableCourses(@semstercode)";

                    using (SqlCommand command = new SqlCommand(commandText, connection))
                    {
                        command.Parameters.Add(new SqlParameter("@semstercode", semester));

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                Course course = new Course();
                                course.name = reader.GetString(0);
                                course.courseid = reader.GetInt32(1);
                                
                                availableCourses.Add(course);
                            }
                        }

                    }
                    connection.Close();
                }
            }
            catch (SqlException e)
            {
                ViewData["Message"] = "Phone number not added";
                Console.WriteLine(e.ToString());
            }

        }

        public class Course
        {
            public int courseid;
            public String name;
        }

    }
}
