-- =============================================================================
-- Project: Thermoelectric Plant Data Infrastructure
-- Description: Analytical queries and Performance Optimization (Indexing)
-- Author: Gideao Amaral
-- =============================================================================

-- 1. ANALYTICAL QUERIES
--------------------------------------------------------------------------------

-- A. Top 10 Equipments with highest downtime (evaluating maintanence plan and design/retrofit)
SELECT e.nome_equipamento, 
       SUM(f.duracao_minutos) as total_downtime,
       COUNT(f.id_falha) as failure_count
FROM equipamento e
JOIN falha f ON e.id_equipamento = f.id_equipamento
GROUP BY e.nome_equipamento
ORDER BY total_downtime DESC
FETCH FIRST 10 ROWS ONLY;

-- B. Temperatura vs Consumo de Gas vs Potencia Ativa (evaluating optimal operating point and bottlenecks)
SELECT 
    e.nome_equipamento,
    s.tag_sensor,
    m.valor_medicao as temperatura_c,
    d.consumo_gas,
    d.potencia_ativa,
    ROUND(d.potencia_ativa / NULLIF(d.consumo_gas, 0), 2) as eficiencia
FROM medicao m
JOIN sensor s ON m.id_sensor = s.id_sensor
JOIN equipamento e ON s.id_equipamento = e.id_equipamento
JOIN desempenho d ON e.id_equipamento = d.id_equipamento
WHERE s.variavel_sensor = 'Temperatura'
  AND m.valor_medicao > 80
ORDER BY m.valor_medicao DESC, d.consumo_gas ASC
FETCH FIRST 50 ROWS ONLY;

-- 2. PERFORMANCE TUNING (The DBA "Touch")
--------------------------------------------------------------------------------

-- Scenario: Searching for specific measurements in a 1M record table
-- Query before Indexing:
SET TIMING ON;
SELECT count(*) FROM medicao WHERE status_medicao = 'AL';
-- Note: This likely performs a FULL TABLE SCAN.

-- Creating Indexes to optimize search and joins
-- B-Tree Index for status filtering
CREATE INDEX idx_medicao_status ON medicao(status_medicao);

-- Composite Index for time-based analysis (Common in industrial trends)
-- (Assuming we add a timestamp to medicao as discussed)
-- CREATE INDEX idx_medicao_time ON medicao(timestamp_med);

-- Index for Foreign Keys (Best Practice to avoid deadlocks and speed up Joins)
CREATE INDEX idx_medicao_sensor ON medicao(id_sensor);
CREATE INDEX idx_falha_equip ON falha(id_equipamento);

-- Query after Indexing:
SELECT count(*) FROM medicao WHERE status_medicao = 'AL';
SET TIMING OFF;
