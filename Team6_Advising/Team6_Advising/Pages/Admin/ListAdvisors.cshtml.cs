using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Data;

namespace Team6_Advising.Pages.Admin
{
    public class ListAdvisorsModel : PageModel
    {
        public List<Advisor> advisors = new List<Advisor>();
        public void OnGet()
        {

            try
            {
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "Procedures_AdminListAdvisors";

                    using (SqlCommand command = new SqlCommand(commandText, connection) { CommandType = CommandType.StoredProcedure })
                    {

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                Advisor advisor = new Advisor();
                                advisor.advisor_id = reader.GetInt32(0);
                                advisor.advisor_name = reader.GetString(1);
                                advisor.email = reader.GetString(2);
                                advisor.office = reader.GetString(3);
                                advisor.password = reader.GetString(4);
                                advisors.Add(advisor);
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

        public class Advisor
        {
            public int advisor_id;
            public String advisor_name;
            public String email;
            public String office;
            public String password;
        }
    }
}
