-- criação de banco de dados para o cenário de e-commerce
create database ecommerce;
use ecommerce;

-- criar tabela cliente
create table clients(
idClients int auto_increment primary key,
Fname varchar(10),
Minit char(3),
Lname varchar(20),
CPF char(11) not null,
Address varchar(30),
constraint unique_cpf_client unique(CPF)
);
alter table clients auto_increment=1;

-- criar tabela produto
-- size dimensão do produto
create table product(
idProduct int auto_increment primary key,
Pname varchar(10),
classification_kids bool,
category enum('Eletronico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') not null,
Avaliation float default 0,
size varchar(10)
);

-- pra ser continuado no desafio, termine de implementar a tabela e crie a conexão com as tabelas necessárias
-- alem disso reflita essa modificação no diagrama de esquema relacional
-- criar constraints relacionadas ao pagamento
create table payments(
idClient int,
id_payment int,
typePayment enum('Dinheiro', 'Boleto', 'Cartão', 'Dois cartões'),
limitAvailable float,
primary key(idClient, id_payment)
);

-- criar tabela pedido
create table orders(
idOrders int auto_increment primary key,
idOrdersClient int,
orderStatus enum('Cancelado', 'Confirmado', 'Em processamento') default 'Em processamento',
oedersDescription varchar(255),
sendValue float default 10,
paymentCash bool default false,
constraint fk_orders_client foreign Key (idOrdersClient) references clients(idClients)
);

-- criar tabela estoque
create table storage(
idProdStorage int auto_increment primary key,
storageLocation varchar(255),
quantity int default 0
);

-- criar tabalea fornecedor
create table supplier(
idSupplier int auto_increment primary key,
socialName varchar(255) not null,
CNPJ char(15) not null,
contact char(11) not null,
constraint unique_supplier unique (CNPJ)
);

-- criar tabela vendedor
create table seller(
idSeller int auto_increment primary key,
SocialName varchar(255) not null,
AbstName varchar(255),
CNPJ char(15),
CPF char(9),
Location varchar(255),
Contact char(11) not null,
constraint unique_cnpj_seller unique (CNPJ),
constraint unique_cpf_seller unique(CPF)
);

create table productSeller(
idPSeller int,
idProduct int,
prodQuantity int default 1,
primary key (idPSeller, idProduct),
constraint fk_product_seller foreign key (idPSeller) references seller(idSeller),
constraint fk_product_product foreign key (idProduct) references product(idProduct)
);

desc productSeller;

create table productOrder(
idPOproduct int,
idPOorder int,
poQuantity int default 1,
poStatus enum('Disponivel', 'Sem estoque') default 'Disponivel',
primary key (idPOproduct, idPOorder),
constraint fk_product_seller foreign key (idPOproduct) references product(idProduct),
constraint fk_product_product foreign key (idPOorder) references orders(idOorder)
);

create table storageLocation(
idproduct int,
idlstorage int,
location varchar(255) not null,
primary key (idLproduct, idLstorage),
constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idproductStorage)
);

create table productSupplier(
idPsSupplier int,
idPsProduct int,
quantity int not null,
primary key (idPsSupplier, isPsproduct),
constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
constraint fk_product_supplier_product foreign key (idPsProduct) references product(idProduct)
);

desc productSupplier;

show tables;

show databases;
use information_schema;
show tables;
desc referential_constraints;
select * from referential_constraints where constraint_schema = 'ecommerce';


