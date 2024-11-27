{{config(materialized='view')}}

WITH fonte_vendedores AS (

    SELECT
        ID_VENDEDORES,
        INITCAP(NOME) AS NOME_VENDEDOR,
        ID_CONCESSIONARIAS,
        DATA_INCLUSAO,
        COALESCE(DATA_ATUALIZACAO, DATA_INCLUSAO) AS DATA_ATUALIZACAO
    FROM {{source('sources', 'vendedores')}}

)

SELECT
    ID_VENDEDORES,
    NOME_VENDEDOR,
    ID_CONCESSIONARIAS,
    DATA_INCLUSAO,
    DATA_ATUALIZACAO
FROM fonte_vendedores