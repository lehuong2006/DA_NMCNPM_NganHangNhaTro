using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace NhaTro_NMCNPM.Models
{
    // Enum định nghĩa trạng thái hóa đơn
    public enum InvoiceStatus
    {
        UNPAID,
        PAID
    }

    // Enum định nghĩa hình thức thanh toán
    public enum PaymentMethod
    {
        CASH,
        BANK_TRANSFER
    }
    public class Invoice
    {
        public int id { get; set; }
        public string invoiceCode { get; set; }
        public int roomId { get; set; }
        public int tenantId { get; set; }
        public int? meterReadingId { get; set; }
        public int roomFee { get; set; }
        public int electricityFee { get; set; }
        public int waterFee { get; set; }
        public int otherFee { get; set; }
        public int totalAmount { get; set; }
        public int actualReceivedAmount { get; set; }
        public string paymentMethod { get; set; }
        public string bankName { get; set; }
        public string transactionCode { get; set; }
        public DateTime? paymentDate { get; set; }
        public string note { get; set; }
        public string status { get; set; }
        public DateTime createdAt { get; set; }
        public DateTime? paidAt { get; set; }
    }
}