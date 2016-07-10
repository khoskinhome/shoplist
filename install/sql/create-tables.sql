BEGIN;

\set ON_ERROR_STOP

-- http://stackoverflow.com/questions/2647158/how-can-i-hash-passwords-in-postgresql

-- sudo apt-get install postgresql postgresql-contrib libpq-dev

-- sql command inside of psql enable the crypto:
-- create extension pgcrypto

---------------------
-- users
---------------------
--CREATE SEQUENCE users_seq;
--GRANT SELECT ON users_seq TO khaospy_read;
--GRANT ALL ON users_seq TO khaospy_write;
--create table users (
--    id INTEGER PRIMARY KEY DEFAULT nextval('users_seq') NOT NULL,
--    username                        text not null unique,
--    name                            text NOT NULL UNIQUE,
--    email                           text not null unique,
--    passhash                        text NOT NULL,
--    passhash_expire                 timestamp with time zone,
--    passhash_must_change            boolean,
--    is_api_user                     boolean not null default false,
--    is_admin                        boolean not null default false,
--    can_remote                      boolean not null default false,
--    mobile_phone                    text not null unique
--);
--GRANT SELECT ON users TO khaospy_read;
--GRANT ALL ON users TO khaospy_write;

--------------------
-- item_groups
--------------------
CREATE SEQUENCE item_groups_seq;
GRANT SELECT ON item_groups_seq TO shoplist_read;
GRANT ALL ON item_groups_seq TO shoplist_write;
CREATE TABLE item_groups (
    id            INTEGER PRIMARY KEY DEFAULT nextval('item_groups_seq') NOT NULL,
    name          TEXT NOT NULL UNIQUE,
    tag           TEXT NOT NULL UNIQUE,
    sequence      integer
);
GRANT SELECT ON item_groups TO shoplist_read;
GRANT ALL    ON item_groups TO shoplist_write;

-- chilled, fruit-n-veg, cleaning, toiletries, cake-n-biscuits, savouries, tinned, drinks

--------------------
-- shops
--------------------
CREATE SEQUENCE shops_seq;
GRANT SELECT ON shops_seq TO shoplist_read;
GRANT ALL ON shops_seq TO shoplist_write;
CREATE TABLE shops (
    id            INTEGER PRIMARY KEY DEFAULT nextval('shops_seq') NOT NULL,
    name          TEXT NOT NULL UNIQUE,
    tag           TEXT NOT NULL UNIQUE
);
GRANT SELECT ON shops TO shoplist_read;
GRANT ALL    ON shops TO shoplist_write;

-- (A)sda, (L)idl, (I)celand, (W)ilko, (S)ainsburys

--------------------
-- lists
--------------------
CREATE SEQUENCE lists_seq;
GRANT SELECT ON lists_seq TO shoplist_read;
GRANT ALL ON lists_seq TO shoplist_write;
CREATE TABLE lists (
    id            INTEGER PRIMARY KEY DEFAULT nextval('lists_seq') NOT NULL,
    name          TEXT NOT NULL UNIQUE,
    create_date   timestamp with time zone NOT NULL
);
GRANT SELECT ON lists TO shoplist_read;
GRANT ALL    ON lists TO shoplist_write;

--------------------
-- items
--------------------
CREATE SEQUENCE items_seq;
GRANT SELECT ON items_seq TO shoplist_read;
GRANT ALL ON items_seq TO shoplist_write;
CREATE TABLE items (
    id            INTEGER PRIMARY KEY DEFAULT nextval('items_seq') NOT NULL,
    item_group_id INTEGER NOT NULL REFERENCES item_groups,
    show_item     BOOLEAN DEFAULT FALSE,
    name          TEXT NOT NULL UNIQUE
);
GRANT SELECT ON items TO shoplist_read;
GRANT ALL    ON items TO shoplist_write;

--------------------
-- item_lists
--------------------
CREATE SEQUENCE item_lists_seq;
GRANT SELECT ON item_lists_seq TO shoplist_read;
GRANT ALL ON item_lists_seq TO shoplist_write;
CREATE TABLE item_lists (
    id INTEGER PRIMARY KEY DEFAULT nextval('item_lists_seq') NOT NULL,
--    user_id       INTEGER NOT NULL REFERENCES users,
    item_id       INTEGER NOT NULL REFERENCES items,
    list_id       INTEGER NOT NULL REFERENCES lists,
    price         REAL,
    priority      integer not null

    -- priority ( 1 -> 3 ) 1 == Need, 2 == would-like , 3 == maybe
);
GRANT SELECT ON item_lists TO shoplist_read;
GRANT ALL    ON item_lists TO shoplist_write;

--------------------
-- item_shops
--------------------
CREATE SEQUENCE item_shops_seq;
GRANT SELECT ON item_shops_seq TO shoplist_read;
GRANT ALL ON item_shops_seq TO shoplist_write;
CREATE TABLE item_shops (
    shop_id       INTEGER NOT NULL REFERENCES shops,
    item_id       INTEGER NOT NULL REFERENCES items,
    price         REAL
);
GRANT SELECT ON item_shops TO shoplist_read;
GRANT ALL    ON item_shops TO shoplist_write;


