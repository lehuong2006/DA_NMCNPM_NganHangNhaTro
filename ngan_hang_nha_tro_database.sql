-- DỰ ÁN: HỆ THỐNG QUẢN LÝ VÀ KẾT NỐI NGÂN HÀNG NHÀ TRỌ (SỐ 8 NGUYỄN AN NINH)

USE master;
GO
-- 1. Khởi tạo Cơ sở dữ liệu
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'ngan_hang_nha_tro')
BEGIN
    ALTER DATABASE ngan_hang_nha_tro SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE ngan_hang_nha_tro;
END
GO

CREATE DATABASE ngan_hang_nha_tro;
GO
USE ngan_hang_nha_tro;
GO

-- PHẦN I: KHỞI TẠO CÁC BẢNG DỮ LIỆU CHUẨN HÓA 3NF (TABLE SCHEMAS)
-- Bảng 1: users (Tài khoản người dùng & Phân quyền - UC01, UC02, UC15)
CREATE TABLE users (
    user_id             INT IDENTITY(1,1)   NOT NULL,
    username            VARCHAR(50)         NOT NULL,
    password_hash       VARCHAR(256)        NOT NULL, 
    full_name           NVARCHAR(100)       NOT NULL,
    phone_number        VARCHAR(15)         NOT NULL,
    email               VARCHAR(100)        NULL,
    id_card_number      VARCHAR(20)         NULL,    
    role                VARCHAR(20)         NOT NULL, 
    status              VARCHAR(20)         NOT NULL DEFAULT 'Active',
    created_at          DATETIME            NOT NULL DEFAULT GETDATE(),
    updated_at          DATETIME            NULL,

    CONSTRAINT pk_users PRIMARY KEY (user_id),
    CONSTRAINT uq_users_username UNIQUE (username),
    CONSTRAINT uq_users_phone_number UNIQUE (phone_number),
    CONSTRAINT chk_users_role CHECK (role IN ('Landlord', 'Tenant', 'Admin')),
    CONSTRAINT chk_users_status CHECK (status IN ('Active', 'Locked'))
);
GO

-- Bảng 2: rooms (Danh mục & Trạng thái phòng trọ - UC03)
CREATE TABLE rooms (
    room_id             INT IDENTITY(1,1)   NOT NULL,
    room_code           VARCHAR(20)         NOT NULL,
    room_name           NVARCHAR(100)       NOT NULL, 
    floor               INT                 NOT NULL DEFAULT 1,
    area                DECIMAL(5,2)        NOT NULL, 
    max_tenants         INT                 NOT NULL DEFAULT 2, 
    base_price          DECIMAL(18,0)       NOT NULL, 
    description         NVARCHAR(2000)      NULL,     
    status              VARCHAR(20)         NOT NULL DEFAULT 'Empty', 
    created_at          DATETIME            NOT NULL DEFAULT GETDATE(),
    updated_at          DATETIME            NULL,

    CONSTRAINT pk_rooms PRIMARY KEY (room_id),
    CONSTRAINT uq_rooms_room_code UNIQUE (room_code),
    CONSTRAINT chk_rooms_base_price CHECK (base_price >= 0),
    CONSTRAINT chk_rooms_area CHECK (area > 0),
    CONSTRAINT chk_rooms_status CHECK (status IN ('Empty', 'Reserved', 'Rented'))
);
GO

-- Bảng 3: tenants (Hồ sơ cư trú khách thuê - UC04)

CREATE TABLE tenants (
    tenant_id           INT IDENTITY(1,1)   NOT NULL,
    user_id             INT                 NULL,     
    room_id             INT                 NULL,    
    hometown            NVARCHAR(255)       NULL,     
    emergency_contact   VARCHAR(15)         NULL,     
    is_room_leader      BIT                 NOT NULL DEFAULT 0,
    created_at          DATETIME            NOT NULL DEFAULT GETDATE(),
    updated_at          DATETIME            NULL,

    CONSTRAINT pk_tenants PRIMARY KEY (tenant_id),
    CONSTRAINT fk_tenants_users FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    CONSTRAINT fk_tenants_rooms FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE SET NULL
);
GO

