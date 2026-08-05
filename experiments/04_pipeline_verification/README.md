

# Experiment 4 – Pipeline Verification

## Objective

The objective of this experiment is to verify whether the Hydra implementation matches the pipeline described in the original paper.

This experiment investigates the relationship between:

```
Hydra Paper

↓

Source Code Implementation

↓

ROS Runtime Behavior

↓

Generated Scene Graph

```
---

## Research Question

Can the major components described in the Hydra paper be verified through source code analysis and runtime observation?

---

## Background

Hydra constructs a hierarchical 3D scene graph through several interconnected modules.

The major processing stages are:

```
RGB-D Sensor Input

    ↓

RosInputModule

    ↓

Reconstruction

    ↓

Frontend

    ↓

Backend

    ↓

Hierarchical Scene Graph
```

Each module has a specific responsibility in converting raw sensor observations into a semantic representation of the environment.

---

## Modules to Verify

### 1. RosInputModule

Function:

- Receives ROS sensor messages.
- Synchronizes RGB-D data.
- Handles TF transformations.
- Provides input data to Hydra.

---

### 2. Reconstruction Module

Function:

- Builds geometric representations.
- Generates TSDF/ESDF.
- Produces mesh information.

---

### 3. Frontend

Function:

- Extracts objects.
- Builds places.
- Creates local scene graph structures.

---

### 4. Backend

Function:

- Performs optimization.
- Maintains global consistency.
- Optimizes graph structure.

---

### 5. Loop Closure

Function:

- Detects revisited locations.
- Corrects accumulated drift.

---

## Procedure

1. Read the Hydra paper and identify the proposed pipeline.
2. Locate corresponding source code modules.
3. Trace how data flows between modules.
4. Observe ROS nodes and topics during execution.
5. Compare runtime behavior with the paper description.
6. Record evidence from source code, terminal output, and RViz.

---

## Expected Outcome

The experiment should establish a clear connection between:

- theoretical architecture,
- implementation modules,
- ROS communication,
- final scene graph output.