<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="YeuCauNapTien.aspx.cs" Inherits="CNPM.YeuCauNapTien" ResponseEncoding="utf-8" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Ví Và Nạp Tiền - Ngân Hàng Nhà Trọ</title>
    <link rel="stylesheet" href="content/yeucaunaptien.css" />
    <script type="text/javascript">
        function selectQuickAmount(amount) {
            var txtAmount = document.getElementById('<%= txtAmount.ClientID %>');
            if (txtAmount) {
                txtAmount.value = amount.toLocaleString('vi-VN');
            }
        }
        function copyText(elementId) {
            var text = document.getElementById(elementId).innerText;
            navigator.clipboard.writeText(text).then(function() {
                alert('Đã sao chép: ' + text);
            });
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="app-layout">
            <!-- SIDEBAR -->
            <aside class="sidebar">
                <div>
                    <div class="brand-header">
                        <div class="brand-title">Ngân hàng nhà trọ</div>
                        <div class="brand-sub">Nhà trọ số 8 Nguyễn An Ninh</div>
                    </div>

                    <ul class="menu-list">
                        <li>
                            <a href="KhachThue.aspx" class="menu-item">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                                <span>Tổng quan</span>
                            </a>
                        </li>
                        <li>
                            <a href="DanhSachPhong.aspx" class="menu-item">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path></svg>
                                <span>Phòng</span>
                            </a>
                        </li>
                        <li>
                            <a href="QLNguoiThue.aspx" class="menu-item">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"></path></svg>
                                <span>Người thuê</span>
                            </a>
                        </li>
                        <li>
                            <a href="TransactionHistory.aspx" class="menu-item">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg>
                                <span>Hợp đồng</span>
                            </a>
                        </li>
                        <li>
                            <a href="Pages/InvoiceDetailPage.aspx" class="menu-item">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 14l6-6m-5.5.5h.01m4.99 5h.01M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16l4-2 4 2 4-2 4 2z"></path></svg>
                                <span>Hóa đơn</span>
                            </a>
                        </li>
                        <li>
                            <a href="YeuCauNapTien.aspx" class="menu-item active">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"></path></svg>
                                <span>Giao dịch ví</span>
                            </a>
                        </li>
                    </ul>
                </div>

                <!-- USER PROFILE BOTTOM -->
                <div class="user-profile">
                    <div class="user-avatar">
                        <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path></svg>
                    </div>
                    <div class="user-info">
                        <div class="user-name"><asp:Literal ID="litUserName" runat="server">Quân - Chủ trọ</asp:Literal></div>
                        <a href="DangNhap.aspx" class="logout-link">Đăng xuất</a>
                    </div>
                </div>
            </aside>

            <!-- MAIN CONTENT -->
            <main class="main-content">
                <!-- HEADER BANNER -->
                <div class="header-banner">
                    <h1 class="page-title">Ví Và Nạp Tiền</h1>
                    <div class="page-subtitle"><asp:Literal ID="litGreeting" runat="server">Xin chào Quân. Tình hình nhà trọ tháng 10/2026</asp:Literal></div>
                </div>

                <!-- TOP ROW: THẺ VÍ & THÔNG TIN CHUYỂN KHOẢN -->
                <div class="top-wallet-row">
                    <!-- THẺ NGÂN HÀNG / VÍ NỘI BỘ -->
                    <div class="bank-card">
                        <div class="card-top">
                            <span class="card-holder"><asp:Literal ID="litCardHolder" runat="server">Nguyễn Anh Quân</asp:Literal></span>
                            <div class="card-chip"></div>
                        </div>
                        <div class="card-balance-section">
                            <div class="balance-label">số dư hiện tại:</div>
                            <div class="balance-amount"><asp:Literal ID="litBalance" runat="server">15.000.000 VNĐ</asp:Literal></div>
                        </div>
                        <div class="card-footer">
                            <span>VÍ TIỆN ÍCH NHÀ TRỌ</span>
                            <span>SỐ 8 NGUYỄN AN NINH</span>
                        </div>
                    </div>

                    <!-- THÔNG TIN CHUYỂN KHOẢN CARD -->
                    <div class="transfer-info-card">
                        <div class="qr-container">
                            <img src="content/images/techcombank_qr.png" alt="Techcombank QR Code" class="qr-image" />
                        </div>
                        <div class="transfer-details">
                            <h2 class="transfer-title">Thông tin chuyển khoản</h2>
                            <div class="detail-line">
                                <strong>Ngân hàng:</strong> Techcombank
                            </div>
                            <div class="detail-line">
                                <strong>STK:</strong> <span id="spanSTK">190368688888</span>
                                <a href="javascript:void(0)" class="copy-badge" onclick="copyText('spanSTK')">Sao chép</a>
                            </div>
                            <div class="detail-line">
                                <strong>Chủ TK:</strong> NGUYEN ANH QUAN
                            </div>
                            <div class="detail-line">
                                <strong>Nội dung:</strong> <span id="spanContent">NAP P202 0987654321</span>
                                <a href="javascript:void(0)" class="copy-badge" onclick="copyText('spanContent')">Sao chép</a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- BOTTOM ROW: FORM NẠP TIỀN & LỊCH SỬ GIAO DỊCH -->
                <div class="bottom-content-row">
                    <!-- KHUNG GỬI YÊU CẦU NẠP TIỀN -->
                    <div class="topup-form-panel">
                        <h2 class="form-panel-title">GỬI YÊU CẦU NẠP TIỀN</h2>

                        <div class="section-sublabel">số dư ví nạp tiền:</div>
                        <div class="quick-chips-grid">
                            <button type="button" class="quick-chip" onclick="selectQuickAmount(100000)">100k</button>
                            <button type="button" class="quick-chip" onclick="selectQuickAmount(1200000)">1200k</button>
                            <button type="button" class="quick-chip" onclick="selectQuickAmount(1500000)">1500k</button>
                            <button type="button" class="quick-chip" onclick="selectQuickAmount(2000000)">2000k</button>
                            <button type="button" class="quick-chip" onclick="selectQuickAmount(2500000)">2500k</button>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="txtAmount">số dư nạp tiền</label>
                            <asp:TextBox ID="txtAmount" runat="server" CssClass="form-control-input" placeholder="Ví dụ: 1.500.000" />
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="txtNote">nội dung</label>
                            <asp:TextBox ID="txtNote" runat="server" CssClass="form-control-input" placeholder="NAP P203 0987654321" />
                        </div>

                        <asp:Button ID="btnSubmitTopUp" runat="server" Text="GỬI YÊU CẦU NẠP TIỀN" OnClick="btnSubmitTopUp_Click" CssClass="btn-submit-topup" />

                        <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert-message">
                            <asp:Literal ID="litMessage" runat="server" />
                        </asp:Panel>
                    </div>

                    <!-- LỊCH SỬ GIAO DỊCH PANEL -->
                    <div class="history-table-panel">
                        <h2 class="history-title">Lịch Sử Giao Dịch</h2>
                        <div class="table-responsive">
                            <table class="history-table">
                                <thead>
                                    <tr>
                                        <th>Ngày giao dịch</th>
                                        <th>Mã giao dịch</th>
                                        <th>Loại</th>
                                        <th>Số Tiền</th>
                                        <th>Trạng Thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Repeater ID="rptTransactions" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td><%# Eval("TransactionDate") %></td>
                                                <td><%# Eval("TransactionCode") %></td>
                                                <td><%# Eval("TransactionType") %></td>
                                                <td><strong><%# Eval("AmountFormatted") %></strong></td>
                                                <td>
                                                    <span class='status-badge <%# Eval("BadgeClass") %>'>
                                                        <%# Eval("StatusName") %>
                                                    </span>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </form>
</body>
</html>
