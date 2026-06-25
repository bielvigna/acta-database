-- ==============================================================================
-- DATALOAD SIMPLES ACTA
-- Aproximadamente 20 registros de exemplo para teste inicial.
-- Execute depois de criar as tabelas, ENUMs, CHECKs e FKs.
-- ===============================================================================

BEGIN;

-- 1
INSERT INTO empresa (
    id, cnpj, nome, tamanho_empresa, setor_empresa, status, criado_em, atualizado_em
) VALUES (
    1, '12345678000195', 'ACTA Demo LTDA', 'MEDIA', 'Tecnologia', 'ATIVO', NOW(), NOW()
) ON CONFLICT DO NOTHING;

-- 2
INSERT INTO endereco_empresa (
    id, id_empresa, cep, uf, cidade, bairro, logradouro, numero_endereco,
    complemento, principal, criado_em, atualizado_em
) VALUES (
    1, 1, '04567000', 'SP', 'Sao Paulo', 'Vila Olimpia', 'Rua Demo ACTA', '100',
    'Conjunto 12', TRUE, NOW(), NOW()
) ON CONFLICT DO NOTHING;

-- 3
INSERT INTO email_empresa (
    id, id_empresa, email, principal, criado_em
) VALUES (
    1, 1, 'contato@actademo.com.br', TRUE, NOW()
) ON CONFLICT DO NOTHING;

-- 4
INSERT INTO telefone_empresa (
    id, id_empresa, numero_telefone, principal, criado_em
) VALUES (
    1, 1, '11999990000', TRUE, NOW()
) ON CONFLICT DO NOTHING;

-- 5
INSERT INTO usuario_sistema (
    id, id_empresa, nome, email_login, senha_hash, tipo_usuario, status, criado_em, atualizado_em
) VALUES (
    1, 1, 'Admin ACTA', 'admin@actademo.com.br', 'hash_demo_admin_1234567890', 'ADMIN', 'ATIVO', NOW(), NOW()
) ON CONFLICT DO NOTHING;

-- 6
INSERT INTO usuario_sistema (
    id, id_empresa, nome, email_login, senha_hash, tipo_usuario, status, criado_em, atualizado_em
) VALUES (
    2, 1, 'Mariana Gestora', 'mariana.gestora@actademo.com.br', 'hash_demo_gestor_123456789', 'GESTOR', 'ATIVO', NOW(), NOW()
) ON CONFLICT DO NOTHING;

-- 7
INSERT INTO usuario_sistema (
    id, id_empresa, nome, email_login, senha_hash, tipo_usuario, status, criado_em, atualizado_em
) VALUES (
    3, 1, 'Lucas Colaborador', 'lucas.colaborador@actademo.com.br', 'hash_demo_colaborador_12345', 'COLABORADOR', 'ATIVO', NOW(), NOW()
) ON CONFLICT DO NOTHING;

-- 8
INSERT INTO colaborador (
    id, id_empresa, id_usuario, cpf, nome, cargo, area, data_nascimento,
    data_contratacao, permissao_gestor, status, criado_em, atualizado_em
) VALUES (
    1, 1, 2, '12345678901', 'Mariana Gestora', 'Gerente de Operacoes', 'Operacoes',
    '1990-04-15', '2021-02-01', TRUE, 'ATIVO', NOW(), NOW()
) ON CONFLICT DO NOTHING;

-- 9
INSERT INTO colaborador (
    id, id_empresa, id_usuario, cpf, nome, cargo, area, data_nascimento,
    data_contratacao, permissao_gestor, status, criado_em, atualizado_em
) VALUES (
    2, 1, 3, '98765432100', 'Lucas Colaborador', 'Analista de Processos', 'Qualidade',
    '1998-09-20', '2023-06-10', FALSE, 'ATIVO', NOW(), NOW()
) ON CONFLICT DO NOTHING;

-- 10
INSERT INTO email_colaborador (
    id, id_colaborador, email, principal, criado_em
) VALUES (
    1, 1, 'mariana.gestora@actademo.com.br', TRUE, NOW()
) ON CONFLICT DO NOTHING;

-- 11
INSERT INTO telefone_colaborador (
    id, id_colaborador, numero_telefone, principal, criado_em
) VALUES (
    1, 1, '11988887777', TRUE, NOW()
) ON CONFLICT DO NOTHING;

-- 12
INSERT INTO ciclo (
    id, id_empresa, id_responsavel, titulo, descricao, status,
    data_inicio, data_estimada_fim, data_fim_real, criado_em
) VALUES (
    1, 1, 1, 'Ciclo PDCA - Reducao de Retrabalho',
    'Ciclo inicial para mapear causas de retrabalho e propor plano de acao.',
    'PLANEJAMENTO', '2026-06-01', '2026-08-30', NULL, NOW()
) ON CONFLICT DO NOTHING;

-- 13
INSERT INTO colaborador_ciclo (
    id, id_colaborador, id_ciclo, papel_no_ciclo, criado_em
) VALUES (
    1, 1, 1, 'RESPONSAVEL', NOW()
) ON CONFLICT DO NOTHING;

-- 14
INSERT INTO colaborador_ciclo (
    id, id_colaborador, id_ciclo, papel_no_ciclo, criado_em
) VALUES (
    2, 2, 1, 'PARTICIPANTE', NOW()
) ON CONFLICT DO NOTHING;

