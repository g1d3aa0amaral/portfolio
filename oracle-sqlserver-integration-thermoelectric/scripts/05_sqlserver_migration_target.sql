-- =============================================================================
-- Project: Thermoelectric Plant Data Infrastructure
-- Description: Database, Schema, and Tables for Multi-Cloud Migration
-- Author: Gideao Amaral
-- =============================================================================

-- 1. INFRASTRUCTURE SETUP
--------------------------------------------------------------------------------

USE master;
GO

-- Create Database
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'BD_PROJETO_DE_BLOCO')
BEGIN
    CREATE DATABASE BD_PROJETO_DE_BLOCO;
END
GO

USE BD_PROJETO_DE_BLOCO;
GO

-- Create Schema
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'gideao_amaral_bd_usu')
BEGIN
    EXEC('CREATE SCHEMA gideao_amaral_bd_usu');
END
GO

-- 2. TABLES
--------------------------------------------------------------------------------

-- 1. EQUIPAMENTO
CREATE TABLE gideao_amaral_bd_usu.equipamento (
    id_equipamento INT IDENTITY(1,1) PRIMARY KEY,
    nome_equipamento VARCHAR(20),
    tipo_equipamento VARCHAR(20),
    fabricante_equipamento VARCHAR(20)
);
GO

-- 2. KPI
CREATE TABLE gideao_amaral_bd_usu.kpi (
    id_kpi INT IDENTITY(1,1) PRIMARY KEY,
    nome_kpi VARCHAR(20),
    id_equipamento INT,
    tipo_kpi VARCHAR(20),
    valor_kpi DECIMAL(10,2),
    CONSTRAINT FK_kpi_id_equipamento FOREIGN KEY (id_equipamento)
     REFERENCES gideao_amaral_bd_usu.equipamento (id_equipamento)
);
GO

-- 3. FALHA
CREATE TABLE gideao_amaral_bd_usu.falha (
    id_falha INT IDENTITY(1,1) PRIMARY KEY,
    id_equipamento INT,
    descricao_falha VARCHAR(50),
    timestamp_inicio_falha DATETIME2,
    timestamp_fim_falha DATETIME2,
    duracao_minutos DECIMAL(10,2),
    CONSTRAINT FK_falha_id_equipamento FOREIGN KEY (id_equipamento)
     REFERENCES gideao_amaral_bd_usu.equipamento (id_equipamento)
);
GO

-- 4. MANUTENCAO
CREATE TABLE gideao_amaral_bd_usu.manutencao (
    id_manutencao INT IDENTITY(1,1) PRIMARY KEY,
    id_equipamento INT,
    tipo_manutencao VARCHAR(20),
    data_manutencao DATE,
    CONSTRAINT FK_manutencao_id_equipamento FOREIGN KEY (id_equipamento)
     REFERENCES gideao_amaral_bd_usu.equipamento (id_equipamento)
);
GO

-- 5. RELATORIO
CREATE TABLE gideao_amaral_bd_usu.relatorio (
    id_relatorio INT IDENTITY(1,1) PRIMARY KEY,
    nome_relatorio VARCHAR(20),
    tipo_relatorio VARCHAR(20),
    periodo_inicio DATE,
    periodo_fim DATE,
    caminho_relatorio VARCHAR(256)
);
GO

-- 6. EQUIPAMENTO_RELATORIO
CREATE TABLE gideao_amaral_bd_usu.equipamento_relatorio (
    id_equipamento INT NOT NULL,
    id_relatorio INT NOT NULL,
    CONSTRAINT PK_equipamento_relatorio PRIMARY KEY (id_equipamento, id_relatorio),
    CONSTRAINT FK_equipamento_relatorio_id_equipamento FOREIGN KEY (id_equipamento)
     REFERENCES gideao_amaral_bd_usu.equipamento (id_equipamento),
    CONSTRAINT FK_equipamento_relatorio_id_relatorio FOREIGN KEY (id_relatorio)
     REFERENCES gideao_amaral_bd_usu.relatorio (id_relatorio)
);
GO

-- 7. SENSOR
CREATE TABLE gideao_amaral_bd_usu.sensor (
    id_sensor INT IDENTITY(1,1) PRIMARY KEY,
    tag_sensor VARCHAR(20),
    id_equipamento INT,
    variavel_sensor VARCHAR(20),
    unidade_sensor VARCHAR(10),
    CONSTRAINT FK_sensor_id_equipamento FOREIGN KEY (id_equipamento)
     REFERENCES gideao_amaral_bd_usu.equipamento (id_equipamento)
);
GO

-- 8. MEDICAO
CREATE TABLE gideao_amaral_bd_usu.medicao (
    id_medicao INT IDENTITY(1,1) PRIMARY KEY,
    id_sensor INT,
    valor_medicao DECIMAL(10,2),
    status_medicao CHAR(2),
    CONSTRAINT FK_medicao_id_sensor FOREIGN KEY (id_sensor)
     REFERENCES gideao_amaral_bd_usu.sensor (id_sensor)
);
GO

-- 9. ALERTA
CREATE TABLE gideao_amaral_bd_usu.alerta (
    id_alerta INT IDENTITY(1,1) PRIMARY KEY,
    id_sensor INT,
    threshold_alerta DECIMAL(10,2),
    timestamp_alerta DATETIME2,
    tipo_alerta VARCHAR(20),
    CONSTRAINT FK_alerta_id_sensor FOREIGN KEY (id_sensor)
     REFERENCES gideao_amaral_bd_usu.sensor (id_sensor)
);
GO

-- 10. DESEMPENHO
CREATE TABLE gideao_amaral_bd_usu.desempenho (
    id_desempenho INT IDENTITY(1,1) PRIMARY KEY,
    id_equipamento INT,
    potencia_ativa DECIMAL(10,2),
    potencia_reativa DECIMAL(10,2),
    consumo_gas DECIMAL(10,2),
    CONSTRAINT FK_desempenho_id_equipamento FOREIGN KEY (id_equipamento)
     REFERENCES gideao_amaral_bd_usu.equipamento (id_equipamento)
);
GO

-- 11. USUARIO
CREATE TABLE gideao_amaral_bd_usu.usuario (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    nome_usuario VARCHAR(20),
    nivel_acesso VARCHAR(20)
);
GO

