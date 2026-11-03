using NhaTro_NMCNPM.Models;
using NhaTro_NMCNPM.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NhaTro_NMCNPM.Pages
{
    public partial class InvoiceDetailPage : System.Web.UI.Page
    {
        private InvoiceService invoiceService = new InvoiceService();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                inputRecordedDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                calculateTotal(null, null);
            }
        }

        protected void ddlRoom_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlRoom.SelectedValue == "101")
            {
                lblRoomFee.Text = "2.500.000 đ";
            }
            else if (ddlRoom.SelectedValue == "102")
            {
                lblRoomFee.Text = "2.800.000 đ";
            }
            calculateTotal(null, null);
        }

        protected void calculateTotal(object sender, EventArgs e)
        {
            int oldElec = int.TryParse(inputOldElec.Text, out oldElec) ? oldElec : 0;
            int newElec = int.TryParse(inputNewElec.Text, out newElec) ? newElec : 0;
            decimal elecPrice = decimal.TryParse(inputElecUnitPrice.Text, out elecPrice) ? elecPrice : 3500;
            int people = int.TryParse(inputPeopleCount.Text, out people) ? people : 1;
            decimal waterPrice = decimal.TryParse(inputWaterUnitPrice.Text, out waterPrice) ? waterPrice : 50000;
            decimal otherFee = decimal.TryParse(inputOtherServiceFee.Text, out otherFee) ? otherFee : 100000;

            decimal roomFee = ddlRoom.SelectedValue == "102" ? 2800000 : 2500000;

            MeterReading meterReading = new MeterReading
            {
                oldElectricity = oldElec,
                newElectricity = newElec,
                electricityUnitPrice = elecPrice,
                tenantCount = people,
                waterUnitPrice = waterPrice
            };

            lblElecUsage.Text = meterReading.electricityUsage.ToString();
            lblElecTotal.Text = $"{meterReading.totalElectricityFee:N0} đ";
            lblWaterTotal.Text = $"{meterReading.totalWaterFee:N0} đ";
            lblTotalUtility.Text = $"{meterReading.totalUtilityFee:N0} đ";

            decimal totalAll = roomFee + meterReading.totalUtilityFee + otherFee;
            lblTotalRoomWithUtility.Text = $"{totalAll:N0} đ";
        }

        protected void btnSaveDraft_Click(object sender, EventArgs e)
        {
            try
            {
                int roomId = int.Parse(ddlRoom.SelectedValue);
                DateTime recordDate = DateTime.Parse(inputRecordedDate.Text);
                decimal roomFee = ddlRoom.SelectedValue == "102" ? 2800000 : 2500000;

                MeterReading meter = new MeterReading
                {
                    oldElectricity = int.Parse(inputOldElec.Text),
                    newElectricity = int.Parse(inputNewElec.Text),
                    electricityUnitPrice = decimal.Parse(inputElecUnitPrice.Text),
                    tenantCount = int.Parse(inputPeopleCount.Text),
                    waterUnitPrice = decimal.Parse(inputWaterUnitPrice.Text)
                };

                bool isSuccess = invoiceService.saveInvoiceDraft(roomId, recordDate, meter, roomFee);

                if (isSuccess)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Đã lưu bản nháp vào CSDL thành công!');", true);
                }
                else
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Lưu CSDL thất bại, vui lòng kiểm tra kết nối!');", true);
                }
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('Lỗi: {ex.Message}');", true);
            }
        }

        protected void btnPayNow_Click(object sender, EventArgs e)
        {
            string recordDate = inputRecordedDate.Text;
            Response.Redirect($"PrintReceiptPage.aspx?date={recordDate}&room={ddlRoom.SelectedValue}");
        }
    }
    
}