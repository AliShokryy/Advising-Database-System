using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Security.Cryptography.X509Certificates;

namespace Team6_Advising.Pages.Students
{
    public class GraduationPlanModel : PageModel
    {
        public List<GraduationPlanView> grad_plan = new List<GraduationPlanView>();
        public void OnGet(String? id)
        {
            try
            {
                int student_id = int.Parse(id);
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "SELECT * FROM FN_StudentViewGP(@student_ID)";

                    using (SqlCommand command = new SqlCommand(commandText, connection))
                    {
                        command.Parameters.Add(new SqlParameter("@student_ID", student_id));

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                GraduationPlanView graduationPlanView = new GraduationPlanView(); 
                                graduationPlanView.student_name = reader.GetString(0);
                                graduationPlanView.plan_id = reader.GetInt32(1);
                                graduationPlanView.semester_code = reader.GetString(2);
                                graduationPlanView.credit_hours = reader.GetInt32(3);
                                graduationPlanView.expected_grad_date = reader.GetDateTime(4);
                                graduationPlanView.advisor_id = reader.GetInt32(5);
                                graduationPlanView.student_id = reader.GetInt32(6);
                                graduationPlanView.course_id = reader.GetInt32(7);
                                graduationPlanView.course_name = reader.GetString(8);
                                grad_plan.Add(graduationPlanView);
                            }
                        }

                    }
                    connection.Close();
                }
            }
            catch (SqlException e)
            {
                ViewData["Message"] = "Phone number not added";
                Console.WriteLine(e.ToString());
            }

        }
        public class GraduationPlanView
        {
            public string student_name;
            public int plan_id;
            public string semester_code;
            public int credit_hours;
            public DateTime expected_grad_date;
            public int advisor_id;
            public int student_id;
            public int course_id;
            public string course_name;
        }
    }
 }

