using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Admin
{
    public class LinkStudentAdvisorModel : PageModel
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

                    ViewData["Message"] = "Linked Student to Advisor Successfully !";
                }
                catch (Exception e)
                {
                    ViewData["Message"] = "Invalid Student ID or Advisor ID";
                }
                finally
                {
                    SqlHelper.DB_CONNECTION.Close();
                }
            }
            else { 
                ViewData["Message"] = "Invalid Input!";
            }
        }
    }
}
