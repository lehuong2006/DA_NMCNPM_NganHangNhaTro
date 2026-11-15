-- Tạo database
IF DB_ID(N'ngan_hang_nha_tro') IS NULL
BEGIN
    CREATE DATABASE ngan_hang_nha_tro;
END
GO

USE ngan_hang_nha_tro;
GO

-- 1. BẢNG users
CREATE TABLE users (
    id              BIGINT IDENTITY(1,1) PRIMARY KEY,
    phone_number    NVARCHAR(20)  NOT NULL UNIQUE,
    password_hash   NVARCHAR(255) NOT NULL,
    full_name       NVARCHAR(100) NOT NULL,
    identity_card   NVARCHAR(20)  NULL,
    address         NVARCHAR(255) NULL,
    role            NVARCHAR(20)  NOT NULL,           -- ADMIN | LANDLORD | TENANT
    status          NVARCHAR(20)  NOT NULL DEFAULT N'ACTIVE', -- ACTIVE | LOCKED
    created_at      DATETIME2     NOT NULL DEFAULT SYSDATETIME()
);
GO
-- 2. BẢNG rooms
CREATE TABLE rooms (
    id              BIGINT IDENTITY(1,1) PRIMARY KEY,
    landlord_id     BIGINT        NOT NULL,
    room_code       NVARCHAR(20)  NOT NULL,
    room_name       NVARCHAR(100) NULL,
    price           BIGINT        NOT NULL,            -- Giá thuê niêm yết (VNĐ)
    max_tenants     INT           NOT NULL DEFAULT 1,
    status          NVARCHAR(20)  NOT NULL DEFAULT N'AVAILABLE', -- AVAILABLE | RENTED | MAINTENANCE
    created_at      DATETIME2     NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT fk_rooms_landlord
        FOREIGN KEY (landlord_id) REFERENCES users(id)
);
GO
-- 3. BẢNG contracts
CREATE TABLE contracts (
    id              BIGINT IDENTITY(1,1) PRIMARY KEY,
    room_id         BIGINT        NOT NULL,
    tenant_id       BIGINT        NOT NULL,
    rental_price    BIGINT        NOT NULL,            -- Giá thuê thỏa thuận (VNĐ)
    deposit_amount  BIGINT        NOT NULL DEFAULT 0,  -- Tiền cọc (VNĐ)
    start_date      DATE          NOT NULL,
    end_date        DATE          NULL,
    status          NVARCHAR(20)  NOT NULL DEFAULT N'ACTIVE', -- ACTIVE | EXPIRED | TERMINATED
    created_at      DATETIME2     NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT fk_contracts_room
        FOREIGN KEY (room_id) REFERENCES rooms(id),
    CONSTRAINT fk_contracts_tenant
        FOREIGN KEY (tenant_id) REFERENCES users(id)
);
GO
-- 4. BẢNG service_prices
CREATE TABLE service_prices (
    id              BIGINT IDENTITY(1,1) PRIMARY KEY,
    service_code    NVARCHAR(30)  NOT NULL UNIQUE,     -- ELECTRIC | WATER | INTERNET | ...
    service_name    NVARCHAR(100) NOT NULL,
    unit_price      BIGINT        NOT NULL,            -- Đơn giá (VNĐ)
    unit            NVARCHAR(30)  NULL,                -- kWh | người | xe
    is_active       BIT           NOT NULL DEFAULT 1,
    updated_at      DATETIME2     NULL
);
GO
-- 5. BẢNG meter_readings
CREATE TABLE meter_readings (
    id              BIGINT IDENTITY(1,1) PRIMARY KEY,
    room_id         BIGINT        NOT NULL,
    contract_id     BIGINT        NOT NULL,
    month_year      NVARCHAR(10)  NOT NULL,            -- VD: 10/2026
    elec_old        INT           NOT NULL,
    elec_new        INT           NOT NULL,
    water_old       INT           NOT NULL,
    water_new       INT           NOT NULL,
    tenant_count    INT           NOT NULL DEFAULT 1,
    created_at      DATETIME2     NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT fk_meter_room
        FOREIGN KEY (room_id) REFERENCES rooms(id),
    CONSTRAINT fk_meter_contract
        FOREIGN KEY (contract_id) REFERENCES contracts(id),
    CONSTRAINT chk_elec CHECK (elec_new >= elec_old),
    CONSTRAINT chk_water CHECK (water_new >= water_old)
);
GO
-- 6. BẢNG invoices
CREATE TABLE invoices (
    id                  BIGINT IDENTITY(1,1) PRIMARY KEY,
    invoice_code        NVARCHAR(30)  NOT NULL UNIQUE,
    contract_id         BIGINT        NOT NULL,
    room_id             BIGINT        NOT NULL,
    meter_reading_id    BIGINT        NULL,
    month_year          NVARCHAR(10)  NOT NULL,
    room_fee            BIGINT        NOT NULL DEFAULT 0,
    elec_fee            BIGINT        NOT NULL DEFAULT 0,
    water_fee           BIGINT        NOT NULL DEFAULT 0,
    service_fee         BIGINT        NOT NULL DEFAULT 0,
    total_amount        BIGINT        NOT NULL DEFAULT 0,
    remaining_amount    BIGINT        NOT NULL DEFAULT 0,
    due_date            DATE          NULL,
    status              NVARCHAR(20)  NOT NULL DEFAULT N'UNPAID', -- UNPAID | PAID | PARTIAL_DEBT
    created_at          DATETIME2     NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT fk_invoices_contract
        FOREIGN KEY (contract_id) REFERENCES contracts(id),
    CONSTRAINT fk_invoices_room
        FOREIGN KEY (room_id) REFERENCES rooms(id),
    CONSTRAINT fk_invoices_meter
        FOREIGN KEY (meter_reading_id) REFERENCES meter_readings(id)
);
GO
-- 7. BẢNG wallets
CREATE TABLE wallets (
    id              BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id         BIGINT        NOT NULL UNIQUE,     -- Quan hệ 1-1 với users
    balance         BIGINT        NOT NULL DEFAULT 0,  -- Số dư ví (VNĐ)
    status          NVARCHAR(20)  NOT NULL DEFAULT N'ACTIVE', -- ACTIVE | LOCKED
    updated_at      DATETIME2     NULL,
    CONSTRAINT fk_wallets_user
        FOREIGN KEY (user_id) REFERENCES users(id)
);
GO
-- 8. BẢNG topup_requests
CREATE TABLE topup_requests (
    id                  BIGINT IDENTITY(1,1) PRIMARY KEY,
    wallet_id           BIGINT        NOT NULL,
    approved_by         BIGINT        NULL,            -- Chủ trọ duyệt
    amount              BIGINT        NOT NULL,        -- Số tiền đề nghị nạp (VNĐ)
    receipt_image_url   NVARCHAR(500) NULL,
    transaction_code    NVARCHAR(100) NULL,
    status              NVARCHAR(20)  NOT NULL DEFAULT N'PENDING', -- PENDING | APPROVED | REJECTED
    reject_reason       NVARCHAR(255) NULL,
    created_at          DATETIME2     NOT NULL DEFAULT SYSDATETIME(),
    approved_at         DATETIME2     NULL,
    CONSTRAINT fk_topup_wallet
        FOREIGN KEY (wallet_id) REFERENCES wallets(id),
    CONSTRAINT fk_topup_approver
        FOREIGN KEY (approved_by) REFERENCES users(id),
    CONSTRAINT chk_topup_amount CHECK (amount > 0)
);
GO
-- 9. BẢNG transactions
CREATE TABLE transactions (
    id                  BIGINT IDENTITY(1,1) PRIMARY KEY,
    wallet_id           BIGINT        NOT NULL,
    invoice_id          BIGINT        NULL,
    topup_request_id    BIGINT        NULL,
    amount              BIGINT        NOT NULL,
    balance_after       BIGINT        NOT NULL,        -- Số dư sau giao dịch
    type                NVARCHAR(20)  NOT NULL,        -- TOPUP | AUTO_DEDUCT
    description         NVARCHAR(255) NULL,
    created_at          DATETIME2     NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT fk_trans_wallet
        FOREIGN KEY (wallet_id) REFERENCES wallets(id),
    CONSTRAINT fk_trans_invoice
        FOREIGN KEY (invoice_id) REFERENCES invoices(id),
    CONSTRAINT fk_trans_topup
        FOREIGN KEY (topup_request_id) REFERENCES topup_requests(id)
);
GO
-- 10. BẢNG debts
CREATE TABLE debts (
    id              BIGINT IDENTITY(1,1) PRIMARY KEY,
    invoice_id      BIGINT        NOT NULL,
    room_id         BIGINT        NOT NULL,
    tenant_id       BIGINT        NOT NULL,
    debt_amount     BIGINT        NOT NULL,
    status          NVARCHAR(20)  NOT NULL DEFAULT N'PENDING', -- PENDING | OVERDUE | RESOLVED
    updated_at      DATETIME2     NULL,
    CONSTRAINT fk_debts_invoice
        FOREIGN KEY (invoice_id) REFERENCES invoices(id),
    CONSTRAINT fk_debts_room
        FOREIGN KEY (room_id) REFERENCES rooms(id),
    CONSTRAINT fk_debts_tenant
        FOREIGN KEY (tenant_id) REFERENCES users(id)
);
GO
-- DỮ LIỆU MẪU: Đơn giá dịch vụ
INSERT INTO service_prices (service_code, service_name, unit_price, unit, is_active) VALUES
(N'ELECTRIC',  N'Tiền điện',            3500,  N'kWh',   1),
(N'WATER',     N'Tiền nước',            50000, N'người', 1),
(N'INTERNET',  N'Tiền Internet',        50000, N'người', 1),
(N'CLEANING',  N'Vệ sinh & thang máy',  100000,N'người', 1),
(N'WASHING',   N'Máy giặt chung',       50000, N'người', 1),
(N'PARKING',   N'Sạc xe điện',          100000,N'xe',    1);
GO

