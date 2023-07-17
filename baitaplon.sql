-- Tạo database --
CREATE DATABASE QuanLyKinhDoanhMayTinh 
USE QuanLyKinhDoanhMayTinh
-- Tạo bảng Nhân viên--
CREATE TABLE tblNhanVien (
	sMaNV VARCHAR(10) PRIMARY KEY ,
	sTenNV NVARCHAR(25) NOT NULL ,
	dNgaySinh DATE NOT NULL,
	sGioiTinh NVARCHAR(5) CHECK ( sGioiTinh IN ('Nam',N'Nữ') ),
	sDiaChi NVARCHAR(50) NOT NULL ,
	sSDT VARCHAR(10) NOT NULL ,
	fHSL FLOAT CHECK(fHSL>=2 AND fHSL<=10) NOT NULL,
	fLCB FLOAT NOT NULL CHECK(fLCB>0),
	dNgayVaoLam DATE NOT NULL ,
	CONSTRAINT [Ngày vào làm đủ 18 tuổi] CHECK(DATEDIFF(DAY,dNgaySinh,dNgayVaoLam)/365>=18),
	sTenDN NVARCHAR(25),
	sMatKhau NVARCHAR(15)
	);

-- Tạo bảng khách hàng--
CREATE TABLE tblKhachHang(
	sTenKH NVARCHAR(25)  NOT NULL,
	sMaKH NVARCHAR(10),
	sSDTKH VARCHAR(10) PRIMARY KEY,
	sEmail VARCHAR(50) ,
	sDiaChi NVARCHAR(50) NOT NULL	
	)
	 
-- Tạo bảng hoá đơn --
CREATE TABLE tblHoaDon(
	sMaHD VARCHAR(10) PRIMARY KEY,
	dThoigianLap DATETIME CHECK(dThoigianLap<=GETDATE()) NOT NULL,
	dThoigianThanhToan DATETIME ,
	sMaNV VARCHAR(10) REFERENCES dbo.tblNhanVien(sMaNV) ON UPDATE CASCADE ON DELETE CASCADE,
	sSDTKH VARCHAR(10) REFERENCES dbo.tblKhachHang(sSDTKH) ON UPDATE CASCADE ON DELETE CASCADE
)
ALTER TABLE tblHoaDon ADD ftongTien float
--tạo trigger ngày lập hoá đơn phải trước thời gian thanh toán
alter trigger thoigianlap_thoigianthanhtoan
on  [tblHoaDon]
for insert
as
begin
      	   declare @thoigianthanhtoan datetime ,@thoigianlap datetime
      	   select @thoigianthanhtoan=[dThoigianThanhToan] from inserted
      	   select @thoigianlap=[dThoigianLap] from [tblHoaDon]
      	   where[dThoigianThanhToan]= @thoigianthanhtoan
  end
      	if(@thoigianthanhtoan>=@thoigianlap)
      	print N'Bạn đã nhập thành công'
      	else
  begin
               	print N'Thời gian lập hoá đơn bắt buộc phải trước thời gian thanh toán'
               	rollback tran
  end


-- Tạo bảng sản phẩm--
ALTER TABLE tblSanPham(
	sMaSP VARCHAR(10) PRIMARY KEY ,
	sTenSP NVARCHAR(25) NOT NULL,
	sHangSX NVARCHAR(25) NOT NULL,
	iNamSX INT NOT NULL,
	sTenNCC VARCHAR(25) REFERENCES dbo.tblNhaCC(stenNCC) ON UPDATE CASCADE ON DELETE CASCADE,
	sDonviTinh VARCHAR(19),
	fDonGia float,
	iSoLuong int,
	);

	ALTER TABLE tblSanPham ADD fDonGia float,
	iSoLuong int;
	update tblSanPham set fDonGia = 1000000, iSoLuong =100 where sMaSP is not null
	select * from tblSanPham
-- Tạo bảng chi tiết hoá đơn --
CREATE TABLE tblChitietHoaDon(
	sMaHD VARCHAR(10) REFERENCES dbo.tblHoaDon(sMaHD) ON UPDATE CASCADE ON DELETE CASCADE,
	sMaSP VARCHAR(10) REFERENCES dbo.tblSanPham(sMaSP) ON UPDATE CASCADE ON DELETE CASCADE,
	isoLuong INT,
	fDonGia FLOAT,
	PRIMARY KEY (sMaHD, sMaSP)
	)
	
