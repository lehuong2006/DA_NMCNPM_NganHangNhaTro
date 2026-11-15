namespace BTL_NganHangNhaTro.Models
{
    public class InvoiceItem
    {
        public long Id { get; set; }
        public long InvoiceId { get; set; }
        public string? ServiceCode { get; set; }
        public string ItemName { get; set; } = string.Empty;
        public decimal Quantity { get; set; }
        public string? Unit { get; set; }
        public long UnitPrice { get; set; }
        public long Amount { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.Now;

        // Navigation properties
        public virtual Invoice? Invoice { get; set; }
    }
}

