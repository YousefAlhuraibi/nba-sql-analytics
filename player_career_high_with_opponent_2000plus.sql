-- Purpose: Top 10 player career-high scoring games (regular season since 2000) with date + opponent.
-- Inputs: PlayerStatistics, Games
-- Techniques: CTEs, window functions (ROW_NUMBER), CASE, quality filter (games_played >= 100)
-- Notes: Opponent derived via home/away; ties resolved to earliest date.

WITH per_game AS (                           -- 1) CTE #1: Build one row per player per game
  SELECT
    ps.personId,
    ps.firstName, ps.lastName,
    ps.gameId,
    g.gameDate,
    ps.points,
    CASE                                         -- derive opponent using home/away logic
      WHEN ps.playerTeamName = g.homeTeamName THEN g.awayTeamName
      ELSE g.homeTeamName
    END AS opponent
  FROM PlayerStatistics ps
  JOIN Games g ON g.gameId = ps.gameId           -- join to get date + home/away context
  WHERE g.gameType LIKE '%Regular%'              -- keep regular season only
    AND g.gameDate >= '2000-01-01'               -- since 2000
),

ranked AS (                                     -- 2) CTE #2: Rank games *within each player*
  SELECT
    personId, firstName, lastName, gameId, gameDate, opponent, points,
    ROW_NUMBER() OVER (                          -- window function creates rank *per player*
      PARTITION BY personId                       -- reset ranking for each player
      ORDER BY points DESC, gameDate ASC          -- highest points first; if tie then earlier date wins
    ) AS rn
  FROM per_game                                   -- this CTE uses the output of per_game
),

gp AS (                                          -- 3) CTE #3: Games played per player (quality filter)
  SELECT personId, COUNT(DISTINCT gameId) AS games_played
  FROM per_game
  GROUP BY personId
)

SELECT                                           -- 4) Final result: each player’s single top game
  r.firstName, r.lastName,
  gp.games_played,
  r.points   AS career_high_pts,
  r.gameDate AS career_high_date,
  r.opponent
FROM ranked r
JOIN gp ON gp.personId = r.personId
WHERE r.rn = 1                                   -- keep only the #1 ranked game per player
  AND gp.games_played >= 100                     -- only legit careers (sample size)
ORDER BY career_high_pts DESC
LIMIT 25;
