USE master
GO

CREATE DATABASE QLDT2
GO

USE QLDT2
GO

CREATE TABLE GIAOVIEN (
    MAGV CHAR(3) PRIMARY KEY,
    HOTEN NVARCHAR(50),
    LUONG DEC(10,2),
    PHAI NVARCHAR(3),
    NGSINH DATE,
    DIACHI NVARCHAR(100),
    GVQLCM CHAR(3),
    MABM CHAR(3)
)

CREATE TABLE BOMON (
    MABM CHAR(3) PRIMARY KEY,
    TENBM NVARCHAR(50),
    PHONG CHAR(3),
    DIENTHOAI CHAR(10),
    TRUONGBM CHAR(3),
    MAKHOA VARCHAR(4),
    NGAYNHANCHUC DATE
)

CREATE TABLE KHOA (
    MAKHOA VARCHAR(4) PRIMARY KEY,
    TENKHOA NVARCHAR(50),
    NAMTL SMALLINT,
    PHONG CHAR(3),
    DIENTHOAI CHAR(10),
    TRUONGKHOA CHAR(3),
    NGAYNHANCHUC DATE
)

CREATE TABLE CONGVIEC (
    MADT CHAR(3),
    SOTT INT,
    TENCV NVARCHAR(50),
    NGAYBD DATE,
    NGAYKT DATE,
    PRIMARY KEY (MADT, SOTT)
)

CREATE TABLE DETAI (
    MADT CHAR(3) PRIMARY KEY,
    TENDT NVARCHAR(50),
    CAPQL NVARCHAR(20),
    KINHPHI DEC(10,2),
    NGAYBD DATE,
    NGAYKT DATE,
    MACD NVARCHAR(4),
    GVCNDT CHAR(3)
)

CREATE TABLE CHUDE (
    MACD NVARCHAR(4) PRIMARY KEY,
    TENCD NVARCHAR(50)
)

CREATE TABLE THAMGIADT (
    MAGV CHAR(3),
    MADT CHAR(3),
    STT INT,
    PHUCAP DEC(10,2),
    KETQUA NVARCHAR(50),
    PRIMARY KEY (MAGV, MADT, STT)
)

CREATE TABLE NGUOITHAN (
    MAGV CHAR(3),
    TEN NVARCHAR(50),
    NGSINH DATE,
    PHAI NVARCHAR(3),
    PRIMARY KEY (MAGV, TEN)
)

CREATE TABLE GV_DT (
    MAGV CHAR(3),
    DIENTHOAI CHAR(10),
    PRIMARY KEY (MAGV, DIENTHOAI)
)


-- FK TABLE GIAOVIEN --
ALTER TABLE GIAOVIEN
ADD CONSTRAINT FK_GIAOVIEN_GVQLCM
FOREIGN KEY (GVQLCM)
REFERENCES GIAOVIEN(MAGV)

ALTER TABLE GIAOVIEN
ADD CONSTRAINT FK_GIAOVIEN_BOMON
FOREIGN KEY (MABM)
REFERENCES BOMON(MABM)

-- FK TABLE BOMON --
ALTER TABLE BOMON
ADD CONSTRAINT FK_BOMON_GIAOVIEN
FOREIGN KEY (TRUONGBM)
REFERENCES GIAOVIEN(MAGV)

ALTER TABLE BOMON
ADD CONSTRAINT FK_BOMON_KHOA
FOREIGN KEY (MAKHOA)
REFERENCES KHOA(MAKHOA)

-- FK TABLE KHOA --
ALTER TABLE KHOA
ADD CONSTRAINT FK_KHOA_GIAOVIEN
FOREIGN KEY (TRUONGKHOA)
REFERENCES GIAOVIEN(MAGV)

-- FK TABLE THAMGIADT --
ALTER TABLE THAMGIADT
ADD CONSTRAINT FK_TGDT_GIAOVIEN
FOREIGN KEY (MAGV)
REFERENCES GIAOVIEN(MAGV)

ALTER TABLE THAMGIADT
ADD CONSTRAINT FK_TGDT_CONGVIEC
FOREIGN KEY (MADT, STT)
REFERENCES CONGVIEC(MADT, SOTT)

-- FK TABLE CONGVIEC --
ALTER TABLE CONGVIEC
ADD CONSTRAINT FK_CONGVIEC_DETAI
FOREIGN KEY (MADT)
REFERENCES DETAI(MADT)

