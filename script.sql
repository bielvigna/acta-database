/*
Script ACTA com ENUMs, CHECKs e ajustes de tamanhos de VARCHAR.
Nomes de tabelas e colunas preservados.
*/




-- ==============================================================================
-- ENUMs
-- ==============================================================================

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'enum_tamanho_empresa') THEN
        CREATE TYPE enum_tamanho_empresa AS ENUM ('PEQUENA', 'MEDIA', 'GRANDE');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'enum_status_geral') THEN
        CREATE TYPE enum_status_geral AS ENUM ('ATIVO', 'INATIVO', 'PENDENTE', 'BLOQUEADO', 'ARQUIVADO');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'enum_tipo_usuario') THEN
        CREATE TYPE enum_tipo_usuario AS ENUM ('ADMIN', 'GESTOR', 'COLABORADOR');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'enum_papel_ciclo') THEN
        CREATE TYPE enum_papel_ciclo AS ENUM ('RESPONSAVEL', 'PARTICIPANTE', 'EXECUTOR', 'VALIDADOR', 'OBSERVADOR');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'enum_status_ciclo') THEN
        CREATE TYPE enum_status_ciclo AS ENUM ('PLANEJAMENTO', 'EXECUCAO', 'VERIFICACAO', 'PADRONIZACAO', 'CONCLUIDO', 'CANCELADO', 'PAUSADO');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'enum_status_problema') THEN
        CREATE TYPE enum_status_problema AS ENUM ('ABERTO', 'EM_ANALISE', 'PRIORIZADO', 'RESOLVIDO', 'DESCARTADO');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'enum_origem_registro') THEN
        CREATE TYPE enum_origem_registro AS ENUM ('MANUAL', 'IA', 'FORMULARIO', 'IMPORTACAO', 'SISTEMA');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'enum_status_meta') THEN
        CREATE TYPE enum_status_meta AS ENUM ('NAO_INICIADA', 'EM_ANDAMENTO', 'ATINGIDA', 'PARCIALMENTE_ATINGIDA', 'NAO_ATINGIDA', 'CANCELADA');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'enum_prioridade') THEN
        CREATE TYPE enum_prioridade AS ENUM ('BAIXA', 'MEDIA', 'ALTA', 'CRITICA');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'enum_status_plano_acao') THEN
        CREATE TYPE enum_status_plano_acao AS ENUM ('RASCUNHO', 'APROVADO', 'EM_EXECUCAO', 'CONCLUIDO', 'CANCELADO');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'enum_status_treinamento') THEN
        CREATE TYPE enum_status_treinamento AS ENUM ('PENDENTE', 'CONFIRMADO', 'CONCLUIDO', 'DISPENSADO', 'CANCELADO');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'enum_status_tarefa') THEN
        CREATE TYPE enum_status_tarefa AS ENUM ('PENDENTE', 'EM_ANDAMENTO', 'BLOQUEADA', 'CONCLUIDA', 'ATRASADA', 'CANCELADA');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'enum_status_verificacao') THEN
        CREATE TYPE enum_status_verificacao AS ENUM ('NAO_VERIFICADO', 'APROVADO', 'PARCIAL', 'REPROVADO');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'enum_nivel_acesso') THEN
        CREATE TYPE enum_nivel_acesso AS ENUM ('PUBLICO', 'INTERNO', 'RESTRITO', 'SENSIVEL');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'enum_operacao_log') THEN
        CREATE TYPE enum_operacao_log AS ENUM ('INSERT', 'UPDATE', 'DELETE', 'LOGIN', 'LOGOUT', 'READ', 'EXPORT');
    END IF;
END $$;


CREATE TABLE IF NOT EXISTS empresa (
	id BIGSERIAL,
	cnpj CHAR(14) NOT NULL UNIQUE,
	nome VARCHAR(160),
	tamanho_empresa enum_tamanho_empresa NOT NULL,
	setor_empresa VARCHAR(100) NOT NULL,
	status enum_status_geral NOT NULL,
	criado_em TIMESTAMPTZ NOT NULL,
	atualizado_em TIMESTAMPTZ NOT NULL,
	PRIMARY KEY(id)
);




CREATE TABLE IF NOT EXISTS endereco_empresa (
	id BIGSERIAL,
	id_empresa BIGINT NOT NULL,
	cep CHAR(8) NOT NULL,
	uf CHAR(2) NOT NULL,
	cidade VARCHAR(100) NOT NULL,
	bairro VARCHAR(100) NOT NULL,
	logradouro VARCHAR(180) NOT NULL,
	numero_endereco VARCHAR(20) NOT NULL,
	complemento TEXT,
	principal BOOLEAN NOT NULL,
	criado_em TIMESTAMPTZ NOT NULL,
	atualizado_em TIMESTAMPTZ NOT NULL,
	PRIMARY KEY(id)
);




