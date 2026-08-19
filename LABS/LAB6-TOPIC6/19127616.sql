
-- LAB#6: TOPIC 6
-- NAME: PHÙNG QUỐC TUẤN
-- STUDENT'S ID: 19127616

use QLDT;
go

-- Q58. Teachers who participate in projects covering every topic.
-- Q58 - NOT EXISTS
SELECT G.MAGV, G.HOTEN
FROM GIAOVIEN G
WHERE NOT EXISTS (
    SELECT *
    FROM CHUDE
    WHERE NOT EXISTS (
        SELECT *
        FROM THAMGIADT T
        JOIN DETAI D ON D.MADT = T.MADT
        WHERE T.MAGV = G.MAGV AND D.MACD = CHUDE.MACD
    )
);

-- Q58 - EXCEPT
SELECT G.MAGV, G.HOTEN
FROM GIAOVIEN G
WHERE NOT EXISTS (
    (
        SELECT MACD
        FROM CHUDE
    )
    EXCEPT
    (
        SELECT D.MACD
        FROM THAMGIADT T
        JOIN DETAI D ON D.MADT = T.MADT
        WHERE T.MAGV = G.MAGV
    )
);

-- Q58 - COUNT
SELECT G.MAGV, G.HOTEN, COUNT(DISTINCT D.MACD) AS N'SỐ CD ĐÃ THAM GIA'
FROM GIAOVIEN G
LEFT JOIN THAMGIADT T ON G.MAGV = T.MAGV
LEFT JOIN DETAI D ON T.MADT = D.MADT
GROUP BY G.MAGV, G.HOTEN
HAVING COUNT(DISTINCT D.MACD) = (SELECT COUNT(*) FROM CHUDE);


-- Q59. Projects in which every teacher of the HTTT department participates.
-- Q59 - NOT EXISTS
SELECT dt.TENDT
FROM DETAI dt
WHERE NOT EXISTS (
    SELECT *
    FROM GIAOVIEN g
    WHERE g.MABM = N'HTTT'
    AND NOT EXISTS (
        SELECT *
        FROM THAMGIADT tg
        WHERE tg.MAGV = g.MAGV
        AND tg.MADT = dt.MADT
    )
);

-- Q59 - EXCEPT
SELECT dt.TENDT
FROM DETAI dt
WHERE NOT EXISTS (
    (
        SELECT MAGV
        FROM GIAOVIEN
        WHERE MABM = N'HTTT'
    )
    EXCEPT
    (
        SELECT MAGV
        FROM THAMGIADT
        WHERE MADT = dt.MADT
    )
);

-- Q59 - COUNT
SELECT dt.TENDT
FROM DETAI dt
JOIN THAMGIADT tg ON tg.MADT = dt.MADT
JOIN GIAOVIEN g ON g.MAGV = tg.MAGV
WHERE g.MABM = N'HTTT'
GROUP BY dt.MADT, dt.TENDT
HAVING COUNT(DISTINCT g.MAGV) = (
    SELECT COUNT(*)
    FROM GIAOVIEN
    WHERE MABM = N'HTTT'
);


-- Q60. Projects in which every teacher of the Hệ thống thông tin department participates.
-- Q60 - NOT EXISTS
SELECT dt.TENDT
FROM DETAI dt
WHERE NOT EXISTS (
    SELECT *
    FROM GIAOVIEN g
    JOIN BOMON bm ON bm.MABM = g.MABM
    WHERE bm.TENBM = N'Hệ thống thông tin'
    AND NOT EXISTS (
        SELECT *
        FROM THAMGIADT tg
        WHERE tg.MAGV = g.MAGV
        AND tg.MADT = dt.MADT
    )
);

