using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Advisor
{
    public class ViewAllPendingRequestsModel : PageModel
    {
        public List<request> requestList = new List<request>();
        public class request
        {
            public int requestID;
            public string requestType;
            public string requestComment;
            public string requestStatus;
            public String creditHours;
            public String courseID;
            public int studentID;
        }
        public void OnPost(String? id)
        {
            int advisorID = Int32.Parse(id);
            int requestID = Int32.Parse(Request.Form["requestID"]);
            string requestType = Request.Form["requestType"];
            string currSemCode = Request.Form["semesterCode"];
            try
            {
                Console.WriteLine("requestID: " + requestID);
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    using (SqlCommand command = new SqlCommand())
                    {
                        command.Connection = connection;
                        if(requestType.Contains("credit"))
                        {
                            command.CommandText = "Procedures_AdvisorApproveRejectCHRequest";
                            command.CommandType = System.Data.CommandType.StoredProcedure;
                            command.Parameters.AddWithValue("@requestID", requestID);
                            //command.Parameters.AddWithValue("@Request_Type", requestType);
                            command.Parameters.AddWithValue("@current_sem_code", currSemCode);
                        }
                        if (requestType.Contains("course"))
                        {
                            command.CommandText = "Procedures_AdvisorApproveRejectCourseRequest";
                            command.CommandType = System.Data.CommandType.StoredProcedure;
                            command.Parameters.AddWithValue("@requestID", requestID);
                            //command.Parameters.AddWithValue("@Request_Type", requestType);
                            command.Parameters.AddWithValue("@current_semester_code", currSemCode);
                        }
                        
                        //command.CommandType = System.Data.CommandType.StoredProcedure;
                        //command.Parameters.AddWithValue("@requestID", requestID);
                        ////command.Parameters.AddWithValue("@Request_Type", requestType);
                        //command.Parameters.AddWithValue("@current_sem_code", currSemCode);
                        command.ExecuteNonQuery();
                        //Response.Redirect("/Advisor/ViewAllPendingRequests?id=" + advisorID);
                        connection.Close();
                        OnGet(id);
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
            }
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
                            request r = new request();
                            r.requestID = reader.GetInt32(0);
                            r.requestType = reader.GetString(1);
                            r.requestComment = reader.GetString(2);
                            r.requestStatus = reader.GetString(3);
                            try
                            {
                                r.creditHours = reader.GetInt32(4)+"";
                            }
                            catch (Exception e)
                            {
                                r.creditHours = "";
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
