namespace BTL_NganHangNhaTro.Models
{
    public class ServicePrice
    {
        public long Id { get; set; }
        public string ServiceCode { get; set; } = string.Empty;
        public string ServiceName { get; set; } = string.Empty;
        public long UnitPrice { get; set; }
        public string? Unit { get; set; }
        public bool IsActive { get; set; } = true;
        public DateTime? UpdatedAt { get; set; }
    }
}

