USE LogisticsDB

CREATE TABLE Warehouses
(
    WarehouseID INT IDENTITY(1, 1) PRIMARY KEY,
    [Location] NVARCHAR(100) UNIQUE NOT NULL,
    Capacity FLOAT NOT NULL,
    ManagerContact NVARCHAR(50) NOT NULL DEFAULT 'Не назначен',
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
)

INSERT INTO Warehouses ([Location], Capacity) VALUES ('Основной склад', 1000.0)

CREATE TABLE Shipments
(
    ShipmentID INT IDENTITY(1, 1) PRIMARY KEY,
    WarehouseID INT NOT NULL,
    OrderID INT NOT NULL,
    TrackingCode NVARCHAR(50) UNIQUE NOT NULL,
    [Weight] FLOAT NOT NULL,
    DispatchDate DATETIME,
    [Status] NVARCHAR(20) NOT NULL DEFAULT 'Ожидает отправки',
    FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID)
)

GO
CREATE FUNCTION fn_GetWarehouses()
RETURNS TABLE AS
RETURN
(
    SELECT WarehouseID, [Location], Capacity, ManagerContact, CreatedDate FROM Warehouses
)
GO

GO
CREATE FUNCTION fn_GetWarehouseByLocation
(
    @SearchLocation NVARCHAR(100)
)
RETURNS TABLE AS
RETURN
(
    SELECT WarehouseID, [Location], Capacity, ManagerContact, CreatedDate FROM Warehouses WHERE [Location] = @SearchLocation
)
GO

GO
CREATE FUNCTION fn_GetShipmentsByWarehouse
(
    @TargetWarehouseID INT
)
RETURNS TABLE AS
RETURN
(
    SELECT ShipmentID, WarehouseID, OrderID, TrackingCode, [Weight], DispatchDate, [Status] FROM Shipments WHERE WarehouseID = @TargetWarehouseID
)
GO

GO
CREATE FUNCTION fn_GetShipmentByTracking
(
    @SearchTrackingCode NVARCHAR(50)
)
RETURNS TABLE AS
RETURN
(
    SELECT ShipmentID, WarehouseID, OrderID, TrackingCode, [Weight], DispatchDate, [Status] FROM Shipments WHERE TrackingCode = @SearchTrackingCode
)
GO

GO
CREATE FUNCTION fn_GetShipmentsByOrder
(
    @TargetOrderID INT
)
RETURNS TABLE AS
RETURN
(
    SELECT ShipmentID, WarehouseID, OrderID, TrackingCode, [Weight], DispatchDate, [Status] FROM Shipments WHERE OrderID = @TargetOrderID
)
GO

GO
CREATE FUNCTION fn_GetShipmentsByStatus
(
    @FilterStatus NVARCHAR(20)
)
RETURNS TABLE AS
RETURN
(
    SELECT ShipmentID, WarehouseID, OrderID, TrackingCode, [Weight], DispatchDate, [Status] FROM Shipments WHERE [Status] = @FilterStatus
)
GO

GO
CREATE FUNCTION fn_GetShipmentsByDateRange
(
    @StartDate DATETIME, 
    @EndDate DATETIME
)
RETURNS TABLE AS
RETURN
(
    SELECT ShipmentID, WarehouseID, OrderID, TrackingCode, [Weight], DispatchDate, [Status] FROM Shipments WHERE DispatchDate BETWEEN @StartDate AND @EndDate
)
GO

SELECT * FROM LogisticsDB.dbo.fn_GetWarehouses();

USE SalesDB

