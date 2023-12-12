using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Students
{
    public class RegisterModel : PageModel
    {
        public void OnGet()
        {
        }

        public void OnPost()
        {
            String firstName = Request.Form["fname"];
            String lastName = Request.Form["lname"];
            String email = Request.Form["mail"];
            String password = Request.Form["password"];
            String faculty = Request.Form["faculty"];
            String major = Request.Form["major"];
            int semester = int.Parse(Request.Form["semester"]);


            try
            {
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "Procedures_StudentRegistration";

                    using (SqlCommand command = new SqlCommand(commandText, connection) { CommandType = CommandType.StoredProcedure})
                    {
                        command.Parameters.Add(new SqlParameter("@first_name", firstName));
                        command.Parameters.Add(new SqlParameter("@last_name", lastName));
                        command.Parameters.Add(new SqlParameter("@email", email));
                        command.Parameters.Add(new SqlParameter("@password", password));
                        command.Parameters.Add(new SqlParameter("@faculty", faculty));
                        command.Parameters.Add(new SqlParameter("@major", major));
                        command.Parameters.Add(new SqlParameter("@Semester", semester));

                        SqlParameter id = command.Parameters.Add("@Student_id", System.Data.SqlDbType.Int);
                        id.Direction = ParameterDirection.Output;

                        command.ExecuteNonQuery();

                        // Retrieve the output parameter value after the execution
                        string studentId = id.Value.ToString();
                        ViewData["Message"] = "Student ID: " + studentId;

       
                        
                        
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
