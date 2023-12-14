using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Data;

namespace Team6_Advising.Pages.Admin
{
    public class ListPaymentsModel : PageModel
    {
        public List<StudentPayment> payments = new List<StudentPayment>();

        public void OnGet()
        {
            try
            {
                SqlHelper.DB_CONNECTION.Open();

                string commandText = "SELECT * FROM Student_Payment";
                SqlDataReader reader = SqlHelper.ExecuteReader(commandText, CommandType.Text);
                while(reader.Read())
                {
                    string[] studentInfo = new string[StudentPayment.STUDENT_INFO_LENGTH];
                    string[] paymentInfo = new string[StudentPayment.PAYMENT_INFO_LENGTH];

                    for (int i = 0;i < studentInfo.Length; i++)
                    {
                        studentInfo[i] = reader[i].ToString();
                    }
                    for(int i = 0; i < paymentInfo.Length ; i++)
                    {
                        paymentInfo[i] = reader[i + studentInfo.Length].ToString();
                    }
                    payments.Add(new StudentPayment(studentInfo, paymentInfo));
                }
                
            }

            catch (SqlException e)
            {

                Console.WriteLine(e.ToString());
            }
            finally { 
                SqlHelper.DB_CONNECTION.Close();
            }
        }

        public class StudentPayment
        {

            public const int STUDENT_INFO_LENGTH = 3, PAYMENT_INFO_LENGTH = 7;

            private string[] studentInfo = new string[STUDENT_INFO_LENGTH];
            private string[] paymentInfo = new string[PAYMENT_INFO_LENGTH];

            public string[] StudentInfo { get { return this.studentInfo;} }
            public string[] PaymentInfo { get { return this.paymentInfo; } }
            public StudentPayment(string[] studentInfo, string[] paymentInfo)
            {
                initStudent(studentInfo);
                intiPayment(paymentInfo);
            }
            private void initStudent(string[] studentInfo)
            {
                for (int i = 0; i < STUDENT_INFO_LENGTH; i++)
                {
                    this.studentInfo[i] = studentInfo[i];
                }
            }

            private void intiPayment(string[] paymentInfo)
            {
                for(int i = 0; i < PAYMENT_INFO_LENGTH; i++)
                {
                    this.paymentInfo[i] = paymentInfo[i];
                }
            }

        }
    }

}
