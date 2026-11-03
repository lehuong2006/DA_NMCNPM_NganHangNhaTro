using NhaTro_NMCNPM.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace NhaTro_NMCNPM.Services
{
    public class InvoiceService
    {
        // Tính toán tổng tiền hóa đơn dự thảo
            private string connectionString = ConfigurationManager.ConnectionStrings["NganHangNhaTroDB"].ConnectionString;

            public Invoice calculateInvoiceDraft(int roomFee, MeterReading meterReading)
            {
                int totalElectricity = (meterReading.newElectricity - meterReading.oldElectricity) * (int)meterReading.electricityUnitPrice;
                int totalWater = meterReading.tenantCount * (int)meterReading.waterUnitPrice;
                int totalAll = roomFee + totalElectricity + totalWater + (int)meterReading.totalInternetFee + (int)meterReading.totalElevatorFee;

                return new Invoice
                {
                    roomFee = roomFee,
                    electricityFee = totalElectricity,
                    waterFee = totalWater,
                    otherFee = (int)(meterReading.totalInternetFee + meterReading.totalElevatorFee),
                    totalAmount = totalAll,
                    status = InvoiceStatus.UNPAID.ToString()
                };
            }

            public bool saveInvoiceDraft(int roomId, DateTime recordedDate, MeterReading meter, decimal roomFee)
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlTransaction transaction = conn.BeginTransaction();

                    try
                    {
                        int month = recordedDate.Month;
                        int year = recordedDate.Year;

                        string sqlMeter = @"
                        IF EXISTS (SELECT 1 FROM meter_readings WHERE room_id = @roomId AND billing_month = @month AND billing_year = @year)
                        BEGIN
                            UPDATE meter_readings 
                            SET old_electricity = @oldElec, new_electricity = @newElec,
                                tenant_count = @tenantCount, electricity_unit_price = @elecPrice,
                                water_unit_price = @waterPrice, recorded_at = GETDATE()
                            WHERE room_id = @roomId AND billing_month = @month AND billing_year = @year;
                            
                            SELECT reading_id FROM meter_readings WHERE room_id = @roomId AND billing_month = @month AND billing_year = @year;
                        END
                        ELSE
                        BEGIN
                            INSERT INTO meter_readings 
                            (room_id, billing_month, billing_year, old_electricity, new_electricity, old_water, new_water, tenant_count, electric_vehicle_count, electricity_unit_price, water_unit_price, internet_unit_price, elevator_unit_price, washing_unit_price, ev_charging_unit_price, recorded_at)
                            VALUES (@roomId, @month, @year, @oldElec, @newElec, 0, 0, @tenantCount, 0, @elecPrice, @waterPrice, 50000, 100000, 50000, 100000, GETDATE());
                            
                            SELECT SCOPE_IDENTITY();
                        END";

                        SqlCommand cmdMeter = new SqlCommand(sqlMeter, conn, transaction);
                        cmdMeter.Parameters.AddWithValue("@roomId", roomId);
                        cmdMeter.Parameters.AddWithValue("@month", month);
                        cmdMeter.Parameters.AddWithValue("@year", year);
                        cmdMeter.Parameters.AddWithValue("@oldElec", meter.oldElectricity);
                        cmdMeter.Parameters.AddWithValue("@newElec", meter.newElectricity);
                        cmdMeter.Parameters.AddWithValue("@tenantCount", meter.tenantCount);
                        cmdMeter.Parameters.AddWithValue("@elecPrice", meter.electricityUnitPrice);
                        cmdMeter.Parameters.AddWithValue("@waterPrice", meter.waterUnitPrice);

                        int readingId = Convert.ToInt32(cmdMeter.ExecuteScalar());

                        string sqlContract = "SELECT TOP 1 contract_id FROM contracts WHERE room_id = @roomId AND status = 'Active'";
                        SqlCommand cmdContract = new SqlCommand(sqlContract, conn, transaction);
                        cmdContract.Parameters.AddWithValue("@roomId", roomId);
                        object contractObj = cmdContract.ExecuteScalar();
                        int contractId = contractObj != null ? Convert.ToInt32(contractObj) : 1;

                        decimal elecFee = meter.totalElectricityFee;
                        decimal waterFee = meter.totalWaterFee;
                        decimal internetFee = meter.totalInternetFee;
                        decimal elevatorFee = meter.totalElevatorFee;
                        decimal washingFee = meter.totalWashingFee;
                        decimal evFee = meter.totalEvChargingFee;
                        decimal totalAmount = roomFee + elecFee + waterFee + internetFee + elevatorFee + washingFee + evFee;

                        string invoiceCode = $"HD-{year.ToString().Substring(2)}{month:D2}-{roomId:D3}";
                        DateTime dueDate = new DateTime(year, month, 5).AddMonths(1);

                        string sqlInvoice = @"
                        IF EXISTS (SELECT 1 FROM invoices WHERE room_id = @roomId AND billing_month = @month AND billing_year = @year)
                        BEGIN
                            UPDATE invoices 
                            SET room_fee = @roomFee, electricity_fee = @elecFee, water_fee = @waterFee,
                                internet_fee = @internetFee, elevator_fee = @elevatorFee, washing_fee = @washingFee,
                                ev_charging_fee = @evFee, total_amount = @totalAmount, remaining_amount = @totalAmount
                            WHERE room_id = @roomId AND billing_month = @month AND billing_year = @year;
                        END
                        ELSE
                        BEGIN
                            INSERT INTO invoices 
                            (invoice_code, contract_id, room_id, reading_id, billing_month, billing_year, room_fee, electricity_fee, water_fee, internet_fee, elevator_fee, washing_fee, ev_charging_fee, total_amount, paid_amount, remaining_amount, status, due_date, created_at)
                            VALUES (@code, @contractId, @roomId, @readingId, @month, @year, @roomFee, @elecFee, @waterFee, @internetFee, @elevatorFee, @washingFee, @evFee, @totalAmount, 0, @totalAmount, 'Unpaid', @dueDate, GETDATE());
                        END";

                        SqlCommand cmdInvoice = new SqlCommand(sqlInvoice, conn, transaction);
                        cmdInvoice.Parameters.AddWithValue("@code", invoiceCode);
                        cmdInvoice.Parameters.AddWithValue("@contractId", contractId);
                        cmdInvoice.Parameters.AddWithValue("@roomId", roomId);
                        cmdInvoice.Parameters.AddWithValue("@readingId", readingId);
                        cmdInvoice.Parameters.AddWithValue("@month", month);
                        cmdInvoice.Parameters.AddWithValue("@year", year);
                        cmdInvoice.Parameters.AddWithValue("@roomFee", roomFee);
                        cmdInvoice.Parameters.AddWithValue("@elecFee", elecFee);
                        cmdInvoice.Parameters.AddWithValue("@waterFee", waterFee);
                        cmdInvoice.Parameters.AddWithValue("@internetFee", internetFee);
                        cmdInvoice.Parameters.AddWithValue("@elevatorFee", elevatorFee);
                        cmdInvoice.Parameters.AddWithValue("@washingFee", washingFee);
                        cmdInvoice.Parameters.AddWithValue("@evFee", evFee);
                        cmdInvoice.Parameters.AddWithValue("@totalAmount", totalAmount);
                        cmdInvoice.Parameters.AddWithValue("@dueDate", dueDate);

                        cmdInvoice.ExecuteNonQuery();

                        transaction.Commit();
                        return true;
                    }
                    catch (Exception)
                    {
                        transaction.Rollback();
                        return false;
                    }
                }
            }

            public bool confirmPayment(string invoiceCode, decimal actualAmount, string paymentMethod, string bankName, string transactionCode, DateTime paymentDate, string note)
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string sql = @"UPDATE invoices 
                    SET paid_amount = @actualAmount,
                        remaining_amount = total_amount - @actualAmount,
                        status = CASE WHEN (total_amount - @actualAmount) <= 0 THEN 'Paid' ELSE 'Debt' END,
                        paid_at = GETDATE()
                    WHERE invoice_code = @code";

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@code", invoiceCode);
                    cmd.Parameters.AddWithValue("@actualAmount", actualAmount);

                    conn.Open();
                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }
}