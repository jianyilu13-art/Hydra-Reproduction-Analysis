# Experiment 2 – Dataset Comparison

## Objective

The objective of this experiment is to investigate how different input datasets affect Hydra's hierarchical 3D scene graph generation.

## Background

Hydra processes sensor data published through ROS topics. Instead of requiring a physical robot or a running simulator for every experiment, previously recorded sensor data can be stored in a **ROS bag (rosbag)** and replayed.

A rosbag records synchronized ROS messages, such as RGB images, depth images, camera information, and coordinate transforms (TF). During playback, these messages are published exactly as they were recorded, allowing Hydra to process the data as if it were receiving live sensor input. The rosbag plays the role of a virtual sensor (camera), not a physical camera.

This mechanism enables reproducible experiments because the same dataset can be replayed multiple times while changing only the Hydra configuration or algorithm parameters.

## Research Question

How does the input dataset influence Hydra's reconstruction quality and generated hierarchical scene graph?

## Procedure

1. Select one or more Hydra-compatible datasets.
2. Verify that each dataset is compatible with the current Hydra implementation.
3. Collect information about each dataset, including environment type, sensor modality, duration, size, and recording format.
4. Replay each dataset using the same Hydra configuration.
5. Compare the generated scene graphs and reconstruction results.
6. Analyze how different environments influence Hydra's mapping and semantic understanding.

## Comparison Metrics

The following aspects will be compared.

### Dataset Properties

* Environment type
* Dataset duration
* Dataset size
* Sensor modality
* Recording format (ROS bag)

### Reconstruction Performance

* Runtime
* Mesh quality
* Number of reconstructed objects
* Place graph structure
* Room segmentation quality
* Hierarchical scene graph structure

### Qualitative Observations

* Scene complexity
* Object distribution
* Mapping stability
* Reconstruction completeness

## Expected Outcome

Different datasets are expected to produce different reconstruction results and hierarchical scene graphs because they contain different environments, object distributions, and scene complexities.

By replaying identical datasets through the same Hydra pipeline, the influence of the input data can be investigated while minimizing the effects of other variables.
