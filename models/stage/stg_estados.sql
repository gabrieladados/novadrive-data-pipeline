{{config(materialized='view')}}


WITH fonte_estados AS (

    SELECT 
            ID_ESTADOS,
            INITCAP(ESTADO) AS NOME_ESTADO,
            UPPER(SIGLA) AS SIGLA_ESTADO,
            DATA_INCLUSAO,
            COALESCE(DATA_ATUALIZACAO, DATA_INCLUSAO) AS DATA_ATUALIZACAO
    FROM {{source('sources', 'estados')}}
)

SELECT 
    ID_ESTADOS,
    NOME_ESTADO,
    SIGLA_ESTADO,
    DATA_INCLUSAO,
    DATA_ATUALIZACAO
FROM fonte_estados