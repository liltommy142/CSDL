-- LAB#7: TOPIC 9
-- NAME: PHÙNG QUỐC TUẤN
-- STUDENT'S ID: 19127616

USE QLDT
GO

ALTER TABLE NGUOITHAN
ADD QUANHE nvarchar(10)
GO

-- 1. RÀNG BUỘC MIỀN GIÁ TRỊ

-- IC1: Phái của giáo viên chỉ có thể là Nam hoặc Nữ.
ALTER TABLE GIAOVIEN
ADD CONSTRAINT CK_GIAOVIEN_PHAI
CHECK (PHAI IN (N'Nam', N'Nữ'))
GO

-- IC2: Lương của giáo viên phải là bội số của 10.
CREATE RULE rule_LUONG_BOI_10
AS @LUONG = FLOOR(@LUONG / 10) * 10
GO

EXEC sp_bindrule 'rule_LUONG_BOI_10', 'GIAOVIEN.LUONG'
GO

-- IC3: Tuổi của giáo viên phải từ 18 đến 60.
ALTER TABLE GIAOVIEN
ADD CONSTRAINT CK_GIAOVIEN_TUOI
CHECK (
    NGSINH BETWEEN DATEADD(year, -60, CAST(GETDATE() AS date))
              AND DATEADD(year, -18, CAST(GETDATE() AS date))
)
GO

-- 2. RÀNG BUỘC TOÀN VẸN BẰNG TRIGGER

