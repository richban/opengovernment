 CREATE TABLE ft_spending_2 (
    id SERIAL PRIMARY KEY NOT NULL,
    transaction_type_id integer NOT NULL,
    date_id integer NOT NULL,
    product_id integer NOT NULL,
    geography_id integer NOT NULL,
    agency_id integer NOT NULL,
    recipient_id integer NOT NULL,
    award_id integer NOT NULL,
    transaction_id text,
    award_amount numeric,
    transactions integer,
    last_modified_date date,
    date_added date
);

CREATE TABLE ft_spending_2_16M01(
    PRIMARY KEY (id, last_modified_date),
    CHECK ( last_modified_date >= DATE '2016-01-01' and last_modified_date < DATE '2016-02-01')
) INHERITS (ft_spending_2);
CREATE INDEX idx_16M01 ON ft_spending_2_16M01 (last_modified_date);

CREATE TABLE ft_spending_2_16M02(
    PRIMARY KEY (id, last_modified_date),
    CHECK ( last_modified_date >= DATE '2016-02-01' and last_modified_date < DATE '2016-03-01')
) INHERITS (ft_spending_2);
CREATE INDEX idx_16M02 ON ft_spending_2_16M02 (last_modified_date);

CREATE TABLE ft_spending_2_16M03(
    PRIMARY KEY (id, last_modified_date),
    CHECK ( last_modified_date >= DATE '2016-03-01' and last_modified_date < DATE '2016-04-01')
) INHERITS (ft_spending_2);
CREATE INDEX idx_16M03 ON ft_spending_2_16M03 (last_modified_date);

CREATE TABLE ft_spending_2_16M04(
    PRIMARY KEY (id, last_modified_date),
    CHECK ( last_modified_date >= DATE '2016-04-01' and last_modified_date < DATE '2016-05-01')
) INHERITS (ft_spending_2);
CREATE INDEX idx_16M04 ON ft_spending_2_16M04 (last_modified_date);

CREATE TABLE ft_spending_2_16M05(
    PRIMARY KEY (id, last_modified_date),
    CHECK ( last_modified_date >= DATE '2016-05-01' and last_modified_date < DATE '2016-06-01')
) INHERITS (ft_spending_2);
CREATE INDEX idx_16M05 ON ft_spending_2_16M05 (last_modified_date);

CREATE TABLE ft_spending_2_16M06(
    PRIMARY KEY (id, last_modified_date),
    CHECK ( last_modified_date >= DATE '2016-06-01' and last_modified_date < DATE '2016-07-01')
) INHERITS (ft_spending_2);
CREATE INDEX idx_16M06 ON ft_spending_2_16M06 (last_modified_date);

CREATE TABLE ft_spending_2_16M07(
    PRIMARY KEY (id, last_modified_date),
    CHECK ( last_modified_date >= DATE '2016-07-01' and last_modified_date < DATE '2016-08-01')
) INHERITS (ft_spending_2);
CREATE INDEX idx_16M07 ON ft_spending_2_16M07 (last_modified_date);

CREATE TABLE ft_spending_2_16M08(
    PRIMARY KEY (id, last_modified_date),
    CHECK ( last_modified_date >= DATE '2016-08-01' and last_modified_date < DATE '2016-09-01')
) INHERITS (ft_spending_2);
CREATE INDEX idx_16M08 ON ft_spending_2_16M08 (last_modified_date);

CREATE TABLE ft_spending_2_16M09(
    PRIMARY KEY (id, last_modified_date),
    CHECK ( last_modified_date >= DATE '2016-09-01' and last_modified_date < DATE '2016-10-01')
) INHERITS (ft_spending_2);
CREATE INDEX idx_16M09 ON ft_spending_2_16M09 (last_modified_date);

CREATE TABLE ft_spending_2_16M10(
    PRIMARY KEY (id, last_modified_date),
    CHECK ( last_modified_date >= DATE '2016-10-01' and last_modified_date < DATE '2016-11-01')
) INHERITS (ft_spending_2);
CREATE INDEX idx_16M10 ON ft_spending_2_16M10 (last_modified_date);

CREATE TABLE ft_spending_2_16M11(
    PRIMARY KEY (id, last_modified_date),
    CHECK ( last_modified_date >= DATE '2016-11-01' and last_modified_date < DATE '2016-12-01')
) INHERITS (ft_spending_2);
CREATE INDEX idx_16M11 ON ft_spending_2_16M11 (last_modified_date);

CREATE TABLE ft_spending_2_16M12(
    PRIMARY KEY (id, last_modified_date),
    CHECK ( last_modified_date >= DATE '2016-12-01' and last_modified_date < DATE '2017-01-01')
) INHERITS (ft_spending_2);
CREATE INDEX idx_16M12 ON ft_spending_2_16M12 (last_modified_date);

