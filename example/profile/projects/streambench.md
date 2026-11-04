# StreamBench
Context: Lumino AI, later open source · 2022

## Summary
An open-source Python CLI that benchmarks streaming ML inference pipelines.
It measures throughput, p50/p95/p99 latency and memory use under configurable load profiles.

## Problem & Stakeholders
ML teams had no standard way to compare two model servers under the same load, and three teams had each written their own timing harness.
Without a reproducible baseline, performance regressions showed up in production.

## What I Did
- Built the async load generator with asyncio and httpx, with configurable request rate, payload size, concurrency and duration.
- Wrote the metrics collector and the report formatter, which outputs JSON for CI and a table for developers.
- Added SLO gates such as `--p99-slo 100ms`, which exit non-zero when breached, so the tool runs in CI.
- Published the tool as open source after using it internally.

## How It Works
A worker pool simulates concurrent clients against the target inference endpoint.
The collector records latency for each request, samples memory and aggregates the results.

## Key Decisions
- asyncio over threading: avoids GIL contention at high request rates.
- HdrHistogram for percentiles: keeps p99 accurate at high request counts.

## Results
- Blocks any model with p99 above 100 ms at 500 RPS from shipping at Lumino AI.
- Caught an int8 ONNX quantisation that improved latency but tripled the memory footprint, which offline timing would have missed.

## Skills & Technologies
- Concepts: load testing, benchmarking, ML inference, model serving, latency percentiles, SLOs, CI gates, async programming, quantisation
- Tools: Python, asyncio, httpx, HdrHistogram, ONNX