-- IC1: Tên đề tài phải duy nhất.
CREATE TRIGGER TRG_DETAI_IC1
ON DETAI
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM DETAI AS DT1
        INNER JOIN DETAI AS DT2
            ON DT2.TENDT = DT1.TENDT
           AND DT2.MADT <> DT1.MADT
        INNER JOIN inserted AS I
            ON I.MADT = DT1.MADT
        WHERE DT1.TENDT IS NOT NULL
    )
    BEGIN
        RAISERROR(N'IC1: Tên đề tài không được trùng nhau.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- IC2: Trưởng bộ môn phải sinh trước năm 1975.
CREATE TRIGGER TRG_BOMON_IC2
ON BOMON
FOR INSERT, UPDATE
AS
BEGIN
    IF UPDATE(TRUONGBM) AND EXISTS (
        SELECT 1
        FROM inserted AS I
        INNER JOIN GIAOVIEN AS GV
            ON GV.MAGV = I.TRUONGBM
        WHERE I.TRUONGBM IS NOT NULL
          AND GV.NGSINH >= '19750101'
    )
    BEGIN
        RAISERROR(N'IC2: Trưởng bộ môn phải sinh trước năm 1975.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

CREATE TRIGGER TRG_GIAOVIEN_IC2
ON GIAOVIEN
FOR UPDATE
AS
BEGIN
    IF UPDATE(NGSINH) AND EXISTS (
        SELECT 1
        FROM inserted AS I
        INNER JOIN BOMON AS BM
            ON BM.TRUONGBM = I.MAGV
        WHERE I.NGSINH >= '19750101'
    )
    BEGIN
        RAISERROR(N'IC2: Trưởng bộ môn phải sinh trước năm 1975.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- IC3: Mỗi bộ môn phải có ít nhất một giáo viên nữ.
CREATE TRIGGER TRG_GIAOVIEN_IC3
ON GIAOVIEN
FOR INSERT, UPDATE, DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted AS I
        WHERE I.MABM IS NOT NULL
          AND NOT EXISTS (
              SELECT 1
              FROM GIAOVIEN AS GV
              WHERE GV.MABM = I.MABM
                AND GV.PHAI = N'Nữ'
          )
    ) OR EXISTS (
        SELECT 1
        FROM deleted AS D
        WHERE D.MABM IS NOT NULL
          AND NOT EXISTS (
              SELECT 1
              FROM GIAOVIEN AS GV
              WHERE GV.MABM = D.MABM
                AND GV.PHAI = N'Nữ'
          )
    )
    BEGIN
        RAISERROR(N'IC3: Mỗi bộ môn phải có ít nhất một giáo viên nữ.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- IC4: Mỗi giáo viên phải có ít nhất một số điện thoại.
CREATE TRIGGER TRG_GIAOVIEN_IC4
ON GIAOVIEN
FOR INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted AS I
        WHERE NOT EXISTS (
            SELECT 1
            FROM GV_DT AS DT
            WHERE DT.MAGV = I.MAGV
        )
    )
    BEGIN
        RAISERROR(N'IC4: Mỗi giáo viên phải có ít nhất một số điện thoại.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

CREATE TRIGGER TRG_GV_DT_IC4
ON GV_DT
FOR DELETE, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM deleted AS D
        INNER JOIN GIAOVIEN AS GV
            ON GV.MAGV = D.MAGV
        WHERE NOT EXISTS (
            SELECT 1
            FROM GV_DT AS DT
            WHERE DT.MAGV = D.MAGV
        )
    )
    BEGIN
        RAISERROR(N'IC4: Mỗi giáo viên phải có ít nhất một số điện thoại.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- IC5: Mỗi giáo viên có tối đa ba số điện thoại.
CREATE TRIGGER TRG_GV_DT_IC5
ON GV_DT
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM GV_DT AS DT
        WHERE EXISTS (
            SELECT 1
            FROM inserted AS I
            WHERE I.MAGV = DT.MAGV
        )
        GROUP BY DT.MAGV
        HAVING COUNT(*) > 3
    )
    BEGIN
        RAISERROR(N'IC5: Mỗi giáo viên có tối đa ba số điện thoại.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- IC6: Mỗi bộ môn phải có ít nhất bốn giáo viên.
CREATE TRIGGER TRG_GIAOVIEN_IC6
ON GIAOVIEN
FOR INSERT, UPDATE, DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted AS I
        WHERE I.MABM IS NOT NULL
          AND NOT EXISTS (
              SELECT 1
              FROM GIAOVIEN AS GV
              WHERE GV.MABM = I.MABM
              GROUP BY GV.MABM
              HAVING COUNT(*) >= 4
          )
    ) OR EXISTS (
        SELECT 1
        FROM deleted AS D
        WHERE D.MABM IS NOT NULL
          AND NOT EXISTS (
              SELECT 1
              FROM GIAOVIEN AS GV
              WHERE GV.MABM = D.MABM
              GROUP BY GV.MABM
              HAVING COUNT(*) >= 4
          )
    )
    BEGIN
        RAISERROR(N'IC6: Mỗi bộ môn phải có ít nhất bốn giáo viên.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- IC7: Trưởng bộ môn phải là người lớn tuổi nhất trong bộ môn.
CREATE TRIGGER TRG_BOMON_IC7
ON BOMON
FOR INSERT, UPDATE
AS
BEGIN
    IF UPDATE(TRUONGBM) AND EXISTS (
        SELECT 1
        FROM inserted AS I
        INNER JOIN GIAOVIEN AS TRUONGBM
            ON TRUONGBM.MAGV = I.TRUONGBM
        WHERE I.TRUONGBM IS NOT NULL
          AND EXISTS (
              SELECT 1
              FROM GIAOVIEN AS GV
              WHERE GV.MABM = I.MABM
                AND GV.MAGV <> I.TRUONGBM
                AND GV.NGSINH < TRUONGBM.NGSINH
          )
    )
    BEGIN
        RAISERROR(N'IC7: Trưởng bộ môn phải là giáo viên lớn tuổi nhất bộ môn.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

CREATE TRIGGER TRG_GIAOVIEN_IC7
ON GIAOVIEN
FOR INSERT, UPDATE, DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted AS I
        INNER JOIN BOMON AS BM
            ON BM.MABM = I.MABM
        INNER JOIN GIAOVIEN AS TRUONGBM
            ON TRUONGBM.MAGV = BM.TRUONGBM
        WHERE BM.TRUONGBM IS NOT NULL
          AND EXISTS (
              SELECT 1
              FROM GIAOVIEN AS GV
              WHERE GV.MABM = BM.MABM
                AND GV.MAGV <> BM.TRUONGBM
                AND GV.NGSINH < TRUONGBM.NGSINH
          )
    ) OR EXISTS (
        SELECT 1
        FROM deleted AS D
        INNER JOIN BOMON AS BM
            ON BM.MABM = D.MABM
        INNER JOIN GIAOVIEN AS TRUONGBM
            ON TRUONGBM.MAGV = BM.TRUONGBM
        WHERE BM.TRUONGBM IS NOT NULL
          AND EXISTS (
              SELECT 1
              FROM GIAOVIEN AS GV
              WHERE GV.MABM = BM.MABM
                AND GV.MAGV <> BM.TRUONGBM
                AND GV.NGSINH < TRUONGBM.NGSINH
          )
    )
    BEGIN
        RAISERROR(N'IC7: Trưởng bộ môn phải là giáo viên lớn tuổi nhất bộ môn.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- IC8: Trưởng bộ môn không được đồng thời quản lý chuyên môn giáo viên khác.
CREATE TRIGGER TRG_BOMON_IC8
ON BOMON
FOR INSERT, UPDATE
AS
BEGIN
    IF UPDATE(TRUONGBM) AND EXISTS (
        SELECT 1
        FROM inserted AS I
        INNER JOIN GIAOVIEN AS GV
            ON GV.GVQLCM = I.TRUONGBM
           AND GV.MAGV <> I.TRUONGBM
        WHERE I.TRUONGBM IS NOT NULL
    )
    BEGIN
        RAISERROR(N'IC8: Trưởng bộ môn không được đồng thời quản lý chuyên môn giáo viên khác.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

CREATE TRIGGER TRG_GIAOVIEN_IC8
ON GIAOVIEN
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted AS I
        INNER JOIN BOMON AS BM
            ON BM.TRUONGBM = I.GVQLCM
        WHERE I.GVQLCM IS NOT NULL
          AND I.MAGV <> BM.TRUONGBM
    ) OR EXISTS (
        SELECT 1
        FROM inserted AS I
        INNER JOIN BOMON AS BM
            ON BM.TRUONGBM = I.MAGV
        INNER JOIN GIAOVIEN AS GV
            ON GV.GVQLCM = I.MAGV
           AND GV.MAGV <> I.MAGV
    )
    BEGIN
        RAISERROR(N'IC8: Trưởng bộ môn không được đồng thời quản lý chuyên môn giáo viên khác.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- IC9: Giáo viên và giáo viên quản lý chuyên môn phải cùng bộ môn.
CREATE TRIGGER TRG_GIAOVIEN_IC9
ON GIAOVIEN
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted AS I
        INNER JOIN GIAOVIEN AS GVQLCM
            ON GVQLCM.MAGV = I.GVQLCM
        WHERE I.GVQLCM IS NOT NULL
          AND (
              I.MABM <> GVQLCM.MABM
              OR (I.MABM IS NULL AND GVQLCM.MABM IS NOT NULL)
              OR (I.MABM IS NOT NULL AND GVQLCM.MABM IS NULL)
          )
    ) OR (UPDATE(MABM) AND EXISTS (
        SELECT 1
        FROM inserted AS I
        INNER JOIN GIAOVIEN AS GV
            ON GV.GVQLCM = I.MAGV
        WHERE GV.MAGV <> I.MAGV
          AND (
              GV.MABM <> I.MABM
              OR (GV.MABM IS NULL AND I.MABM IS NOT NULL)
              OR (GV.MABM IS NOT NULL AND I.MABM IS NULL)
          )
    ))
    BEGIN
        RAISERROR(N'IC9: Giáo viên và giáo viên quản lý chuyên môn phải cùng bộ môn.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO
-- IC10: Mỗi giáo viên chỉ có tối đa một vợ hoặc chồng.
-- IC11: Vợ hoặc chồng phải khác phái với giáo viên.
-- IC12: Con phải sinh sau giáo viên.
CREATE TRIGGER TRG_NGUOITHAN_IC10_IC12
ON NGUOITHAN
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM NGUOITHAN AS NT
        WHERE NT.QUANHE IN (N'Vợ', N'Chồng')
          AND EXISTS (
              SELECT 1
              FROM inserted AS I
              WHERE I.MAGV = NT.MAGV
          )
        GROUP BY NT.MAGV
        HAVING COUNT(*) > 1
    )
    BEGIN
        RAISERROR(N'IC10: Mỗi giáo viên chỉ có tối đa một vợ hoặc chồng.', 16, 1)
        ROLLBACK TRANSACTION
    END

    ELSE IF EXISTS (
        SELECT 1
        FROM inserted AS I
        INNER JOIN GIAOVIEN AS GV
            ON GV.MAGV = I.MAGV
        WHERE I.QUANHE IN (N'Vợ', N'Chồng')
          AND I.PHAI = GV.PHAI
    )
    BEGIN
        RAISERROR(N'IC11: Vợ hoặc chồng phải khác phái với giáo viên.', 16, 1)
        ROLLBACK TRANSACTION
    END

    ELSE IF EXISTS (
        SELECT 1
        FROM inserted AS I
        INNER JOIN GIAOVIEN AS GV
            ON GV.MAGV = I.MAGV
        WHERE I.QUANHE IN (N'Con gái', N'Con trai')
          AND I.NGSINH <= GV.NGSINH
    )
    BEGIN
        RAISERROR(N'IC12: Con phải sinh sau giáo viên.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

CREATE TRIGGER TRG_GIAOVIEN_IC11_IC12
ON GIAOVIEN
FOR UPDATE
AS
BEGIN
    IF UPDATE(PHAI) AND EXISTS (
        SELECT 1
        FROM inserted AS I
        INNER JOIN NGUOITHAN AS NT
            ON NT.MAGV = I.MAGV
        WHERE NT.QUANHE IN (N'Vợ', N'Chồng')
          AND NT.PHAI = I.PHAI
    )
    BEGIN
        RAISERROR(N'IC11: Vợ hoặc chồng phải khác phái với giáo viên.', 16, 1)
        ROLLBACK TRANSACTION
    END

    ELSE IF UPDATE(NGSINH) AND EXISTS (
        SELECT 1
        FROM inserted AS I
        INNER JOIN NGUOITHAN AS NT
            ON NT.MAGV = I.MAGV
        WHERE NT.QUANHE IN (N'Con gái', N'Con trai')
          AND NT.NGSINH <= I.NGSINH
    )
    BEGIN
        RAISERROR(N'IC12: Con phải sinh sau giáo viên.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- IC13: Mỗi giáo viên chỉ được chủ nhiệm tối đa ba đề tài.
CREATE TRIGGER TRG_DETAI_IC13
ON DETAI
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM DETAI AS DT
        WHERE DT.GVCNDT IS NOT NULL
          AND EXISTS (
              SELECT 1
              FROM inserted AS I
              WHERE I.GVCNDT = DT.GVCNDT
          )
        GROUP BY DT.GVCNDT
        HAVING COUNT(*) > 3
    )
    BEGIN
        RAISERROR(N'IC13: Mỗi giáo viên chỉ được chủ nhiệm tối đa ba đề tài.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- IC14: Mỗi đề tài phải có ít nhất một công việc.
CREATE TRIGGER TRG_DETAI_IC14
ON DETAI
FOR INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted AS I
        WHERE NOT EXISTS (
            SELECT 1
            FROM CONGVIEC AS CV
            WHERE CV.MADT = I.MADT
        )
    )
    BEGIN
        RAISERROR(N'IC14: Mỗi đề tài phải có ít nhất một công việc.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

CREATE TRIGGER TRG_CONGVIEC_IC14
ON CONGVIEC
FOR DELETE, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM deleted AS D
        INNER JOIN DETAI AS DT
            ON DT.MADT = D.MADT
        WHERE NOT EXISTS (
            SELECT 1
            FROM CONGVIEC AS CV
            WHERE CV.MADT = D.MADT
        )
    ) OR EXISTS (
        SELECT 1
        FROM inserted AS I
        INNER JOIN DETAI AS DT
            ON DT.MADT = I.MADT
        WHERE NOT EXISTS (
            SELECT 1
            FROM CONGVIEC AS CV
            WHERE CV.MADT = I.MADT
        )
    )
    BEGIN
        RAISERROR(N'IC14: Mỗi đề tài phải có ít nhất một công việc.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- IC15: Lương giáo viên phải thấp hơn lương giáo viên quản lý chuyên môn.
CREATE TRIGGER TRG_GIAOVIEN_IC15
ON GIAOVIEN
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted AS I
        INNER JOIN GIAOVIEN AS GVQLCM
            ON GVQLCM.MAGV = I.GVQLCM
        WHERE I.GVQLCM IS NOT NULL
          AND I.LUONG >= GVQLCM.LUONG
    ) OR (UPDATE(LUONG) AND EXISTS (
        SELECT 1
        FROM inserted AS I
        INNER JOIN GIAOVIEN AS GV
            ON GV.GVQLCM = I.MAGV
        WHERE GV.MAGV <> I.MAGV
          AND GV.LUONG >= I.LUONG
    ))
    BEGIN
        RAISERROR(N'IC15: Lương giáo viên phải thấp hơn lương giáo viên quản lý chuyên môn.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- IC16: Trưởng bộ môn phải có lương cao hơn mọi giáo viên trong bộ môn.
CREATE TRIGGER TRG_BOMON_IC16
ON BOMON
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted AS I
        INNER JOIN GIAOVIEN AS TRUONGBM
            ON TRUONGBM.MAGV = I.TRUONGBM
        WHERE I.TRUONGBM IS NOT NULL
          AND EXISTS (
              SELECT 1
              FROM GIAOVIEN AS GV
              WHERE GV.MABM = I.MABM
                AND GV.MAGV <> I.TRUONGBM
                AND GV.LUONG >= TRUONGBM.LUONG
          )
    )
    BEGIN
        RAISERROR(N'IC16: Trưởng bộ môn phải có lương cao nhất bộ môn.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

CREATE TRIGGER TRG_GIAOVIEN_IC16
ON GIAOVIEN
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM BOMON AS BM
        INNER JOIN GIAOVIEN AS TRUONGBM
            ON TRUONGBM.MAGV = BM.TRUONGBM
        WHERE (
              EXISTS (
                  SELECT 1
                  FROM inserted AS I
                  WHERE I.MABM = BM.MABM
                     OR I.MAGV = BM.TRUONGBM
              )
              OR EXISTS (
                  SELECT 1
                  FROM deleted AS D
                  WHERE D.MABM = BM.MABM
                     OR D.MAGV = BM.TRUONGBM
              )
          )
          AND EXISTS (
              SELECT 1
              FROM GIAOVIEN AS GV
              WHERE GV.MABM = BM.MABM
                AND GV.MAGV <> BM.TRUONGBM
                AND GV.LUONG >= TRUONGBM.LUONG
          )
    )
    BEGIN
        RAISERROR(N'IC16: Trưởng bộ môn phải có lương cao nhất bộ môn.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- IC17: Mỗi bộ môn phải có trưởng bộ môn là một giáo viên.
CREATE TRIGGER TRG_BOMON_IC17
ON BOMON
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted AS I
        WHERE I.TRUONGBM IS NULL
           OR NOT EXISTS (
               SELECT 1
               FROM GIAOVIEN AS GV
               WHERE GV.MAGV = I.TRUONGBM
           )
    )
    BEGIN
        RAISERROR(N'IC17: Mỗi bộ môn phải có một trưởng bộ môn là giáo viên.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- IC18: Mỗi giáo viên chỉ quản lý chuyên môn tối đa ba giáo viên khác.
CREATE TRIGGER TRG_GIAOVIEN_IC18
ON GIAOVIEN
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM GIAOVIEN AS GV
        WHERE GV.GVQLCM IS NOT NULL
          AND EXISTS (
              SELECT 1
              FROM inserted AS I
              WHERE I.GVQLCM = GV.GVQLCM
          )
        GROUP BY GV.GVQLCM
        HAVING COUNT(*) > 3
    )
    BEGIN
        RAISERROR(N'IC18: Mỗi giáo viên chỉ quản lý chuyên môn tối đa ba giáo viên.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- IC19: Giáo viên tham gia và chủ nhiệm đề tài phải cùng bộ môn.
CREATE TRIGGER TRG_THAMGIADT_IC19
ON THAMGIADT
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted AS I
        INNER JOIN GIAOVIEN AS GV
            ON GV.MAGV = I.MAGV
        INNER JOIN DETAI AS DT
            ON DT.MADT = I.MADT
        INNER JOIN GIAOVIEN AS GVCNDT
            ON GVCNDT.MAGV = DT.GVCNDT
        WHERE GV.MABM <> GVCNDT.MABM
           OR (GV.MABM IS NULL AND GVCNDT.MABM IS NOT NULL)
           OR (GV.MABM IS NOT NULL AND GVCNDT.MABM IS NULL)
    )
    BEGIN
        RAISERROR(N'IC19: Giáo viên tham gia và chủ nhiệm đề tài phải cùng bộ môn.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

CREATE TRIGGER TRG_DETAI_IC19
ON DETAI
FOR UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted AS I
        INNER JOIN GIAOVIEN AS GVCNDT
            ON GVCNDT.MAGV = I.GVCNDT
        INNER JOIN THAMGIADT AS TG
            ON TG.MADT = I.MADT
        INNER JOIN GIAOVIEN AS GV
            ON GV.MAGV = TG.MAGV
        WHERE GV.MABM <> GVCNDT.MABM
           OR (GV.MABM IS NULL AND GVCNDT.MABM IS NOT NULL)
           OR (GV.MABM IS NOT NULL AND GVCNDT.MABM IS NULL)
    )
    BEGIN
        RAISERROR(N'IC19: Giáo viên tham gia và chủ nhiệm đề tài phải cùng bộ môn.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

CREATE TRIGGER TRG_GIAOVIEN_IC19
ON GIAOVIEN
FOR UPDATE
AS
BEGIN
    IF UPDATE(MABM) AND EXISTS (
        SELECT 1
        FROM inserted AS I
        INNER JOIN THAMGIADT AS TG
            ON TG.MAGV = I.MAGV
        INNER JOIN DETAI AS DT
            ON DT.MADT = TG.MADT
        INNER JOIN GIAOVIEN AS GVCNDT
            ON GVCNDT.MAGV = DT.GVCNDT
        WHERE I.MABM <> GVCNDT.MABM
           OR (I.MABM IS NULL AND GVCNDT.MABM IS NOT NULL)
           OR (I.MABM IS NOT NULL AND GVCNDT.MABM IS NULL)
    ) OR (UPDATE(MABM) AND EXISTS (
        SELECT 1
        FROM inserted AS I
        INNER JOIN DETAI AS DT
            ON DT.GVCNDT = I.MAGV
        INNER JOIN THAMGIADT AS TG
            ON TG.MADT = DT.MADT
        INNER JOIN GIAOVIEN AS GV
            ON GV.MAGV = TG.MAGV
        WHERE GV.MABM <> I.MABM
           OR (GV.MABM IS NULL AND I.MABM IS NOT NULL)
           OR (GV.MABM IS NOT NULL AND I.MABM IS NULL)
    ))
    BEGIN
        RAISERROR(N'IC19: Giáo viên tham gia và chủ nhiệm đề tài phải cùng bộ môn.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO
