# StreamBench
Context: Lumino AI, later open source · 2021

## Summary
An open-source Python CLI that benchmarks streaming ML inference pipelines.
It measures throughput, p50/p95/p99 latency and memory use under configurable load profiles.

## Problem & Stakeholders
ML teams had no standard way to compare two model servers under the same load, and three teams had each written their own timing harness.
Without a reproducible baseline, performance regressions showed up in production.
General-purpose load testers such as Locust and k6 don't report inference-specific metrics or understand batching.

## What I Did
- Built the async load generator with asyncio and httpx, with configurable request rate, payload size, concurrency and duration.
- Wrote the metrics collector and the report formatter, which outputs JSON for CI and a table for developers.
- Added SLO gates such as `--p99-slo 100ms`, which exit non-zero when breached, so the tool runs in CI.
- Published the tool as open source once its API was stable and it had basic docs.

## How It Works
A worker pool simulates concurrent clients against the target inference endpoint.
The collector records latency for each request, samples memory and aggregates the results.

## Key Decisions
- asyncio over threading: avoids GIL contention at high request rates.
- HdrHistogram for percentiles: keeps p99 accurate at high request counts.

## Results
- Runs as a pre-deployment gate at Lumino AI: a model with p99 above 100 ms at 500 RPS doesn't ship.
- Caught an int8 ONNX quantisation that improved latency but tripled the memory footprint, which offline timing would have missed.
- p99 estimates were within 3 ms of server-side timing logs, checked on a sample of requests.

## Current Status
The load generator runs on a single machine, so endpoints above 10k RPS would need a distributed setup.

## Skills & Technologies
- Concepts: load testing, benchmarking, ML inference, model serving, latency percentiles, SLOs, CI gates, async programming, quantisation
- Tools: Python, asyncio, httpx, HdrHistogram, ONNX
