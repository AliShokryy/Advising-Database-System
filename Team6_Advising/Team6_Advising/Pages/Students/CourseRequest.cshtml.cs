using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Data;

namespace Team6_Advising.Pages.Students
{
    public class CourseRequestModel : PageModel
    {
        public void OnGet()
        {
        }

        public void OnPost(String? id)
        {



            try
            {
                int student_id = int.Parse(id);
                int CourseID = int.Parse(Request.Form["cid"]);
                String comment = Request.Form["cmnt"];
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "Procedures_StudentSendingCourseRequest";

                    using (SqlCommand command = new SqlCommand(commandText, connection) { CommandType = CommandType.StoredProcedure })
                    {
                        command.Parameters.Add(new SqlParameter("@StudentID", student_id));
                        command.Parameters.Add(new SqlParameter("@CourseID", CourseID));
                        command.Parameters.Add(new SqlParameter("@comment", comment));
                        command.Parameters.Add(new SqlParameter("@type", "course"));
                        command.ExecuteNonQuery();

                    }
                    ViewData["Message"] = "Course Request Sent Successfully";
                    connection.Close();
                }
            }


            catch (Exception e)
            {
                ViewData["Message"] = "Invalid Input";
                Console.WriteLine(e.ToString());
            }


        }
    }
}