-- Bảng 4: contracts (Hợp đồng thuê phòng & Đặt cọc giữ chỗ - UC05)
CREATE TABLE contracts (
    contract_id         INT IDENTITY(1,1)   NOT NULL,
    contract_code       VARCHAR(30)         NOT NULL, 
    room_id             INT                 NOT NULL,
    tenant_id           INT                 NOT NULL, 
    start_date          DATE                NOT NULL,
    end_date            DATE                NOT NULL,
    rental_price        DECIMAL(18,0)       NOT NULL, 
    deposit_amount      DECIMAL(18,0)       NOT NULL DEFAULT 0,
    terms               NVARCHAR(MAX)       NULL,     
    status              VARCHAR(20)         NOT NULL DEFAULT 'Active', 
    created_at          DATETIME            NOT NULL DEFAULT GETDATE(),
    updated_at          DATETIME            NULL,

    CONSTRAINT pk_contracts PRIMARY KEY (contract_id),
    CONSTRAINT uq_contracts_contract_code UNIQUE (contract_code),
    CONSTRAINT fk_contracts_rooms FOREIGN KEY (room_id) REFERENCES rooms(room_id),
    CONSTRAINT fk_contracts_tenants FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id),
    CONSTRAINT chk_contracts_dates CHECK (start_date <= end_date),
    CONSTRAINT chk_contracts_rental_price CHECK (rental_price > 0),
    CONSTRAINT chk_contracts_deposit_amount CHECK (deposit_amount >= 0),
    CONSTRAINT chk_contracts_status CHECK (status IN ('Active', 'Expired', 'Liquidated'))
);
GO

-- Bảng 5: meter_readings (Ghi chỉ số điện nước theo kỳ - UC06)

CREATE TABLE meter_readings (
    reading_id          INT IDENTITY(1,1)   NOT NULL,
    room_id             INT                 NOT NULL,
    billing_month       INT                 NOT NULL, 
    billing_year        INT                 NOT NULL,
    old_electricity     INT                 NOT NULL, 
    new_electricity     INT                 NOT NULL, 
    old_water           INT                 NOT NULL DEFAULT 0, 
    new_water           INT                 NOT NULL DEFAULT 0, 
    tenant_count        INT                 NOT NULL DEFAULT 2, 
    electric_vehicle_count INT              NOT NULL DEFAULT 0, 
    electricity_unit_price DECIMAL(18,0)    NOT NULL DEFAULT 3500,  
    water_unit_price       DECIMAL(18,0)    NOT NULL DEFAULT 50000, 
    internet_unit_price    DECIMAL(18,0)    NOT NULL DEFAULT 50000, 
    elevator_unit_price    DECIMAL(18,0)    NOT NULL DEFAULT 100000,
    washing_unit_price     DECIMAL(18,0)    NOT NULL DEFAULT 50000, 
    ev_charging_unit_price DECIMAL(18,0)    NOT NULL DEFAULT 100000,
    recorded_at         DATETIME            NOT NULL DEFAULT GETDATE(),

    CONSTRAINT pk_meter_readings PRIMARY KEY (reading_id),
    CONSTRAINT fk_meter_readings_rooms FOREIGN KEY (room_id) REFERENCES rooms(room_id),
    CONSTRAINT uq_meter_readings_room_period UNIQUE (room_id, billing_month, billing_year),
    CONSTRAINT chk_meter_readings_elec CHECK (new_electricity >= old_electricity),
    CONSTRAINT chk_meter_readings_water CHECK (new_water >= old_water),
    CONSTRAINT chk_meter_readings_month CHECK (billing_month BETWEEN 1 AND 12)
);
GO

