namespace BTL_NganHangNhaTro.Models
{
    public class User
    {
        public long Id { get; set; }

        public string PhoneNumber { get; set; } = null!;

        public string PasswordHash { get; set; } = null!;

        public string FullName { get; set; } = null!;

        public string? IdentityCard { get; set; }

        public string? Address { get; set; }

        public string Role { get; set; } = null!;

        public string Status { get; set; } = null!;

        public DateTime CreatedAt { get; set; }
    }
}
