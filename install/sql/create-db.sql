--BEGIN;

--\set ON_ERROR_STOP

create database shoplist ;

create role shoplist_read;
create role shoplist_write;

ALTER USER shoplist_read WITH PASSWORD 'password';
ALTER USER shoplist_write WITH PASSWORD 'password';

ALTER ROLE shoplist_read WITH LOGIN;
ALTER ROLE shoplist_write WITH LOGIN;


revoke connect on database shoplist from public;
--REVOKE
grant connect on database shoplist to shoplist_read;
-- GRANT
grant connect on database shoplist to shoplist_write;



