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

-- 2. PERFORMANCE TUNING (Indexes)
--------------------------------------------------------------------------------

-- Search before index
SET TIMING ON;
SELECT count(*) FROM medicao WHERE status_medicao = 'AL';
SET TIMING OFF;

-- Index for search
CREATE INDEX idx_medicao_status ON medicao(status_medicao);

-- Index for most frequent/join/FK
CREATE INDEX idx_medicao_sensor ON medicao(id_sensor);
CREATE INDEX idx_falha_equip ON falha(id_equipamento);

-- Search after index
SET TIMING ON;
SELECT count(*) FROM medicao WHERE status_medicao = 'AL';
SET TIMING OFF;
