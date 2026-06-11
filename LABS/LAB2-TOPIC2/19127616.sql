-- use master
-- go

-- drop database QLDT
-- go

create database QLDT
go

use QLDT
go

create table GIAOVIEN
(
    MAGV char(3) not null,
    HOTEN nvarchar(40),
    LUONG float,
    PHAI nchar(3),
    NGSINH date,
    DIACHI nvarchar(200),
    GVQLCM char(3),
    MABM nchar(4)
)

create table GV_DT
(
    MAGV char(3) not null,
    DIENTHOAI char(10) not null
)

create table NGUOITHAN
(
    MAGV char(3) not null,
    TEN nvarchar(20) not null,
    NGSINH date,
    PHAI nchar(3)
)

create table KHOA
(
    MAKHOA char(4) not null,
    TENKHOA nvarchar(40),
    NAMTL int,
    PHONG char(3),
    DIENTHOAI char(10),
    TRUONGKHOA char(3),
    NGAYNHANCHUC date
)

create table BOMON
(
    MABM nchar(4) not null,
    TENBM nvarchar(40),
    PHONG char(3),
    DIENTHOAI char(10),
    TRUONGBM char(3),
    MAKHOA char(4),
    NGAYNHANCHUC date
)

create table CHUDE
(
    MACD char(4) not null,
    TENCD nvarchar(50)
)

create table DETAI
(
    MADT char(3) not null,
    TENDT nvarchar(100),
    CAPQL nvarchar(20),
    KINHPHI float,
    NGAYBD date,
    NGAYKT date,
    MACD char(4),
    GVCNDT char(3)
)

create table CONGVIEC
(
    MADT char(3) not null,
    SOTT int not null,
    TENCV nvarchar(100),
    NGAYBD date,
    NGAYKT date
)

create table THAMGIADT
(
    MAGV char(3) not null,
    MADT char(3) not null,
    STT int not null,
    PHUCAP float,
    KETQUA nchar(10)
)
go

alter table GIAOVIEN
add constraint PK_GIAOVIEN
primary key (MAGV)

alter table GV_DT
add constraint PK_GV_DT
primary key (MAGV, DIENTHOAI)

alter table NGUOITHAN
add constraint PK_NGUOITHAN
primary key (MAGV, TEN)

alter table KHOA
add constraint PK_KHOA
primary key (MAKHOA)

alter table BOMON
add constraint PK_BOMON
primary key (MABM)

alter table CHUDE
add constraint PK_CHUDE
primary key (MACD)

alter table DETAI
add constraint PK_DETAI
primary key (MADT)

alter table CONGVIEC
add constraint PK_CONGVIEC
primary key (MADT, SOTT)

alter table THAMGIADT
add constraint PK_THAMGIADT
primary key (MAGV, MADT, STT)
go

-- KHOÁ NGOẠI
alter table GIAOVIEN
add constraint FK_GIAOVIEN_GIAOVIEN
foreign key (GVQLCM)
references GIAOVIEN(MAGV)

alter table BOMON
add constraint FK_BOMON_KHOA
foreign key (MAKHOA)
references KHOA(MAKHOA)

alter table GIAOVIEN
add constraint FK_GIAOVIEN_BOMON
foreign key (MABM)
references BOMON(MABM)

alter table KHOA
add constraint FK_KHOA_GIAOVIEN
foreign key (TRUONGKHOA)
references GIAOVIEN(MAGV)

alter table BOMON
add constraint FK_BOMON_GIAOVIEN
foreign key (TRUONGBM)
references GIAOVIEN(MAGV)

alter table GV_DT
add constraint FK_GV_DT_GIAOVIEN
foreign key (MAGV)
references GIAOVIEN(MAGV)

alter table NGUOITHAN
add constraint FK_NGUOITHAN_GIAOVIEN
foreign key (MAGV)
references GIAOVIEN(MAGV)

alter table DETAI
add constraint FK_DETAI_CHUDE
foreign key (MACD)
references CHUDE(MACD)

