using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Students
{
    public class CourseSlotsModel : PageModel
    {
        public List<courseSlot> courseSlots = new List<courseSlot>();
        public void OnGet()
        {
            try
            {

                string connectionString = Environment.GetEnvironmentVariable("ConnectionString");
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string commandText = "SELECT * FROM Courses_Slots_Instructor";

                    using (SqlCommand command = new SqlCommand(commandText, connection))
                    {

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                courseSlot courseSlot = new courseSlot();
                                courseSlot.Course_Id = reader.GetInt32(0);
                                courseSlot.Course_Name = reader.GetString(1);
                                courseSlot.Slot_Id = reader.GetInt32(2);
                                courseSlot.Slot_Day = reader.GetString(3);
                                courseSlot.Slot_Time = reader.GetString(4);
                                courseSlot.Slot_Location = reader.GetString(5);
                                courseSlot.Course_Id2 = reader.GetInt32(6);
                                courseSlot.Instructor_Id = reader.GetInt32(7);
                                courseSlot.Instructor_Name = reader.GetString(8);
                                courseSlots.Add(courseSlot);    
                               
                            }
                        }

                    }
                    connection.Close();
                }
            }
            catch (SqlException e)
            {
                ViewData["Message"] = "error";
                Console.WriteLine(e.ToString());
            }

        }
    }
        public class courseSlot
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
    