-- Tạo bảng nhà cung cấp--
CREATE TABLE tblNhaCC(
	sTenNCC VARCHAR(25) PRIMARY KEY ,
	sSDT VARCHAR(10),
	sDiaChi NVARCHAR(50)
	)

--Nhập dữ liệu vào bảng Nhân viên --
insert into tblNhanVien
	values 
	('20a100',N'Phạm Hồng Quân','1/1/2002',N'Nam',N'Thái Bình','0984524831',9,6000000,'5/20/2021', 'phamhongquan', 'quan123'),
	('20a101',N'Trần Văn Cương','8/1/2000',N'Nam',N'Lai Châu','0968597131',8,5000000,'12/1/2020', 'cuongcuong', 'cuong123'),
	('20a102',N'Nguyễn Thị Hòa','4/11/1998',N'Nữ',N'Quảng Ninh','0305986843',7,4000000,'3/18/2020', 'nguyenthihoa', 'hoa123'),
	('20a103',N'Võ Thị Hải','3/22/1996',N'Nữ',N'Phú Thọ','0983475013',6,3000000,'1/1/2021', 'vothihai', 'qhai123'),
	('20a104',N'Đào Văn Tư','8/21/2000',N'Nam',N'Tuyên Quang','0982762300',7.5,5500000,'11/21/2020', 'daovan4', 'tu234'),
	('20a105',N'Vui Như Tết','2/18/1999',N'Nữ',N'Hà Nội','0987654321',6,4000000,'2/3/2020', 'vuinhutet', 'tet123' ),
	('20a106',N'Mãi Phấn Khởi','8/12/1995',N'Nam',N'Hà Nội','037628401',7,4000000,'6/21/2019', 'maiphankhoi1', 'phankhoi123'),
	('20a107',N'Trương Vĩnh Phúc','9/13/1999',N'Nam',N'Bắc Ninh','0986275337',6,6100000,'1/23/2020', 'truongvinhphuc', 'vinhphuctuoidep'),
	('20a108',N'Hoàng Vĩnh Lộc','2/13/1998',N'Nam',N'Hòa Bình','0314567899',8,4000000,'5/27/2019', 'phucloctho', 'loc456'),
	('20a109',N'Thượng Văn Thọ','4/22/1997',N'Nam',N'Hà Nội','0985123123',7,4800000,'9/15/2019', 'thovanthuong', 'thuongtho123')

select *from tblNhanVien

--Nhập dữ liệu vào bảng khách hàng --
INSERT  INTO  tblKhachHang
	VALUES  
	(N'Lê Xuân Đức', 'kh1', '0866000240','dlx@gmail.com',N'Hà Nội'),
	(N'Vũ Thị Lan Anh', 'kh2', '0375684357','ladthw@gmail.com',N'Vĩnh Phúc'),
	(N'Phan Công Long', 'kh3', '0374031261','pcl2k2@gmail.com',N'Ba Đình'),
	(N'Lý Lâm Khải', 'kh4', '0862135113','kaiz@gmail.com',N'Tuyên Quang'),
	(N'Đặng Thị Loan', 'kh5', '0862300513','loandangthi@gmail.com',N'Hà Nội'),
	(N'Lê Đức Mạnh', 'kh6', '0867011150','manhto@gmail.com',N'Giáp Bát'),
	(N'Trần Thị Mai Linh', 'kh7', '0867170570','linh@gmail.com',N'Vĩnh Phúc'),
	(N'Nguyễn Thị Lan Anh', 'kh8', '0862808799','lanhnguyen@gmail.com',N'Vĩnh Phúc'),
	(N'Lê Mạnh Cường', 'kh9', '0865784560','htmlcss@gmail.com',N'Hai Bà Trưng'),
	(N'Nguyễn Hoạ Tình', 'kh10', '0867966612','hoatinh@gmail.com',N'Bắc Ninh')
	
	select *from tblKhachHang

