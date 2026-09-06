# 🛒 Modelo de Banco de Dados para E-commerce

Modelagem física de um banco de dados relacional para um sistema de e-commerce, criada a partir de um diagrama EER no **MySQL Workbench 8.0** e exportada via Forward Engineering.

## 📌 Visão Geral

O modelo cobre o fluxo completo de um e-commerce — do cadastro do cliente até a entrega do pedido — suportando múltiplos fornecedores e vendedores terceiros (marketplace).

O projeto é composto pelos seguintes arquivos:

- **[`.pdf`](./assets/desafio_ecommerce_SQL.pdf):** documento com os requisitos e instruções utilizados como referência para a modelagem.
- **[`.mwb`](./mysql/eer_ecommerce_DIO.mwb):** arquivo original da modelagem desenvolvida no **EER Diagram do MySQL Workbench 8.0**.
- **[`.sql`](./mysql/eer_ecommerce_DIO.sql):** script SQL gerado por meio do processo de Forward Engineering do MySQL Workbench 8.0.
- **[`.svg`](./assets/eer_ecommerce_SQL.svg):** versão vetorial da modelagem EER.

## 📋 Requisitos do negócio

### Produto
- Os produtos são vendidos por uma única plataforma, mas podem ter **vendedores distintos** (terceiros).
- Cada produto possui **um fornecedor**.
- Um pedido pode ser composto por **um ou mais produtos**.

### Cliente
- O cliente se cadastra com **CPF ou CNPJ**.
- O **endereço** do cliente determina o valor do frete.
- Um cliente pode fazer **mais de um pedido**, cada um com prazo de carência para devolução.

### Pedido
- Criado por um cliente, com informações de compra, endereço e status da entrega.
- Composto por um ou mais produtos.
- Pode ser **cancelado**.

### Refinamentos
- **Cliente PF/PJ**: uma conta é PF *ou* PJ, nunca as duas.
- **Pagamento**: o cliente pode cadastrar mais de uma forma de pagamento.
- **Entrega**: possui status e código de rastreio.

## 🗄️ Estrutura das Tabelas

O banco de dados (`ecommerce_db`) está dividido nos seguintes domínios:

### 👥 Clientes
- **`cliente`** — dados base de contato (nome, e-mail, telefones).
- **`cliente_PF`** / **`cliente_PJ`** — especialização em Pessoa Física (CPF) e Pessoa Jurídica (CNPJ), mutuamente exclusivas.
- **`endereco`** — endereços vinculados ao cliente (permite múltiplos, com endereço padrão).
- **`forma_pagamento`** — métodos de pagamento salvos (cartão de crédito, débito, pix).

### 📦 Produtos e Parceiros
- **`produto`** — catálogo de itens, com preço atual.
- **`fornecedor`** — empresas que fornecem os produtos.
- **`vendedor`** — vendedores terceiros (marketplace) responsáveis pelo produto.

### 🛍️ Vendas e Logística
- **`pedido`** — registro central da compra: cliente, endereço, pagamento, status e frete.
- **`item_pedido`** — associativa entre pedido e produto, com quantidade e preço congelado no momento da venda.
- **`entrega`** — rastreio logístico: status e código de rastreamento.

## 🔗 Relacionamentos principais

| Relação | Cardinalidade |
|---|---|
| `cliente` → `endereco` | 1:N |
| `cliente` → `forma_pagamento` | 1:N |
| `cliente` → `pedido` | 1:N |
| `cliente` → `cliente_PF` ou `cliente_PJ` | 1:1 (exclusivo) |
| `vendedor` → `produto` | 1:N |
| `fornecedor` → `produto` | 1:N |
| `pedido` ↔ `produto` (via `item_pedido`) | N:N |
| `pedido` → `entrega` | 1:1 |

## ⚙️ Regras de Negócio Aplicadas (Constraints)

- **Especialização de cliente**: `cliente_PF` e `cliente_PJ` referenciam `cliente` via `id_cliente` como FK e PK ao mesmo tempo, garantindo que cada conta seja PF *ou* PJ, nunca ambas.
- **Chaves únicas**: `email` (cliente), `cpf` (cliente_PF), `cnpj` (cliente_PJ, fornecedor e vendedor) possuem índices **UNIQUE** para evitar duplicidade de cadastro.
- **Exclusão em cascata** (`ON DELETE CASCADE`): remover um cliente apaga automaticamente seus endereços, formas de pagamento e registro PF/PJ; remover um pedido apaga seus itens e a entrega vinculada.
- **Restrição de exclusão** (`ON DELETE RESTRICT`): impede excluir clientes, endereços, pagamentos, produtos, fornecedores ou vendedores que já estejam vinculados a um pedido histórico — preservando o histórico de vendas.
- **Domínios fechados** (`ENUM`): `status_pedido` (processando, concluído, cancelado) e `status_entrega` (aguardando coleta, em transporte, entregue, devolvido) padronizados para evitar inconsistências.

## 🚀 Como executar

1. Tenha o MySQL 8.0+ instalado.
2. Clone este repositório.
3. Execute o script `eer_ecommerce_DIO.sql` na sua IDE de preferência (MySQL Workbench, DBeaver, DataGrip) ou via linha de comando:

```bash
mysql -u seu_usuario -p < eer_ecommerce_DIO.sql
```

O schema `ecommerce_db` será criado automaticamente com todas as tabelas, chaves e índices.

## 🛠️ Tecnologias

- MySQL 8.0
- MySQL Workbench (EER Diagram / Forward Engineering)