CREATE TABLE IF NOT EXISTS email_empresa (
	id BIGSERIAL,
	id_empresa BIGINT NOT NULL,
	email VARCHAR(254) NOT NULL,
	principal BOOLEAN NOT NULL,
	criado_em TIMESTAMPTZ NOT NULL,
	PRIMARY KEY(id),
	CONSTRAINT email_empresa_unique_0 UNIQUE (id_empresa, email)
);




CREATE TABLE IF NOT EXISTS telefone_empresa (
	id BIGSERIAL,
	id_empresa BIGINT NOT NULL,
	numero_telefone VARCHAR(20) NOT NULL,
	principal BOOLEAN NOT NULL,
	criado_em TIMESTAMPTZ NOT NULL,
	PRIMARY KEY(id),
	CONSTRAINT telefone_empresa_unique_0 UNIQUE (id_empresa, numero_telefone)
);




CREATE TABLE IF NOT EXISTS usuario_sistema (
	id BIGSERIAL,
	id_empresa BIGINT,
	nome VARCHAR(160) NOT NULL,
	email_login VARCHAR(254) NOT NULL UNIQUE,
	senha_hash TEXT NOT NULL,
	tipo_usuario enum_tipo_usuario NOT NULL,
	status enum_status_geral NOT NULL,
	criado_em TIMESTAMPTZ NOT NULL,
	atualizado_em TIMESTAMPTZ NOT NULL,
	PRIMARY KEY(id)
);




CREATE TABLE IF NOT EXISTS colaborador (
	id BIGSERIAL,
	id_empresa BIGINT NOT NULL,
	id_usuario BIGINT NOT NULL UNIQUE,
	cpf CHAR(11) NOT NULL UNIQUE,
	nome VARCHAR(160) NOT NULL,
	cargo VARCHAR(100) NOT NULL,
	area VARCHAR(100) NOT NULL,
	data_nascimento DATE NOT NULL,
	data_contratacao DATE NOT NULL,
	permissao_gestor BOOLEAN NOT NULL,
	status enum_status_geral NOT NULL,
	criado_em TIMESTAMPTZ NOT NULL,
	atualizado_em TIMESTAMPTZ NOT NULL,
	PRIMARY KEY(id)
);




CREATE TABLE IF NOT EXISTS email_colaborador (
	id BIGSERIAL,
	id_colaborador BIGINT NOT NULL,
	email VARCHAR(254) NOT NULL,
	principal BOOLEAN NOT NULL,
	criado_em TIMESTAMPTZ NOT NULL,
	PRIMARY KEY(id),
	CONSTRAINT email_colaborador_unique_0 UNIQUE (id_colaborador, email)
);




CREATE TABLE IF NOT EXISTS telefone_colaborador (
	id BIGSERIAL,
	id_colaborador BIGINT NOT NULL,
	numero_telefone VARCHAR(20) NOT NULL,
	principal BOOLEAN NOT NULL,
	criado_em TIMESTAMPTZ NOT NULL,
	PRIMARY KEY(id),
	CONSTRAINT telefone_colaborador_unique_0 UNIQUE (id_colaborador, numero_telefone)
);




CREATE TABLE IF NOT EXISTS colaborador_ciclo (
	id BIGSERIAL,
	id_colaborador BIGINT NOT NULL,
	id_ciclo BIGINT NOT NULL,
	papel_no_ciclo enum_papel_ciclo NOT NULL,
	criado_em TIMESTAMPTZ NOT NULL,
	PRIMARY KEY(id),
	CONSTRAINT colaborador_ciclo_unique_0 UNIQUE (id_colaborador, id_ciclo)
);




CREATE TABLE IF NOT EXISTS ciclo (
	id BIGSERIAL,
	id_empresa BIGINT NOT NULL,
	id_responsavel BIGINT NOT NULL,
	titulo VARCHAR(160) NOT NULL,
	descricao TEXT NOT NULL,
	status enum_status_ciclo NOT NULL,
	data_inicio DATE NOT NULL,
	data_estimada_fim DATE NOT NULL,
	data_fim_real DATE,
	criado_em TIMESTAMPTZ NOT NULL,
	PRIMARY KEY(id)
);




CREATE TABLE IF NOT EXISTS problema (
	id BIGSERIAL,
	id_ciclo BIGINT NOT NULL,
	id_causa_raiz BIGINT NOT NULL,
	id_problema_pai BIGINT,
	titulo VARCHAR(180) NOT NULL,
	descricao TEXT NOT NULL,
	peso NUMERIC(5,2) NOT NULL,
	status enum_status_problema NOT NULL,
	origem enum_origem_registro NOT NULL,
	persistente BOOLEAN NOT NULL,
	criado_por BIGINT,
	criado_em TIMESTAMPTZ NOT NULL,
	PRIMARY KEY(id)
);




