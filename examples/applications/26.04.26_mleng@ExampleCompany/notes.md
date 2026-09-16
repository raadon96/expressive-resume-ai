# Notes

## Interview Prep

### Key talking points
- Feature store design: Redis for real-time lookups, PostgreSQL for batch
  features — why the separation matters
- ONNX + dynamic batching: what it is, how it cut p99 latency 40%
- Airflow DAG design patterns: idempotency, retries, SLA monitoring
- A/B testing and shadow mode: how the rollout framework caught regressions

### Questions to ask Nexus AI
- How is the model serving infrastructure currently architected?
- What does the on-call rotation look like for the platform team?
- What is the relationship between ML Engineers and Data Scientists?

### Gap mitigation
- Kubernetes: mention Docker experience; K8s is the natural next step
- 100k RPS: frame Lumino AI's 2k RPS as proof of fundamentals; ask how
  Nexus AI approached the scale-up
