using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Advisor
{
    public class InsertGradPlanModel : PageModel
    {
        public void OnGet()
        {
        }

        public void OnPost(String? id)
        {
            string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
            try
            {
                int advisorID = int.Parse(id);
                string semcode = Request.Form["semcode"];
                DateTime expected_grad = DateTime.Parse(Request.Form["expgradsem"]);
                string semCredits = Request.Form["semcredhrs"];
                int studentID = int.Parse(Request.Form["stdID"]);

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
                        string commandText = "Procedures_AdvisorCreateGP";

                        using (SqlCommand command = new SqlCommand(commandText, connection))
                        {
                            command.CommandType = System.Data.CommandType.StoredProcedure;
                            command.Parameters.Add(new SqlParameter("@Semester_code", semcode));
                            command.Parameters.Add(new SqlParameter("@expected_graduation_date", expected_grad));
                            command.Parameters.Add(new SqlParameter("@sem_credit_hours", semCredits));
                            command.Parameters.Add(new SqlParameter("@advisor_id", advisorID));
                            command.Parameters.Add(new SqlParameter("@student_id", studentID));
                            command.ExecuteNonQuery();
                        }
                        ViewData["Message"] = "Graduation Plan added Successfully";
                        
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
                ViewData["Message"] = "Graduation Plan not added";
                Console.WriteLine(e.ToString());
            }
        }
    }
}
