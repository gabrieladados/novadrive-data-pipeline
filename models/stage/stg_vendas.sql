{{config(materialized='view')}}

WITH fonte_vendas AS (

    SELECT 
        ID_VENDAS,
        ID_VEICULOS,
        ID_CONCESSIONARIAS,
        ID_VENDEDORES, 
        ID_CLIENTES,
        VALOR_PAGO::DECIMAL(10,2) AS VALOR_PAGO,
        DATA_VENDA,
        DATA_INCLUSAO,
        COALESCE(DATA_ATUALIZACAO, DATA_INCLUSAO) AS DATA_ATUALIZACAO
    FROM {{source('sources', 'vendas')}}
)

SELECT  
    ID_VENDAS,
    ID_VEICULOS,
    ID_CONCESSIONARIAS,
    ID_VENDEDORES, 
    ID_CLIENTES,
    VALOR_PAGO,
    DATA_VENDA, 
    DATA_INCLUSAO,
    DATA_ATUALIZACAO
FROM fonte_vendas