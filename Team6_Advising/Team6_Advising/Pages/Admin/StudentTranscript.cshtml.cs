using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Admin
{
    public class StudentTranscriptModel : PageModel
    {
        public List<StudentTranscrip> studentTranscrips = new List<StudentTranscrip>();
        public void OnGet()
        {

            try
            {
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "SELECT * FROM Students_Courses_transcript";

                    using (SqlCommand command = new SqlCommand(commandText, connection))
                    {

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                StudentTranscrip studentTranscrip = new StudentTranscrip();
                                studentTranscrip.student_id = reader.GetInt32(0);
                                studentTranscrip.student_fname = reader.GetString(1);
                                studentTranscrip.student_lname = reader.GetString(2);
                                studentTranscrip.course_id = reader.GetInt32(3);
                                studentTranscrip.course_name = reader.GetString(4);
                                studentTranscrip.type = reader.GetString(5);
                                studentTranscrip.grade = reader.GetString(6);
                                studentTranscrip.semester_code = reader.GetString(7);
                                studentTranscrips.Add(studentTranscrip);
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

        public class StudentTranscrip
        {
            public int student_id;
            public String student_fname;
            public String student_lname;
            public int course_id;
            public String course_name;
            public String type;
            public String grade;
            public String semester_code;
        }
    }
}
