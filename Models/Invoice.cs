namespace BTL_NganHangNhaTro.Models
{
    public class Invoice
    {
        public long Id { get; set; }
        public string InvoiceCode { get; set; } = string.Empty;
        public long ContractId { get; set; }
        public long RoomId { get; set; }
        public long? MeterReadingId { get; set; }
        public string MonthYear { get; set; } = string.Empty;
        public long RoomFee { get; set; }
        public long ElecFee { get; set; }
        public long WaterFee { get; set; }
        public long ServiceFee { get; set; }
        public long TotalAmount { get; set; }
        public long RemainingAmount { get; set; }
        public DateOnly? DueDate { get; set; }
        public string Status { get; set; } = "UNPAID"; // UNPAID, PAID, PARTIAL
        public DateTime CreatedAt { get; set; } = DateTime.Now;

        // Navigation properties
        public virtual Contract? Contract { get; set; }
        public virtual Room? Room { get; set; }
        public virtual MeterReading? MeterReading { get; set; }
        public virtual ICollection<InvoiceItem> InvoiceItems { get; set; } = new List<InvoiceItem>();
    }
}

