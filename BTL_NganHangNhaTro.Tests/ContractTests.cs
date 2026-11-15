using BTL_NganHangNhaTro.Controllers;
using BTL_NganHangNhaTro.Models;
using Microsoft.AspNetCore.Mvc;
using System.Text.Json;
using Xunit;

namespace BTL_NganHangNhaTro.Tests
{
    public class ContractTests
    {
        [Fact]
        public async Task SaveContract_ValidInput_ShouldCreateContractAndSetRoomRented()
        {
            // Arrange
            using var context = TestDbHelper.CreateInMemoryDbContext();
            var controller = new LandlordController(context);
            TestDbHelper.SetUserContext(controller, userId: 1, role: "LANDLORD");

            // Tạo phòng trống
            var room = new Room
            {
                LandlordId = 1,
                RoomCode = "P501",
                RoomName = "Phòng 501",
                Price = 2_500_000,
                MaxTenants = 2,
                Status = "AVAILABLE"
            };
            context.Rooms.Add(room);
            await context.SaveChangesAsync();

            var request = new LandlordController.CreateContractRequest
            {
                RoomId = room.Id,
                TenantName = "Lê Thị Thảo",
                TenantPhone = "0987654321",
                TenantIdentity = "001200112233",
                TenantAddress = "Hà Nội",
                RentalPrice = 2_500_000,
                DepositAmount = 2_500_000,
                StartDate = "2026-11-01",
                EndDate = "2027-05-01"
            };

            // Act
            var result = await controller.SaveContract(request) as JsonResult;

            // Assert
            Assert.NotNull(result);
            var json = JsonSerializer.Serialize(result.Value);
            Assert.Contains("\"success\":true", json);

            // Kiểm tra trạng thái phòng chuyển sang RENTED
            var updatedRoom = await context.Rooms.FindAsync(room.Id);
            Assert.NotNull(updatedRoom);
            Assert.Equal("RENTED", updatedRoom.Status);

            // Kiểm tra hợp đồng được tạo với trạng thái ACTIVE
            var contract = context.Contracts.FirstOrDefault(c => c.RoomId == room.Id);
            Assert.NotNull(contract);
            Assert.Equal("ACTIVE", contract.Status);
            Assert.Equal(2_500_000, contract.RentalPrice);
        }

        [Fact]
        public async Task TerminateContract_ShouldCleanUpAndSetRoomAvailable()
        {
            // Arrange
            using var context = TestDbHelper.CreateInMemoryDbContext();
            var controller = new LandlordController(context);
            TestDbHelper.SetUserContext(controller, userId: 1, role: "LANDLORD");

            var room = new Room
            {
                LandlordId = 1,
                RoomCode = "P502",
                RoomName = "Phòng 502",
                Price = 3_000_000,
                MaxTenants = 2,
                Status = "RENTED"
            };
            context.Rooms.Add(room);

            var tenant = new User
            {
                FullName = "Trần Văn B",
                PhoneNumber = "0912345678",
                PasswordHash = "hashed123",
                Role = "TENANT",
                Status = "ACTIVE"
            };
            context.Users.Add(tenant);
            await context.SaveChangesAsync();

            var contract = new Contract
            {
                RoomId = room.Id,
                TenantId = tenant.Id,
                RentalPrice = 3_000_000,
                DepositAmount = 3_000_000,
                StartDate = DateOnly.FromDateTime(DateTime.Today.AddMonths(-2)),
                Status = "ACTIVE"
            };
            context.Contracts.Add(contract);
            await context.SaveChangesAsync();

            // Act: Chấm dứt hợp đồng
            var result = await controller.TerminateContract(contract.Id, room.Id) as JsonResult;

            // Assert
            Assert.NotNull(result);
            var json = JsonSerializer.Serialize(result.Value);
            Assert.Contains("\"success\":true", json);

            // Phòng chuyển về trạng thái AVAILABLE (Trống)
            var updatedRoom = await context.Rooms.FindAsync(room.Id);
            Assert.NotNull(updatedRoom);
            Assert.Equal("AVAILABLE", updatedRoom.Status);

            // Hợp đồng cũ đã bị dọn dẹp sạch khỏi database
            var remainingContract = await context.Contracts.FindAsync(contract.Id);
            Assert.Null(remainingContract);
        }
    }
}
