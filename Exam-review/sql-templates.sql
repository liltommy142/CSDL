/* ============================================================================
   SQL TEMPLATE - ON TAP
   He quan tri: Microsoft SQL Server

   Cach dung:
   - Thay TEN_BANG, COT_..., DIEU_KIEN... bang ten trong de bai.
   - Chi giu lai nhung bang/cot can thiet cho cau dang lam.
   - Thu tu menh de thuong dung:
       SELECT -> FROM -> WHERE -> GROUP BY -> HAVING -> ORDER BY
   ============================================================================ */


/* ============================================================================
   1. GOM NHOM VA HAM KET HOP
   ============================================================================ */

-- 1.1. Ham ket hop tren toan bo cac dong thoa dieu kien
SELECT COUNT(*) AS SO_DONG,
       COUNT(DISTINCT COT_CAN_DEM) AS SO_GIA_TRI_KHAC_NHAU,
       SUM(COT_SO) AS TONG,
       AVG(COT_SO) AS TRUNG_BINH,
       MIN(COT_SO) AS NHO_NHAT,
       MAX(COT_SO) AS LON_NHAT
FROM TEN_BANG
WHERE DIEU_KIEN;

-- COUNT(*) dem moi dong; COUNT(COT) bo qua dong co COT = NULL.

-- 1.2. Gom nhom theo mot thuoc tinh
SELECT COT_NHOM, COUNT(*) AS SO_LUONG
FROM TEN_BANG
WHERE DIEU_KIEN
GROUP BY COT_NHOM;

-- 1.3. Gom nhom theo nhieu thuoc tinh
-- Moi cot trong SELECT neu khong nam trong ham ket hop thi phai nam trong GROUP BY.
SELECT COT_NHOM_1, COT_NHOM_2, AVG(COT_SO) AS TRUNG_BINH
FROM TEN_BANG
GROUP BY COT_NHOM_1, COT_NHOM_2;

-- 1.4. Loc dong truoc khi gom bang WHERE, loc nhom sau khi gom bang HAVING
SELECT COT_NHOM, COUNT(*) AS SO_LUONG
FROM TEN_BANG
WHERE DIEU_KIEN_TREN_TUNG_DONG
GROUP BY COT_NHOM
HAVING COUNT(*) >= GIA_TRI;

-- 1.5. Gom theo thuoc tinh mo rong
SELECT YEAR(COT_NGAY) AS NAM, COUNT(*) AS SO_LUONG
FROM TEN_BANG
GROUP BY YEAR(COT_NGAY);

-- 1.6. Van hien thi nhom khong co dong lien quan
SELECT A.MA_A, A.TEN_A, COUNT(B.MA_B) AS SO_LUONG
FROM BANG_A A LEFT JOIN BANG_B B ON B.MA_A = A.MA_A
GROUP BY A.MA_A, A.TEN_A;


/* ============================================================================
   2. TRUY VAN LONG VA PHEP CHIA
   ============================================================================ */

-- 2.1. Truy van long tra ve mot gia tri
SELECT A.*
FROM BANG_A A
WHERE A.COT_SO = (
    SELECT MAX(A2.COT_SO)
    FROM BANG_A A2
);

-- 2.2. Truy van long co tuong quan
SELECT A.*
FROM BANG_A A
WHERE A.COT_SO = (
    SELECT MAX(A2.COT_SO)
    FROM BANG_A A2
    WHERE A2.COT_NHOM = A.COT_NHOM
);

-- 2.3. Kiem tra gia tri thuoc mot tap hop: IN
SELECT A.*
FROM BANG_A A
WHERE A.MA_A IN (
    SELECT B.MA_A
    FROM BANG_B B
    WHERE DIEU_KIEN
);

-- 2.4. Ton tai it nhat mot dong thoa dieu kien: EXISTS
SELECT A.*
FROM BANG_A A
WHERE EXISTS (
    SELECT *
    FROM BANG_B B
    WHERE B.MA_A = A.MA_A
      AND DIEU_KIEN
);

