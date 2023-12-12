using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace Team6_Advising.Pages.Advisor
{
    public class AdvisorMenuModel : PageModel
    {
        public void OnGet()
        {
            // This is how you get the id from the URL
            //int advisorId = int.Parse(Request.Query["id"]);
            //Console.WriteLine("Advisor Id: " + advisorId);
        }
    }
    
}
