<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="NhaTro_NMCNPM.Pages.Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Tổng quan</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background-color: #f5f6f8;
            color: #252525;
            font-size: 14px;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        .container {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 245px;
            min-width: 245px;
            background-color: #ffffff;
            border-right: 1px solid #e5e5e5;
            display: flex;
            flex-direction: column;
        }

        .logo {
            padding: 25px 15px;
            border-bottom: 1px solid #eeeeee;
            white-space: nowrap;
        }

        .logo h2 {
            font-size: 17px;
            letter-spacing: 0.5px;
            color: #21645f;
        }

        .logo span {
            display: block;
            font-size: 11px;
            color: #888888;
            margin-top: 6px;
            letter-spacing: 1px;
        }

        .menu {
            padding: 18px 12px;
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .menu-item {
            display: flex;
            align-items: center;
            gap: 13px;
            padding: 13px 14px;
            border-radius: 7px;
            color: #555555;
            transition: background-color 0.2s;
        }

        .menu-item:hover {
            background-color: #f1f3f2;
        }

        .menu-item.active {
            background-color: #e5f0ee;
            color: #21645f;
            font-weight: bold;
        }

        .menu-icon {
            width: 22px;
            text-align: center;
            font-size: 19px;
        }

        .sidebar-bottom {
            margin-top: auto;
            padding: 18px 15px;
            border-top: 1px solid #eeeeee;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 18px;
        }

        .avatar {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background-color: #21645f;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }

        .user-text strong,
        .user-text small {
            display: block;
        }

        .user-text strong {
            font-size: 13px;
        }

        .user-text small {
            margin-top: 4px;
            color: #888888;
        }

        .logout {
            display: block;
            text-align: center;
            padding: 10px;
            border: 1px solid #dddddd;
            border-radius: 6px;
            color: #666666;
        }

        .logout:hover {
            background-color: #f1f3f2;
            border-color: #21645f;
            color: #21645f;
            transition: 0.2s;
        }

        .main-content {
            flex: 1;
            min-width: 0;
            padding: 30px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .page-header h1 {
            font-size: 28px;
            margin-bottom: 8px;
        }

        .page-header p {
            color: #888888;
            font-size: 13px;
        }

        .header-date {
            color: #666666;
            font-size: 13px;
        }

        .statistics {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 22px;
        }

        .stat-card {
            background-color: #ffffff;
            border: 1px solid #e5e5e5;
            border-radius: 10px;
            padding: 18px;
        }

        .stat-top {
            display: flex;
            justify-content: flex-start;
            align-items: center;
        }

        .stat-label {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            line-height: 1;
        }

        .status-empty {
            background-color: #d8f1e3;
            color: #28734b;
        }

        .status-deposit {
            background-color: #ffebc9;
            color: #98651f;
        }

        .status-rented {
            background-color: #dce8fa;
            color: #315b91;
        }

        .status-repair {
            background-color: #e5e5e2;
            color: #666660;
        }

        .stat-card h2 {
            font-size: 29px;
            margin: 13px 0 7px;
            font-weight: 600;
        }

        .stat-card p {
            color: #999999;
            font-size: 12px;
        }

        .dashboard-content {
            display: grid;
            grid-template-columns: 1.8fr 1fr;
            gap: 18px;
            align-items: start;
        }

        .content-box {
            background-color: #ffffff;
            border: 1px solid #e5e5e5;
            border-radius: 10px;
            padding: 20px;
        }

        .box-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .box-header h3 {
            font-size: 16px;
            margin-bottom: 6px;
        }

        .box-header p {
            color: #999999;
            font-size: 12px;
        }

        .view-all {
            color: #21645f;
            font-size: 12px;
        }

        .table-wrapper {
            width: 100%;
            overflow-x: auto;
        }

        .invoice-table {
            width: 100%;
            border-collapse: collapse;
            min-width: 600px;
        }

        .invoice-table th {
            text-align: left;
            color: #888888;
            font-size: 12px;
            font-weight: 500;
            padding: 12px 10px;
            background-color: #f7f8f8;
        }

        .invoice-table td {
            padding: 15px 10px;
            border-bottom: 1px solid #eeeeee;
            font-size: 12px;
        }

        .amount {
            font-weight: bold;
            white-space: nowrap;
        }

        .badge {
            display: inline-block;
            padding: 5px 9px;
            border-radius: 20px;
            font-size: 11px;
            white-space: nowrap;
        }

        .overdue {
            background-color: #fde5e3;
            color: #c34b43;
        }

        .pending {
            background-color: #fff1d8;
            color: #a87521;
        }

        .task-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 13px 10px;
            border: 1px solid #eeeeee;
            border-radius: 7px;
            margin-bottom: 10px;
        }

        .task-item:hover {
            background-color: #f8f9f9;
        }

        .task-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .task-dot {
            width: 9px;
            height: 9px;
            border-radius: 50%;
        }

        .orange {
            background-color: #e9a23b;
        }

        .blue {
            background-color: #4785d4;
        }

        .task-info strong,
        .task-info small {
            display: block;
        }

        .task-info strong {
            font-size: 12px;
        }

        .task-info small {
            color: #999999;
            font-size: 11px;
            margin-top: 5px;
        }

        .task-number {
            color: #c17c23;
            font-weight: bold;
        }

        .task-arrow {
            font-size: 18px;
            color: #777777;
        }

        .shortcut-section {
            margin-top: 23px;
        }

        .shortcut-section h3 {
            font-size: 15px;
            margin-bottom: 12px;
        }

        .shortcut-button {
            display: block;
            text-align: center;
            border: 1px solid #dddddd;
            border-radius: 6px;
            padding: 11px;
            margin-top: 9px;
            font-size: 12px;
            color: #555555;
        }

        .shortcut-button:hover {
            background-color: #f3f5f4;
        }

        .shortcut-button.primary {
            background-color: #21645f;
            border-color: #21645f;
            color: #ffffff;
            font-weight: bold;
        }

        @media screen and (max-width: 650px) {
            .container {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                min-width: 0;
                border-right: none;
                border-bottom: 1px solid #e5e5e5;
            }

            .logo {
                padding: 15px 18px;
            }

            .menu {
                flex-direction: row;
                overflow-x: auto;
                padding: 8px;
                gap: 5px;
            }

            .menu-item {
                flex-direction: column;
                gap: 5px;
                padding: 10px;
                min-width: 85px;
                font-size: 11px;
            }

            .menu-icon {
                font-size: 18px;
            }

            .sidebar-bottom {
                display: none;
            }

            .main-content {
                padding: 18px 13px;
            }

            .page-header {
                align-items: flex-start;
            }

            .page-header h1 {
                font-size: 23px;
            }

            .header-date {
                display: none;
            }

            .statistics {
                grid-template-columns: repeat(2, 1fr);
                gap: 10px;
            }

            .stat-card {
                padding: 13px;
            }

            .stat-card h2 {
                font-size: 25px;
            }

            .content-box {
                padding: 14px;
            }

            .box-header {
                align-items: flex-start;
            }

            .view-all {
                white-space: nowrap;
            }
        }
    </style>
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
