{{config(materalized='table')}}

SELECT 
    dim_vei.ID_VEICULOS,
    dim_vei.NOME_VEICULO,
    dim_vei.TIPO_VEICULO,
    dim_vei.VALOR_VEICULO AS valor_sugerido,
    COUNT(fato.ID_VENDAS) AS qtd_vendida,
    ROUND(SUM(fato.valor_pago),2) AS total,
    ROUND(AVG(fato.valor_pago),2) AS valor_medio
FROM {{ref('fato_vendas')}} AS fato 
JOIN {{ref('dim_veiculos')}} AS dim_vei
    ON fato.ID_VEICULOS = dim_vei.ID_VEICULOS
GROUP BY dim_vei.ID_VEICULOS, dim_vei.NOME_VEICULO, dim_vei.TIPO_VEICULO, valor_sugerido
ORDER BY qtd_vendida DESC