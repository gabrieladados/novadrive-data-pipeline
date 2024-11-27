{{config(materialized='view')}}

WITH fonte_clientes AS(
    
    SELECT 
        ID_CLIENTES,
        INITCAP(CLIENTE) AS NOME_CLIENTE,
        TRIM(ENDERECO) AS ENDERECO,
        ID_CONCESSIONARIAS,
        DATA_INCLUSAO,
        COALESCE(DATA_ATUALIZACAO, DATA_INCLUSAO) AS DATA_ATUALIZACAO
    FROM {{source('sources', 'clientes')}}

)

SELECT 
    ID_CLIENTES,
    NOME_CLIENTE,
    ENDERECO,
    ID_CONCESSIONARIAS,
    DATA_INCLUSAO,
    DATA_ATUALIZACAO
FROM fonte_clientes