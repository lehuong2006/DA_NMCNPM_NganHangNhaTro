<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TransactionHistory.aspx.cs" Inherits="CNPM.LichSuGiaoDich" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Lịch sử giao dịch</title>
    <link href="content/TransactionHistory.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">

        <div class="container">

            <!-- SIDEBAR -->
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

            <!-- MAIN CONTENT -->
            <main class="main-content">

                <!-- HEADER -->
                <header class="page-header">
                    <div>
                        <h1>Lịch sử giao dịch</h1>
                    </div>
                </header>

                <!-- THỐNG KÊ GIAO DỊCH -->
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

                <!-- BỘ LỌC GIAO DỊCH -->
                <section class="filter-section">

                    <div class="date-filter">
                        <input type="text" class="filter-control"
                            value="01/10/2026 - 30/10/2026" readonly="readonly" />
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

                    <input type="text" class="filter-control"
                        placeholder="Tìm kiếm giao dịch" />

                </section>

                <!-- DANH SÁCH GIAO DỊCH -->
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
