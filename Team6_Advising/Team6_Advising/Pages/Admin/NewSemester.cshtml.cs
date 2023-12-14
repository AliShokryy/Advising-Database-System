using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Data;

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
                DateTime start_date = DateTime.Parse(Request.Form["start_date"]);
                DateTime end_date = DateTime.Parse(Request.Form["end_date"]);
                String semster_code = Request.Form["semester_code"];

                SqlHelper.DB_CONNECTION.Open();

                string commandText = "AdminAddingSemester";

                SqlParameter startDateParam = new SqlParameter("@start_date", start_date.ToString("yyyy-MM-dd"));
                SqlParameter endDateParam =  new SqlParameter("@end_date", end_date.ToString("yyyy-MM-dd"));
                SqlParameter semesterCodeParam = new SqlParameter("@semester_code", semster_code);

                SqlHelper.ExecActionProc(commandText, startDateParam, endDateParam, semesterCodeParam);

                Console.WriteLine("Successful Operation !");
                
            }
            catch (Exception e)
            {
                ViewData["Message"] = "Student not found";
                Console.WriteLine(e.ToString());
            }
            finally
            {
                SqlHelper.DB_CONNECTION.Close();
            }
        }
    }
}
