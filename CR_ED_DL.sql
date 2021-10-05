-- Столбцы для отслеживания
-- CR-Создание ED-Редактирование DL-Удаление(Теневое удаление)
ALTER TABLE [<table>]
ADD
	[CRUser] INT NULL
  , [CRDate] DATETIME NULL
  , [EDUser] INT NULL
  , [EDDate] DATETIME NULL
  , [DLUser] INT NULL
  , [DLDate] DATETIME NULL