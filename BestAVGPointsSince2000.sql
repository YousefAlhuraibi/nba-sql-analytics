SELECT  
    firstName, 
    lastName, 
    COUNT(DISTINCT PlayerStatistics.gameId) AS games_played,
    ROUND(AVG(points), 2) AS average_points
FROM PlayerStatistics 
JOIN Games
    ON PlayerStatistics.gameID = Games.gameId
WHERE PlayerStatistics.gameDate >= '2000-01-01'
  AND PlayerStatistics.gameType LIKE '%Regular%'
GROUP BY personId
	HAVING games_played >= 200
ORDER BY average_points DESC
LIMIT 10;
