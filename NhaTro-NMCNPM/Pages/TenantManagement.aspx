<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TenantManagement.aspx.cs" Inherits="CNPM.QLNguoiThue" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title></title>
    <link href="content/TenantManagement.css" rel="stylesheet" />
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