-- Nhập dữ liệu bảng NHÀ CUNG CẤP --
INSERT  INTO  tblNhaCC
	VALUES 
	('Samsung','0986866868',N'Quảng Ninh'),
	('XiaoMi','0374123123',N'Hà Nội'),
	('Apple','0922383383',N'Hà Nội'),
	('Huawei','0388567567',N'Quảng Bình'),
	('Dell','0982898989',N'Bắc Giang'),
	('Acer','0934999999',N'Bắc Ninh'),
	('Razer','0982633333',N'Thanh Hóa'),
	('Asus','0976911911',N'Vĩnh Phúc'),
	('MSI','0989789789',N'Hòa Bình'),
	('LG','0376161166',N'Thái Nguyên')

	select *from tblNhaCC

-- Nhập dữ liệu bảng SẢN PHẨM --
INSERT  INTO  tblSanPham
	VALUES 
	('ss100',N'Màn hình Samsung 24 inch','Samsung',2019, 'Samsung', 'VNĐ'),
	('xm200',N'Webcam máy tính Xiaomi','Xiaomi',2020, 'XiaoMi', 'VNĐ'),
	('ap300',N'Macbook air M1','Apple',2020, 'Apple', 'VNĐ'),
	('hw400',N'Laptop Huawei D14','Huawei',2020, 'Huawei', 'VNĐ'),
	('d500',N'Bàn Phím Dell KB216','Dell',2018, 'Dell', 'VNĐ'),
	('ac600',N'Laptop Acer Nitro 5','Acer',2021, 'Acer', 'VNĐ'),
	('ra700',N'Chuột Razer V2 Pro','Razer',2019, 'Razer', 'VNĐ'),
	('as800',N'Main PC Asus ROG','Asus',2020, 'Asus', 'VNĐ'),
	('ms900',N'Ram PC G.SKILL 16GB','MSI',2021, 'MSI', 'VNĐ'),
	('lg000',N'Laptop LG Gram 14 inch','LG',2021, 'LG', 'VNĐ')

	select *from tblSanPham 

--Nhập dữ liệu bảng hoá đơn
INSERT INTO tblHoaDon VALUES
	('HD1', '2021-03-19 19:30', '2021-03-19 19:31', '20a100','0866000240'),
	('HD2', '2021-05-19 15:22', '2021-05-19 15:25', '20a101', '0375684357'),
	('HD3', '2022-03-19 16:29', '2022-03-19 16:30', '20a102', '0374031261'),
	('HD4', '2021-03-10 07:00', '2021-03-10 07:05', '20a103', '0862135113'),
	('HD5', '2021-05-12 22:00', '2021-05-12 22:00', '20a104', '0862300513'),
	('HD6', '2022-02-14 21:46', '2022-02-14 21:50', '20a105', '0867011150'),
	('HD7', '2020-06-29 22:22', '2020-06-29 22:47', '20a106', '0867170570'),
	('HD8', '2021-03-03 23:00', '2021-03-03 23:01', '20a107', '0862808799'),
	('HD9', '2022-01-02 22:23', '2022-01-02 22:24', '20a108', '0865784560'),
	('HD10', '2021-12-18 12:01', '2021-12-18 12:02', '20a109', '0867966612')
	
	select *from tblHoaDon

--Nhập dữ liệu bảng chi tiết hoá đơn
INSERT INTO tblChitietHoaDon VALUES
('HD1', 'ac600', 1, 6000000),
('HD2', 'ap300', 2, 7000000),
('HD3', 'as800', 3, 5000000),
('HD4', 'd500', 2, 2500000),
('HD5', 'hw400', 2, 4000000),
('HD6', 'lg000', 3, 5000000),
('HD7', 'ms900', 2, 5500000),
('HD8', 'ra700', 1, 5000000),
('HD9', 'ss100', 1, 4500000),
('HD10', 'xm200', 1, 5000000)
INSERT INTO tblChitietHoaDon VALUES
('HD1', 'ac300', 4, 5000000)
select *from tblChitietHoaDon

UPDATE tblHoaDon SET ftongTien = 0
CREATE TRIGGER triger_tongTien ON tblChitietHoaDon
FOR INSERT, UPDATE
AS 
BEGIN
	DECLARE @maHD varchar(10), @
	SELECT @maHD = sMaHD FROM inserted
	IF(EXISTS (SELECT *FROM tblHoaDon WHERE @maHD = sMaHD))
	BEGIN
		UPDATE tblHoaDon
		SET ftongTien = isoLuong * fDonGia
		WHERE @maHD = sMaHD
		END
	ELSE 
	BEGIN
		print N'khong ton tai '
		rollback tran
	END
