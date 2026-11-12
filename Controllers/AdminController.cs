using Microsoft.AspNetCore.Mvc;

namespace BTL_NganHangNhaTro.Controllers
{
    public class AdminController : Controller
    {
        public IActionResult Accounts()
        {
            return View();
        }

        public IActionResult Roles()
        {
            return View();
        }

    }
}
