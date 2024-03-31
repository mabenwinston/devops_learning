---------------------------------------------------------------------- POSTGRES SQL --------------------------------------------------------------------------

--1) TABLESPACE DELETE/CREATE

SELECT spcname FROM pg_tablespace;

DROP TABLESPACE <tablespace_name>;

CREATE TABLESPACE <tablespace_name> OWNER <SCHEMA_NAME> LOCATION  '/home3/TEMP_AUTO_TS';

--2) CREATE/DROP DATABASE & SCHEMA

DROP DATABASE <DATABASE_NAME>;

DROP SCHEMA <SCHEMA_NAME> cascade; 

CREATE DATABASE <DATABASE_NAME>;;

CREATE SCHEMA <SCHEMA_NAME>;

GRANT ALL ON SCHEMA <SCHEMA_NAME> TO postgres;

set search_path = "<SCHEMA_NAME>";

ALTER DATABASE <DATABASE_NAME> SET search_path TO <SCHEMA_NAME>;

--3) EXPORT IN POSTGRES

pg_dump -d <DATABASE_NAME> -h <HOST-IP> -U postgres --schema=<SCHEMA_NAME> > EXPORT_01MAR23.sql

psql -h <HOST-IP> -U postgres -d <DATABASE_NAME> -f /home3/TEMP/EXPORT_01MAR23.sql > IMPORT_01MAR23.log

--4) COMMANDS OF POSTGRES

\l - To check databases

\c <database_name> - To connect to database

\dn - To check schemas in a database

\db - To check tablespaces in a database

pg_ctl restart - To restart database