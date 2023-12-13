using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Data;

namespace Team6_Advising.Pages.Admin
{
    public class NewCourseModel : PageModel
    {
        public void OnGet()
        {
        }

        public void OnPost()
        {


            try
            {
                String major = Request.Form["major"];
                int semster = int.Parse(Request.Form["semster"]);
                int credit_hours = int.Parse(Request.Form["credit_hours"]);
                String course_name = Request.Form["course_name"];
                bool is_offered = bool.Parse(Request.Form["is_offered"]);

                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "Procedures_AdminAddingCourse";

                    using (SqlCommand command = new SqlCommand(commandText, connection) { CommandType = CommandType.StoredProcedure })
                    {
                        command.Parameters.Add(new SqlParameter("@major", major));
                        command.Parameters.Add(new SqlParameter("@semester", semster));
                        command.Parameters.Add(new SqlParameter("@credit_hours", credit_hours));
                        command.Parameters.Add(new SqlParameter("@name", course_name));
                        command.Parameters.Add(new SqlParameter("@is_offered", is_offered));
                        
                        command.ExecuteNonQuery();


                    }
                    connection.Close();
                }
            }
            catch (SqlException e)
            {
                ViewData["Message"] = "Student not found";
                Console.WriteLine(e.ToString());
            }
            catch (FormatException e)
            {
                ViewData["Message"] = "Invalid Date";
                Console.WriteLine(e.ToString());
            }
            catch (Exception e)
            {
                ViewData["Message"] = "Invalid Date";
                Console.WriteLine(e.ToString());
            }
        }
    }
}
