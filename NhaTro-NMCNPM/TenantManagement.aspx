<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TenantManagement.aspx.cs" Inherits="CNPM.QLNguoiThue" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Quản lý người thuê</title>

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
            transition: all 0.2s ease;
        }

        .logout:hover {
            background-color: #f1f3f2;
            border-color: #21645f;
            color: #21645f;
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
            gap: 15px;
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

        .add-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            height: 40px;
            padding: 0 18px;
            border-radius: 6px;
            background-color: #21645f;
            color: #ffffff;
            font-size: 13px;
            font-weight: bold;
            white-space: nowrap;
            transition: background-color 0.2s;
        }

        .add-button:hover {
            background-color: #194e4a;
        }

        .statistics {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 14px;
            margin-bottom: 18px;
        }

        .stat-card {
            background-color: #ffffff;
            border: 1px solid #e5e5e5;
            border-radius: 10px;
            padding: 13px;
            min-width: 0;
        }

        .stat-label {
            display: inline-block;
            max-width: 100%;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 500;
            white-space: nowrap;
        }

        .total-label {
            background-color: #d8f1e3;
            color: #28734b;
        }

        .active-label {
            background-color: #ffebc9;
            color: #98651f;
        }

        .expiring-label {
            background-color: #dce8fa;
            color: #315b91;
        }

        .expired-label {
            background-color: #e5e5e2;
            color: #666660;
        }

        .stat-card h2 {
            font-size: 25px;
            font-weight: 600;
            margin: 8px 0 5px;
            color: #252525;
        }

        .stat-card p {
            font-size: 11px;
            color: #888888;
        }

        .filter-section {
            display: grid;
            grid-template-columns: 2fr 1fr 1.1fr auto;
            gap: 12px;
            margin-bottom: 15px;
            align-items: center;
        }

        .filter-control {
            width: 100%;
            min-width: 0;
            height: 40px;
            padding: 0 12px;
            border: 1px solid #dddddd;
            border-radius: 6px;
            background-color: #ffffff;
            color: #555555;
            font-family: inherit;
            font-size: 12px;
            outline: none;
        }

        .filter-control:focus {
            border-color: #21645f;
        }

        .filter-control::placeholder {
            color: #999999;
        }

        .filter-button {
            height: 40px;
            padding: 0 17px;
            border: 1px solid #dddddd;
            border-radius: 6px;
            background-color: #ffffff;
            color: #555555;
            font-family: inherit;
            font-size: 12px;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .filter-button:hover {
            background-color: #f1f3f2;
            border-color: #21645f;
            color: #21645f;
        }

        .content-box {
            background-color: #ffffff;
            border: 1px solid #e5e5e5;
            border-radius: 10px;
            padding: 10px 12px;
        }

        .table-wrapper {
            width: 100%;
            overflow-x: auto;
        }

        .tenant-table {
            width: 100%;
            min-width: 850px;
            border-collapse: collapse;
        }

        .tenant-table th {
            text-align: left;
            color: #666666;
            font-size: 12px;
            font-weight: 500;
            padding: 13px 10px;
            background-color: #f7f8f8;
            white-space: nowrap;
        }

        .tenant-table td {
            padding: 13px 10px;
            border-bottom: 1px solid #eeeeee;
            font-size: 12px;
            color: #555555;
            white-space: nowrap;
        }

        .tenant-table tr:last-child td {
            border-bottom: none;
        }

        .action-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 30px;
            height: 25px;
            border: 1px solid #dddddd;
            border-radius: 5px;
            background-color: #ffffff;
            color: #555555;
            font-size: 17px;
            font-weight: bold;
            letter-spacing: 1px;
            transition: all 0.2s ease;
        }

        .action-button:hover {
            background-color: #f1f3f2;
            border-color: #21645f;
            color: #21645f;
        }

        .pagination {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            padding: 15px 0 5px;
        }

        .pagination-info {
            color: #888888;
            font-size: 11px;
        }

        .pagination-buttons {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .page-button {
            width: 28px;
            height: 28px;
            border: 1px solid #dddddd;
            border-radius: 5px;
            background-color: #ffffff;
            color: #555555;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .page-button:hover {
            border-color: #21645f;
            color: #21645f;
        }

        .current-page {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 28px;
            height: 28px;
            border-radius: 5px;
            background-color: #21645f;
            color: #ffffff;
            font-size: 12px;
        }

        .tenant-status {
            display: inline-block;
            min-width: 95px;
            text-align: center;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 11px;
            white-space: nowrap;
        }

        .status-active {
            background-color: #d8f1e3;
            color: #28734b;
        }

        .status-expiring {
            background-color: #ffebc9;
            color: #98651f;
        }

        .status-expired {
            background-color: #fde5e3;
            color: #c34b43;
        }

        @media screen and (max-width: 1100px) {
            .main-content {
                padding: 22px;
            }

            .statistics {
                grid-template-columns: repeat(2, 1fr);
            }

            .filter-section {
                grid-template-columns: 1.5fr 1fr;
            }
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

            .add-button {
                height: 36px;
                padding: 0 11px;
                font-size: 11px;
            }

            .statistics {
                grid-template-columns: repeat(2, 1fr);
                gap: 10px;
            }

            .stat-card {
                padding: 12px;
            }

            .stat-card h2 {
                font-size: 22px;
            }

            .stat-label {
                font-size: 10px;
                padding: 5px 9px;
            }

            .filter-section {
                grid-template-columns: 1fr;
                gap: 9px;
            }

            .content-box {
                padding: 8px;
            }

            .pagination {
                align-items: flex-start;
                flex-direction: column;
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

                    <a href="Dashboard.aspx" class="menu-item">
                        <span class="menu-icon"></span>
                        <span>Tổng quan</span>
                    </a>

                    <a href="RoomList.aspx" class="menu-item">
                        <span class="menu-icon"></span>
                        <span>Phòng</span>
                    </a>

                    <a href="TenantManagement.aspx" class="menu-item active">
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
                        <h1>Quản lý người thuê</h1>
                        <p>Danh sách người thuê và thông tin hợp đồng</p>
                    </div>

                    <a href="ThemNguoiThue.aspx" class="add-button">
                        + Thêm người thuê
                    </a>

                </header>

                <section class="statistics">

                    <div class="stat-card">
                        <span class="stat-label total-label">Tổng số người thuê</span>
                        <h2>7</h2>
                        <p>Đang thuê</p>
                    </div>

                    <div class="stat-card">
                        <span class="stat-label active-label">Đang hợp đồng</span>
                        <h2>6</h2>
                        <p>Còn hiệu lực</p>
                    </div>

                    <div class="stat-card">
                        <span class="stat-label expiring-label">Sắp hết hạn</span>
                        <h2>1</h2>
                        <p>Trong 30 ngày</p>
                    </div>

                    <div class="stat-card">
                        <span class="stat-label expired-label">Đã hết hạn</span>
                        <h2>0</h2>
                        <p>Cần xử lý</p>
                    </div>

                </section>

                <section class="filter-section">

                    <input type="text"
                        class="filter-control search-control"
                        placeholder="Tìm kiếm theo tên, số điện thoại, phòng..." />

                    <select class="filter-control">
                        <option>Tất cả phòng</option>
                        <option>P101</option>
                        <option>P102</option>
                        <option>P201</option>
                        <option>P202</option>
                        <option>P203</option>
                        <option>P301</option>
                        <option>P302</option>
                    </select>

                    <select class="filter-control">
                        <option>Tất cả trạng thái</option>
                        <option>Đang thuê</option>
                        <option>Sắp hết hạn</option>
                        <option>Đã hết hạn</option>
                    </select>

                    <button type="button" class="filter-button">
                        Bộ lọc
                    </button>

                </section>

                <section class="content-box">

                    <div class="table-wrapper">

                        <table class="tenant-table">

                            <thead>
                                <tr>
                                    <th>STT</th>
                                    <th>Tên người thuê</th>
                                    <th>Số điện thoại</th>
                                    <th>Phòng</th>
                                    <th>Ngày bắt đầu</th>
                                    <th>Ngày kết thúc</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>

                            <tbody>

                                <tr>
                                    <td>1</td>
                                    <td>Nguyễn Văn A</td>
                                    <td>0985 123 456</td>
                                    <td>P101</td>
                                    <td>01/09/2025</td>
                                    <td>01/09/2027</td>
                                    <td>
                                        <span class="tenant-status status-active">Đang thuê</span>
                                    </td>
                                    <td>
                                        <a href="#" class="action-button">...</a>
                                    </td>
                                </tr>

                                <tr>
                                    <td>2</td>
                                    <td>Trần Thị B</td>
                                    <td>0977 234 567</td>
                                    <td>P102</td>
                                    <td>15/08/2025</td>
                                    <td>15/08/2027</td>
                                    <td>
                                        <span class="tenant-status status-active">Đang thuê</span>
                                    </td>
                                    <td>
                                        <a href="#" class="action-button">...</a>
                                    </td>
                                </tr>

                                <tr>
                                    <td>3</td>
                                    <td>Lê Văn C</td>
                                    <td>0912 345 678</td>
                                    <td>P201</td>
                                    <td>01/07/2025</td>
                                    <td>01/07/2027</td>
                                    <td>
                                        <span class="tenant-status status-active">Đang thuê</span>
                                    </td>
                                    <td>
                                        <a href="#" class="action-button">...</a>
                                    </td>
                                </tr>

                                <tr>
                                    <td>4</td>
                                    <td>Phạm Thị D</td>
                                    <td>0526 326 627</td>
                                    <td>P202</td>
                                    <td>10/08/2025</td>
                                    <td>10/08/2027</td>
                                    <td>
                                        <span class="tenant-status status-active">Đang thuê</span>
                                    </td>
                                    <td>
                                        <a href="#" class="action-button">...</a>
                                    </td>
                                </tr>

                                <tr>
                                    <td>5</td>
                                    <td>Hoàng Văn E</td>
                                    <td>0732 134 733</td>
                                    <td>P203</td>
                                    <td>20/07/2025</td>
                                    <td>20/07/2027</td>
                                    <td>
                                        <span class="tenant-status status-active">Đang thuê</span>
                                    </td>
                                    <td>
                                        <a href="#" class="action-button">...</a>
                                    </td>
                                </tr>

                                <tr>
                                    <td>6</td>
                                    <td>Vũ Thị F</td>
                                    <td>0973 753 927</td>
                                    <td>P301</td>
                                    <td>25/09/2025</td>
                                    <td>25/09/2027</td>
                                    <td>
                                        <span class="tenant-status status-active">Đang thuê</span>
                                    </td>
                                    <td>
                                        <a href="#" class="action-button">...</a>
                                    </td>
                                </tr>

                                <tr>
                                    <td>7</td>
                                    <td>Ngô Thị H</td>
                                    <td>0936 136 843</td>
                                    <td>P302</td>
                                    <td>01/11/2025</td>
                                    <td>01/11/2026</td>
                                    <td>
                                        <span class="tenant-status status-expiring">Sắp hết hạn</span>
                                    </td>
                                    <td>
                                        <a href="#" class="action-button">...</a>
                                    </td>
                                </tr>

                            </tbody>

                        </table>

                    </div>

                    <div class="pagination">

                        <span class="pagination-info">
                            Hiển thị 1 - 7 trong 7 người thuê
                        </span>

                        <div class="pagination-buttons">
                            <button type="button" class="page-button">&lt;</button>
                            <span class="current-page">1</span>
                            <button type="button" class="page-button">&gt;</button>
                        </div>

                    </div>

                </section>

            </main>

        </div>

    </form>
</body>
</html>
