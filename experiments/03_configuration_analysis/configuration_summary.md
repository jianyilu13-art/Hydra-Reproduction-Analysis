
# Configuration Summary

## Overview

Hydra separates configuration into multiple YAML files according to different responsibilities.

This modular design allows different datasets, sensors, and algorithms to share the same reconstruction framework.

---

# Configuration Hierarchy

```

hydra_ros launch file

    ↓

ROS dataset configuration

    ↓

Hydra configuration

    ↓

Module initialization

    ↓

Visualization

```

---

# 1. Launch Configuration

## File


hydra_ros/hydra_ros/launch/datasets/uhumans2.launch.yaml


## Purpose

The launch file is the entry point of the Hydra pipeline.

It defines:

- ROS nodes to start.
- Parameters to load.
- Dataset configuration.
- Visualization options.

---

# 2. ROS Dataset Configuration

## File


hydra_ros/hydra_ros/config/datasets/uhumans2.yaml


## Purpose

Defines how Hydra receives sensor data.

Important information:

- RGB topic.
- Depth topic.
- Camera information.
- Coordinate frames.
- Dataset-specific settings.

This file connects ROS messages with Hydra input modules.

---

# 3. Hydra Dataset Configuration

## File


hydra/config/datasets/uhumans2.yaml


## Purpose

Defines Hydra-specific processing parameters.

Controls:

- Reconstruction settings.
- Semantic processing.
- Dataset assumptions.

---

# 4. Semantic Label Configuration

## File


hydra/config/label_spaces/


Examples:


uhumans2_office_label_space.yaml
uhumans2_apartment_label_space.yaml


## Purpose

Defines semantic categories used by Hydra.

Example:


chair → furniture

wall → structure


These labels are used when generating semantic scene graph nodes.

---

# 5. Loop Closure Configuration

## File


hydra/config/lcd/


Example:


uhumans2.yaml


## Purpose

Controls place recognition and loop closure behavior.

---

# 6. Visualization Configuration

## File


hydra_visualizer/config/


Examples:


visualizer_config.yaml
visualizer_plugins.yaml


## Purpose

Controls how Hydra output is displayed in RViz.

These parameters affect visualization only and do not directly modify reconstruction.