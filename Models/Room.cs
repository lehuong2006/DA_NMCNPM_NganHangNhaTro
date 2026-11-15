namespace BTL_NganHangNhaTro.Models
{
    public class Room
    {
        public long Id { get; set; }
        public long LandlordId { get; set; }
        public string RoomCode { get; set; } = string.Empty;
        public string? RoomName { get; set; }
        public long Price { get; set; }
        public int MaxTenants { get; set; }
        public string Status { get; set; } = "AVAILABLE"; // AVAILABLE, RENTED, MAINTENANCE
        public DateTime CreatedAt { get; set; } = DateTime.Now;

        // Navigation properties
        public virtual User? Landlord { get; set; }
        public virtual ICollection<Contract> Contracts { get; set; } = new List<Contract>();
        public virtual ICollection<Invoice> Invoices { get; set; } = new List<Invoice>();
    }
}

