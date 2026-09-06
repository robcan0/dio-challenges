# Sistema de Gerenciamento de Oficina Mecânica

## Descrição

Este repositório contém a modelagem de um banco de dados relacional para o controle e gerenciamento de Ordens de Serviço (OS) em uma oficina mecânica.

O projeto é composto pelos seguintes arquivos:

- **[`.pdf`](./assets/desafio_oficina_mecanica.pdf):** documento com os requisitos e instruções utilizados como referência para a modelagem.
- **[`.mwb`](./mysql/eer_oficina_mecanica.mwb):** arquivo original da modelagem desenvolvida no **EER Diagram do MySQL Workbench 8.0**.
- **[`.sql`](./mysql/eer_oficina_mecanica.sql):** script SQL gerado por meio do processo de Forward Engineering do MySQL Workbench 8.0.
- **[`.png`](./assets/eer_oficina_mecanica.png):** imagem da modelagem EER para visualização rápida.
- **[`.svg`](./assets/eer_oficina_mecanica.svg):** versão vetorial da modelagem EER.

## Regras de Negócio

O sistema atende às seguintes necessidades:

- **Atendimento:** Clientes levam seus veículos à oficina para consertos ou revisões periódicas.

- **Equipes e Avaliação:** Cada Ordem de Serviço associa um veículo a uma equipe de mecânicos, responsável por identificar os serviços necessários, registrar a OS e definir a data de entrega.

- **Ordem de Serviço (OS):** As OSs possuem informações fundamentais, como número, data de emissão, data de entrega, valor total, status atual e, após a finalização, data de conclusão.

- **Composição de Valores:** O valor total da OS é calculado a partir do somatório das peças utilizadas e dos serviços realizados, sendo o valor da mão de obra consultado em uma tabela de referência.

- **Execução:** A equipe responsável pela OS avalia o veículo e identifica os serviços necessários. Após a autorização do cliente, a mesma equipe responsável pela avaliação executa os serviços.

- **Múltiplos Itens:** Uma OS pode ser composta por vários serviços e diferentes tipos de peças. Da mesma forma, uma mesma peça ou um mesmo serviço pode estar presente em diversas OSs.

## Estrutura do Banco de Dados

O schema `oficina_mecanica` representa o cenário descrito por meio das seguintes tabelas:

| Tabela | Descrição |
|---|---|
| `cliente` / `veiculo` | Cadastro dos clientes e vínculo com seus veículos (`cliente` 1:N `veiculo`). |
| `equipe` / `mecanico` | Organização dos profissionais em equipes (`equipe` 1:N `mecanico`). Os mecânicos possuem código, nome, endereço e especialidade. |
| `peca` / `mao_de_obra` / `servico` | Entidades de referência para peças e serviços prestados, com seus respectivos valores (`mao_de_obra` 1:N `servico`). |
| `ordem_servico` | Tabela central responsável pelo controle da solicitação, datas, autorização (`autorizado`) e equipe alocada ao veículo (`veiculo` 1:N `ordem_servico`, `equipe` 1:N `ordem_servico`). A associação entre veículo e equipe é registrada nessa tabela, e não por meio de uma FK direta entre `veiculo` e `equipe`. |
| `ordem_servico_peca` / `ordem_servico_servico` | Tabelas associativas que representam a cardinalidade N:N entre a OS e as peças/serviços incluídos. A tabela `ordem_servico_peca` também armazena a `quantidade` de cada peça. |

## Observação de Design: Datas da OS

A narrativa original menciona uma única “data para conclusão dos trabalhos”, enquanto o script implementa **dois campos**:

- `data_entrega` (obrigatório): prazo combinado com o cliente na abertura da OS.
- `data_conclusao` (opcional): data efetiva em que o serviço foi finalizado, preenchida somente após a conclusão do trabalho.

Essa separação não contradiz a narrativa. Ela diferencia o prazo previsto da data efetiva de conclusão, permitindo inclusive avaliar eventuais atrasos ou adiantamentos na entrega.

## Como Visualizar o Modelo

Caso o objetivo seja apenas consultar a modelagem, sem executar o banco de dados, não é necessário instalar o MySQL. Basta:

- **Visualização rápida:** abrir o arquivo [`./assets/eer_oficina_mecanica.png`](./assets/eer_oficina_mecanica.png) ou [`./assets/eer_oficina_mecanica.svg`](./assets/eer_oficina_mecanica.svg) diretamente no repositório ou em qualquer visualizador de imagens. O `.svg` é recomendado para redimensionamento sem perda de qualidade.
- **Visualização interativa:** abrir o arquivo [`./mysql/eer_oficina_mecanica.mwb`](./mysql/eer_oficina_mecanica.mwb) no **MySQL Workbench** (versão 8.0+), o que permite navegar pelo diagrama EER, inspecionar tabelas, relacionamentos e atributos de forma interativa, sem necessidade de conexão com um servidor.

## Como Utilizar

Para efetivamente executar o script:

1. É necessário ter um servidor **MySQL 8.0+** instalado, além de uma ferramenta cliente, como o MySQL Workbench. O uso de uma ferramenta gráfica é opcional, pois o script também pode ser executado pela linha de comando.

   > **Atenção à versão:** o script utiliza a cláusula `VISIBLE` em seus índices — recurso disponível apenas a partir do MySQL 8.0. Em versões 5.7 ou anteriores, a execução falhará com erro de sintaxe.

2. O usuário utilizado para executar o script precisa ter privilégio `CREATE` no servidor, necessário para a criação do schema `oficina_mecanica`.

3. Execute o script diretamente pelo terminal, a partir da raiz do repositório:

```bash
mysql -u seu_usuario -p < ./mysql/eer_oficina_mecanica.sql
```

Ou abra o arquivo [`./mysql/eer_oficina_mecanica.sql`](./mysql/eer_oficina_mecanica.sql) no MySQL Workbench e execute o script integralmente.

4. O script provisiona o schema `oficina_mecanica` (criando-o apenas se ainda não existir, graças ao uso de `IF NOT EXISTS`) com charset `utf8mb4` e todas as tabelas necessárias, incluindo suas chaves primárias, chaves estrangeiras e respectivos índices.

## Créditos

Projeto desenvolvido a partir do desafio de modelagem de banco de dados da [DIO (Digital Innovation One)](https://www.dio.me/curso-sql), sob orientação da professora Juliana Mascarenhas, responsável pelas aulas ministradas.

