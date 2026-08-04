# Dataset Summary

## Objective

This experiment aims to investigate how different input datasets influence Hydra's hierarchical 3D scene graph generation while using the same mapping pipeline and configuration.

---

# Dataset Summary

## Objective

This experiment aims to investigate how different input datasets influence Hydra's hierarchical 3D scene graph generation while using the same mapping pipeline and configuration.

---

## Current Status

The Hydra pipeline has been successfully reproduced using the official office dataset recommended by the Hydra project.

During the dataset investigation, two versions of the office dataset were identified:

| Dataset                      | Source                             | Status                       |
| ---------------------------- | ---------------------------------- | ---------------------------- |
| `uHumans2_office_s1_00h` | MIT SPARK uHumans2 dataset website | Compatibility issue observed |
| `uHumans2_office_s1_00h_v2`  | Official Hydra repository          | Successfully reproduced      |

Although both datasets correspond to the same office environment, the dataset provided by the official Hydra repository is recommended for reproducing the current Hydra pipeline. During reproduction, the dataset downloaded from the MIT SPARK uHumans2 website could not be directly used with the current Hydra configuration, while the official Hydra dataset executed successfully and generated the expected hierarchical scene graph.

The exact reason for this compatibility difference has not yet been fully investigated. Possible factors include differences in dataset version, semantic annotations, preprocessing, or the configuration expected by the current Hydra implementation.

Therefore, this experiment is currently focused on identifying additional datasets that are compatible with the current Hydra pipeline before performing a systematic dataset comparison.

---

## Candidate Dataset Sources

Potential datasets are being investigated from the following sources.

| Source                          | Purpose                | Status                            |
| ------------------------------- | ---------------------- | --------------------------------- |
| MIT SPARK uHumans2              | Primary candidate      | Compatibility under investigation |
| Official Hydra example datasets | Primary candidate      | Compatible                        |
| Other public RGB-D datasets     | Alternative candidates | To be evaluated                   |

---

## Dataset Investigation Plan

Before a dataset is included in the comparison experiment, the following aspects will be verified:

* Compatibility with the current Hydra version.
* Compatibility with the ROS 2 environment.
* Availability of semantic information required by Hydra.
* Availability of configuration files or required preprocessing.
* Successful execution of the complete Hydra pipeline.

Only datasets that satisfy these requirements will be used for comparison.

---

## Planned Comparison

Once compatible datasets have been identified, the following properties will be compared.

| Property          | Dataset A | Dataset B |
| ----------------- | --------- | --------- |
| Environment       |           |           |
| Sensor Type       |           |           |
| Dataset Duration  |           |           |
| Dataset Size      |           |           |
| Number of Frames  |           |           |
| Runtime           |           |           |
| Mesh Quality      |           |           |
| Number of Objects |           |           |
| Number of Places  |           |           |
| Number of Rooms   |           |           |

---

## Expected Outcome

This experiment is expected to evaluate how different environments influence Hydra's reconstruction and hierarchical scene graph generation while using the same software configuration.

At the current stage, the primary task is to identify and validate compatible datasets before conducting the comparison experiments.


---

## Candidate Dataset Sources

Potential datasets are being investigated from the following sources.

| Source                          | Purpose                | Status                            |
| ------------------------------- | ---------------------- | --------------------------------- |
| MIT SPARK uHumans2              | Primary candidate      | Compatibility under investigation |
| Official Hydra example datasets | Primary candidate      | Compatible                        |
| Other public RGB-D datasets     | Alternative candidates | To be evaluated                   |

---

## Dataset Investigation Plan

Before a dataset is included in the comparison experiment, the following aspects will be verified:

* Compatibility with the current Hydra version.
* Compatibility with the ROS 2 environment.
* Availability of semantic information required by Hydra.
* Availability of configuration files or required preprocessing.
* Successful execution of the complete Hydra pipeline.

Only datasets that satisfy these requirements will be used for comparison.

---

## Planned Comparison

Once compatible datasets have been identified, the following properties will be compared.

| Property          | Dataset A | Dataset B |
| ----------------- | --------- | --------- |
| Environment       |           |           |
| Sensor Type       |           |           |
| Dataset Duration  |           |           |
| Dataset Size      |           |           |
| Number of Frames  |           |           |
| Runtime           |           |           |
| Mesh Quality      |           |           |
| Number of Objects |           |           |
| Number of Places  |           |           |
| Number of Rooms   |           |           |

---

## Expected Outcome

This experiment is expected to evaluate how different environments influence Hydra's reconstruction and hierarchical scene graph generation while using the same software configuration.

At the current stage, the primary task is to identify and validate compatible datasets before conducting the comparison experiments.
