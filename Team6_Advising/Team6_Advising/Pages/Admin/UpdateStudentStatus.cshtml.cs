using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Admin
{
    public class UpdateStudentStatusModel : PageModel
    {
        public void OnGet()
        {
        }

        public void OnPost()
        {
            int studentId;
            if (int.TryParse(Request.Form["student_id"], out studentId))
            {
                try
                {
                    SqlHelper.DB_CONNECTION.Open();

                    SqlParameter studentParam = new SqlParameter("@student_id", studentId);

                    string commandText = "Procedure_AdminUpdateStudentStatus";
                    SqlHelper.ExecActionProc(commandText, studentParam);

                    Console.WriteLine("Successful Operation !");
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.Message);
                }
                finally
                {
                    SqlHelper.DB_CONNECTION.Close();
                }
            }
            else
            {
                Console.WriteLine("Invalid input");
            }
        }
    }
}
