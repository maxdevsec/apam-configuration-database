
GO
USE MASTER
GO

CREATE LOGIN apam_config_app WITH PASSWORD = '$(appPassword)';

GO

CREATE USER apam_config_app FOR LOGIN apam_config_app WITH DEFAULT_SCHEMA = [dbo]

GO

USE ApamConfiguration
GO

CREATE USER apam_config_app FOR LOGIN apam_config_app WITH DEFAULT_SCHEMA = [dbo]

GO

CREATE ROLE ApamConfigApplicationRole AUTHORIZATION [dbo]

GO


GRANT 
	DELETE, 
	EXECUTE, 
	INSERT, 
	SELECT, 
	UPDATE
ON SCHEMA :: dbo
	TO ApamConfigApplicationRole
GO

EXEC sp_addrolemember 'ApamConfigApplicationRole', 'apam_config_app';

GO