END

--TẠO PROC THÊM KHÁCH HÀNG
ALTER PROC Them_KH(
@tenKH NVARCHAR(25),
@maKH NVARCHAR(10),
@sdtKH VARCHAR(10),
@emailKH VARCHAR(50),
@diaChiKH NVARCHAR(50)
)
AS
BEGIN
	IF EXISTS (select *from tblKhachHang WHERE @sdtKH = sSDTKH)
		print N'Đã tồn tại khách hàng có số điện thoại' + @sdtKH
	ELSE INSERT INTO tblKhachHang(sTenKH, sMaKH, sSDTKH, sEmail, sDiaChi)
	VALUES(@tenKH, @maKH, @sdtKH, @emailKH, @diaChiKH)
END
GO

--TẠO PROC SỬA THÔNG TIN KHÁCH HÀNG
ALTER PROC Sua_KH(
@tenKH NVARCHAR(25),
@maKH NVARCHAR(10),
@sdtKH VARCHAR(10),
@emailKH VARCHAR(50),
@diaChiKH NVARCHAR(50)
)
AS
BEGIN
	UPDATE tblKhachHang
	SET sTenKH = @tenKH, sMaKH = @maKH, sEmail = @emailKH, sDiaChi =@diaChiKH
	FROM tblKhachHang
	WHERE  sSDTKH = @sdtKH
END

ALTER proc xoaKH
@sSDTKH varchar(10)
as delete from tblKhachHang where sSDTKH = @sSDTKH
--SỬA THÔNG TIN NHÀ CUNG CẤP
ALTER PROC Sua_NCC
(
	@tenNCC VARCHAR(25),
	@sdtNCC VARCHAR(10),
	@diaChiNCC NVARCHAR(50)
)
AS
BEGIN
	UPDATE tblNhaCC
	SET @sdtNCC = sSDT
	FROM tblNhaCC
	WHERE @tenNCC = sTenNCC
END
GO
--TẠO PROC THÊM NHÀ CUNG CẤP
ALTER PROC Them_NCC(
@tenNCC VARCHAR(25),
@sdtNCC VARCHAR(10),
@diaChiNCC NVARCHAR(50)
)
AS
BEGIN
	IF EXISTS (select *from tblNhaCC WHERE @tenNCC = sTenNCC)
		print N'Đã tồn tại nhà cung cấp' + @tenNCC
	ELSE INSERT INTO tblNhaCC(sTenNCC, sSDT, sDiaChi)
	VALUES(@tenNCC, @sdtNCC, @diaChiNCC)
END
GO


alter proc ThemNV(
	@sMaNV VARCHAR(10)  ,
	@sTenNV NVARCHAR(25) ,
	@dNgaySinh DATE,
	@sGioiTinh NVARCHAR(5),
	@sDiaChi NVARCHAR(50)  ,
	@sSDT VARCHAR(10)  ,
	@fHSL FLOAT  ,
	@fLCB FLOAT ,
	@dNgayVaoLam DATE ,
	@sTenDN NVARCHAR(25),
	@sMatKhau NVARCHAR(15))
	as insert into tblNhanVien(sMaNV, sTenNV, dNgaySinh, sGioiTinh, sDiaChi, sSDT, fHSL, fLCB, dNgayVaoLam, sTenDN, sMatKhau)
	values (@sMaNV, @sTenNV, @dNgaySinh, @sGioiTinh, @sDiaChi, @sSDT, @fHSL, @fLCB, @dNgayVaoLam, @sTenDN, @sMatKhau)

create proc XoaNV
	@sMaNV VARCHAR(10)  
	as
	delete from tblNhanVien
	where sMaNV = @sMaNV
	
CREATE PROC Sua_NV(
@sMaNV VARCHAR(10)  ,
	@sTenNV NVARCHAR(25) ,
	@dNgaySinh DATE,
	@sGioiTinh NVARCHAR(5),
	@sDiaChi NVARCHAR(50)  ,
	@sSDT VARCHAR(10)  ,
	@fHSL FLOAT  ,
	@fLCB FLOAT ,
	@dNgayVaoLam DATE ,
	@sTenDN NVARCHAR(25),
	@sMatKhau NVARCHAR(15))