-- 15
INSERT INTO meta (
    id, id_ciclo, objetivo, valor_base, valor_alvo, unidade, prazo,
    status, prioridade, area, categoria, criado_em, atualizado_em
) VALUES (
    1, 1, 'Reduzir retrabalho mensal nos processos internos', 18.00, 10.00, 'percentual',
    '2026-08-30', 'EM_ANDAMENTO', 'ALTA', 'Operacoes', 'Produtividade', NOW(), NOW()
) ON CONFLICT DO NOTHING;

-- 16
INSERT INTO plano_acao (
    id, id_ciclo, nome, objetivo, prioridade, status, origem, criado_por, criado_em, atualizado_em
) VALUES (
    1, 1, 'Padronizacao de checklist operacional',
    'Criar checklist simples para reduzir falhas antes da entrega das tarefas.',
    'ALTA', 'APROVADO', 'MANUAL', 2, NOW(), NOW()
) ON CONFLICT DO NOTHING;

-- 17
INSERT INTO plano_5w2h (
    id, id_plano_acao, what_acao, why_justificativa, where_local,
    id_who_responsavel, when_inicio, when_fim, how_modo_execucao,
    how_much_custo, criado_em, atualizado_em
) VALUES (
    1, 1,
    'Criar checklist padrao para atividades criticas',
    'Evitar esquecimentos e diminuir retrabalho',
    'Setor de Operacoes',
    1, '2026-06-05', '2026-07-05',
    'Levantar principais erros, documentar etapas e validar com a equipe',
    0.00, NOW(), NOW()
) ON CONFLICT DO NOTHING;

-- 18
INSERT INTO tarefa (
    id, id_plano_acao, id_responsavel, titulo, descricao, prioridade, status,
    data_inicio_real, data_fim_prevista, data_fim_real, criado_em, atualizado_em
) VALUES (
    1, 1, 2, 'Mapear erros recorrentes',
    'Listar principais erros que geram retrabalho no fluxo atual.',
    'MEDIA', 'PENDENTE', NULL, '2026-07-01', NULL, NOW(), NOW()
) ON CONFLICT DO NOTHING;

-- 19
INSERT INTO treinamento (
    id, id_ciclo, id_anexo_mongo, id_responsavel, titulo, descricao,
    data_treinamento, obrigatorio_default, criado_em, atualizado_em
) VALUES (
    1, 1, NULL, 1, 'Treinamento de uso do checklist',
    'Capacitar colaboradores para usar o checklist antes da finalizacao das tarefas.',
    '2026-07-10', TRUE, NOW(), NOW()
) ON CONFLICT DO NOTHING;

-- 20
INSERT INTO colaborador_treinamento (
    id, id_treinamento, id_colaborador, obrigatorio, status, confirmado_em
) VALUES (
    1, 1, 2, TRUE, 'PENDENTE', NULL
) ON CONFLICT DO NOTHING;

-- Ajuste das sequences para evitar conflito em novos INSERTs sem id manual.
SELECT setval(pg_get_serial_sequence('empresa', 'id'), COALESCE((SELECT MAX(id) FROM empresa), 1), TRUE);
SELECT setval(pg_get_serial_sequence('endereco_empresa', 'id'), COALESCE((SELECT MAX(id) FROM endereco_empresa), 1), TRUE);
SELECT setval(pg_get_serial_sequence('email_empresa', 'id'), COALESCE((SELECT MAX(id) FROM email_empresa), 1), TRUE);
SELECT setval(pg_get_serial_sequence('telefone_empresa', 'id'), COALESCE((SELECT MAX(id) FROM telefone_empresa), 1), TRUE);
SELECT setval(pg_get_serial_sequence('usuario_sistema', 'id'), COALESCE((SELECT MAX(id) FROM usuario_sistema), 1), TRUE);
SELECT setval(pg_get_serial_sequence('colaborador', 'id'), COALESCE((SELECT MAX(id) FROM colaborador), 1), TRUE);
SELECT setval(pg_get_serial_sequence('email_colaborador', 'id'), COALESCE((SELECT MAX(id) FROM email_colaborador), 1), TRUE);
SELECT setval(pg_get_serial_sequence('telefone_colaborador', 'id'), COALESCE((SELECT MAX(id) FROM telefone_colaborador), 1), TRUE);
SELECT setval(pg_get_serial_sequence('ciclo', 'id'), COALESCE((SELECT MAX(id) FROM ciclo), 1), TRUE);
SELECT setval(pg_get_serial_sequence('colaborador_ciclo', 'id'), COALESCE((SELECT MAX(id) FROM colaborador_ciclo), 1), TRUE);
SELECT setval(pg_get_serial_sequence('meta', 'id'), COALESCE((SELECT MAX(id) FROM meta), 1), TRUE);
SELECT setval(pg_get_serial_sequence('plano_acao', 'id'), COALESCE((SELECT MAX(id) FROM plano_acao), 1), TRUE);
SELECT setval(pg_get_serial_sequence('plano_5w2h', 'id'), COALESCE((SELECT MAX(id) FROM plano_5w2h), 1), TRUE);
SELECT setval(pg_get_serial_sequence('tarefa', 'id'), COALESCE((SELECT MAX(id) FROM tarefa), 1), TRUE);
SELECT setval(pg_get_serial_sequence('treinamento', 'id'), COALESCE((SELECT MAX(id) FROM treinamento), 1), TRUE);
SELECT setval(pg_get_serial_sequence('colaborador_treinamento', 'id'), COALESCE((SELECT MAX(id) FROM colaborador_treinamento), 1), TRUE);

COMMIT;

