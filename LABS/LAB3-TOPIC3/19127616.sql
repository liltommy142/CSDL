
-- LAB#3: TOPIC 3
-- NAME: PHÙNG QUỐC TUẤN
-- STUDENT'S ID: 19127616

use QLDT;
go

-- Q1. Retrieve the full names and salaries of female teachers.
select g.HOTEN, g.LUONG
from GIAOVIEN g
where g.PHAI = N'Nữ';

-- Q2. Retrieve the full names of teachers and their salaries after a 10% increase.
select g.HOTEN, g.LUONG * 1.1 AS LUONG_DA_TANG_10_PHAN_TRAM
from GIAOVIEN g;

-- Q3. Retrieve the IDs of teachers whose names start with “Nguyễn” and whose salaries are above $2000, or who are department heads appointed after 1995.
select g.MAGV
from GIAOVIEN g
where (g.HOTEN like N'Nguyễn%' and g.LUONG > 2000) or (g.MAGV IN (select TRUONGKHOA from KHOA where year(NGAYNHANCHUC) > 1995));

-- Q4. Retrieve the names of teachers in the Faculty of Information Technology.
select g.HOTEN
from GIAOVIEN g
where g.MABM in (
    select b.MABM
    from BOMON b
    where b.MAKHOA in (
        select k.MAKHOA
        from KHOA k
        where k.TENKHOA = N'Công nghệ thông tin'
    )
);

-- Q5. Retrieve information about departments along with information about the teachers who serve as department heads.
select k.*, g.*
from KHOA k
join GIAOVIEN g on k.TRUONGKHOA = g.MAGV;

-- Q6. For each teacher, retrieve information about the department in which they work.
select g.*, k.*
from GIAOVIEN g
join BOMON b on g.MABM = b.MABM
join KHOA k on b.MAKHOA = k.MAKHOA;

-- Q7. Retrieve the project names and the teachers who are in charge of those projects.
select d.TENDT, g.HOTEN as N'GVCN Đề Tài'
from DETAI d
join GIAOVIEN g on d.GVCNDT = g.MAGV;

-- Q8. For each faculty, retrieve information about the head of the faculty.
select k.*, g.*
from KHOA k
join GIAOVIEN g on k.TRUONGKHOA = g.MAGV;

-- Q9. Retrieve teachers from the “Vi sinh” department who participate in project 006.
select g.*
from GIAOVIEN g

select b.*
from BOMON b

select k.*
from KHOA k

select d.*
from DETAI d

select c.*
from CHUDE c