CREATE TABLE IF NOT EXISTS priorizacao_problema_colaborador (
	id BIGSERIAL,
	id_problema BIGINT NOT NULL,
	id_colaborador BIGINT NOT NULL,
	posicao INTEGER NOT NULL,
	peso_calculado NUMERIC(5,2) NOT NULL,
	criado_em TIMESTAMPTZ NOT NULL,
	PRIMARY KEY(id),
	CONSTRAINT priorizacao_problema_colaborador_unique_0 UNIQUE (id_problema, id_colaborador)
);




CREATE TABLE IF NOT EXISTS causa_raiz (
	id BIGSERIAL,
	id_ciclo BIGINT NOT NULL,
	id_plano_acao BIGINT,
	descricao TEXT NOT NULL,
	origem enum_origem_registro NOT NULL,
	aceita BOOLEAN NOT NULL,
	validada_por BIGINT,
	validada_em TIMESTAMPTZ,
	principal BOOLEAN NOT NULL,
	criado_em TIMESTAMPTZ NOT NULL,
	atualizado_em TIMESTAMPTZ NOT NULL,
	PRIMARY KEY(id)
);




CREATE TABLE IF NOT EXISTS meta (
	id BIGSERIAL,
	id_ciclo BIGINT NOT NULL,
	objetivo TEXT NOT NULL,
	valor_base NUMERIC,
	valor_alvo NUMERIC,
	unidade VARCHAR(30),
	prazo DATE NOT NULL,
	status enum_status_meta NOT NULL,
	prioridade enum_prioridade NOT NULL,
	area VARCHAR(100),
	categoria VARCHAR(100),
	criado_em TIMESTAMPTZ NOT NULL,
	atualizado_em TIMESTAMPTZ NOT NULL,
	PRIMARY KEY(id)
);




CREATE TABLE IF NOT EXISTS meta_responsavel (
	id BIGSERIAL,
	id_meta BIGINT NOT NULL,
	id_colaborador BIGINT NOT NULL,
	criado_em TIMESTAMPTZ NOT NULL,
	PRIMARY KEY(id),
	CONSTRAINT meta_responsavel_unique_0 UNIQUE (id_meta, id_colaborador)
);




CREATE TABLE IF NOT EXISTS plano_acao (
	id BIGSERIAL,
	id_ciclo BIGINT NOT NULL,
	nome VARCHAR(160) NOT NULL,
	objetivo TEXT,
	prioridade enum_prioridade NOT NULL,
	status enum_status_plano_acao NOT NULL,
	origem enum_origem_registro NOT NULL,
	criado_por BIGINT,
	criado_em TIMESTAMPTZ NOT NULL,
	atualizado_em TIMESTAMPTZ NOT NULL,
	PRIMARY KEY(id)
);




CREATE TABLE IF NOT EXISTS plano_5w2h (
	id BIGSERIAL,
	id_plano_acao BIGINT NOT NULL UNIQUE,
	what_acao TEXT NOT NULL,
	why_justificativa TEXT NOT NULL,
	where_local TEXT NOT NULL,
	id_who_responsavel BIGINT NOT NULL,
	when_inicio DATE,
	when_fim DATE NOT NULL,
	how_modo_execucao TEXT NOT NULL,
	how_much_custo NUMERIC(12,2) NOT NULL,
	criado_em TIMESTAMPTZ NOT NULL,
	atualizado_em TIMESTAMPTZ NOT NULL,
	PRIMARY KEY(id)
);




CREATE TABLE IF NOT EXISTS treinamento (
	id BIGSERIAL,
	id_ciclo BIGINT NOT NULL,
	id_anexo_mongo INTEGER,
	id_responsavel BIGINT,
	titulo VARCHAR(160) NOT NULL,
	descricao TEXT,
	data_treinamento DATE NOT NULL,
	obrigatorio_default BOOLEAN NOT NULL,
	criado_em TIMESTAMPTZ NOT NULL,
	atualizado_em TIMESTAMPTZ NOT NULL,
	PRIMARY KEY(id)
);




CREATE TABLE IF NOT EXISTS colaborador_treinamento (
	id BIGSERIAL,
	id_treinamento BIGINT NOT NULL,
	id_colaborador BIGINT NOT NULL,
	obrigatorio BOOLEAN NOT NULL,
	status enum_status_treinamento NOT NULL,
	confirmado_em TIMESTAMPTZ,
	PRIMARY KEY(id),
	CONSTRAINT colaborador_treinamento_unique_0 UNIQUE (id_treinamento, id_colaborador)
);




