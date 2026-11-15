# BTL_NganHangNhaTro
## TÀI KHOẢN KIỂM THỬ
-Khách thuê 1
sđt: 0868847280
mk: thang123
- Khách thuê 2
sđt: 0348714727
mk: huong1234
-Chủ trọ:
sđt: 0825611111
mk: quan123456
-Quản trị viên:
sđt: 0856798765
mk: anh123456

## KẾT NỐI
-Cấu hình kết nối SQL Server trong appsettings.json

## HƯỚNG DẪN DÀNH CHO CHỦ TRỌ (LANDLORD)
## 1. Quản lý danh mục phòng trọ
Xem danh sách phòng: Vào menu Quản lý phòng. Tại đây hiển thị thẻ tổng quan số phòng đang có, trạng thái từng phòng (Trống, Đang thuê, Bảo trì) và số người đang ở.
Thêm phòng mới:
Bấm nút + Thêm phòng (hoặc truy cập trang Thêm / sửa phòng).
Bấm nút + Thêm phòng mới ở cột bên phải để làm mới form.
Điền các thông tin: Mã phòng (ví dụ: P101, không được trùng), Tầng, Giá thuê, Số người tối đa và Diện tích.
Bấm Lưu → Hệ thống thông báo tạo thành công và chuyển về danh sách phòng.
Sửa thông tin hoặc Xóa phòng:
Tại màn hình Thêm / sửa phòng, chọn phòng cần sửa từ danh sách ở cột bên phải (hoặc gõ mã phòng vào ô tìm kiếm).
Toàn bộ dữ liệu của phòng sẽ tự động điền vào form bên trái.
Sửa lại các trường thông tin mong muốn rồi bấm Lưu.
Nếu muốn xóa phòng, bấm nút Xóa phòng (Lưu ý: Chỉ xóa được phòng khi không có hợp đồng đang có hiệu lực).
## 2. Quản lý khách thuê và Hợp đồng
Lập hợp đồng cho khách mới:
Vào menu Quản lý người thuê → bấm nút + Lập hợp đồng.
Chọn phòng trống cần cho thuê từ danh sách.
Nhập đầy đủ thông tin khách thuê: Họ tên, Số điện thoại, CCCD, Địa chỉ, Tiền thuê, Tiền đặt cọc, Ngày bắt đầu và Ngày kết thúc.
Bấm Lưu hợp đồng → Hệ thống tự động tạo hợp đồng trạng thái Hiệu lực và chuyển trạng thái phòng tương ứng sang "Đang thuê".
Chấm dứt hợp đồng khi khách dọn đi:
Tại danh sách hợp đồng/người thuê, tìm phòng cần trả và bấm nút Chấm dứt.
Xác nhận đồng ý → Hệ thống tự động cập nhật hợp đồng, dọn sạch hồ sơ liên kết cũ và đưa phòng trở về trạng thái "Trống" để sẵn sàng đón khách mới.
## 3. Ghi chỉ số Điện - Nước và Xuất hóa đơn
Ghi chỉ số định kỳ hàng tháng:
Vào menu Ghi chỉ số.
Chọn kỳ/tháng cần ghi và nhập chỉ số điện, nước mới của từng phòng (Lưu ý: Chỉ số mới phải lớn hơn hoặc bằng chỉ số cũ của kỳ trước).
Bấm Lưu chỉ số → Hệ thống tự động tính ra lượng tiêu thụ thực tế.
Quản lý hóa đơn:
Vào menu Hóa đơn.
Hệ thống tự động tổng hợp tiền phòng, tiền điện, tiền nước và các phí dịch vụ thành hóa đơn tháng.
Chủ trọ có thể theo dõi danh sách hóa đơn theo trạng thái Chưa thanh toán (UNPAID) hoặc Đã thanh toán (PAID).
## 4. Quản lý Ví và Thu tiền tự động
Duyệt yêu cầu nạp tiền ví từ khách:
Vào menu Giao dịch ví → chọn tab Yêu cầu nạp tiền.
Kiểm tra số tiền chuyển khoản của khách theo mã tham chiếu. Bấm Duyệt để cộng tiền vào ví người thuê.
Cấu hình Trừ tiền tự động:
Tại trang Giao dịch ví, chọn tab Trừ tiền tự động.
Chọn ngày cố định hàng tháng (ví dụ: ngày 05 hàng tháng) và gạt nút sang BẬT.
Ngoài ra, Chủ trọ có thể bấm nút Trừ thủ công ngay bất kỳ lúc nào: Hệ thống sẽ tự động quét các hóa đơn chưa trả, nếu ví của khách thuê có đủ tiền thì hệ thống sẽ tự động trừ ví và gạch nợ hóa đơn sang Đã thanh toán.
Lịch sử các lần quét trừ tiền sẽ được lưu vết và hiển thị ở bảng phía dưới.

## HƯỚNG DẪN DÀNH CHO NGƯỜI THUÊ (TENANT)
## 1. Xem thông tin tổng quan phòng ở
Đăng nhập tài khoản bằng số điện thoại được cấp khi ký hợp đồng.
Tại trang Tổng quan (Dashboard), người thuê có thể xem:
Thông tin phòng đang ở, giá thuê, chu kỳ đóng tiền.
Số dư khả dụng hiện tại trong ví điện tử.
Cảnh báo hóa đơn tiền phòng/điện nước của tháng hiện tại.
## 2. Nạp tiền vào Ví điện tử (Qua VietQR)
Vào menu Ví điện tử trên thanh điều hướng.
Tại màn hình nạp tiền, hệ thống hiển thị Mã QR chuyển khoản ngân hàng (VietQR) chứa sẵn thông tin tài khoản và ngân hàng của Chủ trọ.
Mở ứng dụng ngân hàng trên điện thoại → Quét mã QR và tiến hành chuyển khoản với nội dung chuyển tiền hiển thị trên màn hình (ví dụ: NAPTIEN 0868847280).
Nhập số tiền đã chuyển vào ô nạp tiền và bấm Gửi yêu cầu nạp tiền.
Sau khi chủ trọ xác nhận, số dư ví sẽ được cộng ngay lập tức.
## 3. Thanh toán hóa đơn tháng
Vào menu Hợp đồng & Hóa đơn.
Kiểm tra chi tiết hóa đơn tháng gồm: Tiền phòng, số điện, số nước tiêu thụ và tổng tiền cần thanh toán.
Khi ví điện tử có đủ số dư: Bấm nút Thanh toán.
Hệ thống sẽ tự động trừ tiền từ ví và chuyển hóa đơn sang trạng thái Đã thanh toán (Không lo trễ hạn đóng tiền phòng).
## 4. Tra cứu Lịch sử giao dịch
Vào menu Lịch sử giao dịch.
Người thuê có thể lọc theo khoảng thời gian hoặc loại giao dịch để xem lại:
Các lần nạp tiền vào ví.
Các khoản tiền đã thanh toán cho từng hóa đơn.
Thời gian giao dịch và trạng thái thành công.
