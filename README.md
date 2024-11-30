# Do Data Warehouse ao Looker Studio: Projeto End-to-End de Análise para a concessionária Nova Drive

> Este projeto foi desenvolvido como parte do Bootcamp de Engenharia de Dados ministrado pelo professor Fernando Amaral. Ele consiste na construção de um Data Warehouse para uma concessionária fictícia, com foco na criação de pipelines de dados eficientes e visuais impactantes.
>


## 📝 Contexto

A **Nova Drive** é uma concessionária que enfrenta dificuldades na área de vendas para acessar e consumir dados de forma eficiente. Atualmente, a equipe precisa solicitar ao setor de TI a geração de relatórios do CRM, que são posteriormente exportados para o Excel e tratados manualmente. Esse processo é demorado, propenso a erros e deixa os dados frequentemente desatualizados. Além disso, há questões de segurança, já que o uso de planilhas manipuláveis pode comprometer a integridade das informações.

## 🎯 Objetivo do Projeto

O objetivo deste projeto é automatizar a **extração, carregamento e transformação (ELT)** dos dados, criando um pipeline que entregue um **dashboard** dinâmico e atualizado em tempo real. Com isso, a equipe de vendas poderá acessar informações seguras e precisas sobre os principais indicadores (KPIs) de forma ágil, sem depender de processos manuais, garantindo maior eficiência e confiança na tomada de decisões.

## 🛠️ Arquitetura do Projeto

A arquitetura do projeto foi organizada em camadas, seguindo boas práticas de engenharia de dados.

1. **Camada de Ingestão**: Extração dos dados do PostgreSQL.
2. **Camada de Orquestração**: Automação dos processos de extração, transformação e carregamento usando Airflow.
3. **Camada de Armazenamento**: Armazenamento dos dados transformados no Snowflake.
4. **Camada Analítica**: Modelagem dos dados no dbt para geração de tabelas analíticas.
5. **Visualização de Dados**: Dashboards criados no Looker Studio.

## 🛠️ Ferramentas Utilizadas

- **PostgreSQL**: Banco de dados de origem.
- **Airflow**: Orquestração e automação de pipelines.
- **Snowflake**: Data Warehouse na nuvem.
- **dbt**: Modelagem, testes e documentação de dados.
- **Looker Studio**: Visualização de dados e construção de dashboards.
- **AWS EC2**: Hospedagem da máquina virtual.
   

## 🚀 Etapas do Projeto

### **Etapa 1: Conexão com o banco de dados e exploração dos dados**

- Conexão com o banco de dados PostgreSQL usando o PgAdmin.
- Exploração inicial das tabelas e suas relações.

### **Etapa 2: Configuração da máquina virtual e do Airflow**

- Configuração de uma instância EC2 no AWS com Ubuntu.
- Instalação e configuração do Docker e Airflow.

### **Etapa 3: Configuração do Snowflake**

- Criação de uma conta no Snowflake.
- Configuração de objetos no Snowflake (banco de dados, schemas, tabelas e warehouses).

### **Etapa 4: Construção do pipeline com Airflow**

- Desenvolvimento de DAGs para extração, transformação e carregamento (ETL) dos dados.
- Testes de carregamento de dados no Snowflake.

### **Etapa 5: Modelagem analítica com dbt**

- Criação de modelos analíticos no dbt.
- Validação e teste de integridade dos dados.
- Execução de jobs para geração de tabelas analíticas.

### **Etapa 6: Construção do Dashboard no Looker Studio**

- Integração do Snowflake com o Looker Studio.
- Criação de dashboards com os principais KPIs da empresa.


## Exploração Incial dos Dados & Respondendo Questões
1. Liste todos os veículos com tipo 'SUV Compacta' e valor inferior a 30.000,00.
    ```sql
    SELECT *
    FROM veiculos
    WHERE tipo = 'SUV Compacta' AND valor <30000.00
    ```
2. Exiba o nome dos clientes e o nome das concessionárias onde realizaram suas compras.
       
   ```sql
   SELECT 
       cli.cliente,
       con.concessionaria
   FROM clientes AS cli
   JOIN concessionarias AS con
        ON cli.id_concessionarias = con.id_concessionarias
   ```

3. Conte quantos vendedores existem em cada concessionária.
       
   ```sql
    SELECT 
    	con.concessionaria AS nome_concessionaria,
    	COUNT(DISTINCT(ven.id_vendedores)) AS num_vendedores
    FROM concessionarias AS con
    JOIN vendedores AS ven
    ON con.id_concessionarias = ven.id_concessionarias
    GROUP BY nome_concessionaria
    ORDER BY num_vendedores DESC
   ```

