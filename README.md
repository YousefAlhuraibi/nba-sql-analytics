# NBA SQL Analytics (SQLite, 2000–Present)

A collection of SQL analyses on NBA player and team performance since the 2000 season.  
Queries use **SQLite** features (CTEs, window functions, `strftime`) and were tested in **DB Browser for SQLite** / `sqlite3`.

## Queries

- **BestAVGPointsSince2000.sql** — Top average points per game (PPG) since 2000; min 200 games.  
- **MostPPGSince2000.sql** — *Career total points* since 2000 (not PPG); returns the top scorer by cumulative points.  
- **nba_top25_performance_2000plus.sql** — Top-25 by a custom efficiency-per-game score (uses CTE + `DENSE_RANK`, ≥100 GP).  
- **player_career_high_with_opponent_2000plus.sql** — Each player’s single highest-scoring game since 2000 (with date & opponent; ≥100 GP).  
- **player_home_away_avg_stats.sql** — Home vs Away averages (points, assists, rebounds).  
- **player_avg_points_vs_opponent.sql** — Average points vs a **specific opponent** (example uses `'Celtics'`; replace to compare any team).  
- **team_season_win_pct_2000plus.sql** — Team season win% (home+away via `UNION ALL`, then season-level aggregation).

## How to Run

**GUI (DB Browser for SQLite)**
1. Open your database (not included here).
2. Paste a query into **Execute SQL**, run, and view results.

**CLI**
```bash
sqlite3 data/nba_stats.db < ./nba_top25_performance_2000plus.sql

## Database

Due to GitHub’s file size limits, the SQLite database (nba_stats.db) is hosted externally.
Download: (https://drive.google.com/file/d/1L7eRTkZWO2GgdrRGao0KMtVdbVUhbuvs/view?usp=drive_link)
