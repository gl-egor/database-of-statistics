--Триггер для автоматического обновления информации о возрасте игрока при изменении его даты рождения:
CREATE OR REPLACE FUNCTION update_player_age_trigger()
RETURNS TRIGGER AS $$
BEGIN
    NEW.age := DATE_PART('year', CURRENT_DATE) - DATE_PART('year', NEW.birth_date);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER player_age_trigger
BEFORE INSERT OR UPDATE OF birth_date ON project.player
FOR EACH ROW
EXECUTE FUNCTION update_player_age_trigger();

--Триггер для записи истории изменений количества очков за игру для конкретного игрока:
CREATE OR REPLACE FUNCTION log_points_per_game_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'UPDATE' THEN
        INSERT INTO points_per_game_history (player_id, old_points_per_game, new_points_per_game, change_date)
        VALUES (NEW.player_id, OLD.points_per_game, NEW.points_per_game, CURRENT_TIMESTAMP);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER points_per_game_history_trigger
AFTER UPDATE OF points_per_game ON project.best_seasons
FOR EACH ROW
EXECUTE FUNCTION log_points_per_game_changes();

--Триггер для автоматического расчета процента выигранных матчей для каждой команды при вставке новых данных:
CREATE OR REPLACE FUNCTION calculate_win_percentage()
RETURNS TRIGGER AS $$
DECLARE
    total_games INT;
    wins_count INT;
BEGIN
    SELECT COUNT(*) INTO total_games
    FROM project.games;

    SELECT COUNT(*)
    INTO wins_count
    FROM project.match_team mt
    JOIN project.games g ON mt.match_id = g.id
    WHERE (mt.team1_id = NEW.team1_id AND mt.team1_points > mt.team2_points) OR (mt.team2_id = NEW.team1_id AND mt.team2_points > mt.team1_points);

    NEW.win_percentage := (wins_count * 100.0) / total_games;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


--Процедура для расчета среднего количества очков за игру для конкретного игрока:
CREATE OR REPLACE FUNCTION calculate_avg_points_per_game(player_id INT) RETURNS NUMERIC AS $$
DECLARE
    avg_points NUMERIC;
BEGIN
    SELECT AVG(points_per_game) INTO avg_points
    FROM project.best_seasons
    WHERE player_id = calculate_avg_points_per_game.player_id;
    
    RETURN avg_points;
END;
$$ LANGUAGE plpgsql;

--Функция для получения количества матчей, в которых команда победила:
CREATE OR REPLACE FUNCTION get_wins_for_team(team_id INT) RETURNS INT AS $$
DECLARE
    wins_count INT;
BEGIN
    SELECT COUNT(*)
    INTO wins_count
    FROM project.match_team mt
    JOIN project.games g ON mt.match_id = g.id
    WHERE (mt.team1_id = get_wins_for_team.team_id AND mt.team1_points > mt.team2_points) OR (mt.team2_id = get_wins_for_team.team_id AND mt.team2_points > mt.team1_points);

    RETURN wins_count;
END;
$$ LANGUAGE plpgsql;

--Функция для вычисления среднего возраста игроков в указанной команде:
CREATE OR REPLACE FUNCTION calculate_avg_age_in_team(team_id INT) RETURNS NUMERIC AS $$
DECLARE
    avg_age NUMERIC;
BEGIN
    SELECT AVG(age) INTO avg_age
    FROM project.player
    WHERE current_team_id = calculate_avg_age_in_team.team_id;

    RETURN avg_age;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER win_percentage_trigger
AFTER INSERT ON project.match_team
FOR EACH ROW
EXECUTE FUNCTION calculate_win_percentage();
