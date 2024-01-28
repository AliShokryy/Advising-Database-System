using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using static Team6_Advising.Pages.Students.GraduationPlanModel;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Students
{
    public class AllCoursesModel : PageModel
    {
        public List <courseExam> courseExams = new List<courseExam>();
        public void OnGet()
        {
            try
            {
            
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "SELECT * FROM Courses_MakeupExams";

                    using (SqlCommand command = new SqlCommand(commandText, connection))
                    {

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                courseExam courseExam = new courseExam();
                                courseExam.Exam_Id = reader.GetInt32(0);
                                courseExam.Exam_Date = reader.GetDateTime(1);
                                courseExam.Exam_Type = reader.GetString(2);
                                courseExam.Course_Id = reader.GetInt32(3);
                                courseExam.Course_Name = reader.GetString(4);
                                courseExam.Course_Semester = reader.GetInt32(5);
                                courseExams.Add(courseExam);    
                            }
                        }

                    }
                    connection.Close();
                }
            }
            catch (Exception e)
            {
                ViewData["Message"] = "error";
                Console.WriteLine(e.ToString());
            }

        }
    }
        public class courseExam
        {
            public int Exam_Id;
            public DateTime Exam_Date;
            public string Exam_Type;
            public int Course_Id;
            public string Course_Name;
            public int Course_Semester;

        }

    }
    

