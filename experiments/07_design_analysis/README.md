# Experiment 07 – Hydra Design Analysis

## Objective

This experiment analyzes the design principles behind Hydra and investigates the motivation behind its hierarchical semantic mapping framework.

The purpose is not only to understand how Hydra works technically, but also to understand why Hydra is designed using Dynamic Scene Graphs (DSGs), multiple abstraction layers, and optimization-based mapping.

This experiment also compares Hydra with previous and newer scene representation approaches to understand its position in the development of robotic perception systems.

---

# Research Questions

This experiment investigates:

1. Why does Hydra use a Dynamic Scene Graph instead of traditional map representations?
2. Why is the environment divided into multiple hierarchical layers?
3. How does Hydra combine geometry, semantics, and spatial reasoning?
4. What advantages and limitations exist in the current Hydra design?
5. How does Hydra compare with previous and newer scene understanding approaches?

---

# 1. Evolution of Robotic Scene Representation

The development of robotic environment representation can be divided into several stages:

```
Traditional SLAM
|
v
Semantic Mapping
|
v
Hierarchical Scene Graph
|
v
Semantic Reasoning Scene Graph
```

Hydra represents an important transition between geometric reconstruction and higher-level semantic understanding.

---

# 2. Before Hydra: Traditional Geometric Mapping

Before Dynamic Scene Graphs, most robotic mapping systems focused mainly on geometric reconstruction.

The main objectives were:

- estimating robot trajectory,
- reconstructing occupied space,
- building consistent maps.

Common representations include:

- Occupancy Grid Maps
- Point Clouds
- TSDF Maps

The general idea is:

```
Sensor Data
|
v
Geometric Map
|
v
Robot Localization
```

These systems can answer:

> Where is occupied space?

However, they have limited ability to answer:

> What exists in this space?

or

> How are objects and regions related?

For example, a geometric map may contain many points representing a table, but it does not understand:

```
This is a table.

The table is inside a room.

The room connects to another room.
```

The representation contains geometry but lacks semantic structure.

---

# 3. Semantic Mapping Before Hydra

Later robotic systems introduced semantic information into geometric maps.

The representation became:

```
Map
|
+-- Chair
|
+-- Table
|
+-- Door
```

These approaches improved object recognition.

However, the representation was usually flat.

The system could identify objects but had limited ability to represent relationships.

For example:

```
Chair
Table
Monitor
```

does not explicitly describe:

```
Chair
|
inside
|
Office
|
connected to
|
Hallway
```

Main limitations:

- weak relationship modeling,
- limited hierarchical understanding,
- difficult reasoning in large environments.

---

# 4. Hydra: Dynamic Scene Graph Representation

Hydra introduces Dynamic Scene Graphs (DSGs) to represent environments as hierarchical structures.

Instead of storing independent objects, Hydra organizes information into multiple abstraction levels.

The representation becomes:

```
Room
|
Place
|
Object
|
Mesh
```

This allows robots to reason about:

- object relationships,
- spatial regions,
- environment organization.

The key improvement is:

```
Geometric Reconstruction
|
v
Semantic Objects
|
v
Hierarchical Spatial Understanding
```

Hydra combines geometric information and semantic information into a unified representation.

---

# 5. After Hydra: Rich Semantic Scene Graphs

Recent research extends hierarchical scene graphs by introducing stronger semantic reasoning.

Examples include:

- HOV-SG
- foundation-model-based semantic mapping approaches

The research direction changes from:

```
What objects exist?
```

towards:

```
What does this environment mean?
```

---

# 6. Comparison Between Different Scene Representations

| Aspect | Traditional Mapping | Hydra | Post-Hydra Research |
|---|---|---|---|
| Representation | Map / Point Cloud | Dynamic Scene Graph | Semantic Knowledge Graph |
| Main Information | Geometry | Geometry + Structure | Geometry + Meaning + Reasoning |
| Object Understanding | Limited | Object Nodes | Objects + Affordances |
| Spatial Hierarchy | No | Yes | Yes |
| Relationship Modeling | Weak | Strong | Strong + Semantic |
| Human-level Understanding | No | Limited | Improved |
| Task Reasoning | Limited | Moderate | Advanced |

---

# 7. HOV-SG and Future Scene Understanding

HOV-SG extends hierarchical scene understanding by adding richer semantic relationships.

Compared with Hydra:

Hydra mainly represents:

```
Room
|
Place
|
Object
```

Future semantic scene graphs attempt to represent:

```
Environment Concept
|
Room Function
|
Object
|
Affordance
|
Activity
```

For example:

Hydra output:

```
Object:
Chair

Location:
Room 1
```

A richer semantic system may infer:

```
Chair

Affordance:
Sitting

Possible Activity:
Working / Resting

Environment:
Office
```

The difference is the reasoning level.

Hydra focuses on spatial organization.

Newer systems attempt to understand human activities and environmental meaning.

