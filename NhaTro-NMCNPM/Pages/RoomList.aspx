<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RoomList.aspx.cs" Inherits="NhaTro_NMCNPM.Pages.RoomList" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Danh sách phòng</title>

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

        .filter-section {
            display: grid;
            grid-template-columns: 2fr 1.1fr 1.1fr auto;
            gap: 12px;
            margin-bottom: 28px;
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
            font-size: 13px;
            outline: none;
        }

        .filter-control:focus {
            border-color: #21645f;
        }

        .search-control {
            min-width: 0;
        }

        .add-room-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            height: 40px;
            padding: 0 15px;
            border-radius: 6px;
            background-color: #21645f;
            color: #ffffff;
            font-size: 13px;
            font-weight: bold;
            white-space: nowrap;
            transition: background-color 0.2s;
        }

        .add-room-button:hover {
            background-color: #194e4a;
        }

        .room-list {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 20px;
            align-items: start;
        }

        .room-card {
            background-color: #ffffff;
            border: 1px solid #e5e5e5;
            border-radius: 10px;
            padding: 18px;
            min-width: 0;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .room-card:hover {
            border-color: #b8d4d0;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.04);
        }

        .room-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 8px;
            margin-bottom: 15px;
        }

        .room-header h2 {
            font-size: 21px;
            font-weight: 600;
            color: #252525;
        }

        .room-status {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            white-space: nowrap;
        }

        .status-empty {
            background-color: #d8f1e3;
            color: #28734b;
        }

        .status-deposited {
            background-color: #ffebc9;
            color: #98651f;
        }

        .status-rented {
            background-color: #dce8fa;
            color: #315b91;
        }

        .status-maintenance {
            background-color: #e5e5e2;
            color: #666660;
        }

        .room-info p {
            font-size: 13px;
            color: #666666;
            margin-top: 9px;
            line-height: 1.5;
            overflow-wrap: anywhere;
        }

        .room-info strong {
            color: #444444;
        }

        .empty-room {
            grid-column: 1 / -1;
            background-color: #ffffff;
            border: 1px solid #e5e5e5;
            border-radius: 10px;
            padding: 35px 15px;
            text-align: center;
            color: #999999;
        }

        @media screen and (max-width: 1100px) {
            .main-content {
                padding: 22px;
            }

            .room-list {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .filter-section {
                grid-template-columns: 1.5fr 1fr 1fr;
            }

            .add-room-button {
                grid-column: 1 / -1;
                justify-self: start;
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

            .filter-section {
                grid-template-columns: 1fr;
                gap: 10px;
                margin-bottom: 20px;
            }

            .add-room-button {
                grid-column: auto;
                width: 100%;
            }

            .room-list {
                grid-template-columns: 1fr;
                gap: 13px;
            }

            .room-card {
                padding: 16px;
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

                    <a href="RoomList.aspx" class="menu-item active">
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
                        <h1>Danh sách phòng</h1>
                        <p>Xin chào Quản lý! Tình hình nhà trọ tháng 10/2026</p>
                    </div>
                </header>

                <section class="filter-section">

                    <input type="text"
                        class="filter-control search-control"
                        placeholder="Tìm kiếm phòng..." />

                    <select class="filter-control">
                        <option>Tất cả trạng thái</option>
                        <option>Trống</option>
                        <option>Đã cọc</option>
                        <option>Đang thuê</option>
                        <option>Bảo trì</option>
                    </select>

                    <select class="filter-control">
                        <option>Tất cả các tầng</option>
                        <option>Tầng 1</option>
                        <option>Tầng 2</option>
                        <option>Tầng 3</option>
                    </select>

                    <a href="AddEditRoom.aspx" class="add-room-button">
                        + Thêm phòng
                    </a>

                </section>

                <section class="room-list">

                    <div class="room-card">
                        <div class="room-header">
                            <h2>Phòng 101</h2>
                            <span class="room-status status-empty">Trống</span>
                        </div>

                        <div class="room-info">
                            <p><strong>Giá thuê:</strong> 2.800.000 VNĐ</p>
                            <p><strong>Người thuê:</strong> Trần Thu Hà</p>
                            <p><strong>Diện tích:</strong> 20 m²</p>
                        </div>
                    </div>

                    <div class="room-card">
                        <div class="room-header">
                            <h2>Phòng 102</h2>
                            <span class="room-status status-rented">Đang thuê</span>
                        </div>

                        <div class="room-info">
                            <p><strong>Giá thuê:</strong> 3.500.000 VNĐ</p>
                            <p><strong>Người thuê:</strong> N/A</p>
                            <p><strong>Diện tích:</strong> 25 m²</p>
                        </div>
                    </div>

                    <div class="room-card">
                        <div class="room-header">
                            <h2>Phòng 103</h2>
                            <span class="room-status status-deposited">Đã cọc</span>
                        </div>

                        <div class="room-info">
                            <p><strong>Giá thuê:</strong> 3.500.000 VNĐ</p>
                            <p><strong>Người thuê:</strong> N/A</p>
                            <p><strong>Diện tích:</strong> 25 m²</p>
                        </div>
                    </div>

                    <div class="room-card">
                        <div class="room-header">
                            <h2>Phòng 201</h2>
                            <span class="room-status status-empty">Trống</span>
                        </div>

                        <div class="room-info">
                            <p><strong>Giá thuê:</strong> 3.500.000 VNĐ</p>
                            <p><strong>Người thuê:</strong> N/A</p>
                            <p><strong>Diện tích:</strong> 25 m²</p>
                        </div>
                    </div>

                    <div class="room-card">
                        <div class="room-header">
                            <h2>Phòng 202</h2>
                            <span class="room-status status-deposited">Đã cọc</span>
                        </div>

                        <div class="room-info">
                            <p><strong>Giá thuê:</strong> 3.500.000 VNĐ</p>
                            <p><strong>Người thuê:</strong> N/A</p>
                            <p><strong>Diện tích:</strong> 25 m²</p>
                        </div>
                    </div>

                    <div class="room-card">
                        <div class="room-header">
                            <h2>Phòng 203</h2>
                            <span class="room-status status-rented">Đang thuê</span>
                        </div>

                        <div class="room-info">
                            <p><strong>Giá thuê:</strong> 3.500.000 VNĐ</p>
                            <p><strong>Người thuê:</strong> N/A</p>
                            <p><strong>Diện tích:</strong> 25 m²</p>
                        </div>
                    </div>

                    <div class="room-card">
                        <div class="room-header">
                            <h2>Phòng 301</h2>
                            <span class="room-status status-rented">Đang thuê</span>
                        </div>

                        <div class="room-info">
                            <p><strong>Giá thuê:</strong> 3.500.000 VNĐ</p>
                            <p><strong>Người thuê:</strong> N/A</p>
                            <p><strong>Diện tích:</strong> 25 m²</p>
                        </div>
                    </div>

                    <div class="room-card">
                        <div class="room-header">
                            <h2>Phòng 302</h2>
                            <span class="room-status status-rented">Đang thuê</span>
                        </div>

                        <div class="room-info">
                            <p><strong>Giá thuê:</strong> 3.500.000 VNĐ</p>
                            <p><strong>Người thuê:</strong> N/A</p>
                            <p><strong>Diện tích:</strong> 25 m²</p>
                        </div>
                    </div>

                    <div class="room-card">
                        <div class="room-header">
                            <h2>Phòng 303</h2>
                            <span class="room-status status-rented">Đang thuê</span>
                        </div>

                        <div class="room-info">
                            <p><strong>Giá thuê:</strong> 3.500.000 VNĐ</p>
                            <p><strong>Người thuê:</strong> N/A</p>
                            <p><strong>Diện tích:</strong> 25 m²</p>
                        </div>
                    </div>

                </section>

            </main>

        </div>

    </form>
</body>
</html>
