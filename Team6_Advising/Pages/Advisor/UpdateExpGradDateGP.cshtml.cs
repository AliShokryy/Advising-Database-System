using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Advisor
{
    public class UpdateExpGradDateGPModel : PageModel
    {
        public void OnGet()
        {
        }
        public void OnPost(String? id)
        {
            int advisorID = int.Parse(id);
            try
            {
                int studentID = int.Parse(Request.Form["stdID"]);
                DateTime expected_grad = DateTime.Parse(Request.Form["expgradDate"]);
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
                    if (checkStudent)
                    {
                        string commandText = "Procedures_AdvisorUpdateGP";

                        using (SqlCommand command = new SqlCommand(commandText, connection))
                        {
                            command.CommandType = System.Data.CommandType.StoredProcedure;
                            command.Parameters.Add(new SqlParameter("@expected_grad_date", expected_grad));
                            command.Parameters.Add(new SqlParameter("@studentID", studentID));
                            command.ExecuteNonQuery();
                        }
                        ViewData["Message"] = "Graduation Plan updated Successfully";
                        
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
                ViewData["Message"] = "Graduation Plan not updated";
                Console.WriteLine(e.ToString());
        }
    }
}
    }
