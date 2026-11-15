
using BTL_NganHangNhaTro.Data;
using BTL_NganHangNhaTro.Models;
using BTL_NganHangNhaTro.Models.ViewModels;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace BTL_NganHangNhaTro.Controllers
{
    public class AccountController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly PasswordHasher<User> _passwordHasher;

        public AccountController(ApplicationDbContext context)
        {
            _context = context;
            _passwordHasher = new PasswordHasher<User>();
        }

        // GET: Account/Register
        [HttpGet]
        public IActionResult Register()
        {
            return View();
        }

        // POST: Account/Register
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Register(RegisterViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            bool phoneExists = await _context.Users
                .AnyAsync(user => user.PhoneNumber == model.PhoneNumber);

            if (phoneExists)
            {
                ModelState.AddModelError(
                    nameof(model.PhoneNumber),
                    "Số điện thoại đã được đăng ký."
                );

                return View(model);
            }

            var user = new User
            {
                PhoneNumber = model.PhoneNumber,
                FullName = model.FullName,
                Role = "TENANT",
                Status = "ACTIVE"
            };

            user.PasswordHash = _passwordHasher.HashPassword(
                user,
                model.Password
            );

            _context.Users.Add(user);

            await _context.SaveChangesAsync();

            TempData["SuccessMessage"] = "Đăng ký tài khoản thành công!";

            return RedirectToAction(nameof(Login));
        }

        // GET: Account/Login
        [HttpGet]
        public IActionResult Login()
        {
            return View();
        }

        // POST: Account/Login
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Login(LoginViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            var user = await _context.Users
                .FirstOrDefaultAsync(
                    user => user.PhoneNumber == model.PhoneNumber
                );

            if (user == null)
            {
                ModelState.AddModelError(
                    string.Empty,
                    "Số điện thoại hoặc mật khẩu không chính xác."
                );

                return View(model);
            }

            if (user.Status != "ACTIVE")
            {
                ModelState.AddModelError(
                    string.Empty,
                    "Tài khoản của bạn đã bị khóa."
                );

                return View(model);
            }

            var passwordResult = _passwordHasher.VerifyHashedPassword(
                user,
                user.PasswordHash,
                model.Password
            );

            if (passwordResult == PasswordVerificationResult.Failed)
            {
                ModelState.AddModelError(
                    string.Empty,
                    "Số điện thoại hoặc mật khẩu không chính xác."
                );

                return View(model);
            }

            // Create user claims.
            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Name, user.FullName),
                new Claim(ClaimTypes.Role, user.Role),
                new Claim("PhoneNumber", user.PhoneNumber)
            };

            var identity = new ClaimsIdentity(
                claims,
                CookieAuthenticationDefaults.AuthenticationScheme
            );

            var principal = new ClaimsPrincipal(identity);

            // Configure authentication cookie.
            var authenticationProperties = new AuthenticationProperties
            {
                IsPersistent = model.RememberMe
            };

            if (model.RememberMe)
            {
                authenticationProperties.ExpiresUtc =
                    DateTimeOffset.UtcNow.AddDays(30);
            }

            await HttpContext.SignInAsync(
                CookieAuthenticationDefaults.AuthenticationScheme,
                principal,
                authenticationProperties
            );

            // Redirect based on user role.
            switch (user.Role)
            {
                case "ADMIN":
                    return RedirectToAction(
                        "Accounts",
                        "Admin"
                    );

                case "LANDLORD":
                    return RedirectToAction(
                        "Dashboard",
                        "Landlord"
                    );

                case "TENANT":
                    return RedirectToAction(
                        "Dashboard",
                        "Tenant"
                    );

                default:
                    await HttpContext.SignOutAsync(
                        CookieAuthenticationDefaults.AuthenticationScheme
                    );

                    ModelState.AddModelError(
                        string.Empty,
                        "Vai trò tài khoản không hợp lệ."
                    );

                    return View(model);
            }
        }

        // GET: Account/AccessDenied
        [HttpGet]
        public IActionResult AccessDenied()
        {
            return Content("Bạn không có quyền truy cập chức năng này.");
        }

        // GET or POST: Account/Logout
        [HttpGet]
        [HttpPost]
        public async Task<IActionResult> Logout()
        {
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            return RedirectToAction("Login", "Account");
        }
    }
}
