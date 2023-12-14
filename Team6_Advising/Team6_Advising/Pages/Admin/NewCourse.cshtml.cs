using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Data;

namespace Team6_Advising.Pages.Admin
{
    public class NewCourseModel : PageModel
    {
        public void OnGet()
        {
        }

        public void OnPost()
        {
            string major, courseName;
            int semester, creditHours;
            bool isOffered = false;
            if (int.TryParse(Request.Form["semester"], out semester) && int.TryParse(Request.Form["credit_hours"], out creditHours))
            {

                try
                {
                    major = Request.Form["major"];
                    courseName = Request.Form["course_name"];
                    bool.TryParse(Request.Form["is_offered"], out isOffered);

                    SqlHelper.DB_CONNECTION.Open();

                    SqlParameter majorParam, semesterParam, creditHoursParam, courseNameParam, isOfferedParam;
                    majorParam = new SqlParameter("@major", major);
                    semesterParam = new SqlParameter("@semester", semester);
                    creditHoursParam = new SqlParameter("@credit_hours", creditHours);
                    courseNameParam = new SqlParameter("@name", courseName);
                    isOfferedParam = new SqlParameter("@is_offered", isOffered);

                    string commandText = "Procedures_AdminAddingCourse";
                    SqlHelper.ExecActionProc(commandText, majorParam, semesterParam, creditHoursParam, courseNameParam, isOfferedParam);

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

            else
            {
                Console.WriteLine("Invalid semester or credit hours");
            }

            //string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
            //SqlConnection connection = new SqlConnection(connectionString);

            //try
            //{
            //    connection.Open();

            //    String major = Request.Form["major"];
            //    int semster = int.Parse(Request.Form["semester"]);
            //    int credit_hours = int.Parse(Request.Form["credit_hours"]);
            //    String course_name = Request.Form["course_name"];
            //    Boolean is_offered = false;
            //    Boolean.TryParse(Request.Form["is_offered"], out is_offered);

            //    string commandText = "Procedures_AdminAddingCourse";

            //    using (SqlCommand command = new SqlCommand(commandText, connection) { CommandType = CommandType.StoredProcedure })
            //    {
            //        command.Parameters.Add(new SqlParameter("@major", major));
            //        command.Parameters.Add(new SqlParameter("@semester", semster));
            //        command.Parameters.Add(new SqlParameter("@credit_hours", credit_hours));
            //        command.Parameters.Add(new SqlParameter("@name", course_name));
            //        command.Parameters.Add(new SqlParameter("@is_offered", is_offered));

            //        command.ExecuteNonQuery();

            //    }

            //}

            //finally {
            //    connection.Close();
            //}
        }
    }
}
