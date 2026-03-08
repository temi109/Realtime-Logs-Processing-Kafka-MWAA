
# Realtime Event Processing of High Volume Event Logs

This project demonstrates a scalable event-driven data pipeline for real-time log processing. The architecture is built around a distributed streaming platform using Apache Kafka for event ingestion and Apache Airflow running on Amazon Managed Workflows for Apache Airflow for orchestration.

Logs generated from a simulated application are produced to Kafka topics, where they are ingested and processed through downstream workflows orchestrated by Airflow DAGs. The platform demonstrates how modern data engineering systems decouple event ingestion, processing, and orchestration to enable scalable and fault-tolerant data pipelines.

The project showcases common data platform design patterns used in production environments, including:

- Distributed event streaming
- Workflow orchestration
- Scalable pipeline execution
- Event-driven processing


## Data Flow
The pipeline processes log events through the following stages:

#### 1. Log Generation
- A producer simulates high-volume application logs.
- Log events are continuously published to a Kafka topic.

#### 2. Streaming Ingestion
- Apache Kafka acts as the event streaming platform, buffering and distributing log events across partitions for scalable consumption.

#### 3. Workflow Orchestration
- Apache Airflow DAGs running on Amazon Managed Workflows for Apache Airflow coordinate downstream processing tasks.

#### 4. Processing and Transformation
- Airflow tasks consume log batches and apply transformations, enabling structured analysis of event data.

#### 5. Downstream Consumption
- Processed data can be persisted, monitored, or used to power real-time analytics workflows.

## Scalability Considerations

The architecture is designed with distributed data systems principles to support high-throughput event processing.

Key scalability features include:

### Partitioned Streaming
- Kafka topics are partitioned to allow multiple consumers to process events in parallel.

### Decoupled Architecture
- Producers, streaming infrastructure, and orchestration are loosely coupled, allowing each component to scale independently.

### Fault Tolerance
- Kafka ensures durability and replayability of events, enabling recovery from downstream failures.

### Workflow Management
- Airflow DAGs enable reliable scheduling, retry logic, and monitoring of pipeline tasks.

This design mirrors real-world data platform architectures used to process large-scale event streams such as application logs, user interactions, and telemetry data.


## Architecture

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


  
