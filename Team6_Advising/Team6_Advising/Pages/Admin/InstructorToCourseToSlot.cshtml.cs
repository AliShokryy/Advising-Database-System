using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data;
using System.Data.SqlClient;
using static Team6_Advising.Pages.Admin.ListAdvisorsModel;

namespace Team6_Advising.Pages.Admin
{
    public class InstructorToCourseToSlotModel : PageModel
    {
        public void OnGet()
        {
        }
        public void OnPost() {
            int instructorId, courseId, slotId;
            if (int.TryParse(Request.Form["instructor_id"], out instructorId) && int.TryParse(Request.Form["cours_id"], out courseId) && int.TryParse(Request.Form["slot_id"], out slotId)) {
                try 
                {
                    SqlHelper.DB_CONNECTION.Open();

                    SqlParameter instructorParam, courseParam, slotParam; 
                    instructorParam = new SqlParameter("@cours_id", instructorId);
                    courseParam = new SqlParameter("@instructor_id", courseId);
                    slotParam = new SqlParameter("@slot_id", slotId);

                    string commandText = "Procedures_AdminLinkInstructor";
                    SqlHelper.ExecActionProc(commandText, courseParam, instructorParam, slotParam);

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
