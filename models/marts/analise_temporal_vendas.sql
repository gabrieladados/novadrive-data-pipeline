{{config(materalized='table')}}

SELECT 
    DATE_TRUNC('month', DATA_INCLUSAO) AS mes_venda,
    COUNT(ID_VENDAS) AS qtd_vendas,
    ROUND(SUM(VALOR_PAGO), 2) AS total_vendas,
    ROUND(AVG(VALOR_PAGO),2) AS valor_medio
FROM {{ref('fato_vendas')}} AS fato
GROUP BY  DATE_TRUNC('month', DATA_INCLUSAO)
ORDER BY DATE_TRUNC('month', DATA_INCLUSAO) 


