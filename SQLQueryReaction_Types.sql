CREATE TABLE Reaction_Types(
   FIELD1    INTEGER  NOT NULL PRIMARY KEY 
  ,Type      VARCHAR(11) NOT NULL
  ,Sentiment VARCHAR(8) NOT NULL
  ,Score     INTEGER  NOT NULL
);
INSERT INTO Reaction_Types(FIELD1,Type,Sentiment,Score) VALUES (0,'heart','positive',60);
INSERT INTO Reaction_Types(FIELD1,Type,Sentiment,Score) VALUES (1,'want','positive',70);
INSERT INTO Reaction_Types(FIELD1,Type,Sentiment,Score) VALUES (2,'disgust','negative',0);
INSERT INTO Reaction_Types(FIELD1,Type,Sentiment,Score) VALUES (3,'hate','negative',5);
INSERT INTO Reaction_Types(FIELD1,Type,Sentiment,Score) VALUES (4,'interested','positive',30);
INSERT INTO Reaction_Types(FIELD1,Type,Sentiment,Score) VALUES (5,'indifferent','neutral',20);
INSERT INTO Reaction_Types(FIELD1,Type,Sentiment,Score) VALUES (6,'love','positive',65);
INSERT INTO Reaction_Types(FIELD1,Type,Sentiment,Score) VALUES (7,'super love','positive',75);
INSERT INTO Reaction_Types(FIELD1,Type,Sentiment,Score) VALUES (8,'cherish','positive',70);
INSERT INTO Reaction_Types(FIELD1,Type,Sentiment,Score) VALUES (9,'adore','positive',72);
INSERT INTO Reaction_Types(FIELD1,Type,Sentiment,Score) VALUES (10,'like','positive',50);
INSERT INTO Reaction_Types(FIELD1,Type,Sentiment,Score) VALUES (11,'dislike','negative',10);
INSERT INTO Reaction_Types(FIELD1,Type,Sentiment,Score) VALUES (12,'intrigued','positive',45);
INSERT INTO Reaction_Types(FIELD1,Type,Sentiment,Score) VALUES (13,'peeking','neutral',35);
INSERT INTO Reaction_Types(FIELD1,Type,Sentiment,Score) VALUES (14,'scared','negative',15);
INSERT INTO Reaction_Types(FIELD1,Type,Sentiment,Score) VALUES (15,'worried','negative',12);

SELECT * FROM Reaction_Types;


EXEC sp_rename 'Reaction_Types.FIELD1', 'ID', 'COLUMN';