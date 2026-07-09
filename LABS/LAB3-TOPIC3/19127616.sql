
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
select g.HOTEN, g.LUONG * 1.1 as LUONG_DA_TANG_10_PHAN_TRAM
from GIAOVIEN g;

-- Q3. Retrieve the IDs of teachers whose names start with "Nguyễn" and whose salaries are above $2000, or who are department heads appointed after 1995.
select g.MAGV
from GIAOVIEN g
where (g.HOTEN like N'Nguyễn%' and g.LUONG > 2000)
   or g.MAGV in (select b.TRUONGBM from BOMON b where year(b.NGAYNHANCHUC) > 1995);

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
select b.*, g.*
from BOMON b
join GIAOVIEN g on b.TRUONGBM = g.MAGV;

-- Q6. For each teacher, retrieve information about the department in which they work.
select g.*, b.*
from GIAOVIEN g
join BOMON b on g.MABM = b.MABM;

-- Q7. Retrieve the project names and the teachers who are in charge of those projects.
select d.TENDT, g.HOTEN
from DETAI d
join GIAOVIEN g on d.GVCNDT = g.MAGV;

-- Q8. For each faculty, retrieve information about the head of the faculty.
select k.*, g.*
from KHOA k
join GIAOVIEN g on k.TRUONGKHOA = g.MAGV;

-- Q9. Retrieve teachers from the "Vi sinh" department who participate in project 006.
select distinct g.*
from GIAOVIEN g
join BOMON b on g.MABM = b.MABM
join THAMGIADT t on g.MAGV = t.MAGV
where b.TENBM = N'Vi sinh' and t.MADT = '006';

-- Q10. For projects managed at the "Thành phố" level, retrieve the project ID, the topic to which the project belongs, and the full name, date of birth, and address of the project leader.
select d.MADT, c.TENCD, g.HOTEN, g.NGSINH, g.DIACHI
from DETAI d
join CHUDE c on d.MACD = c.MACD
join GIAOVIEN g on d.GVCNDT = g.MAGV
where d.CAPQL = N'Thành phố';

-- Q11. Retrieve the full names of teachers who are directly supervised by "Nguyễn Thanh Tùng".
select g.HOTEN
from GIAOVIEN g
join GIAOVIEN ql on g.GVQLCM = ql.MAGV
where ql.HOTEN = N'Nguyễn Thanh Tùng';

-- Q12. Retrieve the name of the teacher who is the head of the "Hệ thống thông tin" department.
select g.HOTEN
from GIAOVIEN g
join BOMON b on b.TRUONGBM = g.MAGV
where b.TENBM = N'Hệ thống thông tin';

-- Q13. Retrieve the names of project leaders for projects under the "Quản lý giáo dục" topic.
select distinct g.HOTEN
from GIAOVIEN g
join DETAI d on d.GVCNDT = g.MAGV
join CHUDE c on d.MACD = c.MACD
where c.TENCD = N'Quản lý giáo dục';

-- Q14. Retrieve the names of tasks of the project "HTTT quản lý các trường ĐH" that started in March 2008.
select cv.TENCV
from CONGVIEC cv
join DETAI d on cv.MADT = d.MADT
where d.TENDT = N'HTTT quản lý các trường ĐH'
  and year(cv.NGAYBD) = 2008 and month(cv.NGAYBD) = 3;

-- Q15. Retrieve the teacher's name and the name of their academic supervisor.
select g.HOTEN as TEN_GV, ql.HOTEN as TEN_NGUOI_QUANLY
from GIAOVIEN g
left join GIAOVIEN ql on g.GVQLCM = ql.MAGV;

-- Q16. Retrieve tasks that started between January 1, 2007 and August 1, 2007.
select *
from CONGVIEC
where NGAYBD between '2007-01-01' and '2007-08-01';

-- Q17. Retrieve the full names of teachers who work in the same department as the teacher "Trần Trà Hương".
select g.HOTEN
from GIAOVIEN g
where g.MABM = (select MABM from GIAOVIEN where HOTEN = N'Trần Trà Hương')
  and g.HOTEN <> N'Trần Trà Hương';

-- Q18. Retrieve teachers who are both department heads and project leaders.
select *
from GIAOVIEN
where MAGV in (select TRUONGBM from BOMON where TRUONGBM is not null)
  and MAGV in (select GVCNDT from DETAI where GVCNDT is not null);

-- Q19. Retrieve the names of teachers who are both faculty heads and department heads.
select HOTEN
from GIAOVIEN
where MAGV in (select TRUONGKHOA from KHOA where TRUONGKHOA is not null)
  and MAGV in (select TRUONGBM from BOMON where TRUONGBM is not null);

-- Q20. Retrieve the names of department heads who are also project leaders.
select HOTEN
from GIAOVIEN
where MAGV in (select TRUONGBM from BOMON where TRUONGBM is not null)
  and MAGV in (select GVCNDT from DETAI where GVCNDT is not null);

-- Q21. Retrieve the IDs of faculty heads who are project leaders.
select MAGV
from GIAOVIEN
where MAGV in (select TRUONGKHOA from KHOA where TRUONGKHOA is not null)
  and MAGV in (select GVCNDT from DETAI where GVCNDT is not null);

-- Q22. Retrieve the IDs of teachers who belong to the "HTTT" department or who participate in project "001".
select MAGV
from GIAOVIEN
where MABM = N'HTTT'
union
select MAGV
from THAMGIADT
where MADT = '001';

-- Q23. Retrieve teachers who work in the same department as teacher 002.
select *
from GIAOVIEN
where MABM = (select MABM from GIAOVIEN where MAGV = '002')
  and MAGV <> '002';

-- Q24. Retrieve teachers who are department heads.
select *
from GIAOVIEN
where MAGV in (select TRUONGBM from BOMON where TRUONGBM is not null);

-- Q25. Retrieve the full names and salaries of teachers.
select HOTEN, LUONG
from GIAOVIEN;
