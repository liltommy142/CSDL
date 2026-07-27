
-- LAB#4: TOPIC 4
-- NAME: PHÙNG QUỐC TUẤN
-- STUDENT'S ID: 19127616

use QLDT;
go

-- Q27. Display the number of lecturers and their total salary.
select count(MAGV) as N'Số lượng giảng viên', sum(LUONG) as N'Tổng lương'
from GIAOVIEN;

-- Q28. Display the number of lecturers and the average salary for each department.
select b.MABM, count(g.MAGV) as N'Số lượng giảng viên', avg(g.LUONG) as N'Lương trung bình'
from BOMON b
left join GIAOVIEN g on g.MABM = b.MABM
group by b.MABM;

-- Q29. Display the topic name and the number of projects belonging to that topic.
select c.TENCD as N'Tên chủ đề', count(d.MADT) as N'Số lượng đề tài'
from CHUDE c
left join DETAI d on d.MACD = c.MACD
group by c.TENCD;

-- Q30. Display the lecturer name and the number of projects in which the lecturer has participated.
select g.MAGV, g.HOTEN as N'Tên giảng viên', count(distinct t.MADT) as N'Số đề tài tham gia'
from GIAOVIEN g
left join THAMGIADT t on g.MAGV = t.MAGV
group by g.MAGV, g.HOTEN;

-- Q31. Display the lecturer name and the number of projects for which the lecturer serves as the project leader.
select g.MAGV, g.HOTEN as N'Tên giảng viên', count(d.MADT) as N'Số đề tài chủ nhiệm'
from GIAOVIEN g
left join DETAI d on g.MAGV = d.GVCNDT
group by g.MAGV, g.HOTEN;

-- Q32. For each lecturer, display the lecturer name and the number of relatives of that lecturer.
select g.MAGV, g.HOTEN as N'Tên giảng viên', count(n.TEN) as N'Số người thân'
from GIAOVIEN g
left join NGUOITHAN n on g.MAGV = n.MAGV
group by g.MAGV, g.HOTEN;

-- Q33. Display the names of lecturers who have participated in three or more projects.
select g.HOTEN as N'Tên giảng viên'
from GIAOVIEN g
join THAMGIADT t on g.MAGV = t.MAGV
group by g.MAGV, g.HOTEN
having count(distinct t.MADT) >= 3;

-- Q34. Display the number of lecturers who have participated in the project "Ứng dụng hoá học xanh".
select count(distinct t.MAGV) as N'Số giảng viên'
from THAMGIADT t
join DETAI d on t.MADT = d.MADT
where d.TENDT = N'Ứng dụng hoá học xanh';