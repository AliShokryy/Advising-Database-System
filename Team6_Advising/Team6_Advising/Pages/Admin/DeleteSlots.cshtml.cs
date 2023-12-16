using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Admin
{
    public class DeleteSlotsModel : PageModel
    {
        public void OnGet()
        {
        }

        public void OnPost()
        {
            String? semesterCode = Request.Form["current_semester"];
            try
            {
                SqlHelper.DB_CONNECTION.Open();
                if (SqlHelper.ExistIn(semesterCode, "SELECT semester_code FROM Semester"))
                {


                    SqlParameter semesterParam;
                    semesterParam = new SqlParameter("@current_semester", semesterCode);

                    string commandText = "Procedures_AdminDeleteSlots";
                    SqlHelper.ExecActionProc(commandText, semesterParam);

                    ViewData["Message"] = "Deleted Slots Successfully !";
                }
                else
                {
                    ViewData["Message"] = "Invalid Input";
                }
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
    }
}
