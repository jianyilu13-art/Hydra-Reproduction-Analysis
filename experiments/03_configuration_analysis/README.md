
# Experiment 3 – Configuration Analysis

## Objective

The objective of this experiment is to understand how Hydra is configured and how different configuration files influence the reconstruction pipeline and hierarchical 3D scene graph generation.

This experiment investigates the relationship between Hydra launch files, dataset configurations, core Hydra configurations, and visualization settings.

---

## Research Question

How do Hydra configuration files control the behavior of different modules in the reconstruction pipeline?

---

## Background

Hydra uses YAML configuration files to initialize its different components before processing sensor data.

The configuration system defines:

- sensor input topics,
- dataset-specific parameters,
- reconstruction settings,
- semantic label spaces,
- loop closure behavior,
- visualization options.

Instead of modifying source code, Hydra behavior can be changed by modifying these configuration files.

The configuration hierarchy can be summarized as:

```
Launch Configuration
    ↓

Dataset Configuration
    ↓

Hydra Module Configuration
    ↓

Visualization Configuration

```

---

## Configuration Categories

The major configuration categories investigated in this experiment are:

### 1. Launch Configuration

Location:


hydra_ros/hydra_ros/launch/


Example:


datasets/uhumans2.launch.yaml


Purpose:

- Starts Hydra nodes.
- Loads dataset-specific configurations.
- Defines runtime parameters.

---

### 2. ROS Dataset Configuration

Location:


hydra_ros/hydra_ros/config/datasets/


Example:


uhumans2.yaml


Purpose:

- Defines ROS topics.
- Specifies sensor information.
- Provides dataset-specific settings.

---

### 3. Hydra Core Configuration

Location:


hydra/config/


Examples:


datasets/
label_spaces/
label_remaps/
lcd/


Purpose:

- Controls reconstruction behavior.
- Defines semantic categories.
- Configures loop closure.
- Defines dataset processing rules.

---

### 4. Visualization Configuration

Location:


hydra_ros/hydra_visualizer/config/


Purpose:

- Controls RViz visualization.
- Defines displayed plugins and markers.

---

## Procedure

### Phase 1 — Configuration Identification

1. Identify all YAML files used when launching Hydra.
2. Trace the relationship between launch files and configuration files.
3. Record the purpose of each configuration file.

---

### Phase 2 — Source Code Verification

For each configuration file:

1. Identify the corresponding module.
2. Locate where the configuration is loaded in the source code.
3. Record the connection between YAML parameters and implementation behavior.

---

### Phase 3 — Parameter Investigation

Modify selected parameters while keeping other settings unchanged.

Examples:

- Active window size.
- Semantic inference.
- Loop closure.
- Visualization options.

For each modification:

1. Run Hydra with the modified configuration.
2. Record runtime behavior.
3. Compare generated outputs.

---

## Expected Outcome

This experiment will provide a detailed understanding of how Hydra's configuration system controls the complete reconstruction pipeline.

The final result will establish the relationship:

```

Configuration File
    ↓

Hydra Module
    ↓

Runtime Behavior
    ↓

Scene Graph Output

```