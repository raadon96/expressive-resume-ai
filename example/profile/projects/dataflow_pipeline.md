# DataFlow Pipeline
Context: DataStream GmbH · 2020 · Python Backend Developer

## Summary
An Apache Airflow ETL framework that ingests 12 third-party data feeds into one analytics platform.
It gives every feed the same idempotent extraction, schema validation and dead-letter routing.

## Problem & Stakeholders
The feeds came from CRM, ERP, ad network and logistics APIs, and each had been integrated ad hoc.
A failed feed silently left customer dashboards stale, and "my data is wrong" was the top support ticket category.
The data team spent about 3 hours a week on on-call triage.

## What I Did
- Built a DAG factory that generates each feed's DAG from a YAML config (endpoint, auth, schema, schedule).
- Wrote the shared operators: `IdempotentExtractOperator`, `ValidateAndLoadOperator` and `DeadLetterOperator`.
- Added structured JSON logging for every DAG run, and alerts when a feed is more than 15 minutes late.
- Migrated all 12 feeds in 6 weeks.

## How It Works
The extract operator hashes each record and skips hashes it already knows.
Records that pass schema validation load into the data warehouse.
Records that fail go to a dead-letter table, which triggers an alert, and the data team reprocesses or discards them.

## Key Decisions
- Content hashing for idempotency: re-running a DAG for the same time window can't double-count, so retries are safe.
- YAML configs with no per-feed Python: adding a feed is a config change.
- Dead-letter table: invalid records are kept for review, never dropped.

## Results
- Cut pipeline failures by 35%, from about 4 a week to about 2.5.
- Cut on-call triage from about 3 hours a week to under 30 minutes.
- Migrated with no customer-visible downtime.

## Skills & Technologies
- Concepts: ETL, data pipeline orchestration, idempotency, schema validation, dead-letter routing, observability, zero-downtime migration
- Tools: Python, Apache Airflow, YAML
