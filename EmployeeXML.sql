USE SaiAkshay
GO


IF OBJECT_ID('tempdb..#temp') IS NOT NULL
	drop table #temp

select e.Lname, e.Fname,d.Dname,
	P.Pname, P.Pnumber, w.Hours
into #temp
from Employee e
inner join Department d on e.Dno = d.Dnumber
inner join Works_on w on e.Ssn = w.Essn
inner join Project p on w.Pno = p.Pnumber

Declare @xmldata xml

set @xmldata = (
	select Lname,Fname,Dname,
			(
			select Pname,Pnumber,Hours
			from #temp Project
			where Project.Lname = Employee.Lname and Project.Fname = Employee.Fname
			for xml auto,type,elements,ROOT('Projects')
			)
	from #temp Employee
	group by Lname,Fname,Dname
	for xml auto,elements,ROOT('Employees')
)

select @xmldata as xml_format