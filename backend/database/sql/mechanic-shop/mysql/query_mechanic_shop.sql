-- mechanic_shop - QUERIES SQL
-- Execute depois de eer_mechanic_shop.sql e inserts_mechanic_shop.sql

USE `mechanic_shop`;

-- 1. RECUPERAÇÕES SIMPLES COM SELECT

-- 1.1 Todos os clientes cadastrados
SELECT id_cliente, nome_completo, endereco, telefone
FROM cliente;

-- 1.2 Nome e telefone dos clientes
SELECT nome_completo, telefone
FROM cliente;

-- 1.3 Marcas e modelos de veículos, sem repetição
SELECT DISTINCT marca, modelo
FROM veiculo;

-- 1.4 Catálogo de peças
SELECT id_peca, descricao, valor
FROM peca;

-- 1.5 Mecânicos e suas especialidades
SELECT codigo_mecanico, nome_completo, especialidade
FROM mecanico;

-- 2. FILTROS COM WHERE

-- 2.1 Ordens com status 'Concluído'
SELECT numero, data_emissao, valor, status
FROM ordem_servico
WHERE status = 'Concluído';

-- 2.2 Veículos da marca Fiat
SELECT placa, marca, modelo
FROM veiculo
WHERE marca = 'Fiat';

-- 2.3 Ordens ainda não concluídas (sem data de conclusão)
SELECT numero, status, data_entrega
FROM ordem_servico
WHERE data_conclusao IS NULL;

-- 2.4 Ordens autorizadas com valor acima de R$ 500,00
SELECT numero, valor, status
FROM ordem_servico
WHERE autorizado = 1
  AND valor > 500.00;

-- 2.5 Ordens emitidas entre 01/10/2026 e 10/10/2026
SELECT numero, data_emissao, valor
FROM ordem_servico
WHERE data_emissao BETWEEN '2026-10-01' AND '2026-10-10';

-- 2.6 Peças com valor entre R$ 50,00 e R$ 200,00
SELECT descricao, valor
FROM peca
WHERE valor BETWEEN 50.00 AND 200.00;

-- 2.7 Clientes cujo nome termina com "Silva"
SELECT id_cliente, nome_completo, telefone
FROM cliente
WHERE nome_completo LIKE '%Silva';

-- 2.8 Mecânicos especialistas em Motor ou Suspensão
SELECT nome_completo, especialidade
FROM mecanico
WHERE especialidade IN ('Motor', 'Suspensão');

-- 2.9 Ordens com status diferente de 'Concluído'
SELECT numero, status, data_entrega
FROM ordem_servico
WHERE status <> 'Concluído';

-- 3. EXPRESSÕES PARA ATRIBUTOS DERIVADOS
-- 3.1 Valor reajustado em 10% e custo operacional estimado em 80%
SELECT numero,
       valor AS valor_atual,
       valor * 1.10 AS valor_reajustado_10_porcento,
       valor * 0.80 AS custo_estimado_80_porcento
FROM ordem_servico;

-- 3.2 Prazo previsto (em dias) entre emissão e entrega
SELECT numero,
       data_emissao,
       data_entrega,
       DATEDIFF(data_entrega, data_emissao) AS prazo_dias
FROM ordem_servico;

-- 3.3 Dias de atraso nas ordens concluídas depois da data de entrega
SELECT numero,
       data_entrega,
       data_conclusao,
       DATEDIFF(data_conclusao, data_entrega) AS dias_atraso
FROM ordem_servico
WHERE data_conclusao IS NOT NULL
  AND data_conclusao > data_entrega;

-- 3.4 Descrição completa do veículo (concatenação)
SELECT id_veiculo,
       CONCAT(marca, ' ', modelo, ' - Placa ', placa) AS descricao_veiculo
FROM veiculo;

-- 3.5 Situação da ordem derivada com CASE
SELECT numero,
       status,
       CASE
           WHEN autorizado = 1 AND data_conclusao IS NOT NULL THEN 'Autorizada e finalizada'
           WHEN autorizado = 1 AND data_conclusao IS NULL     THEN 'Autorizada em andamento'
           ELSE 'Aguardando autorização'
       END AS situacao
FROM ordem_servico;

-- 3.6 Serviço com acréscimo de 15% sobre a mão de obra de referência
SELECT s.descricao AS servico,
       s.valor AS valor_servico,
       m.valor_referencia,
       s.valor + (m.valor_referencia * 0.15) AS valor_com_acrescimo
FROM servico s
JOIN mao_de_obra m ON m.id_mao_de_obra = s.id_mao_de_obra;

