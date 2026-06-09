USE MASTER;
GO

IF DB_ID('EmpresaSQL') IS NOT NULL
BEGIN
	ALTER DATABASE EmpresaSQL
	SET SINGLE_USER WITH ROLLBACK INMEDIATE;

	DROP DATABASE IF EXISTS EmpresaSQL;
END
GO

CREATE DATABASE EmpresaSQL;
GO

USE EmpresaSQL;
GO

--Tabla Departamento
CREATE TABLE TDepartamento(
	nDepartamentoID INT IDENTITY (1,1),
	cNombreDepartamento NVARCHAR(100) NOT NULL,

	CONSTRAINT PK_TDepartamento_nDepartamento 
	PRIMARY KEY (nDepartamentoID),

	CONSTRAINT UQ_TDepartamento_cNombreDepartamento
	UNIQUE (cNombreDepartamento)
	
);
GO


CREATE TABLE TCargo(
	nCargoID INT IDENTITY (1,1),
	cNombreCargo NVARCHAR (100) NOT NULL,

	CONSTRAINT PK_TCargo_nCargoID
	PRIMARY KEY (nCargoID),
	CONSTRAINT UQ_TCargo_cNombreCargo
	UNIQUE (cNombreCargo)
);
GO


CREATE TABLE TEmpleado(
	nEmpleadoID INT IDENTITY (1,1),
	cNIF INT,
	cNombre NVARCHAR (100) NOT NULL,
	cApellido NVARCHAR (100) NOT NULL,
	nDepartamentoID INT,
	nCargoID INT,
	dFechaContratacion DATETIME NOT NULL
		CONSTRAINT DF_TEmpleado_Fecha
		DEFAULT GETDATE(),
	nSalario DECIMAL (10,2) NOT NULL,

	CONSTRAINT PK_TEmpleado_nEmpleado
	PRIMARY KEY (nEmpleadoID),

	CONSTRAINT UQ_TEmpleado_cNIF
	UNIQUE (cNIF),

	CONSTRAINT CK_TEmpleado_nSalario
	CHECK (nSalario > 300),


	CONSTRAINT FK_TEmpleado_TDepartamento
	FOREIGN KEY (nDepartamentoID) REFERENCES TDepartamento(nDepartamentoID),

	CONSTRAINT FK_TEmpleado_TCargo
	FOREIGN KEY (nCargoID) REFERENCES TCargo(nCargoID)

);
GO

CREATE TABLE TProyecto(
	nProyectoID INT IDENTITY(1,1),
    cNombreProyecto NVARCHAR(100) NOT NULL,
    dFechaInicio DATE NOT NULL,
    dFechaFin DATE NULL,

    CONSTRAINT PK_TProyecto
        PRIMARY KEY (nProyectoID)
);
GO


CREATE TABLE TEmpleadoProyecto(
    nEmpleadoID INT NOT NULL,
    nProyectoID INT NOT NULL,

    CONSTRAINT PK_TEmpleadoProyecto
        PRIMARY KEY (nEmpleadoID, nProyectoID),

    CONSTRAINT FK_TEmpleadoProyecto_Empleado
        FOREIGN KEY (nEmpleadoID)
        REFERENCES TEmpleado(nEmpleadoID),

    CONSTRAINT FK_TEmpleadoProyecto_Proyecto
        FOREIGN KEY (nProyectoID)
        REFERENCES TProyecto(nProyectoID)
);
GO


--PARTE II: ALTER TABLE

ALTER TABLE TEmpleado
ADD cEmail NVARCHAR(100);
GO

ALTER TABLE TEmpleado
ADD cTelefono VARCHAR(15);
GO

ALTER TABLE TEmpleado
ALTER COLUMN cNombre NVARCHAR(100) NOT NULL;
GO

ALTER TABLE TEmpleado
ALTER COLUMN cApellido NVARCHAR(100) NOT NULL;
GO

ALTER TABLE TEmpleado
ADD cDireccion NVARCHAR(200);
GO

ALTER TABLE TEmpleado
ADD nEdad INT;
GO

