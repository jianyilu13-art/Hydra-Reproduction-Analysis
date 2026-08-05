# Dataset Configuration

## Dataset

Dataset:

- uHumans2 Office Scene

Format:

- ROS1 bag (`.bag`)
- Converted to ROS2 bag (`.db3`)


## Conversion

### Tool:

```
rosbags-convert

Workflow:

ROS1 bag
   ↓
rosbags-convert
   ↓
ROS2 bag
```

## ROS Topics

RGB:

/tesse/left_cam/rgb/image_raw

Depth:

/tesse/left_cam/depth/image_raw

Pose:

/tf
/tf_static

## Hydra Configuration

Dataset config:

hydra_ros/hydra_ros/config/datasets/uhumans2.yaml

Defines:

sensor topics
camera parameters
dataset settings
Playback
ros2 bag play <dataset_path> \
--clock \
--qos-profile-overrides-path ~/.tf_overrides.yaml
Notes
Dataset topics must match Hydra YAML configuration.
/tf_static requires QoS override for correct pose loading.