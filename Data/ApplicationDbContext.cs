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

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<User>(entity =>
            {
                entity.ToTable("users");

                entity.HasKey(user => user.Id);

                entity.Property(user => user.Id)
                    .HasColumnName("id")
                    .UseIdentityColumn();

                entity.Property(user => user.PhoneNumber)
                    .HasColumnName("phone_number")
                    .HasMaxLength(20)
                    .IsRequired();

                entity.Property(user => user.PasswordHash)
                    .HasColumnName("password_hash")
                    .HasMaxLength(255)
                    .IsRequired();

                entity.Property(user => user.FullName)
                    .HasColumnName("full_name")
                    .HasMaxLength(100)
                    .IsRequired();

                entity.Property(user => user.IdentityCard)
                    .HasColumnName("identity_card")
                    .HasMaxLength(20);

                entity.Property(user => user.Address)
                    .HasColumnName("address")
                    .HasMaxLength(255);

                entity.Property(user => user.Role)
                    .HasColumnName("role")
                    .HasMaxLength(20)
                    .IsRequired();

                entity.Property(user => user.Status)
                    .HasColumnName("status")
                    .HasMaxLength(20)
                    .HasDefaultValue("ACTIVE")
                    .IsRequired();

                entity.Property(user => user.CreatedAt)
                    .HasColumnName("created_at")
                    .HasColumnType("datetime2(7)")
                    .HasDefaultValueSql("SYSDATETIME()");

                entity.HasIndex(user => user.PhoneNumber)
                    .IsUnique();
            });
        }
    }
}