alter table DETAI
add constraint FK_DETAI_GIAOVIEN
foreign key (GVCNDT)
references GIAOVIEN(MAGV)

alter table CONGVIEC
add constraint FK_CONGVIEC_DETAI
foreign key (MADT)
references DETAI(MADT)

alter table THAMGIADT
add constraint FK_THAMGIADT_GIAOVIEN
foreign key (MAGV)
references GIAOVIEN(MAGV)

alter table THAMGIADT
add constraint FK_THAMGIADT_CONGVIEC
foreign key (MADT, STT)
references CONGVIEC(MADT, SOTT)
go

-- INSERT
insert into CHUDE values ('AI01', N'Trí tuệ nhân tạo')
insert into CHUDE values ('DL01', N'Khoa học dữ liệu')
insert into CHUDE values ('AT01', N'An toàn thông tin')
insert into CHUDE values ('CDS1', N'Chuyển đổi số')
go

insert into GIAOVIEN values ('001',N'Nguyễn Minh Anh',2500,N'Nam','1975-04-15',N'Quận 1, TP.HCM',null,null)
insert into GIAOVIEN values ('002',N'Trần Thu Hà',2300,N'Nữ','1978-09-20',N'Thủ Đức, TP.HCM','001',null)
insert into GIAOVIEN values ('003',N'Lê Quốc Bảo',2800,N'Nam','1974-03-12',N'Gò Vấp, TP.HCM',null,null)
insert into GIAOVIEN values ('004',N'Phạm Ngọc Lan',2200,N'Nữ','1982-08-10',N'Bình Thạnh, TP.HCM','003',null)
insert into GIAOVIEN values ('005',N'Võ Thanh Tùng',2600,N'Nam','1976-11-05',N'Quận 7, TP.HCM',null,null)
insert into GIAOVIEN values ('006',N'Đặng Mỹ Linh',2100,N'Nữ','1985-01-18',N'Tân Bình, TP.HCM','005',null)
insert into GIAOVIEN values ('007',N'Hoàng Đức Long',2900,N'Nam','1972-06-22',N'Thủ Đức, TP.HCM',null,null)
insert into GIAOVIEN values ('008',N'Ngô Quỳnh Mai',2000,N'Nữ','1984-04-30',N'Quận 3, TP.HCM','007',null)
insert into GIAOVIEN values ('009',N'Bùi Anh Tuấn',2400,N'Nam','1979-12-08',N'Quận 10, TP.HCM','001',null)
insert into GIAOVIEN values ('010',N'Lý Khánh Vy',2200,N'Nữ','1987-05-19',N'Nhà Bè, TP.HCM','007',null)
go

insert into KHOA values ('CNTT',N'Công nghệ thông tin',2000,'A11','0281111111','001','2015-01-01')
insert into KHOA values ('KTPM',N'Kỹ thuật phần mềm',2002,'A21','0282222222','003','2016-01-01')
insert into KHOA values ('ATTT',N'An toàn thông tin',2004,'A31','0283333333','005','2017-01-01')
insert into KHOA values ('DTVT',N'Điện tử viễn thông',2001,'A41','0284444444','007','2018-01-01')
go

insert into BOMON values ('LTW1',N'Lập trình Web','B11','0281000001','001','CNTT','2016-05-01')
insert into BOMON values ('AI01',N'Trí tuệ nhân tạo','B12','0281000002','003','CNTT','2017-01-01')
insert into BOMON values ('CNPM',N'Công nghệ phần mềm','B21','0281000003','003','KTPM','2016-08-01')
insert into BOMON values ('KTPM',N'Kiểm thử phần mềm','B22','0281000004','004','KTPM','2018-01-01')
insert into BOMON values ('BMAT',N'Bảo mật mạng','B31','0281000005','005','ATTT','2017-05-01')
insert into BOMON values ('ATDL',N'An toàn dữ liệu','B32','0281000006','006','ATTT','2018-05-01')
insert into BOMON values ('VT01',N'Viễn thông','B41','0281000007','007','DTVT','2018-03-01')
insert into BOMON values ('MANG',N'Mạng truyền thông','B42','0281000008','008','DTVT','2019-01-01')
go

