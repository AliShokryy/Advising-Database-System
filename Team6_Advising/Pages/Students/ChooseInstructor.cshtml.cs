using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Students
{
    public class ChooseInstructorModel : PageModel
    {
        public void OnGet()
        {
        }
        public void OnPost(String? id) {
            try
            {
                int student_id = int.Parse(id);
                int instructor_id = int.Parse(Request.Form["instructor_id"]);
                int course_id = int.Parse(Request.Form["course_id"]);
                String semester_code = Request.Form["semester_code"];
                bool sem_exists = false;
                bool instructor_exists = false;
                bool already_chosen = false;
                String connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText1 = "SELECT semester_code From Semester";
                    using (SqlCommand command1 = new SqlCommand(commandText1, connection))
                    {

                        SqlDataReader reader = command1.ExecuteReader();
                        while (reader.Read())
                        {
                            if (reader.GetString(0).Equals(semester_code))
                            {
                                sem_exists = true;
                                break;
                            }
                        }
                        reader.Close();
                    }
                    string commandText2 = "SELECT * From Instructor_Course";
                    using (SqlCommand command2 = new SqlCommand(commandText2, connection))
                    {

                        SqlDataReader reader = command2.ExecuteReader();
                        while (reader.Read())
                        {
                            if (reader.GetInt32(1) == instructor_id && reader.GetInt32(0) == course_id)
                            {
                                instructor_exists = true;
                                break;
                            }
                        }
                        reader.Close();
                    }

                    string commandText3 = "SELECT course_id,instructor_id From Student_Instructor_Course_Take";
                    using (SqlCommand command3 = new SqlCommand(commandText3, connection))
                    {

                        SqlDataReader reader = command3.ExecuteReader();
                        while (reader.Read())
                        {
                            if (reader.GetInt32(0) == course_id && !reader.IsDBNull(1)&& reader.GetInt32(1) == instructor_id)
                            {
                                already_chosen = true;
                                break;
                            }
                        }
                        reader.Close();
                    }
                    
                    string commandText = "Procedures_Chooseinstructor";
                    if (sem_exists && instructor_exists && !already_chosen)
                    {
                        using (SqlCommand command = new SqlCommand(commandText, connection) { CommandType = CommandType.StoredProcedure })
                        {
                            command.Parameters.Add(new SqlParameter("@StudentID", student_id));
                            command.Parameters.Add(new SqlParameter("@instrucorID", instructor_id));
                            command.Parameters.Add(new SqlParameter("@CourseID", course_id));
                            command.Parameters.Add(new SqlParameter("@current_semester_code", semester_code));
                            command.ExecuteNonQuery();
                        }
                        ViewData["Message"] = "Instructor Chosen Successfully";
                    }
                    else if(already_chosen)
                    {
                        ViewData["Message"] = "Instructor already chosen for this course";
                    }
                    else if(!sem_exists)
                    {
                        ViewData["Message"] = "Invalid Semester Code";
                    }
                    else
                    {
                        ViewData["Message"] = "Instructor doesn't teach this course";
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
}