AS
BEGIN
	UPDATE tblNhanVien
	SET sTenNV=  @sTenNV,dNgaySinh= @dNgaySinh,sGioiTinh= @sGioiTinh,sDiaChi= @sDiaChi,sSDT= @sSDT,fHSL= @fHSL,fLCB= @fLCB,dNgayVaoLam= @dNgayVaoLam,sTenDN= @sTenDN,sMatKhau= @sMatKhau
	FROM tblNhanVien
	WHERE sMaNV = @sMaNV
END

create proc prTimkiemkhtheoten
@TenKH nvarchar(25)
as
select*from tblKhachHang
where sTenKH = @TenKH

create proc prTimkiemnvtheoten
@sTenNV nvarchar(25)
as
select*from tblNhanVien
where sTenNV=@sTenNV
go
alter proc pro_giasanphamtheomasp
@sTenSP varchar(10)
as
select*from tblSanPham
where sTenSP = @sTenSP
go
create proc pro_ThemHoaDon
	@sMaHD VARCHAR(10) ,
	@dThoigianLap DATETIME ,
	@dThoigianThanhToan DATETIME ,
	@sMaNV VARCHAR(10) ,
	@sSDTKH VARCHAR(10)
	as insert into tblHoaDon(sMaHD, dThoigianLap, dThoigianThanhToan, sMaNV, sSDTKH)
	values (@sMaHD, @dThoigianLap,  @dThoigianThanhToan,  @sMaNV,  @sSDTKH)

	--------------------------Bảng mặt hàng ----------------------

	create proc XoaSP
	@sMaSP VARCHAR(10)  
	as
	delete from tblSanPham
	where sMaSP = @sMaSP

	alter proc ThemSP
	(@sMaSP varchar(10),
	@sTenSP NVARCHAR(25) ,
	@sHangSX NVARCHAR(25),
	@iNamSX int,
	@sTenNCC VARCHAR(25)  ,
	@sDonviTinh VARCHAR(19),
	@fDonGia float,
	@iSoLuong int)
	as
	insert into tblSanPham(sMaSP, sTenSP,sHangSX,iNamSX,
	sTenNCC, sDonviTinh, fDonGia, iSoLuong)
	values (@sMaSP, @sTenSP,@sHangSX,@iNamSX,
	@sTenNCC, @sDonviTinh,@fDonGia, @iSoLuong)

	create proc SuaSP
	(@sMaSP varchar(10),
	@sTenSP NVARCHAR(25) ,
	@sHangSX NVARCHAR(25),
	@iNamSX int,
	@sTenNCC VARCHAR(25)  ,
	@sDonviTinh VARCHAR(19),
	@fDonGia float,
	@iSoLuong int)
	as
	update tblSanPham set sTenSP = @sTenSP, sHangSX = @sHangSX, iNamSX = @iNamSX, 
		sTenNCC = 	@sTenNCC, sDonviTinh = @sDonviTinh, fDonGia = @fDonGia, iSoLuong = @iSoLuong
		where sMaSP = @sMaSP
		select*from vTimKiem

	---------------------------------------------------------------------------------------------------------------------------





	-----------------------------------CHUONG TRINH PROC CHAY TU DAY-----------------------------------------------------------------
	UPDATE tblHoaDon SET ftongTien = 0
	---KHONG CHAY DUOC TRIGGER
ALTER TRIGGER triger_tongTien ON tblChitietHoaDon
FOR INSERT, UPDATE
AS 
BEGIN
	DECLARE @maHD varchar(10), @
	SELECT @maHD = sMaHD FROM inserted
	IF(EXISTS (SELECT *FROM tblHoaDon WHERE @maHD = sMaHD))
	BEGIN
		UPDATE tblHoaDon
		SET ftongTien = isoLuong * fDonGia
		WHERE @maHD = sMaHD
		END
	ELSE 
	BEGIN
		print N'khong ton tai '
		rollback tran
	END
