-- =============================================================================
-- Project: Thermoelectric Plant Data Infrastructure
-- Description: Automated mass data generation using PL/SQL Procedures
-- Author: Gideao Amaral
-- =============================================================================

-- Populating Equipment (Dimension Table)

BEGIN
    FOR i IN 1..100 LOOP
        INSERT INTO equipamento (nome_equipamento, tipo_equipamento, fabricante_equipamento)
        VALUES (
            'EQP_' || LPAD(i, 3, '0'),
            CASE MOD(i, 4) WHEN 0 THEN 'Motor' WHEN 1 THEN 'Gerador' ELSE 'Bomba' END,
            CASE MOD(i, 3) WHEN 0 THEN 'Siemens' WHEN 1 THEN 'ABB' ELSE 'WEG' END
        );
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('100 Equipamentos inseridos.');
END;
/

-- Populating Sensor (Dimension Table)

BEGIN
    FOR i IN 1..500 LOOP
        INSERT INTO sensor (tag_sensor, id_equipamento, variavel_sensor, unidade_sensor)
        VALUES (
            'SENS_' || LPAD(i, 4, '0'),
            TRUNC(DBMS_RANDOM.VALUE(1, 101)), -- Randomly linking to an equipment
            CASE MOD(i, 3) WHEN 0 THEN 'Temperatura' WHEN 1 THEN 'Vibracao' ELSE 'Corrente' END,
            CASE MOD(i, 3) WHEN 0 THEN 'C' WHEN 1 THEN 'mm/s' ELSE 'A' END
        );
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('500 Sensores inseridos.');
END;
/

-- Procedure for Data Mass Generation (Measurement, Performance, and Failure)

CREATE OR REPLACE PROCEDURE sp_gerar_carga_massiva (p_total_registros IN NUMBER DEFAULT 50000) AS
    v_start_time    TIMESTAMP;
    v_equip_id      NUMBER;
    v_sens_id       NUMBER;
    v_val           NUMBER;
    v_date          TIMESTAMP;
    v_chunk_size    CONSTANT NUMBER := 50000;
BEGIN
    v_start_time := SYSTIMESTAMP;
    DBMS_OUTPUT.PUT_LINE('--- Iniciando Carga Massiva de Dados: ' || p_total_registros || ' registros ---');

    -- each measurement given by a sensor and related to an equipment
    FOR i IN 1..p_total_registros LOOP
        v_equip_id := TRUNC(DBMS_RANDOM.VALUE(1, 101));
        v_sens_id  := TRUNC(DBMS_RANDOM.VALUE(1, 501));
        
        -- random timestamp within last 2 years
        v_date := SYSTIMESTAMP - NUMTODSINTERVAL(DBMS_RANDOM.VALUE(0, 730), 'DAY');
        v_val  := DBMS_RANDOM.VALUE(10, 99.99);

        -- inserting values in Measurement
        INSERT INTO medicao (id_sensor, valor_medicao, status_medicao)
        VALUES (v_sens_id, v_val, CASE WHEN v_val > 95 THEN 'AL' ELSE 'OK' END);

        -- inserting values in Performance
        INSERT INTO desempenho (id_equipamento, potencia_ativa, potencia_reativa, consumo_gas)
        VALUES (v_equip_id, DBMS_RANDOM.VALUE(100, 500), DBMS_RANDOM.VALUE(10, 100), DBMS_RANDOM.VALUE(5, 50));

        -- inserting values in failures
        IF MOD(i, 200) = 0 THEN
            INSERT INTO falha (id_equipamento, descricao_falha, timestamp_inicio_falha, timestamp_fim_falha)
            VALUES (
                v_equip_id,
                'Falha no EQP ' || v_equip_id || ' - Ocorrencia #' || i,
                v_date,
                v_date + NUMTODSINTERVAL(DBMS_RANDOM.VALUE(30, 360), 'MINUTE')
            );
        END IF;

        -- batch Commit
        IF MOD(i, v_chunk_size) = 0 THEN
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Processados: ' || i || ' registros em ' || TO_CHAR(SYSTIMESTAMP, 'HH24:MI:SS'));
        END IF;

    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('--- Carga Massiva de Dados Completada em ' || 
                         EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_time)) || ' minutes ---');
END;
/

-- Executa a procedure 1mi de vezes
EXEC sp_gerar_carga_massiva(1000000);
