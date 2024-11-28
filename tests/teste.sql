-- A Drive Motors possui duas regras de negócio que precisam ser validadas:
-- 1ª Regra: O preço de venda do veículo deve ser igual ou inferior ao preço sugerido na tabela oficial.
-- 2ª Regra: O desconto aplicado não pode exceder o limite de 5% do valor do veículo.

WITH teste_preco AS (
    
    SELECT 
        fato.ID_VENDAS,
        fato.VALOR_PAGO,
        dim_vei.VALOR_VEICULO AS valor_sugerido,
        CASE 
            WHEN fato.VALOR_PAGO <= valor_sugerido AND fato.VALOR_PAGO >= valor_sugerido*0.95 THEN TRUE
            ELSE FALSE
        END AS regra_negocio
    FROM {{ref('fato_vendas')}} AS fato
    JOIN {{ref('dim_veiculos')}} AS dim_vei
        ON fato.ID_VEICULOS = dim_vei.ID_VEICULOS

)

SELECT *
FROM teste_preco
WHERE regra_negocio = FALSE