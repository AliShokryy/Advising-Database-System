using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Advisor
{
    public class LoginAdvisorModel : PageModel
    {
        public void OnGet()
        {
        }

        public IActionResult OnPost()
        {
            int advisorId = int.Parse(Request.Form["id"]);
            string password = Request.Form["password"];
            try
            {
                String connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    String CommandText = "SELECT dbo.FN_AdvisorLogin(@advisor_Id,@password)";

                    using (SqlCommand command = new SqlCommand(CommandText, connection))
                    {
                        command.Parameters.Add(new SqlParameter("@advisor_Id", advisorId));
                        command.Parameters.Add(new SqlParameter("@password", password));
                        var result = command.ExecuteScalar();
                        Console.WriteLine(result);
                        // Check the result, assuming it's an integer
                        if ((bool)result == true)
                        {
                            Console.WriteLine("Login Successful");
                            //Response.Redirect("/Advisor/AdvisorMenu");
                            return new RedirectToPageResult("/Advisor/AdvisorMenu", new { id = advisorId });
                        }
                        else
                        {
                            Console.WriteLine("Login failed");
                            ViewData["Message"] = "Login Failed";
                            return Page();

                        }
                    }

                    connection.Close();
                }
            }
            catch(SqlException e)
            {
                ViewData["Message"] = "Advisor not found";
                Console.WriteLine(e.ToString());
                return Page();
            }
        }
    }
}