-- FK TABLE DETAI --
ALTER TABLE DETAI
ADD CONSTRAINT FK_DETAI_CHUDE
FOREIGN KEY (MACD)
REFERENCES CHUDE(MACD)

ALTER TABLE DETAI
ADD CONSTRAINT FK_DETAI_GIAOVIEN
FOREIGN KEY (GVCNDT)
REFERENCES GIAOVIEN(MAGV)

-- FK TABLE NGUOITHAN --
ALTER TABLE NGUOITHAN
ADD CONSTRAINT FK_NGUOITHAN_GIAOVIEN
FOREIGN KEY (MAGV)
REFERENCES GIAOVIEN(MAGV)

-- FK TABLE GV_DT --
ALTER TABLE GV_DT
ADD CONSTRAINT FK_GV_DT_GIAOVIEN
FOREIGN KEY (MAGV)
REFERENCES GIAOVIEN(MAGV)

/* =========================================================
   1. INSERT KHOA
   TRUONGKHOA để NULL trước vì GIAOVIEN chưa có
   ========================================================= */

INSERT INTO KHOA(MAKHOA, TENKHOA, NAMTL, PHONG, DIENTHOAI, TRUONGKHOA, NGAYNHANCHUC)
VALUES
    ('CNTT', N'Công nghệ thông tin', 1995, 'B11', '0281234567', NULL, NULL),
    ('VLKT', N'Vật lý - Vật lý kỹ thuật', 1976, 'B21', '0282345678', NULL, NULL),
    ('SH',   N'Sinh học', 1980, 'B31', '0283456789', NULL, NULL);
GO


/* =========================================================
   2. INSERT BOMON
   TRUONGBM để NULL trước vì GIAOVIEN chưa có
   ========================================================= */

INSERT INTO BOMON(MABM, TENBM, PHONG, DIENTHOAI, TRUONGBM, MAKHOA, NGAYNHANCHUC)
VALUES
    ('HTT', N'Hệ thống thông tin',      'B01', '0281111111', NULL, 'CNTT', NULL),
    ('CNM', N'Mạng máy tính',           'B02', '0281111112', NULL, 'CNTT', NULL),
    ('KTP', N'Kỹ thuật phần mềm',       'B03', '0281111113', NULL, 'CNTT', NULL),

    ('VLĐ', N'Vật lý điện tử',          'B04', '0282222221', NULL, 'VLKT', NULL),
    ('UDT', N'Ứng dụng tin học',        'B05', '0282222222', NULL, 'VLKT', NULL),

    ('SHH', N'Sinh hóa',                'B06', '0283333331', NULL, 'SH', NULL),
    ('VSV', N'Vi sinh vật',             'B07', '0283333332', NULL, 'SH', NULL);
GO


/* =========================================================
   3. INSERT GIAOVIEN
   GVQLCM để NULL trước
   ========================================================= */

INSERT INTO GIAOVIEN(MAGV, HOTEN, LUONG, PHAI, NGSINH, DIACHI, GVQLCM, MABM)
VALUES
    ('001', N'Nguyễn Văn An',       2500.00, N'Nam', '1975-11-20', N'Quận 1, TP.HCM',  NULL, 'HTT'),
    ('002', N'Trần Thị Bình',       2200.00, N'Nữ',  '1980-03-15', N'Quận 3, TP.HCM',  NULL, 'HTT'),
    ('003', N'Lê Văn Cường',        2400.00, N'Nam', '1978-07-10', N'Quận 5, TP.HCM',  NULL, 'CNM'),
    ('004', N'Phạm Thị Dung',       2100.00, N'Nữ',  '1985-12-01', N'Quận 7, TP.HCM',  NULL, 'CNM'),
    ('005', N'Hoàng Văn Em',        2300.00, N'Nam', '1979-06-23', N'Thủ Đức, TP.HCM', NULL, 'KTP'),
    ('006', N'Võ Thị Giang',        2050.00, N'Nữ',  '1987-09-17', N'Quận 10, TP.HCM', NULL, 'KTP'),

    ('007', N'Đặng Văn Hùng',       2600.00, N'Nam', '1974-01-05', N'Quận 6, TP.HCM',  NULL, 'VLĐ'),
    ('008', N'Bùi Thị Hương',       2150.00, N'Nữ',  '1983-05-30', N'Quận 8, TP.HCM',  NULL, 'UDT'),

    ('009', N'Ngô Văn Khánh',       2550.00, N'Nam', '1976-04-12', N'Bình Thạnh',      NULL, 'SHH'),
    ('010', N'Đỗ Thị Lan',          2250.00, N'Nữ',  '1982-08-08', N'Gò Vấp, TP.HCM', NULL, 'VSV');
