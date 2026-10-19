-- mechanic_shop - DADOS DE TESTE
-- Execute depois de eer_mechanic_shop.sql
-- Execute apenas uma vez (ids fixos geram erro de chave duplicada se repetido)

USE `mechanic_shop`;

-- Clientes (o cliente 4 não possui veículo, de propósito, para testar LEFT JOIN)
INSERT INTO `cliente` (`id_cliente`, `nome_completo`, `endereco`, `telefone`) VALUES
(1, 'Carlos Silva',     'Rua das Flores, 123 - São Paulo', '(11) 98765-4321'),
(2, 'Ana Souza',        'Av. Paulista, 1000 - São Paulo',  '(11) 91234-5678'),
(3, 'Marcos Oliveira',  'Rua Bahia, 45 - Santo André',     '(11) 99888-7766'),
(4, 'Juliana Costa',    'Rua Verde, 78 - São Caetano',     '(11) 97777-1122');

-- Veículos (Carlos possui 2 veículos; Fiat aparece 2 vezes)
INSERT INTO `veiculo` (`id_veiculo`, `marca`, `modelo`, `id_cliente`, `placa`) VALUES
(1, 'Volkswagen', 'Gol',   1, 'ABC-1234'),
(2, 'Chevrolet',  'Onix',  2, 'XYZ-9876'),
(3, 'Fiat',       'Palio', 3, 'DEF-5678'),
(4, 'Fiat',       'Uno',   1, 'GHI-4321');

-- Equipes (a equipe 103 não possui mecânicos nem ordens, de propósito)
INSERT INTO `equipe` (`id_equipe`, `codigo_equipe`) VALUES
(1, 101),
(2, 102),
(3, 103);

-- Mecânicos
INSERT INTO `mecanico` (`id_mecanico`, `codigo_mecanico`, `nome_completo`, `especialidade`, `endereco`, `id_equipe`) VALUES
(1, 201, 'Roberto Santos', 'Motor',     'Rua A, 10 - São Paulo',    1),
(2, 202, 'Lucas Pereira',  'Suspensão', 'Rua B, 20 - São Paulo',    1),
(3, 203, 'Fernanda Lima',  'Elétrica',  'Rua C, 30 - Santo André',  2),
(4, 204, 'Paulo Mendes',   'Freios',    'Rua D, 40 - São Paulo',    2);

-- Peças
INSERT INTO `peca` (`id_peca`, `valor`, `descricao`) VALUES
(1, 150.00, 'Pastilha de Freio'),
(2,  80.00, 'Filtro de Óleo'),
(3, 350.00, 'Amortecedor Dianteiro'),
(4,  40.00, 'Vela de Ignição');

-- Mão de obra
INSERT INTO `mao_de_obra` (`id_mao_de_obra`, `descricao`, `valor_referencia`) VALUES
(1, 'Troca de Pastilha de Freio',        100.00),
(2, 'Revisão Geral e Troca de Filtro',   150.00),
(3, 'Substituição de Suspensão',         300.00),
(4, 'Diagnóstico Elétrico',              120.00);

-- Serviços
INSERT INTO `servico` (`id_servico`, `valor`, `descricao`, `id_mao_de_obra`) VALUES
(1, 120.00, 'Serviço de Freios',        1),
(2, 180.00, 'Serviço de Troca de Óleo', 2),
(3, 350.00, 'Serviço de Suspensão',     3),
(4, 200.00, 'Serviço de Elétrica',      4);

-- Ordens de serviço
-- O campo valor = soma dos serviços + soma de (peça x quantidade) de cada ordem:
--   1001: serviços 120+180=300   | peças 2x150 + 1x80          = 380  -> 680.00
--   1002: serviços 350           | peças 2x350                 = 700  -> 1050.00
--   1003: serviços 120           | peças 1x150                 = 150  -> 270.00
--   1004: serviços 180+200=380   | peças 1x80 + 4x40           = 240  -> 620.00
--   1005: serviços 180           | peças 1x80                  = 80   -> 260.00
INSERT INTO `ordem_servico` (`id_ordem_servico`, `numero`, `data_emissao`, `data_entrega`, `valor`, `status`, `data_conclusao`, `id_veiculo`, `id_equipe`, `autorizado`) VALUES
(1, 1001, '2026-10-01', '2026-10-05',  680.00, 'Concluído',            '2026-10-04', 1, 1, 1),
(2, 1002, '2026-10-05', '2026-10-10', 1050.00, 'Em Andamento',         NULL,         2, 1, 1),
(3, 1003, '2026-10-08', '2026-10-12',  270.00, 'Aguardando Aprovação', NULL,         3, 2, 0),
(4, 1004, '2026-10-10', '2026-10-14',  620.00, 'Concluído',            '2026-10-16', 4, 2, 1),
(5, 1005, '2026-10-12', '2026-10-15',  260.00, 'Concluído',            '2026-10-15', 1, 1, 1);

-- Ordem de serviço x serviço
INSERT INTO `ordem_servico_servico` (`id_ordem_servico`, `id_servico`) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 1),
(4, 2),
(4, 4),
(5, 2);

-- Ordem de serviço x peça
INSERT INTO `ordem_servico_peca` (`id_ordem_servico`, `id_peca`, `quantidade`) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 3, 2),
(3, 1, 1),
(4, 2, 1),
(4, 4, 4),
(5, 2, 1);
