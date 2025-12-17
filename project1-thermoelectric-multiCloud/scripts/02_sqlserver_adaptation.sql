-- =============================================================================
-- Project: Thermoelectric Plant Data Infrastructure
-- Description: DDL - Tables and Operational Logic
-- Author: Gideao Amaral
-- =============================================================================

-- Switching context to PDB
ALTER SESSION SET CONTAINER = PDB_PROJETO_DE_BLOCO;

-- 1. BASE TABLES (EQUIPMENT & ADMINISTRATION)
--------------------------------------------------------------------------------

CREATE TABLE equipamento (
    id_equipamento    INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    nome_equipamento  VARCHAR2(20),
    tipo_equipamento  VARCHAR2(20),
    fabricante_equip  VARCHAR2(20),
    CONSTRAINT PK_id_equipamento PRIMARY KEY (id_equipamento)
);

CREATE TABLE relatorio (
    id_relatorio      INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    nome_relatorio    VARCHAR2(20),
    tipo_relatorio    VARCHAR2(20),
    periodo_inicio    DATE,
    periodo_fim       DATE,
    caminho_relatorio VARCHAR2(256),
    CONSTRAINT PK_id_relatorio PRIMARY KEY (id_relatorio)
);

CREATE TABLE usuario (
    id_usuario   INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    nome_usuario VARCHAR2(20),
    nivel_acesso VARCHAR2(20),
    CONSTRAINT PK_id_usuario PRIMARY KEY (id_usuario)
);

-- 2. EQUIPMENT SUB-LEVELS (SENSORS & MANAGEMENT)
--------------------------------------------------------------------------------

CREATE TABLE sensor (
    id_sensor       INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    tag_sensor      VARCHAR2(20),
    id_equipamento  INTEGER,
    variavel_sensor VARCHAR2(20),
    unidade_sensor  VARCHAR2(10),
    CONSTRAINT PK_id_sensor PRIMARY KEY (id_sensor),
    CONSTRAINT FK_sensor_id_equipamento FOREIGN KEY (id_equipamento) 
        REFERENCES equipamento (id_equipamento)
);

CREATE TABLE equipamento_relatorio (
    id_equipamento INTEGER NOT NULL,
    id_relatorio   INTEGER NOT NULL,
    CONSTRAINT PK_equipamento_relatorio PRIMARY KEY (id_equipamento, id_relatorio),
    CONSTRAINT FK_eq_rel_id_equipamento FOREIGN KEY (id_equipamento) 
        REFERENCES equipamento (id_equipamento),
    CONSTRAINT FK_eq_rel_id_relatorio FOREIGN KEY (id_relatorio) 
        REFERENCES relatorio (id_relatorio)
);

-- 3. OPERATIONAL LOGS & KPIs
--------------------------------------------------------------------------------

CREATE TABLE medicao (
    id_medicao     INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    id_sensor      INTEGER,
    valor_medicao  NUMBER(10,2),
    status_medicao CHAR(2),
    CONSTRAINT PK_id_medicao PRIMARY KEY (id_medicao),
    CONSTRAINT FK_medicao_id_sensor FOREIGN KEY (id_sensor) 
        REFERENCES sensor (id_sensor)
);

CREATE TABLE kpi (
    id_kpi         INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    nome_kpi       VARCHAR2(20),
    id_equipamento INTEGER,
    tipo_kpi       VARCHAR2(20),
    valor_kpi      NUMBER(10,2),
    CONSTRAINT PK_id_kpi PRIMARY KEY (id_kpi),
    CONSTRAINT FK_kpi_id_equipamento FOREIGN KEY (id_equipamento) 
        REFERENCES equipamento (id_equipamento)
);

CREATE TABLE desempenho (
    id_desempenho    INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    id_equipamento   INTEGER,
    potencia_ativa   NUMBER(10,2),
    potencia_reativa NUMBER(10,2),
    consumo_gas      NUMBER(10,2),
    CONSTRAINT PK_id_desempenho PRIMARY KEY (id_desempenho),
    CONSTRAINT FK_desemp_id_equipamento FOREIGN KEY (id_equipamento) 
        REFERENCES equipamento (id_equipamento)
);

-- 4. INCIDENT & MAINTENANCE MANAGEMENT
--------------------------------------------------------------------------------

CREATE TABLE falha (
    id_falha               INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    id_equipamento         INTEGER,
    descricao_falha        VARCHAR2(50),
    timestamp_inicio_falha TIMESTAMP,
    timestamp_fim_falha    TIMESTAMP,
    duracao_minutos        NUMBER(10,2), -- Coluna para cálculo automático via Trigger
    CONSTRAINT PK_id_falha PRIMARY KEY (id_falha),
    CONSTRAINT FK_falha_id_equipamento FOREIGN KEY (id_equipamento) 
        REFERENCES equipamento (id_equipamento)
);

CREATE TABLE manutencao (
    id_manutencao   INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    id_equipamento  INTEGER,
    tipo_manutencao VARCHAR2(20),
    data_manutencao DATE,
    CONSTRAINT PK_id_manutencao PRIMARY KEY (id_manutencao),
    CONSTRAINT FK_manut_id_equipamento FOREIGN KEY (id_equipamento) 
        REFERENCES equipamento (id_equipamento)
);

CREATE TABLE alerta (
    id_alerta        INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    id_sensor        INTEGER,
    threshold_alerta NUMBER(10,2),
    timestamp_alerta TIMESTAMP,
    tipo_alerta      VARCHAR2(20),
    CONSTRAINT PK_id_alerta PRIMARY KEY (id_alerta),
    CONSTRAINT FK_alerta_id_sensor FOREIGN KEY (id_sensor) 
        REFERENCES sensor (id_sensor)
);

-- 5. BUSINESS LOGIC (TRIGGER)
--------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER TRG_CALC_DURACAO_FALHA
BEFORE INSERT OR UPDATE ON falha
FOR EACH ROW
BEGIN
    IF :NEW.timestamp_fim_falha IS NOT NULL THEN
        -- Cálculo da duração em minutos para relatórios de KPI de Disponibilidade
        :NEW.duracao_minutos := (CAST(:NEW.timestamp_fim_falha AS DATE) - CAST(:NEW.timestamp_inicio_falha AS DATE)) * 24 * 60;
    END IF;
END;
/
