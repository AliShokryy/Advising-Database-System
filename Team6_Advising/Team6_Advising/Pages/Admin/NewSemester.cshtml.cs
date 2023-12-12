using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Data;
using System;

namespace Team6_Advising.Pages.Admin
{
    public class NewSemesterModel : PageModel
    {
        public void OnGet()
        {
        }
        public void OnPost()
        {
            
    
            try
            {
                DateTime end_date = DateTime.Parse(Request.Form["end_date"]);
                DateTime start_date = DateTime.Parse(Request.Form["start_date"]);
                String semster_code = Request.Form["semester_code"];

                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "AdminAddingSemester";

                    using (SqlCommand command = new SqlCommand(commandText, connection) { CommandType = CommandType.StoredProcedure })
                    {
                        command.Parameters.Add(new SqlParameter("@start_date", start_date));
                        command.Parameters.Add(new SqlParameter("@end_date", end_date));
                        command.Parameters.Add(new SqlParameter("@semester_code", semster_code));
                        

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
        }
    }
}
