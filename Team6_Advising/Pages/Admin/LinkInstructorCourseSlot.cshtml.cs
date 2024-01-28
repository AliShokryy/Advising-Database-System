using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data;
using System.Data.SqlClient;
using static Team6_Advising.Pages.Admin.ListAdvisorsModel;

namespace Team6_Advising.Pages.Admin
{
    public class LinkInstructorCourseSlotModel : PageModel
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
                    instructorParam = new SqlParameter("@instructor_id", instructorId);
                    courseParam = new SqlParameter("@cours_id", courseId);
                    slotParam = new SqlParameter("@slot_id", slotId);

                    string commandText = "Procedures_AdminLinkInstructor";
                    SqlHelper.ExecActionProc(commandText, courseParam, instructorParam, slotParam);

                    ViewData["Message"] = "Linked Instructor to Course Successfully !";
                }
                catch (Exception e)
                {
                    ViewData["Message"] = "Invalid Instructor ID or Course ID or Slot ID";
                }
                finally
                {
                    SqlHelper.DB_CONNECTION.Close();
                }
            }
            else { 
                ViewData["Message"] = "Invalid Input !";
            }
        }
    }
}
