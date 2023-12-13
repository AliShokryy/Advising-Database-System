using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Admin
{
    public class StudentToAdvisorModel : PageModel
    {
        public void OnGet()
        {
        }
        public void OnPost() { 
            int studentId, advisorId;
            if (int.TryParse(Request.Form["studentId"], out studentId) && int.TryParse(Request.Form["advisorId"], out advisorId))
            {
                try 
                {
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        connection.Open();
                        string commandText = "Procedures_AdminLinkStudentToAdvisor";

                        using (SqlCommand command = new SqlCommand(commandText, connection) { CommandType = CommandType.StoredProcedure })
                        {
                            command.Parameters.Add(new SqlParameter("@studentID", studentId));
                            command.Parameters.Add(new SqlParameter("@advisorID", advisorId));
                            command.ExecuteNonQuery();
                        }
                        connection.Close();
                        Console.WriteLine("Successful Operation !");
                    }
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.Message);
                }
            }
            else { 
                Console.WriteLine("Invalid input");
            }
        }
    }
}
