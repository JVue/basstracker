CREATE TABLE IF NOT EXISTS basstracker (
  id            SERIAL PRIMARY KEY,
  date          VARCHAR(20),
  time          VARCHAR(20),
  angler        VARCHAR(100),
  event         VARCHAR(100),
  weight        VARCHAR(20),
  weight_decimal NUMERIC(6,2),
  weight_oz     NUMERIC(6,2),
  bass_type     VARCHAR(50),
  state         VARCHAR(50),
  lake          VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS basstracker_anglers (
  id     SERIAL PRIMARY KEY,
  angler VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS basstracker_events (
  id    SERIAL PRIMARY KEY,
  event VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS basstracker_lakes (
  id   SERIAL PRIMARY KEY,
  lake VARCHAR(100) UNIQUE NOT NULL
);
