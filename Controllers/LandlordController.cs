using BTL_NganHangNhaTro.Data;
using BTL_NganHangNhaTro.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace BTL_NganHangNhaTro.Controllers
{
    public class LandlordController : Controller
    {
        private readonly ApplicationDbContext _context;

        public LandlordController(ApplicationDbContext context)
        {
            _context = context;
        }

        // ==========================================
        // API HELPER CHO PHÒNG & THÔNG TIN CHỦ TRỌ
        // ==========================================
        [HttpGet]
        public async Task<IActionResult> GetAvailableRooms()
        {
            var rooms = await _context.Rooms
                .Where(r => r.Status == "AVAILABLE")
                .OrderBy(r => r.RoomCode)
                .Select(r => new
                {
                    id = r.Id,
                    roomCode = r.RoomCode,
                    roomName = r.RoomName,
                    price = r.Price,
                    maxTenants = r.MaxTenants,
                    status = r.Status
                })
                .ToListAsync();

            return Json(rooms);
        }

        [HttpGet]
        public async Task<IActionResult> GetAllRooms()
        {
            var rooms = await _context.Rooms
                .OrderBy(r => r.RoomCode)
                .Select(r => new
                {
                    id = r.Id,
                    roomCode = r.RoomCode,
                    roomName = r.RoomName,
                    price = r.Price,
                    maxTenants = r.MaxTenants,
                    status = r.Status
                })
                .ToListAsync();

            return Json(rooms);
        }

        [HttpGet]
        public async Task<IActionResult> GetActiveContractsWithRooms()
        {
            var contracts = await _context.Contracts
                .Include(c => c.Room)
                .Include(c => c.Tenant)
                .Where(c => c.Status == "ACTIVE")
                .Select(c => new
                {
                    contractId = c.Id,
                    roomId = c.RoomId,
                    roomCode = c.Room != null ? c.Room.RoomCode : "",
                    roomName = c.Room != null ? c.Room.RoomName : "",
                    rentalPrice = c.RentalPrice,
                    tenantName = c.Tenant != null ? c.Tenant.FullName : "",
                    tenantPhone = c.Tenant != null ? c.Tenant.PhoneNumber : ""
                })
                .ToListAsync();

            return Json(contracts);
        }

        [HttpGet]
        public async Task<IActionResult> GetServicePrices()
        {
            var prices = await _context.ServicePrices
                .Where(s => s.IsActive)
                .Select(s => new
                {
                    serviceCode = s.ServiceCode,
                    serviceName = s.ServiceName,
                    unitPrice = s.UnitPrice,
                    unit = s.Unit
                })
                .ToListAsync();

            return Json(prices);
        }

        // ==========================================
        // 1. DASHBOARD
        // ==========================================
        public async Task<IActionResult> Dashboard()
        {
            var totalEmpty = await _context.Rooms.CountAsync(r => r.Status == "AVAILABLE");
            var totalDeposit = await _context.Rooms.CountAsync(r => r.Status == "DEPOSIT");
            var totalRented = await _context.Rooms.CountAsync(r => r.Status == "RENTED");
            var totalMaintenance = await _context.Rooms.CountAsync(r => r.Status == "MAINTENANCE");

            ViewBag.TotalEmpty = totalEmpty;
            ViewBag.TotalDeposit = totalDeposit;
            ViewBag.TotalRented = totalRented;
            ViewBag.TotalMaintenance = totalMaintenance;

            // Hóa đơn chưa thanh toán tháng này
            var currentMonth = DateTime.Now.ToString("yyyy-MM");
            var unpaidInvoices = await _context.Invoices
                .Include(i => i.Room)
                .Include(i => i.Contract)
                    .ThenInclude(c => c!.Tenant)
                .Where(i => i.Status != "PAID")
                .OrderByDescending(i => i.CreatedAt)
                .Take(5)
                .ToListAsync();

            ViewBag.UnpaidInvoices = unpaidInvoices;

            return View();
        }

        // ==========================================
        // 2. PHÒNG (ROOMS)
        // ==========================================
        public async Task<IActionResult> Rooms()
        {
            var rooms = await _context.Rooms
                .Include(r => r.Contracts.Where(c => c.Status == "ACTIVE"))
                    .ThenInclude(c => c.Tenant)
                .OrderBy(r => r.RoomCode)
                .ToListAsync();

            return View(rooms);
        }

        public async Task<IActionResult> RoomForm(long? id)
        {
            Room? room = null;
            if (id.HasValue && id.Value > 0)
            {
                room = await _context.Rooms.FindAsync(id.Value);
            }

            ViewBag.ExistingRooms = await _context.Rooms.OrderBy(r => r.RoomCode).ToListAsync();
            return View(room);
        }

        public class SaveRoomRequest
        {
            public long? Id { get; set; }
            public string RoomCode { get; set; } = string.Empty;
            public string? RoomName { get; set; }
            public long Price { get; set; }
            public int MaxTenants { get; set; }
            public string? Status { get; set; }
        }

        [HttpPost]
        public async Task<IActionResult> SaveRoom([FromBody] SaveRoomRequest request)
        {
            try
            {
                if (request == null || string.IsNullOrWhiteSpace(request.RoomCode))
                {
                    return Json(new { success = false, message = "Vui lòng nhập mã phòng." });
                }

                if (request.Price <= 0)
                {
                    return Json(new { success = false, message = "Vui lòng nhập giá thuê hợp lệ." });
                }

                // Lấy ID landlord
                var landlordClaim = User.FindFirst(ClaimTypes.NameIdentifier);
                long landlordId = 1;
                if (landlordClaim != null && long.TryParse(landlordClaim.Value, out var parsedId))
                {
                    landlordId = parsedId;
                }

                string roomCode = request.RoomCode.Trim();
                string status = (request.Status ?? "AVAILABLE").ToUpper();

                if (request.Id.HasValue && request.Id.Value > 0)
                {
                    var room = await _context.Rooms.FindAsync(request.Id.Value);
                    if (room == null)
                    {
                        return Json(new { success = false, message = "Không tìm thấy phòng cần sửa." });
                    }

                    // Kiểm tra trùng mã với phòng khác
                    bool duplicate = await _context.Rooms.AnyAsync(r => r.RoomCode == roomCode && r.Id != request.Id.Value);
                    if (duplicate)
                    {
                        return Json(new { success = false, message = $"Mã phòng {roomCode} đã được sử dụng bởi phòng khác." });
                    }

                    room.RoomCode = roomCode;
                    room.RoomName = !string.IsNullOrWhiteSpace(request.RoomName) ? request.RoomName.Trim() : roomCode;
                    room.Price = request.Price;
                    room.MaxTenants = request.MaxTenants > 0 ? request.MaxTenants : 2;
                    room.Status = status;

                    await _context.SaveChangesAsync();
                    return Json(new { success = true, message = $"Cập nhật thông tin phòng {roomCode} thành công!", roomId = room.Id });
                }
                else
                {
                    // Kiểm tra trùng mã
                    bool exists = await _context.Rooms.AnyAsync(r => r.RoomCode == roomCode);
                    if (exists)
                    {
                        return Json(new { success = false, message = $"Mã phòng {roomCode} đã tồn tại trong hệ thống." });
                    }

                    var newRoom = new Room
                    {
                        LandlordId = landlordId,
                        RoomCode = roomCode,
                        RoomName = !string.IsNullOrWhiteSpace(request.RoomName) ? request.RoomName.Trim() : roomCode,
                        Price = request.Price,
                        MaxTenants = request.MaxTenants > 0 ? request.MaxTenants : 2,
                        Status = status,
                        CreatedAt = DateTime.Now
                    };

                    _context.Rooms.Add(newRoom);
                    await _context.SaveChangesAsync();
                    return Json(new { success = true, message = $"Thêm phòng mới {roomCode} thành công!", roomId = newRoom.Id });
                }
            }
            catch (Exception ex)
            {
                var innerMsg = ex.InnerException != null ? ex.InnerException.Message : ex.Message;
                return Json(new { success = false, message = "Lỗi khi lưu phòng: " + innerMsg });
            }
        }

        [HttpPost]
        public async Task<IActionResult> DeleteRoom(long id)
        {
            try
            {
                var room = await _context.Rooms
                    .Include(r => r.Contracts)
                    .FirstOrDefaultAsync(r => r.Id == id);

                if (room == null)
                {
                    return Json(new { success = false, message = "Không tìm thấy phòng cần xóa." });
                }

                // Kiểm tra hợp đồng còn hiệu lực
                bool hasActiveContract = room.Contracts.Any(c => c.Status == "ACTIVE");
                if (hasActiveContract)
                {
                    return Json(new { success = false, message = "Không thể xóa phòng đang có hợp đồng hiệu lực." });
                }

                // Kiểm tra hóa đơn chưa thanh toán
                bool hasUnpaidInvoices = await _context.Invoices.AnyAsync(i => i.RoomId == room.Id && i.Status == "UNPAID");
                if (hasUnpaidInvoices)
                {
                    return Json(new { success = false, message = "Không thể xóa phòng đang còn hóa đơn chưa thanh toán." });
                }

                // Xóa các dữ liệu phụ thuộc cũ nếu có
                var oldInvoices = await _context.Invoices.Include(i => i.InvoiceItems).Where(i => i.RoomId == room.Id).ToListAsync();
                foreach (var inv in oldInvoices)
                {
                    var txs = await _context.Transactions.Where(t => t.InvoiceId == inv.Id).ToListAsync();
                    _context.Transactions.RemoveRange(txs);
                    _context.InvoiceItems.RemoveRange(inv.InvoiceItems);
                }
                _context.Invoices.RemoveRange(oldInvoices);

                var oldMeters = await _context.MeterReadings.Where(m => m.RoomId == room.Id).ToListAsync();
                _context.MeterReadings.RemoveRange(oldMeters);

                var oldContracts = await _context.Contracts.Where(c => c.RoomId == room.Id).ToListAsync();
                _context.Contracts.RemoveRange(oldContracts);

                _context.Rooms.Remove(room);
                await _context.SaveChangesAsync();

                return Json(new { success = true, message = $"Đã xóa phòng {room.RoomCode} thành công!" });
            }
            catch (Exception ex)
            {
                var innerMsg = ex.InnerException != null ? ex.InnerException.Message : ex.Message;
                return Json(new { success = false, message = "Lỗi khi xóa phòng: " + innerMsg });
            }
        }

        // ==========================================
        // 3. NGƯỜI THUÊ (TENANTS)
        // ==========================================
        public async Task<IActionResult> Tenants()
        {
            var contracts = await _context.Contracts
                .Include(c => c.Room)
                .Include(c => c.Tenant)
                .Where(c => c.Status == "ACTIVE")
                .OrderByDescending(c => c.CreatedAt)
                .ToListAsync();

            var totalTenants = contracts.Select(c => c.TenantId).Distinct().Count();
            var activeContracts = contracts.Count;
            var today = DateOnly.FromDateTime(DateTime.Today);
            var expiring = contracts.Count(c => c.EndDate.HasValue && c.EndDate.Value <= today.AddDays(30) && c.EndDate.Value >= today);
            var expired = contracts.Count(c => c.EndDate.HasValue && c.EndDate.Value < today);

            ViewBag.TotalTenants = totalTenants;
            ViewBag.ActiveContracts = activeContracts;
            ViewBag.Expiring = expiring;
            ViewBag.Expired = expired;
            ViewBag.Rooms = await _context.Rooms.OrderBy(r => r.RoomCode).ToListAsync();

            return View(contracts);
        }

        // ==========================================
        // 4. HỢP ĐỒNG (CONTRACT FORM)
        // ==========================================
        public async Task<IActionResult> ContractForm(long? roomId)
        {
            // Lấy danh sách phòng còn trống
            var availableRooms = await _context.Rooms
                .Where(r => r.Status == "AVAILABLE" || (roomId.HasValue && r.Id == roomId.Value))
                .OrderBy(r => r.RoomCode)
                .ToListAsync();

            ViewBag.AvailableRooms = availableRooms;
            ViewBag.SelectedRoomId = roomId;

            // Thông tin chủ trọ hiện tại
            var landlordClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            User? landlord = null;
            if (landlordClaim != null && long.TryParse(landlordClaim.Value, out var parsedId))
            {
                landlord = await _context.Users.FindAsync(parsedId);
            }
            if (landlord == null)
            {
                landlord = await _context.Users.FirstOrDefaultAsync(u => u.Role == "LANDLORD") 
                    ?? new User { FullName = "Chủ trọ", PhoneNumber = "0825611111", IdentityCard = "001200000001" };
            }

            ViewBag.Landlord = landlord;

            // Danh sách đơn giá dịch vụ
            ViewBag.ServicePrices = await _context.ServicePrices.Where(s => s.IsActive).ToListAsync();

            return View();
        }

        public class CreateContractRequest
        {
            public long RoomId { get; set; }
            public string TenantName { get; set; } = string.Empty;
            public string TenantPhone { get; set; } = string.Empty;
            public string? TenantIdentity { get; set; }
            public string? TenantAddress { get; set; }
            public string? StartDate { get; set; }
            public string? EndDate { get; set; }
            public long RentalPrice { get; set; }
            public long DepositAmount { get; set; }
        }

        [HttpPost]
        public async Task<IActionResult> SaveContract([FromBody] CreateContractRequest request)
        {
            try
            {
                if (request == null || request.RoomId <= 0 || string.IsNullOrWhiteSpace(request.TenantName) || string.IsNullOrWhiteSpace(request.TenantPhone))
                {
                    return Json(new { success = false, message = "Vui lòng nhập đầy đủ thông tin phòng và người thuê." });
                }

                var room = await _context.Rooms.FindAsync(request.RoomId);
                if (room == null)
                {
                    return Json(new { success = false, message = "Phòng không tồn tại." });
                }

                // Tìm hoặc tạo mới Tenant User
                var phone = request.TenantPhone.Trim();
                var tenant = await _context.Users.FirstOrDefaultAsync(u => u.PhoneNumber == phone);
                if (tenant == null)
                {
                    tenant = new User
                    {
                        FullName = request.TenantName.Trim(),
                        PhoneNumber = phone,
                        IdentityCard = request.TenantIdentity?.Trim(),
                        Address = request.TenantAddress?.Trim(),
                        Role = "TENANT",
                        Status = "ACTIVE",
                        CreatedAt = DateTime.Now
                    };
                    var hasher = new Microsoft.AspNetCore.Identity.PasswordHasher<User>();
                    tenant.PasswordHash = hasher.HashPassword(tenant, "123456"); // Mật khẩu mặc định
                    _context.Users.Add(tenant);
                    await _context.SaveChangesAsync();

                    // Tạo ví cho khách
                    var wallet = new Wallet
                    {
                        UserId = tenant.Id,
                        Balance = 0,
                        Status = "ACTIVE",
                        UpdatedAt = DateTime.Now
                    };
                    _context.Wallets.Add(wallet);
                    await _context.SaveChangesAsync();
                }
                else
                {
                    // Cập nhật thông tin nếu cần
                    tenant.FullName = request.TenantName.Trim();
                    if (!string.IsNullOrWhiteSpace(request.TenantIdentity)) tenant.IdentityCard = request.TenantIdentity.Trim();
                    if (!string.IsNullOrWhiteSpace(request.TenantAddress)) tenant.Address = request.TenantAddress.Trim();
                    await _context.SaveChangesAsync();
                }

                DateOnly startDate = DateOnly.FromDateTime(DateTime.Today);
                if (!string.IsNullOrEmpty(request.StartDate) && DateOnly.TryParse(request.StartDate, out var parsedStart))
                {
                    startDate = parsedStart;
                }

                DateOnly? endDate = null;
                if (!string.IsNullOrEmpty(request.EndDate) && DateOnly.TryParse(request.EndDate, out var parsedEnd))
                {
                    endDate = parsedEnd;
                }

                var contract = new Contract
                {
                    RoomId = room.Id,
                    TenantId = tenant.Id,
                    RentalPrice = request.RentalPrice > 0 ? request.RentalPrice : room.Price,
                    DepositAmount = request.DepositAmount,
                    StartDate = startDate,
                    EndDate = endDate,
                    Status = "ACTIVE",
                    CreatedAt = DateTime.Now
                };

                _context.Contracts.Add(contract);

                // Cập nhật trạng thái phòng sang RENTED
                room.Status = "RENTED";
                await _context.SaveChangesAsync();

                return Json(new { success = true, message = "Lập hợp đồng thành công!", contractId = contract.Id });
            }
            catch (Exception ex)
            {
                var innerMsg = ex.InnerException != null ? ex.InnerException.Message : ex.Message;
                return Json(new { success = false, message = "Lỗi khi lưu hợp đồng: " + innerMsg });
            }
        }

        // ==========================================
        // CHẤM DỨT HỢP ĐỒNG / TRẢ PHÒNG
        // ==========================================
        [HttpPost]
        public async Task<IActionResult> TerminateContract(long? contractId, long? roomId)
        {
            try
            {
                Contract? contract = null;
                if (contractId.HasValue && contractId.Value > 0)
                {
                    contract = await _context.Contracts
                        .Include(c => c.Room)
                        .FirstOrDefaultAsync(c => c.Id == contractId.Value);
                }
                else if (roomId.HasValue && roomId.Value > 0)
                {
                    contract = await _context.Contracts
                        .Include(c => c.Room)
                        .FirstOrDefaultAsync(c => c.RoomId == roomId.Value && c.Status == "ACTIVE");
                }

                if (contract == null)
                {
                    return Json(new { success = false, message = "Không tìm thấy hợp đồng." });
                }

                // Cập nhật trạng thái phòng sang AVAILABLE (Trống)
                var room = contract.Room ?? await _context.Rooms.FindAsync(contract.RoomId);
                if (room != null)
                {
                    room.Status = "AVAILABLE";
                }

                var roomCode = room?.RoomCode ?? "của phòng";

                // Xóa toàn bộ dữ liệu liên quan đến khách cũ / hợp đồng này:
                // 1. Invoices & items & transactions
                var invoices = await _context.Invoices
                    .Include(i => i.InvoiceItems)
                    .Where(i => i.ContractId == contract.Id)
                    .ToListAsync();

                foreach (var inv in invoices)
                {
                    var txs = await _context.Transactions.Where(t => t.InvoiceId == inv.Id).ToListAsync();
                    _context.Transactions.RemoveRange(txs);
                    _context.InvoiceItems.RemoveRange(inv.InvoiceItems);
                }
                _context.Invoices.RemoveRange(invoices);

                // 2. Meter readings
                var meters = await _context.MeterReadings.Where(m => m.ContractId == contract.Id).ToListAsync();
                _context.MeterReadings.RemoveRange(meters);

                // 3. Xóa hợp đồng
                _context.Contracts.Remove(contract);

                await _context.SaveChangesAsync();

                return Json(new { success = true, message = $"Đã chấm dứt hợp đồng và xóa toàn bộ dữ liệu khách cũ thành công! Phòng {roomCode} đã chuyển về trạng thái Trống." });
            }
            catch (Exception ex)
            {
                var innerMsg = ex.InnerException != null ? ex.InnerException.Message : ex.Message;
                return Json(new { success = false, message = "Lỗi khi chấm dứt hợp đồng: " + innerMsg });
            }
        }

        // ==========================================
        // 5. HÓA ĐƠN (INVOICES) & TẠO HÓA ĐƠN CHO PHÒNG
        // ==========================================
        public async Task<IActionResult> Invoices()
        {
            var invoices = await _context.Invoices
                .Include(i => i.Room)
                .Include(i => i.Contract)
                    .ThenInclude(c => c!.Tenant)
                .Include(i => i.InvoiceItems)
                .OrderByDescending(i => i.CreatedAt)
                .ToListAsync();

            var totalCount = invoices.Count;
            var paidAmount = invoices.Where(i => i.Status == "PAID").Sum(i => i.TotalAmount)
                + invoices.Where(i => i.Status == "PARTIAL").Sum(i => i.TotalAmount - i.RemainingAmount);
            var remainingAmount = invoices.Sum(i => i.RemainingAmount);

            ViewBag.TotalCount = totalCount;
            ViewBag.PaidAmount = paidAmount;
            ViewBag.RemainingAmount = remainingAmount;

            // Lấy danh sách các phòng đang thuê kèm hợp đồng để cho phép chủ trọ chọn phòng tạo hóa đơn trực tiếp
            var activeContracts = await _context.Contracts
                .Include(c => c.Room)
                .Include(c => c.Tenant)
                .Where(c => c.Status == "ACTIVE")
                .OrderBy(c => c.Room!.RoomCode)
                .ToListAsync();

            ViewBag.ActiveContracts = activeContracts;

            return View(invoices);
        }

        public class QuickCreateInvoiceRequest
        {
            public long RoomId { get; set; }
            public string MonthYear { get; set; } = string.Empty;
            public long RoomFee { get; set; }
            public long ElecFee { get; set; }
            public long WaterFee { get; set; }
            public long ServiceFee { get; set; }
            public string? DueDate { get; set; }
        }

        [HttpPost]
        public async Task<IActionResult> CreateInvoiceForRoom([FromBody] QuickCreateInvoiceRequest request)
        {
            if (request == null || request.RoomId <= 0)
            {
                return Json(new { success = false, message = "Vui lòng chọn phòng để tạo hóa đơn." });
            }

            var contract = await _context.Contracts
                .Include(c => c.Room)
                .Include(c => c.Tenant)
                .FirstOrDefaultAsync(c => c.RoomId == request.RoomId && c.Status == "ACTIVE");

            if (contract == null)
            {
                return Json(new { success = false, message = "Phòng được chọn hiện chưa có hợp đồng thuê có hiệu lực." });
            }

            var monthYear = string.IsNullOrWhiteSpace(request.MonthYear) 
                ? DateTime.Now.ToString("yyyy-MM") 
                : request.MonthYear.Trim();

            long roomFee = request.RoomFee > 0 ? request.RoomFee : contract.RentalPrice;
            long elecFee = request.ElecFee;
            long waterFee = request.WaterFee;
            long serviceFee = request.ServiceFee;
            long total = roomFee + elecFee + waterFee + serviceFee;

            DateOnly? dueDate = null;
            if (!string.IsNullOrEmpty(request.DueDate) && DateOnly.TryParse(request.DueDate, out var parsedDue))
            {
                dueDate = parsedDue;
            }
            else
            {
                dueDate = DateOnly.FromDateTime(DateTime.Today.AddDays(7));
            }

            var invoiceCode = $"HD-{contract.Room?.RoomCode}-{DateTime.Now:yyyyMMddHHmmss}";

            var invoice = new Invoice
            {
                InvoiceCode = invoiceCode,
                ContractId = contract.Id,
                RoomId = contract.RoomId,
                MonthYear = monthYear,
                RoomFee = roomFee,
                ElecFee = elecFee,
                WaterFee = waterFee,
                ServiceFee = serviceFee,
                TotalAmount = total,
                RemainingAmount = total,
                DueDate = dueDate,
                Status = "UNPAID",
                CreatedAt = DateTime.Now
            };

            // Thêm các mục chi tiết hóa đơn
            invoice.InvoiceItems.Add(new InvoiceItem
            {
                ItemName = "Tiền phòng",
                Quantity = 1,
                Unit = "tháng",
                UnitPrice = roomFee,
                Amount = roomFee,
                CreatedAt = DateTime.Now
            });

            if (elecFee > 0)
            {
                invoice.InvoiceItems.Add(new InvoiceItem
                {
                    ServiceCode = "ELECTRIC",
                    ItemName = "Tiền điện",
                    Quantity = 1,
                    Unit = "tháng",
                    UnitPrice = elecFee,
                    Amount = elecFee,
                    CreatedAt = DateTime.Now
                });
            }

            if (waterFee > 0)
            {
                invoice.InvoiceItems.Add(new InvoiceItem
                {
                    ServiceCode = "WATER",
                    ItemName = "Tiền nước",
                    Quantity = 1,
                    Unit = "tháng",
                    UnitPrice = waterFee,
                    Amount = waterFee,
                    CreatedAt = DateTime.Now
                });
            }

            if (serviceFee > 0)
            {
                invoice.InvoiceItems.Add(new InvoiceItem
                {
                    ServiceCode = "SERVICE",
                    ItemName = "Dịch vụ chung (Internet, vệ sinh, máy giặt)",
                    Quantity = 1,
                    Unit = "tháng",
                    UnitPrice = serviceFee,
                    Amount = serviceFee,
                    CreatedAt = DateTime.Now
                });
            }

            _context.Invoices.Add(invoice);
            await _context.SaveChangesAsync();

            return Json(new { success = true, message = "Tạo hóa đơn thành công!", invoiceId = invoice.Id, invoiceCode = invoice.InvoiceCode });
        }

        // ==========================================
        // 6. NHẬP CHỈ SỐ ĐIỆN NƯỚC (METER READING)
        // ==========================================
        public async Task<IActionResult> MeterReading()
        {
            var activeContracts = await _context.Contracts
                .Include(c => c.Room)
                .Include(c => c.Tenant)
                .Where(c => c.Status == "ACTIVE")
                .OrderBy(c => c.Room!.RoomCode)
                .ToListAsync();

            ViewBag.ActiveContracts = activeContracts;
            ViewBag.ServicePrices = await _context.ServicePrices.Where(s => s.IsActive).ToListAsync();

            return View();
        }

        public class SaveMeterReadingRequest
        {
            public long RoomId { get; set; }
            public string MonthYear { get; set; } = string.Empty;
            public int ElecOld { get; set; }
            public int ElecNew { get; set; }
            public int TenantCount { get; set; }
            public int VehicleCount { get; set; }
            public long ElectricPrice { get; set; }
            public long WaterPrice { get; set; }
            public long InternetPrice { get; set; }
            public long CleaningPrice { get; set; }
            public long WashingPrice { get; set; }
            public long ParkingPrice { get; set; }
        }

        [HttpPost]
        public async Task<IActionResult> SaveMeterReading([FromBody] SaveMeterReadingRequest request)
        {
            try
            {
                if (request == null || request.RoomId <= 0)
                {
                    return Json(new { success = false, message = "Vui lòng chọn phòng." });
                }

                var contract = await _context.Contracts
                    .Include(c => c.Room)
                    .FirstOrDefaultAsync(c => c.RoomId == request.RoomId && c.Status == "ACTIVE");

                if (contract == null)
                {
                    return Json(new { success = false, message = "Phòng không có hợp đồng đang thuê." });
                }

                if (request.ElecNew < request.ElecOld)
                {
                    return Json(new { success = false, message = "Chỉ số điện mới không được nhỏ hơn chỉ số cũ." });
                }

                var monthYear = string.IsNullOrWhiteSpace(request.MonthYear) ? DateTime.Now.ToString("yyyy-MM") : request.MonthYear;

                // Tạo meter reading
                var reading = new MeterReading
                {
                    RoomId = request.RoomId,
                    ContractId = contract.Id,
                    MonthYear = monthYear,
                    ElecOld = request.ElecOld,
                    ElecNew = request.ElecNew,
                    WaterOld = 0,
                    WaterNew = 0,
                    TenantCount = request.TenantCount > 0 ? request.TenantCount : 1,
                    CreatedAt = DateTime.Now
                };

                _context.MeterReadings.Add(reading);
                await _context.SaveChangesAsync();

                // Tính toán chi phí
                int kwh = request.ElecNew - request.ElecOld;
                long elecFee = kwh * (request.ElectricPrice > 0 ? request.ElectricPrice : 3500);
                long waterFee = (request.TenantCount > 0 ? request.TenantCount : 1) * (request.WaterPrice > 0 ? request.WaterPrice : 50000);
                long internetFee = (request.TenantCount > 0 ? request.TenantCount : 1) * (request.InternetPrice > 0 ? request.InternetPrice : 50000);
                long cleaningFee = (request.TenantCount > 0 ? request.TenantCount : 1) * (request.CleaningPrice > 0 ? request.CleaningPrice : 100000);
                long washingFee = (request.TenantCount > 0 ? request.TenantCount : 1) * (request.WashingPrice > 0 ? request.WashingPrice : 50000);
                long parkingFee = request.VehicleCount * (request.ParkingPrice > 0 ? request.ParkingPrice : 100000);

                long serviceFee = internetFee + cleaningFee + washingFee + parkingFee;
                long roomFee = contract.RentalPrice;
                long totalAmount = roomFee + elecFee + waterFee + serviceFee;

                var invoiceCode = $"HD-{contract.Room?.RoomCode}-{DateTime.Now:yyyyMMddHHmmss}";

                var invoice = new Invoice
                {
                    InvoiceCode = invoiceCode,
                    ContractId = contract.Id,
                    RoomId = contract.RoomId,
                    MeterReadingId = reading.Id,
                    MonthYear = monthYear,
                    RoomFee = roomFee,
                    ElecFee = elecFee,
                    WaterFee = waterFee,
                    ServiceFee = serviceFee,
                    TotalAmount = totalAmount,
                    RemainingAmount = totalAmount,
                    DueDate = DateOnly.FromDateTime(DateTime.Today.AddDays(7)),
                    Status = "UNPAID",
                    CreatedAt = DateTime.Now
                };

                invoice.InvoiceItems.Add(new InvoiceItem { ServiceCode = null, ItemName = "Tiền phòng", Quantity = 1, Unit = "tháng", UnitPrice = roomFee, Amount = roomFee });
                invoice.InvoiceItems.Add(new InvoiceItem { ServiceCode = "ELECTRIC", ItemName = "Tiền điện", Quantity = kwh, Unit = "kWh", UnitPrice = request.ElectricPrice > 0 ? request.ElectricPrice : 3500, Amount = elecFee });
                invoice.InvoiceItems.Add(new InvoiceItem { ServiceCode = "WATER", ItemName = "Tiền nước", Quantity = request.TenantCount > 0 ? request.TenantCount : 1, Unit = "người", UnitPrice = request.WaterPrice > 0 ? request.WaterPrice : 50000, Amount = waterFee });
                invoice.InvoiceItems.Add(new InvoiceItem { ServiceCode = "INTERNET", ItemName = "Tiền Internet", Quantity = request.TenantCount > 0 ? request.TenantCount : 1, Unit = "người", UnitPrice = request.InternetPrice > 0 ? request.InternetPrice : 50000, Amount = internetFee });
                invoice.InvoiceItems.Add(new InvoiceItem { ServiceCode = "CLEANING", ItemName = "Thang máy & Vệ sinh", Quantity = request.TenantCount > 0 ? request.TenantCount : 1, Unit = "người", UnitPrice = request.CleaningPrice > 0 ? request.CleaningPrice : 100000, Amount = cleaningFee });
                invoice.InvoiceItems.Add(new InvoiceItem { ServiceCode = "WASHING", ItemName = "Máy giặt chung", Quantity = request.TenantCount > 0 ? request.TenantCount : 1, Unit = "người", UnitPrice = request.WashingPrice > 0 ? request.WashingPrice : 50000, Amount = washingFee });
                if (parkingFee > 0)
                {
                    invoice.InvoiceItems.Add(new InvoiceItem { ServiceCode = "PARKING", ItemName = "Sạc xe điện", Quantity = request.VehicleCount, Unit = "xe", UnitPrice = request.ParkingPrice > 0 ? request.ParkingPrice : 100000, Amount = parkingFee });
                }

                _context.Invoices.Add(invoice);
                await _context.SaveChangesAsync();

                return Json(new { success = true, message = "Lưu chỉ số và tạo hóa đơn thành công!" });
            }
            catch (Exception ex)
            {
                var innerMsg = ex.InnerException != null ? ex.InnerException.Message : ex.Message;
                return Json(new { success = false, message = "Lỗi khi lưu chỉ số: " + innerMsg });
            }
        }

        // ==========================================
        // 7. CẬP NHẬT ĐƠN GIÁ DỊCH VỤ
        // ==========================================
        [HttpPost]
        public async Task<IActionResult> SaveServicePrices([FromBody] List<ServicePrice> prices)
        {
            if (prices != null && prices.Count > 0)
            {
                foreach (var p in prices)
                {
                    var existing = await _context.ServicePrices.FirstOrDefaultAsync(s => s.ServiceCode == p.ServiceCode);
                    if (existing != null)
                    {
                        existing.UnitPrice = p.UnitPrice;
                        existing.UpdatedAt = DateTime.Now;
                    }
                }
                await _context.SaveChangesAsync();
                return Json(new { success = true, message = "Lưu đơn giá dịch vụ thành công!" });
            }

            return Json(new { success = false, message = "Dữ liệu đơn giá không hợp lệ." });
        }

        // ==========================================
        // 8. ĐẶT CỌC & GIAO DỊCH VÍ
        // ==========================================
        public async Task<IActionResult> DepositReceipt()
        {
            ViewBag.Rooms = await _context.Rooms.OrderBy(r => r.RoomCode).ToListAsync();
            ViewBag.Tenants = await _context.Users.Where(u => u.Role == "TENANT").OrderBy(u => u.FullName).ToListAsync();
            return View();
        }

        public async Task<IActionResult> WalletTransactions()
        {
            // Danh sách yêu cầu nạp tiền đang chờ duyệt
            var pendingTopups = await _context.TopupRequests
                .Include(t => t.Wallet)
                    .ThenInclude(w => w!.User)
                .Where(t => t.Status == "PENDING")
                .OrderBy(t => t.CreatedAt)
                .ToListAsync();

            ViewBag.PendingTopups = pendingTopups;

            // Lịch sử giao dịch tất cả tenant
            var transactions = await _context.Transactions
                .Include(t => t.Wallet)
                    .ThenInclude(w => w!.User)
                .Include(t => t.Invoice)
                    .ThenInclude(i => i!.Room)
                .OrderByDescending(t => t.CreatedAt)
                .ToListAsync();

            // Danh sách hóa đơn chưa thanh toán (công nợ)
            var unpaidInvoices = await _context.Invoices
                .Include(i => i.Room)
                .Include(i => i.Contract)
                    .ThenInclude(c => c!.Tenant)
                .Where(i => i.Status == "UNPAID")
                .OrderBy(i => i.CreatedAt)
                .ToListAsync();

            ViewBag.UnpaidInvoices = unpaidInvoices;

            // Lấy lịch sử tự động trừ tiền trực tiếp từ bảng transactions (loại giao dịch PAYMENT)
            var autoDeductHistory = transactions
                .Where(t => t.Type == "PAYMENT")
                .Select(t => new BTL_NganHangNhaTro.Models.ViewModels.AutoDeductItemViewModel
                {
                    ExecutedAt = t.CreatedAt,
                    InvoicePeriod = t.Invoice?.MonthYear ?? t.CreatedAt.ToString("MM/yyyy"),
                    RoomCode = t.Invoice?.Room?.RoomCode ?? "—",
                    TenantName = t.Wallet?.User?.FullName ?? "—",
                    Amount = t.Amount,
                    Status = "Thành công"
                })
                .ToList();

            ViewBag.AutoDeductHistory = autoDeductHistory;

            // Tổng số dư các ví
            ViewBag.TotalWalletsBalance = await _context.Wallets.SumAsync(w => w.Balance);

            return View(transactions);
        }

        // ==========================================
        // PHÊ DUYỆT YÊU CẦU NẠP TIỀN
        // ==========================================
        [HttpPost]
        public async Task<IActionResult> ApproveTopup(long topupRequestId)
        {
            var claim = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier);
            long landlordId = claim != null && long.TryParse(claim.Value, out var id) ? id : 0;

            try
            {
                var topupRequest = await _context.TopupRequests
                    .Include(t => t.Wallet)
                    .FirstOrDefaultAsync(t => t.Id == topupRequestId);

                if (topupRequest == null)
                    return Json(new { success = false, message = "Không tìm thấy yêu cầu nạp tiền." });

                if (topupRequest.Status != "PENDING")
                    return Json(new { success = false, message = "Yêu cầu này đã được xử lý rồi." });

                var wallet = topupRequest.Wallet!;

                // Cộng tiền vào ví
                wallet.Balance += topupRequest.Amount;
                wallet.UpdatedAt = DateTime.Now;

                // Ghi giao dịch nạp tiền
                var topupTx = new Transaction
                {
                    WalletId = wallet.Id,
                    TopupRequestId = topupRequest.Id,
                    Amount = topupRequest.Amount,
                    BalanceAfter = wallet.Balance,
                    Type = "TOPUP",
                    Description = $"Nạp tiền vào ví - {topupRequest.TransactionCode}",
                    CreatedAt = DateTime.Now
                };
                _context.Transactions.Add(topupTx);

                // Cập nhật trạng thái yêu cầu
                topupRequest.Status = "APPROVED";
                topupRequest.ApprovedBy = landlordId > 0 ? landlordId : null;
                topupRequest.ApprovedAt = DateTime.Now;

                await _context.SaveChangesAsync();

                // TỰ ĐỘNG TRỪ TIỀN HÓA ĐƠN NẾU ĐỦ SỐ DƯ
                var autoPaidMessages = new List<string>();

                // Tìm hợp đồng của wallet user
                var tenantContracts = await _context.Contracts
                    .Where(c => c.TenantId == wallet.UserId && c.Status == "ACTIVE")
                    .Select(c => c.Id)
                    .ToListAsync();

                if (tenantContracts.Any())
                {
                    // Lấy hóa đơn chưa thanh toán, sắp xếp theo ngày tạo cũ nhất trước
                    var unpaidInvoices = await _context.Invoices
                        .Where(i => tenantContracts.Contains(i.ContractId) && i.Status == "UNPAID")
                        .OrderBy(i => i.CreatedAt)
                        .ToListAsync();

                    long totalAutoPaid = 0;
                    foreach (var invoice in unpaidInvoices)
                    {
                        // Reload wallet balance mới nhất
                        var currentBalance = wallet.Balance;
                        if (currentBalance >= invoice.RemainingAmount && invoice.RemainingAmount > 0)
                        {
                            var payAmount = invoice.RemainingAmount;
                            wallet.Balance -= payAmount;
                            wallet.UpdatedAt = DateTime.Now;
                            totalAutoPaid += payAmount;

                            var payTx = new Transaction
                            {
                                WalletId = wallet.Id,
                                InvoiceId = invoice.Id,
                                Amount = payAmount,
                                BalanceAfter = wallet.Balance,
                                Type = "PAYMENT",
                                Description = $"Tự động thanh toán hóa đơn {invoice.InvoiceCode} kỳ {invoice.MonthYear}",
                                CreatedAt = DateTime.Now
                            };
                            _context.Transactions.Add(payTx);

                            invoice.RemainingAmount = 0;
                            invoice.Status = "PAID";

                            autoPaidMessages.Add($"Đã tự động thanh toán hóa đơn {invoice.InvoiceCode}");
                        }
                        else
                        {
                            break; // Không đủ tiền cho hóa đơn tiếp theo thì dừng
                        }
                    }

                    await _context.SaveChangesAsync();
                }

                string autoPayNote = autoPaidMessages.Any()
                    ? " " + string.Join(", ", autoPaidMessages) + "."
                    : "";

                return Json(new
                {
                    success = true,
                    message = $"Đã phê duyệt nạp {topupRequest.Amount:N0} VNĐ thành công!{autoPayNote}",
                    newBalance = wallet.Balance,
                    autoPaidCount = autoPaidMessages.Count
                });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = "Đã xảy ra lỗi: " + ex.Message });
            }
        }

        // ==========================================
        // TỪ CHỐI YÊU CẦU NẠP TIỀN
        // ==========================================
        [HttpPost]
        public async Task<IActionResult> RejectTopup(long topupRequestId, [FromBody] RejectTopupDto data)
        {
            try
            {
                var topupRequest = await _context.TopupRequests.FindAsync(topupRequestId);

                if (topupRequest == null)
                    return Json(new { success = false, message = "Không tìm thấy yêu cầu nạp tiền." });

                if (topupRequest.Status != "PENDING")
                    return Json(new { success = false, message = "Yêu cầu này đã được xử lý rồi." });

                topupRequest.Status = "REJECTED";
                topupRequest.RejectReason = data?.Reason ?? "Không có lý do";
                topupRequest.ApprovedAt = DateTime.Now;

                await _context.SaveChangesAsync();

                return Json(new { success = true, message = "Đã từ chối yêu cầu nạp tiền." });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = "Đã xảy ra lỗi: " + ex.Message });
            }
        }

        public class RejectTopupDto
        {
            public string? Reason { get; set; }
        }

        // ==========================================
        // CHẠY TRỪ TIỀN TỰ ĐỘNG THỦ CÔNG
        // ==========================================
        [HttpPost]
        public async Task<IActionResult> RunAutoDeduct()
        {
            try
            {
                var unpaidInvoices = await _context.Invoices
                    .Include(i => i.Contract)
                    .Include(i => i.Room)
                    .Where(i => i.Status == "UNPAID")
                    .OrderBy(i => i.CreatedAt)
                    .ToListAsync();

                string currentPeriod = DateTime.Now.ToString("MM/yyyy");

                if (!unpaidInvoices.Any())
                {
                    return Json(new { success = true, message = "Hiện không có hóa đơn nào chưa thanh toán.", count = 0, totalAmount = 0 });
                }

                int successCount = 0;
                long totalDeducted = 0;
                var paidRooms = new List<string>();

                var tenantIds = unpaidInvoices.Select(i => i.Contract?.TenantId).Where(id => id.HasValue).Select(id => id!.Value).Distinct().ToList();
                var wallets = await _context.Wallets.Where(w => tenantIds.Contains(w.UserId)).ToDictionaryAsync(w => w.UserId);

                foreach (var inv in unpaidInvoices)
                {
                    if (inv.Contract == null) continue;
                    var tenantId = inv.Contract.TenantId;
                    if (!wallets.TryGetValue(tenantId, out var wallet)) continue;

                    if (wallet.Balance >= inv.RemainingAmount && inv.RemainingAmount > 0)
                    {
                        var amountToPay = inv.RemainingAmount;
                        wallet.Balance -= amountToPay;
                        wallet.UpdatedAt = DateTime.Now;

                        var tx = new Transaction
                        {
                            WalletId = wallet.Id,
                            InvoiceId = inv.Id,
                            Amount = amountToPay,
                            BalanceAfter = wallet.Balance,
                            Type = "PAYMENT",
                            Description = $"Tự động thanh toán hóa đơn {inv.InvoiceCode} kỳ {inv.MonthYear}",
                            CreatedAt = DateTime.Now
                        };
                        _context.Transactions.Add(tx);

                        inv.RemainingAmount = 0;
                        inv.Status = "PAID";

                        successCount++;
                        totalDeducted += amountToPay;
                        var rCode = inv.Room?.RoomCode ?? "P" + inv.RoomId;
                        if (!paidRooms.Contains(rCode)) paidRooms.Add(rCode);
                    }
                }

                await _context.SaveChangesAsync();

                if (successCount > 0)
                {
                    return Json(new
                    {
                        success = true,
                        message = $"Đã trừ tiền tự động thành công cho {successCount} phòng ({string.Join(", ", paidRooms)})! Tổng tiền đã trừ: {totalDeducted:N0} VNĐ.",
                        count = successCount,
                        totalAmount = totalDeducted
                    });
                }
                else
                {
                    return Json(new
                    {
                        success = false,
                        message = "Đã quét hệ thống nhưng ví người thuê hiện không đủ số dư để thanh toán hóa đơn.",
                        count = 0,
                        totalAmount = 0
                    });
                }
            }
            catch (Exception ex)
            {
                var innerMsg = ex.InnerException != null ? ex.InnerException.Message : ex.Message;
                return Json(new { success = false, message = "Lỗi khi chạy trừ tiền tự động: " + innerMsg });
            }
        }
    }
}
