```mermaid

graph LR
    subgraph "Oracle Server (Linux VM)"
    DB[(Oracle 19c PDB)]
    end

    subgraph "Oracle Database Gateway (Windows VM)"
    DB[(Oracle Database Gateway)]
    end

    subgraph "SQL Server (Docker Container)"
    INIT --> SQL[(SQL Server DB)]
    end

    style DB fill:#f96,stroke:#333,stroke-width:2px
    style SQL fill:#0078d4,stroke:#333,stroke-width:2px
