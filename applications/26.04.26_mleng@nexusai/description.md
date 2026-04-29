# Job Description

## ML Engineer — Nexus AI

**Company:** Nexus AI | San Francisco, CA (Hybrid)
**Posted:** April 2026

---

### About Nexus AI

Nexus AI builds real-time machine learning infrastructure for e-commerce and
logistics companies. Our platform processes over 10 billion prediction requests
per day, helping clients personalise recommendations, detect fraud, and optimise
delivery routes.

### The Role

We're looking for an ML Engineer to join our Platform team. You will design,
build, and operate the infrastructure that powers Nexus AI's prediction serving
layer — from feature pipelines to model deployment and monitoring.

### What You'll Do

- Design and maintain low-latency model serving infrastructure (target: p99 <
  50ms at 100k RPS)
- Build and operate feature pipelines that feed real-time and batch models
- Implement model monitoring and automated alerting for data and concept drift
- Work closely with data scientists to take models from prototype to production
- Contribute to internal tooling: experiment tracking, model registry, deployment
  automation

### Requirements

- 3+ years of experience in ML engineering or a related field
- Proficiency in Python; experience with ML frameworks (PyTorch, TensorFlow,
  scikit-learn)
- Experience with model serving frameworks (TorchServe, Triton, BentoML, or
  similar)
- Experience with workflow orchestration tools (Airflow, Prefect, or similar)
- Familiarity with feature stores (Feast, Tecton, or custom solutions)
- Experience with containerisation (Docker, Kubernetes)
- Strong understanding of software engineering fundamentals (testing, CI/CD,
  observability)

### Nice to Have

- Experience with streaming data infrastructure (Kafka, Kinesis, or similar)
- Familiarity with MLflow or similar experiment tracking tools
- Experience in a high-throughput production ML environment (>1k RPS)

### What We Offer

- Competitive salary and equity
- Hybrid work (3 days on-site in San Francisco)
- Health, dental, vision
- $2,000/year learning budget

---

## Fit Analysis

### Strengths

| Requirement | Match from Profile |
|-------------|-------------------|
| 3+ years ML engineering | 4 years total: ML Engineer at Lumino AI (2022–present) + Python Backend Dev at DataStream (2020–2022) |
| Python proficiency | Core language throughout all roles; FastAPI, Celery, Airflow |
| Model serving (ONNX, dynamic batching) | Led serving infrastructure overhaul at Lumino AI; 40% p99 latency reduction |
| Workflow orchestration (Airflow) | Built automated retraining DAGs at Lumino AI |
| Feature stores | Designed Redis + PostgreSQL feature store at Lumino AI; 3 model teams consuming it |
| Docker / containerisation | Used throughout profile |
| Software fundamentals (testing, CI/CD) | 80%+ integration test coverage at DataStream; MLflow adoption at Lumino AI |

### Gaps

| Requirement | Gap | Severity |
|-------------|-----|----------|
| Kubernetes | Not explicitly mentioned in profile | Medium |
| Streaming infrastructure (Kafka/Kinesis) | Not in profile | Low |
| 100k RPS scale | Profile mentions ~2,000 RPS peak — below the stated target | Medium |

### Framing Recommendation

Lead with the feature store and model serving work at Lumino AI — it maps directly
to the two core pillars of this role. The 40% p99 latency reduction is a strong
quantified signal. Frame DataStream's ETL and async pipeline work as evidence of
production-grade data engineering instincts. Acknowledge the Kubernetes gap
proactively if asked; note that Docker experience is present and K8s is learnable
in context.

## Verdict

Strong fit — 7 of 9 core requirements match directly. Recommend applying.
