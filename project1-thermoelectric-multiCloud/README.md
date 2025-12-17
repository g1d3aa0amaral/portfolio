# Migração e Integração de Dados: Usina Termelétrica (Oracle & SQL Server)
[English](#english) | [Português](#português)


<a name="english"></a>
## 🇺🇸 English
###Overview
This project simulates the data ecosystem of a gas-fired thermoelectric power plant. The challenge was to design a database architecture capable of handling high volumes of sensor data, ensuring integrity for performance analysis, safety, and predictive maintenance.

###Architecture & Infrastructure
The environment was built using a hybrid virtualization strategy to simulate a real-world enterprise integration:

Oracle Database 19c: Running on a VirtualBox VM (Linux).

SQL Server: Running in a Docker Container.

Oracle Database Gateway for SQL Server: Configured on a Windows VM to enable heterogeneous connectivity and federated queries.

###Technical Highlights
High Volume Data Handling: Implementation and performance testing with 1,000,000 records in the measurements table.

Heterogeneous Integration: Setup of listener.ora, tnsnames.ora, and init.ora to allow Oracle to consume SQL Server data transparently.

Automation (Triggers): Developed triggers to automatically calculate failure durations and operational KPIs.

Performance Optimization: Strategic creation of indexes to optimize complex queries involving vibration, temperature, and power generation correlations.

<a name="português"></a>
## 🇧🇷 Português

###Visão Geral
Este projeto simula o ecossistema de dados de uma usina termelétrica a gás. O desafio consistiu em projetar uma arquitetura de banco de dados capaz de lidar com altos volumes de dados de sensores, garantindo a integridade para análises de desempenho, segurança e manutenção preditiva.

###Arquitetura e Infraestrutura
O ambiente foi construído utilizando uma estratégia de virtualização híbrida para simular uma integração corporativa real:

Oracle Database 19c: Rodando em uma VM VirtualBox (Linux).

SQL Server: Rodando em um Container Docker.

Oracle Database Gateway for SQL Server: Configurado em uma VM Windows para permitir conectividade heterogênea e consultas federadas.

###Destaques Técnicos
Manipulação de Grande Volume de Dados: Implementação e testes de performance com 1.000.000 de registros na tabela de medições.

Integração Heterogênea: Configuração de listener.ora, tnsnames.ora e init.ora para permitir que o Oracle consuma dados do SQL Server de forma transparente.

Automação (Triggers): Desenvolvimento de gatilhos para calcular automaticamente a duração de falhas e KPIs operacionais.

Otimização de Performance: Criação estratégica de índices para otimizar consultas complexas envolvendo correlações de vibração, temperatura e geração de energia.


/docs: Original project documentation and presentation.


Adicione os prints (MER e Arquitetura) na pasta /docs ou /diagrams e atualize os links das imagens no texto.
