
go
create database [QLDT]
go

use [QLDT]
go

-- drop table if exists [GIAOVIEN]
-- drop table if exists [BOMON]
-- drop table if exists [KHOA]

-- CREATE TABLES
-- create table [KHOA]
-- (
--     MaKhoa char(10) primary key,
--     TenKhoa nvarchar(50) not null,
--     NamThanhLap SMALLINT not null,
--     DienThoai char(10),
--     Phong varchar(10),
--     TruongKhoa char(10),
--     NgayNhanChuc date not null
-- )
-- go

-- create table [BOMON]
-- (
--     TenBM nvarchar(50) not null,
--     MaBM char(10) primary key,
--     Phong varchar(10),
--     DienThoai char(10),
--     MaKhoa char(10),
--     TruongBM char(10),
--     NgayNhanChuc date not null
-- )
-- go

-- create table [GIAOVIEN]
-- (
--     MaGV char(10) primary key,
--     HoTen nvarchar(50) not null,
--     Luong decimal(10,2),
--     Phai nvarchar(3) not null,
--     DiaChi nvarchar(100),
--     NgaySinh date not null,
--     MaNQL char(10),
--     MaBM char(10)
-- )
-- go

-- ADJUST RELATIONAL CONSTRAINTS
go
alter table [BOMON] add constraint FK_BOMON_KHOA
    foreign key (MaKhoa)
    references KHOA(MaKhoa)

alter table [GIAOVIEN] add constraint FK_GIAOVIEN_BOMON
    foreign key (MaBM)
    references BOMON(MaBM)

alter table [KHOA] add constraint FK_KHOA_GIAOVIEN
    foreign key (TruongKhoa)
    references GIAOVIEN(MaGV)

alter table [BOMON] add constraint FK_BOMON_GIAOVIEN
    foreign key (TruongBM)
    references GIAOVIEN(MaGV)

alter table [GIAOVIEN] add constraint FK_GIAOVIEN_GIAOVIEN
    foreign key (MaNQL)
    references GIAOVIEN(MaGV)
go


-- INSERT DATA
insert into [GIAOVIEN] values
('GV001', N'Nguyễn Văn A', 5000.00, N'Nam', N'123 Đường ABC, TP.HCM', '1980-01-01', null, null),
('GV002', N'Lê Thị B', 4500.00, N'Nữ', N'456 Đường DEF, TP.HCM', '1985-05-15', 'GV001', null),
('GV003', N'Trần Văn C', 4000.00, N'Nam', N'789 Đường GHI, TP.HCM', '1990-10-20', 'GV001', null)
go


insert into [KHOA] values
('CNTT', N'Công nghệ thông tin', 2000, '0123456789', 'A101', 'GV001', '2020-01-01'),
('KT', N'Kế toán', 1995, '0987654321', 'B202', 'GV002', '2019-05-15')
go

insert into [BOMON] values
(N'Lập trình', 'BM001', 'C303', '0123456789', 'CNTT', 'GV003', '2021-01-01'),
(N'Mạng máy tính', 'BM002', 'D404', '0987654321', 'CNTT', 'GV002', '2020-05-15')
go