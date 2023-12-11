using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Students
{
    public class LoginModel : PageModel
    {
        public void OnGet()
        {
        }

        public void OnPost()
        {
            int studentId = int.Parse(Request.Form["id"]);
            string password = Request.Form["password"];

            try
            {
                String connectionString = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=Advising_System;Integrated Security=True;";
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    String CommandText = "SELECT dbo.FN_StudentLogin(@Student_id,@password)";


                    using (SqlCommand command = new SqlCommand(CommandText, connection))
                    {
                        command.Parameters.Add(new SqlParameter("@Student_id", studentId));
                        command.Parameters.Add(new SqlParameter("@password", password));
                        var result = command.ExecuteScalar();
                        Console.WriteLine(result);
                        // Check the result, assuming it's an integer
                        if ((bool)result == true)
                        {
                            Console.WriteLine("Login Successful");
                            Response.Redirect("/Students/Index");
                        }
                        else
                        {
                            Console.WriteLine("Login failed");
                            ViewData["Message"] = "Login Failed";

                        }
                    }

                    connection.Close();
                }
            }
            catch(SqlException e)
            {
                ViewData["Message"] = "Student not found";
                Console.WriteLine(e.ToString());
            }
        }
    }
}
