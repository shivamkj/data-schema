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
  description TEXT CHECK (LENGTH(description) <= 100)
);