CREATE TABLE Customers
(
    CustomerID INT IDENTITY(1, 1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    RegistrationDate DATETIME NOT NULL DEFAULT GETDATE()
)

CREATE TABLE Orders
(
    OrderID INT IDENTITY(1, 1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderTotal FLOAT NOT NULL CHECK (OrderTotal > 0),
    OrderDate DATETIME NOT NULL DEFAULT GETDATE(),
    [Status] NVARCHAR(20) NOT NULL DEFAULT 'Новый',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
)

--2
GO
CREATE FUNCTION fn_GetCustomers()
RETURNS TABLE AS
RETURN
(
    SELECT CustomerID, FullName, Email, RegistrationDate FROM Customers
)
GO

GO
CREATE FUNCTION fn_GetCustomerByID
(
    @TargetCustomerID INT
)
RETURNS TABLE AS
RETURN
(
    SELECT CustomerID, FullName, Email, RegistrationDate FROM Customers WHERE CustomerID = @TargetCustomerID
)
GO

GO
CREATE FUNCTION fn_GetCustomerByEmail
(
    @TargetEmail NVARCHAR(100)
)
RETURNS TABLE AS
RETURN
(
    SELECT CustomerID, FullName, Email, RegistrationDate FROM Customers WHERE Email = @TargetEmail
)
GO

GO
CREATE FUNCTION fn_GetCustomersByName
(
    @SearchFullName NVARCHAR(100)
)
RETURNS TABLE AS
RETURN
(
    SELECT CustomerID, FullName, Email, RegistrationDate FROM Customers WHERE FullName LIKE '%' + @SearchFullName + '%'
)
GO

GO
CREATE FUNCTION fn_GetOrdersByStatus
(
    @FilterStatus NVARCHAR(20)
)
RETURNS TABLE AS
RETURN
(
    SELECT OrderID, CustomerID, OrderTotal, OrderDate, [Status] FROM Orders WHERE [Status] = @FilterStatus
)
GO

GO
CREATE FUNCTION fn_GetOrdersByCustomer
(
    @TargetCustomerID INT
)
RETURNS TABLE AS
RETURN
(
    SELECT OrderID, CustomerID, OrderTotal, OrderDate, [Status] FROM Orders WHERE CustomerID = @TargetCustomerID
)
GO

GO
CREATE FUNCTION fn_GetOrdersByDateRange
(
    @StartDate DATETIME, 
    @EndDate DATETIME
)
RETURNS TABLE AS
RETURN
(
    SELECT OrderID, CustomerID, OrderTotal, OrderDate, [Status] FROM Orders WHERE OrderDate BETWEEN @StartDate AND @EndDate
)
GO

GO
CREATE FUNCTION fn_GetOrdersByTotalRange
(
    @MinOrderTotal FLOAT, 
    @MaxOrderTotal FLOAT
)
RETURNS TABLE AS
RETURN
(
    SELECT OrderID, CustomerID, OrderTotal, OrderDate, [Status] FROM Orders WHERE OrderTotal BETWEEN @MinOrderTotal AND @MaxOrderTotal
)
GO

--3
GO
CREATE TRIGGER trg_Orders_CreateShipment ON Orders AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE [Status] = 'Подтвержден')
    BEGIN
        BEGIN TRY
            IF NOT EXISTS (SELECT 1 FROM LogisticsDB.dbo.Warehouses WHERE WarehouseID = 1)
            BEGIN
                RAISERROR ('Склад 1 не найден в LogisticsDB', 16, 1)
            END
            INSERT INTO LogisticsDB.dbo.Shipments (WarehouseID, OrderID, TrackingCode, [Weight], [Status])
            SELECT 
                1,
                OrderID,
                CONCAT('ID-', NEWID()),
                1,
                'Ожидает отправки'
            FROM inserted WHERE [Status] = 'Подтвержден' AND OrderID NOT IN (SELECT OrderID FROM LogisticsDB.dbo.Shipments)
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION
            RAISERROR ('Сбой при создании записи в LogisticsDB.', 16, 1)
        END CATCH
    END
END
GO


--4.1
DECLARE @CurrentCustID INT, @CurrentOrderID INT
INSERT INTO Customers (FullName, Email) VALUES ('Иван Иванов', 'ivan@chtoto.com')
SET @CurrentCustID = SCOPE_IDENTITY()
INSERT INTO Orders (CustomerID, OrderTotal) VALUES (@CurrentCustID, 500)
SET @CurrentOrderID = SCOPE_IDENTITY()

--4.2
UPDATE Orders SET [Status] = 'Подтвержден' WHERE OrderID = @CurrentOrderID
SELECT * FROM LogisticsDB.dbo.fn_GetShipmentsByOrder(@CurrentOrderID)

--4.3
BEGIN TRY
    BEGIN TRANSACTION
        INSERT INTO Orders (CustomerID, OrderTotal) VALUES (1, -100)
    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    ROLLBACK
    PRINT 'Ошибка. Сумма должна быть больше 0'
END CATCH
BEGIN TRY
    BEGIN TRANSACTION
        INSERT INTO Customers (FullName, Email) VALUES ('Другой Иван', 'ivan@chtoto.com')
    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    ROLLBACK
    PRINT 'Ошибка. Пользователь с таким Email уже существует'
END CATCH

--4.4
SELECT * FROM dbo.fn_GetCustomers()
SELECT * FROM dbo.fn_GetOrdersByStatus('Новый')

--4.5
BEGIN TRY
    BEGIN TRANSACTION
        UPDATE Orders SET OrderTotal = 999 WHERE OrderID = @CurrentOrderID
        DECLARE @fail INT = 1 / 0
    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    PRINT 'Транзакция отменена. Данные не изменились.'
END CATCH

--4.4
SELECT * FROM dbo.fn_GetCustomerByEmail('test@mail.ru')


DELETE FROM SalesDB.dbo.Orders
DELETE FROM SalesDB.dbo.Customers

  
DROP TABLE Orders
DROP TABLE Customers
DROP TABLE Shipments
DROP TABLE Warehouses
