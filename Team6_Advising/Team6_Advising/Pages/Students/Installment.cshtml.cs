using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Students
{
    public class InstallmentModel : PageModel
    {
        public void OnGet(String? id)
        {
            try
            {
                int studentId = int.Parse(id);
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    String CommandText = "SELECT dbo.FN_StudentUpcoming_installment(@student_ID)";


                    using (SqlCommand command = new SqlCommand(CommandText, connection))
                    {
                        command.Parameters.Add(new SqlParameter("@Student_id", studentId));
                        var result = command.ExecuteScalar();
                        String date = result.ToString();
                        ViewData["Message"] = date;
                        Console.WriteLine(date);
                    }

                    connection.Close();
                }
            }
            catch (FormatException e)
            {
                ViewData["Message"] = "Invalid Student ID";
                Console.WriteLine(e.ToString());
            }
            catch (SqlException e)
            {
                ViewData["Message"] = "Student not found";
                Console.WriteLine(e.ToString());
            }
        }
    }

    }
