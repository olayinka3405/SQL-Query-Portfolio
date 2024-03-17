-- Create a database
CREATE DATABASE Social_Buzz;

-- Use the created database
USE Social_Buzz;

-- Create the tables
CREATE TABLE Content(
   FIELD1       INTEGER  NOT NULL PRIMARY KEY 
  ,Content_ID   VARCHAR(36) NOT NULL
  ,User_ID      VARCHAR(36) NOT NULL
  ,Content_Type VARCHAR(5) NOT NULL
  ,Category     VARCHAR(17) NOT NULL
);

CREATE TABLE Reaction_Types(
   FIELD1    INTEGER  NOT NULL PRIMARY KEY 
  ,Type      VARCHAR(11) NOT NULL
  ,Sentiment VARCHAR(8) NOT NULL
  ,Score     INTEGER  NOT NULL
);

CREATE TABLE Reactions(
   FIELD1     INTEGER  NOT NULL PRIMARY KEY 
  ,Content_ID VARCHAR(36) NOT NULL
  ,User_ID    VARCHAR(36)
  ,Type       VARCHAR(11)
  ,Datetime   VARCHAR(19) NOT NULL
);

-- Select all data from tables
SELECT * FROM Content
SELECT * FROM Reaction_Types
SELECT * FROM Reactions

-- Create the merged table
SELECT Reactions.Content_ID, Reactions.Type, Reactions.Datetime, 
		Content.Content_Type, Content.Category,
		Reaction_Types.Sentiment, Reaction_Types.Score
INTO Merged_Table
FROM Reactions 
LEFT JOIN Content ON Reactions.Content_ID = Content.Content_ID
FULL JOIN Reaction_Types ON Reactions.Type = Reaction_Types.Type;

-- Select data from the merged table
SELECT * FROM Merged_Table;

-- Summarize by category
SELECT Category, SUM(Score) AS 'Total_Score'
FROM Merged_Table
GROUP BY Category
ORDER BY Total_Score DESC;

-- Drop the tables
DROP TABLE IF EXISTS Merged_Table;
DROP TABLE IF EXISTS Reactions;
DROP TABLE IF EXISTS Content;
DROP TABLE IF EXISTS Reaction_Types;

-- Drop the database
DROP DATABASE IF EXISTS Social_Buzz;


