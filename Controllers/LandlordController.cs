using Microsoft.AspNetCore.Mvc;

namespace BTL_NganHangNhaTro.Controllers
{
    public class LandlordController : Controller
    {
        public IActionResult Dashboard()
        {
            return View();
        }

        public IActionResult Rooms()
        {
            return View();
        }

        public IActionResult RoomForm()
        {
            return View();
        }

        public IActionResult Tenants()
        {
            return View();
        }

        public IActionResult ContractForm()
        {
            return View();
        }

        public IActionResult DepositReceipt()
        {
            return View();
        }

        public IActionResult Invoices()
        {
            return View();
        }

        public IActionResult MeterReading()
        {
            return View();
        }

        public IActionResult WalletTransactions()
        {
            return View();
        }
    }
}
