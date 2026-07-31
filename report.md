Hydra-ROS Reproduction and Experimental Analysis

1. Background

Hydra is a semantic 3D scene graph generation framework developed by MIT-SPARK for robotic perception and spatial understanding. Unlike traditional geometric maps, semantic scene graphs provide robots with structured information about environments, including objects, rooms, and their relationships. This enables higher-level tasks such as navigation, manipulation, and autonomous decision-making.

Due to the complexity of the system, which integrates perception, mapping, semantic inference, and graph optimization, reproducing Hydra provides an opportunity to understand the implementation of modern robotics research systems.



2. Project Objective

The objective of this project is to independently reproduce the complete Hydra-ROS pipeline on Ubuntu 24.04 with ROS 2 Jazzy, understand the internal system architecture and data processing workflow, and evaluate the performance of Hydra under different RGB-D datasets and environmental conditions.

The project focuses on understanding how sensor data is transformed into semantic 3D scene graphs and investigating factors that influence reconstruction quality.



3. Understanding of Hydra System Architecture

3.1 Overall Pipeline

Describe the complete data flow:

RGB-D sensor input

Camera pose estimation

3D reconstruction

Semantic inference

Scene graph generation

Optimization and visualization


3.2 ROS 2 Communication Structure

Describe the important ROS 2 nodes and topics used in Hydra.

Example:

Node:
hydra

Function:
Main perception and scene graph generation node


Important topics:

RGB image:
Description

Depth image:
Description

TF:
Description

Scene graph output:
Description


3.3 Code Structure Understanding

Explain the role of important packages:

hydra_ros:

Role:

hydra:

Role:

kimera_pgmo:

Role:

spark_dsg:

Role:



4. Research Question

Main research question:

How do different RGB-D datasets and sensing conditions influence Hydra's semantic 3D scene graph reconstruction?


Sub research questions:

1. How does sensor quality affect reconstruction completeness?

2. How does environmental complexity influence semantic object recognition?

3. What are the common failure cases and limitations of Hydra?



5. Methodology

5.1 Dataset Selection

Dataset 1:

Name:

Type:

Characteristics:


Dataset 2:

Name:

Type:

Characteristics:


5.2 Experimental Setup

The experiments maintain the same Hydra configuration and hardware environment while changing only the input dataset.

The evaluation focuses on:

Scene graph quality

Semantic object detection

Reconstruction completeness

Computational performance


5.3 Evaluation Metrics

Metrics used:

Number of detected objects

Number of scene graph nodes

Processing time

GPU and memory usage

Qualitative visualization comparison



6. Experimental Results

6.1 Scene Graph Visualization Comparison

Describe the differences between datasets.

Insert screenshots:

Dataset 1:

Dataset 2:


6.2 Quantitative Comparison

Create comparison tables.

Example:

Metric | Dataset 1 | Dataset 2

Runtime:

Number of objects:

Scene graph nodes:


6.3 Failure Case Analysis

Describe cases where Hydra produces incorrect or incomplete results.

Example:

Occlusion:

Observation:

Possible reason:


Dynamic objects:

Observation:

Possible reason:



7. Discussion

Discuss the relationship between dataset characteristics and Hydra performance.

Possible discussion points:

Sensor noise

Depth accuracy

Environmental complexity

Semantic inference limitations



8. Conclusion

Summarize:

The Hydra system was successfully reproduced on ROS 2 Jazzy.

The internal perception pipeline was analyzed.

Experiments were conducted to evaluate system behavior under different conditions.

The project improved understanding of robotic perception, semantic mapping, and research software reproduction.



9. Future Work

Possible future improvements:

Dynamic scene understanding

Improved semantic reasoning

More efficient scene graph optimization

Real-world robot deployment