


SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "ApamConfiguration"
:setvar DefaultFilePrefix "ApamConfiguration"
:setvar DefaultDataPath ""
:setvar DefaultLogPath ""

GO
:on error exit
GO


GO


USE [master];


GO

PRINT N'Creating $(DatabaseName)'

GO

CREATE DATABASE [$(DatabaseName)] COLLATE SQL_Latin1_General_CP1_CI_AS
GO


USE [$(DatabaseName)];

IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_UPDATE_STATISTICS_ASYNC OFF,
                DATE_CORRELATION_OPTIMIZATION OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE (QUERY_CAPTURE_MODE = AUTO, OPERATION_MODE = READ_WRITE, DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_PLANS_PER_QUERY = 200, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), MAX_STORAGE_SIZE_MB = 100) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET TEMPORAL_HISTORY_RETENTION ON 
            WITH ROLLBACK IMMEDIATE;
    END


GO


PRINT N'Create Resource Type Table'
GO

CREATE TABLE dbo.ResourceType 
(
    ResourceTypeId INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_ResourceType_Id PRIMARY KEY CLUSTERED,
    ResourceTypeName VARCHAR(50) NOT NULL,
    TypeDescription VARCHAR(100)  NOT NULL
)

GO



PRINT N'Create Resource Table'
CREATE TABLE dbo.Resource
(
	ResourceId INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Resource_Id PRIMARY KEY CLUSTERED,
	ResourceName VARCHAR(50) NOT NULL,
    ResourceDescription VARCHAR(100) NOT NULL,
    ResourceTypeId INT NOT NULL,
	CONSTRAINT FK_Resource_ResourceType FOREIGN KEY (ResourceTypeId) REFERENCES dbo.ResourceType(ResourceTypeId)
)

GO

CREATE INDEX IDX_Resource_ResourceType ON dbo.Resource(ResourceTypeId)

GO

PRINT N'Create Resource Environment Table'
GO
CREATE TABLE dbo.ResourceEnvironment
(
	ResourceEnvironmentId SMALLINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_ResourceEnvironment_Id PRIMARY KEY CLUSTERED,
	EnvironmentName VARCHAR(50) NOT NULL,
	EnvironmentDescription VARCHAR(100) NOT NULL
)

GO

PRINT N'Create Setting Type Table'
GO
CREATE TABLE dbo.SettingType
(
	SettingTypeId SMALLINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_SettingType_Id PRIMARY KEY CLUSTERED,
	TypeName VARCHAR(50) NOT NULL
)
GO

PRINT N'Create Setting Table'
GO
CREATE TABLE dbo.Setting 
(
	SettingId INT IDENTITY(1, 1) NOT NULL CONSTRAINT PK_Setting_Id PRIMARY KEY CLUSTERED,
	SettingName VARCHAR(50) NOT NULL,
	SettingTypeId SMALLINT NOT NULL,
	CONSTRAINT FK_Setting_SettingType FOREIGN KEY (SettingTypeId) REFERENCES dbo.SettingType(SettingTypeId)
)

CREATE INDEX IDX_Setting_SettingType ON dbo.Setting(SettingTypeId)

GO

PRINT N'Create Setting Value Table'
GO
CREATE TABLE dbo.SettingValue
(
	SettingValueId INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_SettingValue_Id PRIMARY KEY CLUSTERED,
	Value VARCHAR(255) NOT NULL,
    SettingId INT NOT NULL,
	ResourceEnvironmentId SMALLINT NOT NULL,
	CONSTRAINT FK_SettingValue_ResourceEnvironment FOREIGN KEY (ResourceEnvironmentId) REFERENCES dbo.ResourceEnvironment(ResourceEnvironmentId),
    CONSTRAINT FK_SettingValue_Setting FOREIGN KEY (SettingId) REFERENCES dbo.Setting(SettingId)
)

GO

CREATE INDEX IDX_SettingValue_ResourceEnvironment ON dbo.SettingValue(ResourceEnvironmentId)

GO

CREATE INDEX IDX_SettingValue_Setting ON dbo.Setting(SettingId)
GO

PRINT N'Create Secret Table'
GO
CREATE TABLE dbo.Secret 
(
	SecretId INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Secret_Id PRIMARY KEY CLUSTERED,
	SecretName VARCHAR(50) NOT NULL
)

GO