-- 3.7 Subtotal de peças por item da ordem (valor x quantidade)
SELECT osp.id_ordem_servico,
       p.descricao AS peca,
       p.valor AS valor_unitario,
       osp.quantidade,
       p.valor * osp.quantidade AS subtotal
FROM ordem_servico_peca osp
JOIN peca p ON p.id_peca = osp.id_peca;

-- 4. ORDENAÇÃO COM ORDER BY
-- 4.1 Peças do maior para o menor valor
SELECT descricao, valor
FROM peca
ORDER BY valor DESC;

-- 4.2 Clientes em ordem alfabética
SELECT nome_completo, telefone
FROM cliente
ORDER BY nome_completo ASC;

-- 4.3 Ordens por status e, dentro do status, da emissão mais recente para a mais antiga
SELECT numero, status, data_emissao
FROM ordem_servico
ORDER BY status ASC, data_emissao DESC;

-- 4.4 Ordens do maior para o menor prazo previsto (atributo derivado)
SELECT numero,
       DATEDIFF(data_entrega, data_emissao) AS prazo_dias
FROM ordem_servico
ORDER BY prazo_dias DESC, numero ASC;

-- 4.5 As 3 ordens de maior valor
SELECT numero, valor
FROM ordem_servico
ORDER BY valor DESC
LIMIT 3;

-- 5. FILTROS EM GRUPOS COM HAVING
-- 5.1 Equipes com soma de ordens superior a R$ 500,00
SELECT e.codigo_equipe,
       COUNT(os.id_ordem_servico) AS qtd_ordens,
       SUM(os.valor) AS valor_total_os
FROM equipe e
JOIN ordem_servico os ON os.id_equipe = e.id_equipe
GROUP BY e.id_equipe, e.codigo_equipe
HAVING SUM(os.valor) > 500.00;

-- 5.2 Clientes com mais de um veículo cadastrado
SELECT c.nome_completo,
       COUNT(v.id_veiculo) AS qtd_veiculos
FROM cliente c
JOIN veiculo v ON v.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome_completo
HAVING COUNT(v.id_veiculo) > 1;

-- 5.3 Equipes com 2 ou mais mecânicos
SELECT e.codigo_equipe,
       COUNT(m.id_mecanico) AS qtd_mecanicos
FROM equipe e
JOIN mecanico m ON m.id_equipe = e.id_equipe
GROUP BY e.id_equipe, e.codigo_equipe
HAVING COUNT(m.id_mecanico) >= 2;

-- 5.4 Marcas com mais de um veículo cadastrado
SELECT marca,
       COUNT(*) AS qtd_veiculos
FROM veiculo
GROUP BY marca
HAVING COUNT(*) > 1;

-- 5.5 Status cujo valor médio das ordens supera a média geral
SELECT status,
       COUNT(*) AS qtd_ordens,
       AVG(valor) AS valor_medio
FROM ordem_servico
GROUP BY status
HAVING AVG(valor) > (SELECT AVG(valor) FROM ordem_servico);

-- 5.6 Peças utilizadas em 3 ou mais unidades no total
SELECT p.descricao,
       SUM(osp.quantidade) AS total_unidades
FROM peca p
JOIN ordem_servico_peca osp ON osp.id_peca = p.id_peca
GROUP BY p.id_peca, p.descricao
HAVING SUM(osp.quantidade) >= 3;

-- 5.7 Serviços executados em mais de uma ordem
SELECT s.descricao,
       COUNT(oss.id_ordem_servico) AS vezes_executado
FROM servico s
JOIN ordem_servico_servico oss ON oss.id_servico = s.id_servico
GROUP BY s.id_servico, s.descricao
HAVING COUNT(oss.id_ordem_servico) > 1;

-- 6. JUNÇÕES ENTRE TABELAS
-- 6.1 Cliente, veículo e ordem de serviço correspondente
SELECT c.nome_completo AS cliente,
       v.marca,
       v.modelo,
       v.placa,
       os.numero AS numero_os,
       os.status,
       os.valor
FROM cliente c
INNER JOIN veiculo v        ON v.id_cliente = c.id_cliente
INNER JOIN ordem_servico os ON os.id_veiculo = v.id_veiculo
ORDER BY c.nome_completo, os.numero;

-- 6.2 Ordens com cliente, veículo e equipe responsável
SELECT os.numero,
       os.data_emissao,
       os.status,
       os.valor,
       c.nome_completo AS cliente,
       CONCAT(v.marca, ' ', v.modelo) AS veiculo,
       v.placa,
       e.codigo_equipe
