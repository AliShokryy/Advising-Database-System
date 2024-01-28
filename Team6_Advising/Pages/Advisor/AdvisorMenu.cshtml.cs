using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Advisor
{
    public class AdvisorMenuModel : PageModel
    {
        public advisor a = new advisor();
        public class advisor
        {
            public string id;
            public string name;
            public string email;
            public string office;
        }
        public void OnGet(String? id)
        {
            string advisorID = int.Parse(id) + "";
            a.id = advisorID;
            string connection = Environment.GetEnvironmentVariable("connectionString");
            using (SqlConnection sqlConnection = new SqlConnection(connection))
            {
                sqlConnection.Open();
                string query = "SELECT advisor_name,email,office FROM Advisor WHERE advisor_id = @advisorID";
                using (SqlCommand command = new SqlCommand(query, sqlConnection))
                {
                    command.Parameters.AddWithValue("@advisorID", advisorID);
                    SqlDataReader reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        try
                        {
                            a.name = reader.GetString(0);
                        }
                        catch (Exception e)
                        {
                            a.name = "";
                        }
                        try
                        {
                            a.email = reader.GetString(1);
                        }
                        catch (Exception e)
                        {
                            a.email = "";
                        }
                        try
                        {
                            a.office = reader.GetString(2);
                        }
                        catch (Exception e)
                        {
                            a.office = "";
                        }
                    }
                }
                sqlConnection.Close();
            }
        }
    }
}
