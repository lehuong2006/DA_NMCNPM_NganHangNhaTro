using BTL_NganHangNhaTro.Models;
using Microsoft.EntityFrameworkCore;

namespace BTL_NganHangNhaTro.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(
            DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        public DbSet<User> Users { get; set; }
        public DbSet<Room> Rooms { get; set; }
        public DbSet<Contract> Contracts { get; set; }
        public DbSet<ServicePrice> ServicePrices { get; set; }
        public DbSet<MeterReading> MeterReadings { get; set; }
        public DbSet<Invoice> Invoices { get; set; }
        public DbSet<InvoiceItem> InvoiceItems { get; set; }
        public DbSet<Wallet> Wallets { get; set; }
        public DbSet<Transaction> Transactions { get; set; }
        public DbSet<TopupRequest> TopupRequests { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Users
            modelBuilder.Entity<User>(entity =>
            {
                entity.ToTable("users");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id").UseIdentityColumn();
                entity.Property(e => e.PhoneNumber).HasColumnName("phone_number").HasMaxLength(20).IsRequired();
                entity.Property(e => e.PasswordHash).HasColumnName("password_hash").HasMaxLength(255).IsRequired();
                entity.Property(e => e.FullName).HasColumnName("full_name").HasMaxLength(100).IsRequired();
                entity.Property(e => e.IdentityCard).HasColumnName("identity_card").HasMaxLength(20);
                entity.Property(e => e.Address).HasColumnName("address").HasMaxLength(255);
                entity.Property(e => e.Role).HasColumnName("role").HasMaxLength(20).IsRequired();
                entity.Property(e => e.Status).HasColumnName("status").HasMaxLength(20).HasDefaultValue("ACTIVE").IsRequired();
                entity.Property(e => e.CreatedAt).HasColumnName("created_at").HasColumnType("datetime2(7)").HasDefaultValueSql("SYSDATETIME()");
                entity.HasIndex(e => e.PhoneNumber).IsUnique();
            });

            // Rooms
            modelBuilder.Entity<Room>(entity =>
            {
                entity.ToTable("rooms");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id").UseIdentityColumn();
                entity.Property(e => e.LandlordId).HasColumnName("landlord_id").IsRequired();
                entity.Property(e => e.RoomCode).HasColumnName("room_code").HasMaxLength(50).IsRequired();
                entity.Property(e => e.RoomName).HasColumnName("room_name").HasMaxLength(100);
                entity.Property(e => e.Price).HasColumnName("price").IsRequired();
                entity.Property(e => e.MaxTenants).HasColumnName("max_tenants").IsRequired();
                entity.Property(e => e.Status).HasColumnName("status").HasMaxLength(20).IsRequired();
                entity.Property(e => e.CreatedAt).HasColumnName("created_at").HasColumnType("datetime2(7)");

                entity.HasOne(e => e.Landlord)
                      .WithMany()
                      .HasForeignKey(e => e.LandlordId);
            });

            // Contracts
            modelBuilder.Entity<Contract>(entity =>
            {
                entity.ToTable("contracts", tb => tb.UseSqlOutputClause(false));
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id").UseIdentityColumn();
                entity.Property(e => e.RoomId).HasColumnName("room_id").IsRequired();
                entity.Property(e => e.TenantId).HasColumnName("tenant_id").IsRequired();
                entity.Property(e => e.RentalPrice).HasColumnName("rental_price").IsRequired();
                entity.Property(e => e.DepositAmount).HasColumnName("deposit_amount").IsRequired();
                entity.Property(e => e.StartDate).HasColumnName("start_date").IsRequired();
                entity.Property(e => e.EndDate).HasColumnName("end_date");
                entity.Property(e => e.Status).HasColumnName("status").HasMaxLength(20).IsRequired();
                entity.Property(e => e.CreatedAt).HasColumnName("created_at").HasColumnType("datetime2(7)");

                entity.HasOne(e => e.Room)
                      .WithMany(r => r.Contracts)
                      .HasForeignKey(e => e.RoomId);

                entity.HasOne(e => e.Tenant)
                      .WithMany()
                      .HasForeignKey(e => e.TenantId);
            });

            // ServicePrices
            modelBuilder.Entity<ServicePrice>(entity =>
            {
                entity.ToTable("service_prices");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id").UseIdentityColumn();
                entity.Property(e => e.ServiceCode).HasColumnName("service_code").HasMaxLength(30).IsRequired();
                entity.Property(e => e.ServiceName).HasColumnName("service_name").HasMaxLength(100).IsRequired();
                entity.Property(e => e.UnitPrice).HasColumnName("unit_price").IsRequired();
                entity.Property(e => e.Unit).HasColumnName("unit").HasMaxLength(30);
                entity.Property(e => e.IsActive).HasColumnName("is_active").IsRequired();
                entity.Property(e => e.UpdatedAt).HasColumnName("updated_at").HasColumnType("datetime2(7)");
            });

            // MeterReadings
            modelBuilder.Entity<MeterReading>(entity =>
            {
                entity.ToTable("meter_readings");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id").UseIdentityColumn();
                entity.Property(e => e.RoomId).HasColumnName("room_id").IsRequired();
                entity.Property(e => e.ContractId).HasColumnName("contract_id").IsRequired();
                entity.Property(e => e.MonthYear).HasColumnName("month_year").HasMaxLength(20).IsRequired();
                entity.Property(e => e.ElecOld).HasColumnName("elec_old").IsRequired();
                entity.Property(e => e.ElecNew).HasColumnName("elec_new").IsRequired();
                entity.Property(e => e.WaterOld).HasColumnName("water_old").IsRequired();
                entity.Property(e => e.WaterNew).HasColumnName("water_new").IsRequired();
                entity.Property(e => e.TenantCount).HasColumnName("tenant_count").IsRequired();
                entity.Property(e => e.CreatedAt).HasColumnName("created_at").HasColumnType("datetime2(7)");

                entity.HasOne(e => e.Room)
                      .WithMany()
                      .HasForeignKey(e => e.RoomId);

                entity.HasOne(e => e.Contract)
                      .WithMany()
                      .HasForeignKey(e => e.ContractId);
            });

            // Invoices
            modelBuilder.Entity<Invoice>(entity =>
            {
                entity.ToTable("invoices");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id").UseIdentityColumn();
                entity.Property(e => e.InvoiceCode).HasColumnName("invoice_code").HasMaxLength(50).IsRequired();
                entity.Property(e => e.ContractId).HasColumnName("contract_id").IsRequired();
                entity.Property(e => e.RoomId).HasColumnName("room_id").IsRequired();
                entity.Property(e => e.MeterReadingId).HasColumnName("meter_reading_id");
                entity.Property(e => e.MonthYear).HasColumnName("month_year").HasMaxLength(20).IsRequired();
                entity.Property(e => e.RoomFee).HasColumnName("room_fee").IsRequired();
                entity.Property(e => e.ElecFee).HasColumnName("elec_fee").IsRequired();
                entity.Property(e => e.WaterFee).HasColumnName("water_fee").IsRequired();
                entity.Property(e => e.ServiceFee).HasColumnName("service_fee").IsRequired();
                entity.Property(e => e.TotalAmount).HasColumnName("total_amount").IsRequired();
                entity.Property(e => e.RemainingAmount).HasColumnName("remaining_amount").IsRequired();
                entity.Property(e => e.DueDate).HasColumnName("due_date");
                entity.Property(e => e.Status).HasColumnName("status").HasMaxLength(20).IsRequired();
                entity.Property(e => e.CreatedAt).HasColumnName("created_at").HasColumnType("datetime2(7)");

                entity.HasOne(e => e.Room)
                      .WithMany(r => r.Invoices)
                      .HasForeignKey(e => e.RoomId);

                entity.HasOne(e => e.Contract)
                      .WithMany(c => c.Invoices)
                      .HasForeignKey(e => e.ContractId);

                entity.HasOne(e => e.MeterReading)
                      .WithMany()
                      .HasForeignKey(e => e.MeterReadingId);
            });

            // InvoiceItems
            modelBuilder.Entity<InvoiceItem>(entity =>
            {
                entity.ToTable("invoice_items");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id").UseIdentityColumn();
                entity.Property(e => e.InvoiceId).HasColumnName("invoice_id").IsRequired();
                entity.Property(e => e.ServiceCode).HasColumnName("service_code").HasMaxLength(30);
                entity.Property(e => e.ItemName).HasColumnName("item_name").HasMaxLength(100).IsRequired();
                entity.Property(e => e.Quantity).HasColumnName("quantity").HasColumnType("decimal(18,2)").IsRequired();
                entity.Property(e => e.Unit).HasColumnName("unit").HasMaxLength(30);
                entity.Property(e => e.UnitPrice).HasColumnName("unit_price").IsRequired();
                entity.Property(e => e.Amount).HasColumnName("amount").IsRequired();
                entity.Property(e => e.CreatedAt).HasColumnName("created_at").HasColumnType("datetime2(7)");

                entity.HasOne(e => e.Invoice)
                      .WithMany(i => i.InvoiceItems)
                      .HasForeignKey(e => e.InvoiceId);
            });

            // Wallets
            modelBuilder.Entity<Wallet>(entity =>
            {
                entity.ToTable("wallets");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id").UseIdentityColumn();
                entity.Property(e => e.UserId).HasColumnName("user_id").IsRequired();
                entity.Property(e => e.Balance).HasColumnName("balance").IsRequired();
                entity.Property(e => e.Status).HasColumnName("status").HasMaxLength(20).IsRequired();
                entity.Property(e => e.UpdatedAt).HasColumnName("updated_at").HasColumnType("datetime2(7)");

                entity.HasOne(e => e.User)
                      .WithMany()
                      .HasForeignKey(e => e.UserId);
            });

            // Transactions
            modelBuilder.Entity<Transaction>(entity =>
            {
                entity.ToTable("transactions");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id").UseIdentityColumn();
                entity.Property(e => e.WalletId).HasColumnName("wallet_id").IsRequired();
                entity.Property(e => e.InvoiceId).HasColumnName("invoice_id");
                entity.Property(e => e.TopupRequestId).HasColumnName("topup_request_id");
                entity.Property(e => e.Amount).HasColumnName("amount").IsRequired();
                entity.Property(e => e.BalanceAfter).HasColumnName("balance_after").IsRequired();
                entity.Property(e => e.Type).HasColumnName("type").HasMaxLength(20).IsRequired();
                entity.Property(e => e.Description).HasColumnName("description").HasMaxLength(255);
                entity.Property(e => e.CreatedAt).HasColumnName("created_at").HasColumnType("datetime2(7)");

                entity.HasOne(e => e.Wallet)
                      .WithMany(w => w.Transactions)
                      .HasForeignKey(e => e.WalletId);

                entity.HasOne(e => e.Invoice)
                      .WithMany()
                      .HasForeignKey(e => e.InvoiceId);

                entity.HasOne(e => e.TopupRequest)
                      .WithMany()
                      .HasForeignKey(e => e.TopupRequestId)
                      .IsRequired(false);
            });

            // TopupRequests
            modelBuilder.Entity<TopupRequest>(entity =>
            {
                entity.ToTable("topup_requests");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id").UseIdentityColumn();
                entity.Property(e => e.WalletId).HasColumnName("wallet_id").IsRequired();
                entity.Property(e => e.ApprovedBy).HasColumnName("approved_by");
                entity.Property(e => e.Amount).HasColumnName("amount").IsRequired();
                entity.Property(e => e.ReceiptImageUrl).HasColumnName("receipt_image_url").HasMaxLength(500);
                entity.Property(e => e.TransactionCode).HasColumnName("transaction_code").HasMaxLength(100);
                entity.Property(e => e.Status).HasColumnName("status").HasMaxLength(20).IsRequired();
                entity.Property(e => e.RejectReason).HasColumnName("reject_reason").HasMaxLength(500);
                entity.Property(e => e.CreatedAt).HasColumnName("created_at").HasColumnType("datetime2(7)");
                entity.Property(e => e.ApprovedAt).HasColumnName("approved_at").HasColumnType("datetime2(7)");

                entity.HasOne(e => e.Wallet)
                      .WithMany()
                      .HasForeignKey(e => e.WalletId);

                entity.HasOne(e => e.ApprovedByUser)
                      .WithMany()
                      .HasForeignKey(e => e.ApprovedBy)
                      .IsRequired(false);
            });
        }
    }
}