ALTER TABLE TEmpleado
ADD CONSTRAINT CK_TEmpleado_Edad
CHECK(nEdad BETWEEN 18 AND 65);
GO

ALTER TABLE TEmpleado
ADD CONSTRAINT UQ_TEmpleado_Email
UNIQUE(cEmail);
GO

ALTER TABLE TEmpleado
ADD bActivo BIT NOT NULL
CONSTRAINT DF_TEmpleado_Activo DEFAULT(1);
GO

ALTER TABLE TEmpleado
DROP COLUMN cDireccion;
GO

ALTER TABLE TEmpleado
ALTER COLUMN cTelefono VARCHAR(20);
GO

ALTER TABLE TEmpleado
ADD cGenero CHAR(1);
GO

ALTER TABLE TEmpleado
ADD CONSTRAINT CK_TEmpleado_Genero
CHECK(cGenero IN ('M','F'));
GO

ALTER TABLE TEmpleado
ADD dFechaNacimiento DATE;
GO


--Creación de tabla TSucursal
CREATE TABLE TSucursal(
    nSucursalID INT IDENTITY(1,1) PRIMARY KEY,
    cNombreSucursal NVARCHAR(100) NOT NULL,
    cCiudad NVARCHAR(100) NOT NULL
);
GO

INSERT INTO TDepartamento (cNombreDepartamento) VALUES 
('Recursos Humanos'), ('Finanzas'), ('Sistemas'), ('Ventas'), ('Marketing');
GO

INSERT INTO TCargo (cNombreCargo) VALUES
('Gerente'), ('Supervisor'), ('Analista'), ('Programador'), ('Asistente');
GO

INSERT INTO TEmpleado (cNIF,cNombre,cApellido,nDepartamentoID,nCargoID, nSalario,cEmail,cTelefono,nEdad,cGenero) VALUES 
(1001,'Juan','Perez',1,1,1200,'juan@empresa.com','88881111',35,'M'),
(1002,'Maria','Lopez',2,2,950,'maria@empresa.com','88882222',29,'F'),
(1003,'Carlos','Gomez',3,4,1500,'carlos@empresa.com','88883333',30,'M'),
(1004,'Ana','Ruiz',4,5,650,'ana@empresa.com','88884444',24,'F'),
(1005,'Luis','Garcia',5,3,850,'luis@empresa.com','88885555',40,'M'),
(1006,'Elena','Martinez',1,2,1100,'elena@empresa.com','88886666',32,'F'),
(1007,'Pedro','Hernandez',2,3,900,'pedro@empresa.com','88887777',28,'M'),
(1008,'Sofia','Torres',3,4,1700,'sofia@empresa.com','88888888',27,'F'),
(1009,'Miguel','Castro',4,5,700,'miguel@empresa.com','88889999',45,'M'),
(1010,'Lucia','Gonzalez',5,1,2000,'lucia@empresa.com','88880000',38,'F');
GO

INSERT INTO TProyecto (cNombreProyecto,dFechaInicio,dFechaFin) VALUES
('Sistema Inventario','2025-01-10','2025-06-10'),
('ERP Empresarial','2025-02-15','2025-12-15'),
('Portal Web','2025-03-01',NULL);
GO

INSERT INTO TEmpleadoProyecto VALUES (1,1);
INSERT INTO TEmpleadoProyecto VALUES (2,1);
INSERT INTO TEmpleadoProyecto VALUES (3,1);
INSERT INTO TEmpleadoProyecto VALUES (4,2);
INSERT INTO TEmpleadoProyecto VALUES (5,2);
INSERT INTO TEmpleadoProyecto VALUES (6,2);
INSERT INTO TEmpleadoProyecto VALUES (7,3);
INSERT INTO TEmpleadoProyecto VALUES (8,3);
INSERT INTO TEmpleadoProyecto VALUES (9,3);
INSERT INTO TEmpleadoProyecto VALUES (10,3);
GO


INSERT INTO TEmpleado(cNIF,cNombre,cApellido,nDepartamentoID,nCargoID,nSalario)
VALUES(2001,'Mario','FechaDefault',1,1,800);