-- Q60 - EXCEPT
SELECT dt.TENDT
FROM DETAI dt
WHERE NOT EXISTS (
    (
        SELECT g.MAGV
        FROM GIAOVIEN g
        JOIN BOMON bm ON bm.MABM = g.MABM
        WHERE bm.TENBM = N'Hệ thống thông tin'
    )
    EXCEPT
    (
        SELECT MAGV
        FROM THAMGIADT
        WHERE MADT = dt.MADT
    )
);

-- Q60 - COUNT
SELECT dt.TENDT
FROM DETAI dt
JOIN THAMGIADT tg ON tg.MADT = dt.MADT
JOIN GIAOVIEN g ON g.MAGV = tg.MAGV
JOIN BOMON bm ON bm.MABM = g.MABM
WHERE bm.TENBM = N'Hệ thống thông tin'
GROUP BY dt.MADT, dt.TENDT
HAVING COUNT(DISTINCT g.MAGV) = (
    SELECT COUNT(*)
    FROM GIAOVIEN g
    JOIN BOMON bm ON bm.MABM = g.MABM
    WHERE bm.TENBM = N'Hệ thống thông tin'
);

-- Q61. Teachers who have participated in every project of topic QLGD.
-- Q61 - NOT EXISTS
SELECT g.HOTEN
FROM GIAOVIEN g
WHERE NOT EXISTS (
    SELECT *
    FROM DETAI dt
    WHERE dt.MACD = N'QLGD'
    AND NOT EXISTS (
        SELECT *
        FROM THAMGIADT tg
        WHERE tg.MAGV = g.MAGV
        AND tg.MADT = dt.MADT
    )
);

-- Q61 - EXCEPT
SELECT DISTINCT g.HOTEN
FROM GIAOVIEN g
JOIN THAMGIADT tg ON tg.MAGV = g.MAGV
WHERE NOT EXISTS (
    (
        SELECT MADT
        FROM DETAI
        WHERE MACD = N'QLGD'
    )
    EXCEPT
    (
        SELECT MADT
        FROM THAMGIADT
        WHERE MAGV = g.MAGV
    )
);

-- Q61 - COUNT
SELECT g.HOTEN
FROM GIAOVIEN g
JOIN THAMGIADT tg ON tg.MAGV = g.MAGV
JOIN DETAI dt ON dt.MADT = tg.MADT
WHERE dt.MACD = N'QLGD'
GROUP BY g.MAGV, g.HOTEN
HAVING COUNT(DISTINCT tg.MADT) = (
    SELECT COUNT(*)
    FROM DETAI
    WHERE MACD = N'QLGD'
);


-- Q62. Teachers who participate in every project that Trần Trà Hương participates in.
-- Q62 - NOT EXISTS
SELECT g.HOTEN
FROM GIAOVIEN g
WHERE NOT EXISTS (
    SELECT *
    FROM THAMGIADT huong_tg
    JOIN GIAOVIEN huong ON huong.MAGV = huong_tg.MAGV
    WHERE huong.HOTEN = N'Trần Trà Hương'
    AND NOT EXISTS (
        SELECT *
        FROM THAMGIADT tg
        WHERE tg.MAGV = g.MAGV
        AND tg.MADT = huong_tg.MADT
    )
);

-- Q62 - EXCEPT
SELECT DISTINCT g.HOTEN
FROM GIAOVIEN g
JOIN THAMGIADT tg ON tg.MAGV = g.MAGV
WHERE NOT EXISTS (
    (
        SELECT h.MADT
        FROM THAMGIADT h
        JOIN GIAOVIEN x ON x.MAGV = h.MAGV
        WHERE x.HOTEN = N'Trần Trà Hương'
    )
    EXCEPT
    (
        SELECT MADT
        FROM THAMGIADT
        WHERE MAGV = g.MAGV
    )
);