CREATE TABLE ft_spending_2_15M01(
    PRIMARY KEY (id, last_modified_date),
    CHECK ( last_modified_date >= DATE '2015-01-01' and last_modified_date < DATE '2015-02-01')
) INHERITS (ft_spending_2);
CREATE INDEX idx_15M01 ON ft_spending_2_15M01 (last_modified_date);

CREATE TABLE ft_spending_2_15M02(
    PRIMARY KEY (id, last_modified_date),
    CHECK ( last_modified_date >= DATE '2016-02-01' and last_modified_date < DATE '2015-03-01')
) INHERITS (ft_spending_2);
CREATE INDEX idx_15M02 ON ft_spending_2_15M02 (last_modified_date);

CREATE TABLE ft_spending_2_15M03(
    PRIMARY KEY (id, last_modified_date),
    CHECK ( last_modified_date >= DATE '2015-03-01' and last_modified_date < DATE '2015-04-01')
) INHERITS (ft_spending_2);
CREATE INDEX idx_15M03 ON ft_spending_2_15M03 (last_modified_date);

CREATE TABLE ft_spending_2_15M04(
    PRIMARY KEY (id, last_modified_date),
    CHECK ( last_modified_date >= DATE '2015-04-01' and last_modified_date < DATE '2015-05-01')
) INHERITS (ft_spending_2);
CREATE INDEX idx_15M04 ON ft_spending_2_15M04 (last_modified_date);

CREATE TABLE ft_spending_2_15M05(
    PRIMARY KEY (id, last_modified_date),
    CHECK ( last_modified_date >= DATE '2015-05-01' and last_modified_date < DATE '2015-06-01')
) INHERITS (ft_spending_2);
CREATE INDEX idx_15M05 ON ft_spending_2_15M05 (last_modified_date);

CREATE TABLE ft_spending_2_15M06(
    PRIMARY KEY (id, last_modified_date),
    CHECK ( last_modified_date >= DATE '2015-06-01' and last_modified_date < DATE '2015-07-01')
) INHERITS (ft_spending_2);
CREATE INDEX idx_15M06 ON ft_spending_2_15M06 (last_modified_date);

CREATE TABLE ft_spending_2_15M07(
    PRIMARY KEY (id, last_modified_date),
    CHECK ( last_modified_date >= DATE '2015-07-01' and last_modified_date < DATE '2015-08-01')
) INHERITS (ft_spending_2);
CREATE INDEX idx_15M07 ON ft_spending_2_15M07 (last_modified_date);

CREATE TABLE ft_spending_2_15M08(
    PRIMARY KEY (id, last_modified_date),
    CHECK ( last_modified_date >= DATE '2015-08-01' and last_modified_date < DATE '2016-05-01')
) INHERITS (ft_spending_2);
CREATE INDEX idx_15M08 ON ft_spending_2_15M08 (last_modified_date);

CREATE TABLE ft_spending_2_15M09(
    PRIMARY KEY (id, last_modified_date),
    CHECK ( last_modified_date >= DATE '2015-09-01' and last_modified_date < DATE '2015-10-01')
) INHERITS (ft_spending_2);
CREATE INDEX idx_15M09 ON ft_spending_2_15M09 (last_modified_date);

CREATE TABLE ft_spending_2_15M10(
    PRIMARY KEY (id, last_modified_date),
    CHECK ( last_modified_date >= DATE '2015-10-01' and last_modified_date < DATE '2015-11-01')
) INHERITS (ft_spending_2);
CREATE INDEX idx_15M10 ON ft_spending_2_15M10 (last_modified_date);

CREATE TABLE ft_spending_2_15M11(
    PRIMARY KEY (id, last_modified_date),
    CHECK ( last_modified_date >= DATE '2015-11-01' and last_modified_date < DATE '2015-12-01')
) INHERITS (ft_spending_2);
CREATE INDEX idx_15M11 ON ft_spending_2_15M11 (last_modified_date);

CREATE TABLE ft_spending_2_15M12(
    PRIMARY KEY (id, last_modified_date),
    CHECK ( last_modified_date >= DATE '2015-12-01' and last_modified_date < DATE '2016-01-01')
) INHERITS (ft_spending_2);
CREATE INDEX idx_15M12 ON ft_spending_2_15M12 (last_modified_date);

