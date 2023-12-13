using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Advisor
{
    public class ViewAllRequestsModel : PageModel
    {
        public List<Request> requestList = new List<Request>();
        public class Request
        {
            public int requestId;
            public string requestType;
            public string requestComment;
            public string requestStatus;
            public int studentId;
            public string studentName;
        }
        public void OnGet(String? id)
        {
            int advisorId = int.Parse(id);
            try
            {
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "SELECT R.request_id,R.type,R.comment,R.status,R.student_id,S.f_name + ' ' +S.l_name FROM Request R INNER JOIN Student S ON (S.student_id=R.student_id) WHERE R.advisor_id = @advisor_Id";

                    using (SqlCommand command = new SqlCommand(commandText, connection))
                    {
                        command.Parameters.Add(new SqlParameter("@advisor_Id", advisorId));
                        SqlDataReader reader = command.ExecuteReader();
                        while (reader.Read())
                        {
                            Request request = new Request();
                            request.requestId = reader.GetInt32(0);
                            request.requestType = reader.GetString(1);
                            request.requestComment = reader.GetString(2);
                            request.requestStatus = reader.GetString(3);
                            request.studentId = reader.GetInt32(4);
                            request.studentName = reader.GetString(5);
                            requestList.Add(request);
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
    }
}
