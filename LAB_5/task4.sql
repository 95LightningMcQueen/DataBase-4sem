USE master


GO
CREATE PROCEDURE RestoreMyDatabase
    @NameOfDB NVARCHAR(100),
    @PathToBackup NVARCHAR(500)
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX)
    SET @Command = 'ALTER DATABASE [' + @NameOfDB + '] SET SINGLE_USER WITH ROLLBACK IMMEDIATE'
    EXEC sp_executesql @Command
    PRINT 'Все пользователи отключены'
    SET @Command = 'RESTORE DATABASE [' + @NameOfDB + '] FROM DISK = ''' + @PathToBackup + ''' WITH REPLACE, RECOVERY'
    EXEC sp_executesql @Command
    PRINT 'Восстановление завершено'
    IF EXISTS (SELECT name FROM sys.databases WHERE name = @NameOfDB)
    BEGIN
    SET @Command = 'ALTER DATABASE [' + @NameOfDB + '] SET SINGLE_USER WITH ROLLBACK IMMEDIATE'
    EXEC sp_executesql @Command
END

    SET @Command = 'ALTER DATABASE [' + @NameOfDB + '] SET MULTI_USER'
    EXEC sp_executesql @Command
    PRINT 'База данных снова доступна для работы'
END
GO

EXEC RestoreMyDatabase
    @NameOfDB = 'User_Actions',
    @PathToBackup = 'C:\Backups\User_Actions_2025.bak'
