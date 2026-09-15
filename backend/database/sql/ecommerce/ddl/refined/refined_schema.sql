-- criação de banco de dados para o cenário de e-commerce
create database ecommerce;
use ecommerce;

-- Tabela de Clientes: Armazena dados de pessoas físicas (PF) e jurídicas (PJ).
-- A constraint 'chk_cliente_pf_pj' aplica um "Ou Exclusivo" (XOR), garantindo que o cliente seja apenas PF ou apenas PJ, mas nunca ambos simultaneamente.
create table cliente(
id_cliente int auto_increment primary key,
nome varchar(60),
inicial_meio char(3),
sobrenome varchar(20),
tipo_pessoa enum('PF','PJ') not null,
cpf char(11) null,
cnpj char(14) null,
razao_social varchar(100) null,
endereco varchar(100),
constraint uq_cliente_cpf unique(cpf),
constraint uq_cliente_cnpj unique(cnpj),
constraint chk_cliente_pf_pj check (
(tipo_pessoa = 'PF' and cpf is not null and cnpj is null and razao_social is null)
or
(tipo_pessoa = 'PJ' and cnpj is not null and cpf is null and razao_social is not null)
)
);
alter table cliente auto_increment=1;

-- Tabela de Produtos: O campo 'categoria' utiliza ENUM para restringir as opções de entrada, garantindo a padronização dos dados.
create table produto(
id_produto int auto_increment primary key,
nome varchar(60),
infantil bool,
categoria enum('Eletronico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') not null,
avaliacao float default 0,
tamanho varchar(10)
);

-- Tabela de Pagamentos: Criada separadamente para permitir que um único cliente possua múltiplas formas de pagamento cadastradas (relação 1:N).
create table pagamento(
id_forma_pagamento int auto_increment primary key,
id_cliente int not null,
tipo_pagamento enum('Dinheiro', 'Boleto', 'Cartão', 'Dois cartões') not null,
limite_disponivel float,
constraint fk_cliente_pagamento foreign key (id_cliente) references cliente(id_cliente)
);

-- Tabela de Pedidos: Vinculada ao cliente via chave estrangeira (id_cliente).
create table pedido(
id_pedido int auto_increment primary key,
id_cliente int,
status_pedido enum('Cancelado', 'Confirmado', 'Em processamento') default 'Em processamento',
descricao_pedido varchar(255),
valor_frete float default 10,
pagamento_em_dinheiro bool default false,
constraint fk_pedido_cliente foreign key (id_cliente) references cliente(id_cliente)
);

-- Tabela de Entregas: Relação de 1 para 1 com pedido, garantida pela constraint UNIQUE (id_pedido), contendo status e código de rastreio.
create table entrega(
id_entrega int auto_increment primary key,
id_pedido int not null,
status_entrega enum('Aguardando envio', 'Em transporte', 'Entregue', 'Devolvido') default 'Aguardando envio',
codigo_rastreio varchar(50),
constraint fk_entrega_pedido foreign key (id_pedido) references pedido(id_pedido),
constraint uq_entrega_pedido unique (id_pedido)
);

-- Tabela de Estoque: Gerencia os locais físicos de armazenamento e suas quantidades totais.
create table estoque(
id_estoque int auto_increment primary key,
local_estoque varchar(255),
quantidade int default 0
);

-- Tabela de Fornecedores: O campo CNPJ é único (UNIQUE) para evitar o cadastro duplicado de empresas.
create table fornecedor(
id_fornecedor int auto_increment primary key,
razao_social varchar(255) not null,
cnpj char(14) not null,
contato char(11) not null,
constraint uq_fornecedor_cnpj unique (cnpj)
);

-- Tabela de Vendedores (Terceiros): Assim como clientes, usa a constraint 'chk_vendedor_pf_pj' para validar logicamente se é PF ou PJ.
create table vendedor(
id_vendedor int auto_increment primary key,
razao_social varchar(255) null,
nome_fantasia varchar(255) null,
cnpj char(14),
cpf char(11),
localizacao varchar(255),
contato char(11) not null,
constraint uq_vendedor_cnpj unique (cnpj),
constraint uq_vendedor_cpf unique(cpf),
constraint chk_vendedor_pf_pj check (
(cnpj is not null and cpf is null)
or
(cnpj is null and cpf is not null)
)
);

-- Tabela Associativa N:M (Vendedor-Produto): Define quais produtos são vendidos por quais vendedores parceiros.
create table produto_vendedor(
id_vendedor int,
id_produto int,
quantidade int default 1,
primary key (id_vendedor, id_produto),
constraint fk_produto_vendedor_vendedor foreign key (id_vendedor) references vendedor(id_vendedor),
constraint fk_produto_vendedor_produto foreign key (id_produto) references produto(id_produto)
);

desc produto_vendedor;

-- Tabela Associativa N:M (Produto-Pedido): Representa os itens individuais dentro de cada pedido realizado.
create table produto_pedido(
id_produto int,
id_pedido int,
quantidade int default 1,
status_estoque enum('Disponivel', 'Sem estoque') default 'Disponivel',
primary key (id_produto, id_pedido),
constraint fk_produto_pedido_produto foreign key (id_produto) references produto(id_produto),
constraint fk_produto_pedido_pedido foreign key (id_pedido) references pedido(id_pedido)
);

-- Tabela Associativa N:M (Produto-Estoque): Mapeia onde cada produto específico está fisicamente armazenado.
create table produto_estoque(
id_produto int,
id_estoque int,
regiao varchar(255) not null,
primary key (id_produto, id_estoque),
constraint fk_produto_estoque_produto foreign key (id_produto) references produto(id_produto),
constraint fk_produto_estoque_estoque foreign key (id_estoque) references estoque(id_estoque)
);

-- Tabela Associativa N:M (Produto-Fornecedor): Define quais fornecedores provêm quais produtos para o e-commerce.
create table produto_fornecedor(
id_fornecedor int,
id_produto int,
quantidade int not null,
primary key (id_fornecedor, id_produto),
constraint fk_produto_fornecedor_fornecedor foreign key (id_fornecedor) references fornecedor(id_fornecedor),
constraint fk_produto_fornecedor_produto foreign key (id_produto) references produto(id_produto)
);

desc produto_fornecedor;

show tables;
show databases;
use information_schema;
show tables;
desc referential_constraints;
select * from referential_constraints where constraint_schema = 'ecommerce';