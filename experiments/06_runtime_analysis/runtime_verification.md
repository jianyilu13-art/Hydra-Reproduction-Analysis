# Runtime Verification (Ongoing)

## Objective

This experiment verifies the actual runtime behavior of the Hydra pipeline.

The goal is to connect the source code implementation with the running system by observing:

- ROS2 nodes
- ROS2 topics
- module startup sequence
- data flow
- generated outputs

---

# 1. Runtime Environment

## System

| Component | Value |
|-----------|-------|
| Ubuntu | |
| ROS2 | |
| Hydra Version | |
| Dataset | |
| GPU | |

---

# 2. Launch Procedure

## Dataset Playback

Command:

```bash

```

Purpose:

Explain how the dataset is provided to Hydra.

Expected:

- ROS2 topics are published.
- Sensor data becomes available to Hydra.

---

## Hydra Launch

Command:

```bash

```

Purpose:

Start the Hydra pipeline.

Expected:

- Hydra node starts.
- Required modules are initialized.
- Scene graph generation begins.

---

## Visualization

Command:

```bash

```

Purpose:

Launch RViz visualization.

Expected:

- Mesh appears.
- Objects appear.
- Places and rooms are visualized.

---

# 3. ROS2 Node Verification

## Command

```bash
ros2 node list
```

## Recorded Nodes

| Node | Function |
|------|----------|
| | |
| | |
| | |

---

# 4. ROS2 Topic Verification

## Command

```bash
ros2 topic list
```

## Important Topics

| Topic | Purpose |
|------|---------|
| | |
| | |
| | |

---

## Topic Frequency

Command:

```bash
ros2 topic hz <topic_name>
```

Record:

| Topic | Frequency |
|-------|-----------|
| | |
| | |

---

# 5. TF Verification

## Command

```bash
ros2 run tf2_tools view_frames
```

Purpose:

Verify that sensor poses and robot transforms are available.

Observation:

```

```

---

# 6. Pipeline Data Flow Verification

## Expected Flow

```
RGB-D Dataset
      |
      v
ROS2 Topics
      |
      v
RosInputModule
      |
      v
Active Window / Reconstruction
      |
      v
Frontend
      |
      v
Backend
      |
      v
Dynamic Scene Graph
      |
      v
RViz Visualization
```

---

# 7. Runtime Evidence

## Terminal Output

Record important messages:

```

```

---

## RViz Observation

Description:

```

```

---

## Generated Outputs

| Output | Location | Status |
|--------|----------|--------|
| Mesh | | |
| Scene Graph | | |
| Logs | | |

---

# 8. Problems Encountered

## Issue 1

Description:

```

```

Solution:

```

```

---

## Issue 2

Description:

```

```

Solution:

```

```

---

# 9. Conclusion

Runtime verification will confirm whether the Hydra implementation matches the expected pipeline described in the paper.

The relationship between source code and execution will be analyzed by comparing:

```
Paper Architecture
        |
        v
Source Code Modules
        |
        v
Runtime Behavior
        |
        v
Generated Scene Graph
```