-- Q62 - COUNT
SELECT g.HOTEN
FROM GIAOVIEN g
JOIN THAMGIADT tg ON tg.MAGV = g.MAGV
WHERE tg.MADT in (
    SELECT h.MADT
    FROM THAMGIADT h
    JOIN GIAOVIEN x ON x.MAGV = h.MAGV
    WHERE x.HOTEN = N'Trần Trà Hương'
)
GROUP BY g.MAGV, g.HOTEN
HAVING COUNT(DISTINCT tg.MADT) = (
    SELECT COUNT(DISTINCT h.MADT)
    FROM THAMGIADT h
    JOIN GIAOVIEN x ON x.MAGV = h.MAGV
    WHERE x.HOTEN = N'Trần Trà Hương'
);


-- Q63. Projects in which every teacher of the Hoá hữu cơ department participates.
-- Q63 - NOT EXISTS
SELECT dt.TENDT
FROM DETAI dt
WHERE NOT EXISTS (
    SELECT *
    FROM GIAOVIEN g
    JOIN BOMON bm ON bm.MABM = g.MABM
    WHERE bm.TENBM = N'Hoá hữu cơ'
    AND NOT EXISTS (
        SELECT *
        FROM THAMGIADT tg
        WHERE tg.MAGV = g.MAGV
        AND tg.MADT = dt.MADT
    )
);

-- Q63 - EXCEPT
SELECT dt.TENDT
FROM DETAI dt
WHERE NOT EXISTS (
    (
        SELECT g.MAGV
        FROM GIAOVIEN g
        JOIN BOMON bm ON bm.MABM = g.MABM
        WHERE bm.TENBM = N'Hoá hữu cơ'
    )
    EXCEPT
    (
        SELECT MAGV
        FROM THAMGIADT
        WHERE MADT = dt.MADT
    )
);

-- Q63 - COUNT
SELECT dt.TENDT
FROM DETAI dt
JOIN THAMGIADT tg ON tg.MADT = dt.MADT
JOIN GIAOVIEN g ON g.MAGV = tg.MAGV
JOIN BOMON bm ON bm.MABM = g.MABM
WHERE bm.TENBM = N'Hoá hữu cơ'
GROUP BY dt.MADT, dt.TENDT
HAVING COUNT(DISTINCT g.MAGV) = (
    SELECT COUNT(*)
    FROM GIAOVIEN g
    JOIN BOMON bm ON bm.MABM = g.MABM
    WHERE bm.TENBM = N'Hoá hữu cơ'
);


-- Q64. Teachers who participate in every task of project 006.
-- Q64 - NOT EXISTS
SELECT g.HOTEN
FROM GIAOVIEN g
WHERE NOT EXISTS (
    SELECT *
    FROM CONGVIEC cv
    WHERE cv.MADT = N'006'
    AND NOT EXISTS (
        SELECT *
        FROM THAMGIADT tg
        WHERE tg.MAGV = g.MAGV
        AND tg.MADT = cv.MADT
        AND tg.STT = cv.SOTT
    )
);

-- Q64 - EXCEPT
SELECT DISTINCT g.HOTEN
FROM GIAOVIEN g
JOIN THAMGIADT tg ON tg.MAGV = g.MAGV
WHERE NOT EXISTS (
    (
        SELECT SOTT
        FROM CONGVIEC
        WHERE MADT = N'006'
    )
    EXCEPT
    (
        SELECT STT
        FROM THAMGIADT
        WHERE MAGV = g.MAGV AND MADT = N'006'
    )
);

-- Q64 - COUNT
SELECT g.HOTEN
FROM GIAOVIEN g
JOIN THAMGIADT tg ON tg.MAGV = g.MAGV
WHERE tg.MADT = N'006'
GROUP BY g.MAGV, g.HOTEN
HAVING COUNT(DISTINCT tg.STT) = (
    SELECT COUNT(*)
    FROM CONGVIEC
    WHERE MADT = N'006'
);

