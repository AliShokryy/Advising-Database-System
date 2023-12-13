using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Advisor
{
    public class ViewAllPendingRequestsModel : PageModel
    {
        public List<Request> requestList = new List<Request>();
        public class Request
        {
            public int requestID;
            public string requestType;
            public string requestComment;
            public string requestStatus;
            public int creditHours;
            public String courseID;
            public int studentID;
        }
        public void OnGet(String? id)
        {
            int advisorID = Int32.Parse(id);
            try
            {
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    using (SqlCommand command = new SqlCommand())
                    {
                        command.Connection = connection;
                        command.CommandText = "Procedures_AdvisorViewPendingRequests";
                        command.CommandType = System.Data.CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@Advisor_ID", advisorID);
                        SqlDataReader reader = command.ExecuteReader();
                        while (reader.Read())
                        {
                            Request r = new Request();
                            r.requestID = reader.GetInt32(0);
                            r.requestType = reader.GetString(1);
                            r.requestComment = reader.GetString(2);
                            r.requestStatus = reader.GetString(3);
                            try
                            {
                                r.creditHours = reader.GetInt32(4);
                            }
                            catch (Exception e)
                            {
                                r.creditHours = 0;
                            }
                            try {                                
                                r.courseID = reader.GetInt32(5) + " ";
                                    }
                            catch (Exception e)
                            {
                                r.courseID = "";
                            }
                            r.studentID = reader.GetInt32(6);
                            requestList.Add(r);
                        }
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
            }
        }
    }
}
