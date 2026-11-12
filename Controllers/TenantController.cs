using Microsoft.AspNetCore.Mvc;

namespace BTL_NganHangNhaTro.Controllers
{
    public class TenantController : Controller
    {
        public IActionResult Dashboard()
        {
            return View();
        }

        public IActionResult Wallet()
        {
            return View();
        }

        public IActionResult TransactionHistory()
        {
            return View();
        }

        public IActionResult ContractsAndInvoices()
        {
            return View();
        }



    }
}
