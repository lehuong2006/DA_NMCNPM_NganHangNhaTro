using Microsoft.AspNetCore.Mvc;

namespace BTL_NganHangNhaTro.Controllers
{
    public class HomeController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
