--BEGIN;

--\set ON_ERROR_STOP

create database shoplist ;

ALTER USER shoplist_read WITH PASSWORD 'password';

ALTER USER shoplist_write WITH PASSWORD 'password';

revoke connect on database shoplist from public;
--REVOKE
grant connect on database shoplist to shoplist_read;
-- GRANT
grant connect on database shoplist to shoplist_write;



