using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Admin
{
    public class ListStudentsModel : PageModel
    {

        public List<StudentwithAdvisor> student_advisor = new List<StudentwithAdvisor>();
        public void OnGet()
        {
            
            try
            {
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "AdminListStudentsWithAdvisors";

                    using (SqlCommand command = new SqlCommand(commandText, connection) { CommandType = CommandType.StoredProcedure })
                    {

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                StudentwithAdvisor student = new StudentwithAdvisor();
                                student.student_id = reader.GetInt32(0);
                                student.fname = reader.GetString(1);
                                student.lname = reader.GetString(2);
                                student.advisor_id = reader.GetInt32(3);
                                student.advisor_name = reader.GetString(4);
                                student_advisor.Add(student);
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

        public class StudentwithAdvisor
        {
            public int student_id;
            public String fname;
            public String lname;
            public int advisor_id;
            public String advisor_name;
        }
    }
}