CREATE TABLE IF NOT EXISTS efeito_secundario (
	id BIGSERIAL,
	id_verificacao_resultado BIGINT NOT NULL,
	descricao TEXT NOT NULL,
	peso DECIMAL NOT NULL,
	impacto_estimado TEXT,
	criado_em TIMESTAMPTZ NOT NULL,
	PRIMARY KEY(id)
);




CREATE TABLE IF NOT EXISTS alerta_prazo (
	id BIGSERIAL,
	id_tarefa BIGINT NOT NULL,
	id_usuario_destino BIGINT NOT NULL,
	mensagem TEXT NOT NULL,
	enviado_em TIMESTAMPTZ NOT NULL,
	lido_em TIMESTAMPTZ,
	PRIMARY KEY(id)
);




CREATE TABLE IF NOT EXISTS tarefa (
	id BIGSERIAL,
	id_plano_acao BIGINT NOT NULL,
	id_responsavel BIGINT NOT NULL,
	titulo VARCHAR(160) NOT NULL,
	descricao TEXT NOT NULL,
	prioridade enum_prioridade NOT NULL,
	status enum_status_tarefa NOT NULL,
	data_inicio_real DATE,
	data_fim_prevista DATE NOT NULL,
	data_fim_real DATE,
	criado_em TIMESTAMPTZ NOT NULL,
	atualizado_em TIMESTAMPTZ NOT NULL,
	PRIMARY KEY(id)
);




CREATE TABLE IF NOT EXISTS tarefa_dependencia (
	id_tarefa BIGINT NOT NULL,
	id_tarefa_dependencia BIGINT NOT NULL,
	criado_em TIMESTAMPTZ NOT NULL,
	PRIMARY KEY(id_tarefa, id_tarefa_dependencia)
);




CREATE TABLE IF NOT EXISTS verificacao_resultado (
	id BIGSERIAL,
	id_ciclo BIGINT NOT NULL,
	status enum_status_verificacao NOT NULL,
	resumo TEXT NOT NULL,
	observacao TEXT,
	criado_por BIGINT,
	criado_em TIMESTAMPTZ NOT NULL,
	PRIMARY KEY(id)
);




CREATE TABLE IF NOT EXISTS catalogo_dados (
	id BIGSERIAL,
	tabela VARCHAR(100) NOT NULL,
	coluna VARCHAR(100) NOT NULL,
	tipo_dado VARCHAR(80) NOT NULL,
	eh_pk BOOLEAN NOT NULL,
	eh_fk BOOLEAN NOT NULL,
	referencia TEXT,
	obrigatorio BOOLEAN NOT NULL,
	regra_negocio TEXT,
	nivel_acesso enum_nivel_acesso NOT NULL,
	observacao TEXT,
	criado_em TIMESTAMPTZ NOT NULL,
	PRIMARY KEY(id),
	CONSTRAINT catalogo_dados_unique_0 UNIQUE (tabela, coluna)
);




CREATE TABLE IF NOT EXISTS log_acesso_usuario (
	id BIGSERIAL,
	id_usuario BIGINT NOT NULL,
	id_ciclo BIGINT,
	acao_realizada VARCHAR(60) NOT NULL,
	acessado_em TIMESTAMPTZ NOT NULL,
	PRIMARY KEY(id)
);




CREATE TABLE IF NOT EXISTS atv_usuario_dia (
	id BIGSERIAL NOT NULL,
	id_usuario BIGINT,
	data_atv DATE,
	hora_inicio TIMESTAMPTZ NOT NULL,
	hora_fim TIMESTAMPTZ NOT NULL,
	qnt_acoes INTEGER NOT NULL,
	PRIMARY KEY(id)
);




CREATE TABLE IF NOT EXISTS log_auditoria (
	id BIGSERIAL NOT NULL,
	id_usuario BIGINT,
	id_registro BIGINT NOT NULL,
	tabela VARCHAR(100) NOT NULL,
	operacao enum_operacao_log NOT NULL,
	dados_antes JSONB NOT NULL,
	dados_depois JSONB NOT NULL,
	data_log TIMESTAMPTZ NOT NULL,
	PRIMARY KEY(id)
);




CREATE TABLE IF NOT EXISTS log_colaborador (
	id BIGSERIAL NOT NULL,
	id_colaborador BIGINT NOT NULL,
	id_usuario BIGINT NOT NULL,
	operacao enum_operacao_log NOT NULL,
	dados_antes JSONB NOT NULL,
	dados_depois JSONB NOT NULL,
	data_log TIMESTAMPTZ NOT NULL,
	PRIMARY KEY(id)
);




