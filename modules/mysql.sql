CREATE TABLE _class (
  id   SMALLINT PRIMARY KEY AUTO_INCREMENT,
  name TEXT NOT NULL
) AUTO_INCREMENT = 1;

CREATE TABLE section (
  id       SMALLINT PRIMARY KEY AUTO_INCREMENT,
  name     TEXT NOT NULL,
  class_id SMALLINT NOT NULL REFERENCES _class (id)
) AUTO_INCREMENT = 1;

CREATE TABLE session (
  id         SMALLINT PRIMARY KEY AUTO_INCREMENT,
  name       TEXT NOT NULL,
  start_date INTEGER NOT NULL,
  end_date   INTEGER NOT NULL
) AUTO_INCREMENT = 1;


CREATE TABLE student (
  id          INTEGER PRIMARY KEY AUTO_INCREMENT,
  first_name  VARCHAR(100) NOT NULL,
  last_name   VARCHAR(100),
  profile_pic VARCHAR(250),
  section_id  SMALLINT NOT NULL REFERENCES section (id)
) AUTO_INCREMENT = 1;


CREATE TABLE attendance (
  student_id  INTEGER REFERENCES student (id),
  date        INTEGER,
  section_id  SMALLINT NOT NULL REFERENCES section (id),
  is_absent   BOOLEAN,
  is_half_day BOOLEAN,
  is_late     BOOLEAN,
  PRIMARY KEY (student_id, date)
);

CREATE TABLE off_day (
  date        INTEGER,
  class_id    SMALLINT REFERENCES _class (id),
  section_id  SMALLINT REFERENCES section (id),
  is_holiday  BOOLEAN,
  is_weekend  BOOLEAN,
  is_half_day BOOLEAN,
  description VARCHAR(100)
);


CREATE TABLE payments (
  id          INTEGER PRIMARY KEY AUTO_INCREMENT,
  student_id  INTEGER REFERENCES student (id),
  due_amount  SMALLINT NOT NULL,
  paid_amount SMALLINT NOT NULL,
  concession  SMALLINT,
  late_fees   SMALLINT,
  status      SMALLINT NOT NULL CHECK (status > 0 AND status < 4),
  section_id  SMALLINT NOT NULL REFERENCES section (id),
  paid_date   INTEGER
) AUTO_INCREMENT = 1;

CREATE TABLE payment_history (
  payment_date INTEGER NOT NULL,
  student_id   INTEGER NOT NULL,
  amount       SMALLINT NOT NULL,
  mode         SMALLINT NOT NULL CHECK (mode > 0 AND mode < 4),
  collected_by INTEGER,
  status       SMALLINT NOT NULL CHECK (status > 0 AND status < 4),
  payments_id  INTEGER NOT NULL REFERENCES payments (id)
);

CREATE TABLE receipt_particular (
  payments_id     INTEGER PRIMARY KEY REFERENCES payments (id),
  particular_name TEXT NOT NULL,
  amount          SMALLINT NOT NULL
);

CREATE TABLE fees_details (
  id       SMALLINT PRIMARY KEY AUTO_INCREMENT,
  name     TEXT,
  due_date INTEGER
) AUTO_INCREMENT = 1;

CREATE TABLE class_fees (
  fees_details_id SMALLINT REFERENCES fees_details (id),
  section_id      SMALLINT REFERENCES section (id),
  PRIMARY KEY (fees_details_id, section_id)
);

CREATE TABLE fees_particulars (
  id              SMALLINT PRIMARY KEY AUTO_INCREMENT,
  name            TEXT NOT NULL,
  amount          SMALLINT NOT NULL,
  frequency       SMALLINT NOT NULL CHECK (frequency > 0 AND frequency < 4),
  optional        BOOLEAN,
  variable        BOOLEAN,
  fees_details_id INTEGER NOT NULL REFERENCES fees_details (id)
) AUTO_INCREMENT = 1;

CREATE TABLE fees_config (
  fees_particulars_id SMALLINT REFERENCES fees_particulars (id),
  student_id          INTEGER REFERENCES student (id),
  amount              SMALLINT,
  applicable          BOOLEAN,
  PRIMARY KEY (fees_particulars_id, student_id)
);
