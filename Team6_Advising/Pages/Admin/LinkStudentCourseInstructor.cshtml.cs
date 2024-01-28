using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Admin
{
    public class LinkStudentCourseInstructorModel : PageModel
    {
        public void OnGet()
        {
        }
        public void OnPost() {
            int courseId, instructorId, studentId;
            String? semesterCode;
            if (int.TryParse(Request.Form["cours_id"], out courseId) && int.TryParse(Request.Form["instructor_id"], out instructorId) && int.TryParse(Request.Form["studentID"], out studentId)) {
                try
                {
                    SqlHelper.DB_CONNECTION.Open();

                    semesterCode = Request.Form["semester_code"];
                    if (SqlHelper.ExistIn(semesterCode, "SELECT semester_code FROM Semester"))
                    { 
                        SqlParameter instructorParam, courseParam, studentParam, semesterParam;
                        courseParam = new SqlParameter("@cours_id", courseId);
                        instructorParam = new SqlParameter("@instructor_id", instructorId);
                        studentParam = new SqlParameter("@studentID", studentId);
                        semesterParam = new SqlParameter("@semester_code", semesterCode);

                        string commandText = "Procedures_AdminLinkStudent";
                        SqlHelper.ExecActionProc(commandText, courseParam, instructorParam, studentParam, semesterParam);

                        ViewData["Message"] = "Linked Student to Course Successfully !";

                    }
                    else
                    {
                        ViewData["Message"] = "Invalid Input";
                    }
                }
                catch (Exception e)
                {
                    ViewData["Message"] = "Invalid Instructor ID or Course ID or Student ID";
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