CREATE TABLE IF NOT EXISTS log_tarefa (
	id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY,
	id_tarefa BIGINT NOT NULL,
	id_usuario BIGINT NOT NULL,
	dados_antes JSONB NOT NULL,
	dados_depois JSONB NOT NULL,
	data_log TIMESTAMPTZ NOT NULL,
	operacao enum_operacao_log NOT NULL,
	PRIMARY KEY(id)
);




CREATE TABLE IF NOT EXISTS log_status (
	id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY,
	id_usuario BIGINT NOT NULL,
	id_registro BIGINT NOT NULL,
	tabela VARCHAR(100) NOT NULL,
	status_anterior VARCHAR(40) NOT NULL,
	status_atual VARCHAR(40) NOT NULL,
	data_log TIMESTAMPTZ NOT NULL,
	PRIMARY KEY(id)
);





-- ==============================================================================
-- CHECK constraints
-- ==============================================================================

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'empresa_cnpj_check') THEN
        ALTER TABLE empresa ADD CONSTRAINT empresa_cnpj_check
        CHECK (cnpj ~ '^[0-9]{14}$');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'empresa_nome_check') THEN
        ALTER TABLE empresa ADD CONSTRAINT empresa_nome_check
        CHECK (nome IS NULL OR LENGTH(TRIM(nome)) >= 2);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'endereco_empresa_cep_check') THEN
        ALTER TABLE endereco_empresa ADD CONSTRAINT endereco_empresa_cep_check
        CHECK (cep ~ '^[0-9]{8}$');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'endereco_empresa_uf_check') THEN
        ALTER TABLE endereco_empresa ADD CONSTRAINT endereco_empresa_uf_check
        CHECK (uf ~ '^[A-Z]{2}$');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'email_empresa_email_check') THEN
        ALTER TABLE email_empresa ADD CONSTRAINT email_empresa_email_check
        CHECK (email ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'telefone_empresa_numero_check') THEN
        ALTER TABLE telefone_empresa ADD CONSTRAINT telefone_empresa_numero_check
        CHECK (numero_telefone ~ '^[0-9]{10,15}$');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'usuario_sistema_email_login_check') THEN
        ALTER TABLE usuario_sistema ADD CONSTRAINT usuario_sistema_email_login_check
        CHECK (email_login ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'usuario_sistema_senha_hash_check') THEN
        ALTER TABLE usuario_sistema ADD CONSTRAINT usuario_sistema_senha_hash_check
        CHECK (LENGTH(senha_hash) >= 20);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'colaborador_cpf_check') THEN
        ALTER TABLE colaborador ADD CONSTRAINT colaborador_cpf_check
        CHECK (cpf ~ '^[0-9]{11}$');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'colaborador_datas_check') THEN
        ALTER TABLE colaborador ADD CONSTRAINT colaborador_datas_check
        CHECK (data_contratacao >= data_nascimento);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'email_colaborador_email_check') THEN
        ALTER TABLE email_colaborador ADD CONSTRAINT email_colaborador_email_check
        CHECK (email ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'telefone_colaborador_numero_check') THEN
        ALTER TABLE telefone_colaborador ADD CONSTRAINT telefone_colaborador_numero_check
        CHECK (numero_telefone ~ '^[0-9]{10,15}$');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ciclo_datas_check') THEN
        ALTER TABLE ciclo ADD CONSTRAINT ciclo_datas_check
        CHECK (
            data_estimada_fim >= data_inicio
            AND (data_fim_real IS NULL OR data_fim_real >= data_inicio)
        );
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'problema_peso_check') THEN
        ALTER TABLE problema ADD CONSTRAINT problema_peso_check
        CHECK (peso >= 0);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'priorizacao_posicao_check') THEN
        ALTER TABLE priorizacao_problema_colaborador ADD CONSTRAINT priorizacao_posicao_check
        CHECK (posicao > 0);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'priorizacao_peso_calculado_check') THEN
        ALTER TABLE priorizacao_problema_colaborador ADD CONSTRAINT priorizacao_peso_calculado_check
        CHECK (peso_calculado >= 0);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'meta_valores_check') THEN
        ALTER TABLE meta ADD CONSTRAINT meta_valores_check
        CHECK (
            (valor_base IS NULL OR valor_base >= 0)
            AND (valor_alvo IS NULL OR valor_alvo >= 0)
        );
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'plano_5w2h_datas_check') THEN
        ALTER TABLE plano_5w2h ADD CONSTRAINT plano_5w2h_datas_check
        CHECK (when_inicio IS NULL OR when_fim >= when_inicio);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'plano_5w2h_custo_check') THEN
        ALTER TABLE plano_5w2h ADD CONSTRAINT plano_5w2h_custo_check
        CHECK (how_much_custo >= 0);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'efeito_secundario_peso_check') THEN
        ALTER TABLE efeito_secundario ADD CONSTRAINT efeito_secundario_peso_check
        CHECK (peso >= 0);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'tarefa_datas_check') THEN
        ALTER TABLE tarefa ADD CONSTRAINT tarefa_datas_check
        CHECK (
            (data_inicio_real IS NULL OR data_fim_prevista >= data_inicio_real)
            AND (data_fim_real IS NULL OR data_inicio_real IS NULL OR data_fim_real >= data_inicio_real)
        );
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'tarefa_dependencia_diferente_check') THEN
        ALTER TABLE tarefa_dependencia ADD CONSTRAINT tarefa_dependencia_diferente_check
        CHECK (id_tarefa <> id_tarefa_dependencia);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'atv_usuario_dia_horario_check') THEN
        ALTER TABLE atv_usuario_dia ADD CONSTRAINT atv_usuario_dia_horario_check
        CHECK (hora_fim >= hora_inicio);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'atv_usuario_dia_qnt_acoes_check') THEN
        ALTER TABLE atv_usuario_dia ADD CONSTRAINT atv_usuario_dia_qnt_acoes_check
        CHECK (qnt_acoes >= 0);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'log_auditoria_json_check') THEN
        ALTER TABLE log_auditoria ADD CONSTRAINT log_auditoria_json_check
        CHECK (jsonb_typeof(dados_antes) = 'object' AND jsonb_typeof(dados_depois) = 'object');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'log_colaborador_json_check') THEN
        ALTER TABLE log_colaborador ADD CONSTRAINT log_colaborador_json_check
        CHECK (jsonb_typeof(dados_antes) = 'object' AND jsonb_typeof(dados_depois) = 'object');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'log_tarefa_json_check') THEN
        ALTER TABLE log_tarefa ADD CONSTRAINT log_tarefa_json_check
        CHECK (jsonb_typeof(dados_antes) = 'object' AND jsonb_typeof(dados_depois) = 'object');
    END IF;