GO


/* =========================================================
   4. UPDATE TRƯỞNG BỘ MÔN
   ========================================================= */

UPDATE BOMON
SET TRUONGBM = '001',
    NGAYNHANCHUC = '2015-01-01'
WHERE MABM = 'HTT';

UPDATE BOMON
SET TRUONGBM = '003',
    NGAYNHANCHUC = '2016-06-01'
WHERE MABM = 'CNM';

UPDATE BOMON
SET TRUONGBM = '005',
    NGAYNHANCHUC = '2018-03-01'
WHERE MABM = 'KTP';

UPDATE BOMON
SET TRUONGBM = '007',
    NGAYNHANCHUC = '2014-01-01'
WHERE MABM = 'VLĐ';

UPDATE BOMON
SET TRUONGBM = '008',
    NGAYNHANCHUC = '2019-09-01'
WHERE MABM = 'UDT';

UPDATE BOMON
SET TRUONGBM = '009',
    NGAYNHANCHUC = '2017-02-01'
WHERE MABM = 'SHH';

UPDATE BOMON
SET TRUONGBM = '010',
    NGAYNHANCHUC = '2020-01-01'
WHERE MABM = 'VSV';
GO


/* =========================================================
   5. UPDATE TRƯỞNG KHOA
   ========================================================= */

UPDATE KHOA
SET TRUONGKHOA = '001',
    NGAYNHANCHUC = '2018-01-01'
WHERE MAKHOA = 'CNTT';

UPDATE KHOA
SET TRUONGKHOA = '007',
    NGAYNHANCHUC = '2017-01-01'
WHERE MAKHOA = 'VLKT';

UPDATE KHOA
SET TRUONGKHOA = '009',
    NGAYNHANCHUC = '2019-01-01'
WHERE MAKHOA = 'SH';
GO


/* =========================================================
   6. UPDATE GIÁO VIÊN QUẢN LÝ CHUYÊN MÔN
   ========================================================= */

UPDATE GIAOVIEN
SET GVQLCM = '001'
WHERE MAGV = '002';

UPDATE GIAOVIEN
SET GVQLCM = '003'
WHERE MAGV = '004';

UPDATE GIAOVIEN
SET GVQLCM = '005'
WHERE MAGV = '006';
GO


/* =========================================================
   7. INSERT CHUDE
   ========================================================= */

INSERT INTO CHUDE(MACD, TENCD)
VALUES
    ('NCPT', N'Nghiên cứu phát triển'),
    ('QLGD', N'Quản lý giáo dục'),
    ('UDCN', N'Ứng dụng công nghệ'),
    ('MTTT', N'Môi trường và tài nguyên');
GO


/* =========================================================
   8. INSERT DETAI
   ========================================================= */

INSERT INTO DETAI(MADT, TENDT, CAPQL, KINHPHI, NGAYBD, NGAYKT, MACD, GVCNDT)
VALUES
    ('001', N'Xây dựng hệ thống quản lý sinh viên',
        N'Trường', 10000.00, '2024-01-01', '2024-12-31', 'QLGD', '001'),

    ('002', N'Nghiên cứu ứng dụng trí tuệ nhân tạo',
        N'ĐHQG', 25000.00, '2024-03-01', '2025-03-01', 'NCPT', '003'),

    ('003', N'Xây dựng hệ thống nhận diện hình ảnh',
        N'Trường', 18000.00, '2024-05-01', '2025-05-01', 'UDCN', '005'),

    ('004', N'Nghiên cứu cảm biến môi trường',
        N'ĐHQG', 30000.00, '2024-06-01', '2025-06-01', 'MTTT', '007'),

    ('005', N'Ứng dụng học máy trong phân tích dữ liệu',
        N'Trường', 20000.00, '2024-07-01', '2025-04-30', 'UDCN', '008');
GO


/* =========================================================
   9. INSERT CONGVIEC
   ========================================================= */

