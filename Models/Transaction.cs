namespace BTL_NganHangNhaTro.Models
{
    public class Transaction
    {
        public long Id { get; set; }
        public long WalletId { get; set; }
        public long? InvoiceId { get; set; }
        public long? TopupRequestId { get; set; }
        public long Amount { get; set; }
        public long BalanceAfter { get; set; }
        public string Type { get; set; } = string.Empty; // TOPUP, PAYMENT, REFUND
        public string? Description { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.Now;

        public virtual Wallet? Wallet { get; set; }
        public virtual Invoice? Invoice { get; set; }
        public virtual TopupRequest? TopupRequest { get; set; }
    }
}

