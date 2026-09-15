-- inserção de dados e queries

use ecommerce;

show tables;
-- idClient, Fname, Minit, Lname, CPF, Address
insert into clients (Fname, Minit, Lname, CPF, Address) values
('Maria', 'M', 'Silva', '12346789', 'rua silva da prata 29, Carangola - Cidade das flores'),
('Matheus', 'O', 'Pimentel', '987456321', 'rua alameda 289, Centro - Cidade das flores'),
('Ricardo', 'F', 'Silva', '45678913', 'avenida alameda vinha 1009, Centro - Cidade das flores'),
('Julia', 'S', 'França', '789123456', 'rua das laranjeiras 861, Centro - Cidade das flores'),
('Roberta', 'G', 'Assis', '98745631', 'avenida de koller 19, Centro - Cidade das flores'),
('Isabela', 'M', 'Cruz', '654789123', 'rua alameda das flores 28, centro - Cidade das flores');

-- idProduct, Pname, classification_kids boolean, category('Eletronico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis'), avaliação, size
insert into product (Pname, classification_kids, category, avaliação, size) values
('Fone de ouvido', false, 'Eletronico', '4', null),
('Barbie Elsa', true, 'Brinquedos', '3', null),
('Body Carters', true, 'Vestimenta', '5', null),
('Microfone Vedo - Youtuber', false, 'Eletronico', '4', null),
('Sofá retratil', false, 'Móveis', '3', '3x57x80'),
('Farinha de arroz', false, 'Alimentos', '2', null),
('Fire Stick Amazon', false, 'Eletronico', '3', null);

select * from clients;
select * from product;

-- idorder, idOrderClient, orderStatus, orderStatus, orderDescription, sendValue, paymentCash

insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash) values
(1, null, 'compra via aplicativo', null, 1),
(2, null, 'compra via aplicativo', 50, 0),
(3, 'Confirmado', null, null, 1),
(4, null, 'compra via web site', 150, 0);

select * from orders;
insert into productOrder (idOproduct, idOorder, poQuantity, poStatus) values
(1, 5, 2, null),
(2, 5, 1, null),
(3, 6, 1, null);

insert into productStorage (storageLocation, quantity) values
('Rio de janeiro',1000),
('Rio de janeiro',500),
('São Paulo', 10),
('São Paulo', 100),
('Brasilia',60);

insert into storageLocation (idLproduct, idLstorage, location) values
(1,2,'RJ'),
(2,6,'GO');

insert into supplier (SocialName, CNPJ, contact) values
('Alameda e filhos', 123456789123456, '21985474'),
('Eletrônicos Silva',8545619649143457, '21985484'),
('Eletrônicos Valma', 934567893934695, '21975474');

select * from supplier;

insert into productSupplier (idPsSupplier, idPsProduct, quantity) values
(1,1,500),
(1,2,400),
(2,4,633),
(3,3,5),
(2,5,10);

insert into seller (SocialName, abstName, CNPJ, CPF, location, contact) values
('Tech eletronics', null, '123456789456321', null, 'Rio de Janeiro', '219946287'),
('Botique Durgas', null, null, '123456783', null, '219567895'),
('Kids World', null, '456789123654485', null, 'São Paulo', '1198657484');

select * from seller;
insert into productSeller (idOseller, idPproduct, prodQuantity) values
(1,6,80),
(2,7,10);

select * from productSeller;

select count(*) from clients;

select Fname, Lname, idOrder, orderStatus from clients c, orders o where c.idClient = idOrderClient;
select concat(Fname,' ',Lname) as Client, idOrder as Request, orderStatus as Status from clients c, orders o where c.idClient = idOrderClient;

insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash) values
(2, default, 'compra via aplicativo', null,1);

-- recuperação de pedidos por produto associado
select count(*) from clients c, orders o 
where c.idClient = idOrderClient
group by idOrder;

select * from orders;
-- recuperar qantos pedidos forma realizados pelos clientes
select c.idClient, Fname, count(*) as Numbers_of_orders 
from clients c 
inner join orders o ON c.idClient = o.idOrderClient
inner join productOrder po ON o.idOrder = po.idOorder
group by c.idClient, Fname;