END
--KHONG CHAY DUOC TRIGGER---
--TẠO PROC THÊM KHÁCH HÀNG
ALTER PROC Them_KH(
@tenKH NVARCHAR(25),
@maKH NVARCHAR(10),
@sdtKH VARCHAR(10),
@emailKH VARCHAR(50),
@diaChiKH NVARCHAR(50)
)
AS
BEGIN
	IF EXISTS (select *from tblKhachHang WHERE @sdtKH = sSDTKH)
		print N'Đã tồn tại khách hàng có số điện thoại' + @sdtKH
	ELSE INSERT INTO tblKhachHang(sTenKH, sMaKH, sSDTKH, sEmail, sDiaChi)
	VALUES(@tenKH, @maKH, @sdtKH, @emailKH, @diaChiKH)
END
GO

--TẠO PROC SỬA THÔNG TIN KHÁCH HÀNG
ALTER PROC Sua_KH(
@tenKH NVARCHAR(25),
@maKH NVARCHAR(10),
@sdtKH VARCHAR(10),
@emailKH VARCHAR(50),
@diaChiKH NVARCHAR(50)
)
AS
BEGIN
	UPDATE tblKhachHang
	SET sTenKH = @tenKH, sMaKH = @maKH, sEmail = @emailKH, sDiaChi =@diaChiKH
	FROM tblKhachHang
	WHERE  sSDTKH = @sdtKH
END

create proc xoaKH
@sSDTKH varchar(10)
as delete from tblKhachHang where sSDTKH = @sSDTKH
--SỬA THÔNG TIN NHÀ CUNG CẤP
ALTER PROC Sua_NCC
(
	@tenNCC VARCHAR(25),
	@sdtNCC VARCHAR(10),
	@diaChiNCC NVARCHAR(50)
)
AS
BEGIN
	UPDATE tblNhaCC
	SET @sdtNCC = sSDT
	FROM tblNhaCC
	WHERE @tenNCC = sTenNCC
END
GO
--TẠO PROC THÊM NHÀ CUNG CẤP
ALTER PROC Them_NCC(
@tenNCC VARCHAR(25),
@sdtNCC VARCHAR(10),
@diaChiNCC NVARCHAR(50)
)
AS
BEGIN
	IF EXISTS (select *from tblNhaCC WHERE @tenNCC = sTenNCC)
		print N'Đã tồn tại nhà cung cấp' + @tenNCC
	ELSE INSERT INTO tblNhaCC(sTenNCC, sSDT, sDiaChi)
	VALUES(@tenNCC, @sdtNCC, @diaChiNCC)
END
GO


ALTER proc ThemNV(
	@sMaNV VARCHAR(10)  ,
	@sTenNV NVARCHAR(25) ,
	@dNgaySinh DATE,
	@sGioiTinh NVARCHAR(5),
	@sDiaChi NVARCHAR(50)  ,
	@sSDT VARCHAR(10)  ,
	@fHSL FLOAT  ,
	@fLCB FLOAT ,
	@dNgayVaoLam DATE ,
	@sTenDN NVARCHAR(25),
	@sMatKhau NVARCHAR(15))
	as insert into tblNhanVien(sMaNV, sTenNV, dNgaySinh, sGioiTinh, sDiaChi, sSDT, fHSL, fLCB, dNgayVaoLam, sTenDN, sMatKhau)
	values (@sMaNV, @sTenNV, @dNgaySinh, @sGioiTinh, @sDiaChi, @sSDT, @fHSL, @fLCB, @dNgayVaoLam, @sTenDN, @sMatKhau)

ALTER proc XoaNV
	@sMaNV VARCHAR(10)  
	as
	delete from tblNhanVien
	where sMaNV = @sMaNV
	
ALTER PROC Sua_NV(
@sMaNV VARCHAR(10)  ,
	@sTenNV NVARCHAR(25) ,
	@dNgaySinh DATE,
	@sGioiTinh NVARCHAR(5),
	@sDiaChi NVARCHAR(50)  ,
	@sSDT VARCHAR(10)  ,
	@fHSL FLOAT  ,
	@fLCB FLOAT ,
	@dNgayVaoLam DATE ,
	@sTenDN NVARCHAR(25),
	@sMatKhau NVARCHAR(15))
