namespace BTL_NganHangNhaTro.Models
{
    public class Wallet
    {
        public long Id { get; set; }
        public long UserId { get; set; }
        public long Balance { get; set; } = 0;
        public string Status { get; set; } = "ACTIVE";
        public DateTime? UpdatedAt { get; set; }

        public virtual User? User { get; set; }
        public virtual ICollection<Transaction> Transactions { get; set; } = new List<Transaction>();
    }
}

