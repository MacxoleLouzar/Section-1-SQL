CREATE DATABASE CallLogDb;
GO

/* 1.	Create a table which contains the calls made from a centre of tele sales representatives.*/

CREATE TABLE Tele_Sales(
Id int IDENTITY(1,1) PRIMARY KEY not null,
User_extension VARCHAR(250),
Number_dialled CHAR(10),
Date_and_time smalldatetime,
Result VARCHAR(100)
);

CREATE TABLE CallResult(
R_Id int IDENTITY(1,1) PRIMARY KEY not null,
Result VARCHAR(100),

FOREIGN KEY(Result) references Tele_Sales(Result)
);

SELECT User_extension, Number_dialled, Date_and_time, Tele_Sales.Result
FROM Tele_Sales Right Join CallResults
ON Tele_Sales.Result = CallResults.Result
WHERE Id is not null;

/* 2. Write a query which returns the number of dials made by each user per day. Sort it by user then date. */

SELECT User_extension, Number_dialled,
COUNT(*) as 'number_dials'
FROM Tele_Sales
GROUP BY User_extension, Number_dialled
ORDER BY Date_and_time

/* 3. Write a query which returns the number of times each number was dialled and sort it by number descending. */

SELECT Number_dialled,
COUNT(*) as 'Number_times'
FROM Tele_Sales
GROUP by Number_dialled
ORDER by Number_times Desc 


/* 4. Write a query which returns all the fields with an additional column indicating a counter of the number of times that specific number was dialled to date. */

SELECT User_extension, Number_dialled, Date_and_time, Tele_Sales.Result,
COUNT(*) as 'Number_times'
FROM Tele_Sales Right Join CallResults
ON Tele_Sales.Result = CallResults.Result
WHERE Id is not null
GROUP by Number_dialled
ORDER by Date_and_time

/* 5. Write a query which calculates the percentage answered per user per day. Round to 1 decimal. */

SELECT User_extension, Date_and_time,
COUNT(*) AS 'Total',
(SELECT COUNT(*) FROM Tele_Sales) AS 'Total_sum'
SELECT *, CONCAT (Round(Total / Total_sum * 100, 1), '%') AS 'Total_percentage'

FROM Tele_Sales Right Join CallResults
ON Tele_Sales.Result = CallResults.Result
WHERE Result = 'Answered'

GROUP by User_extension, Date_and_time
ORDER by Total_percentage


/* 6. Write a query showing the top 10 most dialled numbers ordered in a descending order. */


SELECT Number_dialled, MAX(Number_dialled) AS Most_Dialled
FROM Tele_Sales
WHERE Most_Dialled <= 10
GROUP BY Number_dialled
ORDER BY MAX(Number_dialled) DESC 

/* 7.	Write a query highlighting all the users who have made less than 100 dials in a day. */

SELECT User_extension, Date_and_time,
COUNT(*) AS Number_Dials
FROM Tele_Sales
GROUP BY User_extension, Date_and_time
HAVING Count(*) < 100
ORDER BY User_extension, Date_and_time 

/* 8.	Show the work duration for each user per day */

Select User_extension, Date_and_time,
sum(Date_and_time) AS 'firstCall',
sum(Date_and_time) As 'LastCall',
sum (firstCall - LastCall) AS 'Duration'
FROM
( 
Date_and_time
CAST(firstCall AS smalldatetime) [Date_and_time],
CASE 
When DATEDIFF( day, firstCall, LastCall) =  0 THEN
DATEDIFF( minute, firstCall, LastCall)/60.0 THEN
ELSE
DATEDIFF( minute, firstCall,DATEDIFF( day, DATEDIFF( day, 0, firstCall, 1)) / 60.0
END Duration
)
Group By Date_and_time