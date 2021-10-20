USE SQL4DevsDb
GO

;WITH staff_recursive_cte AS (	
	SELECT s.StaffId,
		(s.FirstName + ' ' + s.LastName) AS FullName,
		CAST(s.FirstName + ' ' + s.LastName AS VARCHAR(500)) AS EmployeeHierarchy	
	FROM dbo.Staff s
	WHERE ManagerId IS NULL

	UNION ALL

	SELECT s.StaffId,
		(s.FirstName + ' ' + s.LastName) AS FullName,
		CAST(src.EmployeeHierarchy + ', ' + s.FirstName + ' ' + s.LastName AS VARCHAR(500))
	FROM dbo.Staff s
	INNER JOIN staff_recursive_cte src ON src.StaffId = s.ManagerId
)

SELECT src.StaffId,
	src.FullName,
	src.EmployeeHierarchy
FROM staff_recursive_cte src
ORDER BY src.StaffId
OPTION (MAXRECURSION 150)
