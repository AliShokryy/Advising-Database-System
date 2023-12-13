using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Students
{
    public class ChooseInstructorModel : PageModel
    {
        public void OnGet()
        {
        }
        public void OnPost(String? id) {
            try
            {
                int student_id = int.Parse(id);
                int instructor_id = int.Parse(Request.Form["instructor_id"]);
                int course_id = int.Parse(Request.Form["course_id"]);
                String semester_code = Request.Form["semester_code"];
                String connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "Procedures_Chooseinstructor";

                    using (SqlCommand command = new SqlCommand(commandText, connection){CommandType=CommandType.StoredProcedure})
                    {
                        command.Parameters.Add(new SqlParameter("@StudentID", student_id));
                        command.Parameters.Add(new SqlParameter("@instrucorID", instructor_id));
                        command.Parameters.Add(new SqlParameter("@CourseID", course_id));
                        command.Parameters.Add(new SqlParameter("@current_semester_code", semester_code));
                        command.ExecuteNonQuery();
                    }
                    connection.Close();
                }

            }
            catch (SqlException e)
            {
                ViewData["Message"] = "error";
                Console.WriteLine(e.ToString());
            }
            

            

            
        }
    }
}