-- Bảng 6: invoices (Hóa đơn dịch vụ hàng tháng 7 mục phí - UC07, UC13)
CREATE TABLE invoices (
    invoice_id          INT IDENTITY(1,1)   NOT NULL,
    invoice_code        VARCHAR(30)         NOT NULL, 
    contract_id         INT                 NOT NULL,
    room_id             INT                 NOT NULL,
    reading_id          INT                 NULL,
    billing_month       INT                 NOT NULL,
    billing_year        INT                 NOT NULL,
    -- Chi tiết 7 khoản phí dịch vụ theo khảo sát thực tế Nhà trọ số 8 Nguyễn An Ninh:
    room_fee            DECIMAL(18,0)       NOT NULL, -- Khoản 1: Tiền phòng
    electricity_fee     DECIMAL(18,0)       NOT NULL, -- Khoản 2: Tiền điện
    water_fee           DECIMAL(18,0)       NOT NULL, -- Khoản 3: Tiền nước
    internet_fee        DECIMAL(18,0)       NOT NULL, -- Khoản 4: Tiền mạng 
    elevator_fee        DECIMAL(18,0)       NOT NULL, -- Khoản 5: Thang máy & vệ sinh 
    washing_fee         DECIMAL(18,0)       NOT NULL, -- Khoản 6: Máy giặt chung 
    ev_charging_fee     DECIMAL(18,0)       NOT NULL DEFAULT 0, -- Khoản 7: Sạc xe điện 
    
    total_amount        DECIMAL(18,0)       NOT NULL, 
    paid_amount         DECIMAL(18,0)       NOT NULL DEFAULT 0,
    remaining_amount    DECIMAL(18,0)       NOT NULL, 
    status              VARCHAR(20)         NOT NULL DEFAULT 'Unpaid', 
    due_date            DATE                NOT NULL,
    created_at          DATETIME            NOT NULL DEFAULT GETDATE(),
    paid_at             DATETIME            NULL,

    CONSTRAINT pk_invoices PRIMARY KEY (invoice_id),
    CONSTRAINT uq_invoices_invoice_code UNIQUE (invoice_code),
    CONSTRAINT fk_invoices_contracts FOREIGN KEY (contract_id) REFERENCES contracts(contract_id),
    CONSTRAINT fk_invoices_rooms FOREIGN KEY (room_id) REFERENCES rooms(room_id),
    CONSTRAINT fk_invoices_readings FOREIGN KEY (reading_id) REFERENCES meter_readings(reading_id),
    CONSTRAINT chk_invoices_total CHECK (total_amount = (room_fee + electricity_fee + water_fee + internet_fee + elevator_fee + washing_fee + ev_charging_fee)),
    CONSTRAINT chk_invoices_status CHECK (status IN ('Unpaid', 'Paid', 'Debt'))
);
GO

-- Bảng 7: wallets (Sổ cái Ví nội bộ của khách thuê - UC08, UC10, UC11)
CREATE TABLE wallets (
    wallet_id           INT IDENTITY(1,1)   NOT NULL,
    user_id             INT                 NOT NULL, 
    balance             DECIMAL(18,0)       NOT NULL DEFAULT 0, 
    status              VARCHAR(20)         NOT NULL DEFAULT 'Active', 
    created_at          DATETIME            NOT NULL DEFAULT GETDATE(),
    updated_at          DATETIME            NULL,

    CONSTRAINT pk_wallets PRIMARY KEY (wallet_id),
    CONSTRAINT uq_wallets_user_id UNIQUE (user_id),
    CONSTRAINT fk_wallets_users FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT chk_wallets_balance CHECK (balance >= 0),
    CONSTRAINT chk_wallets_status CHECK (status IN ('Active', 'Frozen'))
);
GO

-- Bảng 8: topup_requests (Yêu cầu nạp tiền vào ví - UC08, UC09)
CREATE TABLE topup_requests (
    request_id          INT IDENTITY(1,1)   NOT NULL,
    request_code        VARCHAR(30)         NOT NULL, 
    wallet_id           INT                 NOT NULL,
    amount              DECIMAL(18,0)       NOT NULL, 
    receipt_image_url   NVARCHAR(500)       NULL,     
    bank_reference_code VARCHAR(50)         NULL,     
    note                NVARCHAR(500)       NULL,     
    status              VARCHAR(20)         NOT NULL DEFAULT 'Pending', -- 'Pending', 'Approved', 'Rejected'
    reject_reason       NVARCHAR(255)       NULL,    
    approved_by         INT                 NULL,     
    created_at          DATETIME            NOT NULL DEFAULT GETDATE(),
    processed_at        DATETIME            NULL,

    CONSTRAINT pk_topup_requests PRIMARY KEY (request_id),
    CONSTRAINT uq_topup_requests_code UNIQUE (request_code),
    CONSTRAINT fk_topup_requests_wallets FOREIGN KEY (wallet_id) REFERENCES wallets(wallet_id),
    CONSTRAINT fk_topup_requests_approver FOREIGN KEY (approved_by) REFERENCES users(user_id),
    CONSTRAINT chk_topup_requests_amount CHECK (amount > 0),
    CONSTRAINT chk_topup_requests_status CHECK (status IN ('Pending', 'Approved', 'Rejected'))
);
GO

