{{config(materialized='table')}}

WITH dim_estados AS (

    SELECT 
        CAST(ID_ESTADOS AS NUMBER) AS ID_ESTADOS,
        CAST(NOME_ESTADO AS VARCHAR) AS NOME_ESTADO,
        CAST(SIGLA_ESTADO AS VARCHAR) AS SIGLA_ESTADO,
        TO_CHAR(DATA_INCLUSAO,'YYYY-MM-DD HH24:MI') AS DATA_INCLUSAO,
        TO_CHAR(DATA_ATUALIZACAO, 'YYYY-MM-DD HH24:MI') AS DATA_ATUALIZACAO
    FROM {{ref('stg_estados')}}

)

SELECT 
    ID_ESTADOS,
    NOME_ESTADO,
    SIGLA_ESTADO,
    DATA_INCLUSAO,
    DATA_ATUALIZACAO
FROM dim_estados