---

# 8. Hydra Hierarchical Layers

Hydra separates the environment into multiple layers.

Each layer represents different levels of information.

---

## 8.1 Mesh Layer

Purpose:

Represent physical geometry.

Technology:

- TSDF reconstruction
- mesh generation

Main question:

```
Where does geometry exist?
```

The mesh provides the physical structure of the environment.

---

## 8.2 Object Layer

Purpose:

Represent semantic entities.

Technology:

- semantic inference,
- instance segmentation,
- mesh segmentation.

Main question:

```
What objects exist?
```

Examples:

- chair,
- table,
- monitor.

---

## 8.3 Place Layer

Purpose:

Represent spatial regions.

Technology:

- ESDF,
- GVD.

Main question:

```
Which areas belong together?
```

ESDF provides distance information from obstacles.

GVD extracts spatial structures from free space.

Together they help Hydra identify meaningful regions.

---

## 8.4 Room Layer

Purpose:

Represent high-level spatial organization.

Main question:

```
How are different regions organized?
```

Important limitation:

Hydra does not automatically understand human room names.

Hydra may generate:

```
Room 1
Room 2
Room 3
```

It does not automatically know:

```
Room 1 = Office

Room 2 = Kitchen

Room 3 = Bedroom
```

Additional semantic reasoning is required for human-level room understanding.

---

# 9. Geometry and Semantic Separation

A key design principle of Hydra is separating geometry processing and semantic understanding.

## Geometry Pipeline

```
RGB-D Input
|
v
TSDF
|
v
Mesh Reconstruction
```

The geometry pipeline focuses on:

- surface reconstruction,
- spatial consistency,
- physical structure.

---

## Semantic Pipeline

```
RGB Image
|
v
Semantic Model
|
v
Object Labels
```

The semantic pipeline focuses on:

- object recognition,
- object categories,
- semantic information.

---

These two sources are combined to create the Dynamic Scene Graph.

Advantages:

- independent improvement of modules,
- easier replacement of perception models,
- flexible sensor integration.

---

# 10. Important Technical Components

## TSDF

Truncated Signed Distance Function.

Purpose:

- integrate RGB-D observations,
- estimate surfaces,
- generate meshes.

---

## ESDF

Euclidean Signed Distance Field.

Purpose:

- calculate distance to obstacles,
- represent free space,
- support navigation and spatial reasoning.

---

## GVD

Generalized Voronoi Diagram.

Purpose:

- extract spatial structures,
- identify places,
- represent navigable regions.

---

# 11. Active Window Strategy

Large environments create computational challenges.

Hydra does not optimize the complete map continuously.

Instead, it uses an Active Window.

The Active Window contains currently important information.

Advantages:

- reduced computation,
- better scalability,
- real-time performance.

---

# 12. Optimization-Based Backend

Hydra uses optimization methods to maintain global consistency.

Important concepts:

- factor graph,
- pose graph,
- loop closure.

The backend integrates new observations and corrects previous estimation errors.

This allows Hydra to maintain a consistent scene graph when revisiting previously observed areas.

---

# 13. Design Advantages

## Hierarchical Understanding

Hydra provides multiple levels of abstraction:

```
Object
|
v
Place
|
v
Room
```

This allows robots to reason beyond raw sensor measurements.

---

## Scalability

The hierarchical representation reduces complexity compared with dense global maps.

---

## Extensibility

Different modules can be improved independently:

- reconstruction methods,
- semantic models,
- optimization algorithms.

---

# 14. Design Limitations

## Semantic Dependence

The quality of semantic understanding depends on:

- segmentation models,
- available labels,
- inference accuracy.

---

## Limited Human-level Understanding

Hydra understands spatial organization but not complete human concepts.

Example:

Hydra:

```
Room 1

Objects:
- Desk
- Chair
- Monitor
```

Human interpretation:

```
Office

Working Area

Desk + Chair + Monitor
```

Additional reasoning models are required.

---

## Dynamic Environment Challenges

Moving objects and humans introduce additional difficulties.

Future directions include:

- dynamic object tracking,
- temporal scene graphs,
- human-aware mapping.

---

# 15. Relationship with Previous Experiments

| Experiment | Contribution |
|---|---|
| Experiment 03 | Hydra configuration analysis |
| Experiment 04 | Source-code module analysis |
| Experiment 05 | Scene graph structure analysis |
| Experiment 06 | Runtime verification and visualization |
| Experiment 07 | Design motivation and research analysis |

---

# Expected Outcome

This experiment provides an understanding of Hydra as a research system.

The analysis explains:

- why Hydra uses Dynamic Scene Graphs,
- how hierarchical layers represent environments,
- how geometry and semantics are combined,
- how Hydra connects traditional mapping with future semantic reasoning systems.

Hydra represents an important step from geometric reconstruction toward intelligent robotic environment understanding.