using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Admin
{
    public class LoginModel : PageModel
    {
        const int ADMIN_ID = 1;
        string PASSWORD = "admin";
        
        public void OnGet()
        {
        }

        public void OnPost()
        {

            try
            {
                int adminId = int.Parse(Request.Form["id"]);
                string password = Request.Form["password"];
                if (adminId == ADMIN_ID && password== PASSWORD)
                {
                    Console.WriteLine("Login Successful");
                    Response.Redirect("/Admin/Index?id=1");

                }
                else
                {
                    Console.WriteLine("Login failed");
                    ViewData["Message"] = "Login Failed";

                }
            }
            catch (Exception e)
            {
                ViewData["Message"] = "Admin not found";
                Console.WriteLine(e.ToString());
            }
        }
    }
}
