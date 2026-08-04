# Documentation

This folder contains the documents created during my study and reproduction of the **Hydra** semantic 3D scene graph framework.

The purpose of these documents is to record **my learning journey**, including my understanding of the Hydra paper, source code, and reproduction process. They are **learning-oriented notes**, not professional analyses or official documentation.

---

## Files

### `hydra_architecture.md`

A high-level summary of Hydra, including:

- Motivation behind Hydra
- Overall system architecture
- RGB-D processing pipeline
- Hierarchical 3D scene graph
- Scene graph optimization
- Personal understanding and workflow diagrams

---

### `code_notes.md`

Notes taken while reading Hydra's core source code.

Topics include:

- Module responsibilities
- Data flow between modules
- Important classes and functions
- Source code walkthroughs
- Personal observations and questions

Core files analyzed include:

- `hydra_ros_pipeline.cpp`
- `ros_input_module.cpp`
- `reconstruction_module.cpp`
- `graph_builder.cpp`
- `backend_module.cpp`
- `loop_closure_module.cpp`

---

### `experiment_plan.md`

Planning document for the reproduction project.

It records:

- Learning objectives
- Reading roadmap
- Experiment schedule
- Future work

---

## Learning Disclaimer

The documents in this folder are **personal study notes** created while learning Hydra. They should be viewed as a record of my learning process rather than a complete or authoritative explanation of the framework.

Most of the analyses were developed through an **interactive learning process with ChatGPT**. I used ChatGPT as a study assistant to:

- explain unfamiliar C++ and ROS2 concepts
- discuss Hydra's software architecture
- clarify implementation details
- organize and summarize what I learned

The final notes are therefore **learning-based summaries**, combining my own understanding with AI-assisted explanations. They are intended to demonstrate **how I learned and analyzed Hydra**, not to serve as official documentation or expert technical analysis.

---

## References

- Hydra: *A Real-time Spatial Perception System for 3D Scene Graph Construction*
- Official Hydra GitHub Repository
- MIT SPARK Lab
- Kimera
- Spark-DSG