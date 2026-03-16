# RFM Analysis projecto with Snowflake, DBT and Python

## 1. Project description
This project performs a complete RFM (Recency, Frequency, Monetary) analysis using transactional data. 
The database is **snowflake_sample_data** and the schema is **TPCH_SF1**.
It is implemented using **dbt** for data modeling and **Python** for analysis and visualization. **Snowflake** has been the data warehouse.

The project demonstrates:
- Data ingestion and cleaning (Raw → Bronze → Silver → Gold)
- Creation of dimension and fact tables
- Customer segmentation using RFM methodology
- Deep analysis of the aggregate constructed with RFM scores by customer.

The main objective is the development of an END-TO-END analytics engineering project.

## 2. Environment and Setup configuration
1. Clone the repository
```bash
git clone https://github.com/tu_usuario/tu_proyecto.git
cd tu_proyecto
```
2. Environment configuration
```bash
conda env create -f environment.yml
conda activate rfm_env
```
3. Create a profiles.yml file
```bash
cp profiles.yml.example ~/.dbt/profiles.yml
```
3. Add your Snowflake credentials
4. DBT execution
- Verify conexion
```bash
dbt debug
```
- Models execution
```bash
dbt run
```
- Test execution
```bash
dbt test
```
- Generate documentation
```bash
dbt docs generate
dbt docs serve
```