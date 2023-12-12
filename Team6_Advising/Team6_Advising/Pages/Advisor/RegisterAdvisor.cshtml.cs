using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Data;


namespace Team6_Advising.Pages.Advisor
{
    public class RegisterAdvisorModel : PageModel
    {
        public void OnGet()
        {
        }

        public void OnPost()
        {
            String name = Request.Form["name"];
            String email = Request.Form["mail"];
            String password = Request.Form["password"];
            String office = Request.Form["office"];

            try
            {
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "Procedures_AdvisorRegistration";

                    using (SqlCommand command = new SqlCommand(commandText, connection) { CommandType = CommandType.StoredProcedure })
                    {
                        command.Parameters.Add(new SqlParameter("@advisor_name", name));
                        command.Parameters.Add(new SqlParameter("@password", password));
                        command.Parameters.Add(new SqlParameter("@email", email));
                        command.Parameters.Add(new SqlParameter("@office", office));

                        SqlParameter id = command.Parameters.Add("@Advisor_id", System.Data.SqlDbType.Int);
                        id.Direction = ParameterDirection.Output;

                        command.ExecuteNonQuery();

                        // Retrieve the output parameter value after the execution
                        string studentId = id.Value.ToString();
                        ViewData["Message"] = "Advisor ID: " + studentId;




                    }
                    connection.Close();
                }
            }


            catch (SqlException e)
            {
                ViewData["Message"] = "Student not found";
                Console.WriteLine(e.ToString());
            }

        }
    }
}
