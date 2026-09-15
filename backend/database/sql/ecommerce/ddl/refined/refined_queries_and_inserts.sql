-- SCRIPT DML: INSERÇÃO E CONSULTA DE DADOS

use ecommerce;

show tables;

-- Inserindo clientes: Os dados de PF preenchem CPF e deixam CNPJ e Razão Social nulos; para PJ, ocorre o inverso, respeitando a constraint criada.
insert into cliente (nome, inicial_meio, sobrenome, tipo_pessoa, cpf, cnpj, razao_social, endereco) values
('Maria', 'M', 'Silva', 'PF', '12346789012', null, null, 'rua silva da prata 29, Carangola - Cidade das flores'),
('Matheus', 'O', 'Pimentel', 'PF', '98745632108', null, null, 'rua alameda 289, Centro - Cidade das flores'),
('Ricardo', 'F', 'Silva', 'PF', '45678913058', null, null, 'avenida alameda vinha 1009, Centro - Cidade das flores'),
('Julia', 'S', 'França', 'PF', '78912345655', null, null, 'rua das laranjeiras 861, Centro - Cidade das flores'),
('Roberta', 'G', 'Assis', 'PF', '98745631897', null, null, 'avenida de koller 19, Centro - Cidade das flores'),
('Isabela', 'M', 'Cruz', 'PF', '65478912387', null, null, 'rua alameda das flores 28, centro - Cidade das flores'),
(null, null, null, 'PJ', null, '12345678000199', 'Comércio Flores LTDA', 'avenida central 500, Centro - Cidade das flores');

-- Inserindo produtos: Booleanos são passados como true/false (ou 1/0) e as categorias devem corresponder exatamente ao ENUM.
insert into produto (nome, infantil, categoria, avaliacao, tamanho) values
('Fone de ouvido', false, 'Eletronico', '4', null),
('Barbie Elsa', true, 'Brinquedos', '3', null),
('Body Carters', true, 'Vestimenta', '5', null),
('Microfone Vedo - Youtuber', false, 'Eletronico', '4', null),
('Sofá retrátil', false, 'Móveis', '3', '3x57x80'),
('Farinha de arroz', false, 'Alimentos', '2', null),
('Fire Stick Amazon', false, 'Eletronico', '3', null);

select * from cliente;
select * from produto;

-- Inserindo pedidos: O uso da palavra-chave 'default' preenche o campo com o valor padrão ('Em processamento' para status, por exemplo).
insert into pedido (id_cliente, status_pedido, descricao_pedido, valor_frete, pagamento_em_dinheiro) values
(1, default, 'compra via aplicativo', default, 1),
(2, default, 'compra via aplicativo', 50, 0),
(3, 'Confirmado', null, default, 1),
(4, default, 'compra via web site', 150, 0),
(2, default, 'compra via aplicativo', default, 1),
(1, default, 'compra via aplicativo', default, 1);

select * from pedido;

-- Inserindo os itens dentro de cada pedido correspondente (ligação N:M).
insert into produto_pedido (id_produto, id_pedido, quantidade, status_estoque) values
(1, 5, 2, default),
(2, 5, 1, default),
(3, 6, 1, default);

-- Registrando o status logístico e rastreio de cada pedido.
insert into entrega (id_pedido, status_entrega, codigo_rastreio) values
(1, 'Entregue', 'BR123456789'),
(2, 'Em transporte', 'BR987654321'),
(3, 'Aguardando envio', null),
(4, 'Entregue', 'BR456789123'),
(5, 'Devolvido', 'BR321654987'),
(6, 'Aguardando envio', null);

-- Populando os locais de armazenagem (estoque).
insert into estoque (local_estoque, quantidade) values
('Rio de Janeiro',1000),
('Rio de Janeiro',500),
('São Paulo', 10),
('São Paulo', 100),
('Brasília',60),
('Brasília', 200);

-- Associando os produtos previamente cadastrados aos galpões de estoque.
insert into produto_estoque (id_produto, id_estoque, regiao) values
(1,2,'RJ'),
(2,6,'GO');

-- Vinculando formas de pagamento aos clientes; repare que o cliente ID 1 possui dois meios cadastrados.
insert into pagamento (id_cliente, tipo_pagamento, limite_disponivel) values
(1, 'Cartão', 2000),
(1, 'Boleto', null),
(2, 'Boleto', null),
(3, 'Dois cartões', 5000),
(4, 'Dinheiro', null);

select * from pagamento;

-- Inserindo fornecedores B2B.
insert into fornecedor (razao_social, cnpj, contato) values
('Alameda e filhos', '12345678912345', '21985474'),
('Eletrônicos Silva', '85456196491434', '21985484'),
('Eletrônicos Valma', '93456789393469', '21975474');

