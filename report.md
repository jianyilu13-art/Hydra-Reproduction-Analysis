# Hydra-ROS Reproduction and Experimental Analysis

## 1. Background

Hydra is a semantic 3D scene graph generation framework developed by MIT-SPARK for robotic perception and spatial understanding. Unlike traditional geometric maps, semantic scene graphs provide robots with structured representations of environments, including objects, places, rooms, and their spatial relationships. This enables higher-level robotic tasks such as navigation, manipulation, and autonomous decision-making.

Due to the complexity of Hydra, which integrates RGB-D perception, 3D reconstruction, semantic inference, scene graph generation, and graph optimization, reproducing the system provides an opportunity to understand the implementation of modern robotic perception frameworks.

---

# 2. Project Objective

The objective of this project is to reproduce the official Hydra-ROS pipeline on Ubuntu 24.04 with ROS 2 Jazzy, understand the internal system architecture and data processing workflow, and investigate factors affecting semantic 3D scene graph reconstruction quality.

The project focuses on:

- Understanding how RGB-D sensor data is processed through the Hydra pipeline
- Studying how ROS 2 communication connects sensor inputs, Hydra modules, and RViz visualization
- Analyzing the internal implementation of Hydra through source code study
- Evaluating how different datasets and sensing conditions influence scene graph reconstruction

The goal of this repository is **not to develop a new implementation of Hydra**, but to understand its design through official pipeline reproduction, source code analysis, and documentation of the system architecture.

---

# 3. Understanding of Hydra System Architecture

## 3.1 Overall Pipeline

The Hydra pipeline transforms raw RGB-D observations into a hierarchical semantic 3D scene graph.

The overall workflow is:

```
RGB-D Sensor Input
|
v
ROS 2 Sensor Interface
|
v
Camera Pose Estimation (TF)
|
v
3D Reconstruction
|
v
Semantic Inference
|
v
Scene Graph Generation
|
v
Graph Optimization
|
v
RViz Visualization
```

The main processing stages include:

- RGB-D data acquisition
- Camera pose tracking through TF
- Volumetric reconstruction
- Semantic label prediction
- Object and place extraction
- Hierarchical scene graph optimization

---

## 3.2 ROS 2 Communication Structure

Hydra is integrated into ROS 2 through several nodes and topics.

Main node:

### `/hydra`

Function:

- Receives sensor observations
- Performs reconstruction and scene graph generation
- Publishes scene graph updates

Important topics:

| Topic | Description |
|---|---|
| RGB image | Camera color observations |
| Depth image | Depth measurements for reconstruction |
| TF | Camera and robot pose transformation |
| Mesh updates | 3D reconstruction updates |
| Scene graph topics | Semantic scene graph outputs |

RViz is used as the visualization interface to display:

- Mesh reconstruction
- Object nodes
- Place nodes
- Room structure
- GVD structure

---

## 3.3 Code Structure Understanding

Important packages studied:

### hydra_ros

Role:

Provides ROS 2 integration, sensor interfaces, message handling, and pipeline execution.

Main files studied:

- `hydra_ros_pipeline.cpp`
- `ros_input_module.cpp`

---

### hydra

Role:

Contains the core Hydra perception pipeline, including reconstruction, frontend processing, backend optimization, and loop closure.

---

### kimera_pgmo

Role:

Provides pose graph and mesh optimization functionality used for geometric consistency.

---

### spark_dsg

Role:

Provides the dynamic scene graph representation and optimization framework.

---

# 4. Research Questions

Main research question:

> How do different RGB-D datasets and sensing conditions influence Hydra's semantic 3D scene graph reconstruction?

Sub research questions:

1. How does RGB-D sensor quality affect reconstruction completeness?

2. How does environmental complexity influence semantic object recognition?

3. What are the common failure cases and limitations of Hydra?

4. How does additional semantic information improve scene graph generation?

---

# 5. Methodology

## 5.1 Dataset Selection

### Dataset 1: Official Hydra Dataset

Status:
Completed

Source:
Official Hydra repository dataset

Characteristics:

- Compatible with Hydra semantic pipeline
- Provides required RGB-D streams
- Used for initial pipeline verification


