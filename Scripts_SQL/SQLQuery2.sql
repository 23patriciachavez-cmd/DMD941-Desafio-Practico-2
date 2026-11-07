
USE master;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.server_principals
    WHERE name = N'NT SERVICE\MSSQLServerOLAPService'
)
BEGIN
    CREATE LOGIN [NT SERVICE\MSSQLServerOLAPService]
    FROM WINDOWS;
END;
GO

USE AdventureWorksDW2025;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.database_principals
    WHERE name = N'NT SERVICE\MSSQLServerOLAPService'
)
BEGIN
    CREATE USER [NT SERVICE\MSSQLServerOLAPService]
    FOR LOGIN [NT SERVICE\MSSQLServerOLAPService];
END;
GO

IF IS_ROLEMEMBER(
    N'db_datareader',
    N'NT SERVICE\MSSQLServerOLAPService'
) <> 1
BEGIN
    ALTER ROLE db_datareader
    ADD MEMBER [NT SERVICE\MSSQLServerOLAPService];
END;
GO
