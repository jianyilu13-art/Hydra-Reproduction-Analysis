# Experiment 5 — Scene Graph Analysis

## Objective

This experiment investigates how Hydra converts RGB-D sensor observations into a hierarchical Dynamic Scene Graph (DSG).

Unlike traditional mapping systems that only generate geometric maps, Hydra builds a semantic representation of the environment by organizing information into multiple abstraction levels.

The objective is to understand:

- how the hierarchical scene graph is constructed,
- what information each layer represents,
- how the generated scene graph is visualized in RViz.

---

# Research Question

How does Hydra transform raw RGB-D observations into a hierarchical semantic scene representation?

---

# Background

Traditional SLAM systems mainly focus on estimating:

- robot pose,
- geometry,
- occupancy maps.

Hydra extends this by generating a Dynamic Scene Graph (DSG), which represents the environment at different semantic levels.

The general pipeline is:

```
RGB-D Input

 |
 v

3D Reconstruction

 |
 v

Mesh Representation

 |
 v

Object Layer

 |
 v

Place Layer

 |
 v

Room Layer

 |
 v

Dynamic Scene Graph
```

---

# Experiment Scope

This experiment focuses on the final output of Hydra.

The analysis is divided into two parts:

## 1. Scene Graph Structure Analysis

The generated DSG is analyzed by studying:

- metric representation,
- object nodes,
- place nodes,
- room nodes,
- relationships between layers.

Detailed analysis:


layers_&_structure_analysis.md


---

## 2. Hydra Visualization Analysis

The generated scene graph is inspected through RViz.

The purpose is to understand how Hydra connects internal representations with ROS2 visualization tools.

The visualization pipeline is:

```
Hydra Pipeline

  |
  v

Dynamic Scene Graph

  |
  v

Hydra Visualizer

  |
  v

ROS2 Visualization Messages

  |
  v

RViz
```

RViz is only used for visualization.

It does not:

- provide sensor input,
- generate the map,
- perform semantic inference.

---

# Analysis Method

The scene graph will be analyzed using three sources.

## Source Code Analysis

Identify:

- scene graph data structures,
- layer generation functions,
- responsible modules.

Relevant components include:

- Reconstruction Module
- Frontend
- Backend
- Dynamic Scene Graph classes

---

## Runtime Observation

During Hydra execution, observe:

- generated mesh,
- object extraction,
- scene graph updates,
- visualization output.

---

## RViz Visualization

RViz is used to verify:

- reconstructed geometry,
- semantic objects,
- place regions,
- room structure.

The visualization provides a human-readable representation of the internal DSG.

---

# Expected Outcome

After completing this experiment, the following should be understood:

- how Hydra creates hierarchical scene graphs,
- the meaning of each DSG layer,
- the relationship between geometry and semantics,
- how Hydra output is visualized through RViz.

The final result should explain the complete transformation:
```

Sensor Observation

    |
    v

Geometric Reconstruction

    |
    v

Semantic Understanding

    |
    v

Hierarchical Scene Graph

    |
    v

RViz Visualization
```