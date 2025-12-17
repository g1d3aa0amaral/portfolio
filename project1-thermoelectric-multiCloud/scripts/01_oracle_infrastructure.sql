-- =============================================================================
-- Project: Thermoelectric Plant Data Infrastructure
-- Description: PDB, Tablespace, and User & Security
-- Author: Gideao Amaral
-- =============================================================================

-- 1. PDB Creation

CREATE PLUGGABLE DATABASE PDB_PROJETO_DE_BLOCO 
ADMIN USER pdb_admin IDENTIFIED BY **********
FILE_NAME_CONVERT = ('/u01/datafiles/GAMARALDB/pdbseed/', '/u01/datafiles/GAMARALDB/PDB_PROJETO/');

-- open PDB and save state 
ALTER PLUGGABLE DATABASE PDB_PROJETO_DE_BLOCO OPEN;
ALTER PLUGGABLE DATABASE PDB_PROJETO_DE_BLOCO SAVE STATE;

-- alter session from CBD to PDB created
ALTER SESSION SET CONTAINER = PDB_PROJETO_DE_BLOCO;

-- 2. Tablespace Creation

CREATE TABLESPACE TB_PROJETO_DE_BLOCO
DATAFILE SIZE 500M 
AUTOEXTEND ON NEXT 50M MAXSIZE 1G
LOGGING
EXTENT MANAGEMENT LOCAL;

-- 3. User & Security

CREATE USER gideao_amaral_bd_usu IDENTIFIED BY **********
DEFAULT TABLESPACE TABLESPACE TB_PROJETO_DE_BLOCO
TEMPORARY TABLESPACE TEMP;

-- tb quota
ALTER USER gideao_amaral_bd_usu QUOTA 1G ON TB_PROJETO_DE_BLOCO;

-- roles
GRANT CONNECT, RESOURCE TO gideao_amaral_bd_usu;
GRANT CREATE VIEW, CREATE TRIGGER, CREATE PROCEDURE, CREATE SEQUENCE TO gideao_amaral_bd_usu;
GRANT ANALYZE ANY TO gideao_amaral_bd_usu;