-- Bảng 9: transactions (Lịch sử giao dịch sổ cái ví - UC10, UC11)
CREATE TABLE transactions (
    transaction_id      INT IDENTITY(1,1)   NOT NULL,
    transaction_code    VARCHAR(30)         NOT NULL, 
    wallet_id           INT                 NOT NULL,
    invoice_id          INT                 NULL,     
    topup_request_id    INT                 NULL,     
    transaction_type    VARCHAR(30)         NOT NULL, -- 'TopUp', 'AutoDeduct', 'Refund'
    amount              DECIMAL(18,0)       NOT NULL, 
    balance_before      DECIMAL(18,0)       NOT NULL, 
    balance_after       DECIMAL(18,0)       NOT NULL, 
    description         NVARCHAR(500)       NOT NULL, 
    status              VARCHAR(20)         NOT NULL DEFAULT 'Success', -- 'Success', 'Failed'
    created_at          DATETIME            NOT NULL DEFAULT GETDATE(),

    CONSTRAINT pk_transactions PRIMARY KEY (transaction_id),
    CONSTRAINT uq_transactions_code UNIQUE (transaction_code),
    CONSTRAINT fk_transactions_wallets FOREIGN KEY (wallet_id) REFERENCES wallets(wallet_id),
    CONSTRAINT fk_transactions_invoices FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id),
    CONSTRAINT fk_transactions_topup FOREIGN KEY (topup_request_id) REFERENCES topup_requests(request_id),
    CONSTRAINT chk_transactions_type CHECK (transaction_type IN ('TopUp', 'AutoDeduct', 'Refund')),
    CONSTRAINT chk_transactions_status CHECK (status IN ('Success', 'Failed'))
);
GO

-- Bảng 10: debts (Theo dõi công nợ phòng trọ khi ví thiếu tiền - UC12)
CREATE TABLE debts (
    debt_id             INT IDENTITY(1,1)   NOT NULL,
    invoice_id          INT                 NOT NULL,
    room_id             INT                 NOT NULL,
    tenant_id           INT                 NOT NULL,
    debt_amount         DECIMAL(18,0)       NOT NULL, 
    overdue_days        INT                 NOT NULL DEFAULT 0, 
    status              VARCHAR(20)         NOT NULL DEFAULT 'Unpaid', -- 'Unpaid', 'Overdue', 'Cleared'
    last_notified_at    DATETIME            NULL,    
    created_at          DATETIME            NOT NULL DEFAULT GETDATE(),
    updated_at          DATETIME            NULL,

    CONSTRAINT pk_debts PRIMARY KEY (debt_id),
    CONSTRAINT fk_debts_invoices FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id),
    CONSTRAINT fk_debts_rooms FOREIGN KEY (room_id) REFERENCES rooms(room_id),
    CONSTRAINT fk_debts_tenants FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id),
    CONSTRAINT chk_debts_amount CHECK (debt_amount > 0),
    CONSTRAINT chk_debts_status CHECK (status IN ('Unpaid', 'Overdue', 'Cleared'))
);
GO

