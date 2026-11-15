using BTL_NganHangNhaTro.Data;
using BTL_NganHangNhaTro.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace BTL_NganHangNhaTro.Controllers
{
    public class TenantController : Controller
    {
        private readonly ApplicationDbContext _context;

        public TenantController(ApplicationDbContext context)
        {
            _context = context;
        }

        private long GetCurrentUserId()
        {
            var claim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (claim != null && long.TryParse(claim.Value, out var id))
            {
                return id;
            }
            return 0;
        }

        // ==========================================
        // 1. DASHBOARD KHÁCH THUÊ
        // ==========================================
        public async Task<IActionResult> Dashboard()
        {
            long userId = GetCurrentUserId();

            // Tìm hợp đồng của khách thuê
            var contract = await _context.Contracts
                .Include(c => c.Room)
                .Where(c => c.TenantId == userId && c.Status == "ACTIVE")
                .OrderByDescending(c => c.CreatedAt)
                .FirstOrDefaultAsync();

            ViewBag.Contract = contract;

            // Hóa đơn của phòng / hợp đồng
            List<Invoice> invoices = new List<Invoice>();
            if (contract != null)
            {
                invoices = await _context.Invoices
                    .Where(i => i.ContractId == contract.Id)
                    .OrderByDescending(i => i.CreatedAt)
                    .ToListAsync();
            }

            ViewBag.Invoices = invoices;

            // Thống kê hóa đơn tháng này
            var currentMonth = DateTime.Now.ToString("yyyy-MM");
            var currentInvoice = invoices.FirstOrDefault(i => i.MonthYear == currentMonth);
            ViewBag.CurrentInvoice = currentInvoice;

            var totalPaid = invoices.Where(i => i.Status == "PAID").Sum(i => i.TotalAmount);
            ViewBag.TotalPaid = totalPaid;

            // Dịch vụ đang dùng
            var services = await _context.ServicePrices.Where(s => s.IsActive).ToListAsync();
            ViewBag.Services = services;

            return View();
        }

        // ==========================================
        // 2. VÍ CỦA TÔI
        // ==========================================
        public async Task<IActionResult> Wallet()
        {
            long userId = GetCurrentUserId();

            var wallet = await _context.Wallets
                .Include(w => w.Transactions)
                .FirstOrDefaultAsync(w => w.UserId == userId);

            if (wallet == null && userId > 0)
            {
                wallet = new Wallet
                {
                    UserId = userId,
                    Balance = 0,
                    Status = "ACTIVE",
                    UpdatedAt = DateTime.Now
                };
                _context.Wallets.Add(wallet);
                await _context.SaveChangesAsync();
            }

            ViewBag.Wallet = wallet;

            var landlord = await _context.Users.FirstOrDefaultAsync(u => u.Role == "LANDLORD");
            ViewBag.Landlord = landlord;

            return View();
        }

        // ==========================================
        // 3. LỊCH SỬ GIAO DỊCH
        // ==========================================
        public async Task<IActionResult> TransactionHistory()
        {
            long userId = GetCurrentUserId();

            var wallet = await _context.Wallets.FirstOrDefaultAsync(w => w.UserId == userId);
            List<Transaction> transactions = new List<Transaction>();

            if (wallet != null)
            {
                transactions = await _context.Transactions
                    .Where(t => t.WalletId == wallet.Id)
                    .OrderByDescending(t => t.CreatedAt)
                    .ToListAsync();
            }

            ViewBag.Wallet = wallet;
            ViewBag.WalletBalance = wallet?.Balance ?? 0;
            ViewBag.TotalTopup = transactions.Where(t => t.Type == "TOPUP").Sum(t => t.Amount);
            ViewBag.TotalExpense = transactions.Where(t => t.Type == "PAYMENT").Sum(t => t.Amount);
            ViewBag.Transactions = transactions;

            return View(transactions);
        }

        // ==========================================
        // 4. HỢP ĐỒNG VÀ HÓA ĐƠN
        // ==========================================
        public async Task<IActionResult> ContractsAndInvoices()
        {
            long userId = GetCurrentUserId();

            // Tìm hợp đồng của khách thuê
            var contract = await _context.Contracts
                .Include(c => c.Room)
                .Where(c => c.TenantId == userId && c.Status == "ACTIVE")
                .OrderByDescending(c => c.CreatedAt)
                .FirstOrDefaultAsync();

            ViewBag.Contract = contract;

            List<Invoice> invoices = new List<Invoice>();
            if (contract != null)
            {
                invoices = await _context.Invoices
                    .Include(i => i.InvoiceItems)
                    .Where(i => i.ContractId == contract.Id)
                    .OrderByDescending(i => i.CreatedAt)
                    .ToListAsync();
            }

            ViewBag.Invoices = invoices;

            return View();
        }

        // ==========================================
        // 5. GỬI YÊU CẦU NẠP TIỀN
        // ==========================================
        [HttpPost]
        public async Task<IActionResult> SubmitTopup([FromBody] SubmitTopupDto request)
        {
            long userId = GetCurrentUserId();
            if (userId == 0)
                return Json(new { success = false, message = "Bạn cần đăng nhập để thực hiện chức năng này." });

            if (request == null || request.Amount <= 0)
                return Json(new { success = false, message = "Số tiền nạp không hợp lệ." });

            if (string.IsNullOrWhiteSpace(request.Content))
                return Json(new { success = false, message = "Vui lòng nhập nội dung chuyển khoản." });

            try
            {
                // Tìm hoặc tạo ví
                var wallet = await _context.Wallets.FirstOrDefaultAsync(w => w.UserId == userId);
                if (wallet == null)
                {
                    wallet = new Wallet
                    {
                        UserId = userId,
                        Balance = 0,
                        Status = "ACTIVE",
                        UpdatedAt = DateTime.Now
                    };
                    _context.Wallets.Add(wallet);
                    await _context.SaveChangesAsync();
                }

                // Tạo yêu cầu nạp tiền với status PENDING
                var topupRequest = new TopupRequest
                {
                    WalletId = wallet.Id,
                    Amount = request.Amount,
                    TransactionCode = request.Content,
                    Status = "PENDING",
                    CreatedAt = DateTime.Now
                };

                _context.TopupRequests.Add(topupRequest);
                await _context.SaveChangesAsync();

                return Json(new { success = true, message = "Yêu cầu nạp tiền đã được gửi thành công! Vui lòng chờ chủ trọ xác nhận." });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = "Đã xảy ra lỗi khi gửi yêu cầu: " + ex.Message });
            }
        }

        public class SubmitTopupDto
        {
            public long Amount { get; set; }
            public string Content { get; set; } = string.Empty;
        }

        // Thanh toán hóa đơn bằng ví
        [HttpPost]
        public async Task<IActionResult> PayInvoice(long invoiceId)
        {
            long userId = GetCurrentUserId();
            var wallet = await _context.Wallets.FirstOrDefaultAsync(w => w.UserId == userId);
            if (wallet == null)
            {
                return Json(new { success = false, message = "Không tìm thấy thông tin ví của bạn." });
            }

            var invoice = await _context.Invoices.FindAsync(invoiceId);
            if (invoice == null)
            {
                return Json(new { success = false, message = "Không tìm thấy hóa đơn." });
            }

            if (invoice.Status == "PAID")
            {
                return Json(new { success = false, message = "Hóa đơn này đã được thanh toán rồi." });
            }

            if (wallet.Balance < invoice.RemainingAmount)
            {
                return Json(new { success = false, message = "Số dư trong ví không đủ để thanh toán hóa đơn này. Vui lòng nạp thêm tiền vào ví!" });
            }

            // Trừ tiền
            wallet.Balance -= invoice.RemainingAmount;
            wallet.UpdatedAt = DateTime.Now;

            // Ghi lịch sử giao dịch
            var transaction = new Transaction
            {
                WalletId = wallet.Id,
                InvoiceId = invoice.Id,
                Amount = invoice.RemainingAmount,
                BalanceAfter = wallet.Balance,
                Type = "PAYMENT",
                Description = $"Thanh toán hóa đơn {invoice.InvoiceCode} kỳ {invoice.MonthYear}",
                CreatedAt = DateTime.Now
            };

            invoice.RemainingAmount = 0;
            invoice.Status = "PAID";

            _context.Transactions.Add(transaction);
            await _context.SaveChangesAsync();

            return Json(new { success = true, message = "Thanh toán hóa đơn thành công!" });
        }
    }
}
