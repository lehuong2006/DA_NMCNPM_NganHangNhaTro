using BTL_NganHangNhaTro.Controllers;
using BTL_NganHangNhaTro.Models;
using Microsoft.AspNetCore.Mvc;
using System.Text.Json;
using Xunit;

namespace BTL_NganHangNhaTro.Tests
{
    public class WalletTests
    {
        [Fact]
        public async Task SubmitTopup_ValidAmount_ShouldCreatePendingRequest()
        {
            // Arrange
            using var context = TestDbHelper.CreateInMemoryDbContext();
            var controller = new TenantController(context);
            TestDbHelper.SetUserContext(controller, userId: 10, role: "TENANT", fullName: "Nguyễn Văn Test");

            var request = new TenantController.SubmitTopupDto
            {
                Amount = 1_000_000,
                Content = "NAP TIEN TEST"
            };

            // Act
            var result = await controller.SubmitTopup(request) as JsonResult;

            // Assert
            Assert.NotNull(result);
            var json = JsonSerializer.Serialize(result.Value);
            Assert.Contains("\"success\":true", json);

            var topup = context.TopupRequests.FirstOrDefault(t => t.Amount == 1_000_000);
            Assert.NotNull(topup);
            Assert.Equal("PENDING", topup.Status);
            Assert.Equal("NAP TIEN TEST", topup.TransactionCode);
        }

        [Fact]
        public async Task PayInvoice_SufficientBalance_ShouldDeductBalanceAndMarkPaid()
        {
            // Arrange
            using var context = TestDbHelper.CreateInMemoryDbContext();
            var controller = new TenantController(context);
            long userId = 20;
            TestDbHelper.SetUserContext(controller, userId: userId, role: "TENANT");

            // Tạo ví với số dư 3.000.000 VNĐ
            var wallet = new Wallet
            {
                UserId = userId,
                Balance = 3_000_000,
                Status = "ACTIVE"
            };
            context.Wallets.Add(wallet);

            // Tạo hóa đơn tiền phòng 2.000.000 VNĐ
            var invoice = new Invoice
            {
                ContractId = 1,
                RoomId = 1,
                InvoiceCode = "HD-TEST-01",
                MonthYear = "2026-11",
                TotalAmount = 2_000_000,
                RemainingAmount = 2_000_000,
                Status = "UNPAID"
            };
            context.Invoices.Add(invoice);
            await context.SaveChangesAsync();

            // Act
            var result = await controller.PayInvoice(invoice.Id) as JsonResult;

            // Assert
            Assert.NotNull(result);
            var json = JsonSerializer.Serialize(result.Value);
            Assert.Contains("\"success\":true", json);

            // Kiểm tra số dư ví giảm còn 1.000.000 VNĐ
            var updatedWallet = await context.Wallets.FindAsync(wallet.Id);
            Assert.NotNull(updatedWallet);
            Assert.Equal(1_000_000, updatedWallet.Balance);

            // Kiểm tra trạng thái hóa đơn đổi thành PAID
            var updatedInvoice = await context.Invoices.FindAsync(invoice.Id);
            Assert.NotNull(updatedInvoice);
            Assert.Equal("PAID", updatedInvoice.Status);
            Assert.Equal(0, updatedInvoice.RemainingAmount);

            // Kiểm tra có tạo bản ghi giao dịch PAYMENT
            var tx = context.Transactions.FirstOrDefault(t => t.InvoiceId == invoice.Id);
            Assert.NotNull(tx);
            Assert.Equal("PAYMENT", tx.Type);
            Assert.Equal(2_000_000, tx.Amount);
        }

        [Fact]
        public async Task PayInvoice_InsufficientBalance_ShouldFailAndNotDeduct()
        {
            // Arrange
            using var context = TestDbHelper.CreateInMemoryDbContext();
            var controller = new TenantController(context);
            long userId = 30;
            TestDbHelper.SetUserContext(controller, userId: userId, role: "TENANT");

            // Tạo ví với số dư chỉ có 500.000 VNĐ
            var wallet = new Wallet
            {
                UserId = userId,
                Balance = 500_000,
                Status = "ACTIVE"
            };
            context.Wallets.Add(wallet);

            // Hóa đơn 2.000.000 VNĐ (lớn hơn số dư ví)
            var invoice = new Invoice
            {
                ContractId = 2,
                RoomId = 2,
                InvoiceCode = "HD-TEST-02",
                MonthYear = "2026-11",
                TotalAmount = 2_000_000,
                RemainingAmount = 2_000_000,
                Status = "UNPAID"
            };
            context.Invoices.Add(invoice);
            await context.SaveChangesAsync();

            // Act
            var result = await controller.PayInvoice(invoice.Id) as JsonResult;

            // Assert
            Assert.NotNull(result);
            var json = JsonSerializer.Serialize(result.Value);
            Assert.Contains("\"success\":false", json);

            // Số dư ví không bị trừ
            var currentWallet = await context.Wallets.FindAsync(wallet.Id);
            Assert.NotNull(currentWallet);
            Assert.Equal(500_000, currentWallet.Balance);

            // Hóa đơn vẫn UNPAID
            var currentInvoice = await context.Invoices.FindAsync(invoice.Id);
            Assert.NotNull(currentInvoice);
            Assert.Equal("UNPAID", currentInvoice.Status);
        }

        [Fact]
        public async Task ApproveTopup_ShouldIncreaseWalletBalance()
        {
            // Arrange
            using var context = TestDbHelper.CreateInMemoryDbContext();
            var controller = new LandlordController(context);
            TestDbHelper.SetUserContext(controller, userId: 1, role: "LANDLORD");

            var wallet = new Wallet
            {
                UserId = 40,
                Balance = 1_000_000,
                Status = "ACTIVE"
            };
            context.Wallets.Add(wallet);
            await context.SaveChangesAsync();

            var topup = new TopupRequest
            {
                WalletId = wallet.Id,
                Amount = 2_000_000,
                TransactionCode = "CK-ABC",
                Status = "PENDING"
            };
            context.TopupRequests.Add(topup);
            await context.SaveChangesAsync();

            // Act
            var result = await controller.ApproveTopup(topup.Id) as JsonResult;

            // Assert
            Assert.NotNull(result);
            var json = JsonSerializer.Serialize(result.Value);
            Assert.Contains("\"success\":true", json);

            var updatedWallet = await context.Wallets.FindAsync(wallet.Id);
            Assert.NotNull(updatedWallet);
            // 1.000.000 + 2.000.000 = 3.000.000
            Assert.Equal(3_000_000, updatedWallet.Balance);

            var updatedTopup = await context.TopupRequests.FindAsync(topup.Id);
            Assert.NotNull(updatedTopup);
            Assert.Equal("APPROVED", updatedTopup.Status);
        }
    }
}
