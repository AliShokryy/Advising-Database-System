using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Admin
{
    public class GradPlanAdvisorsModel : PageModel
    {
        public List<GradPlanAdvisors> gradPlanAdvisors = new List<GradPlanAdvisors>();
        public void OnGet()
        {

            try
            {
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "SELECT * FROM Advisors_Graduation_Plan";

                    using (SqlCommand command = new SqlCommand(commandText, connection))
                    {

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {  
                                GradPlanAdvisors gradPlanAdvisor = new GradPlanAdvisors();
                                gradPlanAdvisor.plan_id = reader.GetInt32(0);
                                gradPlanAdvisor.semester_code = reader.GetString(1);
                                gradPlanAdvisor.semester_credit_hours = reader.GetInt32(2);
                                gradPlanAdvisor.expected_grad_date = reader.GetDateTime(3);
                                gradPlanAdvisor.student_id = reader.GetInt32(5);
                                gradPlanAdvisor.advisor_id = reader.GetInt32(6);
                                gradPlanAdvisor.advisor_name = reader.GetString(7);
                                gradPlanAdvisors.Add(gradPlanAdvisor);
                            }
                        }

                    }
                    connection.Close();
                }
            }

            catch (SqlException e)
            {

                Console.WriteLine(e.ToString());
            }
        }

        public class GradPlanAdvisors
        {
            public int plan_id;
            public String semester_code;
            public int semester_credit_hours;
            public DateTime expected_grad_date;
            public int student_id;
            public int advisor_id;
            public String advisor_name;
        }
    }
}
