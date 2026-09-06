# 🚀 Desafios Full Stack - DIO

Repositório dedicado ao armazenamento e à organização dos desafios de **backend e frontend** realizados ao longo das trilhas, bootcamps e formações da [DIO (Digital Innovation One)](https://www.dio.me/).

O objetivo é reunir as soluções desenvolvidas durante os estudos, documentar a evolução técnica e manter os projetos organizados em um único portfólio.

## 📑 Índice

* [Sobre o repositório](#-sobre-o-repositório)
* [Tecnologias utilizadas](#-tecnologias-utilizadas)
* [Estrutura do repositório](#-estrutura-do-repositório)
* [Desafios](#-desafios)
* [Como executar os projetos](#-como-executar-os-projetos)
* [Licença](#-licença)

## 📌 Sobre o repositório

Este repositório reúne desafios propostos pela [DIO](https://www.dio.me/), com soluções desenvolvidas em diferentes linguagens, frameworks, bancos de dados e ferramentas.

O repositório tem como objetivos:

* Consolidar o aprendizado prático em diferentes tecnologias;
* Registrar a evolução ao longo dos estudos;
* Organizar os projetos desenvolvidos durante as formações;
* Servir como portfólio de projetos e estudos.

Cada desafio possui sua própria pasta, contendo o código-fonte e os arquivos relacionados ao projeto. Quando necessário, também poderá incluir um `README.md` específico com informações sobre requisitos, instalação, execução e demais detalhes.

## 🛠 Tecnologias utilizadas

As tecnologias serão adicionadas conforme novos desafios forem incorporados ao repositório.

* **Linguagens:** SQL
* **Frameworks e bibliotecas:** Em breve
* **Bancos de dados:** MySQL
* **Ferramentas:** MySQL Workbench, VS Code, Git e GitHub

## 📂 Estrutura do repositório

Os desafios serão organizados por categoria e, posteriormente, por projeto:

```text
dio-challenges/
├── backend/
│   └── database/
│       └── sql/
│          └── ecommerce/
└── README.md
```

A estrutura poderá ser expandida ou adaptada conforme a quantidade e a natureza dos projetos adicionados.

## 🧩 Desafios

#### Os desafios serão adicionados e organizados conforme forem desenvolvidos.

### Backend

| Desafio                                                 | Tecnologia  | Ferramenta      | Status       |
| ------------------------------------------------------- | ------------| --------------- | ------------ |
| [Modelagem de dados](./backend/database/sql/ecommerce/) | EER Diagram | MySQL Workbench | ✅ Concluído |

## ▶️ Como executar os projetos

Cada projeto possui requisitos e instruções de execução específicos, de acordo com as tecnologias utilizadas.

### 📥 Obter um projeto específico

Para baixar somente a pasta do projeto desejado, utilizando o Git:

```bash
# Clonar o repositório sem baixar o conteúdo dos outros projetos
git clone --no-checkout https://github.com/seu-usuario/seu-repositorio.git

# Acessar o repositório
cd seu-repositorio

# Habilitar o sparse-checkout
git sparse-checkout init --cone

# Selecionar a pasta do projeto
git sparse-checkout set caminho/da/pasta-do-projeto

# Baixar os arquivos da branch principal
git checkout main
```

Substitua `caminho/da/pasta-do-projeto` pelo caminho correspondente ao desafio que deseja obter.

### ▶️ Executar o projeto

Após obter os arquivos, acesse a pasta do projeto e consulte o `README.md` específico, quando disponível, para verificar os requisitos, instalação, configuração e comandos necessários para sua execução.

As instruções de execução são mantidas individualmente em cada projeto, considerando suas respectivas tecnologias e dependências.

## 📄 Licença

Os projetos desenvolvidos neste repositório estão disponibilizados sob a licença [MIT](./LICENSE), quando aplicável.

Os desafios, enunciados, materiais didáticos e demais conteúdos fornecidos pela [DIO](https://www.dio.me/) permanecem sujeitos às respectivas condições de uso e direitos de seus autores.
