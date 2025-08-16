WITH player_agg as (
SELECT 
SUM(PlayerStatistics.points) AS total_points,
SUM(PlayerStatistics.assists) AS total_assists,
SUM(PlayerStatistics.reboundsTotal) AS total_rebounds,
SUM(PlayerStatistics.steals) AS total_steals,
SUM(PlayerStatistics.blocks) AS total_blocks,
SUM(PlayerStatistics.turnovers) AS total_turnovers,
PlayerStatistics.firstName, 
PlayerStatistics.lastName,
PlayerStatistics.personId,
COUNT(DISTINCT PlayerStatistics.gameID) AS games_played,
  ROUND(1.0 * SUM(PlayerStatistics.points)        / COUNT(DISTINCT PlayerStatistics.gameId), 2) AS ppg,
  ROUND(1.0 * SUM(PlayerStatistics.assists)       / COUNT(DISTINCT PlayerStatistics.gameId), 2) AS apg,
  ROUND(1.0 * SUM(PlayerStatistics.reboundsTotal) / COUNT(DISTINCT PlayerStatistics.gameId), 2) AS rpg
From PlayerStatistics 
JOIN Games
	on Games.gameId = PlayerStatistics.gameId
WHERE games.gameType like '%Regular%'
	AND games.gameDate >= '2000-01-01'
GROUP BY PlayerStatistics.personId, PlayerStatistics.firstName, PlayerStatistics.lastName
)
SELECT
  firstName,
  lastName,
  games_played,
  ROUND(
    1.0 * ( total_points
          + 1.5*total_assists
          + 1.2*total_rebounds
          + 3.0*total_steals
          + 3.0*total_blocks
          - 1.0*total_turnovers ) / NULLIF(games_played,0), 2
  ) AS efficiency_per_game,
  DENSE_RANK() OVER (
    ORDER BY
      ( total_points
      + 1.5*total_assists
      + 1.2*total_rebounds
      + 3.0*total_steals
      + 2.5*total_blocks
      - 1.5*total_turnovers ) / NULLIF(games_played,0) DESC
  ) AS rank_position
FROM player_agg
WHERE games_played >= 100
ORDER BY rank_position
LIMIT 25;


