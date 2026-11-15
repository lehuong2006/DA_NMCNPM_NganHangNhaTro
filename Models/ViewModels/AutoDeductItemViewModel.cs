namespace BTL_NganHangNhaTro.Models.ViewModels
{
    public class AutoDeductItemViewModel
    {
        public DateTime ExecutedAt { get; set; }
        public string InvoicePeriod { get; set; } = string.Empty;
        public string RoomCode { get; set; } = string.Empty;
        public string TenantName { get; set; } = string.Empty;
        public long Amount { get; set; }
        public string Status { get; set; } = "Thành công";
    }
}
