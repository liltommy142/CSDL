USE QLDT2
GO

-- Q27. Display the number of lecturers and their total salary.
SELECT COUNT(GV.MAGV) AS 'SO LUONG GV', SUM(GV.LUONG) AS 'TONG LUONG'
FROM GIAOVIEN GV

-- Q28. Display the number of lecturers and the average salary for each department.
SELECT B.TENBM, COUNT(GV.MAGV) AS 'SOLUONG GV', AVG(GV.LUONG) AS 'TRUNG BINH LUONG'
FROM BOMON B JOIN GIAOVIEN GV ON GV.MABM = B.MABM
GROUP BY B.TENBM

-- Q29. Display the topic name and the number of projects belonging to that topic.
SELECT CD.TENCD, COUNT(D.MADT) AS 'SO LUONG DE TAI'
FROM DETAI D JOIN CHUDE CD ON D.MACD = CD.MACD
GROUP BY CD.TENCD

-- Q30. Display the lecturer name and the number of projects in which the lecturer has participated.
SELECT GV.HOTEN, COUNT(TG.MADT) AS 'SO LUONG DT THAM GIA'
FROM GIAOVIEN GV JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV
GROUP BY GV.HOTEN

-- Q31.  Display the lecturer name and the number of projects for which the lecturer serves as the project leader.
SELECT GV.HOTEN, COUNT(TG.MADT) AS 'SO DE TAI CHU NHIEM'
FROM GIAOVIEN GV
    LEFT JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV
    LEFT JOIN DETAI D ON GV.MAGV = D.GVCNDT
GROUP BY GV.HOTEN

-- Q32. For each lecturer, display the lecturer name and the number of relatives of that lecturer.
SELECT GV.HOTEN, COUNT(NT.TEN) AS 'SO LUONG NGUOI THAN'
FROM GIAOVIEN GV LEFT JOIN NGUOITHAN NT ON GV.MAGV = NT.MAGV
GROUP BY GV.HOTEN

-- Q33. Display the names of lecturers who have participated in three or more projects.
SELECT GV.HOTEN, COUNT(TG.MADT) AS 'SOLUONG DT THAMGIA'
FROM GIAOVIEN GV LEFT JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV
GROUP BY GV.HOTEN
HAVING COUNT(TG.MADT) >= 3

-- Q34. Display the number of lecturers who have participated in the project "Ứng dụng hoá học xanh”.
SELECT COUNT(GV.MAGV) AS 'SO LUONG GV THAM GIA'
FROM GIAOVIEN GV
    LEFT JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV
    LEFT JOIN DETAI D ON D.MADT = TG.MADT
WHERE D.TENDT = N'Ứng dụng hóa học xanh'