-- 2.5. Khong ton tai dong nao thoa dieu kien: NOT EXISTS
SELECT A.*
FROM BANG_A A
WHERE NOT EXISTS (
    SELECT *
    FROM BANG_B B
    WHERE B.MA_A = A.MA_A
      AND DIEU_KIEN
);

-- 2.6. Lon hon tat ca / lon hon it nhat mot gia tri cua truy van con
SELECT A.*
FROM BANG_A A
WHERE A.COT_SO > ALL (
    SELECT B.COT_SO
    FROM BANG_B B
    WHERE DIEU_KIEN
);

SELECT A.*
FROM BANG_A A
WHERE A.COT_SO > ANY (
    SELECT B.COT_SO
    FROM BANG_B B
    WHERE DIEU_KIEN
);

-- 2.7. PHEP CHIA - mau NOT EXISTS long nhau
-- Tim moi A co lien he voi TAT CA B thoa DIEU_KIEN_CHON_B.
SELECT A.*
FROM BANG_A A
WHERE NOT EXISTS (
    SELECT *
    FROM BANG_B B
    WHERE DIEU_KIEN_CHON_B
      AND NOT EXISTS (
          SELECT *
          FROM BANG_LIENHE L
          WHERE L.MA_A = A.MA_A
            AND L.MA_B = B.MA_B
      )
);

-- 2.8. PHEP CHIA - mau dem
-- COUNT(DISTINCT ...) tranh dem trung quan he A-B.
SELECT A.MA_A, A.TEN_A
FROM BANG_A A JOIN BANG_LIENHE L ON L.MA_A = A.MA_A
WHERE L.MA_B IN (
    SELECT B.MA_B
    FROM BANG_B B
    WHERE DIEU_KIEN_CHON_B
)
GROUP BY A.MA_A, A.TEN_A
HAVING COUNT(DISTINCT L.MA_B) = (
    SELECT COUNT(*)
    FROM BANG_B B
    WHERE DIEU_KIEN_CHON_B
);


/* ============================================================================
   3. CAU TRUC CASE (TUONG TU SWITCH/CASE)
   SQL khong dung tu khoa SWITCH; dung CASE ... WHEN ... THEN ... ELSE ... END.
   ============================================================================ */

-- 3.1. Simple CASE: so sanh mot cot voi tung gia tri
SELECT A.MA_A,
       CASE A.COT_PHAN_LOAI
           WHEN GIA_TRI_1 THEN N'Kết quả 1'
           WHEN GIA_TRI_2 THEN N'Kết quả 2'
           ELSE N'Kết quả khác'
       END AS KET_QUA
FROM BANG_A A;

-- 3.2. Searched CASE: moi WHEN la mot dieu kien
SELECT A.MA_A,
       CASE
           WHEN A.COT_SO < MOC_1 THEN N'Thấp'
           WHEN A.COT_SO <= MOC_2 THEN N'Trung bình'
           ELSE N'Cao'
       END AS MUC
FROM BANG_A A;

-- 3.3. CASE trong WHERE
SELECT A.*
FROM BANG_A A
WHERE A.COT_SO >= CASE A.COT_PHAN_LOAI
                      WHEN GIA_TRI_1 THEN MOC_1
                      WHEN GIA_TRI_2 THEN MOC_2
                      ELSE MOC_MAC_DINH
                  END;

-- 3.4. Ket hop CASE voi ham ket hop
SELECT A.COT_NHOM,
       SUM(CASE WHEN DIEU_KIEN_1 THEN 1 ELSE 0 END) AS SO_LOAI_1,
       SUM(CASE WHEN DIEU_KIEN_2 THEN 1 ELSE 0 END) AS SO_LOAI_2
FROM BANG_A A
GROUP BY A.COT_NHOM;


