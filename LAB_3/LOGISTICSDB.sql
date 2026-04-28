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


DROP TABLE Shipments
DROP TABLE Warehouses
