<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddEditRoom.aspx.cs" Inherits="NhaTro_NMCNPM.Pages.AddEditRoom" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Thêm, sửa phòng</title>

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
            margin-bottom: 25px;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 9px;
            margin-bottom: 7px;
            color: #252525;
        }

        .back-link span {
            font-size: 25px;
            line-height: 1;
        }

        .back-link h1 {
            font-size: 26px;
            font-weight: 600;
        }

        .page-header p {
            color: #888888;
            font-size: 13px;
        }

        .room-form {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 18px;
            align-items: stretch;
        }

        .form-box {
            background-color: #ffffff;
            border: 1px solid #e5e5e5;
            border-radius: 10px;
            padding: 20px;
        }

        .form-box h3 {
            font-size: 16px;
            margin-bottom: 22px;
            color: #333333;
        }

        .form-group {
            margin-bottom: 18px;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            color: #666666;
            margin-bottom: 8px;
        }

        .required {
            color: #e05252;
        }

        .form-control {
            display: block;
            width: 100%;
            height: 40px;
            padding: 0 11px;
            border: 1px solid #dddddd;
            border-radius: 5px;
            background-color: #ffffff;
            color: #333333;
            font-family: inherit;
            font-size: 13px;
            outline: none;
        }

        .form-control:focus {
            border-color: #21645f;
        }

        .form-control::placeholder {
            color: #aaaaaa;
        }

        .textarea-control {
            height: 100px;
            padding: 10px;
            resize: vertical;
            line-height: 1.5;
        }

        .textarea-note {
            text-align: right;
            color: #999999;
            font-size: 11px;
            margin-top: 4px;
        }

        .image-group {
            margin-bottom: 0;
        }

        .upload-area {
            position: relative;
            min-height: 115px;
            border: 1px dashed #dddddd;
            border-radius: 6px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            gap: 5px;
            padding: 12px;
            text-align: center;
            background-color: #ffffff;
            overflow: hidden;
        }

        .upload-area:hover {
            background-color: #f8f9f9;
            border-color: #21645f;
        }

        .upload-area strong {
            font-size: 13px;
            font-weight: 500;
            color: #555555;
        }

        .upload-area small {
            font-size: 11px;
            color: #999999;
        }

        .file-input {
            position: absolute;
            inset: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            cursor: pointer;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 25px;
        }

        .cancel-button,
        .save-button {
            min-width: 105px;
            height: 40px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 6px;
            font-family: inherit;
            font-size: 13px;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .cancel-button {
            background-color: #ffffff;
            border: 1px solid #dddddd;
            color: #555555;
        }

        .cancel-button:hover {
            background-color: #f1f3f2;
            border-color: #bbbbbb;
        }

        .save-button {
            background-color: #21645f;
            border: 1px solid #21645f;
            color: #ffffff;
            font-weight: bold;
        }

        .save-button:hover {
            background-color: #194e4a;
            border-color: #194e4a;
        }

        @media screen and (max-width: 1100px) {
            .main-content {
                padding: 22px;
            }

            .room-form {
                gap: 14px;
            }

            .form-box {
                padding: 16px;
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

            .back-link h1 {
                font-size: 22px;
            }

            .room-form {
                grid-template-columns: 1fr;
                gap: 14px;
            }

            .form-box {
                padding: 16px;
            }

            .form-actions {
                margin-top: 18px;
            }

            .cancel-button,
            .save-button {
                flex: 1;
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

                    <a href="RoomList.aspx" class="cancel-button">
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
