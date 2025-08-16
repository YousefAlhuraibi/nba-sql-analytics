SELECT  
    firstName, 
    lastName, 
    SUM(points) AS total_points
FROM PlayerStatistics 
WHERE gameDate >= '2000-01-01'
  AND gameType LIKE '%Regular%'
GROUP BY personId
ORDER BY total_points DESC
LIMIT 1;
