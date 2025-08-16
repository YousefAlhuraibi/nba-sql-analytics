SELECT
    ps.firstName,
    ps.lastName,
    ps.personId,
    ROUND(AVG(ps.points), 2) AS avg_points,
    COUNT(*) AS games_played
FROM PlayerStatistics ps
JOIN Games g 
	ON ps.gameId = g.gameId
WHERE g.gameType LIKE '%Regular%'
  AND g.gameDate >= '2000-01-01'
  AND (
      (g.homeTeamName = 'Celtics' AND ps.playerTeamName != 'Celtics') OR
      (g.awayTeamName = 'Celtics' AND ps.playerTeamName != 'Celtics')
  )
GROUP BY ps.personId
HAVING games_played >= 5
ORDER BY avg_points DESC
LIMIT 15;
