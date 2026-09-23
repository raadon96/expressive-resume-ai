# LinkedIn Profile — Experience Section

---

## ML Engineer
**Lumino AI · Full-time**
Jan 2022 – Present · San Francisco, CA · Hybrid

Led development of the model serving infrastructure supporting 5 production ML
services at a combined peak load of ~2,000 RPS, reducing p99 inference latency
by 40% through ONNX quantisation and dynamic batching.

- Designed and shipped a real-time feature store (Redis + PostgreSQL) consumed
  by 3 independent model teams, cutting feature computation duplication by ~60%.
- Implemented a model rollout framework supporting A/B testing and shadow mode,
  enabling safe gradual rollouts; caught 2 regressions in shadow mode before
  they reached production.
- Introduced MLflow for experiment tracking and a lightweight model card template
  adopted by all 4 data scientists on the team.
- Built Airflow DAGs for automated daily retraining of two high-churn prediction
  models, reducing manual retraining overhead from ~3h/week to zero.

---

## Python Backend Developer
**DataStream GmbH · Full-time**
Mar 2020 – Dec 2021 · Berlin, Germany · On-site

Built and maintained the ETL backbone ingesting 12 third-party data feeds into a
unified analytics platform, reducing average pipeline failure rate by 35% through
idempotent design and structured alerting.

- Designed a webhook ingestion service (FastAPI + Celery) handling ~5k events/day;
  implemented deduplication and dead-letter queuing to guarantee exactly-once
  delivery.
- Refactored the legacy synchronous report-generation module into an async Celery
  pipeline, cutting report delivery time from 8 minutes to under 45 seconds for
  the largest customers.
- Wrote and maintained integration test suite covering 80%+ of the ETL surface
  area, catching 3 data-loss bugs before they reached production.

---

## Software Consultant
**Freelance · Self-employed**
Jun 2019 – Feb 2020 · Remote

- Built a data collection and reporting tool for a small logistics client,
  automating a weekly Excel workflow and saving ~4 hours/week of manual
  processing.
- Delivered two small Django REST APIs for local SME clients; both projects
  completed on time and within scope.
