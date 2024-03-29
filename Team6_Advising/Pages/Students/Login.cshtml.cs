using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Students
{
    public class LoginModel : PageModel
    {
        public void OnGet()
        {
        }

        public void OnPost()
        {
            try
            {
                int studentId = int.Parse(Request.Form["id"]);
                string password = Request.Form["password"];
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    String CommandText = "SELECT dbo.FN_StudentLogin(@Student_id,@password)";


                    using (SqlCommand command = new SqlCommand(CommandText, connection))
                    {
                        command.Parameters.Add(new SqlParameter("@Student_id", studentId));
                        command.Parameters.Add(new SqlParameter("@password", password));
                        var result = command.ExecuteScalar();

                        if ((bool)result == true)
                        {
                            //pass the student id to the next page
                            ViewData["Message"] = "Login Successful";
                            Response.Redirect("/Students/Index?id="+studentId);
                            
                        }
                        else
                        {
                            ViewData["Message"] = "Invalid Credentials";

                        }
                    }

                    connection.Close();
                }
            }
            catch(FormatException e)
            {
                ViewData["Message"] = "Student ID must be a number";               
            }
            catch(Exception e)
            {
                ViewData["Message"] = "Student not found";
            }
        }
    }
}
