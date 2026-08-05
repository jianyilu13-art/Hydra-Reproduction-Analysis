
# Hydra Configuration Analysis

---

### Dataset Configuration

Hydra configuration defines how sensor data is loaded from the ROS bag.

**Important parameters:**

- RGB-D topic names
- Camera parameters
- Frame names
- Timestamp synchronization
- Dataset-specific settings

The configuration must match the actual ROS bag topics.

**Validation:**

```bash
ros2 bag info <bag_name>
ros2 topic list
````

Incorrect topic names can cause Hydra to run without receiving sensor data.

---

### ROS and TF Configuration

Hydra requires correct TF information to transform sensor measurements into the global coordinate frame.

**Main parameters:**

* Sensor frame
* Base frame
* World frame

TF and timestamp alignment are required for correct pose estimation and map integration.

---

### Reconstruction Configuration

Controls geometric reconstruction from RGB-D input.

**Main parameters:**

* Voxel resolution
* TSDF settings
* Mesh extraction parameters

Voxel size affects the balance between:

* Reconstruction accuracy
* Memory usage
* Processing speed

---

### Semantic Configuration

Controls semantic processing.

**Important parameters:**

* Semantic inference enable/disable
* Semantic model settings
* Class mapping

During reproduction, semantic inference was disabled first:

```yaml
use_gt_semantics: false
```

This allows testing the basic reconstruction and scene graph pipeline before adding semantic dependencies.

---

### Backend Configuration

Controls graph optimization and global consistency.

**Main parameters:**

* Pose graph optimization
* Loop closure settings
* Optimization thresholds

These parameters affect:

* Trajectory accuracy
* Scene graph stability

---

### Visualization Configuration

Controls Hydra output display in RViz.

**Important parameters:**

* Visualization topics
* Fixed frame
* Update frequency

**Common issues:**

* Wrong RViz fixed frame
* Missing topics
* ROS message incompatibility

---

## Reproduction Issues

---

### Dataset Compatibility

The Hydra configuration must match:

* Hydra version
* Dataset format
* ROS message format

A mismatch can cause Hydra to launch but produce incomplete outputs.

---

### Topic Mismatch

The ROS bag topics were checked using:

```bash
ros2 topic list
```

The configuration was updated to match the actual published topics.

---

### Semantic Dependency

Semantic inference requires additional dependencies such as TensorRT.

Initial testing disabled semantic processing to verify the core Hydra pipeline first.

```
```