-- Q65. Teachers who have participated in every project of topic Ứng dụng công nghệ.
-- Q65 - NOT EXISTS
SELECT g.HOTEN
FROM GIAOVIEN g
WHERE NOT EXISTS (
    SELECT *
    FROM DETAI dt
    JOIN CHUDE cd ON cd.MACD = dt.MACD
    WHERE cd.TENCD = N'Ứng dụng công nghệ'
    AND NOT EXISTS (
        SELECT *
        FROM THAMGIADT tg
        WHERE tg.MAGV = g.MAGV
        AND tg.MADT = dt.MADT
    )
);

-- Q65 - EXCEPT
SELECT DISTINCT g.HOTEN
FROM GIAOVIEN g
JOIN THAMGIADT tg ON tg.MAGV = g.MAGV
WHERE NOT EXISTS (
    (
        SELECT dt.MADT
        FROM DETAI dt
        JOIN CHUDE cd ON cd.MACD = dt.MACD
        WHERE cd.TENCD = N'Ứng dụng công nghệ'
    )
    EXCEPT
    (
        SELECT MADT
        FROM THAMGIADT
        WHERE MAGV = g.MAGV
    )
);

-- Q65 - COUNT
SELECT g.HOTEN
FROM GIAOVIEN g
JOIN THAMGIADT tg ON tg.MAGV = g.MAGV
JOIN DETAI dt ON dt.MADT = tg.MADT
JOIN CHUDE cd ON cd.MACD = dt.MACD
WHERE cd.TENCD = N'Ứng dụng công nghệ'
GROUP BY g.MAGV, g.HOTEN
HAVING COUNT(DISTINCT tg.MADT) = (
    SELECT COUNT(*)
    FROM DETAI dt
    JOIN CHUDE cd ON cd.MACD = dt.MACD
    WHERE cd.TENCD = N'Ứng dụng công nghệ'
);


-- Q66. Teachers who have participated in every project led by Trần Trà Hương.
-- Q66 - NOT EXISTS
SELECT g.HOTEN
FROM GIAOVIEN g
WHERE NOT EXISTS (
    SELECT *
    FROM DETAI dt
    JOIN GIAOVIEN huong ON huong.MAGV = dt.GVCNDT
    WHERE huong.HOTEN = N'Trần Trà Hương'
    AND NOT EXISTS (
        SELECT *
        FROM THAMGIADT tg
        WHERE tg.MAGV = g.MAGV
        AND tg.MADT = dt.MADT
    )
);

-- Q66 - EXCEPT
SELECT DISTINCT g.HOTEN
FROM GIAOVIEN g
JOIN THAMGIADT tg ON tg.MAGV = g.MAGV
WHERE NOT EXISTS (
    (
        SELECT dt.MADT
        FROM DETAI dt
        JOIN GIAOVIEN x ON x.MAGV = dt.GVCNDT
        WHERE x.HOTEN = N'Trần Trà Hương'
    )
    EXCEPT
    (
        SELECT MADT
        FROM THAMGIADT
        WHERE MAGV = g.MAGV
    )
);

-- Q66 - COUNT
SELECT g.HOTEN
FROM GIAOVIEN g
JOIN THAMGIADT tg ON tg.MAGV = g.MAGV
JOIN DETAI dt ON dt.MADT = tg.MADT
JOIN GIAOVIEN x ON x.MAGV = dt.GVCNDT
WHERE x.HOTEN = N'Trần Trà Hương'
GROUP BY g.MAGV, g.HOTEN
HAVING COUNT(DISTINCT tg.MADT) = (
    SELECT COUNT(*)
    FROM DETAI dt
    JOIN GIAOVIEN x ON x.MAGV = dt.GVCNDT
    WHERE x.HOTEN = N'Trần Trà Hương'
);

