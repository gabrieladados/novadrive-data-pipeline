{{config(materalized='table')}}

SELECT 
    dim_con.ID_CONCESSIONARIAS AS id_concessionaria,
    dim_con.NOME_CONCESSIONARIA AS nome_concessionaria,
    dim_cid.NOME_CIDADE AS cidade,
    dim_est.NOME_ESTADO AS estado, 
    COUNT(fato.ID_VENDAS) AS qtd_vendas,
    ROUND(SUM(fato.VALOR_PAGO),2) AS total_venda,
    ROUND(AVG(fato.VALOR_PAGO), 2) AS media_venda
FROM {{ref('fato_vendas')}} AS fato
JOIN {{ref('dim_concessionarias')}} AS dim_con 
    ON fato.ID_CONCESSIONARIAS = dim_con.ID_CONCESSIONARIAS
JOIN {{ref('dim_cidades')}} AS dim_cid 
    ON dim_con.ID_CIDADES = dim_cid.ID_CIDADES
JOIN {{ref('dim_estados')}} AS dim_est
    ON dim_cid.ID_ESTADOS = dim_est.ID_ESTADOS
GROUP BY id_concessionaria, nome_concessionaria, cidade, estado
ORDER BY qtd_vendas DESC