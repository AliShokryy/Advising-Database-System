using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Advisor
{
    public class InsertCourseToGradPlanModel : PageModel
    {
        public void OnGet()
        {
        }
        public void OnPost(String? id) {
            int advisorID = int.Parse(id);
            try
            {
                int studentID = int.Parse(Request.Form["stdID"]);
                string semesterCode = Request.Form["semcode"];
                string courseName = Request.Form["crsName"];
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "Procedures_AdvisorAddCourseGP";
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
                    }
                    if (checkStudent)
                    {
                        using (SqlCommand command = new SqlCommand(commandText, connection))
                        {
                            command.CommandType = System.Data.CommandType.StoredProcedure;
                            command.Parameters.Add(new SqlParameter("@student_id", studentID));
                            command.Parameters.Add(new SqlParameter("@Semester_code", semesterCode));
                            command.Parameters.Add(new SqlParameter("@course_name", courseName));
                            command.ExecuteNonQuery();
                        }
                        ViewData["Message"] = "Course added Successfully";
                        connection.Close();

                    }
                    else
                    {
                        ViewData["Message"] = "Not One of Your Assigned Students";
                    }
                }
            }
            catch (Exception e)
            {
                ViewData["Message"] = "Course not added";
                Console.WriteLine(e.ToString());    
            }
        }
    }
}
