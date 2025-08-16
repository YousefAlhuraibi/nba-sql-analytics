SELECT
PlayerStatistics.firstName,
PlayerStatistics.lastName,
PlayerStatistics.personId,
CASE 
	WHEN PlayerStatistics.playerteamName = Games.hometeamName THEN 'Home'
	Else 'Away'
	END as Game_Location,
  ROUND(AVG(PlayerStatistics.points), 2) AS avg_points,
  ROUND(AVG(PlayerStatistics.assists), 2) AS avg_assists,
  ROUND(AVG(PlayerStatistics.reboundsTotal), 2) AS avg_rebounds
FROM PlayerStatistics
JOIN Games
	ON PlayerStatistics.gameid = games.gameid 
WHERE PlayerStatistics.gameDate >= '2000-01-01'
	  AND PlayerStatistics.gameType LIKE '%Regular%'
Group BY PlayerStatistics.personId, Game_Location
Order by avg_points DESC
Limit 100;