select * from fornecedor;

-- Relacionando produtos aos seus respectivos fornecedores.
insert into produto_fornecedor (id_fornecedor, id_produto, quantidade) values
(1,1,500),
(1,2,400),
(2,4,633),
(3,3,5),
(2,5,10);

-- Inserindo vendedores terceiros (Marketplace).
insert into vendedor (razao_social, nome_fantasia, cnpj, cpf, localizacao, contato) values
('Tech Eletronics', null, '12345678945632', null, 'Rio de Janeiro', '219946287'),
('Boutique Durgas', null, null, '12345678312', null, '219567895'),
('Kids World', null, '45678912365448', null, 'São Paulo', '1198657484');

select * from vendedor;

-- Relacionando quais produtos do e-commerce são vendidos pelos vendedores terceiros.
insert into produto_vendedor (id_vendedor, id_produto, quantidade) values
(1,6,80),
(2,7,10);

select * from produto_vendedor;

-- CONSULTAS DE ANÁLISE DE DADOS

-- Conta o número total de clientes cadastrados.
select count(*) from cliente;

-- Junção simples estilo produto cartesiano filtrado no WHERE. O segundo select utiliza CONCAT para formatar o nome completo como Atributo Derivado.
select nome, sobrenome, id_pedido, status_pedido from cliente c, pedido o where c.id_cliente = o.id_cliente;
select concat(nome,' ',sobrenome) as Cliente, id_pedido as Pedido, status_pedido as Status from cliente c, pedido o where c.id_cliente = o.id_cliente;

-- Agrupa dados de clientes e pedidos contando a volumetria por ID do pedido.
select count(*) from cliente c, pedido o 
where c.id_cliente = o.id_cliente
group by o.id_pedido;

select * from pedido;

-- Recupera a quantidade exata de pedidos feitos por cada cliente utilizando INNER JOINs para cruzar Cliente > Pedido > Produto_Pedido.
select c.id_cliente, nome, count(*) as numero_de_pedidos 
from cliente c 
inner join pedido o ON c.id_cliente = o.id_cliente
inner join produto_pedido po ON o.id_pedido = po.id_pedido
group by c.id_cliente, nome;

-- Ordena (ORDER BY) a exibição dos produtos dando prioridade às maiores avaliações (descendente) e, em caso de empate, por ordem alfabética de nome (ascendente).
select nome, categoria, avaliacao
from produto
order by avaliacao desc, nome asc;

-- Agrupa as informações e utiliza o HAVING (filtro de grupo) para exibir apenas clientes recorrentes (com mais de 1 pedido).
select c.id_cliente, nome, count(o.id_pedido) as numero_de_pedidos
from cliente c
inner join pedido o on c.id_cliente = o.id_cliente
group by c.id_cliente, nome
having count(o.id_pedido) > 1
order by numero_de_pedidos desc;

-- Filtra os dados de pedidos especificamente para aqueles que já estão confirmados E cujo método foi dinheiro.
select id_pedido, id_cliente, status_pedido, pagamento_em_dinheiro
from pedido
where status_pedido = 'Confirmado' and pagamento_em_dinheiro = 1;

-- Verifica se algum Vendedor também atua como Fornecedor, cruzando as duas tabelas através de seus CNPJs.
select v.razao_social as nome_vendedor, f.razao_social as nome_fornecedor, v.cnpj
from vendedor v
inner join fornecedor f on v.cnpj = f.cnpj;

-- Consulta complexa que cruza 5 tabelas (com INNER JOIN e LEFT JOIN) para listar os produtos, quem fornece e qual a situação deles fisicamente nos estoques.
select p.nome as produto,
f.razao_social as fornecedor,
pf.quantidade as qtd_fornecida,
e.local_estoque,
e.quantidade as qtd_em_estoque
from produto p
inner join produto_fornecedor pf on p.id_produto = pf.id_produto
inner join fornecedor f on pf.id_fornecedor = f.id_fornecedor
left join produto_estoque pe on p.id_produto = pe.id_produto
left join estoque e on pe.id_estoque = e.id_estoque
order by p.nome;

-- Exibe a relação direta dos nomes de fornecedores com os nomes dos produtos que eles comercializam, organizando em ordem alfabética por fornecedor.
select f.razao_social as fornecedor, p.nome as produto, pf.quantidade
from fornecedor f
inner join produto_fornecedor pf on f.id_fornecedor = pf.id_fornecedor
inner join produto p on pf.id_produto = p.id_produto
order by f.razao_social, p.nome;