PRINT N'Create Secret Value Table'
GO
CREATE TABLE dbo.SecretValue
(
	SecretValueId INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_SecretValue_Id PRIMARY KEY CLUSTERED,
	SecretResourceId VARCHAR(255) NOT NULL,
	ResourceEnvironmentId SMALLINT NOT NULL,
    SecretId INT NOT NULL,
    CONSTRAINT FK_SecretValue_SecretId FOREIGN KEY (SecretId) REFERENCES dbo.Secret(SecretId),
	CONSTRAINT FK_SecretVale_ResourceEnvironment FOREIGN KEY (ResourceEnvironmentId) REFERENCES dbo.ResourceEnvironment(ResourceEnvironmentId)


)

GO

CREATE INDEX IDX_SecretValue_ResourceEnvironment ON dbo.SecretValue(ResourceEnvironmentId)

GO

CREATE INDEX IDX_SecretValue_Secret ON dbo.SecretValue(SecretId)
GO


PRINT N'Create ResourceSetting Table'
GO

CREATE TABLE dbo.ResourceSetting 
(
    ResourceSettingId INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_ResourceSetting_Id PRIMARY KEY CLUSTERED,
    ResourceId INT NOT NULL,
    SettingId INT NOT NULL,
    SettingName VARCHAR(255) NOT NULL,
    GroupPrefix VARCHAR(255) NOT NULL,
    CONSTRAINT FK_ResourceSetting_Resource FOREIGN KEY (ResourceId) REFERENCES dbo.Resource(ResourceId),
    CONSTRAINT FK_ResourceSetting_Setting FOREIGN KEY (SettingId) REFERENCES dbo.Setting(SettingId)
   
)

GO
CREATE INDEX IDX_ResourceSetting_Resource ON dbo.ResourceSetting(ResourceId)

GO

CREATE INDEX IDX_ResourceSetting_Setting ON dbo.ResourceSetting(SettingId)
GO

PRINT N'Create ResourceSecret Table'
GO

CREATE TABLE dbo.ResourceSecret 
(
    ResourceSecretId INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_ResourceSecret_Id PRIMARY KEY CLUSTERED,
    ResourceId INT NOT NULL,
    SecretId INT NOT NULL,
    SecretName VARCHAR(255) NOT NULL,
    GroupPrefix VARCHAR(255) NOT NULL,
    CONSTRAINT FK_ResourceSecret_Resource FOREIGN KEY (ResourceId) REFERENCES dbo.Resource(ResourceId),
    CONSTRAINT FK_ResourceSecret_Setting FOREIGN KEY (SecretId) REFERENCES dbo.Secret(SecretId)
   
)

GO
CREATE INDEX IDX_ResourceSecret_Resource ON dbo.ResourceSecret(ResourceId)

GO

CREATE INDEX IDX_ResourceSecret_Secret ON dbo.ResourceSecret(SecretId)
GO

PRINT N'Create ConfigurationSetting View'
GO

CREATE VIEW dbo.ConfigurationSetting 
AS 
(
	SELECT R.ResourceId, RS.SettingId AS ConfigurationSettingId, RS.SettingName, RS.GroupPrefix, ST.TypeName, SV.Value, RE.EnvironmentName, RE.ResourceEnvironmentId
	FROM dbo.Resource AS R
	INNER JOIN dbo.ResourceSetting AS RS
	  ON R.ResourceId = RS.ResourceId
	INNER JOIN dbo.Setting AS S
	  ON RS.SettingId = S.SettingId
	INNER JOIN dbo.SettingType AS ST
	  ON S.SettingTypeId = ST.SettingTypeId
	LEFT OUTER JOIN dbo.SettingValue as SV
	  ON S.SettingId = SV.SettingId
	LEFT OUTER JOIN dbo.ResourceEnvironment AS RE
	  ON SV.ResourceEnvironmentId = RE.ResourceEnvironmentId
)
GO


PRINT N'Create ConfigurationSecret View'
GO
CREATE VIEW dbo.ConfigurationSecret
AS
(
	SELECT R.ResourceId, RS.SecretName, RS.ResourceSecretId AS ConfigurationSecretId, RS.GroupPrefix, SV.SecretResourceId, RE.EnvironmentName, RE.ResourceEnvironmentId
	FROM dbo.Resource AS R
	INNER JOIN dbo.ResourceSecret AS RS
	  ON R.ResourceId = RS.ResourceId
	INNER JOIN dbo.Secret AS S
	  ON RS.SecretId = S.SecretId
	LEFT OUTER JOIN dbo.SecretValue AS SV
	  ON S.SecretId  = SV.SecretId
	LEFT OUTER JOIN dbo.ResourceEnvironment AS RE
	  ON SV.ResourceEnvironmentId = RE.ResourceEnvironmentId
	  
)


GO