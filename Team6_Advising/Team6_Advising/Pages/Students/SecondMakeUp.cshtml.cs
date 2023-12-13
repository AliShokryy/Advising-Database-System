using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Students
{
    public class SecondMakeUpModel : PageModel
    {
        public void OnGet()
        {
        }
        public void OnPost(String? id)
        {
            try
            {
                int student_id = int.Parse(id);
                int course_id = int.Parse(Request.Form["course_id"]);
                String current_sem = Request.Form["current_sem"];
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "Procedures_StudentRegisterSecondMakeup";
                    using (SqlCommand command = new SqlCommand(commandText, connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add(new SqlParameter("@StudentID", student_id));
                        command.Parameters.Add(new SqlParameter("@courseID", course_id));
                        command.Parameters.Add(new SqlParameter("@studentCurr_sem", current_sem));
                        command.ExecuteNonQuery();
                    }

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
