-- названия всех команд и соответствующие им города.
SELECT team_name, city FROM project.teams;

-- все тренеры, которые работали в Милуоки бакс с 2020 года.
SELECT * FROM project.coach 
WHERE team_id = (SELECT id FROM project.teams WHERE team_name = 'Milwaukee Bucks')
AND begin_of_work >= '2020-07-01';

-- Игроки, которые в данный момент играют за Лос Анджелес Лейкерс
SELECT * FROM project.player 
WHERE current_team_id = (SELECT id FROM project.teams WHERE team_name = 'Los Angeles Lakers');

-- Лучшие сезоны Стефена Карри
SELECT * FROM project.best_seasons 
WHERE player_id = (SELECT id FROM project.player WHERE name = 'Stephen Curry');

-- Победители турниров начиная с 2021 года
SELECT t.id, t.begin_of_event, t.end_of_event, tm.team_name AS winner, tc.category
FROM project.tournament t
JOIN project.teams tm ON t.winner = tm.id
JOIN project.tournament_category tc ON t.categorial_code = tc.id
WHERE begin_of_event > '2021-01-01';

-- команды с самым высоким средним количеством зрителей за игру
SELECT t.team_name, AVG(g.viewers) AS avg_viewership
FROM project.teams t
JOIN project.games g ON t.id IN (SELECT DISTINCT team1_id FROM project.match_team UNION SELECT DISTINCT team2_id FROM project.match_team)
GROUP BY t.team_name
HAVING AVG(g.viewers) > 15000
ORDER BY avg_viewership DESC;

-- игроки, которые выиграли какой-либо турнир.
SELECT DISTINCT p.name AS player_name
FROM project.player p
JOIN project.match_team mt ON p.current_team_id IN (mt.team1_id, mt.team2_id)
JOIN project.games g ON mt.match_id = g.id
JOIN project.tournament t ON g.tournament_id = t.id
WHERE t.winner = p.current_team_id;

-- тренеры с самым длительным стажем работы в каждой команде.
SELECT t.team_name, c.name AS coach_name, MAX(DATEDIFF(end_of_work, begin_of_work)) AS tenure_days
FROM project.teams t
JOIN project.coach c ON t.id = c.team_id
GROUP BY t.team_name, c.name
ORDER BY tenure_days DESC;

-- Количество игр, которое сыграла каждая команда
SELECT t.team_name, COUNT(mt.match_id) AS games_played
FROM project.teams t
LEFT JOIN project.match_team mt ON t.id IN (mt.team1_id, mt.team2_id)
GROUP BY t.team_name;

-- Команды со средним возрастом, меньшим 25
SELECT t.team_name, AVG(p.age) AS avg_age
FROM project.teams t
JOIN project.player p ON t.id = p.current_team_id
GROUP BY t.team_name
HAVING AVG(p.age) < 25;
