<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InvoiceDetailPage.aspx.cs" Inherits="NhaTro_NMCNPM.Pages.InvoiceDetailPage" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Chi tiết hóa đơn - Ngân hàng nhà trọ</title>
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
        .card-container { background: #fff; padding: 25px; border-radius: 12px; max-width: 800px; margin: 0 auto; box-shadow: 0 2px 10px rgba(0,0,0,0.03); border: 1px solid #eaeaea; }
        .form-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        
        table { width: 100%; border-collapse: collapse; margin-top: 10px; margin-bottom: 20px; }
        th, td { border: 1px solid #e0e0e0; padding: 10px; text-align: center; font-size: 13px; }
        th { background-color: #fafafa; font-weight: 600; color: #444; }
        
        .btn-green { background-color: #28a745; color: white; border: none; padding: 10px 24px; border-radius: 8px; cursor: pointer; font-weight: bold; }
        .btn-green:hover { background-color: #218838; }
        
        .btn-red { background-color: #1b4d4f; color: white; border: none; padding: 10px 24px; border-radius: 8px; cursor: pointer; font-weight: bold; }
        .btn-red:hover { background-color: #143b3c; }
        
        .flex-between { display: flex; justify-content: space-between; margin-top: 25px; }
        .text-bold-red { color: #d9534f; font-weight: bold; }
        
        select, input[type="text"], input[type="date"] { padding: 6px 10px; border: 1px solid #ccc; border-radius: 6px; font-size: 13px; }
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
        <form id="formInvoiceDetail" runat="server">
            <div class="card-container">
                <h2 style="margin-bottom: 20px; font-size: 20px; color: #111;">Chi tiết hóa đơn</h2>
                
                <div class="form-header">
                    <asp:DropDownList ID="ddlRoomArea" runat="server">
                        <asp:ListItem Text="Phòng trọ khu vực A" Value="A" />
                    </asp:DropDownList>
                    <asp:TextBox ID="inputRecordedDate" runat="server" TextMode="Date"></asp:TextBox>
                </div>

                <div style="margin-bottom: 15px; background: #f8f9fa; padding: 12px; border-radius: 8px; border: 1px solid #eee;">
                    <label><b>Chọn phòng: </b></label>
                    <asp:DropDownList ID="ddlRoom" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlRoom_SelectedIndexChanged">
                        <asp:ListItem Text="101 Trần Đức Hùng" Value="101" />
                        <asp:ListItem Text="102 Nguyễn Ngọc Anh" Value="102" />
                    </asp:DropDownList>
                </div>

                <div style="font-size: 14px; line-height: 1.8; margin-bottom: 15px;">
                    <p>Giá phòng trọ: <span class="text-bold-red"><asp:Label ID="lblRoomFee" runat="server" Text="2.000.000 đ"></asp:Label></span></p>
                    <p>Dịch vụ khác (vệ sinh, wifi,...): 
                        <asp:TextBox ID="inputOtherServiceFee" runat="server" Text="100000" Width="100px" Style="text-align:right;" AutoPostBack="true" OnTextChanged="calculateTotal"></asp:TextBox> đ
                    </p>
                </div>

                <h3 style="font-size: 15px; color: #333; margin-top: 15px;">Tiền điện</h3>
                <table>
                    <tr>
                        <th>Chỉ số điện cũ (kwh)</th>
                        <th>Chỉ số điện mới (kwh)</th>
                        <th>Đơn giá (trên một số điện)</th>
                    </tr>
                    <tr>
                        <td><asp:TextBox ID="inputOldElec" runat="server" Text="125" Width="80px" Style="text-align:center;" AutoPostBack="true" OnTextChanged="calculateTotal"></asp:TextBox></td>
                        <td><asp:TextBox ID="inputNewElec" runat="server" Text="190" Width="80px" Style="text-align:center;" AutoPostBack="true" OnTextChanged="calculateTotal"></asp:TextBox></td>
                        <td><asp:TextBox ID="inputElecUnitPrice" runat="server" Text="3500" Width="90px" Style="text-align:center;" AutoPostBack="true" OnTextChanged="calculateTotal"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td colspan="2">Mức sử dụng: <b><asp:Label ID="lblElecUsage" runat="server" Text="65"></asp:Label></b></td>
                        <td>Thành tiền: <b><asp:Label ID="lblElecTotal" runat="server" Text="227.500 đ"></asp:Label></b></td>
                    </tr>
                </table>

                <h3 style="font-size: 15px; color: #333;">Tiền nước</h3>
                <table>
                    <tr>
                        <th>Số người</th>
                        <th>Số tiền/người</th>
                        <th>Thành tiền</th>
                    </tr>
                    <tr>
                        <td><asp:TextBox ID="inputPeopleCount" runat="server" Text="2" Width="60px" Style="text-align:center;" AutoPostBack="true" OnTextChanged="calculateTotal"></asp:TextBox></td>
                        <td><asp:TextBox ID="inputWaterUnitPrice" runat="server" Text="50000" Width="90px" Style="text-align:center;" AutoPostBack="true" OnTextChanged="calculateTotal"></asp:TextBox></td>
                        <td><b><asp:Label ID="lblWaterTotal" runat="server" Text="100.000 đ"></asp:Label></b></td>
                    </tr>
                </table>

                <h3 style="font-size: 15px; color: #333;">Tổng cộng</h3>
                <table>
                    <tr>
                        <th>Tổng tiền điện nước</th>
                        <th>Thành tiền (Giá phòng)</th>
                    </tr>
                    <tr>
                        <td><span class="text-bold-red"><asp:Label ID="lblTotalUtility" runat="server" Text="327.000 đ"></asp:Label></span></td>
                        <td><span class="text-bold-red"><asp:Label ID="lblTotalRoomWithUtility" runat="server" Text="2.327.000 đ"></asp:Label></span></td>
                    </tr>
                </table>

                <div class="flex-between">
                    <asp:Button ID="btnSaveDraft" runat="server" Text="Lưu bản nháp" CssClass="btn-green" OnClick="btnSaveDraft_Click" />
                    <asp:Button ID="btnPayNow" runat="server" Text="Thanh toán ngay" CssClass="btn-red" OnClick="btnPayNow_Click" />
                </div>
            </div>
        </form>
    </div>
</body>
</html>