CREATE OR REPLACE FUNCTION ft_partition_trigger()
RETURNS TRIGGER AS $$
BEGIN
	IF
    (NEW.last_modified_date >= DATE '2016-01-01' and NEW.last_modified_date < DATE '2016-02-01') THEN
    INSERT INTO ft_spending_2_16M01 VALUES (NEW.*);
    ELSIF (NEW.last_modified_date >= DATE '2016-02-01' and NEW.last_modified_date < DATE '2016-03-01') THEN
    INSERT INTO ft_spending_2_16M02 VALUES (NEW.*);
    ELSIF (NEW.last_modified_date >= DATE '2016-03-01' and NEW.last_modified_date < DATE '2016-04-01') THEN
    INSERT INTO ft_spending_2_16M03 VALUES (NEW.*);
    ELSIF (NEW.last_modified_date >= DATE '2016-04-01' and NEW.last_modified_date < DATE '2016-05-01') THEN
    INSERT INTO ft_spending_2_16M04 VALUES (NEW.*);
    ELSIF (NEW.last_modified_date >= DATE '2016-05-01' and NEW.last_modified_date < DATE '2016-06-01') THEN
    INSERT INTO ft_spending_2_16M05 VALUES (NEW.*);
    ELSIF (NEW.last_modified_date >= DATE '2016-06-01' and NEW.last_modified_date < DATE '2016-07-01') THEN
    INSERT INTO ft_spending_2_16M06 VALUES (NEW.*);
    ELSIF (NEW.last_modified_date >= DATE '2016-07-01' and NEW.last_modified_date < DATE '2016-08-01') THEN
    INSERT INTO ft_spending_2_16M07 VALUES (NEW.*);
    ELSIF (NEW.last_modified_date >= DATE '2016-08-01' and NEW.last_modified_date < DATE '2016-09-01') THEN
    INSERT INTO ft_spending_2_16M08 VALUES (NEW.*);
    ELSIF (NEW.last_modified_date >= DATE '2016-09-01' and NEW.last_modified_date < DATE '2016-10-01') THEN
    INSERT INTO ft_spending_2_16M09 VALUES (NEW.*);
    ELSIF (NEW.last_modified_date >= DATE '2016-10-01' and NEW.last_modified_date < DATE '2016-11-01') THEN
    INSERT INTO ft_spending_2_16M10 VALUES (NEW.*);
    ELSIF (NEW.last_modified_date >= DATE '2016-11-01' and NEW.last_modified_date < DATE '2016-12-01') THEN
    INSERT INTO ft_spending_2_16M11 VALUES (NEW.*);
    ELSIF (NEW.last_modified_date >= DATE '2016-12-01' and NEW.last_modified_date < DATE '2017-01-01') THEN
    INSERT INTO ft_spending_2_16M12 VALUES (NEW.*);
    ELSIF (NEW.last_modified_date >= DATE '2015-01-01' and NEW.last_modified_date < DATE '2015-02-01') THEN
    INSERT INTO ft_spending_2_15M01 VALUES (NEW.*);
    ELSIF (NEW.last_modified_date >= DATE '2015-02-01' and NEW.last_modified_date < DATE '2015-03-01') THEN
    INSERT INTO ft_spending_2_15M02 VALUES (NEW.*);
    ELSIF (NEW.last_modified_date >= DATE '2015-03-01' and NEW.last_modified_date < DATE '2015-04-01') THEN
    INSERT INTO ft_spending_2_15M03 VALUES (NEW.*);
    ELSIF (NEW.last_modified_date >= DATE '2015-04-01' and NEW.last_modified_date < DATE '2015-05-01') THEN
    INSERT INTO ft_spending_2_15M04 VALUES (NEW.*);
    ELSIF (NEW.last_modified_date >= DATE '2015-05-01' and NEW.last_modified_date < DATE '2015-06-01') THEN
    INSERT INTO ft_spending_2_15M05 VALUES (NEW.*);
    ELSIF (NEW.last_modified_date >= DATE '2015-06-01' and NEW.last_modified_date < DATE '2015-07-01') THEN
    INSERT INTO ft_spending_2_15M06 VALUES (NEW.*);
    ELSIF (NEW.last_modified_date >= DATE '2015-07-01' and NEW.last_modified_date < DATE '2015-08-01') THEN
    INSERT INTO ft_spending_2_15M07 VALUES (NEW.*);
    ELSIF (NEW.last_modified_date >= DATE '2015-08-01' and NEW.last_modified_date < DATE '2015-09-01') THEN
    INSERT INTO ft_spending_2_15M08 VALUES (NEW.*);
    ELSIF (NEW.last_modified_date >= DATE '2015-09-01' and NEW.last_modified_date < DATE '2015-10-01') THEN
    INSERT INTO ft_spending_2_15M09 VALUES (NEW.*);
    ELSIF (NEW.last_modified_date >= DATE '2015-10-01' and NEW.last_modified_date < DATE '2015-11-01') THEN
    INSERT INTO ft_spending_2_15M10 VALUES (NEW.*);
    ELSIF (NEW.last_modified_date >= DATE '2015-11-01' and NEW.last_modified_date < DATE '2015-12-01') THEN
    INSERT INTO ft_spending_2_15M11 VALUES (NEW.*);
    ELSIF (NEW.last_modified_date >= DATE '2015-12-01' and NEW.last_modified_date < DATE '2016-01-01') THEN
    INSERT INTO ft_spending_2_15M12 VALUES (NEW.*);
    ELSE
      RAISE EXCEPTION 'DATE OUT OF RANGE!';
  END IF;
  RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER insert_ft_spending_2
	BEFORE INSERT ON ft_spending_2
		FOR EACH ROW EXECUTE PROCEDURE ft_partition_trigger_2();

SET constraint_exclusion = on;


