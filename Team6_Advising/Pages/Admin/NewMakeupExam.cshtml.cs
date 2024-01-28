using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Admin
{
    public class NewMakeupExamModel : PageModel
    {
        public void OnGet()
        {
        }

        public void OnPost() {
            String examType;
            DateTime examDateAndTime;
            int courseID;

            if (int.TryParse(Request.Form["courseID"], out courseID))
            {
                try
                {
                    examType = Request.Form["Type"];
                    examDateAndTime = DateTime.Parse(Request.Form["date"]);

                    SqlHelper.DB_CONNECTION.Open();

                    SqlParameter typeParam, dateTimeParam, courseParam;
                    typeParam = new SqlParameter("@Type", examType);
                    dateTimeParam = new SqlParameter("@date", examDateAndTime.ToString("yyyy-MM-dd"));
                    courseParam = new SqlParameter("@courseID", courseID);

                    string commandText = "Procedures_AdminAddExam";
                    SqlHelper.ExecActionProc(commandText, typeParam, dateTimeParam, courseParam);

                    ViewData["Message"] = "The makeup exam has been added successfully !";
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
                ViewData["Message"] = "Invalid Course ID";
            }
        }
    }
}
