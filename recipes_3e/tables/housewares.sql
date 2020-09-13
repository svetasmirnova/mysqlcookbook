# housewares.sql

# housewares catalogs:
# housewares: fixed-length id substrings
# housewares2: id represented by separate category, serial, country columns
# housewares3: like housewares, but serial number part of id
#   has no leading zeros (variable-length id substrings)
# housewares4: id in n-n-n-n format

DROP TABLE IF EXISTS housewares;
CREATE TABLE housewares
(
  id      VARCHAR(20),
  description VARCHAR(255)
);

INSERT INTO housewares (id,description)
  VALUES
    ('DIN40672US', 'dining table'),
    ('KIT00372UK', 'garbage disposal'),
    ('KIT01729JP', 'microwave oven'),
    ('BED00038SG', 'bedside lamp'),
    ('BTH00485US', 'shower stall'),
    ('BTH00415JP', 'lavatory')
;

SELECT * FROM housewares;

# Alternate representation of the housewares table.  It has the id
# column represented by three columns

DROP TABLE IF EXISTS housewares2;
#@ _CREATE_TABLE_HOUSEWARES2__
CREATE TABLE housewares2
(
  category    VARCHAR(3) NOT NULL,
  serial      INT(5) UNSIGNED ZEROFILL NOT NULL,
  country     VARCHAR(2) NOT NULL,
  description VARCHAR(255),
  PRIMARY KEY (category, country, serial)
);
#@ _CREATE_TABLE_HOUSEWARES2__

INSERT INTO housewares2 (category,serial,country,description)
  VALUES
    ('DIN', 40672, 'US', 'dining table'),
    ('KIT', 372, 'UK', 'garbage disposal'),
    ('KIT', 1729, 'JP', 'microwave oven'),
    ('BED', 38, 'SG', 'bedside lamp'),
    ('BTH', 485, 'US', 'shower stall'),
    ('BTH', 415, 'JP', 'lavatory')
;

SELECT * FROM housewares2;

DROP TABLE IF EXISTS housewares3;
CREATE TABLE housewares3
(
  id      VARCHAR(20),
  description VARCHAR(255)
);

INSERT INTO housewares3 (id,description)
  VALUES
    ('DIN40672US', 'dining table'),
    ('KIT372UK', 'garbage disposal'),
    ('KIT1729JP', 'microwave oven'),
    ('BED38SG', 'bedside lamp'),
    ('BTH485US', 'shower stall'),
    ('BTH415JP', 'lavatory')
;

SELECT * FROM housewares3;

# housewares4 table
# NEED BETTER NAME


DROP TABLE IF EXISTS housewares4;
CREATE TABLE housewares4
(
  id      VARCHAR(20),
  description VARCHAR(255)
);

INSERT INTO housewares4 (id,description)
  VALUES
    ('13-478-92-2', 'dining table'),
    ('873-48-649-63', 'garbage disposal'),
    ('8-4-2-1', 'microwave oven'),
    ('97-681-37-66', 'bedside lamp'),
    ('27-48-534-2', 'shower stall'),
    ('5764-56-89-72', 'lavatory')
;

SELECT * FROM housewares4;

DROP TABLE IF EXISTS hw_category;
CREATE TABLE hw_category
(
  abbrev  VARCHAR(3),
  name  VARCHAR(20)
);

INSERT INTO hw_category (abbrev,name)
  VALUES
    ('DIN', 'dining'),
    ('KIT', 'kitchen'),
    ('BTH', 'bathroom'),
    ('BED', 'bedroom')
;

SELECT * FROM hw_category;
