using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Students
{
    public class CoursePrerequisitesModel : PageModel
    {
        public List<CoursePrereq> coursePrerequisites = new List<CoursePrereq>();
        public void OnGet()
        {
            try
            {

                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "SELECT * FROM view_Course_prerequisites";

                    using (SqlCommand command = new SqlCommand(commandText, connection))
                    {

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                CoursePrereq coursePrereq = new CoursePrereq();
                                coursePrereq.course_id = reader.GetInt32(0);
                                coursePrereq.course_name = reader.GetString(1);
                                coursePrereq.major = reader.GetString(2);
                                coursePrereq.is_offered = reader.GetBoolean(3);
                                coursePrereq.credit_hours = reader.GetInt32(4);
                                coursePrereq.semester = reader.GetInt32(5);
                                coursePrereq.pre_id = reader.GetInt32(6);
                                coursePrereq.pre_name = reader.GetString(7);
                                coursePrerequisites.Add(coursePrereq);    
                               
                            }
                        }

                    }
                    connection.Close();
                }
            }
            catch (Exception e)
            {
                ViewData["Message"] = "error";
                Console.WriteLine(e.ToString());
            }
        }
        public class CoursePrereq
        {
            public int course_id;
            public String course_name;
            public String major;
            public Boolean is_offered;
            public int credit_hours;
            public int semester;
            public int pre_id;
            public String pre_name;
        }
    }
}
