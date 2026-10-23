USE ecommerce_db;

DROP PROCEDURE IF EXISTS sp_manipula_cliente;

DELIMITER $$

-- CRUD de cliente em uma única procedure.
-- p_opcao: 1 = inserir | 2 = consultar | 3 = atualizar | 4 = excluir
CREATE PROCEDURE sp_manipula_cliente (
    IN p_opcao        INT,           -- operação desejada (1 a 4)
    IN p_id_cliente   INT,           -- ID do cliente (opções 2, 3 e 4)
    IN p_nome         VARCHAR(100),  -- nome completo
    IN p_email        VARCHAR(100),  -- e-mail (único)
    IN p_celular      CHAR(13),      -- celular
    IN p_telefone     CHAR(12)       -- telefone fixo
)
BEGIN
    -- Em qualquer erro SQL (ex.: e-mail duplicado, FK em uso): desfaz e informa.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Erro: operação não realizada (dados duplicados ou registro em uso).' AS mensagem;
    END;

    START TRANSACTION;

    CASE p_opcao

        -- 1) INSERIR: cria o cliente e retorna o novo ID.
        WHEN 1 THEN
            INSERT INTO cliente (nome_completo, email, celular, telefone)
            VALUES (p_nome, p_email, p_celular, p_telefone);
            SELECT LAST_INSERT_ID() AS id_cliente, 'Cliente inserido.' AS mensagem;

        -- 2) CONSULTAR: ID nulo lista todos; ID informado lista um.
        WHEN 2 THEN
            SELECT id_cliente, nome_completo, email, celular, telefone
              FROM cliente
             WHERE p_id_cliente IS NULL OR id_cliente = p_id_cliente;

        -- 3) ATUALIZAR: campos nulos são mantidos (COALESCE).
        WHEN 3 THEN
            UPDATE cliente
               SET nome_completo = COALESCE(p_nome, nome_completo),
                   email         = COALESCE(p_email, email),
                   celular       = COALESCE(p_celular, celular),
                   telefone      = COALESCE(p_telefone, telefone)
             WHERE id_cliente = p_id_cliente;

            IF ROW_COUNT() = 0 THEN
                SELECT 'Nenhum cliente atualizado.' AS mensagem;
            ELSE
                SELECT 'Cliente atualizado.' AS mensagem;
            END IF;

        -- 4) EXCLUIR: remove o cliente (cascata em endereço, PF/PJ e pagamentos;
        --    falha se houver pedidos, por causa do RESTRICT).
        WHEN 4 THEN
            DELETE FROM cliente WHERE id_cliente = p_id_cliente;

            IF ROW_COUNT() = 0 THEN
                SELECT 'Nenhum cliente removido.' AS mensagem;
            ELSE
                SELECT 'Cliente removido.' AS mensagem;
            END IF;

        -- Opção fora de 1–4: gera erro (tratado pelo handler acima).
        ELSE
            SIGNAL SQLSTATE '45000'
               SET MESSAGE_TEXT = 'Opção inválida. Use 1, 2, 3 ou 4.';
    END CASE;

    COMMIT;
END$$

DELIMITER ;

-- EXEMPLOS DE USO

-- Inserir
CALL sp_manipula_cliente(1, NULL, 'Maria Souza', 'maria@email.com', '5511999999999', NULL);

-- Consultar todos / consultar um
CALL sp_manipula_cliente(2, NULL, NULL, NULL, NULL, NULL);
CALL sp_manipula_cliente(2, 1, NULL, NULL, NULL, NULL);

-- Atualizar nome e celular (e-mail e telefone permanecem)
CALL sp_manipula_cliente(3, 1, 'Maria S. Lima', NULL, '5511988888888', NULL);

-- Excluir
CALL sp_manipula_cliente(4, 1, NULL, NULL, NULL, NULL);