-- Team season win% (regular season, since 2000)
WITH base_games AS (
  SELECT
    g.gameDate,
    g.homeTeamName,
    g.awayTeamName,
    g.homeScore,
    g.awayScore
  FROM Games g
  WHERE g.gameType LIKE '%Regular%'
    AND g.gameDate >= '2000-01-01'
),
team_games AS (
  -- one row per team per game
  SELECT
    strftime('%Y', gameDate) AS season,
    homeTeamName AS team,
    CASE WHEN homeScore > awayScore THEN 1 ELSE 0 END AS win
  FROM base_games
  UNION ALL
  SELECT
    strftime('%Y', gameDate) AS season,
    awayTeamName AS team,
    CASE WHEN awayScore > homeScore THEN 1 ELSE 0 END AS win
  FROM base_games
),
season_agg AS (
  SELECT
    team,
    season,
    COUNT(*) AS gp,
    SUM(win) AS wins,
    ROUND(1.0 * SUM(win) / NULLIF(COUNT(*),0), 3) AS win_pct
  FROM team_games
  GROUP BY team, season
)
SELECT team, season, gp, wins, win_pct
FROM season_agg
-- WHERE season >= '2015'   -- optional cutoff to shorten
ORDER BY season DESC, win_pct DESC, team
LIMIT 500;
