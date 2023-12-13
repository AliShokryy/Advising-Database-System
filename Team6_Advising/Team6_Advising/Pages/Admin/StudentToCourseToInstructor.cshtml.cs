using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Admin
{
    public class StudentToCourseToInstructorModel : PageModel
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
                        courseParam = new SqlParameter("@cours_id", instructorId);
                        instructorParam = new SqlParameter("@instructor_id", courseId);
                        studentParam = new SqlParameter("@studentID", studentId);
                        semesterParam = new SqlParameter("@semester_code", semesterCode);

                        string commandText = "Procedures_AdminLinkStudent";
                        SqlHelper.ExecActionProc(commandText, courseParam, instructorParam, studentParam, semesterParam);

                        Console.WriteLine("Successful Operation !");

                    }
                    else
                    {
                        Console.WriteLine("Semester code does not exist");
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
            else { 
                Console.WriteLine("Invalid input");
            }
        }
        
    }
}