INSERT INTO TEmpleado(cNIF,cNombre,cApellido,nDepartamentoID,nCargoID,nSalario,cEmail)
VALUES(2002,'Laura','Correo',2,2,900,'laura@empresa.com');

INSERT INTO TEmpleado(cNIF,cNombre,cApellido,nDepartamentoID,nCargoID,nSalario)
VALUES(2003,'Jose','ActivoDefault',3,3,950);


--UPDATE
UPDATE TEmpleado SET nSalario = nSalario * 1.10;
GO 
UPDATE TEmpleado SET nSalario = nSalario * 1.20 WHERE nDepartamentoID = 3;
GO
UPDATE TEmpleado SET cEmail='nuevo_correo@empresa.com' WHERE nEmpleadoID=1;
GO
UPDATE TEmpleado SET bActivo=0 WHERE nSalario < 500;
GO
UPDATE TProyecto SET dFechaFin='2026-12-31' WHERE nProyectoID=3;
GO

--Ejemplo de error
INSERT INTO TEmpleadoProyecto VALUES(1,3);


--UPDATES
UPDATE TEmpleado SET nSalario=nSalario*1.10;
UPDATE TEmpleado SET nSalario=nSalario*1.20 WHERE nDepartamentoID=3;
UPDATE TEmpleado SET cEmail='nuevo_correo@empresa.com' WHERE nEmpleadoID=1;
UPDATE TEmpleado SET nCargoID=1 WHERE nEmpleadoID=2;
UPDATE TEmpleado SET nDepartamentoID=4 WHERE nEmpleadoID IN(1,2);
UPDATE TEmpleado SET bActivo=0 WHERE nSalario<500;
UPDATE TProyecto SET dFechaFin='2026-12-31' WHERE nProyectoID=3;
INSERT INTO TEmpleadoProyecto VALUES(1,3);


--DELETES
DELETE FROM TEmpleado WHERE cNIF=2003;
DELETE FROM TEmpleado WHERE bActivo=0;
DELETE FROM TEmpleadoProyecto WHERE nProyectoID=2;
DELETE FROM TProyecto WHERE nProyectoID=2;


--CONSULTAS
SELECT * FROM TEmpleado ORDER BY cApellido;
SELECT * FROM TEmpleado WHERE nSalario>1000;
SELECT * FROM TEmpleado WHERE bActivo=1;
SELECT * FROM TEmpleado WHERE YEAR(dFechaContratacion)=YEAR(GETDATE());
SELECT E.cNombre,E.cApellido,D.cNombreDepartamento FROM TEmpleado E JOIN TDepartamento D ON E.nDepartamentoID=D.nDepartamentoID;
SELECT E.cNombre,E.cApellido,C.cNombreCargo FROM TEmpleado E JOIN TCargo C ON E.nCargoID=C.nCargoID;
SELECT E.cNombre,P.cNombreProyecto FROM TEmpleado E JOIN TEmpleadoProyecto EP ON E.nEmpleadoID=EP.nEmpleadoID JOIN TProyecto P ON EP.nProyectoID=P.nProyectoID;
SELECT D.cNombreDepartamento,COUNT(*) Total FROM TEmpleado E JOIN TDepartamento D ON E.nDepartamentoID=D.nDepartamentoID GROUP BY D.cNombreDepartamento;
SELECT D.cNombreDepartamento,AVG(nSalario) Promedio FROM TEmpleado E JOIN TDepartamento D ON E.nDepartamentoID=D.nDepartamentoID GROUP BY D.cNombreDepartamento;
SELECT D.cNombreDepartamento,MAX(nSalario) Maximo,MIN(nSalario) Minimo FROM TEmpleado E JOIN TDepartamento D ON E.nDepartamentoID=D.nDepartamentoID GROUP BY D.cNombreDepartamento;
SELECT P.cNombreProyecto,COUNT(*) Empleados FROM TProyecto P JOIN TEmpleadoProyecto EP ON P.nProyectoID=EP.nProyectoID GROUP BY P.cNombreProyecto HAVING COUNT(*)>2;
SELECT * FROM TEmpleado WHERE cApellido LIKE 'G%';
SELECT * FROM TEmpleado ORDER BY nSalario DESC;
SELECT TOP 3 * FROM TEmpleado ORDER BY nSalario DESC;
SELECT * FROM TEmpleado WHERE nEdad BETWEEN 25 AND 40;
SELECT COUNT(*) TotalActivos FROM TEmpleado WHERE bActivo=1;
SELECT COUNT(*) TotalProyectos FROM TProyecto;


