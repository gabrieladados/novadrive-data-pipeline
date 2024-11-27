{{config(materialized='view')}}

WITH fonte_concessionarias AS (

    SELECT 
            ID_CONCESSIONARIAS,
            TRIM(CONCESSIONARIA) AS NOME_CONCESSIONARIA,
            ID_CIDADES,
            DATA_INCLUSAO,
            COALESCE(DATA_ATUALIZACAO, DATA_INCLUSAO) AS DATA_ATUALIZACAO
    FROM {{source('sources', 'concessionarias')}}

)

SELECT 
    ID_CONCESSIONARIAS,
    NOME_CONCESSIONARIA,
    ID_CIDADES,
    DATA_INCLUSAO,
    DATA_ATUALIZACAO
FROM fonte_concessionarias