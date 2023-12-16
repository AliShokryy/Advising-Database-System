using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Data;

namespace Team6_Advising.Pages.Admin
{
    public class ListPendingRequestsModel : PageModel
    {
        public List<Request> pendingRequests = new List<Request>();
        public void OnGet()
        {

            try
            {
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "SELECT * FROM all_Pending_Requests";

                    using (SqlCommand command = new SqlCommand(commandText, connection))
                    {

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                Request request = new Request();
                                request.request_id = reader.GetInt32(0);
                                request.type = reader.GetString(1);
                                request.comment = reader.GetString(2);
                                request.status = reader.GetString(3);
                                request.credit_hours = (reader.IsDBNull(4))? null:reader.GetInt32(4);
                                request.course_id = (reader.IsDBNull(5)) ? null : reader.GetInt32(5);
                                request.student_id = (reader.IsDBNull(6)) ? null : reader.GetInt32(6);
                                request.advisor_id = (reader.IsDBNull(7)) ? null : reader.GetInt32(7);
                                
                                pendingRequests.Add(request);
                            }
                        }

                    }
                    connection.Close();
                }
            }

            catch (Exception e)
            {

                Console.WriteLine(e.ToString());
            }
        }

        public class Request
        {
            public int request_id;
            public String type;
            public String comment;
            public String status;
            public int? credit_hours;
            public int? course_id;
            public int? student_id;
            public int? advisor_id;      
        }
    }
}
