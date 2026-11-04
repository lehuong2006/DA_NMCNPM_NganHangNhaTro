<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TransactionHistory.aspx.cs" Inherits="CNPM.LichSuGiaoDich" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Lịch sử giao dịch</title>

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

        .stat-label {
            display: inline-block;
            padding: 7px 15px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 500;
        }

        .balance-label {
            background-color: #d8f1e3;
            color: #28734b;
        }

        .deposit-label {
            background-color: #d8f1e3;
            color: #28734b;
        }

        .expense-label {
            background-color: #fde5e3;
            color: #c34b43;
        }

        .count-label {
            background-color: #dce8fa;
            color: #315b91;
        }

        .stat-card h2 {
            font-size: 29px;
            margin: 13px 0 7px;
            font-weight: 600;
            color: #252525;
        }

        .filter-section {
            display: grid;
            grid-template-columns: 1.5fr 1fr 1fr 1.3fr;
            gap: 10px;
            margin-bottom: 20px;
        }

        .filter-control {
            width: 100%;
            min-width: 0;
            height: 40px;
            padding: 0 10px;
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

        .date-filter {
            display: flex;
            align-items: center;
            gap: 5px;
            min-width: 0;
        }

        .date-filter span {
            color: #888888;
            font-size: 11px;
            white-space: nowrap;
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

        .table-wrapper {
            width: 100%;
            overflow-x: auto;
        }

        .transaction-table {
            width: 100%;
            border-collapse: collapse;
            min-width: 750px;
        }

        .transaction-table th {
            text-align: left;
            color: #888888;
            font-size: 12px;
            font-weight: 500;
            padding: 12px 10px;
            background-color: #f7f8f8;
            white-space: nowrap;
        }

        .transaction-table td {
            padding: 15px 10px;
            border-bottom: 1px solid #eeeeee;
            font-size: 12px;
            color: #555555;
        }

        .transaction-table tr:last-child td {
            border-bottom: none;
        }

        .transaction-table th:first-child,
        .transaction-table td:first-child {
            text-align: center;
        }

        .transaction-table th:nth-child(5),
        .transaction-table td:nth-child(5) {
            white-space: nowrap;
        }

        .type-payment {
            color: #2196f3;
        }

        .type-deposit {
            color: #16b84e;
        }

        .type-withdraw {
            color: #f04452;
        }

        .transaction-success {
            color: #16b84e;
        }

        @media screen and (max-width: 1100px) {
            .main-content {
                padding: 22px;
            }

            .statistics {
                grid-template-columns: repeat(2, 1fr);
            }

            .filter-section {
                grid-template-columns: repeat(2, 1fr);
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
                font-size: 19px;
            }

            .filter-section {
                grid-template-columns: 1fr;
            }

            .content-box {
                padding: 14px;
            }

            .box-header {
                align-items: flex-start;
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

                    <a href="TransactionHistory.aspx" class="menu-item active">
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
                        <h1>Lịch sử giao dịch</h1>
                    </div>
                </header>

                <section class="statistics">

                    <div class="stat-card">
                        <span class="stat-label balance-label">Số tiền dư hiện tại</span>
                        <h2>4.860.000 đ</h2>
                    </div>

                    <div class="stat-card">
                        <span class="stat-label deposit-label">Tổng nạp</span>
                        <h2>7.250.000 đ</h2>
                    </div>

                    <div class="stat-card">
                        <span class="stat-label expense-label">Tổng chi</span>
                        <h2>2.390.000 đ</h2>
                    </div>

                    <div class="stat-card">
                        <span class="stat-label count-label">Tổng giao dịch</span>
                        <h2>12</h2>
                    </div>

                </section>

                <section class="filter-section">

                    <div class="date-filter">
                        <input type="text"
                            class="filter-control"
                            value="01/10/2026 - 30/10/2026"
                            readonly="readonly" />
                    </div>

                    <select class="filter-control">
                        <option>Tất cả loại giao dịch</option>
                        <option>Nạp tiền</option>
                        <option>Thanh toán</option>
                        <option>Rút tiền</option>
                    </select>

                    <select class="filter-control">
                        <option>Tất cả trạng thái</option>
                        <option>Thành công</option>
                        <option>Đang xử lý</option>
                        <option>Thất bại</option>
                    </select>

                    <input type="text"
                        class="filter-control"
                        placeholder="Tìm kiếm giao dịch" />

                </section>

                <section class="content-box">

                    <div class="box-header">
                        <div>
                            <h3>Danh sách giao dịch</h3>
                            <p>Thông tin chi tiết các giao dịch trong ví</p>
                        </div>
                    </div>

                    <div class="table-wrapper">

                        <table class="transaction-table">

                            <thead>
                                <tr>
                                    <th>STT</th>
                                    <th>Thời gian</th>
                                    <th>Loại giao dịch</th>
                                    <th>Nội dung</th>
                                    <th>Số tiền</th>
                                    <th>Trạng thái</th>
                                    <th>Chú thích</th>
                                </tr>
                            </thead>

                            <tbody>

                                <tr>
                                    <td>1</td>
                                    <td>25/10/2026</td>
                                    <td><span class="type-payment">Thanh toán</span></td>
                                    <td>Thanh toán tiền phòng</td>
                                    <td class="amount">-1.500.000 đ</td>
                                    <td><span class="transaction-success">Thành công</span></td>
                                    <td>Tháng 10/2026</td>
                                </tr>

                                <tr>
                                    <td>2</td>
                                    <td>19/10/2026</td>
                                    <td><span class="type-deposit">Nạp tiền</span></td>
                                    <td>Nạp vào ví</td>
                                    <td class="amount">+1.000.000 đ</td>
                                    <td><span class="transaction-success">Thành công</span></td>
                                    <td>Chuyển khoản ngân hàng</td>
                                </tr>

                                <tr>
                                    <td>3</td>
                                    <td>15/10/2026</td>
                                    <td><span class="type-payment">Thanh toán</span></td>
                                    <td>Thanh toán tiền nước</td>
                                    <td class="amount">-150.000 đ</td>
                                    <td><span class="transaction-success">Thành công</span></td>
                                    <td>Tháng 10/2026</td>
                                </tr>

                                <tr>
                                    <td>4</td>
                                    <td>10/10/2026</td>
                                    <td><span class="type-withdraw">Rút tiền</span></td>
                                    <td>Rút tiền tài khoản</td>
                                    <td class="amount">-300.000 đ</td>
                                    <td><span class="transaction-success">Thành công</span></td>
                                    <td>Ngân hàng MB</td>
                                </tr>

                                <tr>
                                    <td>5</td>
                                    <td>08/10/2026</td>
                                    <td><span class="type-deposit">Nạp tiền</span></td>
                                    <td>Nạp vào ví</td>
                                    <td class="amount">+500.000 đ</td>
                                    <td><span class="transaction-success">Thành công</span></td>
                                    <td>Chuyển khoản ngân hàng</td>
                                </tr>

                                <tr>
                                    <td>6</td>
                                    <td>05/10/2026</td>
                                    <td><span class="type-withdraw">Rút tiền</span></td>
                                    <td>Rút tiền tài khoản</td>
                                    <td class="amount">-200.000 đ</td>
                                    <td><span class="transaction-success">Thành công</span></td>
                                    <td>Ngân hàng MB</td>
                                </tr>

                            </tbody>

                        </table>

                    </div>

                </section>

            </main>

        </div>

    </form>
</body>
</html>
