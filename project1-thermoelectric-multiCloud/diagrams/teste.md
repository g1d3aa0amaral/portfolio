```mermaid

graph LR
    subgraph "Ambiente Oracle (Linux)"
    DB[(Oracle 19c PDB)] --> TNS[TNSNAMES.ORA]
    end

    subgraph "Servidor Gateway (Windows VM)"
    TNS --> LIS[LISTENER / dg4msql]
    LIS --> INIT[initSQLSERVER.ora]
    end

    subgraph "Destino (Docker)"
    INIT --> SQL[(SQL Server DB)]
    end

    %% Cores para destacar as tecnologias
    style DB fill:#f9f,stroke:#333,stroke-width:2px
    style SQL fill:#0078d4,stroke:#fff,stroke-width:2px,color:#fff
