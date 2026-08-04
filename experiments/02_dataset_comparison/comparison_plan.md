# Dataset Comparison Plan

## Objective

The objective of this experiment is to evaluate how different input datasets influence Hydra's hierarchical 3D scene graph generation while keeping the software configuration unchanged.

---

## Experimental Setup

To ensure a fair comparison, the following conditions will remain the same throughout all experiments:

* Hydra version
* ROS 2 version
* Operating system
* Hardware platform
* Hydra configuration files
* Launch procedure

Only the input dataset will be changed.

---

## Comparison Procedure

For each compatible dataset, the following steps will be performed:

1. Verify dataset compatibility with the current Hydra pipeline.
2. Convert the dataset to the required format if necessary.
3. Launch Hydra using the same configuration.
4. Process the entire dataset.
5. Save runtime logs and screenshots.
6. Record reconstruction results.
7. Compare the generated scene graphs.

---

## Evaluation Metrics

### Dataset Information

| Property         | Description                                   |
| ---------------- | --------------------------------------------- |
| Environment      | Office, apartment, subway, neighborhood, etc. |
| Sensor Type      | RGB-D                                         |
| Dataset Duration | Recording time                                |
| Dataset Size     | Storage size                                  |
| Number of Frames | Total RGB-D frames                            |

---

### Runtime Performance

The following runtime information will be recorded:

* Processing time
* Memory usage
* GPU utilization (if applicable)
* Average topic frequency

---

### Reconstruction Quality

The following reconstruction results will be compared:

* Mesh completeness
* Mesh quality
* Number of reconstructed objects
* Number of places
* Number of rooms
* Overall scene graph structure

---

### Observations

The following qualitative observations will also be recorded:

* Scene complexity
* Object distribution
* Room segmentation
* Mapping stability
* Runtime issues

---

## Expected Outcome

Different datasets are expected to produce different reconstruction results and hierarchical scene graphs due to differences in environment structure, object distribution, and scene complexity.

The experiment aims to identify how dataset characteristics influence Hydra's semantic mapping performance.
