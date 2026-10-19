# Sistema de Gerenciamento de Oficina Mecânica

## Descrição

Este repositório contém a modelagem de um banco de dados relacional para o controle e gerenciamento de Ordens de Serviço (OS) em uma oficina mecânica, junto com dados de teste e consultas SQL para exercitar o modelo.

O projeto é composto pelos seguintes arquivos:

- **[`.pdf`](./assets/mechanic_shop_challenge.pdf):** documento com os requisitos e instruções utilizados como referência para a modelagem.
- **[`.mwb`](./mysql/eer_mechanic_shop.mwb):** arquivo original da modelagem desenvolvida no **EER Diagram do MySQL Workbench 8.0**.
- **[`eer_mechanic_shop.sql`](./mysql/eer_mechanic_shop.sql):** script SQL (DDL) gerado por meio do processo de Forward Engineering do MySQL Workbench 8.0. Cria o schema e as tabelas.
- **[`inserts_mechanic_shop.sql`](./mysql/inserts_mechanic_shop.sql):** script com dados de teste (clientes, veículos, equipes, mecânicos, peças, mão de obra, serviços e ordens de serviço).
- **[`query_mechanic_shop.sql`](./mysql/query_mechanic_shop.sql):** script com consultas SQL organizadas por tema, para validar o modelo e os dados de teste.
- **[`.png`](./assets/eer_mechanic_shop.png):** imagem da modelagem EER para visualização rápida.
- **[`.svg`](./assets/eer_mechanic_shop.svg):** versão vetorial da modelagem EER.

## Regras de Negócio

O sistema atende às seguintes necessidades:

- **Atendimento:** Clientes levam seus veículos à oficina para consertos ou revisões periódicas.

- **Equipes e Avaliação:** Cada Ordem de Serviço associa um veículo a uma equipe de mecânicos, responsável por identificar os serviços necessários, registrar a OS e definir a data de entrega.

- **Ordem de Serviço (OS):** As OSs possuem informações fundamentais, como número, data de emissão, data de entrega, valor total, status atual e, após a finalização, data de conclusão.

- **Composição de Valores:** O valor total da OS é calculado a partir do somatório das peças utilizadas e dos serviços realizados, sendo o valor da mão de obra consultado em uma tabela de referência.

- **Execução:** A equipe responsável pela OS avalia o veículo e identifica os serviços necessários. Após a autorização do cliente, a mesma equipe responsável pela avaliação executa os serviços.

- **Múltiplos Itens:** Uma OS pode ser composta por vários serviços e diferentes tipos de peças. Da mesma forma, uma mesma peça ou um mesmo serviço pode estar presente em diversas OSs.

## Estrutura do Banco de Dados

O schema `mechanic_shop` representa o cenário descrito por meio das seguintes tabelas:

| Tabela | Descrição |
|---|---|
| `cliente` / `veiculo` | Cadastro dos clientes e vínculo com seus veículos (`cliente` 1:N `veiculo`). |
| `equipe` / `mecanico` | Organização dos profissionais em equipes (`equipe` 1:N `mecanico`). Os mecânicos possuem código, nome, endereço e especialidade. |
| `peca` / `mao_de_obra` / `servico` | Entidades de referência para peças e serviços prestados, com seus respectivos valores (`mao_de_obra` 1:N `servico`). |
| `ordem_servico` | Tabela central responsável pelo controle da solicitação, datas, autorização (`autorizado`) e equipe alocada ao veículo (`veiculo` 1:N `ordem_servico`, `equipe` 1:N `ordem_servico`). A associação entre veículo e equipe é registrada nessa tabela, e não por meio de uma FK direta entre `veiculo` e `equipe`. |
| `ordem_servico_peca` / `ordem_servico_servico` | Tabelas associativas que representam a cardinalidade N:N entre a OS e as peças/serviços incluídos. A tabela `ordem_servico_peca` também armazena a `quantidade` de cada peça. |

## Observações de Design

### Datas da OS

A narrativa original menciona uma única “data para conclusão dos trabalhos”, enquanto o script implementa **dois campos**:

- `data_entrega` (obrigatório): prazo combinado com o cliente na abertura da OS.
- `data_conclusao` (opcional): data efetiva em que o serviço foi finalizado, preenchida somente após a conclusão do trabalho.

Essa separação não contradiz a narrativa. Ela diferencia o prazo previsto da data efetiva de conclusão, permitindo inclusive avaliar eventuais atrasos ou adiantamentos na entrega.

### Valor da OS e mão de obra

- O campo `ordem_servico.valor` é **gravado diretamente** na tabela (não é calculado automaticamente). Nos dados de teste, ele corresponde à soma dos valores dos serviços (`servico.valor`) com a soma de `peca.valor × quantidade` de cada OS.
- `mao_de_obra.valor_referencia` funciona como **tabela de consulta**: ele não entra na composição do `valor` da OS nos dados de teste e é utilizado apenas em consultas (por exemplo, nas queries 3.6 e 6.7).
- Como o valor é armazenado, ele pode divergir dos itens caso estes sejam alterados. A query **6.9** do arquivo de consultas faz essa conferência (`diferenca` deve ser `0` para todas as OSs dos dados de teste).

## Dados de Teste

O arquivo `inserts_mechanic_shop.sql` popula o banco com um cenário pequeno, com casos propositalmente escolhidos para exercitar as consultas:

