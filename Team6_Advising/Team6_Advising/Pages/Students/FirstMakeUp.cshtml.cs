using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Students
{
    public class FirstMakeUpModel : PageModel
    {
        public List<StudentExam> studentExams = new List<StudentExam>();
        public void OnGet(String? id)
        {
            try
            {
                int student_id = int.Parse(id);
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "SELECT Es.* FROM Exam_Student Es INNER JOIN MakeUp_Exam Me ON Es.exam_id = Me.exam_id WHERE student_id =" + student_id + "AND Me.type = 'First_makeup'";
                    using (SqlCommand command = new SqlCommand(commandText, connection))
                    {                        
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                StudentExam studentExam = new StudentExam();
                                studentExam.exam_id = reader.GetInt32(0);
                                studentExam.student_id = reader.GetInt32(1);
                                studentExam.course_id = reader.GetInt32(2);
                                studentExams.Add(studentExam);
                            }

                        }
                        
                    }

                }
            }
            catch (Exception e)
            {
                ViewData["Message"] = "error";
                Console.WriteLine(e.ToString());
            }
        }
        public void OnPost(String? id)
        {
            try
            {
                int student_id = int.Parse(id);
                int course_id = int.Parse(Request.Form["course_id"]);
                String current_sem = Request.Form["current_sem"];
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "Procedures_StudentRegisterFirstMakeup";
                    using (SqlCommand command = new SqlCommand(commandText, connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add(new SqlParameter("@StudentID", student_id));
                        command.Parameters.Add(new SqlParameter("@courseID", course_id));
                        command.Parameters.Add(new SqlParameter("@studentCurr_sem", current_sem));
                        command.ExecuteNonQuery();
                    }
                    connection.Close();
                    OnGet(id);
                }

            }
            catch (SqlException e)
            {
                ViewData["Message"] = "error";
                Console.WriteLine(e.ToString());
            }


        }

        public class StudentExam
        {
            public int exam_id;
            public int student_id;
            public int course_id;
        }
    }
}
