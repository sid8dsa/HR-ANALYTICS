select * from hr_1;
select Department,count(attrition) `Number of Attrition`from hr_1
where attrition = 'yes'
group by Department;

#KPI 1
#Average Attrition rate for all Departments
create view Dept_average as
select department,concat(round(count(attrition)/(select count(employeenumber) from hr_1)*100,2), '%') as attrtion_rate
from hr_1
where attrition = "yes"
group by department;
select * from dept_average;



#KPI 2
#Average Hourly rate of Male Research Scientist

DELIMITER //
create procedure emp_role (in input_gender varchar(20), in input_jobrole varchar(30))
begin
 select Gender,round(avg(HourlyRate),2) `Avg Hourly Rate` from hr_1
 where gender = input_gender and jobrole = input_jobrole
 group by gender;
end //
DELIMITER ;


call emp_role('male',"Research Scientist");



#KPI 3
#Attrition rate Vs Monthly income stats

select h1.department,
round(count(h1.attrition)/(select count(h1.employeenumber) from hr_1 h1)*100,2) `Attrtion rate`,
round(avg(h2.MonthlyIncome),2) average_incom from hr_1 h1 join hr_2 h2
on h1.EmployeeNumber = h2.`employee id`
where attrition = 'Yes'
group by h1.department;

create view Attrition_employeeincome as
select h1.department,
round(count(h1.attrition)/(select count(h1.employeenumber) from hr_1 h1)*100,2) `Attrtion rate`,
round(avg(h2.MonthlyIncome),2) average_income from hr_1 h1 join hr_2 h2
on h1.EmployeeNumber = h2.`employee id`
where attrition = 'Yes'
group by h1.department;

select * from attrition_employeeincome;




#KPI 4
#Average working years for each Department

select h1.department,Round(avg(h2.totalworkingyears),0) as 'Average working years' from hr_1 h1
join hr_2 h2 on h1.employeenumber = h2.`Employee ID`
group by h1.department;

Create view `Employee Age` as 
select h1.department,Round(avg(h2.totalworkingyears),0) as 'Average working years' from hr_1 h1
join hr_2 h2 on h1.employeenumber = h2.`Employee ID`
group by h1.department;

select * from `employee age`;

#KPI 5
#Job Role Vs Work life balance

select * from hr_2;
select h1.jobrole,h2.WorkLifeBalance, count(h2.WorkLifeBalance) as 'Employee_count'
from hr_1 h1 join hr_2 h2
on h1.employeenumber = h2.`Employee ID`
group by h1.jobrole,h2.WorkLifeBalance
order by h1.jobrole;

SELECT * from ( 
	select JobRole, WorkLifeBalance FROM hr_1 h1
	 JOIN hr_2 h2 ON h1.EmployeeNumber = h2.`Employee ID`
     ) a
WHERE JobRole = 'developer'  and  WorkLifeBalance ='Good';

DELIMITER //
CREATE PROCEDURE Get_Count(IN job_role VARCHAR(30), IN Work_balance VARCHAR(30), OUT Ecount INT)
BEGIN
    SELECT COUNT(*) INTO Ecount
    FROM hr_1 h1
    JOIN hr_2 h2 ON h1.EmployeeNumber = h2.`Employee ID`
    WHERE h1.JobRole = job_role AND h2.WorkLifeBalance = Work_balance;
END //
/*-- Reset DELIMITER--*/
DELIMITER ;
CALL Get_Count('developer', 'Good', @Ecount);
SELECT @Ecount;


#KPI 6
#Attrition rate Vs Year since last promotion relation

select * from  hr_2;

select h2.`YearsSinceLastPromotion`,concat(round(count(case when h1.Attrition = 'Yes' then 1 end )*100/count(*),2), '%')  as attrtion_rate
from hr_1 h1 join hr_2 h2 on h1.employeenumber = h2.`employee id`
group by 1
order by 1;


select h2.`YearsSinceLastPromotion`,concat(round(count(case when h1.Attrition = 'Yes' then 1 end )*100/count(*),2), '%')  as attrtion_rate
from hr_1 h1 join hr_2 h2 on h1.employeenumber = h2.`employee id`
group by 1
order by 1;
