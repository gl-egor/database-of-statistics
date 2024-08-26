-- процент побед команд в турнирах
DROP VIEW IF EXISTS Tournament_Win_Percent;
CREATE OR REPLACE VIEW Tournament_Win_Percent AS
SELECT t.id AS tournament_id, 
       EXTRACT(YEAR FROM t.begin_of_event) AS year,
       CASE WHEN mt.team1_id = t2.id THEN t2.id ELSE t1.id END AS team_id,
       CASE WHEN mt.team1_id = t2.id THEN t2.team_name ELSE t1.team_name END AS team_name,
       COUNT(CASE WHEN (mt.team1_id = t2.id AND mt.team1_points > mt.team2_points) OR (mt.team2_id = t2.id AND mt.team2_points > mt.team1_points) THEN 1 END) * 100.0 / COUNT(*) AS win_percentage
FROM project.games g
JOIN project.match_team mt ON g.id = mt.match_id
JOIN project.teams t1 ON mt.team1_id = t1.id
JOIN project.teams t2 ON mt.team2_id = t2.id
JOIN project.tournament t ON g.tournament_id = t.id
GROUP BY t.id, t1.id, t1.team_name, t2.id, t2.team_name, mt.team1_id, mt.team2_id;

--посещаемость для каждого турнира
CREATE VIEW Tournament_Attendance AS
SELECT t.id AS tournament_id, EXTRACT(YEAR FROM t.begin_of_event) AS year, COUNT(*) AS number_of_games, SUM(g.viewers) AS total_viewers
FROM project.games g
JOIN project.tournament t ON g.tournament_id = t.id
GROUP BY t.id;

--Лучшие сезоны игроков с процентом побед
DROP VIEW IF EXISTS Best_Player_Season;
CREATE VIEW Best_Player_Seasons AS
SELECT bp.id AS player_id, 
       p.name AS player_name, 
       bp.year, 
       bp.points_per_game, 
       bp.rebounds_per_game, 
       bp.assists_per_game,
       twp.win_percentage
FROM project.best_seasons bp
JOIN project.player p ON bp.player_id = p.id
JOIN Tournament_Win_Percentage twp ON p.current_team_id = twp.team_id AND bp.year = twp.year;

--Статистика побед тренеров
DROP VIEW IF EXISTS Coach_Work_Info;
CREATE VIEW Coach_Work_Info AS
SELECT c.id AS coach_id, c.name AS coach_name, c.birth_date, c.begin_of_work, c.end_of_work, t.team_name AS team, twp.percentage_of_wins
FROM project.coach c
JOIN project.teams t ON c.team_id = t.id
JOIN Tournament_Win_Percentage twp ON c.team_id = twp.team_id AND EXTRACT(YEAR FROM c.begin_of_work) = twp.year;

--Информация о минимальном и максимальном возрасте в команде
CREATE VIEW Team_Player_Age_Stats AS
SELECT t.team_name, 
       MAX(p.age) AS max_age, 
       MIN(p.age) AS min_age
FROM project.player p
JOIN project.teams t ON p.current_team_id = t.id
GROUP BY t.team_name;

