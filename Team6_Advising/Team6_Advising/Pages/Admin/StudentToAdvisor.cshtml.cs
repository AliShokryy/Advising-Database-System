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
            if (int.TryParse(Request.Form["studentID"], out studentId) && int.TryParse(Request.Form["advisorID"], out advisorId))
            {
                try 
                {
                    SqlHelper.DB_CONNECTION.Open();

                    SqlParameter studentParam, advisorParam;
                    studentParam = new SqlParameter("@studentID", studentId);
                    advisorParam = new SqlParameter("@advisorID", advisorId);

                    string commandText = "Procedures_AdminLinkStudentToAdvisor";
                    SqlHelper.ExecActionProc(commandText, studentParam, advisorParam);

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
            else { 
                Console.WriteLine("Invalid input");
            }
        }
    }
}
