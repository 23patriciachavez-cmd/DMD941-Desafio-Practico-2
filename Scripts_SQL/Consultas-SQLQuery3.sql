--CONSULTA DE BD
SELECT name, state_desc
FROM sys.databases
WHERE name = 'AdventureWorksDW2025';





--CONSULTA DE TABLAS
USE AdventureWorksDW2025;
GO

SELECT
    TABLE_NAME AS NombreTabla
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo'
AND TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;





--TOTAL DE REGISTROS, VENTAS Y UNIDADES
USE AdventureWorksDW2025;
GO

SELECT
    COUNT(*) AS TotalRegistros,
    SUM(SalesAmount) AS TotalVentas,
    SUM(OrderQuantity) AS TotalUnidades
FROM dbo.FactInternetSales;





--PRIMERA CONSULTA: VENTAS POR ANIO
USE AdventureWorksDW2025;
GO

SELECT
    d.CalendarYear AS Anio,
    COUNT(DISTINCT f.SalesOrderNumber) AS TotalPedidos,
    SUM(f.OrderQuantity) AS UnidadesVendidas,
    ROUND(SUM(f.SalesAmount), 2) AS VentasTotales,
    ROUND(SUM(f.TotalProductCost), 2) AS CostosTotales,
    ROUND(
        SUM(f.SalesAmount - f.TotalProductCost), 2
    ) AS MargenBrutoEstimado
FROM dbo.FactInternetSales AS f
INNER JOIN dbo.DimDate AS d
    ON f.OrderDateKey = d.DateKey
GROUP BY d.CalendarYear
ORDER BY d.CalendarYear;





--SEGUNDA CONSULTA: VENTAS POR CATEGORIAS DE PRODUCTOS 
--Categorias que generan mayores ingresos
USE AdventureWorksDW2025;
GO

SELECT
    pc.EnglishProductCategoryName AS Categoria,
    COUNT(DISTINCT f.SalesOrderNumber) AS TotalPedidos,
    SUM(f.OrderQuantity) AS UnidadesVendidas,
    ROUND(SUM(f.SalesAmount), 2) AS VentasTotales,
    ROUND(SUM(f.TotalProductCost), 2) AS CostosTotales,
    ROUND(
        SUM(f.SalesAmount - f.TotalProductCost), 2
    ) AS MargenBrutoEstimado
FROM dbo.FactInternetSales AS f
INNER JOIN dbo.DimProduct AS p
    ON f.ProductKey = p.ProductKey
INNER JOIN dbo.DimProductSubcategory AS ps
    ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
INNER JOIN dbo.DimProductCategory AS pc
    ON ps.ProductCategoryKey = pc.ProductCategoryKey
GROUP BY
    pc.EnglishProductCategoryName
ORDER BY
    VentasTotales DESC;





--TERCERA CONSULTA: VENTAS POR TERRITORIO GEOGRAFICO
--Paises y regiones que generan mas ingresos
USE AdventureWorksDW2025;
GO

SELECT
    st.SalesTerritoryCountry AS Pais,
    st.SalesTerritoryRegion AS Region,

    COUNT(DISTINCT f.SalesOrderNumber)
        AS TotalPedidos,

    SUM(f.OrderQuantity)
        AS UnidadesVendidas,

    ROUND(SUM(f.SalesAmount), 2)
        AS VentasTotales,

    ROUND(SUM(f.TotalProductCost), 2)
        AS CostosTotales,

    ROUND(
        SUM(f.SalesAmount - f.TotalProductCost), 2
    ) AS MargenBrutoEstimado

FROM dbo.FactInternetSales AS f

INNER JOIN dbo.DimSalesTerritory AS st
    ON f.SalesTerritoryKey = st.SalesTerritoryKey

GROUP BY
    st.SalesTerritoryCountry,
    st.SalesTerritoryRegion

ORDER BY
    VentasTotales DESC;





--CUARTA CONSULTA: TOP 10 PRODUCTOS CON MAYORES VENTAS
USE AdventureWorksDW2025;
GO

SELECT TOP 10
    p.EnglishProductName AS Producto,

    SUM(f.OrderQuantity) AS UnidadesVendidas,

    COUNT(DISTINCT f.SalesOrderNumber)
        AS TotalPedidos,

    ROUND(SUM(f.SalesAmount), 2)
        AS VentasTotales,

    ROUND(SUM(f.TotalProductCost), 2)
        AS CostosTotales,

    ROUND(
        SUM(f.SalesAmount - f.TotalProductCost), 2
    ) AS MargenBrutoEstimado

FROM dbo.FactInternetSales AS f

INNER JOIN dbo.DimProduct AS p
    ON f.ProductKey = p.ProductKey

GROUP BY
    p.EnglishProductName

ORDER BY
    VentasTotales DESC,
    Producto ASC;





--QUINTA CONSULTA: ANALISIS DE RENTABILIDAD POR CATEGORIA
--Comparacion entre ingresos, costos y margen bruto estimado
USE AdventureWorksDW2025;
GO

SELECT
    pc.EnglishProductCategoryName AS Categoria,

    ROUND(SUM(f.SalesAmount), 2)
        AS VentasTotales,

    ROUND(SUM(f.TotalProductCost), 2)
        AS CostosTotales,

    ROUND(
        SUM(f.SalesAmount - f.TotalProductCost), 2
    ) AS MargenBrutoEstimado,

    ROUND(
        100.0 *
        SUM(f.SalesAmount - f.TotalProductCost)
        / NULLIF(SUM(f.SalesAmount), 0),
        2
    ) AS PorcentajeMargenBruto,

    ROUND(
        100.0 * SUM(f.TotalProductCost)
        / NULLIF(SUM(f.SalesAmount), 0),
        2
    ) AS PorcentajeCosto

FROM dbo.FactInternetSales AS f

INNER JOIN dbo.DimProduct AS p
    ON f.ProductKey = p.ProductKey

INNER JOIN dbo.DimProductSubcategory AS ps
    ON p.ProductSubcategoryKey =
       ps.ProductSubcategoryKey

INNER JOIN dbo.DimProductCategory AS pc
    ON ps.ProductCategoryKey =
       pc.ProductCategoryKey

GROUP BY
    pc.EnglishProductCategoryName

ORDER BY
    PorcentajeMargenBruto DESC;




