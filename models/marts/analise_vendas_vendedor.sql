{{config(materalized='table')}}

SELECT 
    dim_ven.ID_VENDEDORES AS id_vendedor,
    dim_ven.NOME_VENDEDOR,
    dim_con.NOME_CONCESSIONARIA,
    COUNT(fato.id_vendas) AS qtd_vendas,
    ROUND(SUM(fato.valor_pago),2) AS total,
    ROUND(AVG(fato.valor_pago),2) AS valor_medio
FROM {{ref('fato_vendas')}} AS fato
JOIN {{ref('dim_vendedores')}} AS dim_ven
    ON fato.ID_VENDEDORES = dim_ven.ID_VENDEDORES 
JOIN {{ref('dim_concessionarias')}} AS dim_con
    ON dim_ven.ID_CONCESSIONARIAS = dim_con.ID_CONCESSIONARIAS
GROUP BY id_vendedor, dim_ven.NOME_VENDEDOR, dim_con.NOME_CONCESSIONARIA
ORDER BY qtd_vendas DESC