END $$;

-- ==============================================================================
-- FOREIGN KEYS
-- ==============================================================================

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_endereco_empresa_id_empresa') THEN
        ALTER TABLE endereco_empresa
        ADD CONSTRAINT fk_endereco_empresa_id_empresa
        FOREIGN KEY(id_empresa) REFERENCES empresa(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_email_empresa_id_empresa') THEN
        ALTER TABLE email_empresa
        ADD CONSTRAINT fk_email_empresa_id_empresa
        FOREIGN KEY(id_empresa) REFERENCES empresa(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_telefone_empresa_id_empresa') THEN
        ALTER TABLE telefone_empresa
        ADD CONSTRAINT fk_telefone_empresa_id_empresa
        FOREIGN KEY(id_empresa) REFERENCES empresa(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_usuario_sistema_id_empresa') THEN
        ALTER TABLE usuario_sistema
        ADD CONSTRAINT fk_usuario_sistema_id_empresa
        FOREIGN KEY(id_empresa) REFERENCES empresa(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_colaborador_id_empresa') THEN
        ALTER TABLE colaborador
        ADD CONSTRAINT fk_colaborador_id_empresa
        FOREIGN KEY(id_empresa) REFERENCES empresa(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_colaborador_id_usuario') THEN
        ALTER TABLE colaborador
        ADD CONSTRAINT fk_colaborador_id_usuario
        FOREIGN KEY(id_usuario) REFERENCES usuario_sistema(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_email_colaborador_id_colaborador') THEN
        ALTER TABLE email_colaborador
        ADD CONSTRAINT fk_email_colaborador_id_colaborador
        FOREIGN KEY(id_colaborador) REFERENCES colaborador(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_telefone_colaborador_id_colaborador') THEN
        ALTER TABLE telefone_colaborador
        ADD CONSTRAINT fk_telefone_colaborador_id_colaborador
        FOREIGN KEY(id_colaborador) REFERENCES colaborador(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_ciclo_id_empresa') THEN
        ALTER TABLE ciclo
        ADD CONSTRAINT fk_ciclo_id_empresa
        FOREIGN KEY(id_empresa) REFERENCES empresa(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_ciclo_id_responsavel') THEN
        ALTER TABLE ciclo
        ADD CONSTRAINT fk_ciclo_id_responsavel
        FOREIGN KEY(id_responsavel) REFERENCES colaborador(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_colaborador_ciclo_id_colaborador') THEN
        ALTER TABLE colaborador_ciclo
        ADD CONSTRAINT fk_colaborador_ciclo_id_colaborador
        FOREIGN KEY(id_colaborador) REFERENCES colaborador(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_colaborador_ciclo_id_ciclo') THEN
        ALTER TABLE colaborador_ciclo
        ADD CONSTRAINT fk_colaborador_ciclo_id_ciclo
        FOREIGN KEY(id_ciclo) REFERENCES ciclo(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_problema_id_ciclo') THEN
        ALTER TABLE problema
        ADD CONSTRAINT fk_problema_id_ciclo
        FOREIGN KEY(id_ciclo) REFERENCES ciclo(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_problema_id_problema_pai') THEN
        ALTER TABLE problema
        ADD CONSTRAINT fk_problema_id_problema_pai
        FOREIGN KEY(id_problema_pai) REFERENCES problema(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_problema_criado_por') THEN
        ALTER TABLE problema
        ADD CONSTRAINT fk_problema_criado_por
        FOREIGN KEY(criado_por) REFERENCES usuario_sistema(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_priorizacao_id_problema') THEN
        ALTER TABLE priorizacao_problema_colaborador
        ADD CONSTRAINT fk_priorizacao_id_problema
        FOREIGN KEY(id_problema) REFERENCES problema(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_priorizacao_id_colaborador') THEN
        ALTER TABLE priorizacao_problema_colaborador
        ADD CONSTRAINT fk_priorizacao_id_colaborador
        FOREIGN KEY(id_colaborador) REFERENCES colaborador(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_causa_raiz_id_ciclo') THEN
        ALTER TABLE causa_raiz
        ADD CONSTRAINT fk_causa_raiz_id_ciclo
        FOREIGN KEY(id_ciclo) REFERENCES ciclo(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_causa_raiz_validada_por') THEN
        ALTER TABLE causa_raiz
        ADD CONSTRAINT fk_causa_raiz_validada_por
        FOREIGN KEY(validada_por) REFERENCES usuario_sistema(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_meta_id_ciclo') THEN
        ALTER TABLE meta
        ADD CONSTRAINT fk_meta_id_ciclo
        FOREIGN KEY(id_ciclo) REFERENCES ciclo(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_meta_responsavel_id_meta') THEN
        ALTER TABLE meta_responsavel
        ADD CONSTRAINT fk_meta_responsavel_id_meta
        FOREIGN KEY(id_meta) REFERENCES meta(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_meta_responsavel_id_colaborador') THEN
        ALTER TABLE meta_responsavel
        ADD CONSTRAINT fk_meta_responsavel_id_colaborador
        FOREIGN KEY(id_colaborador) REFERENCES colaborador(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_plano_acao_id_ciclo') THEN
        ALTER TABLE plano_acao
        ADD CONSTRAINT fk_plano_acao_id_ciclo
        FOREIGN KEY(id_ciclo) REFERENCES ciclo(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_plano_acao_criado_por') THEN
        ALTER TABLE plano_acao
        ADD CONSTRAINT fk_plano_acao_criado_por
        FOREIGN KEY(criado_por) REFERENCES usuario_sistema(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_plano_5w2h_id_plano_acao') THEN
        ALTER TABLE plano_5w2h
        ADD CONSTRAINT fk_plano_5w2h_id_plano_acao
        FOREIGN KEY(id_plano_acao) REFERENCES plano_acao(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_plano_5w2h_id_who_responsavel') THEN
        ALTER TABLE plano_5w2h
        ADD CONSTRAINT fk_plano_5w2h_id_who_responsavel
        FOREIGN KEY(id_who_responsavel) REFERENCES colaborador(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tarefa_id_plano_acao') THEN
        ALTER TABLE tarefa
        ADD CONSTRAINT fk_tarefa_id_plano_acao
        FOREIGN KEY(id_plano_acao) REFERENCES plano_acao(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tarefa_id_responsavel') THEN
        ALTER TABLE tarefa
        ADD CONSTRAINT fk_tarefa_id_responsavel
        FOREIGN KEY(id_responsavel) REFERENCES colaborador(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tarefa_dependencia_id_tarefa') THEN
        ALTER TABLE tarefa_dependencia
        ADD CONSTRAINT fk_tarefa_dependencia_id_tarefa
        FOREIGN KEY(id_tarefa) REFERENCES tarefa(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tarefa_dependencia_id_dependencia') THEN
        ALTER TABLE tarefa_dependencia
        ADD CONSTRAINT fk_tarefa_dependencia_id_dependencia
        FOREIGN KEY(id_tarefa_dependencia) REFERENCES tarefa(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_alerta_prazo_id_tarefa') THEN
        ALTER TABLE alerta_prazo
        ADD CONSTRAINT fk_alerta_prazo_id_tarefa
        FOREIGN KEY(id_tarefa) REFERENCES tarefa(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_alerta_prazo_id_usuario_destino') THEN
        ALTER TABLE alerta_prazo
        ADD CONSTRAINT fk_alerta_prazo_id_usuario_destino
        FOREIGN KEY(id_usuario_destino) REFERENCES usuario_sistema(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_treinamento_id_ciclo') THEN
        ALTER TABLE treinamento
        ADD CONSTRAINT fk_treinamento_id_ciclo
        FOREIGN KEY(id_ciclo) REFERENCES ciclo(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_treinamento_id_responsavel') THEN
        ALTER TABLE treinamento
        ADD CONSTRAINT fk_treinamento_id_responsavel
        FOREIGN KEY(id_responsavel) REFERENCES colaborador(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_colaborador_treinamento_id_treinamento') THEN
        ALTER TABLE colaborador_treinamento
        ADD CONSTRAINT fk_colaborador_treinamento_id_treinamento
        FOREIGN KEY(id_treinamento) REFERENCES treinamento(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_colaborador_treinamento_id_colaborador') THEN
        ALTER TABLE colaborador_treinamento
        ADD CONSTRAINT fk_colaborador_treinamento_id_colaborador
        FOREIGN KEY(id_colaborador) REFERENCES colaborador(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_verificacao_resultado_id_ciclo') THEN
        ALTER TABLE verificacao_resultado
        ADD CONSTRAINT fk_verificacao_resultado_id_ciclo
        FOREIGN KEY(id_ciclo) REFERENCES ciclo(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_verificacao_resultado_criado_por') THEN
        ALTER TABLE verificacao_resultado
        ADD CONSTRAINT fk_verificacao_resultado_criado_por
        FOREIGN KEY(criado_por) REFERENCES usuario_sistema(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_efeito_secundario_id_verificacao') THEN
        ALTER TABLE efeito_secundario
        ADD CONSTRAINT fk_efeito_secundario_id_verificacao
        FOREIGN KEY(id_verificacao_resultado) REFERENCES verificacao_resultado(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_log_acesso_usuario_id_usuario') THEN
        ALTER TABLE log_acesso_usuario
        ADD CONSTRAINT fk_log_acesso_usuario_id_usuario
        FOREIGN KEY(id_usuario) REFERENCES usuario_sistema(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_atv_usuario_dia_id_usuario') THEN
        ALTER TABLE atv_usuario_dia
        ADD CONSTRAINT fk_atv_usuario_dia_id_usuario
        FOREIGN KEY(id_usuario) REFERENCES usuario_sistema(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_log_auditoria_id_usuario') THEN
        ALTER TABLE log_auditoria
        ADD CONSTRAINT fk_log_auditoria_id_usuario
        FOREIGN KEY(id_usuario) REFERENCES usuario_sistema(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_problema_id_causa_raiz') THEN
        ALTER TABLE problema
        ADD CONSTRAINT fk_problema_id_causa_raiz
        FOREIGN KEY(id_causa_raiz) REFERENCES causa_raiz(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_causa_raiz_id_plano_acao') THEN
        ALTER TABLE causa_raiz
        ADD CONSTRAINT fk_causa_raiz_id_plano_acao
        FOREIGN KEY(id_plano_acao) REFERENCES plano_acao(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_log_acesso_usuario_id_ciclo') THEN
        ALTER TABLE log_acesso_usuario
        ADD CONSTRAINT fk_log_acesso_usuario_id_ciclo
        FOREIGN KEY(id_ciclo) REFERENCES ciclo(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_log_colaborador_id_colaborador') THEN
        ALTER TABLE log_colaborador
        ADD CONSTRAINT fk_log_colaborador_id_colaborador
        FOREIGN KEY(id_colaborador) REFERENCES colaborador(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_log_colaborador_id_usuario') THEN
        ALTER TABLE log_colaborador
        ADD CONSTRAINT fk_log_colaborador_id_usuario
        FOREIGN KEY(id_usuario) REFERENCES usuario_sistema(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_log_tarefa_id_tarefa') THEN
        ALTER TABLE log_tarefa
        ADD CONSTRAINT fk_log_tarefa_id_tarefa
        FOREIGN KEY(id_tarefa) REFERENCES tarefa(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_log_tarefa_id_usuario') THEN
        ALTER TABLE log_tarefa
        ADD CONSTRAINT fk_log_tarefa_id_usuario
        FOREIGN KEY(id_usuario) REFERENCES usuario_sistema(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_log_status_id_usuario') THEN
        ALTER TABLE log_status
        ADD CONSTRAINT fk_log_status_id_usuario
        FOREIGN KEY(id_usuario) REFERENCES usuario_sistema(id)
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    END IF;

END $$;