-- PHẦN II: KHỞI TẠO BỘ DỮ LIỆU MẪU (SEED DATA)
-- 1. Tài khoản mẫu (Tài khoản Chủ trọ & Khách thuê Phan Trần Việt Anh)
INSERT INTO users (username, password_hash, full_name, phone_number, email, id_card_number, role, status)
VALUES 
('chutro',  '123', N'Nguyễn Văn Thắng (Chủ trọ)', '0988888888', 'chutro@nhatro8.vn', '001080000001', 'Landlord', 'Active'),
('vietanh', '123', N'Phan Trần Việt Anh',         '0912345678', 'vietanh@gmail.com', '001202000001', 'Tenant',   'Active'),
('admin',   '123', N'Quản trị viên Hệ thống',    '0900000000', 'admin@nhatro8.vn',  '001000000000', 'Admin',    'Active');
GO

-- 2. Danh mục phòng trọ mẫu
INSERT INTO rooms (room_code, room_name, floor, area, max_tenants, base_price, description, status)
VALUES 
('P101', N'Phòng 101', 1, 25.0, 2, 2800000, N'Tầng 1, có điều hòa, bình nóng lạnh, khép kín', 'Rented'),
('P102', N'Phòng 102', 1, 28.0, 2, 3000000, N'Tầng 1, ban công thoáng mát',                  'Reserved'),
('P103', N'Phòng 103', 1, 22.0, 2, 2500000, N'Tầng 1, phòng tiêu chuẩn sinh viên',          'Empty');
GO

-- 3. Hồ sơ khách thuê
INSERT INTO tenants (user_id, room_id, hometown, emergency_contact, is_room_leader)
VALUES 
(2, 1, N'Nam Định', '0911222333', 1); -- Phan Trần Việt Anh thuê Phòng 101
GO

-- 4. Hợp đồng thuê phòng (Phòng 101)
INSERT INTO contracts (contract_code, room_id, tenant_id, start_date, end_date, rental_price, deposit_amount, terms, status)
VALUES 
('HDT001', 1, 1, '2026-09-01', '2027-08-31', 2800000, 2800000, N'Hợp đồng 1 năm, cọc 1 tháng, thanh toán trước ngày 05 hàng tháng', 'Active');
GO

-- 5. Chỉ số điện nước tháng 09/2026 (Phòng 101: 184 số điện)
INSERT INTO meter_readings (room_id, billing_month, billing_year, old_electricity, new_electricity, old_water, new_water, tenant_count, electric_vehicle_count, recorded_at)
VALUES 
(1, 9, 2026, 3927, 4111, 120, 128, 2, 0, '2026-09-30 20:00:00');
GO

-- 6. Hóa đơn tháng 09/2026
INSERT INTO invoices (invoice_code, contract_id, room_id, reading_id, billing_month, billing_year, room_fee, electricity_fee, water_fee, internet_fee, elevator_fee, washing_fee, ev_charging_fee, total_amount, paid_amount, remaining_amount, status, due_date, created_at)
VALUES 
('HD001', 1, 1, 1, 9, 2026, 2800000, 644000, 100000, 100000, 200000, 100000, 0, 3944000, 0, 3944000, 'Unpaid', '2026-10-05', '2026-10-01 08:00:00');
GO

-- 7. Tạo Ví nội bộ của Phan Trần Việt Anh (Có sẵn số dư mẫu 4.000.000 đ)
INSERT INTO wallets (user_id, balance, status)
VALUES 
(2, 4000000, 'Active');
GO

-- 8. Giao dịch nạp tiền mẫu đã được Chủ trọ phê duyệt
INSERT INTO topup_requests (request_code, wallet_id, amount, receipt_image_url, bank_reference_code, note, status, approved_by, created_at, processed_at)
VALUES 
('YCNT001', 1, 4000000, 'bienlai_mb_4000k.jpg', 'MB123456789', N'Nộp tiền trọ tháng 9', 'Approved', 1, '2026-10-02 09:15:00', '2026-10-02 09:30:00');
GO

INSERT INTO transactions (transaction_code, wallet_id, topup_request_id, transaction_type, amount, balance_before, balance_after, description, status, created_at)
VALUES 
('GD001', 1, 1, 'TopUp', 4000000, 0, 4000000, N'Nạp tiền vào ví qua chuyển khoản MB Bank (Chủ trọ Thắng duyệt)', 'Success', '2026-10-02 09:30:00');
GO