INSERT INTO CONGVIEC(MADT, SOTT, TENCV, NGAYBD, NGAYKT)
VALUES
    ('001', 1, N'Khảo sát yêu cầu',           '2024-01-01', '2024-02-15'),
    ('001', 2, N'Thiết kế cơ sở dữ liệu',     '2024-02-16', '2024-04-30'),
    ('001', 3, N'Xây dựng hệ thống',          '2024-05-01', '2024-10-31'),
    ('001', 4, N'Kiểm thử hệ thống',          '2024-11-01', '2024-12-31'),

    ('002', 1, N'Thu thập dữ liệu',           '2024-03-01', '2024-05-31'),
    ('002', 2, N'Xây dựng mô hình',           '2024-06-01', '2024-10-31'),
    ('002', 3, N'Đánh giá mô hình',           '2024-11-01', '2025-03-01'),

    ('003', 1, N'Chuẩn bị dữ liệu hình ảnh',   '2024-05-01', '2024-07-31'),
    ('003', 2, N'Huấn luyện mô hình',          '2024-08-01', '2025-01-31'),
    ('003', 3, N'Đánh giá kết quả',            '2025-02-01', '2025-05-01'),

    ('004', 1, N'Thiết kế cảm biến',           '2024-06-01', '2024-09-30'),
    ('004', 2, N'Thu thập dữ liệu môi trường', '2024-10-01', '2025-02-28'),
    ('004', 3, N'Phân tích dữ liệu',           '2025-03-01', '2025-06-01'),

    ('005', 1, N'Thu thập bộ dữ liệu',         '2024-07-01', '2024-09-30'),
    ('005', 2, N'Xử lý dữ liệu',               '2024-10-01', '2024-12-31'),
    ('005', 3, N'Xây dựng mô hình học máy',    '2025-01-01', '2025-04-30');
GO


/* =========================================================
   10. INSERT THAMGIADT

   STT phải tồn tại trong CONGVIEC(MADT, SOTT)
   ========================================================= */

INSERT INTO THAMGIADT(MAGV, MADT, STT, PHUCAP, KETQUA)
VALUES
    ('001', '001', 1, 500.00, N'Đạt'),
    ('002', '001', 2, 400.00, N'Đạt'),
    ('005', '001', 3, 600.00, N'Đạt'),
    ('006', '001', 4, 300.00, N'Đạt'),

    ('003', '002', 1, 500.00, N'Đạt'),
    ('004', '002', 1, 350.00, N'Đạt'),
    ('003', '002', 2, 700.00, N'Đạt'),
    ('005', '002', 3, 500.00, N'Đạt'),

    ('005', '003', 1, 450.00, N'Đạt'),
    ('006', '003', 2, 650.00, N'Đạt'),
    ('002', '003', 3, 400.00, N'Đạt'),

    ('007', '004', 1, 550.00, N'Đạt'),
    ('008', '004', 2, 500.00, N'Đạt'),
    ('007', '004', 3, 600.00, N'Đạt'),

    ('008', '005', 1, 450.00, N'Đạt'),
    ('004', '005', 2, 500.00, N'Đạt'),
    ('006', '005', 3, 600.00, N'Đạt');
GO


/* =========================================================
   11. INSERT NGUOITHAN
   ========================================================= */

INSERT INTO NGUOITHAN
    (MAGV, TEN, NGSINH, PHAI)
VALUES
    ('001', N'Nguyễn Thị Mai',   '1978-04-12', N'Nữ'),
    ('001', N'Nguyễn Văn Minh',  '2005-08-20', N'Nam'),

    ('002', N'Trần Văn Long',    '1978-09-10', N'Nam'),
    ('003', N'Lê Thị Hoa',       '1980-11-05', N'Nữ'),

    ('005', N'Hoàng Thị Thảo',   '1982-06-16', N'Nữ'),
    ('007', N'Đặng Thị Hồng',    '1977-02-14', N'Nữ'),

    ('008', N'Bùi Văn Nam',      '1981-12-25', N'Nam'),
    ('009', N'Ngô Thị Ngọc',     '1979-03-21', N'Nữ');
GO


/* =========================================================
   12. INSERT GV_DT
   ========================================================= */

INSERT INTO GV_DT
    (MAGV, DIENTHOAI)
VALUES
    ('001', '0901000001'),
    ('001', '0911000001'),

    ('002', '0902000002'),
    ('003', '0903000003'),
    ('004', '0904000004'),

    ('005', '0905000005'),
    ('005', '0915000005'),

    ('006', '0906000006'),
    ('007', '0907000007'),
    ('008', '0908000008'),
    ('009', '0909000009'),
    ('010', '0910000010');
GO