-- Q67. Projects in which every teacher of the CNTT faculty participates.
-- Q67 - NOT EXISTS
SELECT dt.TENDT
FROM DETAI dt
WHERE NOT EXISTS (
    SELECT *
    FROM GIAOVIEN g
    JOIN BOMON bm ON bm.MABM = g.MABM
    JOIN KHOA k ON k.MAKHOA = bm.MAKHOA
    WHERE k.MAKHOA = N'CNTT'
    AND NOT EXISTS (
        SELECT *
        FROM THAMGIADT tg
        WHERE tg.MAGV = g.MAGV
        AND tg.MADT = dt.MADT
    )
);

-- Q67 - EXCEPT
SELECT dt.TENDT
FROM DETAI dt
WHERE NOT EXISTS (
    (
        SELECT g.MAGV
        FROM GIAOVIEN g
        JOIN BOMON bm ON bm.MABM = g.MABM
        WHERE bm.MAKHOA = N'CNTT'
    )
    EXCEPT
    (
        SELECT MAGV
        FROM THAMGIADT
        WHERE MADT = dt.MADT
    )
);

-- Q67 - COUNT
SELECT dt.TENDT
FROM DETAI dt
JOIN THAMGIADT tg ON tg.MADT = dt.MADT
JOIN GIAOVIEN g ON g.MAGV = tg.MAGV
JOIN BOMON bm ON bm.MABM = g.MABM
WHERE bm.MAKHOA = N'CNTT'
GROUP BY dt.MADT, dt.TENDT
HAVING COUNT(DISTINCT g.MAGV) = (
    SELECT COUNT(*)
    FROM GIAOVIEN g
    JOIN BOMON bm ON bm.MABM = g.MABM
    WHERE bm.MAKHOA = N'CNTT'
);


-- Q68. Teachers who participate in every task of project Nghiên cứu tế bào gốc.
-- Q68 - NOT EXISTS
SELECT g.HOTEN
FROM GIAOVIEN g
WHERE NOT EXISTS (
    SELECT *
    FROM CONGVIEC cv
    JOIN DETAI dt ON dt.MADT = cv.MADT
    WHERE dt.TENDT = N'Nghiên cứu tế bào gốc'
    AND NOT EXISTS (
        SELECT *
        FROM THAMGIADT tg
        WHERE tg.MAGV = g.MAGV
        AND tg.MADT = cv.MADT
        AND tg.STT = cv.SOTT
    )
);

-- Q68 - EXCEPT
SELECT DISTINCT g.HOTEN
FROM GIAOVIEN g
JOIN THAMGIADT tg ON tg.MAGV = g.MAGV
WHERE NOT EXISTS (
    (
        SELECT cv.MADT, cv.SOTT
        FROM CONGVIEC cv
        JOIN DETAI dt ON dt.MADT = cv.MADT
        WHERE dt.TENDT = N'Nghiên cứu tế bào gốc'
    )
    EXCEPT
    (
        SELECT MADT, STT
        FROM THAMGIADT
        WHERE MAGV = g.MAGV
    )
);

-- Q68 - COUNT
SELECT g.HOTEN
FROM GIAOVIEN g
JOIN THAMGIADT tg ON tg.MAGV = g.MAGV
JOIN DETAI dt ON dt.MADT = tg.MADT
WHERE dt.TENDT = N'Nghiên cứu tế bào gốc'
GROUP BY g.MAGV, g.HOTEN
HAVING COUNT(DISTINCT tg.STT) = (
    SELECT COUNT(*)
    FROM CONGVIEC cv
    JOIN DETAI dt ON dt.MADT = cv.MADT
    WHERE dt.TENDT = N'Nghiên cứu tế bào gốc'
);

-- Q69. Teachers assigned to every project whose budget exceeds 100 million.
-- Q69 - NOT EXISTS
SELECT g.HOTEN
FROM GIAOVIEN g
WHERE NOT EXISTS (
    SELECT *
    FROM DETAI dt
    WHERE dt.KINHPHI > 100
    AND NOT EXISTS (
        SELECT *
        FROM THAMGIADT tg
        WHERE tg.MAGV = g.MAGV
        AND tg.MADT = dt.MADT
    )
);

