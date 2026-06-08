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

--CONSULTAS
SELECT * FROM TEmpleado ORDER BY cApellido;

SELECT * FROM TEmpleado WHERE nSalario > 1000;
SELECT * FROM TEmpleado WHERE bActivo = 1;

SELECT E.cNombre, E.cApellido, D.cNombreDepartamento FROM TEmpleado E INNER JOIN TDepartamento D ON E.nDepartamentoID = D.nDepartamentoID;

SELECT E.cNombre, E.cApellido, C.cNombreCargo FROM TEmpleado E INNER JOIN TCargo C ON E.nCargoID = C.nCargoID;

SELECT D.cNombreDepartamento, COUNT(*) AS TotalEmpleados FROM TEmpleado E INNER JOIN TDepartamento D ON E.nDepartamentoID=D.nDepartamentoID GROUP BY D.cNombreDepartamento;

SELECT D.cNombreDepartamento, AVG(E.nSalario) AS PromedioSalario FROM TEmpleado E INNER JOIN TDepartamento D ON E.nDepartamentoID=D.nDepartamentoID GROUP BY D.cNombreDepartamento;

SELECT TOP 3 * FROM TEmpleado ORDER BY nSalario DESC; SELECT COUNT(*) AS TotalActivos FROM TEmpleado WHERE bActivo=1; SELECT COUNT(*) AS TotalProyectos FROM TProyecto;
GO


SELECT
	C.nClienteID,
	C.cNombres,
	C.cApellidos,
	AVG(V.nMonto) AS PromedioCompra
FROM TCliente C INNER JOIN TVenta V
ON C.nClienteID = V.nClienteID
GROUP BY 
	C.nClienteID,
	C.cNombres,
	C.cApellidos
ORDER BY PromedioCompra DESC;
GO


SELECT 
	C.cNombres + ' ' + C.cApellidos AS Cliente,
	V.nVentaID,
	V.dFechaVenta,
	V.nMonto,
D.cNombreDepartamento 
FROM TCliente C INNER JOIN TVenta V
ON C.nClienteID = V.nClienteID CROSS JOIN TDepartamento D
ORDER BY Cliente;
GO

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