4. Encontre os veículos mais caros vendidos em cada tipo de veículo.
   ```sql
    WITH base AS (
    
    SELECT *
    FROM vendas AS ven
    JOIN veiculos AS vei
    ON ven.id_veiculos = vei.id_veiculos
    ),
    
    mais_caros AS (
    SELECT 
    	tipo,
    	MAX(valor_pago) AS maior_valor
    FROM base
    GROUP BY tipo
    ORDER BY maior_valor DESC
    )
    
    SELECT *
    FROM mais_caros
        ORDER BY num_vendedores DESC
   ```
5. Liste o nome do cliente, o veículo comprado e o valor pago, para todas as vendas.
   ```sql
    SELECT 
    	cli.cliente,
    	vei.nome,
    	ven.valor_pago
    FROM vendas AS ven
    LEFT JOIN clientes AS cli
      ON ven.id_clientes = cli.id_clientes
    JOIN veiculos AS vei
      ON ven.id_veiculos = vei.id_veiculos
    ```
6. Identifique as concessionárias que venderam mais de 5 veículos.
   ```sql
   SELECT 
    	con.concessionaria,
    	COUNT(ven.id_veiculos) AS num_veiculos
    FROM vendas AS ven
    JOIN concessionarias AS con
    ON ven.id_concessionarias = con.id_concessionarias
    GROUP BY con.concessionaria
    HAVING COUNT(ven.id_veiculos) > 5
   ```
    
7. Liste os três veículos mais caros disponíveis.
   ```sql
    SELECT *
    FROM veiculos
    ORDER BY valor DESC
    LIMIT 3
   ```
       
8. Selecione todos os veículos adicionados no último mês.
   ```sql
    SELECT *
    FROM veiculos
    WHERE data_inclusao > CURRENT_TIMESTAMP - INTERVAL '1 month'
   ```
  
9. Liste todas as cidades e qualquer concessionária nelas, se houver.
   ```sql
    SELECT 
    	ciade,
    	concessionaria
    FROM cidades AS cid
    LEFT JOIN concessionarias AS con
      ON cid.id_cidades = con.id_cidadesd
    ```

10. Encontre clientes que compraram veículos 'SUV Premium Híbrida' ou veículos com valor acima de 60.000,00.
 ```sql
    SELECT 
      	cli.cliente,
      	CASE 
          WHEN vei.tipo = 'SUV Premium Híbrida' and ven.valor_pago > 60000 THEN 'SUV PH e >60k'
      		WHEN vei.tipo = 'SUV Premium Híbrida' THEN 'SUV PH'
      		WHEN ven.valor_pago > 60000 THEN '>60K'
      	END as tipo_cliente
    FROM vendas AS ven
    JOIN clientes AS cli
       ON ven.id_clientes = cli.id_clientes
    JOIN veiculos AS vei
      ON ven.id_veiculos = vei.id_veiculos
    WHERE vei.tipo = 'SUV Premium Híbrida' OR ven.valor_pago > 60000
   ```


## 🚀 Instalação e Configuração do Airflow com Docker

Para instalar e configurar o **Apache Airflow** utilizando o **Docker** no Ubuntu, siga os passos abaixo. Esses comandos serão usados para configurar o Airflow em um ambiente desacoplado e garantir que ele esteja rodando corretamente.

</details>

<details>
<summary>
 Passo a passo da Instalação
</summary>
  
  1. **Atualize a lista de pacotes do APT:**
     ```bash
      sudo apt-get update
      ```
  2. **Instale pacotes necessários para adicionar um novo repositório via HTTPS:**
      ```bash
      sudo apt-get install ca-certificates curl gnupg lsb-release
      ```
  
  3. **Crie o diretório para armazenar as chaves de repositórios:**
      ```bash
      sudo mkdir -m 0755 -p /etc/apt/keyrings
      ```
  
  4. **Adicione a chave GPG do repositório do Docker:**
      ```bash
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
      ```
  
  5. **Adicione o repositório do Docker às fontes do APT:**
      ```bash
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      ```
  
  6. **Atualize a lista de pacotes após adicionar o novo repositório do Docker:**
      ```bash
      sudo apt-get update
      ```
  
  7. **Instale o Docker e seus componentes:**
      ```bash
      sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
      ```
  
  8. **Baixe o arquivo `docker-compose.yaml` do Airflow:**
      ```bash
      curl -LfO 'https://airflow.apache.org/docs/apache-airflow/stable/docker-compose.yaml'
      ```
  
  9. **Crie os diretórios necessários para DAGs, logs e plugins:**
      ```bash
      mkdir -p ./dags ./logs ./plugins
      ```
  
  10. **Crie o arquivo `.env` com o UID do usuário para configurações de permissões do Docker:**
      ```bash
      echo -e "AIRFLOW_UID=$(id -u)" > .env
      ```
  
  11. **Inicie o Airflow com o comando:**
      ```bash
      sudo docker compose up airflow-init
      ```
  
  12. **Suba o Airflow em modo desacoplado:**
      ```bash
      sudo docker compose up -d
      ```
  
  13. **Aguarde até que o Airflow esteja pronto e saudável.**
  
  14. **Acesse o Airflow através do navegador utilizando o endereço (substitua a URL abaixo pelo IP público do seu servidor):**
      ```bash
      http://coloque_a_url_aqui:8080/
      ```
  
  15. **Edite o arquivo `docker-compose.yaml` e altere a configuração `AIRFLOW__CORE__LOAD_EXAMPLES` para `false`:**
      ```bash
      nano /home/ubuntu/docker-compose.yaml
      # Mude para falso
      AIRFLOW__CORE__LOAD_EXAMPLES: 'false'
      ```
  
  16. **Reinicie o Airflow após as alterações:**
      ```bash
      sudo docker compose stop
      sudo docker compose up -d
      sudo docker ps
      ```
