using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Data;

namespace Team6_Advising.Pages.Admin
{
    public class InstructorAssignedCoursesModel : PageModel
    {
        public List<InstructorAssignedCourses>instructorAssignedCourses  = new List<InstructorAssignedCourses>();
        public void OnGet()
        {

            try
            {
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "SELECT * FROM Instructors_AssignedCourses";

                    using (SqlCommand command = new SqlCommand(commandText, connection))
                    {

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                InstructorAssignedCourses instructorAssignedCourse = new InstructorAssignedCourses();
                                instructorAssignedCourse.instructor_id = reader.GetInt32(0);
                                instructorAssignedCourse.instructor_name = reader.GetString(1);
                                instructorAssignedCourse.course_id = reader.GetInt32(2);
                                instructorAssignedCourse.course_name = reader.GetString(3);
                                instructorAssignedCourses.Add(instructorAssignedCourse);
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

        public class InstructorAssignedCourses
        {
            public int instructor_id;
            public String instructor_name;
            public int course_id;
            public String course_name;
        }
    }
}
