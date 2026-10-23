USE ecommerce_db;

-- ÍNDICES

-- Pedidos de um cliente, ordenados por data (histórico do cliente).
CREATE INDEX idx_pedido_cliente_data ON pedido (id_cliente, data_compra);

-- Redundante: o composto acima já cobre id_cliente (e atende à FK).
ALTER TABLE pedido DROP INDEX idx_pedido_cliente;

-- Pedidos por status e período (ex.: pendentes desde uma data).
CREATE INDEX idx_pedido_status_data ON pedido (status_pedido, data_compra);

-- Busca de produto por nome (prefixo, ex.: LIKE 'Notebook%').
CREATE INDEX idx_produto_nome ON produto (nome);

-- Rastreio único; acelera a consulta por código.
ALTER TABLE entrega ADD UNIQUE idx_entrega_rastreio (codigo_rastreio);

-- Busca de cliente por nome (prefixo).
CREATE INDEX idx_cliente_nome ON cliente (nome_completo);

-- Endereço padrão do cliente.
CREATE INDEX idx_endereco_cliente_padrao ON endereco (id_cliente, padrao);

-- Redundante: o composto acima já cobre id_cliente (e atende à FK).
ALTER TABLE endereco DROP INDEX idx_endereco_cliente;

-- VALIDAÇÃO (EXPLAIN): confere se cada índice é usado

-- Usa idx_pedido_cliente_data (filtro + ordenação).
EXPLAIN SELECT * FROM pedido
 WHERE id_cliente = 1 ORDER BY data_compra DESC;

-- Usa idx_pedido_status_data (igualdade + faixa).
EXPLAIN SELECT * FROM pedido
 WHERE status_pedido = 'processando'
   AND data_compra >= '2026-01-01';

-- Usa idx_produto_nome (LIKE com prefixo fixo).
EXPLAIN SELECT * FROM produto WHERE nome LIKE 'Notebook%';

-- Usa idx_entrega_rastreio (busca exata em índice único).
EXPLAIN SELECT * FROM entrega WHERE codigo_rastreio = 'BR123456789';

-- Usa idx_cliente_nome (LIKE com prefixo fixo).
EXPLAIN SELECT * FROM cliente WHERE nome_completo LIKE 'Maria%';

-- Usa idx_endereco_cliente_padrao (ambas as colunas do índice).
EXPLAIN SELECT * FROM endereco WHERE id_cliente = 1 AND padrao = 1;