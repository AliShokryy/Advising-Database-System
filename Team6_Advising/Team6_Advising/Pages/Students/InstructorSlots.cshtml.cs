using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Students
{
    public class InstructorSlotsModel : PageModel
    {
        public List<InstructorSlot> instructorSlots = new List<InstructorSlot>();
        public void OnGet()
        {
        }
        public void OnPost() {
            try
            {
                
                int course_id = int.Parse(Request.Form["course_id"]);
                int instructor_id = int.Parse(Request.Form["instructor_id"]);
                bool instructor_exists = false;
                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText1 = "SELECT * From Instructor_Course";
                    using (SqlCommand command1 = new SqlCommand(commandText1, connection))
                    {

                        SqlDataReader reader = command1.ExecuteReader();
                        while (reader.Read())
                        {
                            if (reader.GetInt32(0) == instructor_id && reader.GetInt32(1) == course_id)
                            {
                                instructor_exists = true;
                                break;
                            }
                        }
                        reader.Close();
                    }
                    string commandText = "SELECT * FROM FN_StudentViewSlot(@CourseID,@InstructorID)";
                    if(instructor_exists)
                    {
                        using (SqlCommand command = new SqlCommand(commandText, connection))
                        {
                            command.Parameters.Add(new SqlParameter("@CourseID", course_id));
                            command.Parameters.Add(new SqlParameter("@InstructorID", instructor_id));


                            using (SqlDataReader reader = command.ExecuteReader())
                            {
                                while (reader.Read())
                                {
                                    InstructorSlot instructorSlot = new InstructorSlot();
                                    instructorSlot.Course_Id = reader.GetInt32(0);
                                    instructorSlot.Course_Name = reader.GetString(1);
                                    instructorSlot.Slot_Id = reader.GetInt32(2);
                                    instructorSlot.Slot_Day = reader.GetString(3);
                                    instructorSlot.Slot_Time = reader.GetString(4);
                                    instructorSlot.Slot_Location = reader.GetString(5);
                                    instructorSlot.Course_Id2 = reader.GetInt32(6);
                                    instructorSlot.Instructor_Id = reader.GetInt32(7);
                                    instructorSlot.Instructor_Name = reader.GetString(8);
                                    instructorSlots.Add(instructorSlot);

                                }
                            }

                        }
                    }
                    else
                    {
                        ViewData["Message"] = "Instructor does not teach this course";
                    }
                    connection.Close();
                }
            }
            catch (SqlException e)
            {
                ViewData["Message"] = "error";
                
            }   

        }
        public class InstructorSlot
        {
            public int Course_Id;
            public String Course_Name;
            public int Slot_Id;
            public String Slot_Day;
            public String Slot_Time;
            public String Slot_Location;
            public int Course_Id2;
            public int Instructor_Id;
            public String Instructor_Name;
        }
    }
}
