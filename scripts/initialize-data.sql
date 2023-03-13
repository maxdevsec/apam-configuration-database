
PRINT N'Initialize Resource Types'
GO

INSERT INTO dbo.ResourceType
(ResourceTypeName, TypeDescription)
VALUES
('ExternalApi', 'External API')

GO

PRINT N'Initialize Setting Types'
GO

INSERT INTO dbo.SettingType
(TypeName)
VALUES
('string')



INSERT INTO dbo.SettingType
(TypeName)
VALUES
('bool')



INSERT INTO dbo.SettingType
(TypeName)
VALUES
('int')

GO

PRINT N'Initialize Environments'
GO

INSERT INTO dbo.ResourceEnvironment
(EnvironMentName, EnvironmentDescription)
VALUES
('DEV', 'Development')

INSERT INTO dbo.ResourceEnvironment
(EnvironMentName, EnvironmentDescription)
VALUES
('STAGING', 'Staging')

INSERT INTO dbo.ResourceEnvironment
(EnvironMentName, EnvironmentDescription)
VALUES
('PROD', 'Production')

GO