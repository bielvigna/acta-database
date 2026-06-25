# ACTA Database

Projeto de banco de dados do ACTA, contendo o script de criação das tabelas, um dataload simples para testes e uma CTE para consulta inicial dos dados.

## Arquivos do projeto

```text
script.sql
dataload_test.sql
cte_test.sql
```

## Descrição dos arquivos

### `script.sql`

Arquivo principal do banco de dados.

Contém:

- criação dos tipos `ENUM`;
- criação das tabelas;
- definição das chaves primárias;
- definição das constraints `CHECK`;
- definição das chaves estrangeiras.

### `dataload_test.sql`

Arquivo usado para popular o banco com dados de teste.

Contém inserts simples para validar o funcionamento das tabelas, relacionamentos e enums.

### `cte_test.sql`

Arquivo com uma consulta usando CTE para visualizar um resumo por empresa.

A consulta retorna campos como:

- empresa;
- quantidade de usuários;
- quantidade de gestores;
- quantidade de ciclos.

## Ordem de execução

Execute os arquivos nesta ordem:

```sql
-- 1. Criar estrutura do banco
\i script.sql

-- 2. Inserir dados de teste
\i dataload_test.sql

-- 3. Rodar consulta de teste
\i cte_test.sql
```