using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Admin
{
    public class IssueInstallmentsModel : PageModel
    {
        public void OnGet()
        {
        }

        public void OnPost()
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

                    Console.WriteLine("Successful Operation !");
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.Message);
                }
                finally
                {
                    SqlHelper.DB_CONNECTION.Close();
                }
            }
            else
            {
                Console.WriteLine("Invalid input");
            }
        }
    }
}
