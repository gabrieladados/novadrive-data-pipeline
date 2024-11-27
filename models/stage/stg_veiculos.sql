{{config(materialized='view')}}

WITH fonte_veiculos AS (

    SELECT
        ID_VEICULOS,
        INITCAP(NOME) AS NOME_VEICULO,
        INITCAP(TIPO) AS TIPO_VEICULO,
        VALOR::DECIMAL(10,2) AS VALOR_VEICULO,
        DATA_INCLUSAO,
        COALESCE(DATA_ATUALIZACAO, CURRENT_TIMESTAMP()) AS DATA_ATUALIZACAO
    FROM {{source('sources', 'veiculos')}}

)

SELECT 
    ID_VEICULOS,
    NOME_VEICULO,
    TIPO_VEICULO,
    VALOR_VEICULO,
    DATA_INCLUSAO,
    DATA_ATUALIZACAO
FROM fonte_veiculos