--------------------------------------------------------------ORACLE SQL INTERVIEW----------------------------------------------------------------------

--1) EXPORT COMMAND
nohup expdp IATT1/gbpUpgPwd@ORA19C DIRECTORY=DATA_PUMP_DIR logfile=IATT1_17FEB22.log dumpfile=IATT1_17FEB22.dmp schemas=IATT1 exclude=grant,statistics parallel=4 COMPRESSION=ALL &

nohup expdp IATT1/gbpUpgPwd@ORA19C DIRECTORY=DATA_PUMP_DIR logfile=IATT1_17FEB22.log dumpfile=expdir:IAT_T1-%U.dmp schemas=IATT1 FILESIZE=2G exclude=grant,statistics parallel=4 COMPRESSION=ALL &


--2) IMPORT COMMAND
nohup impdp TEMP/password123@ORA19C DIRECTORY=DATA_PUMP_DIR DUMPFILE=IATT1_17FEB22.dmp LOGFILE=TEMP_Imp_25Jan22_IMP1.log remap_schema=IATT1:TEMP remap_tablespace=TS_IATT1:TEMP_TS &


--3) TABLESPACE & USER CREATION
CREATE TABLESPACE TEMP_TS DATAFILE '/home0/ora19c/app/base/oradata/ORA19C/TEMP_TS.DBF' SIZE 512M AUTOEXTEND ON NEXT 256M MAXSIZE 30G;
ALTER TABLESPACE TEMP_TS ADD DATAFILE '/home0/ora19c/app/base/oradata/ORA19C/TEMP_TS_1.DBF' SIZE 512m AUTOEXTEND ON NEXT 250m MAXSIZE 30G;
ALTER TABLESPACE TEMP_TS ADD DATAFILE '/home0/ora19c/app/base/oradata/ORA19C/TEMP_TS_2.DBF' SIZE 30G

create user TEMP identified by password123 default tablespace TEMP_TS quota unlimited on TEMP_TS;
grant connect,resource,imp_full_database to TEMP;

--4) DROP USER & TABLESPACE
DROP USER TEMP_USER CASCADE;
Drop TABLESPACE TEMP_TS INCLUDING CONTENTS AND DATAFILES;

--5) RESET USER PASSWORD
ALTER USER TEMP_USER IDENTIFIED BY gbpUpgPwd ACCOUNT UNLOCK;

--6) CHECK DBF location & CREATE DATA_PUMP_DIR 
SELECT owner, directory_name, directory_path FROM dba_directories;

CREATE DIRECTORY DATA_PUMP_DIR as 'home0/ora19c/DB_BUMP';

REPLACE DIRECTORY DATA_PUMP_DIR as 'home0/ora19c/DB_BUMP';

SELECT * FROM DBA_DATA_FILES;

--7) KILL CONNECTED SESSION restart DB and listner

SELECT 'ALTER SYSTEM KILL SESSION '''||sid||','||serial#||''' IMMEDIATE;' FROM v$session where username='TEMP';
ALTER SYSTEM KILL SESSION '252,63476' IMMEDIATE;


$ export ORACLE_SID=ORA19C; --tns.ora in $ORACLE_HOME/network/admin entry

$ lsnrctl start
$ lsnrctl stop
$ lsnrctl status

$ STARTUP PFILE=$ORACLE_HOME/admin/$ORACLE_SID/pfile/init2.ora
$ STARTUP;
$ SHUTDOWN IMMEDIATE | NORMAL | ABORT


--8) CHECK TABLESPACE OR USER and SID/INSTANCE
select tablespace_name from all_tables where owner = 'TEMP';
select owner from all_tables where tablespace_name = 'TEMP_TS';

select instance from v$thread;



--9) SQLPLUS CONNECT
sqlplus SCHEMA/password@10.180.40.200:1521/GSC19C


--10) CHECK LOCKED TABLES & EXPIRED USER
SELECT username, account_status FROM dba_users WHERE ACCOUNT_STATUS LIKE '%EXPIRED%';

select session_id from dba_dml_locks where name = 'HBC_TXN_ACTION_BIZ_PROS_CONFIG';


------------------------------------------------- DBA Activity ----------------------------------------------------------------------------------------------

--1. Alter system capacity in oracle

SQL> alter system set sga_max_size=30720M scope=spfile;
System altered.
SQL> alter system set sga_target=30720M scope=spfile;
System altered.
SQL> show parameter sga


--2. Get database info 


select df.tablespace_name "Tablespace",
totalusedspace "Used MB",
(df.totalspace - tu.totalusedspace) "Free MB",
df.totalspace "Total MB",
round(100 * ( (df.totalspace - tu.totalusedspace)/ df.totalspace))
"Pct. Free"
from
(select tablespace_name,
round(sum(bytes) / 1048576) TotalSpace
from dba_data_files
group by tablespace_name) df,
(select round(sum(bytes)/(1024*1024)) totalusedspace, tablespace_name
from dba_segments
group by tablespace_name) tu
where df.tablespace_name = tu.tablespace_name;


--3. Get sid of locker tables

select sid, serial# from v$session where sid in ( select session_id from dba_dml_locks where name = 'temp_table');

--4. Create readuser in a database

create user readuser identified by readuser;
grant create session to readuser;
grant select any table to readuser;


--5. Create DB link between two schema in a database

--# CONNECT PROD AND UAT DB

CREATE DATABASE LINK <PROD_LINK>
CONNECT TO <SCHEMA_NAME> IDENTIFIED BY password123
USING'(DESCRIPTION=
(ADDRESS=
(PROTOCOL=TCP)
(HOST=10.180.40.92)
(PORT=1521))
(CONNECT_DATA=
(SID=ORA19C)))';


-- TAKE BACKUP OF THE EXISTING TABLES
create table PRD_APPLICATION_DETAILS_BACKUP as (select * from PRD_APPLICATION_DETAILS);

-- DELETE THE TABLES
delete from PRD_APPLICATION_DETAILS;

-- INSERT THE DATA FROM FI TO IAT
insert into PRD_APPLICATION_DETAILS (select * from PRD_APPLICATION_DETAILS@<PROD_LINK>);
insert into CH_JOB_PROFILE (select * from CH_JOB_PROFILE@<PROD_LINK>);

-- delete the link
drop database link "<PROD_LINK>"