/* ============================================================================
   4. CAI DAT TRIGGER
   inserted: du lieu moi cua INSERT/UPDATE.
   deleted : du lieu cu cua DELETE/UPDATE.
   Trigger SQL Server xu ly theo TAP DONG, khong duoc gia su chi co mot dong.
   ============================================================================ */

-- 4.1. Trigger kiem tra rang buoc tren mot bang
GO
CREATE TRIGGER TRG_TEN_RANG_BUOC
ON TEN_BANG
FOR INSERT, UPDATE
AS
IF UPDATE(COT_CAN_KIEM_TRA)
BEGIN
    IF EXISTS (
        SELECT *
        FROM inserted I
        WHERE DIEU_KIEN_VI_PHAM
    )
    BEGIN
        RAISERROR(N'Lỗi: dữ liệu vi phạm ràng buộc', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- 4.2. Trigger kiem tra rang buoc lien quan hai bang
-- Dat tren BANG_A khi INSERT/UPDATE BANG_A co the lam vi pham rang buoc.
GO
CREATE TRIGGER TRG_KIEM_TRA_TU_BANG_A
ON BANG_A
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT *
        FROM inserted I, BANG_B B
        WHERE I.MA_B = B.MA_B
          AND DIEU_KIEN_VI_PHAM
    )
    BEGIN
        RAISERROR(N'Lỗi: dữ liệu giữa hai bảng không hợp lệ', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- Neu UPDATE/DELETE BANG_B cung co the lam sai rang buoc, phai tao trigger phia BANG_B.
GO
CREATE TRIGGER TRG_KIEM_TRA_TU_BANG_B
ON BANG_B
FOR UPDATE, DELETE
AS
BEGIN
    IF EXISTS (
        SELECT *
        FROM deleted D, BANG_A A
        WHERE A.MA_B = D.MA_B
          AND DIEU_KIEN_VI_PHAM
    )
    BEGIN
        RAISERROR(N'Lỗi: thao tác làm vi phạm ràng buộc', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- 4.3. Trigger tu dong cap nhat cot tinh toan
GO
CREATE TRIGGER TRG_CAP_NHAT_COT_TINH
ON TEN_BANG
FOR INSERT, UPDATE
AS
IF UPDATE(COT_1) OR UPDATE(COT_2)
BEGIN
    UPDATE T
    SET T.COT_KET_QUA = T.COT_1 * T.COT_2
    FROM TEN_BANG T, inserted I
    WHERE T.COT_KHOA = I.COT_KHOA
END
GO

-- 4.4. Trigger kiem tra khi DELETE
GO
CREATE TRIGGER TRG_KIEM_TRA_XOA
ON TEN_BANG
FOR DELETE
AS
BEGIN
    IF EXISTS (
        SELECT *
        FROM deleted D
        WHERE DIEU_KIEN_KHONG_DUOC_XOA
    )
    BEGIN
        RAISERROR(N'Lỗi: không được xóa dữ liệu này', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- 4.5. Sua / xoa trigger
-- ALTER TRIGGER co phan ON ... FOR ... AS ... giong CREATE TRIGGER.
ALTER TRIGGER TRG_TEN_RANG_BUOC
ON TEN_BANG
FOR INSERT, UPDATE
AS
BEGIN
    -- Noi dung trigger moi
END
GO

DROP TRIGGER TRG_TEN_RANG_BUOC;
GO

/* Checklist khi lam trigger:
   1. Rang buoc lien quan bang nao?
   2. INSERT, DELETE hay UPDATE cot nao co the lam vi pham?
   3. Du lieu moi doc tu inserted; du lieu cu doc tu deleted.
   4. Dung EXISTS de kiem tra ca tap dong bi tac dong.
   5. Vi pham: RAISERROR roi ROLLBACK TRANSACTION.
   6. Rang buoc lien bang: kiem tra ca thao tac tu bang con va bang duoc tham chieu.
*/
