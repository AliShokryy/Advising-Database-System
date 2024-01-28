using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Students
{
    public class PhoneModel : PageModel
    {
        public String id;
        public void OnGet(String? id)
        {
            this.id = id;
        }

        public void OnPost(String? id)
        {
            
            String phone = Request.Form["phone"];
            int studentId = int.Parse(id);

            try
            {
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "Procedures_StudentaddMobile";

                    using (SqlCommand command = new SqlCommand(commandText, connection) { CommandType = CommandType.StoredProcedure })
                    {
                        command.Parameters.Add(new SqlParameter("@StudentID", studentId));
                        command.Parameters.Add(new SqlParameter("@mobile_number", phone));

                        command.ExecuteNonQuery();

                        ViewData["Message"] = "Phone number added";
                    }
                    connection.Close();
                }
            }
            catch (Exception e)
            {
                ViewData["Message"] = "Phone Already Added";
                Console.WriteLine(e.ToString());
            }
        }
    }
}
