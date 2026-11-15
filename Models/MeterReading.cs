namespace BTL_NganHangNhaTro.Models
{
    public class MeterReading
    {
        public long Id { get; set; }
        public long RoomId { get; set; }
        public long ContractId { get; set; }
        public string MonthYear { get; set; } = string.Empty; // e.g. "2026-11"
        public int ElecOld { get; set; }
        public int ElecNew { get; set; }
        public int WaterOld { get; set; }
        public int WaterNew { get; set; }
        public int TenantCount { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.Now;

        // Navigation properties
        public virtual Room? Room { get; set; }
        public virtual Contract? Contract { get; set; }
    }
}

