USE SaiAkshay
GO


IF OBJECT_ID('tempdb..#temp') IS NOT NULL
	drop table #temp

select P.Pname, P.Pnumber, d.Dname, 
	e.Lname, e.Fname, w.Hours
into #temp
from Project p
inner join Department d on p.Dnum = d.Dnumber
inner join Works_on w on p.Pnumber = w.Pno
inner join Employee e on w.Essn = e.Ssn

Declare @xmldata xml

set @xmldata = (
	select Pname,Pnumber,Dname,
			(
			select Lname,Fname,Hours
			from #temp Employee
			where Project.Pnumber = Employee.Pnumber
			for xml auto,type,elements,ROOT('Employees')
			)
	from #temp Project
	group by Pname,Pnumber,Dname
	for xml auto,elements,ROOT('Projects')
)

select @xmldata as xml_format