-- Q69 - EXCEPT
SELECT DISTINCT g.HOTEN
FROM GIAOVIEN g
JOIN THAMGIADT tg ON tg.MAGV = g.MAGV
WHERE NOT EXISTS (
    (
        SELECT MADT
        FROM DETAI
        WHERE KINHPHI > 100
    )
    EXCEPT
    (
        SELECT MADT
        FROM THAMGIADT
        WHERE MAGV = g.MAGV
    )
);

-- Q69 - COUNT
SELECT g.HOTEN
FROM GIAOVIEN g
JOIN THAMGIADT tg ON tg.MAGV = g.MAGV
JOIN DETAI dt ON dt.MADT = tg.MADT
WHERE dt.KINHPHI > 100
GROUP BY g.MAGV, g.HOTEN
HAVING COUNT(DISTINCT tg.MADT) = (
    SELECT COUNT(*)
    FROM DETAI
    WHERE KINHPHI > 100
);


-- Q70. Projects in which every teacher of the Sinh học faculty participates.
-- Q70 - NOT EXISTS
SELECT dt.TENDT
FROM DETAI dt
WHERE NOT EXISTS (
    SELECT *
    FROM GIAOVIEN g
    JOIN BOMON bm ON bm.MABM = g.MABM
    JOIN KHOA k ON k.MAKHOA = bm.MAKHOA
    WHERE k.TENKHOA = N'Sinh học'
    AND NOT EXISTS (
        SELECT *
        FROM THAMGIADT tg
        WHERE tg.MAGV = g.MAGV
        AND tg.MADT = dt.MADT
    )
);

-- Q70 - EXCEPT
SELECT dt.TENDT
FROM DETAI dt
WHERE NOT EXISTS (
    (
        SELECT g.MAGV
        FROM GIAOVIEN g
        JOIN BOMON bm ON bm.MABM = g.MABM
        JOIN KHOA k ON k.MAKHOA = bm.MAKHOA
        WHERE k.TENKHOA = N'Sinh học'
    )
    EXCEPT
    (
        SELECT MAGV
        FROM THAMGIADT
        WHERE MADT = dt.MADT)
);

-- Q70 - COUNT
SELECT dt.TENDT
FROM DETAI dt
JOIN THAMGIADT tg ON tg.MADT = dt.MADT
JOIN GIAOVIEN g ON g.MAGV = tg.MAGV
JOIN BOMON bm ON bm.MABM = g.MABM
JOIN KHOA k ON k.MAKHOA = bm.MAKHOA
WHERE k.TENKHOA = N'Sinh học'
GROUP BY dt.MADT, dt.TENDT
HAVING COUNT(DISTINCT g.MAGV) = (
    SELECT COUNT(*)
    FROM GIAOVIEN g
    JOIN BOMON bm ON bm.MABM = g.MABM
    JOIN KHOA k ON k.MAKHOA = bm.MAKHOA
    WHERE k.TENKHOA = N'Sinh học'
);


-- Q71. ID, name, and date of birth of teachers who participate in every task of project Ứng dụng hoá học xanh.
-- Q71 - NOT EXISTS
SELECT g.MAGV, g.HOTEN, g.NGSINH
FROM GIAOVIEN g
WHERE NOT EXISTS (
    SELECT *
    FROM CONGVIEC cv
    JOIN DETAI dt ON dt.MADT = cv.MADT
    WHERE dt.TENDT = N'Ứng dụng hoá học xanh'
    AND NOT EXISTS (
        SELECT *
        FROM THAMGIADT tg
        WHERE tg.MAGV = g.MAGV
        AND tg.MADT = cv.MADT
        AND tg.STT = cv.SOTT
    )
);

