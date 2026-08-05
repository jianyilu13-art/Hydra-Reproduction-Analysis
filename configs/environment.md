# Software Environment


## ROS2

ROS Distribution:


ROS2 Jazzy



Hydra ROS supports:

- Ubuntu 22.04 + ROS2 Iron
- Ubuntu 24.04 + ROS2 Jazzy


My environment:


Ubuntu 24.04
ROS2 Jazzy



---

## Workspace

Hydra workspace:


~/hydra_ws



Source location:


~/hydra_ws/src



Main repositories:


hydra_ros
hydra
spark_dsg
kimera_pgmo
kimera_rpgo
semantic_inference



---

## Build Method

Hydra uses ROS2 colcon build:

```bash
colcon build --continue-on-error

Build workspace:

cd ~/hydra_ws
colcon build --symlink-install