AS
BEGIN
	UPDATE tblNhanVien
	SET sTenNV=  @sTenNV,dNgaySinh= @dNgaySinh,sGioiTinh= @sGioiTinh,sDiaChi= @sDiaChi,sSDT= @sSDT,fHSL= @fHSL,fLCB= @fLCB,dNgayVaoLam= @dNgayVaoLam,sTenDN= @sTenDN,sMatKhau= @sMatKhau
	FROM tblNhanVien
	WHERE sMaNV = @sMaNV
END

alter proc prTimkiemkhtheoten
@TenKH nvarchar(25)
as
select*from tblKhachHang
where sTenKH = @TenKH

[dbo].[pro_timsdtkhachhangtheoten]
ALTER PROCEDURE prTimkiemkhtheoten(@sTenKH NVARCHAR(50))
AS
BEGIN
	SELECT TOP 1 sSDTKH,sMaKH FROM tblKhachHang
	WHERE sTenKH = @sTenKH
END


alter proc prTimkiemnvtheoten
@sTenNV nvarchar(25)
as
select*from tblNhanVien
where sTenNV=@sTenNV
go

alter proc pro_giasanphamtheomasp
@sTenSP varchar(10)
as
select*from tblSanPham
where sTenSP = @sTenSP
go
[dbo].[pro_giasanphamtheomasp]

ALTER PROCEDURE  pro_giasanphamtheomasp(@sTenSP VARCHAR(50))
AS
BEGIN
	SELECT TOP 1 fDonGia,sMaSP FROM tblSanPham
	WHERE sTenSP = @sTenSP
END

alter proc pro_ThemHoaDon
	@sMaHD VARCHAR(10) ,
	@dThoigianLap DATETIME ,
	@dThoigianThanhToan DATETIME ,
	@sMaNV VARCHAR(10) ,
	@sSDTKH VARCHAR(10)
	as insert into tblHoaDon(sMaHD, dThoigianLap, dThoigianThanhToan, sMaNV, sSDTKH)
	values (@sMaHD, @dThoigianLap,  @dThoigianThanhToan,  @sMaNV,  @sSDTKH)



	alter PROCEDURE pro_ThemHoaDon(@sMaHD NVARCHAR(50),@dThoiGianLap DATETIME , @dThoiGianThanhToan DATETIME , @sMaNV NVARCHAR(50) , @sSDTKH NVARCHAR(50) )
AS
BEGIN
	INSERT INTO tblHoaDon
	VALUES (@sMaHD , @dThoiGianLap , @dThoiGianThanhToan , @sMaNV , @sSDTKH , null)
END

ALTER proc [dbo].[pro_ThemHoaDon]
	@sMaHD VARCHAR(10) ,
	@dThoigianLap DATETIME ,
	@dThoigianThanhToan DATETIME ,
	@sMaNV VARCHAR(10) ,
	@sSDTKH VARCHAR(10)
	as insert into tblHoaDon(sMaHD, dThoigianLap, dThoigianThanhToan, sMaNV, sSDTKH)
	values (@sMaHD, @dThoigianLap,  @dThoigianThanhToan,  @sMaNV,  @sSDTKH)
	--------------------------Bảng mặt hàng ----------------------

	alter proc XoaSP
	@sMaSP VARCHAR(10)  
	as
	delete from tblSanPham
	where sMaSP = @sMaSP

	create proc ThemSP
	(@sMaSP varchar(10),
	@sTenSP NVARCHAR(25) ,
	@sHangSX NVARCHAR(25),
	@iNamSX int,
	@sTenNCC VARCHAR(25)  ,
	@sDonviTinh VARCHAR(19),
	@fDonGia float,
	@iSoLuong int)
	as
	insert into tblSanPham(sMaSP, sTenSP,sHangSX,iNamSX,
	sTenNCC, sDonviTinh, fDonGia, iSoLuong)
	values (@sMaSP, @sTenSP,@sHangSX,@iNamSX,
	@sTenNCC, @sDonviTinh,@fDonGia, @iSoLuong)

	CREATE VIEW vTimKiem AS
	SELECT dbo.tblHoaDon.dThoigianLap, dbo.tblNhanVien.sMaNV, dbo.tblSanPham.sMaSP, dbo.tblSanPham.sTenSP, dbo.tblChitietHoaDon.isoLuong, dbo.tblChitietHoaDon.fDonGia, dbo.tblKhachHang.sSDTKH, dbo.tblHoaDon.sMaHD, 
                  dbo.tblHoaDon.dThoigianThanhToan