-- Q71 - EXCEPT
SELECT DISTINCT g.MAGV, g.HOTEN, g.NGSINH
FROM GIAOVIEN g
JOIN THAMGIADT tg ON tg.MAGV = g.MAGV
WHERE NOT EXISTS (
    (
        SELECT cv.MADT, cv.SOTT
        FROM CONGVIEC cv
        JOIN DETAI dt ON dt.MADT = cv.MADT
        WHERE dt.TENDT = N'Ứng dụng hoá học xanh'
    )
    EXCEPT
    (
        SELECT MADT, STT
        FROM THAMGIADT
        WHERE MAGV = g.MAGV
    )
);

-- Q71 - COUNT
SELECT g.MAGV, g.HOTEN, g.NGSINH
FROM GIAOVIEN g
JOIN THAMGIADT tg ON tg.MAGV = g.MAGV
JOIN DETAI dt ON dt.MADT = tg.MADT
WHERE dt.TENDT = N'Ứng dụng hoá học xanh'
GROUP BY g.MAGV, g.HOTEN, g.NGSINH
HAVING COUNT(DISTINCT tg.STT) = (
    SELECT COUNT(*)
    FROM CONGVIEC cv
    JOIN DETAI dt ON dt.MADT = cv.MADT
    WHERE dt.TENDT = N'Ứng dụng hoá học xanh'
);


-- Q72. Teachers who participate in every project of topic Nghiên cứu phát triển.
-- Q72 - NOT EXISTS
SELECT g.MAGV, g.HOTEN, bm.TENBM, gvql.HOTEN AS N'Giáo viên quản lý chuyên môn'
FROM GIAOVIEN g
JOIN BOMON bm ON bm.MABM = g.MABM
LEFT JOIN GIAOVIEN gvql ON gvql.MAGV = g.GVQLCM
WHERE NOT EXISTS (
    SELECT *
    FROM DETAI dt
    JOIN CHUDE cd ON cd.MACD = dt.MACD
    WHERE cd.TENCD = N'Nghiên cứu phát triển'
    AND NOT EXISTS (
        SELECT *
        FROM THAMGIADT tg
        WHERE tg.MAGV = g.MAGV
        AND tg.MADT = dt.MADT
    )
);

-- Q72 - EXCEPT
SELECT DISTINCT g.MAGV, g.HOTEN, bm.TENBM, q.HOTEN AS N'Giáo viên quản lý chuyên môn'
FROM GIAOVIEN g
JOIN BOMON bm ON bm.MABM = g.MABM
LEFT JOIN GIAOVIEN q ON q.MAGV = g.GVQLCM
JOIN THAMGIADT tg ON tg.MAGV = g.MAGV
WHERE NOT EXISTS (
    (
        SELECT dt.MADT
        FROM DETAI dt
        JOIN CHUDE cd ON cd.MACD = dt.MACD
        WHERE cd.TENCD = N'Nghiên cứu phát triển'
    )
    EXCEPT
    (
        SELECT MADT
        FROM THAMGIADT
        WHERE MAGV = g.MAGV
    )
);

-- Q72 - COUNT
SELECT g.MAGV, g.HOTEN, bm.TENBM, q.HOTEN AS N'Giáo viên quản lý chuyên môn'
FROM GIAOVIEN g
JOIN BOMON bm ON bm.MABM = g.MABM
LEFT JOIN GIAOVIEN q ON q.MAGV = g.GVQLCM
JOIN THAMGIADT tg ON tg.MAGV = g.MAGV
JOIN DETAI dt ON dt.MADT = tg.MADT
JOIN CHUDE cd ON cd.MACD = dt.MACD
WHERE cd.TENCD = N'Nghiên cứu phát triển'
GROUP BY g.MAGV, g.HOTEN, bm.TENBM, q.HOTEN
HAVING COUNT(DISTINCT tg.MADT) = (
    SELECT COUNT(*)
    FROM DETAI dt
    JOIN CHUDE cd ON cd.MACD = dt.MACD
    WHERE cd.TENCD = N'Nghiên cứu phát triển'
);
