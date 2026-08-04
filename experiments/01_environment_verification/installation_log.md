# Hydra Installation Log

## Repository Setup


The initial installation was attempted using AI-generated installation instructions. However, the workspace failed to compile due to missing repositories, unresolved dependencies, and package conflicts.

### Example Errors

```text
Package 'hydra_ros' not found
```

```text
CMake Error:
Could not find package configuration file provided by ...
```

```text
fatal: not a git repository
```

```text
kex_exchange_identification: Connection reset by peer
```

Because of these compilation and configuration issues, the installation process was restarted by following the official **MIT-SPARK Hydra-ROS** installation guide.


The installation process was restarted by following the official **MIT-SPARK Hydra-ROS** documentation.

### Create Workspace

```bash
mkdir -p ~/hydra_ws/src
cd ~/hydra_ws/src
git clone git@github.com:MIT-SPARK/Hydra-ROS.git hydra_ros
```

### Import Required Repositories

Hydra depends on multiple repositories besides `hydra_ros`. They were imported using:

```bash
vcs import . < hydra_ros/install/ros2.yaml
```

#### Issue

GitHub occasionally reset SSH connections during cloning:

```text
kex_exchange_identification: Connection reset by peer
```

#### Solution

Import the repositories using a single worker:

```bash
vcs import . < hydra_ros/install/ros2.yaml --workers 1
```

---

## Install Dependencies

Install all required ROS packages and Ubuntu libraries:

```bash
rosdep install --from-paths . --ignore-src -r -y
```

### What are Dependencies?

Dependencies are external packages required for Hydra to compile and run.

Examples include:

- ROS 2 packages
- Eigen
- OpenCV
- PCL
- Other Ubuntu system libraries

`rosdep` automatically installs these packages.

---

## Build Workspace

Compile the workspace:

```bash
colcon build --symlink-install
```

### Warning

```text
TensorRT is required for inference to run!
```

This warning only affects semantic inference.

The Hydra framework can still be compiled and executed successfully.

---

## Installation Issues

During installation, several problems were encountered:

- Package dependency conflicts
- Duplicate ROS packages
- GitHub SSH cloning failures
- `rosdep` installation issues
- TensorRT compilation warning
- NVIDIA driver and CUDA verification
- ROS environment sourcing problems
- QoS incompatibility for `/tf_static`
- Missing semantic feature topics
- Runtime communication issues between ROS nodes

---

## Troubleshooting

The issues were resolved by:

- Removing duplicate packages
- Re-importing missing repositories
- Reinstalling dependencies
- Rebuilding the workspace
- Verifying GPU and CUDA installation
- Applying QoS overrides for `/tf_static`
- Checking ROS packages

```bash
ros2 pkg list
```

- Checking ROS nodes

```bash
ros2 node list
```

- Checking ROS topics

```bash
ros2 topic list
ros2 topic info
ros2 topic hz
```

- Verifying TF transforms

```bash
ros2 run tf2_ros tf2_echo
```

- Performing a clean rebuild after configuration changes

---

## Runtime Verification

The Hydra pipeline was launched using the uHumans2 Office dataset.

Verified components:

- Hydra node
- Hydra Visualizer
- RViz
- Rosbag playback
- RGB images
- Depth images
- Camera information
- TF transforms
- Input Module
- Frontend Module
- Active Window Module
- Backend Module

Additional debugging included verifying ROS nodes, publishers, subscribers, topics, and TF frames.

---

## Result

The Hydra framework was successfully:

- Installed
- Compiled
- Launched
- Tested on Ubuntu 24.04 with ROS 2 Jazzy

The reproduction process provided a deeper understanding of:

- Hydra software architecture
- ROS 2 communication
- Workspace management
- Runtime debugging
- Hydra execution pipeline

The completed reproduction provides a solid foundation for future research and development based on the Hydra framework.