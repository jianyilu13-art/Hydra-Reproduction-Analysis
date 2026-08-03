# Hydra Reproduction & Code Analysis

A personal learning project documenting my reproduction and analysis of the **Hydra** semantic 3D scene graph framework developed by the MIT SPARK Lab.

The goal of this repository is **not** to re-implement Hydra, but to understand how it works by reproducing the official pipeline, reading the core source code, and documenting the overall system architecture and implementation.

---

## Project Objectives

- Reproduce the official Hydra pipeline
- Understand Hydra's system architecture
- Read and analyze the core source code
- Learn how RGB-D observations are transformed into hierarchical scene graphs
- Record the complete learning and reproduction process

---

## Repository Structure

```text
Hydra-Reproduction-Analysis/
│
├── README.md
├── report.md
│
├── docs/
│   ├── README.md
│   ├── hydra_architecture.md
│   ├── code_notes.md
│   └── experiment_plan.md
│
├── configs/
│
├── experiments/
│
├── results/
│
└── scripts/
```

---

## Documentation

### `docs/hydra_architecture.md`

High-level study notes covering:

- Motivation behind Hydra
- Overall system architecture
- RGB-D processing pipeline
- Hierarchical scene graph layers
- Scene graph optimization
- Personal understanding and diagrams

---

### `docs/code_notes.md`

Notes taken while reading the core Hydra source code, including:

- Pipeline workflow
- Module responsibilities
- Data flow between modules
- Important classes and functions
- Personal observations and questions

Core files studied include:

- `hydra_ros_pipeline.cpp`
- `ros_input_module.cpp`
- `reconstruction_module.cpp`
- `graph_builder.cpp`
- `backend_module.cpp`
- `loop_closure_module.cpp`

---

### `docs/experiment_plan.md`

Project planning and learning roadmap.

---

## Reproduction Workflow

```text
Hydra Paper
      │
      ▼
Understand Architecture
      │
      ▼
Read Core Source Code
      │
      ▼
Run Official Hydra Pipeline
      │
      ▼
Observe ROS Topics & RViz
      │
      ▼
Analyze Individual Modules
      │
      ▼
Record Experiments
      │
      ▼
Summarize Findings
```

---

## Current Progress

- ✅ Architecture analysis
- ✅ Core code reading
- 🚧 Hydra reproduction experiments
- 🚧 Result collection
- 🚧 Final report

---

## Disclaimer

This repository is an educational learning project.

It does **not** contain the original Hydra implementation. Instead, it documents my understanding of the framework through paper reading, code analysis, and reproduction experiments.

The study notes were created during my learning process. I used ChatGPT as a study assistant to help explain unfamiliar C++, ROS2, and software architecture concepts. The notes have been reviewed, organized, and supplemented by me to reflect my own understanding. They are intended as learning materials rather than official documentation of the Hydra project.

---

## References

- Hydra: A Real-time Spatial Perception System for 3D Scene Graph Construction
- MIT SPARK Lab – Hydra
- Kimera
- Spark-DSG