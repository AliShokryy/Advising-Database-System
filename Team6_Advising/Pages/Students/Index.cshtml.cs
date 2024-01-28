using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Students
{
    public class IndexModel : PageModel
    {
        public student s= new student();
        public String id;
        public class student
        {
            public string id;
            public string name;
            public string gpa;
            public string faculty;
            public string email;
            public string major;
            public string semester;
            public string acquired_hours;
            public string assigned_hours;
            public string advisor_id;
            public string advisor_name;
        }
        public void OnGet()
        {
            
            id = Request.Query["id"];
            //string studentID = int.Parse(id) + "";
            if (id != null)
            {
                s.id = id;
                int studentID = int.Parse(id);
                string connection = Environment.GetEnvironmentVariable("connectionString");
                using (SqlConnection sqlConnection = new SqlConnection(connection))
                {
                    sqlConnection.Open();
                    string query = "SELECT S.f_name + ' ' + S.l_name , S.gpa , S.faculty , S.email , S.major , S.semester , S.acquired_hours ,S.assigned_hours ,A.advisor_id , A.advisor_name FROM Advisor A INNER JOIN Student S ON(S.advisor_id = A.advisor_id) WHERE S.student_id = @studentID";
                    using (SqlCommand command = new SqlCommand(query, sqlConnection))
                    {
                        command.Parameters.AddWithValue("@studentID", studentID);
                        SqlDataReader reader = command.ExecuteReader();
                        while (reader.Read())
                        {
                            try
                            {
                                s.name = reader.GetString(0);
                            }
                            catch (Exception e)
                            {
                                s.name = "";
                            }
                            try
                            {
                                s.gpa = reader.GetInt32(1) + "";
                            }
                            catch (Exception e)
                            {
                                s.gpa = "";
                            }
                            try
                            {
                                s.faculty = reader.GetString(2);
                            }
                            catch (Exception e)
                            {
                                s.faculty = "";
                            }
                            try
                            {
                                s.email = reader.GetString(3);
                            }
                            catch (Exception e)
                            {
                                s.email = "";
                            }
                            try
                            {
                                s.major = reader.GetString(4);
                            }
                            catch (Exception e)
                            {
                                s.major = "";
                            }
                            try
                            {
                                s.semester = reader.GetString(5);
                            }
                            catch (Exception e)
                            {
                                s.semester = "";
                            }
                            try
                            {
                                s.acquired_hours = reader.GetInt32(6) + "";
                            }
                            catch (Exception e)
                            {
                                s.acquired_hours = "";
                            }
                            try
                            {
                                s.assigned_hours = reader.GetInt32(7) + "";
                            }
                            catch (Exception e)
                            {
                                s.assigned_hours = "";
                            }
                            try
                            {
                                s.advisor_id = reader.GetInt32(8) + "";
                            }
                            catch (Exception e)
                            {
                                s.advisor_id = "";
                            }
                            try
                            {
                                s.advisor_name = reader.GetString(9);
                            }
                            catch (Exception e)
                            {
                                s.advisor_name = "";
                            }
                        }
                    }
                    sqlConnection.Close();
                }
            }
           
        }



    }
}
