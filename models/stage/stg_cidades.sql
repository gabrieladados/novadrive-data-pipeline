{{ config(materialized='view')}}

WITH fonte_cidades AS (

    SELECT 
        ID_CIDADES,
        INITCAP(CIDADE) AS NOME_CIDADE,
        ID_ESTADOS,
        DATA_INCLUSAO,
        COALESCE(DATA_ATUALIZACAO, DATA_INCLUSAO) AS DATA_ATUALIZACAO
    FROM {{source('sources', 'cidades')}}
)


SELECT 
    ID_CIDADES,
    NOME_CIDADE,
    ID_ESTADOS,
    DATA_INCLUSAO,
    DATA_ATUALIZACAO
FROM fonte_cidades