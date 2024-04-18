DROP SCHEMA IF EXISTS project cascade;
CREATE SCHEMA IF NOT EXISTS project;

DROP TABLE IF EXISTS project.teams CASCADE;
CREATE TABLE project.teams (
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	team_name VARCHAR(50),
	city VARCHAR(50),
	foundation_date DATE
);

DROP TABLE IF EXISTS project.coach;
CREATE TABLE project.coach (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(100),
	birth_date DATE,
	begin_of_work DATE,
	end_of_work DATE,
	team_id INT,
    FOREIGN KEY(team_id) REFERENCES project.teams(id)
);

DROP TABLE IF EXISTS project.player;
CREATE TABLE project.player (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(100),
	position VARCHAR(100),
	age INTEGER,
	height INTEGER,
	weight INTEGER,
	current_team_id INT,
    FOREIGN KEY(current_team_id) REFERENCES project.teams(id)
);

DROP TABLE IF EXISTS project.best_seasons;
CREATE TABLE project.best_seasons (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	player_id INTEGER,
	year INTEGER,
	points_per_game NUMERIC,
	rebounds_per_game NUMERIC,
	assists_per_game NUMERIC,
	games_played INTEGER,
	percentage_of_wins NUMERIC,
    FOREIGN KEY(player_id) REFERENCES project.player(id)
);

DROP TABLE IF EXISTS project.tournament;
CREATE TABLE project.tournament (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	begin_of_event DATE,
	end_of_event DATE,
	winner INTEGER,
	categorial_code INT,
    FOREIGN KEY(winner) REFERENCES project.teams(id)
);

DROP TABLE IF EXISTS project.tournament_category;
CREATE TABLE project.tournament_category (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	category VARCHAR(100)
);

ALTER TABLE project.tournament ADD FOREIGN KEY(categorial_code) REFERENCES project.tournament_category(id);

DROP TABLE IF EXISTS project.games;
CREATE TABLE project.games (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	date DATE,
	arena VARCHAR(100),
	viewers INTEGER,
	tournament_id INT,
    FOREIGN KEY(tournament_id) REFERENCES project.tournament(id)
);

DROP TABLE IF EXISTS project.match_team;
CREATE TABLE project.match_team (
    match_id INT,
	team1_id INT,
	team2_id INT,
	team1_points INT,
	team2_points INT,
    FOREIGN KEY(match_id) REFERENCES project.games(id),
	FOREIGN KEY(team1_id) REFERENCES project.teams(id),
	FOREIGN KEY(team2_id) REFERENCES project.teams(id)
);

SELECT * FROM project.match_team
