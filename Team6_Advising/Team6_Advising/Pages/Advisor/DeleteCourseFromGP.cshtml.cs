using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Advisor
{
    public class DeleteCourseFromGPModel : PageModel
    {
        public void OnGet()
        {
        }
        public void OnPost(String? id) 
        { 
            int advisorID = int.Parse(id);
            try
            {
                int courseID = int.Parse(Request.Form["crsID"]);
                int studentID = int.Parse(Request.Form["stdID"]);
                string semesterCode = Request.Form["semCode"];
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "Procedures_AdvisorDeleteFromGP";

                    using (SqlCommand command = new SqlCommand(commandText, connection))
                    {
                        command.CommandType = System.Data.CommandType.StoredProcedure;
                        command.Parameters.Add(new SqlParameter("@studentID", studentID));
                        command.Parameters.Add(new SqlParameter("sem_code", semesterCode));
                        command.Parameters.Add(new SqlParameter("@courseID", courseID));
                        
                        command.ExecuteNonQuery();
                    }
                    ViewData["Message"] = "Course deleted Successfully";
                    connection.Close();
                }
            }
            catch (Exception e)
            {
                ViewData["Message"] = "Course not deleted";
                Console.WriteLine(e.ToString());
            }
        }
    }
}
