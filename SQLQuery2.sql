
USE TechWorldHRDB;
GO



CREATE TABLE AccessCards (
    CardID INT PRIMARY KEY,
    CardNumber VARCHAR(50) NOT NULL UNIQUE,
    EmployeeID INT UNIQUE,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
GO



CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100) NOT NULL
);
GO



CREATE TABLE EmployeeProjects (
    EmployeeID INT,
    ProjectID INT,
    AssignedDate DATE,

    PRIMARY KEY (EmployeeID, ProjectID),

    FOREIGN KEY (EmployeeID)
    REFERENCES Employees(EmployeeID),

    FOREIGN KEY (ProjectID)
    REFERENCES Projects(ProjectID)
);
GO



INSERT INTO AccessCards
VALUES
(101, 'CARD101', 1),
(102, 'CARD102', 2),
(103, 'CARD103', 3);
GO


/* Insert Projects */

INSERT INTO Projects
VALUES
(1, 'AI & Security Training'),
(2, 'Cloud Migration');
GO



INSERT INTO EmployeeProjects
VALUES
(1, 1, '2026-10-01'),
(1, 2, '2026-10-02'),
(2, 1, '2026-10-03'),
(3, 2, '2026-10-04');
GO




SELECT
    Employees.FullName,
    Employees.Salary,
    Departments.DepartmentName
FROM Employees
INNER JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID;
GO



SELECT
    Departments.DepartmentName,
    Employees.FullName
FROM Departments
LEFT JOIN Employees
ON Departments.DepartmentID = Employees.DepartmentID;
GO



SELECT
    Employees.FullName,
    AccessCards.CardNumber
FROM Employees
INNER JOIN AccessCards
ON Employees.EmployeeID = AccessCards.EmployeeID;
GO



SELECT
    Employees.FullName,
    Projects.ProjectName,
    EmployeeProjects.AssignedDate
FROM Employees
INNER JOIN EmployeeProjects
ON Employees.EmployeeID = EmployeeProjects.EmployeeID
INNER JOIN Projects
ON EmployeeProjects.ProjectID = Projects.ProjectID;
GO





SELECT
    DepartmentID,
    SUM(Salary) AS TotalSalary,
    COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentID;
GO



SELECT
    DepartmentID,
    AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY DepartmentID
HAVING AVG(Salary) > 1000.00;
GO



SELECT *
FROM Employees
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Employees
);
GO



CREATE VIEW vw_EmployeeDetails AS
SELECT
    Employees.EmployeeID,
    Employees.FullName,
    Employees.Email,
    Departments.DepartmentName
FROM Employees
INNER JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID;
GO



SELECT *
FROM vw_EmployeeDetails;
GO



CREATE PROCEDURE sp_GetEmployeesByDepartment
    @DeptID INT
AS
BEGIN
    SELECT *
    FROM Employees
    WHERE DepartmentID = @DeptID;
END;
GO



EXEC sp_GetEmployeesByDepartment @DeptID = 1;
GO



CREATE TABLE EmployeeAudit (
    AuditID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT,
    Action VARCHAR(50),
    ActionDate DATETIME
);
GO



CREATE TRIGGER trg_EmployeeDelete
ON Employees
AFTER DELETE
AS
BEGIN
    INSERT INTO EmployeeAudit
    (EmployeeID, Action, ActionDate)

    SELECT
        EmployeeID,
        'DELETE',
        GETDATE()
    FROM deleted;
END;
GO



SELECT *
FROM EmployeeAudit;
GO