-- 11. BẢNG invoice_items (Chi tiết từng khoản hóa đơn)
CREATE TABLE invoice_items (
    id              BIGINT IDENTITY(1,1) PRIMARY KEY,
    invoice_id      BIGINT        NOT NULL,
    service_code    NVARCHAR(30)  NULL,                -- ELECTRIC | WATER | INTERNET | ROOM | ...
    item_name       NVARCHAR(100) NOT NULL,            -- Tên hiển thị trên phiếu thu
    quantity        DECIMAL(10,2) NOT NULL DEFAULT 1,
    unit            NVARCHAR(20)  NULL,                -- kWh | người | xe | tháng
    unit_price      BIGINT        NOT NULL,            -- Đơn giá (VNĐ)
    amount          BIGINT        NOT NULL,            -- Thành tiền (VNĐ)
    created_at      DATETIME2     NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT fk_invoice_items_invoice
        FOREIGN KEY (invoice_id) REFERENCES invoices(id)
);
GO
--thêm unique không trùng phòng
ALTER TABLE rooms
ADD CONSTRAINT uq_rooms_landlord_code UNIQUE (landlord_id, room_code);
GO
--2. Thêm index phụ
CREATE INDEX ix_invoices_status ON invoices(status);
CREATE INDEX ix_invoices_month_year ON invoices(month_year);
CREATE INDEX ix_topup_status ON topup_requests(status);
CREATE INDEX ix_transactions_wallet ON transactions(wallet_id);
CREATE INDEX ix_invoice_items_invoice ON invoice_items(invoice_id);
CREATE INDEX ix_debts_status ON debts(status);
CREATE INDEX ix_topup_wallet ON topup_requests(wallet_id);
GO

