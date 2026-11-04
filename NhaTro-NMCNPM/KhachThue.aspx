<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="KhachThue.aspx.cs" Inherits="CNPM.KhachThue" ResponseEncoding="utf-8" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Trang Chủ Khách Thuê - Ngân Hàng Nhà Trọ</title>
    <link rel="stylesheet" href="content/khachthue.css" />
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
                            <a href="KhachThue.aspx" class="menu-item active">
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
                            <a href="YeuCauNapTien.aspx" class="menu-item">
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
                <!-- GREETING BANNER -->
                <div class="greeting-banner">
                    <h1 class="greeting-title">Xin chào bạn</h1>
                </div>

                <!-- 4 TOP STAT CARDS -->
                <div class="stat-cards-grid">
                    <!-- CARD 1 -->
                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-label">Phòng đang ở</span>
                            <div class="stat-icon stat-icon-blue">
                                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                            </div>
                        </div>
                        <div class="stat-value"><asp:Literal ID="litRoomCode" runat="server">P 203</asp:Literal></div>
                        <div class="stat-subtext"><asp:Literal ID="litRoomFloor" runat="server">Tầng 2-Nhà A</asp:Literal></div>
                    </div>

                    <!-- CARD 2 -->
                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-label">Hóa đơn tháng này</span>
                            <div class="stat-icon stat-icon-orange">
                                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 14l6-6m-5.5.5h.01m4.99 5h.01M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16l4-2 4 2 4-2 4 2z"></path></svg>
                            </div>
                        </div>
                        <div class="stat-value"><asp:Literal ID="litCurrentInvoice" runat="server">2.870.000 đ</asp:Literal></div>
                        <div class="stat-subtext">Hạn đến 10/10/2026</div>
                    </div>

                    <!-- CARD 3 -->
                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-label">Đã thanh toán</span>
                            <div class="stat-icon stat-icon-green">
                                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                            </div>
                        </div>
                        <div class="stat-value"><asp:Literal ID="litPaidCount" runat="server">1</asp:Literal></div>
                        <div class="stat-subtext">Hóa đơn tháng trước</div>
                    </div>

                    <!-- CARD 4 -->
                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-label">Dịch vụ đang dùng</span>
                            <div class="stat-icon stat-icon-purple">
                                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path></svg>
                            </div>
                        </div>
                        <div class="stat-value"><asp:Literal ID="litServiceCount" runat="server">2</asp:Literal></div>
                        <div class="stat-subtext">Internet & Nước sạch</div>
                    </div>
                </div>

                <!-- MIDDLE ROW: BẢNG HÓA ĐƠN & THAO TÁC NHANH -->
                <div class="content-grid-row">
                    <!-- BẢNG HÓA ĐƠN -->
                    <div class="card-panel">
                        <div class="panel-header">
                            <h2 class="panel-title">Hóa Đơn</h2>
                        </div>
                        <div class="table-responsive">
                            <table class="custom-table">
                                <thead>
                                    <tr>
                                        <th>Tháng</th>
                                        <th>Loại phí</th>
                                        <th>Số tiền</th>
                                        <th>Hạn thanh toán</th>
                                        <th>Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>10/2026</td>
                                        <td>Tiền phòng</td>
                                        <td><strong>1.500.000 đ</strong></td>
                                        <td>10/10/2026</td>
                                        <td><span class="badge-unpaid">Chưa thanh toán</span></td>
                                    </tr>
                                    <tr>
                                        <td>10/2026</td>
                                        <td>Nước</td>
                                        <td><strong>150.000 đ</strong></td>
                                        <td>10/10/2026</td>
                                        <td><span class="badge-unpaid">Chưa thanh toán</span></td>
                                    </tr>
                                    <tr>
                                        <td>10/2026</td>
                                        <td>Điện</td>
                                        <td><strong>350.000 đ</strong></td>
                                        <td>10/10/2026</td>
                                        <td><span class="badge-unpaid">Chưa thanh toán</span></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- THAO TÁC NHANH -->
                    <div class="card-panel">
                        <div class="panel-header">
                            <h2 class="panel-title">Thao tác nhanh</h2>
                        </div>
                        <div class="quick-action-list">
                            <a href="YeuCauNapTien.aspx" class="quick-action-btn">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z"></path></svg>
                                <span>Thanh toán hóa đơn</span>
                            </a>
                            <a href="#" class="quick-action-btn" onclick="alert('Tính năng Đăng kí dịch vụ thêm đang được cập nhật!'); return false;">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path></svg>
                                <span>Đăng kí dịch vụ</span>
                            </a>
                            <a href="#" class="quick-action-btn" onclick="alert('Vui lòng liên hệ ban quản lý qua Zalo/Hotline: 0987.654.321'); return false;">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z"></path></svg>
                                <span>Góp ý / khiếu nại</span>
                            </a>
                            <a href="#" class="quick-action-btn" onclick="alert('Chức năng Cập nhật thông tin cá nhân'); return false;">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path></svg>
                                <span>Cập nhật thông tin</span>
                            </a>
                        </div>
                    </div>
                </div>

                <!-- BOTTOM ROW: THÔNG BÁO & DỊCH VỤ ĐANG DÙNG -->
                <div class="content-grid-row">
                    <!-- THÔNG BÁO -->
                    <div class="card-panel">
                        <div class="panel-header">
                            <h2 class="panel-title">Thông Báo</h2>
                        </div>
                        <div class="notice-box">
                            Xin chào bạn, khách thuê phòng trọ P 203. Hiện tại bạn vẫn chưa hoàn thành khoản thanh toán phòng trọ tháng 10/2026. Vui lòng thanh toán trước ngày 10/10/2026 để tránh phát sinh chi phí phạt trễ hạn.
                        </div>
                    </div>

                    <!-- DỊCH VỤ ĐANG DÙNG -->
                    <div class="card-panel">
                        <div class="panel-header">
                            <h2 class="panel-title">Dịch vụ đang dùng</h2>
                        </div>
                        <ul class="service-list">
                            <li class="service-item">
                                <div class="service-icon">
                                    <svg width="18" height="18" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.111 16.404a5.5 5.5 0 017.778 0M12 20h.01m-7.08-7.071c3.904-3.905 10.236-3.905 14.141 0M1.394 9.393c5.857-5.857 15.355-5.857 21.213 0"></path></svg>
                                </div>
                                <span class="service-name">Internet</span>
                                <span class="service-status">Đang hoạt động</span>
                            </li>
                            <li class="service-item">
                                <div class="service-icon">
                                    <svg width="18" height="18" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"></path></svg>
                                </div>
                                <span class="service-name">Nước</span>
                                <span class="service-status">Đang hoạt động</span>
                            </li>
                        </ul>
                    </div>
                </div>
            </main>
        </div>
    </form>
</body>
</html>
