CREATE TABLE _class (
  id   INTEGER PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE section (
  id       INTEGER PRIMARY KEY,
  name     TEXT NOT NULL,
  class_id INTEGER NOT NULL REFERENCES _class (id)
);

CREATE TABLE session (
  id         INTEGER PRIMARY KEY,
  name       TEXT NOT NULL,
  start_date INTEGER NOT NULL,
  end_date   INTEGER NOT NULL
);


CREATE TABLE student (
  id          INTEGER PRIMARY KEY,
  first_name  TEXT CHECK (LENGTH(first_name) <= 100) NOT NULL,
  last_name   TEXT CHECK (LENGTH(last_name) <= 100),
  profile_pic TEXT CHECK (LENGTH(profile_pic) <= 250),
  section_id  INTEGER NOT NULL REFERENCES section (id)
);


CREATE TABLE attendance (
  student_id  INTEGER REFERENCES student (id),
  date        INTEGER,
  section_id  INTEGER NOT NULL REFERENCES section (id),
  is_absent   BOOLEAN,
  is_half_day BOOLEAN,
  is_late     BOOLEAN,
  PRIMARY KEY (student_id, date)
);

CREATE TABLE off_day (
  date        INTEGER,
  class_id    INTEGER REFERENCES _class (id),
  section_id  INTEGER REFERENCES section (id),
  is_holiday  BOOLEAN,
  is_weekend  BOOLEAN,
  is_half_day BOOLEAN,
  description TEXT CHECK (LENGTH(description) <= 100)
);


CREATE TABLE payments (
  id          INTEGER PRIMARY KEY,
  student_id  INTEGER REFERENCES student (id),
  due_amount  INTEGER NOT NULL,
  paid_amount INTEGER NOT NULL,
  concession  INTEGER,
  late_fees   INTEGER,
  status      INTEGER NOT NULL CHECK (status > 0 AND status < 4),
  section_id  INTEGER NOT NULL REFERENCES section (id),
  paid_date   INTEGER
);

CREATE TABLE payment_history (
  payment_date INTEGER NOT NULL,
  student_id   INTEGER NOT NULL,
  amount       INTEGER NOT NULL,
  mode         INTEGER NOT NULL CHECK (mode > 0 AND mode < 4),
  collected_by INTEGER,
  status       INTEGER NOT NULL CHECK (status > 0 AND status < 4),
  payments_id  INTEGER NOT NULL REFERENCES payments (id)
);

CREATE TABLE receipt_particular (
  payments_id     INTEGER PRIMARY KEY REFERENCES payments (id),
  particular_name TEXT NOT NULL,
  amount          INTEGER NOT NULL
);

CREATE TABLE fees_details (
  id       INTEGER PRIMARY KEY,
  name     TEXT,
  due_date INTEGER
);

CREATE TABLE class_fees (
  fees_details_id INTEGER REFERENCES fees_details (id),
  section_id      INTEGER REFERENCES section (id),
  PRIMARY KEY (fees_details_id, section_id)
);

CREATE TABLE fees_particulars (
  id              INTEGER PRIMARY KEY,
  name            TEXT NOT NULL,
  amount          INTEGER NOT NULL,
  frequency       INTEGER NOT NULL CHECK (frequency > 0 AND frequency < 4),
  optional        BOOLEAN,
  variable        BOOLEAN,
  fees_details_id INTEGER NOT NULL REFERENCES fees_details (id)
);

CREATE TABLE fees_config (
  fees_particulars_id INTEGER REFERENCES fees_particulars (id),
  student_id          INTEGER REFERENCES student (id),
  amount              INTEGER,
  applicable          BOOLEAN,
  PRIMARY KEY (fees_particulars_id, student_id)
);