-- Chặn hợp đồng chồng thời gian trên cùng 1 phòng
CREATE OR ALTER TRIGGER trg_contracts_no_overlap
ON contracts
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Chỉ kiểm tra các hợp đồng đang ACTIVE
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN contracts c
            ON c.room_id = i.room_id
           AND c.id <> i.id                  -- không so với chính nó
           AND c.status = N'ACTIVE'
           AND i.status = N'ACTIVE'
           AND (
                -- Hai khoảng thời gian giao nhau
                i.start_date <= ISNULL(c.end_date, '9999-12-31')
            AND c.start_date <= ISNULL(i.end_date, '9999-12-31')
           )
    )
    BEGIN
        RAISERROR(N'Phòng đã có hợp đồng ACTIVE trùng thời gian. Không thể tạo/cập nhật hợp đồng chồng chéo.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO
--bổ sung khóa ngoại
ALTER TABLE invoice_items
ADD CONSTRAINT fk_invoice_items_service
    FOREIGN KEY (service_code) REFERENCES service_prices(service_code);
GO

SELECT * FROM service_prices;

SELECT * FROM users;

-- Chuyển tài khoản thứ nhất thành chủ trọ
UPDATE dbo.users
SET role = 'LANDLORD'
WHERE phone_number = '0825611111';

-- Chuyển tài khoản thứ hai thành quản trị viên
UPDATE dbo.users
SET role = 'ADMIN'
WHERE phone_number = '0856798765';

SELECT id, phone_number, full_name, role, status
FROM dbo.users;