-- UPDATE MABM CHO GV
update GIAOVIEN set MABM='LTW1' where MAGV='001'
update GIAOVIEN set MABM='LTW1' where MAGV='002'
update GIAOVIEN set MABM='AI01' where MAGV='003'
update GIAOVIEN set MABM='CNPM' where MAGV='004'
update GIAOVIEN set MABM='BMAT' where MAGV='005'
update GIAOVIEN set MABM='ATDL' where MAGV='006'
update GIAOVIEN set MABM='VT01' where MAGV='007'
update GIAOVIEN set MABM='MANG' where MAGV='008'
update GIAOVIEN set MABM='AI01' where MAGV='009'
update GIAOVIEN set MABM='CNPM' where MAGV='010'
go

-- INSERT TIEP VAO DETAI
insert into DETAI values ('D01', N'Hệ thống nhận diện khuôn mặt sinh viên', N'ĐHQG', 150, '2023-01-01', '2023-12-31', 'AI01', '003')
insert into DETAI values ('D02', N'Phân tích dữ liệu tuyển sinh', N'Trường', 80, '2023-03-01', '2023-10-30', 'DL01', '001')
insert into DETAI values ('D03', N'Ứng dụng Blockchain quản lý hồ sơ', N'Sở KHCN', 120, '2023-02-01', '2024-01-30', 'CDS1', '005')
insert into DETAI values ('D04', N'Giám sát tấn công mạng bằng AI', N'ĐHQG', 200, '2023-01-15', '2024-03-15', 'AT01', '007')
go

insert into CONGVIEC values ('D01',1,N'Khảo sát yêu cầu','2023-01-01','2023-02-01')
insert into CONGVIEC values ('D01',2,N'Thiết kế hệ thống','2023-02-02','2023-05-01')
insert into CONGVIEC values ('D01',3,N'Huấn luyện mô hình','2023-05-02','2023-10-01')
insert into CONGVIEC values ('D02',1,N'Thu thập dữ liệu','2023-03-01','2023-04-01')
insert into CONGVIEC values ('D02',2,N'Phân tích dữ liệu','2023-04-02','2023-08-01')
insert into CONGVIEC values ('D03',1,N'Khảo sát blockchain','2023-02-01','2023-03-15')
insert into CONGVIEC values ('D03',2,N'Phát triển hệ thống','2023-03-16','2023-10-15')
insert into CONGVIEC values ('D04',1,N'Thu thập log mạng','2023-01-15','2023-03-01')
insert into CONGVIEC values ('D04',2,N'Phân tích dữ liệu tấn công','2023-03-02','2023-09-01')
go

insert into THAMGIADT values ('003','D01',1,2.0,N'Đạt')
insert into THAMGIADT values ('009','D01',2,1.0,N'Đạt')
insert into THAMGIADT values ('001','D02',1,1.5,N'Đạt')
insert into THAMGIADT values ('002','D02',2,1.0,N'Đạt')
insert into THAMGIADT values ('005','D03',1,2.0,N'Đạt')
insert into THAMGIADT values ('006','D03',2,1.0,N'Đạt')
insert into THAMGIADT values ('007','D04',1,2.5,N'Đạt')
insert into THAMGIADT values ('008','D04',2,1.5,N'Đạt')
go

insert into GV_DT values ('001','0901111111')
insert into GV_DT values ('002','0902222222')
insert into GV_DT values ('003','0903333333')
insert into GV_DT values ('004','0904444444')
insert into GV_DT values ('005','0905555555')
insert into GV_DT values ('006','0906666666')
insert into GV_DT values ('007','0907777777')
insert into GV_DT values ('008','0908888888')
go

insert into NGUOITHAN values ('001',N'Minh','2002-01-15',N'Nam')
insert into NGUOITHAN values ('003',N'Hà','2001-05-20',N'Nữ')
insert into NGUOITHAN values ('005',N'Trang','2000-07-11',N'Nữ')
insert into NGUOITHAN values ('007',N'Long','2003-08-09',N'Nam')
go