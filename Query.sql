CREATE TABLE HelloWorld ( 
Id INT IDENTITY, 
Description VARCHAR(50) 
) 

INSERT INTO HelloWorld (Description) VALUES ('Hello World5')

select * from HelloWorld
select description from HelloWorld
select count(*) from HelloWorld
UPDATE HelloWorld SET Description = 'Hello, World!' WHERE Id = 1
select * from HelloWorld
DELETE FROM HelloWorld WHERE Id = 1
select * from HelloWorld

--DBCC CHECKIDENT (HelloWorld, RESEED, 0)