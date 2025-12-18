```mermaid

graph LR
    subgraph "Origem: Oracle (Linux VM)"
    DB[(Oracle 19c PDB)] --> TNS[TNSNAMES.ORA]
    end

    subgraph "Intermediário: Gateway (Windows VM)"
    TNS --> LIS[LISTENER / dg4msql]
    LIS --> INIT[initSQLSERVER.ora]
    end

    subgraph "Destino: SQL Server (Docker)"
    INIT --> SQL[(SQL Server DB)]
    end

    style DB fill:#f96,stroke:#333,stroke-width:2px
    style SQL fill:#0078d4,stroke:#333,stroke-width:2px
