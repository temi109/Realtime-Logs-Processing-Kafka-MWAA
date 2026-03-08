
# Realtime Event Processing of High Volume Event Logs

This project demonstrates a scalable event-driven data pipeline for real-time log processing. The architecture is built around a distributed streaming platform using Apache Kafka for event ingestion and Apache Airflow running on Amazon Managed Workflows for Apache Airflow for orchestration.

Logs generated from a simulated application are produced to Kafka topics, where they are ingested and processed through downstream workflows orchestrated by Airflow DAGs. The platform demonstrates how modern data engineering systems decouple event ingestion, processing, and orchestration to enable scalable and fault-tolerant data pipelines.

The project showcases common data platform design patterns used in production environments, including:

- Distributed event streaming
- Workflow orchestration
- Scalable pipeline execution
- Event-driven processing

## Architecture Diagram

  <a href="https://github.com/temi109/Realtime-Logs-Processing-Kafka-MWAA.git">
    <img src="https://github.com/temi109/Realtime-Logs-Processing-Kafka-MWAA/blob/main/images/Realtime%20Logs%20Processing%20With%20Kafka%20%2B%20MWAA.png" alt="Logo" width="2000" height="2000">
  </a>

## Usage

### Create virtual Environment and install requirements

```sh

python -m venv venv

.\venv\Scripts\activate

pip install -r requirements.txt

  ```

### Create AWS infrastructure

```sh

terraform validate

terraform plan

terraform apply

  ```

You can the use MWAA UI to manage and run dag.


  
