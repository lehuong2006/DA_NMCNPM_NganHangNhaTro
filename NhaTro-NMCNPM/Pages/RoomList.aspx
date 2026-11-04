<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RoomList.aspx.cs" Inherits="CNPM.DanhSachPhong" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Danh sách phòng</title>
    <link href="content/RoomList.css" rel="stylesheet" />
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
