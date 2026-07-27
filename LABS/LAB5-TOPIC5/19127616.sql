
-- LAB#5: TOPIC 5
-- NAME: PHÙNG QUỐC TUẤN
-- STUDENT'S ID: 19127616

use QLDT;
go

-- Q35. Retrieve the highest salary among lecturers.
select max(LUONG) as N'Lương cao nhất'
from GIAOVIEN;

-- Q36. Retrieve teachers who have the highest salary.
select MAGV, HOTEN, LUONG
from GIAOVIEN
where LUONG = (select max(LUONG) from GIAOVIEN);

-- Q37. Retrieve the highest salary in the "HTTT" department.
select max(LUONG) as N'Lương cao nhất'
from GIAOVIEN
where MABM = N'HTTT';

-- Q38. Retrieve the name of the oldest teacher in the Information Systems department.
select HOTEN, NGSINH
from GIAOVIEN
where NGSINH = (
    select min(NGSINH) as N'Ngày sinh nhỏ nhất khoa Công nghệ thông tin'
    from GIAOVIEN g, BOMON b join khoa k on b.MAKHOA = k.MAKHOA
    where k.TENKHOA = N'Công nghệ thông tin'
);

-- Q39. Retrieve the name of the youngest teacher in the Faculty of Information Technology.
select HOTEN, NGSINH
from GIAOVIEN
where NGSINH = (
    select max(NGSINH) as N'Ngày sinh lớn nhất khoa Công nghệ thông tin'
    from GIAOVIEN g, BOMON b join khoa k on b.MAKHOA = k.MAKHOA
    where k.TENKHOA = N'Công nghệ thông tin'
);

-- Q40. Retrieve the teacher's name and the faculty name of the teacher with the highest salary.
select g.HOTEN, k.TENKHOA
from GIAOVIEN g join BOMON b on g.MABM = b.MABM
join KHOA k on b.MAKHOA = k.MAKHOA
where g.LUONG = (select max(LUONG) from GIAOVIEN);

-- Q41. Retrieve teachers who have the highest salary within their own department.
select *
from GIAOVIEN g
where g.LUONG in (
    select max(g2.LUONG)
    from GIAOVIEN g2
    group by g2.MABM
);

-- Q42. Retrieve the names of projects that the teacher "Nguyễn Hoài An" has not participated in.
select d.TENDT
from DETAI d
where d.MADT not in (
    select t.MADT
    from THAMGIADT t
    join GIAOVIEN g on t.MAGV = g.MAGV
    where g.HOTEN = N'Nguyễn Hoài An'
);

-- Q43. Same as Q42, output project name and project leader's name.
select d.TENDT, gv.HOTEN as N'Tên GVCN'
from DETAI d
left join GIAOVIEN gv on d.GVCNDT = gv.MAGV
where d.MADT not in (
    select t.MADT
    from THAMGIADT t
    join GIAOVIEN g on t.MAGV = g.MAGV
    where g.HOTEN = N'Nguyễn Hoài An'
);

-- Q44. Teachers in Faculty of Information Technology who have not participated in any project.
select g.*
from GIAOVIEN g
join BOMON b on g.MABM = b.MABM
join KHOA k on b.MAKHOA = k.MAKHOA
where k.TENKHOA = N'Công nghệ thông tin'
and g.MAGV not in (
    select MAGV
    from THAMGIADT
);

-- Q45. Teachers who do not participate in any project.
select *
from GIAOVIEN
where MAGV not in (
    select MAGV
    from THAMGIADT
);

-- Q46. Teachers whose salary is higher than "Nguyễn Hoài An".
select HOTEN, LUONG
from GIAOVIEN
where LUONG > all (
    select LUONG
    from GIAOVIEN
    where HOTEN = N'Nguyễn Hoài An'
);

-- Q47. Department heads who participate in at least one project.
select distinct g.*
from GIAOVIEN g
join BOMON b on g.MAGV = b.TRUONGBM
join THAMGIADT t on g.MAGV = t.MAGV

-- Q48. Teachers who share the same name and gender as another teacher in the same department.
select g1.*
from GIAOVIEN g1 left join GIAOVIEN g2 on g1.MABM = g2.MABM
where g1.HOTEN = g2.HOTEN and g1.PHAI = g2.PHAI and g1.MAGV <> g2.MAGV;

