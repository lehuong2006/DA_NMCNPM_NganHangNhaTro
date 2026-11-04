<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="CNPM.TongQuan" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Tổng quan</title>
    <link href="content/Dashboard.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">

        <div class="container">

            <aside class="sidebar">

                <div class="logo">
                    <h2>NGÂN HÀNG NHÀ TRỌ</h2>
                    <span>Nhà trọ số 8 Nguyễn An Ninh</span>
                </div>

                <nav class="menu">
                    <a href="Dashboard.aspx" class="menu-item active">
                        <span class="menu-icon"></span>
                        <span>Tổng quan</span>
                    </a>

                    <a href="RoomList.aspx" class="menu-item">
                        <span class="menu-icon"></span>
                        <span>Phòng</span>
                    </a>

                    <a href="TenantManagement.aspx" class="menu-item">
                        <span class="menu-icon"></span>
                        <span>Người thuê</span>
                    </a>

                    <a href="QuanLyHopDong.aspx" class="menu-item">
                        <span class="menu-icon"></span>
                        <span>Hợp đồng</span>
                    </a>

                    <a href="QuanLyHoaDon.aspx" class="menu-item">
                        <span class="menu-icon"></span>
                        <span>Hóa đơn</span>
                    </a>

                    <a href="YeuCauNapTien.aspx" class="menu-item">
                        <span class="menu-icon"></span>
                        <span>Giao dịch ví</span>
                    </a>

                    <a href="TransactionHistory.aspx" class="menu-item">
                        <span class="menu-icon"></span>
                        <span>Lịch sử giao dịch</span>
                    </a>
                </nav>

                <div class="sidebar-bottom">
                    <div class="user-info">
                        <div class="avatar">Q</div>
                        <div class="user-text">
                            <strong>Quản lý</strong>
                            <small>Chủ trọ</small>
                        </div>
                    </div>

                    <a href="DangXuat.aspx" class="logout">
                        Đăng xuất
                    </a>
                </div>

            </aside>

            <main class="main-content">

                <header class="page-header">
                    <div>
                        <h1>Tổng quan</h1>
                        <p>Xin chào Quản lý! Tình hình nhà trọ tháng 10/2026</p>
                    </div>
                </header>

                <section class="statistics">

                    <div class="stat-card">
                        <div class="stat-top">
                            <span class="stat-label status-empty">Trống</span>
                        </div>
                        <h2>3</h2>
                        <p>Phòng</p>
                    </div>

                    <div class="stat-card">
                        <div class="stat-top">
                            <span class="stat-label status-deposit">Đã cọc</span>
                        </div>
                        <h2>2</h2>
                        <p>Phòng</p>
                    </div>

                    <div class="stat-card">
                        <div class="stat-top">
                            <span class="stat-label status-rented">Đang thuê</span>
                        </div>
                        <h2>12</h2>
                        <p>Phòng</p>
                    </div>

                    <div class="stat-card">
                        <div class="stat-top">
                            <span class="stat-label status-repair">Bảo trì</span>
                        </div>
                        <h2>1</h2>
                        <p>Phòng</p>
                    </div>

                </section>

                <section class="dashboard-content">

                    <div class="content-box invoice-box">

                        <div class="box-header">
                            <div>
                                <h3>Hóa đơn chưa thu</h3>
                                <p>Danh sách hóa đơn chưa thanh toán</p>
                            </div>

                            <a href="QuanLyHoaDon.aspx" class="view-all">
                                Xem tất cả
                            </a>
                        </div>

                        <div class="table-wrapper">

                            <table class="invoice-table">
                                <thead>
                                    <tr>
                                        <th>Phòng</th>
                                        <th>Người thuê</th>
                                        <th>Số tiền</th>
                                        <th>Hạn thanh toán</th>
                                        <th>Trạng thái</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <tr>
                                        <td>Phòng 101</td>
                                        <td>Nguyễn Văn An</td>
                                        <td class="amount">2.500.000đ</td>
                                        <td>05/10/2026</td>
                                        <td>
                                            <span class="badge pending">Chờ thanh toán</span>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>Phòng 102</td>
                                        <td>Dương Tuấn Duy</td>
                                        <td class="amount">2.800.000đ</td>
                                        <td>03/10/2026</td>
                                        <td>
                                            <span class="badge overdue">Quá hạn</span>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>Phòng 201</td>
                                        <td>Lê Hoàng Nam</td>
                                        <td class="amount">3.000.000đ</td>
                                        <td>10/10/2026</td>
                                        <td>
                                            <span class="badge pending">Chờ thanh toán</span>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>Phòng 202</td>
                                        <td>Phạm Minh Đức</td>
                                        <td class="amount">2.600.000đ</td>
                                        <td>01/10/2026</td>
                                        <td>
                                            <span class="badge overdue">Quá hạn</span>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>

                        </div>

                    </div>

                    <div class="content-box task-box">

                        <div class="box-header">
                            <div>
                                <h3>Việc cần làm</h3>
                            </div>
                        </div>

                        <a href="YeuCauNapTien.aspx" class="task-item">
                            <div class="task-info">
                                <span class="task-dot orange"></span>
                                <div>
                                    <strong>Yêu cầu nạp tiền</strong>
                                    <small>Đang chờ phê duyệt</small>
                                </div>
                            </div>

                            <span class="task-number">3</span>
                        </a>

                        <a href="GhiChiSo.aspx" class="task-item">
                            <div class="task-info">
                                <span class="task-dot blue"></span>
                                <div>
                                    <strong>Ghi chỉ số điện nước</strong>
                                    <small>Cần cập nhật chỉ số tháng này</small>
                                </div>
                            </div>
                            <span class="task-arrow"></span>
                        </a>

                        <div class="shortcut-section">
                            <h3>Lối tắt</h3>

                            <a href="ThemSuaPhong.aspx" class="shortcut-button primary">
                                Thêm phòng
                            </a>

                            <a href="PhieuThu.aspx" class="shortcut-button">
                                Lập phiếu thu cọc
                            </a>

                            <a href="QuanLyHopDong.aspx" class="shortcut-button">
                                Lập hợp đồng
                            </a>

                            <a href="GhiChiSo.aspx" class="shortcut-button">
                                Nhập chỉ số điện nước
                            </a>
                        </div>

                    </div>

                </section>

            </main>

        </div>

    </form>
</body>
</html>