</details>



## 🧑‍💻 Modelagem dos Dados no dbt e Testes

A modelagem dos dados no dbt foi dividida em três etapas principais: **staging**, **intermediate** e **marts**.

1. **Staging:** Carrega os dados brutos para a área de staging e renomeando campos necessários sem modificar substancialmente os dados.

2. **Intermediate:** Realiza transformações iniciais, como limpeza de dados e criação de joins, criando as tabelas dimensionais e a fato. 

3. **Marts:** A camada Marts é a etapa final da modelagem dimensional, onde os dados são organizados para análise de negócios, como vendas por período, concessionária, veículo e vendedor. É a camada consumida pelos usuários finais, seja por consultas diretas no Snowflake ou por meio de ferramentas de BI, facilitando a extração de insights de forma rápida e eficiente.


### Testes no dbt

Durante a modelagem, foram aplicados testes para garantir a qualidade e a consistência dos dados, como a verificação de dados nulos e a unicidade das chaves primárias. Além de um teste em específico para validar se os dados de acordo com as regras de negócio, são elas:

1. O preço de venda do veículo deve ser igual ou inferior ao valor sugerido.
2. O desconto aplicado não pode exceder 5% do valor do veículo.

#### Exemplos de comnados executados no dbt:
- **dbt run:** Executa os modelos e materializa-os no data warehouse.
- **dbt test –select source:*:** Realiza testes de qualidade nos dados de origem.
- **dbt test:** Valida os dados com base nas regras de negócio e condições do projeto.




## 📊 Dashboard no Looker Studio

- **KPIs monitorados e Análises Realizadas**:
    - Quantidade de vendas.
    - Total de vendas.
    - Valor médio de vendas
    - Análise temporal do total de vendas
    - Mapa da quantidade de vendas por estado.
    - Top 5 concessionárias em total de vendas.
    - Top 5 veículos em total de vendas.
    - Top 5 vendedores em total de vendas.
    <br>  
      
  > 👉 **Acesse o dashboard no Looker aqui:** https://lookerstudio.google.com/reporting/084f3415-ca37-4d1c-ba6f-adfe0df6becd
![analise_vendas](https://github.com/user-attachments/assets/af7e1b92-4fb6-4842-9ecd-b755895f0ae3)



## 🚀 Conclusão
Ao final deste projeto, conseguimos construir uma solução de engenharia de dados robusta e eficiente para a Nova Drive. O pipeline desenvolvido, com o uso de ferramentas modernas como Airflow, Snowflake, dbt e Looker Studio, garante que a área de vendas agora tenha acesso a dados atualizados em tempo real, sem depender de processos manuais demorados ou suscetíveis a erros.

O dashboard criado oferece uma visualização clara e interativa dos principais KPIs, permitindo que os gestores da Nova Drive acompanhem o desempenho das vendas, identifiquem tendências e tomem decisões informadas de maneira ágil e segura. Além disso, a automação do processo elimina a necessidade de intervenção manual constante e garante a integridade e segurança dos dados, resolvendo os principais desafios que a equipe enfrentava.

Essa solução não apenas otimiza o fluxo de trabalho, mas também proporciona mais confiança e agilidade na análise de dados, dando à Nova Drive uma vantagem estratégica no mercado competitivo de vendas de veículos.


---


## Constribuições

Muito obrigada por acompanhar meu projeto até aqui! 🎉

Contribuições são **muito bem-vindas**. Se você tem sugestões ou melhorias, fique à vontade para abrir uma **issue** ou enviar um **pull request**.

Gostou do projeto? Não esqueça de dar uma ⭐️! 


**Meus Contatos:**

💻 [LinkedIn](https://www.linkedin.com/in/gabrielasantanamorais/)  
📩 [E-mail](mailto:gabrielasmorais01@gmail.com)

**Até a próxima!** 🚀
