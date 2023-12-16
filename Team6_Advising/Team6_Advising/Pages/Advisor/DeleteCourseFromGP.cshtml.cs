using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using Team6_Advising.Pages.Admin;
using static Team6_Advising.Pages.Admin.ListAdvisorsModel;

namespace Team6_Advising.Pages.Advisor
{
    public class DeleteCourseFromGPModel : PageModel
    {
        public void OnGet()
        {
        }
        public void OnPost(String? id)
        {
            int advisorID = int.Parse(id);
            try
            {
                int courseID = int.Parse(Request.Form["crsID"]);
                int studentID = int.Parse(Request.Form["stdID"]);
                string semesterCode = Request.Form["semCode"];
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string checkAdvisor = "SELECT advisor_id FROM Student WHERE advisor_id=@advisor_id AND student_id = @student_id";
                    Boolean checkStudent = false;
                    using (SqlCommand cmd = new SqlCommand(checkAdvisor, connection))
                    {
                        cmd.Parameters.Add(new SqlParameter("@advisor_Id", advisorID));
                        cmd.Parameters.Add(new SqlParameter("@student_id", studentID));
                        SqlDataReader reader = cmd.ExecuteReader();
                        while (reader.Read())
                        {
                            checkStudent = !reader.IsDBNull(0);
                        }
                        reader.Close();
                    }
                    //Boolean checkStudent = SqlHelper.ExistIn(studentID + "", "SELECT student_id FROM Student WHERE advisor_id = " +advisorID);
                    if (checkStudent)
                    {
                        string commandText = "Procedures_AdvisorDeleteFromGP";

                        using (SqlCommand command = new SqlCommand(commandText, connection))
                        {
                            command.CommandType = System.Data.CommandType.StoredProcedure;
                            command.Parameters.Add(new SqlParameter("@studentID", studentID));
                            command.Parameters.Add(new SqlParameter("@sem_code", semesterCode));
                            command.Parameters.Add(new SqlParameter("@courseID", courseID));

                            command.ExecuteNonQuery();
                        }
                        ViewData["Message"] = "Course deleted Successfully";
                        
                    }
                    else
                    {
                        ViewData["Message"] = "Not One of Your Assigned Students";
                    }
                    connection.Close();


                }
            }
            catch (Exception e)
            {
                ViewData["Message"] = "Course not deleted";
                Console.WriteLine(e.ToString());
            }
        }
    }
}
