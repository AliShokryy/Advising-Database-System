using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Admin
{
    public class IndexModel : PageModel
    {
        public void OnGet()
        {
        }

        public void OnPostUpdateStatus() {
            int studentId;
            if (int.TryParse(Request.Form["student_id"], out studentId))
            {
                try
                {
                    SqlHelper.DB_CONNECTION.Open();

                    SqlParameter studentParam = new SqlParameter("@student_id", studentId);

                    string commandText = "Procedure_AdminUpdateStudentStatus";
                    SqlHelper.ExecActionProc(commandText, studentParam);

                    ViewData["Message"] = "Updated Student Status Successfully !";
                }
                catch (Exception e)
                {
                    ViewData["Message"] = "Invalid Student ID";
                }
                finally
                {
                    SqlHelper.DB_CONNECTION.Close();
                }
            }
            else
            {
                ViewData["Message"] = "Invalid Student ID";
            }
        }

        public void OnPostIssueInstallmetns()
        {
            int paymentId;
            if (int.TryParse(Request.Form["payment_id"], out paymentId))
            {
                try
                {
                    SqlHelper.DB_CONNECTION.Open();

                    SqlParameter paymentParam = new SqlParameter("payment_id", paymentId);

                    string commandText = "Procedures_AdminIssueInstallment";
                    SqlHelper.ExecActionProc(commandText, paymentParam);

                    ViewData["Message"] = "Issued Installments Successfully !";
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.ToString());
                    ViewData["Message"] = "Invalid Payment ID";
                }
                finally
                {
                    SqlHelper.DB_CONNECTION.Close();
                }
            }
            else
            {
                ViewData["Message"] = "Invalid Payment ID";
            }
        }

    }
}
