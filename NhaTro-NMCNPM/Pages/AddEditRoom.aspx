<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddEditRoom.aspx.cs" Inherits="CNPM.ThemSuaPhong" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Thêm,sửa phòng</title>
    <link href="content/AddEditRoom.css" rel="stylesheet" />
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
                        <a href="RoomList.aspx" class="back-link">
                            <span>&larr;</span>
                            <h1>Thêm / sửa phòng</h1>
                        </a>

                        <p>Quản lý thông tin phòng trong hệ thống</p>
                    </div>

                </header>

                <section class="room-form">

                    <div class="form-box">

                        <h3>Thông tin phòng</h3>

                        <div class="form-group">
                            <label for="txtMaPhong">
                                Mã phòng <span class="required">*</span>
                            </label>

                            <asp:TextBox ID="txtMaPhong" runat="server"
                                CssClass="form-control"
                                placeholder="Nhập mã phòng">
                            </asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label for="ddlTang">
                                Tầng <span class="required">*</span>
                            </label>

                            <asp:DropDownList ID="ddlTang" runat="server"
                                CssClass="form-control">
                                <asp:ListItem Value="">Chọn tầng</asp:ListItem>
                                <asp:ListItem Value="1">Tầng 1</asp:ListItem>
                                <asp:ListItem Value="2">Tầng 2</asp:ListItem>
                                <asp:ListItem Value="3">Tầng 3</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="form-group">
                            <label for="ddlLoaiPhong">
                                Loại phòng <span class="required">*</span>
                            </label>

                            <asp:DropDownList ID="ddlLoaiPhong" runat="server"
                                CssClass="form-control">
                                <asp:ListItem Value="">Chọn loại phòng</asp:ListItem>
                                <asp:ListItem Value="Thuong">Phòng thường</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="form-group">
                            <label for="txtGiaThue">
                                Giá thuê (VNĐ/tháng) <span class="required">*</span>
                            </label>

                            <asp:TextBox ID="txtGiaThue" runat="server"
                                CssClass="form-control"
                                placeholder="Nhập giá thuê">
                            </asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label for="ddlTrangThai">
                                Trạng thái <span class="required">*</span>
                            </label>

                            <asp:DropDownList ID="ddlTrangThai" runat="server"
                                CssClass="form-control">
                                <asp:ListItem Value="">Chọn trạng thái</asp:ListItem>
                                <asp:ListItem Value="Trong">Trống</asp:ListItem>
                                <asp:ListItem Value="DaCoc">Đã cọc</asp:ListItem>
                                <asp:ListItem Value="DangThue">Đang thuê</asp:ListItem>
                                <asp:ListItem Value="BaoTri">Bảo trì</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                    </div>

                    <div class="form-box">

                        <h3>Chi tiết phòng</h3>

                        <div class="form-group">
                            <label for="txtDienTich">Diện tích (m²)</label>

                            <asp:TextBox ID="txtDienTich" runat="server"
                                CssClass="form-control"
                                placeholder="Nhập diện tích">
                            </asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label for="txtSoNguoiToiDa">Số người tối đa</label>

                            <asp:TextBox ID="txtSoNguoiToiDa" runat="server"
                                CssClass="form-control"
                                placeholder="Nhập số người tối đa">
                            </asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label for="txtMoTa">Mô tả</label>

                            <asp:TextBox ID="txtMoTa" runat="server"
                                CssClass="form-control textarea-control"
                                TextMode="MultiLine"
                                MaxLength="500"
                                placeholder="Nhập mô tả phòng...">
                            </asp:TextBox>

                            <div class="textarea-note">Tối đa 500 ký tự</div>
                        </div>

                        <div class="form-group image-group">
                            <label>Hình ảnh phòng</label>

                            <div class="upload-area">  

                                <asp:FileUpload ID="fuHinhAnh" runat="server"
                                    CssClass="file-input"
                                    AllowMultiple="true" />

                                <strong>Nhấn để tải ảnh lên</strong>
                                <small>Hỗ trợ JPG, PNG. Tối đa 5 ảnh</small>

                            </div>
                        </div>

                    </div>

                </section>

                <div class="form-actions">

                    <a href="DanhSachPhong.aspx" class="cancel-button">
                        Hủy
                    </a>

                    <asp:Button ID="btnLuu" runat="server"
                        Text="Lưu"
                        CssClass="save-button"
                        CausesValidation="false" />

                </div>

            </main>

        </div>

    </form>
</body>
</html>
