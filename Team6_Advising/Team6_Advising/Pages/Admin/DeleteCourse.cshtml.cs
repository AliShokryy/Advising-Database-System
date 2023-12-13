using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Admin
{
    public class DeleteCourseModel : PageModel
    {
        public void OnGet()
        {
        }

        public void OnPost()
        {
            int courseId;
            if (int.TryParse(Request.Form["courseID"], out courseId))
            {
                try
                {
                    SqlHelper.DB_CONNECTION.Open();

                    SqlParameter courseParam;
                    courseParam = new SqlParameter("@courseID", courseId);

                    string commandText = "Procedures_AdminDeleteCourse";
                    SqlHelper.ExecActionProc(commandText, courseParam);

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