--ELIMINAR RESTRICCIONEA
ALTER TABLE TEmpleado DROP CONSTRAINT CK_TEmpleado_Edad;
GO
ALTER TABLE TEmpleado DROP CONSTRAINT UQ_TEmpleado_Email;
GO


--SE VUELVE A CREAR RESTRICCIONES
ALTER TABLE TEmpleado ADD CONSTRAINT CK_TEmpleado_Edad CHECK(nEdad BETWEEN 18 AND 65);
GO
ALTER TABLE TEmpleado ADD CONSTRAINT UQ_TEmpleado_Email UNIQUE(cEmail);
GO


--CREACIÓN DE LA TABLA CLIENTE
CREATE TABLE TCliente(
 nClienteID INT IDENTITY(1,1) PRIMARY KEY,
 cNombres NVARCHAR(100) NOT NULL,
 cApellidos NVARCHAR(100) NOT NULL,
 cCedula VARCHAR(20) UNIQUE NOT NULL,
 cTelefono VARCHAR(20),
 cEmail NVARCHAR(100) UNIQUE,
 cDireccion NVARCHAR(200),
 dFechaRegistro DATE DEFAULT GETDATE(),
 bActivo BIT DEFAULT 1
);


--CREACCIÓN DE LA TABLA VENTA
CREATE TABLE TVenta(
 nVentaID INT IDENTITY(1,1) PRIMARY KEY,
 nClienteID INT NOT NULL,
 dFechaVenta DATE DEFAULT GETDATE(),
 nMonto DECIMAL(10,2) CHECK(nMonto>0),
 FOREIGN KEY(nClienteID) REFERENCES TCliente(nClienteID)
);

DECLARE @i INT=1;
WHILE @i<=20
BEGIN
 INSERT INTO TCliente(cNombres,cApellidos,cCedula)
 VALUES(CONCAT('Cliente',@i),'Demo',CONCAT('CED',@i));
 SET @i=@i+1;
END

SET @i=1;
WHILE @i<=50
BEGIN
 INSERT INTO TVenta(nClienteID,nMonto)
 VALUES(((@i-1)%20)+1,100+(@i*10));
 SET @i=@i+1;
END

UPDATE TVenta SET nMonto=nMonto*1.10 WHERE nMonto>=500;

SELECT TOP 5 C.nClienteID,C.cNombres,SUM(V.nMonto) TotalCompras
FROM TCliente C JOIN TVenta V ON C.nClienteID=V.nClienteID
GROUP BY C.nClienteID,C.cNombres
ORDER BY TotalCompras DESC;

SELECT YEAR(dFechaVenta) Anio,MONTH(dFechaVenta) Mes,SUM(nMonto) Total
FROM TVenta
GROUP BY YEAR(dFechaVenta),MONTH(dFechaVenta);

SELECT C.cNombres,AVG(V.nMonto) Promedio
FROM TCliente C JOIN TVenta V ON C.nClienteID=V.nClienteID
GROUP BY C.cNombres;

SELECT C.cNombres,V.nMonto,D.cNombreDepartamento
FROM TCliente C
JOIN TVenta V ON C.nClienteID=V.nClienteID
CROSS JOIN TDepartamento D;

/*(ejecutar al final si se solicita)
DROP TABLE TEmpleadoProyecto;
DROP TABLE TProyecto;
DROP TABLE TEmpleado;
DROP TABLE TCargo;
DROP TABLE TDepartamento;
DROP TABLE TSucursal;
USE master;
DROP DATABASE EmpresaSQL;*/
