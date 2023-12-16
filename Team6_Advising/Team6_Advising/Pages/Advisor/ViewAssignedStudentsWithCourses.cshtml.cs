using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using static Team6_Advising.Pages.Advisor.ViewStudentsModel;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Advisor
{
    public class ViewAssignedStudentsWithCoursesModel : PageModel
    {
        public List<StudentWithCourses> studentWithCoursesList = new List<StudentWithCourses>();
        public class StudentWithCourses
        {
            public int id;
            public string name;
            public string major;
            public string course_name;
        }
        public void OnGet()
        {
        }
        public void OnPost(String? id)
        {
            int advisorID = int.Parse(id);
            bool major_exists = false;
            try
            {
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "Procedures_AdvisorViewAssignedStudents";
                    string major = Request.Form["major"];
                    string commandText1 = "SELECT major From Student";
                    using (SqlCommand command1 = new SqlCommand(commandText1, connection))
                    {

                        SqlDataReader reader = command1.ExecuteReader();
                        while (reader.Read())
                        {
                            if (reader.GetString(0).Equals(major))
                            {
                                major_exists = true;
                                break;
                            }
                        }
                        reader.Close();
                    }
                    if (major_exists) {
                        using (SqlCommand command = new SqlCommand(commandText, connection))
                        {
                            command.CommandType = System.Data.CommandType.StoredProcedure;
                            command.Parameters.Add(new SqlParameter("@AdvisorID", advisorID));
                            command.Parameters.Add(new SqlParameter("@major", major));
                            SqlDataReader reader = command.ExecuteReader();
                            while (reader.Read())
                            {
                                StudentWithCourses student = new StudentWithCourses();
                                student.id = reader.GetInt32(0);
                                student.name = reader.GetString(1);
                                student.major = reader.GetString(2);
                                try
                                {
                                    student.course_name = reader.GetString(3);
                                }
                                catch (Exception e)
                                {
                                    student.course_name = "";
                                }
                                studentWithCoursesList.Add(student);
                            }
                        }
                    }
                    else
                    {
                        ViewData["Message"] = "Major does not exist";
                    }                    
                    connection.Close();
                }
                }
            catch (Exception e)
            {
                ViewData["Message"] = "Course not deleted";
                Console.WriteLine(e.ToString());
            }
        }
    }
}
