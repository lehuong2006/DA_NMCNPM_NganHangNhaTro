using NhaTro_NMCNPM.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NhaTro_NMCNPM.Pages
{
    public partial class PrintReceiptPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblCreatedDate.Text = DateTime.Now.ToString("dd/MM/yyyy");
                inputTransferDate.Text = DateTime.Now.ToString("yyyy-MM-dd");

                if (Request.QueryString["date"] != null)
                {
                    inputPaymentDate.Text = Request.QueryString["date"];
                }
                else
                {
                    inputPaymentDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                }

                if (Request.QueryString["room"] != null)
                {
                    string roomVal = Request.QueryString["room"];
                    if (roomVal == "102")
                    {
                        lblTenantName.Text = "Nguyễn Ngọc Anh";
                        lblRoomName.Text = "P102";
                    }
                    else
                    {
                        lblTenantName.Text = "Trần Đức Hùng";
                        lblRoomName.Text = "P101";
                    }
                }

                setPaymentMode(isBankTransfer: false);
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("InvoiceDetailPage.aspx");
        }

        protected void btnPrintReceipt_Click(object sender, EventArgs e)
        {
            try
            {
                InvoiceService service = new InvoiceService();

                string code = lblInvoiceCode.Text;
                decimal amount = decimal.Parse(inputActualAmount.Text.Replace(".", "").Replace("VND", "").Trim());
                string method = btnBank.CssClass.Contains("active") ? "BANK_TRANSFER" : "CASH";
                string bank = ddlBankName.SelectedValue;
                string transCode = inputTransactionCode.Text;
                DateTime payDate = DateTime.Parse(inputPaymentDate.Text);
                string note = inputNote.Text;

                bool success = service.confirmPayment(code, amount, method, bank, transCode, payDate, note);
                if (success)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Xác nhận thanh toán thành công và đã cập nhật CSDL!');", true);
                }
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Lỗi: " + ex.Message + "');", true);
            }
        }

        protected void btnCash_Click(object sender, EventArgs e)
        {
            btnCash.CssClass = "btn-tab active";
            btnBank.CssClass = "btn-tab";
            setPaymentMode(isBankTransfer: false);
        }

        protected void btnBank_Click(object sender, EventArgs e)
        {
            btnBank.CssClass = "btn-tab active";
            btnCash.CssClass = "btn-tab";
            setPaymentMode(isBankTransfer: true);
        }

        private void setPaymentMode(bool isBankTransfer)
        {
            ddlBankName.Enabled = isBankTransfer;
            inputTransferDate.Enabled = isBankTransfer;
            inputTransactionCode.Enabled = isBankTransfer;

            if (!isBankTransfer)
            {
                ddlBankName.SelectedIndex = 0;
            }
        }
    }
}