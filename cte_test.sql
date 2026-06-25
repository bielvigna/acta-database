WITH usuarios_por_empresa AS (
    SELECT
        us.id_empresa,
        COUNT(*) AS qntd_usuarios,
        COUNT(*) FILTER (WHERE col.permissao_gestor = true) AS qnt_gestores
    FROM usuario_sistema us
    LEFT JOIN colaborador col
        ON col.id_usuario = us.id
    GROUP BY us.id_empresa
),

ciclos_por_empresa AS (
    SELECT
        id_empresa,
        COUNT(*) AS qnt_ciclos
    FROM ciclo
    GROUP BY id_empresa
)

SELECT
    e.nome AS empresa,
    COALESCE(u.qntd_usuarios, 0) AS qntd_usuarios,
    COALESCE(u.qnt_gestores, 0) AS qnt_gestores,
    COALESCE(c.qnt_ciclos, 0) AS qnt_ciclos
FROM empresa e
LEFT JOIN usuarios_por_empresa u
    ON u.id_empresa = e.id
LEFT JOIN ciclos_por_empresa c
    ON c.id_empresa = e.id
ORDER BY e.nome;