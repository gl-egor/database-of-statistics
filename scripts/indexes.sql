--Создадим индексы в базе данных чтобы ускорить выполнение запросов к таблицам. 
--Индексы для таблицы project.player могут понадобиться так как столбец current_team_id часто используется в соединениях с таблицей project.teams.
CREATE INDEX idx_player_current_team_id ON project.player (current_team_id);
CREATE INDEX idx_player_age ON project.player (age);
CREATE INDEX idx_player_height ON project.player (height);

--Для таблицы games: столбцы team1_id и team2_id часто используются в условиях запросов или в соединениях.
CREATE INDEX idx_games_date ON project.games (date);
CREATE INDEX idx_games_team1_id ON project.games (team1_id);
CREATE INDEX idx_games_team2_id ON project.games (team2_id);

--Для таблицы match_team
CREATE INDEX idx_match_team_match_id ON project.match_team (match_id);
CREATE INDEX idx_match_team_team1_id ON project.match_team (team1_id);
CREATE INDEX idx_match_team_team2_id ON project.match_team (team2_id);

--В таблице best_seasons столбец year часто используется в условиях запросов
CREATE INDEX idx_best_seasons_player_id ON project.best_seasons (player_id);
CREATE INDEX idx_best_seasons_year ON project.best_seasons (year);
CREATE INDEX idx_tournament_begin_of_event ON project.tournament (begin_of_event);
