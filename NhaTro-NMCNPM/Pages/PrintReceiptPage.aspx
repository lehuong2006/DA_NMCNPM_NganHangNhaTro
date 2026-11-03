<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PrintReceiptPage.aspx.cs" Inherits="NhaTro_NMCNPM.Pages.PrintReceiptPage" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Lập phiếu in - Ngân hàng nhà trọ</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background-color: #f8f9fa; display: flex; min-height: 100vh; }

        .sidebar { 
            width: 250px; 
            background-color: #ffffff; 
            border-right: 1px solid #eaeaea; 
            padding: 24px 16px; 
            display: flex; 
            flex-direction: column; 
            justify-content: space-between; 
            min-height: 100vh;
        }

        .sidebar-header { margin-bottom: 30px; }
        .sidebar-header h2 { font-size: 16px; color: #111; font-weight: 800; text-transform: uppercase; letter-spacing: 0.5px; }
        .sidebar-header p { font-size: 12px; color: #888; margin-top: 4px; }

        .sidebar-menu { list-style: none; }
        .sidebar-menu li { margin-bottom: 6px; }
        .sidebar-menu a { display: block; padding: 10px 16px; color: #555; text-decoration: none; font-size: 13.5px; border-radius: 8px; font-weight: 500; transition: all 0.2s; }
        .sidebar-menu a:hover { background-color: #f5f5f5; color: #111; }
        .sidebar-menu a.active { background-color: #e5ebe8; color: #111; font-weight: 700; }

        .sidebar-footer { border-top: none; padding-top: 15px; }
        .user-profile { display: flex; align-items: center; gap: 10px; margin-bottom: 15px; }
        .avatar-circle { width: 36px; height: 36px; background-color: #1b4d4f; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 14px; }
        .user-info { font-size: 13px; line-height: 1.3; }
        .user-info b { display: block; color: #222; }
        .user-info span { font-size: 11px; color: #777; }

        .btn-logout { width: 100%; padding: 8px; background: transparent; border: 1px solid #e0e0e0; border-radius: 6px; color: #555; font-size: 12px; cursor: pointer; text-align: center; }
        .btn-logout:hover { background-color: #f9f9f9; }

        .main-content { flex: 1; padding: 25px 30px; }
        .top-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .top-bar-title { font-size: 13px; color: #666; margin-bottom: 4px; }

        .btn-action-group { display: flex; gap: 10px; }
        .btn-back { background-color: #ffffff; color: #333; border: 1px solid #ccc; padding: 8px 18px; border-radius: 6px; cursor: pointer; font-weight: bold; }
        .btn-back:hover { background-color: #e9ecef; }
        
        .btn-print { background-color: #1b4d4f; color: white; border: none; padding: 8px 20px; border-radius: 6px; cursor: pointer; font-weight: bold; }
        .btn-print:hover { background-color: #143b3c; }

        .page-grid { display: flex; gap: 20px; }
        .left-panel { flex: 1; background: #fff; padding: 20px; border-radius: 12px; border: 1px solid #eaeaea; box-shadow: 0 2px 5px rgba(0,0,0,0.02); }
        .right-panel { flex: 1; background: #fff; padding: 25px; border-radius: 12px; border: 1px solid #ddd; box-shadow: 0 2px 5px rgba(0,0,0,0.02); }
        
        .badge-success { background: #d4edda; color: #155724; padding: 4px 10px; border-radius: 12px; font-size: 12px; display: inline-block; }
        .receipt-header { text-align: center; background: #6c757d; color: #fff; padding: 12px; border-radius: 6px; margin: 15px 0; }
        .receipt-table { width: 100%; border-collapse: collapse; margin: 15px 0; }
        .receipt-table th, .receipt-table td { border: 1px solid #ddd; padding: 8px 12px; text-align: left; font-size: 13px; }
        
        .btn-tab { padding: 8px 16px; border: 1px solid #1b4d4f; background: #fff; color: #1b4d4f; cursor: pointer; border-radius: 6px; font-weight: 500; }
        .btn-tab.active { background: #1b4d4f; color: white; font-weight: bold; }

        select, input[type="text"], input[type="date"] { padding: 6px 10px; border: 1px solid #ccc; border-radius: 6px; font-size: 13px; }

        @media print {
            .sidebar, .top-bar, .left-panel, .btn-action-group { display: none !important; }
            body { background: white; margin: 0; padding: 0; }
            .main-content { padding: 0; }
            .page-grid { display: block; }
            .right-panel { border: none; box-shadow: none; width: 100%; }
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <div>
            <div class="sidebar-header">
                <h2>NGÂN HÀNG NHÀ TRỌ</h2>
                <p>Nhà trọ số 8 Nguyễn An Ninh</p>
            </div>
            <ul class="sidebar-menu">
                <li><a href="#">Tổng quan</a></li>
                <li><a href="#">Phòng</a></li>
                <li><a href="#">Người thuê</a></li>
                <li><a href="#">Hợp đồng</a></li>
                <li><a href="#" class="active">Hóa đơn</a></li>
                <li><a href="#">Giao dịch ví</a></li>
                <li><a href="#">Lịch sử giao dịch</a></li>
            </ul>
        </div>
        <div class="sidebar-footer">
            <div class="user-profile">
                <div class="avatar-circle">Q</div>
                <div class="user-info">
                    <b>Quản lý</b>
                    <span>Chủ trọ</span>
                </div>
            </div>
            <button type="button" class="btn-logout">Đăng xuất</button>
        </div>
    </div>

    <div class="main-content">
        <form id="formPrintReceipt" runat="server">
            <div class="top-bar">
                <div>
                    <div class="top-bar-title">Tổng quan / In phiếu</div>
                    <h2 style="font-size: 20px; color: #111;">Lập phiếu in</h2>
                </div>
                <div class="btn-action-group">
                    <asp:Button ID="btnBack" runat="server" Text="Quay lại" CssClass="btn-back" OnClick="btnBack_Click" />
                    <asp:Button ID="btnPrintReceipt" runat="server" Text="In hóa đơn" CssClass="btn-print" OnClick="btnPrintReceipt_Click" OnClientClick="window.print(); return false;" />
                </div>
            </div>

            <div class="page-grid">
                <div class="left-panel">
                    <h3 style="font-size: 15px; margin-bottom: 12px;">1. Xác nhận thanh toán & Số tiền đã nhận</h3>
                    <p style="font-size: 14px; margin-bottom: 5px;">Phòng: <b>P102, Tầng 1</b> <span class="badge-success">Thanh toán thành công</span></p>
                    <p style="font-size: 13px; color: #555; margin-bottom: 15px;">Giá thuê: <b>2.500.000 đ/tháng</b> | Diện tích: <b>20m2</b></p>
                    
                    <div style="margin-bottom: 15px;">
                        <label style="font-size: 13px; font-weight: bold;">Số tiền thực tế đã nhận:</label><br />
                        <asp:TextBox ID="inputActualAmount" runat="server" Text="3.150.000 VND" Font-Bold="true" Style="padding: 6px; margin-top: 4px;"></asp:TextBox>
                        <asp:TextBox ID="inputPaymentDate" runat="server" TextMode="Date" Style="padding: 5px;"></asp:TextBox>
                    </div>

                    <h4 style="font-size: 13px; margin-bottom: 8px;">Các khoản đã thanh toán:</h4>
                    <div style="font-size: 13px; margin-bottom: 15px;">
                        <asp:CheckBox ID="chkRoom" runat="server" Checked="true" Text="Tiền phòng " />
                        <asp:CheckBox ID="chkElectricity" runat="server" Checked="true" Text="Tiền điện " />
                        <asp:CheckBox ID="chkWater" runat="server" Checked="true" Text="Tiền nước " />
                        <asp:CheckBox ID="chkOtherService" runat="server" Text="Dịch vụ" />
                    </div>

                    <h3 style="font-size: 15px; margin-bottom: 12px;">2. Hình thức nhận:</h3>
                    <div style="margin-bottom: 12px;">
                        <asp:Button ID="btnCash" runat="server" Text="Tiền mặt" CssClass="btn-tab active" OnClick="btnCash_Click" />
                        <asp:Button ID="btnBank" runat="server" Text="Chuyển khoản" CssClass="btn-tab" OnClick="btnBank_Click" />
                    </div>
                    
                    <div style="margin-bottom: 10px;">
                        <label style="font-size: 13px;">Ngân hàng:</label><br />
                        <asp:DropDownList ID="ddlBankName" runat="server" Width="95%" Style="padding: 6px; margin-top: 3px;">
                            <asp:ListItem Text="-- Chọn ngân hàng --" Value="" />
                            <asp:ListItem Text="Vietcombank (VCB)" Value="Vietcombank" />
                            <asp:ListItem Text="BIDV (Ngân hàng Đầu tư và Phát triển)" Value="BIDV" />
                            <asp:ListItem Text="VietinBank (Ngân hàng Công Thương)" Value="VietinBank" />
                            <asp:ListItem Text="Techcombank" Value="Techcombank" />
                            <asp:ListItem Text="TPBank (Tiên Phong Bank)" Value="TPBank" />
                            <asp:ListItem Text="MB Bank (Ngân hàng Quân Đội)" Value="MB Bank" />
                            <asp:ListItem Text="VPBank" Value="VPBank" />
                            <asp:ListItem Text="Agribank" Value="Agribank" />
                            <asp:ListItem Text="ACB (Ngân hàng Á Châu)" Value="ACB" />
                            <asp:ListItem Text="Sacombank" Value="Sacombank" />
                        </asp:DropDownList>
                    </div>
                    
                    <div style="display:flex; gap:10px; margin-bottom: 10px;">
                        <div>
                            <label style="font-size: 13px;">Ngày chuyển:</label><br />
                            <asp:TextBox ID="inputTransferDate" runat="server" TextMode="Date" Style="padding: 5px; margin-top: 3px;"></asp:TextBox>
                        </div>
                        <div>
                            <label style="font-size: 13px;">Mã giao dịch:</label><br />
                            <asp:TextBox ID="inputTransactionCode" runat="server" Text="10012026" Style="padding: 5px; margin-top: 3px;"></asp:TextBox>
                        </div>
                    </div>

                    <div>
                        <label style="font-size: 13px;">Ghi chú:</label><br />
                        <asp:TextBox ID="inputNote" runat="server" TextMode="MultiLine" Rows="2" Width="95%" Style="padding: 6px; margin-top: 3px;"></asp:TextBox>
                    </div>
                </div>

                <div class="right-panel">
                    <h3 style="text-align:center; font-size: 16px;">Hóa đơn dịch vụ</h3>
                    <div class="receipt-header">
                        <h4 style="margin: 3px 0; font-size: 15px;">PHIẾU THANH TOÁN THÀNH CÔNG</h4>
                        <small>Dịch vụ: Điện, Nước, Tiền phòng, Vệ sinh,...</small>
                    </div>
                    
                    <div style="display:flex; justify-content:space-between; font-size: 13px; margin-bottom: 15px;">
                        <span>Số: <b><asp:Label ID="lblInvoiceCode" runat="server" Text="HD-2610-001"></asp:Label></b></span>
                        <span>Ngày lập: <b><asp:Label ID="lblCreatedDate" runat="server" Text="01/10/2026"></asp:Label></b></span>
                    </div>
                    
                    <div style="font-size: 13px; line-height: 1.6; margin-bottom: 10px;">
                        <p><b>Thông tin người thuê:</b></p>
                        <p>Tên: <b><asp:Label ID="lblTenantName" runat="server" Text="Trần Đức Hùng"></asp:Label></b> | Phòng: <b><asp:Label ID="lblRoomName" runat="server" Text="P101"></asp:Label></b></p>
                        <p>Căn cước: <b>015206000881</b> | Tầng: <b>1</b></p>
                        <p>Điện thoại: <b>0344534567</b></p>
                    </div>

                    <table class="receipt-table">
                        <tr>
                            <th>Dịch vụ</th>
                            <th>Đơn giá</th>
                            <th>Thành tiền</th>
                        </tr>
                        <tr>
                            <td>Tiền phòng</td>
                            <td>2.500.000</td>
                            <td>2.500.000</td>
                        </tr>
                        <tr>
                            <td>Tiền điện</td>
                            <td>3.500</td>
                            <td>350.000</td>
                        </tr>
                        <tr>
                            <td>Tiền nước</td>
                            <td>50.000/ng</td>
                            <td>100.000</td>
                        </tr>
                        <tr>
                            <td>Khác</td>
                            <td>100.000</td>
                            <td>200.000</td>
                        </tr>
                    </table>

                    <p style="text-align:right; font-size: 15px; margin-top: 10px;"><b>Thành tiền: <asp:Label ID="lblTotalReceipt" runat="server" Text="3.150.000 VND" ForeColor="Red"></asp:Label></b></p>

                    <div style="display:flex; justify-content:space-between; text-align:center; margin-top:40px; font-size: 13px;">
                        <div>
                            <b>Chủ trọ / Người lập phiếu</b><br />
                            <small style="color: #777;">(Ký, ghi rõ họ tên)</small>
                        </div>
                        <div>
                            <b>Khách thuê / Người nộp tiền</b><br />
                            <small style="color: #777;">(Ký, ghi rõ họ tên)</small>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</body>
</html>