-- Q49. Teachers whose salary is higher than at least one teacher in "Công nghệ phần mềm".
select HOTEN, LUONG
from GIAOVIEN
where LUONG > (
    select min(LUONG)
    from GIAOVIEN g join BOMON b on g.MABM = b.MABM
    where b.TENBM = N'Công nghệ phần mềm'
);

-- Q50. Teachers whose salary is higher than all teachers in "Hệ thống thông tin".
select HOTEN, LUONG
from GIAOVIEN
where LUONG > (
    select max(LUONG)
    from GIAOVIEN g join BOMON b on g.MABM = b.MABM
    where b.TENBM = N'Hệ thống thông tin'
);

-- Q51. Faculty with the largest number of teachers.
select count(g.MAGV) as N'Số lượng giảng viên', k.MAKHOA, k.TENKHOA
from GIAOVIEN g
join BOMON b on g.MABM = b.MABM
join KHOA k on b.MAKHOA = k.MAKHOA
group by k.TENKHOA, k.MAKHOA
having count(g.MAGV) >= all (
    select count(g2.MAGV)
    from GIAOVIEN g2
    join BOMON b2 on g2.MABM = b2.MABM
    join KHOA k2 on b2.MAKHOA = k2.MAKHOA
    group by k2.MAKHOA
);

-- Q52. Teacher who leads the largest number of projects.
select count(distinct d.MADT) as N'Số đề tài chủ nhiệm', g.MAGV, g.HOTEN 
from GIAOVIEN g
join DETAI d on g.MAGV = d.GVCNDT
group by g.HOTEN, g.MAGV
having count(distinct d.MADT) >= all (
    select count(distinct MADT) as N'Số đề tài chủ nhiệm'
    from DETAI
    group by GVCNDT
)

-- Q53. Department with the largest number of teachers.
select count(g.MAGV) as N'Số lượng giảng viên', g.MABM
from GIAOVIEN g
group by g.MABM
having count(g.MAGV) >= all (
    select count(g2.MAGV)
    from GIAOVIEN g2
    group by g2.MABM
);

-- Q54. Teacher's name and department of the teacher who participates in the most projects.
select g.HOTEN, b.TENBM, count(distinct t.MADT) as N'Số đề tài tham gia'
from GIAOVIEN g
join BOMON b on g.MABM = b.MABM
join THAMGIADT t on g.MAGV = t.MAGV
group by g.HOTEN, b.TENBM
having count(distinct t.MADT) >= all (
    select count(distinct t2.MADT)
    from THAMGIADT t2
    group by t2.MAGV
);

-- Q55. Teacher in HTTT department who participates in the most projects.
select g.MAGV, g.HOTEN, count(distinct t.MADT) as N'Số đề tài tham gia'
from GIAOVIEN g
join THAMGIADT t on g.MAGV = t.MAGV
where g.MABM = 'HTTT'
group by g.MAGV, g.HOTEN
having count(distinct t.MADT) >= all (
    select count(distinct t2.MADT) as N'Số đề tài mà giáo viên thuộc bộ môn HTTT đã tham gia'
    from THAMGIADT t2 join GIAOVIEN g2 on t2.MAGV = g2.MAGV
    where g2.MABM = 'HTTT'
    group by g2.MAGV
);

-- Q56. Teacher's name and department of the teacher with the most relatives.
select g.HOTEN, b.TENBM, count(n.TEN) as N'Số người thân'
from GIAOVIEN g
join BOMON b on g.MABM = b.MABM
join NGUOITHAN n on g.MAGV = n.MAGV
group by g.HOTEN, b.TENBM
having count(n.TEN) >= all (
    select count(n2.TEN)
    from NGUOITHAN n2
    group by n2.MAGV
); 

-- Q57. Department head who leads the largest number of projects.
select g.MAGV, g.HOTEN, count(distinct d.MADT) as N'Số đề tài chủ nhiệm'
from GIAOVIEN g
join BOMON b on g.MAGV = b.TRUONGBM
join DETAI d on g.MAGV = d.GVCNDT
group by g.MAGV, g.HOTEN
having count(distinct d.MADT) >= all (
    select count(distinct d2.MADT) as N'Số đề tài mà mỗi GVCN chủ nhiệm'
    from DETAI d2 join GIAOVIEN g2 on d2.GVCNDT = g2.MAGV
    group by g2.MAGV
);