### Dataset 2: Alternative RGB-D Dataset

Status:
In progress

Characteristics:

- Used to evaluate Hydra generalization
- Requires compatibility verification
- Investigating semantic attachment support

---

# 5.2 Experimental Setup

The experiments are performed under the same hardware and software environment while changing the input dataset.

Environment:

- Ubuntu 24.04
- ROS 2 Jazzy
- NVIDIA GPU acceleration
- Hydra-ROS framework


Evaluation focuses on:

- Scene graph generation quality
- Semantic object detection
- Reconstruction completeness
- Runtime performance
- GPU and memory usage

---

# 6. Implementation Challenges and Debugging Process

During the reproduction process, several compatibility and pipeline issues were encountered.

## 6.1 Hydra Version Compatibility Issue

### Problem:

The first attempt used an incompatible Hydra version that was not fully compatible with ROS 2 Jazzy.

Symptoms:

- Compilation and dependency issues
- ROS interface mismatch

### Solution:

The Hydra version and related ROS packages were aligned with the official Hydra-ROS repository to ensure compatibility with ROS 2.

---

## 6.2 Dataset Compatibility Issue

### Problem:

The first tested dataset was the uHumans2 dataset.

Although the RGB-D data could be converted and played through ROS 2, it was not directly compatible with Hydra semantic processing requirements.

Symptoms:

- Hydra nodes started successfully
- ROS bag playback worked
- However, semantic scene graph visualization did not appear


### Debugging Process:

The complete pipeline was checked:

```
ROS Bag
|
v
Sensor Topics
|
v
Hydra Input Module
|
v
Reconstruction Module
|
v
Semantic Processing
|
v
Scene Graph Output
|
v
RViz Visualization
```

The investigation focused on:

- Topic names
- Message types
- TF availability
- Dataset configuration
- Semantic inference configuration

---

## 6.3 Scene Graph Visualization Failure

### Problem:

Hydra and rosbag playback were running correctly, but the scene graph did not appear in RViz.

Possible causes investigated:

- Incorrect dataset configuration
- Missing semantic inference output
- Incorrect ROS topic connections
- Hydra version mismatch
- Missing semantic attachment configuration

The issue was resolved by adjusting the dataset configuration and using a compatible dataset from the official Hydra repository.

---

# 7. Experimental Results

## 7.1 Scene Graph Visualization Comparison

(Currently in progress)

Screenshots will compare:

- Object layer
- Place layer
- Room layer
- GVD structure

---

## 7.2 Quantitative Comparison

(Currently in progress)

Metrics:

| Metric | Dataset 1 | Dataset 2 |
|---|---|---|
| Runtime | | |
| Number of objects | | |
| Scene graph nodes | | |
| GPU usage | | |

---

## 7.3 Failure Case Analysis

Cases under investigation:

### Occlusion

Observation:

Hydra may fail to reconstruct objects when RGB-D observations contain severe occlusion.

Possible reason:

Limited observation coverage and incomplete depth information.

---

### Dynamic Objects

Observation:

Moving objects may introduce inconsistency in reconstruction.

Possible reason:

Hydra assumes relatively static environments.

---

# 8. Discussion

The reproduction process demonstrates that Hydra performance depends strongly on:

- Dataset compatibility
- RGB-D sensor quality
- Depth accuracy
- Semantic inference configuration
- Environmental complexity

The debugging process also highlights the importance of understanding the complete ROS 2 data flow rather than only launching the final system.

---

# 9. Conclusion

The Hydra-ROS pipeline was successfully reproduced on Ubuntu 24.04 with ROS 2 Jazzy.

The project achieved:

- Understanding of Hydra system architecture
- Analysis of core source code modules
- Verification of ROS 2 communication workflow
- Successful visualization of semantic 3D scene graphs

The reproduction process improved understanding of robotic perception systems, semantic mapping, and research software debugging.

---

# 10. Future Work

Future improvements include:

- Testing additional RGB-D datasets
- Integrating additional semantic attachments
- Investigating dynamic scene understanding
- Improving semantic reasoning capabilities
- Exploring more efficient scene graph optimization
- Deploying Hydra on real robot platforms