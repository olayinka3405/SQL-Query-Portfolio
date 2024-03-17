
SELECT Reactions.Content_ID, Reactions.Type, Reactions.Datetime, 
		Content.Content_Type, Content.Category,
		Reaction_Types.Sentiment, Reaction_Types.Score
INTO Merged_Table
FROM Reactions 
LEFT JOIN Content ON Reactions.Content_ID = Content.Content_ID
FULL JOIN Reaction_Types ON Reactions.Type = Reaction_Types.Type


SELECT * FROM Merged_Table

SELECT Category, SUM(Score) AS 'Total_Score'
FROM Merged_Table
GROUP BY Category
ORDER BY Total_Score DESC;