FROM     dbo.tblHoaDon INNER JOIN
                  dbo.tblChitietHoaDon ON dbo.tblHoaDon.sMaHD = dbo.tblChitietHoaDon.sMaHD AND dbo.tblHoaDon.sMaHD = dbo.tblChitietHoaDon.sMaHD AND dbo.tblHoaDon.sMaHD = dbo.tblChitietHoaDon.sMaHD INNER JOIN
                  dbo.tblNhanVien ON dbo.tblHoaDon.sMaNV = dbo.tblNhanVien.sMaNV INNER JOIN
                  dbo.tblKhachHang ON dbo.tblHoaDon.sSDTKH = dbo.tblKhachHang.sSDTKH INNER JOIN
                  dbo.tblSanPham ON dbo.tblChitietHoaDon.sMaSP = dbo.tblSanPham.sMaSP
	----

	alter proc SuaSP
	(@sMaSP varchar(10),
	@sTenSP NVARCHAR(25) ,
	@sHangSX NVARCHAR(25),
	@iNamSX int,
	@sTenNCC VARCHAR(25)  ,
	@sDonviTinh VARCHAR(19),
	@fDonGia float,
	@iSoLuong int)
	as
	update tblSanPham set sTenSP = @sTenSP, sHangSX = @sHangSX, iNamSX = @iNamSX, 
		sTenNCC = 	@sTenNCC, sDonviTinh = @sDonviTinh, fDonGia = @fDonGia, iSoLuong = @iSoLuong
		where sMaSP = @sMaSP
		select*from vTimKiem
---------CTHD--------------
create proc pro_ThemChiTietHoaDon
	@sMaHD VARCHAR(10) ,
	@sMaSP VARCHAR(10) ,
	@iSoLuong int
	as insert into tblChitietHoaDon(sMaHD, sMaSP, isoLuong)
	values (@sMaHD, @sMaSP,  @iSoLuong)

ALTER PROCEDURE [dbo].[pro_ThemChiTietHoaDon] (@sMaHD NVARCHAR(50) , @sMaSP NVARCHAR(50), @iSoLuong INT )
AS
BEGIN
	INSERT INTO tblChitietHoaDon
	VALUES (@sMaHD , @sMaSP , @iSoLuong,null)
END

ALTER proc [dbo].[pro_ThemChiTietHoaDon]
	@sMaHD VARCHAR(10) ,
	@sMaSP VARCHAR(10) ,
	@iSoLuong int,
	@fDonGia float
	as insert into tblChitietHoaDon(sMaHD, sMaSP, isoLuong, fDonGia )
	values (@sMaHD, @sMaSP,  @iSoLuong, @fDonGia)

select*from tblSanPham

create proc pro_timkiemhoadontheoma
@sMaHD varchar(10)
as
select*from tblHoaDon
where sMaHD=@sMaHD
go
SELECT * FROM tblSanPham
update tblSanPham set fDonGia = 2700000 where sMaSP like 'ms900'

alter proc tongtien 
@Tongtien float
as 
select* from tblHoaDon, tblChitietHoaDon
where @Tongtien > ftongTien 

update vTimkiem set  =  fDonGia*isoLuong
from  vTimKiem
/*
create view Thanhtien
as
select sum(tblChitietHoaDon.isoLuong*tblChitietHoaDon.fDonGia) as [Tong tien]
from tblChitietHoaDon inner join tblHoaDon
on tblChitietHoaDon.sMaHD = tblHoaDon.sMaHD
*/


create proc prTimkiemttheodongia
@Giabatdau int,
@Giaketthuc int
as
select*from vTimKiem
where fDonGia> @Giabatdau and fDonGia < @Giaketthuc

create proc prTimkiemtrongkhoangtheongay
@Ngaybatdau date,
@Ngayketthuc date
as
select*from vTimKiem
where dThoigianLap > @Ngaybatdau and dThoigianLap < @Ngayketthuc

create proc pr_timKHtheoMa 
@maKH nvarchar(25)
as select*from tblKhachHang where sMaKH=@maKH

ALTER TABLE tblNhanVien ADD sCCCD nvarchar(20)