FROM ordem_servico os
JOIN veiculo v ON v.id_veiculo = os.id_veiculo
JOIN cliente c ON c.id_cliente = v.id_cliente
JOIN equipe e  ON e.id_equipe  = os.id_equipe
ORDER BY os.data_emissao DESC;

-- 6.3 Todos os clientes, inclusive os sem veículo (LEFT JOIN)
SELECT c.nome_completo,
       v.placa
FROM cliente c
LEFT JOIN veiculo v ON v.id_cliente = c.id_cliente
ORDER BY c.nome_completo;

-- 6.4 Clientes que ainda não possuem veículo cadastrado
SELECT c.id_cliente, c.nome_completo, c.telefone
FROM cliente c
LEFT JOIN veiculo v ON v.id_cliente = c.id_cliente
WHERE v.id_veiculo IS NULL;

-- 6.5 Equipes e seus mecânicos
SELECT e.codigo_equipe,
       m.codigo_mecanico,
       m.nome_completo AS mecanico,
       m.especialidade
FROM equipe e
JOIN mecanico m ON m.id_equipe = e.id_equipe
ORDER BY e.codigo_equipe, m.nome_completo;

-- 6.6 Equipes sem nenhuma ordem de serviço
SELECT e.id_equipe, e.codigo_equipe
FROM equipe e
LEFT JOIN ordem_servico os ON os.id_equipe = e.id_equipe
WHERE os.id_ordem_servico IS NULL;

-- 6.7 Serviços de cada ordem, com a mão de obra associada
SELECT os.numero,
       s.descricao AS servico,
       s.valor AS valor_servico,
       m.descricao AS mao_de_obra,
       m.valor_referencia
FROM ordem_servico os
JOIN ordem_servico_servico oss ON oss.id_ordem_servico = os.id_ordem_servico
JOIN servico s                 ON s.id_servico = oss.id_servico
JOIN mao_de_obra m             ON m.id_mao_de_obra = s.id_mao_de_obra
ORDER BY os.numero;

-- 6.8 Peças de cada ordem, com subtotal
SELECT os.numero,
       p.descricao AS peca,
       osp.quantidade,
       p.valor AS valor_unitario,
       p.valor * osp.quantidade AS subtotal
FROM ordem_servico os
JOIN ordem_servico_peca osp ON osp.id_ordem_servico = os.id_ordem_servico
JOIN peca p                 ON p.id_peca = osp.id_peca
ORDER BY os.numero, p.descricao;

-- 6.9 Conferência: valor da ordem x total calculado (serviços + peças)
SELECT c.nome_completo AS cliente,
       v.placa,
       os.numero AS ordem,
       os.valor AS valor_registrado,
       COALESCE(sv.total_servicos, 0) AS total_servicos,
       COALESCE(pc.total_pecas, 0)    AS total_pecas,
       COALESCE(sv.total_servicos, 0) + COALESCE(pc.total_pecas, 0) AS total_calculado,
       os.valor - (COALESCE(sv.total_servicos, 0) + COALESCE(pc.total_pecas, 0)) AS diferenca
FROM ordem_servico os
JOIN veiculo v ON v.id_veiculo = os.id_veiculo
JOIN cliente c ON c.id_cliente = v.id_cliente
LEFT JOIN (
    SELECT oss.id_ordem_servico, SUM(s.valor) AS total_servicos
    FROM ordem_servico_servico oss
    JOIN servico s ON s.id_servico = oss.id_servico
    GROUP BY oss.id_ordem_servico
) sv ON sv.id_ordem_servico = os.id_ordem_servico
LEFT JOIN (
    SELECT osp.id_ordem_servico, SUM(p.valor * osp.quantidade) AS total_pecas
    FROM ordem_servico_peca osp
    JOIN peca p ON p.id_peca = osp.id_peca
    GROUP BY osp.id_ordem_servico
) pc ON pc.id_ordem_servico = os.id_ordem_servico
ORDER BY os.numero;

-- 6.10 Total gasto por cliente em ordens autorizadas (JOIN + WHERE + GROUP BY + HAVING + ORDER BY)
SELECT c.nome_completo,
       COUNT(os.id_ordem_servico) AS qtd_ordens,
       SUM(os.valor) AS total_gasto
FROM cliente c
JOIN veiculo v        ON v.id_cliente = c.id_cliente
JOIN ordem_servico os ON os.id_veiculo = v.id_veiculo
WHERE os.autorizado = 1
GROUP BY c.id_cliente, c.nome_completo
HAVING SUM(os.valor) > 1000.00
ORDER BY total_gasto DESC;
