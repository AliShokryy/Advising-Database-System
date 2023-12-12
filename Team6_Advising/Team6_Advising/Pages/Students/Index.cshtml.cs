using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace Team6_Advising.Pages.Students
{
    public class IndexModel : PageModel
    {
        public String id;
        public void OnGet()
        {
            id = Request.Query["id"];
        }
          
      

    }
}
