# Projeto Lógico de Banco de Dados: E-commerce

Este repositório contém a modelagem lógica e a implementação em SQL de um banco de dados para um cenário de e-commerce. O projeto contempla a criação do esquema relacional, o mapeamento de relacionamentos, a persistência de dados e a elaboração de consultas SQL mais complexas para análise das informações do negócio.

## Refinamentos Implementados

A partir do modelo conceitual, foram adicionados os seguintes refinamentos ao projeto lógico:

* **Clientes PF e PJ:** Aplicação de uma constraint `CHECK` baseada em uma operação lógica XOR, garantindo que um cliente possua CPF ou CNPJ e impedindo que ambos sejam informados simultaneamente.

* **Múltiplos Pagamentos:** Separação da entidade de pagamento para permitir o cadastro de mais de uma forma de pagamento, conforme o relacionamento definido no modelo lógico.

* **Logística de Entrega:** Criação da tabela `entrega`, relacionada ao pedido e contendo informações sobre o status do transporte e o código de rastreio.

* **Mapeamento de Relacionamentos:** Criação de tabelas associativas para representar os relacionamentos N:M, como `produto_fornecedor`, `produto_pedido`, `produto_estoque` e `produto_vendedor`.

## Estrutura dos Scripts

* **`refined_schema.sql`:** Script DDL responsável pela criação do banco de dados, definição das tabelas, tipos de dados, chaves primárias (PK), chaves estrangeiras (FK) e regras de integridade (constraints).

* **`refined_queries_and_inserts.sql`:** Script DML responsável pela inserção dos dados de teste e pela execução das consultas SQL utilizadas na análise da base de dados.

## Funcionalidades e Cláusulas SQL Empregadas

Os scripts contemplam os requisitos de manipulação e consulta de dados, incluindo:

* **Consultas e Filtros:** Utilização de `SELECT` para recuperação de dados e `WHERE` para aplicação de filtros.

* **Atributos Derivados:** Utilização de expressões para gerar informações derivadas durante a consulta, como a função `CONCAT`.

* **Ordenação e Agrupamento:** Organização dos resultados com `ORDER BY` e agrupamento de dados.

* **Filtros em Grupos:** Utilização de `HAVING` para aplicação de condições após o agrupamento.

* **Junções (`JOINs`):** Junção de dados entre múltiplas tabelas utilizando `INNER JOIN` e `LEFT JOIN`.

## Perguntas de Negócio Respondidas

O script de consultas foi desenvolvido para extrair informações da base de dados e responder às seguintes perguntas:

1. Quantos pedidos foram realizados por cada cliente?

2. Algum vendedor também atua como fornecedor?

3. Qual é a relação entre os produtos, seus fornecedores e os estoques onde estão armazenados?

4. Qual é a relação entre os nomes dos fornecedores e os nomes dos produtos?
