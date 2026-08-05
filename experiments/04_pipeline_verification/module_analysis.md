# Module Analysis

## Objective

This document investigates how the major modules described in the Hydra paper are implemented in the Hydra ROS2 source code.

The analysis is based on static source code inspection. The goal is to identify the corresponding classes, files, and functions that implement each part of the Hydra pipeline.

---

# 1. ROS Input Module

## Source Discovery

Command:

```bash
grep -R "class RosInputModule" ~/hydra_ws/src
```

Output:

```
hydra_ros/hydra_ros/include/hydra_ros/input/ros_input_module.h
```

---

## Implementation

File:

```
hydra_ros/hydra_ros/include/hydra_ros/input/ros_input_module.h
```

Class:

```cpp
class RosInputModule : public InputModule
```

---

## Role

The `RosInputModule` provides the interface between ROS2 sensor messages and the Hydra processing pipeline.

It is responsible for:

- Receiving RGB-D sensor data from ROS2 topics.
- Handling ROS communication.
- Obtaining robot pose information through TF.
- Providing formatted sensor input to downstream Hydra modules.

---

# 2. Reconstruction Module

## Source Discovery

Command:

```bash
grep -R "class ReconstructionModule" ~/hydra_ws/src
```

Output:

```
hydra/include/hydra/active_window/reconstruction_module.h
```

---

## Implementation

File:

```
hydra/include/hydra/active_window/reconstruction_module.h
```

Class:

```cpp
class ReconstructionModule : public ActiveWindowModule
```

---

## Role

The `ReconstructionModule` is responsible for converting incoming sensor observations into geometric representations.

The module is implemented under the Active Window subsystem.

Main responsibilities include:

- Processing RGB-D observations.
- Maintaining local reconstruction information.
- Generating geometric representations used by later scene understanding modules.

---

# 3. Frontend Module

## Source Discovery

Commands:

```bash
ls ~/hydra_ws/src/hydra/include/hydra/frontend
```

```bash
ls ~/hydra_ws/src/hydra/src/frontend
```

---

## Important Files

Source directory:

```
hydra/include/hydra/frontend/
```

Important file:

```
graph_builder.h
```

---

## Graph Builder

File:

```
hydra/include/hydra/frontend/graph_builder.h
```

Evidence from source code:

```cpp
using Sink =
OutputSink<uint64_t,
const DynamicSceneGraph&,
const BackendInput&>;
```

---

## Role

The frontend module processes local reconstruction information and builds local scene graph structures.

It is responsible for:

- Creating object nodes.
- Creating place nodes.
- Building local Dynamic Scene Graph information.
- Passing frontend results to the backend module.

---

# 4. Backend Module

## Source Discovery

Command:

```bash
grep -R "Backend" ~/hydra_ws/src/hydra/include
```

---

## Important Files

Directory:

```
hydra/include/hydra/backend/
```

Files:

```
backend_module.h
backend_input.h
dsg_updater.h
zmq_interfaces.h
```

---

## BackendModule

File:

```
hydra/include/hydra/backend/backend_module.h
```

Class:

```cpp
class BackendModule :
public kimera_pgmo::KimeraPgmoInterface,
public Module
```

---

## Important Functions

Functions identified from source code:

```cpp
updateFactorGraph()

copyMeshDelta()
```

---

## Role

The backend module maintains global consistency of the scene graph through optimization.

Main responsibilities:

- Updating the factor graph.
- Integrating frontend outputs.
- Updating the Dynamic Scene Graph.
- Optimizing the global representation.

---

# 5. Loop Closure Module

## Source Discovery

Command:

```bash
grep -R "LoopClosure" ~/hydra_ws/src/hydra
```

---

## Important Files

Header files:

```
hydra/include/hydra/loop_closure/
```

Files:

```
loop_closure_module.h
loop_closure_config.h
```

Implementation:

```
hydra/src/loop_closure/loop_closure_module.cpp
```

---

## Implementation

Class:

```cpp
class LoopClosureModule : public Module
```

---

## Important Functions

Functions identified from source code:

```cpp
processFrontendOutput()

getPlacesToCache()

getQueryAgentId()
```

---

## Backend Integration

The backend contains loop closure related functions:

```cpp
addLoopClosure()

logIncrementalLoopClosures()
```

---

## Role

The Loop Closure module detects previously visited locations and provides constraints for backend optimization.

It helps reduce accumulated drift during long-term mapping.

---

# Summary of Source Findings

| Component | Source Location | Evidence |
|---|---|---|
| RosInputModule | `hydra_ros/input/ros_input_module.h` | `class RosInputModule` |
| ReconstructionModule | `hydra/active_window/reconstruction_module.h` | `class ReconstructionModule` |
| Frontend | `hydra/frontend/graph_builder.h` | `GraphBuilder`, `DynamicSceneGraph` output |
| BackendModule | `hydra/backend/backend_module.h` | `BackendModule`, `updateFactorGraph()` |
| LoopClosureModule | `hydra/loop_closure/loop_closure_module.h` | `LoopClosureModule` |

---

# Conclusion

The source code inspection confirms that Hydra is implemented as a collection of independent modules.

The identified modules correspond to the main stages of the Hydra pipeline:

- ROS input handling
- Active window reconstruction
- Frontend scene graph construction
- Backend optimization
- Loop closure detection

Further runtime experiments will verify how these modules communicate during actual Hydra execution.