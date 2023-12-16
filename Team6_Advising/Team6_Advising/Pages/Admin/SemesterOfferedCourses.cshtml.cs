using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Admin
{
    public class SemesterOfferedCoursesModel : PageModel
    {
        public List<SemesterOfferedCourses> semesterOfferedCourses = new List<SemesterOfferedCourses>();
        public void OnGet()
        {

            try
            {
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "SELECT * FROM Semster_offered_Courses";

                    using (SqlCommand command = new SqlCommand(commandText, connection))
                    {

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                SemesterOfferedCourses course = new SemesterOfferedCourses();
                                course.course_id = reader.GetInt32(0);
                                course.course_name = reader.GetString(1);
                                course.semester_code = reader.GetString(2);
                                semesterOfferedCourses.Add(course);
                            }
                        }

                    }
                    connection.Close();
                }
            }

            catch (Exception e)
            {

                Console.WriteLine(e.ToString());
            }
        }

        public class SemesterOfferedCourses
        {
            public int course_id;
            public String course_name;
            public String semester_code;
        }
    }
}
