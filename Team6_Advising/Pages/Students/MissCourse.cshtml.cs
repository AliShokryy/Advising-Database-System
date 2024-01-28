using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Data;

namespace Team6_Advising.Pages.Students
{
    public class MissCourseModel : PageModel
    {
        public List<Course> courses = new List<Course>();
        public void OnGet(String? id)
        {
            int student_id = int.Parse(id);

            try
            {
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "Procedures_ViewMS";

                    using (SqlCommand command = new SqlCommand(commandText, connection) { CommandType = CommandType.StoredProcedure })
                    {
                        command.Parameters.Add(new SqlParameter("@StudentID", student_id));

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                Course course = new Course();
                                course.id = reader.GetInt32(0);
                                course.name = reader.GetString(1);
                                courses.Add(course);
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

        public class Course
        {
            public String name;
            public int id;
        }
    }
}
