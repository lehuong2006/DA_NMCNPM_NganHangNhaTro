using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using BTL_NganHangNhaTro.Data;

namespace BTL_NganHangNhaTro.Controllers
{
    public class DatabaseController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<DatabaseController> _logger;
        private readonly IWebHostEnvironment _environment;

        public DatabaseController(
            ApplicationDbContext context,
            ILogger<DatabaseController> logger,
            IWebHostEnvironment environment)
        {
            _context = context;
            _logger = logger;
            _environment = environment;
        }

        public async Task<IActionResult> Check()
        {
            try
            {
                bool isConnected = await _context.Database.CanConnectAsync();

                if (isConnected)
                {
                    return Content("Kết nối SQL Server thành công!");
                }

                return StatusCode(
                    500,
                    "Không thể kết nối đến database."
                );
            }
            catch (Exception exception)
            {
                _logger.LogError(exception, "Database connection failed.");

                if (_environment.IsDevelopment())
                {
                    return StatusCode(500, exception.Message);
                }

                return StatusCode(
                    500,
                    "Đã xảy ra lỗi khi kết nối database."
                );
            }
        }
    }
}
