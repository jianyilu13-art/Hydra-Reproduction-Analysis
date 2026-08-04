# Experiment Plan

## Objective

The goal of this project is not only to reproduce the official Hydra pipeline, but also to investigate how different inputs, configurations, and implementation modules affect the construction of the hierarchical 3D scene graph.

---

# Experiment 1 — Environment Verification

## Research Question

Can Hydra be successfully reproduced on my hardware?

### Record

- Ubuntu version
- ROS2 version
- CUDA version
- GPU
- Hydra version
- Build time
- Installation issues
- Solutions

### Expected Output

- Successful compilation
- Successful launch
- RViz visualization

---

# Experiment 2 — Dataset Investigation

## Research Question

How does the input dataset influence Hydra's output?

### Compare

| Property | Dataset A | Dataset B |
|----------|-----------|-----------|
| Environment | Office | |
| Sensor | RGB-D | |
| Duration | | |
| Size | | |
| Number of frames | | |

### Observe

- Scene complexity
- Number of objects
- Room structure
- Mapping quality

### Goal

Understand whether different environments produce different scene graphs.

---

# Experiment 3 — Configuration Investigation

## Research Question

How do different Hydra configurations affect the reconstruction process?

### Compare

| Configuration | Run 1 | Run 2 |
|--------------|-------|-------|
| Active window size | | |
| Semantic inference | | |
| Loop closure | | |
| Visualization | | |

### Observe

- Runtime
- Memory usage
- Generated mesh
- Scene graph quality

### Goal

Understand the purpose of important configuration parameters.

---

# Experiment 4 — Pipeline Verification

## Research Question

Can the implementation described in the paper be verified through the source code and runtime behavior?

### Verify

Paper

↓

Code

↓

Runtime

↓

Output

### Modules

- RosInputModule
- Reconstruction
- Frontend
- Backend
- Loop Closure

### Evidence

- source code
- ROS topics
- ROS nodes
- RViz
- terminal output

---

# Experiment 5 — Scene Graph Analysis

## Research Question

How is the hierarchical scene graph constructed?

### Observe

RGB-D

↓

TSDF

↓

Mesh

↓

Objects

↓

Places

↓

Rooms

### Record

- Mesh generation
- Object extraction
- Place graph
- Room segmentation

### Compare

| Layer | Input | Output | Responsible Module |
|--------|-------|--------|--------------------|
| Mesh | TSDF | Mesh | Reconstruction |
| Objects | Mesh | Objects | Frontend |
| Places | ESDF | Places | Frontend |
| Rooms | Places | Rooms | Frontend |

---

# Experiment 6 — Runtime Analysis

## Research Question

How does data flow through Hydra during execution?

### Record

- ROS nodes
- ROS topics
- Topic frequency
- TF tree
- Module startup order

### Verify

Sensor

↓

ROS

↓

Input Module

↓

Active Window

↓

Frontend

↓

Backend

↓

Scene Graph

---

# Experiment 7 — Design Analysis

## Research Question

Why is Hydra designed this way?

### Investigate

- Why Active Window?
- Why TSDF + ESDF?
- Why separate Frontend and Backend?
- Why hierarchical scene graphs?
- Why asynchronous modules?

### Compare

| Traditional Mapping | Hydra |
|---------------------|-------|
| Dense map only | Dense + Semantic |
| Whole map | Active Window |
| Geometry | Hierarchical Scene Graph |
| Offline optimization | Incremental optimization |

---

# Expected Outcome

- Successfully reproduce Hydra.
- Verify the implementation using source code and runtime observations.
- Understand the complete data flow from RGB-D input to hierarchical scene graph generation.
- Analyze the influence of datasets and configuration settings on the generated scene graph.
- Document the complete learning and reproduction process.