| Cenário | Finalidade |
|---|---|
| Cliente 4 (Juliana Costa) sem veículo | Testar `LEFT JOIN` (queries 6.3 e 6.4). |
| Equipe 103 sem mecânicos e sem OS | Testar equipes sem vínculo (query 6.6). |
| Cliente 1 (Carlos Silva) com 2 veículos | Testar agrupamentos com `HAVING` (query 5.2). |
| Marca Fiat com 2 veículos | Testar agrupamento por marca (queries 2.2 e 5.4). |
| OS 1004 concluída 2 dias após a data de entrega | Testar cálculo de atraso (query 3.3). |
| OS 1003 não autorizada, aguardando aprovação | Testar filtros por autorização e status. |

> O script utiliza **IDs fixos**. Execute-o **apenas uma vez**; uma segunda execução causará erro de chave duplicada. Para recarregar os dados, recrie o schema (ou apague os registros) antes de executá-lo novamente.

## Consultas SQL

O arquivo `query_mechanic_shop.sql` reúne consultas numeradas e comentadas, organizadas nos seguintes grupos:

| Grupo | Conteúdo |
|---|---|
| **1. Recuperações simples** | `SELECT` básico e `DISTINCT`. |
| **2. Filtros** | `WHERE` com `=`, `<>`, `IS NULL`, `BETWEEN`, `LIKE`, `IN` e operadores lógicos. |
| **3. Atributos derivados** | Expressões aritméticas, `DATEDIFF`, `CONCAT` e `CASE`. |
| **4. Ordenação** | `ORDER BY` com múltiplas colunas, atributos derivados e `LIMIT`. |
| **5. Filtros em grupos** | `GROUP BY` com `HAVING`, funções de agregação e subconsulta. |
| **6. Junções** | `INNER JOIN`, `LEFT JOIN`, junções com tabelas associativas, subconsultas derivadas e conferência do valor das OSs. |

As consultas são compatíveis com o modo `ONLY_FULL_GROUP_BY` utilizado pelo script do schema.

## Como Visualizar o Modelo

Caso o objetivo seja apenas consultar a modelagem, sem executar o banco de dados, não é necessário instalar o MySQL. Basta:

- **Visualização rápida:** abrir o arquivo [`./assets/eer_mechanic_shop.png`](./assets/eer_mechanic_shop.png) ou [`./assets/eer_mechanic_shop.svg`](./assets/eer_mechanic_shop.svg) diretamente no repositório ou em qualquer visualizador de imagens. O `.svg` é recomendado para redimensionamento sem perda de qualidade.
- **Visualização interativa:** abrir o arquivo [`./mysql/eer_mechanic_shop.mwb`](./mysql/eer_mechanic_shop.mwb) no **MySQL Workbench** (versão 8.0+), o que permite navegar pelo diagrama EER, inspecionar tabelas, relacionamentos e atributos de forma interativa, sem necessidade de conexão com um servidor.

## Como Utilizar

Para efetivamente executar os scripts:

1. É necessário ter um servidor **MySQL 8.0+** instalado, além de uma ferramenta cliente, como o MySQL Workbench. O uso de uma ferramenta gráfica é opcional, pois os scripts também podem ser executados pela linha de comando.

   > **Atenção à versão:** o script do schema utiliza a cláusula `VISIBLE` em seus índices — recurso disponível apenas a partir do MySQL 8.0. Em versões 5.7 ou anteriores, a execução falhará com erro de sintaxe.

2. O usuário utilizado para executar o script precisa ter privilégio `CREATE` no servidor, necessário para a criação do schema `mechanic_shop`, além de privilégios de `INSERT` e `SELECT` para os demais scripts.

3. Execute os scripts **nesta ordem**, a partir da raiz do repositório:

   | Ordem | Arquivo | Função |
   |---|---|---|
   | 1 | `eer_mechanic_shop.sql` | Cria o schema e as tabelas. |
   | 2 | `inserts_mechanic_shop.sql` | Insere os dados de teste. |
   | 3 | `query_mechanic_shop.sql` | Executa as consultas. |

```bash
mysql -u seu_usuario -p --default-character-set=utf8mb4 < ./mysql/eer_mechanic_shop.sql
mysql -u seu_usuario -p --default-character-set=utf8mb4 < ./mysql/inserts_mechanic_shop.sql
mysql -u seu_usuario -p --default-character-set=utf8mb4 < ./mysql/query_mechanic_shop.sql
```

   > A opção `--default-character-set=utf8mb4` evita que textos acentuados (como "São Paulo" e "Concluído") sejam gravados ou lidos com codificação incorreta em alguns terminais, principalmente no Windows. Isso é importante porque as consultas filtram por textos acentuados, como `status = 'Concluído'`.

   Ou abra cada arquivo no MySQL Workbench e execute o script integralmente, respeitando a mesma ordem.

4. O script do schema provisiona o `mechanic_shop` (criando-o apenas se ainda não existir, graças ao uso de `IF NOT EXISTS`) com charset `utf8mb4` e todas as tabelas necessárias, incluindo suas chaves primárias, chaves estrangeiras e respectivos índices. Os scripts de inserts e de consultas selecionam o schema automaticamente com `USE mechanic_shop`.

5. As consultas do arquivo `query_mechanic_shop.sql` são independentes entre si. Ao usar o Workbench, é possível executar uma consulta por vez selecionando-a e utilizando **Query > Execute Current Statement**.

## Créditos

Projeto desenvolvido a partir do desafio de modelagem de banco de dados da [DIO (Digital Innovation One)](https://www.dio.me/curso-sql), sob orientação da professora Juliana Mascarenhas, responsável pelas aulas ministradas.