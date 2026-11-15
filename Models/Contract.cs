namespace BTL_NganHangNhaTro.Models
{
    public class Contract
    {
        public long Id { get; set; }
        public long RoomId { get; set; }
        public long TenantId { get; set; }
        public long RentalPrice { get; set; }
        public long DepositAmount { get; set; }
        public DateOnly StartDate { get; set; }
        public DateOnly? EndDate { get; set; }
        public string Status { get; set; } = "ACTIVE"; // ACTIVE, EXPIRED, TERMINATED
        public DateTime CreatedAt { get; set; } = DateTime.Now;

        // Navigation properties
        public virtual Room? Room { get; set; }
        public virtual User? Tenant { get; set; }
        public virtual ICollection<Invoice> Invoices { get; set; } = new List<Invoice>();
    }
}

