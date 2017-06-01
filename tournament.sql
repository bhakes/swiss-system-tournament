-- Table definitions for the tournament project.
--

-
CREATE TABLE players(
-- create log to store players
   full_name text,
   id serial PRIMARY KEY
);

CREATE TABLE matches(
-- create log to store match winners & losers
   winner int REFERENCES players (id),
   loser int REFERENCES players (id),
   m_id serial PRIMARY KEY
);

CREATE VIEW standings_sml AS
-- create a standings based on wins and losses from players and matches
  SELECT players.id, players.full_name, count(matches.winner) as wins
    FROM players LEFT JOIN matches
    ON players.id = matches.winner
    GROUP BY players.id
    ORDER BY wins desc;

CREATE VIEW matchlist AS
--- create log of each match participant (winner or loser) for all games played
  SELECT matches.winner AS match_participants
    FROM matches
  union all
  SELECT matches.loser
    FROM matches;

CREATE VIEW num_of_matches AS
-- from matchlist table, count number of matches for each team
  SELECT players.id AS id, count(matchlist.match_participants) as matches
    FROM players LEFT JOIN matchlist
    ON players.id = matchlist.match_participants
    GROUP BY players.id
    ORDER BY matches desc;

CREATE VIEW standings_lrg AS
-- create a larger standing that includes matches played
  SELECT standings_sml.id, standings_sml.full_name, standings_sml.wins, num_of_matches.matches --, row_number() OVER(ORDER BY standings_sml.wins DESC) AS p_rank
    FROM standings_sml, num_of_matches
    WHERE standings_sml.id = num_of_matches.id
    ORDER BY standings_sml.wins desc;

CREATE VIEW standings_lrg_even AS
-- select only even rows from the large standings table, add new row number
  SELECT t.id, t.full_name, row_number() OVER(ORDER BY t.row ASC) as row
  FROM (
    SELECT id, full_name, wins, row_number() OVER(ORDER BY wins DESC) as row
    FROM standings_lrg
  ) t
  WHERE row % 2 = 0;

CREATE VIEW standings_lrg_odd AS
-- select only odd rows from the large standings table, add new row number
  SELECT t.id, t.full_name, row_number() OVER(ORDER BY t.row ASC) as row
  FROM (
    SELECT id, full_name, wins, row_number() OVER(ORDER BY wins DESC) as row
    FROM standings_lrg
  ) t
  WHERE row % 2 != 0;

CREATE VIEW next_pairings AS
-- combined even and odd views into one pairing table
  SELECT standings_lrg_odd.id AS p1_id, standings_lrg_odd.full_name AS p1_name, standings_lrg_even.id AS p2_id, standings_lrg_even.full_name AS p2_name
    FROM standings_lrg_odd JOIN standings_lrg_even
    ON standings_lrg_odd.row = standings_lrg_even.row;

CREATE VIEW count_players AS
-- count the number of players in players table
  SELECT count(players.id) as count
    FROM players;
