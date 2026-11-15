namespace BTL_NganHangNhaTro.Models
{
    public class TopupRequest
    {
        public long Id { get; set; }
        public long WalletId { get; set; }
        public long? ApprovedBy { get; set; }
        public long Amount { get; set; }
        public string? ReceiptImageUrl { get; set; }
        public string? TransactionCode { get; set; }
        public string Status { get; set; } = "PENDING"; // PENDING, APPROVED, REJECTED
        public string? RejectReason { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.Now;
        public DateTime? ApprovedAt { get; set; }

        // Navigation properties
        public virtual Wallet? Wallet { get; set; }
        public virtual User? ApprovedByUser { get; set; }
    }
}

