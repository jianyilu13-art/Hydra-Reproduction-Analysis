
# Hydra ROS Pipeline (`hydra_ros_pipeline.cpp`) Explanation

## 1. Overview

`hydra_ros_pipeline.cpp` is the **main connection layer between Hydra core and ROS 2**.

Hydra itself is a C++ robotics system containing modules such as:

- Active Window
- Frontend
- Backend
- Loop Closure
- Reconstruction

However, these Hydra modules do not directly understand ROS messages.

The role of `HydraRosPipeline` is to:

1. Receive sensor data from ROS 2
2. Convert ROS messages into Hydra internal data structures
3. Start and connect Hydra processing modules
4. Publish Hydra outputs back into ROS topics


```

Overall workflow:



             ROS 2 System
                  |
                  |
          ROS Sensor Topics
    (RGB, Depth, Pose, Odometry)
                  |
                  v
        +-------------------+
        |  RosInputModule   |
        +-------------------+
                  |
                  |
          InputPacket Queue
                  |
                  v
        +-------------------+
        | Active Window     |
        | Reconstruction    |
        +-------------------+
                  |
                  |
      +-----------+-----------+
      |                       |
      v                       v
 Frontend Module        Backend Module


(Graph Building)       (Optimization)
|                       |
|                       |
v                       v
RosFrontendPublisher    RosBackendPublisher
|                       |
+-----------+-----------+
|
v
ROS Topics
(Mesh, DSG, Pose)

```

---

# 2. Include Files: Connecting Hydra and ROS

## Hydra ROS Pipeline Header

```cpp
#include "hydra_ros/hydra_ros_pipeline.h"
````

This includes the definition of:

```cpp
class HydraRosPipeline
```

which is the main ROS wrapper around Hydra.

It inherits from:

```
HydraPipeline
```

Meaning:

```
HydraPipeline
      |
      |
HydraRosPipeline
```

`HydraPipeline` provides the normal Hydra processing framework.

`HydraRosPipeline` adds ROS communication.

---

# 3. Hydra Core Modules Imported

These headers connect the ROS pipeline to Hydra algorithms.

## Active Window

```cpp
#include <hydra/active_window/reconstruction_module.h>
```

Provides:

```
Active Window Module
```

Purpose:

* Maintains recent sensor observations
* Performs reconstruction
* Creates 3D geometry

Workflow:

```
Sensor Data
     |
     v
Active Window
     |
     v
3D Reconstruction
```

---

## Backend

```cpp
#include <hydra/backend/backend_module.h>
```

Provides:

```
Backend Module
```

Purpose:

* Global optimization
* Scene graph optimization
* Pose graph optimization

Workflow:

```
Frontend Graph
       |
       v
Backend Optimization
```

---

## Frontend

```cpp
#include <hydra/frontend/graph_builder.h>
```

Provides:

```
Frontend Module
```

Purpose:

* Builds local scene graph
* Creates objects and places
* Updates graph incrementally

Workflow:

```
Processed Sensor Data
          |
          v
Frontend
          |
          v
Local Scene Graph
```

---

# 4. Configuration System

Function:

```cpp
void declare_config(HydraRosPipeline::Config& config)
```

defines the ROS Hydra configuration.

It tells Hydra which parameters exist in YAML.

Example:

```cpp
field(config.active_window, "active_window");
field(config.frontend, "frontend");
field(config.backend, "backend");
```

means YAML can contain:

```yaml
active_window:
frontend:
backend:
```

The configuration controls:

```
YAML File
    |
    v
HydraRosPipeline::Config
    |
    v
Create Modules
```

---

# 5. Constructor: Creating Hydra ROS Pipeline

```cpp
HydraRosPipeline::HydraRosPipeline(...)
```

The constructor does two things:

## Step 1

Create normal Hydra pipeline:

```cpp
HydraPipeline(...)
```

This initializes:

```
Hydra Core
```

## Step 2

Load ROS-specific configuration:

```cpp
config(config::checkValid(config::fromContext<Config>()))
```

This loads:

```
hydra_ros configuration
```

Example:

```
input:
    camera_topic
    depth_topic

frontend:
    enable: true

backend:
    enable: true
```

---

# 6. init(): Building the Hydra-ROS Connection

The most important function is:

```cpp
void HydraRosPipeline::init()
```

This creates all modules and connects them together.

---

# 7. Creating the Backend Module

Code:

```cpp
backend_ = config.backend.create(
        backend_dsg_,
        shared_state_);
```

Creates:

```
Backend Module
```

Connection:

```
Scene Graph
     |
     v
Backend
```

Then:

```cpp
modules_["backend"] = backend_;
```

stores it in the module list.

---

# 8. Creating the Frontend Module

Code:

```cpp
frontend_ =
config.frontend.create(
frontend_dsg_,
shared_state_);
```

Creates:

```
Frontend Module
```

Connection:

```
Sensor Data
     |
     v
Frontend
     |
     v
Local DSG
```

---

# 9. Creating Active Window Module

Code:

```cpp
active_window_ =
config.active_window.create(frontend_->queue());
```

Important connection:

```
Active Window
       |
       |
       v
Frontend Queue
```

The active window sends processed data to frontend.

The queue creates the data flow:

```
Input
 |
 v
Active Window Queue
 |
 v
Frontend
```

---

# 10. ROS Node Connection

Code:

```cpp
auto nh =
ianvs::NodeHandle::this_node("~");
```

Creates a ROS node handle.

This allows Hydra to:

* Subscribe to topics
* Publish topics
* Access parameters

Connection:

```
HydraRosPipeline
        |
        v
ROS Node Handle
        |
        v
ROS Communication
```

---

# 11. Input Connection: ROS → Hydra

The most important connection:

```cpp
input_module_ =
std::make_shared<RosInputModule>(
config.input,
active_window_->queue());
```

Creates:

```
RosInputModule
```

Its job:

Convert:

```
ROS Messages
```

into:

```
Hydra InputPacket
```

Data flow:

```
ROS Topic
   |
   |
   v
RosInputModule
   |
   |
   v
InputPacket
   |
   |
   v
Active Window Queue
```

Example:

```
/camera/rgb/image
/camera/depth/image
/tf
```

becomes:

```
InputPacket
{
 timestamp,
 rgb,
 depth,
 pose
}
```

---

# 12. Backend Output Connection: Hydra → ROS

Code:

```cpp
backend_->addSink(
std::make_shared<RosBackendPublisher>(bnh));
```

Creates:

```
RosBackendPublisher
```

Purpose:

Convert:

```
Hydra Backend Output
```

into:

```
ROS Messages
```

Flow:

```
Backend
   |
   v
RosBackendPublisher
   |
   v
ROS Topic
```

Example outputs:

```
Optimized pose
Scene graph
Map updates
```

---

# 13. Frontend Output Connection

Code:

```cpp
frontend_->addSink(
std::make_shared<RosFrontendPublisher>
(nh / "frontend"));
```

Creates:

```
RosFrontendPublisher
```

Flow:

```
Frontend
    |
    v
ROS Publisher
    |
    v
RViz / Other ROS Nodes
```

Possible outputs:

* Mesh updates
* Objects
* Scene graph visualization

---

# 14. Loop Closure Connection

Function:

```cpp
initLCD()
```

creates:

```cpp
LoopClosureModule
```

Purpose:

Detect when the robot returns to a previous location.

Flow:

```
Camera Features
       |
       v
Loop Closure Detector
       |
       v
Backend Optimization
```

---

# 15. ZMQ Interface

Code:

```cpp
if(config.enable_zmq_interface)
```

creates:

```
ZMQ Sink
```

Purpose:

Allow external programs to receive Hydra data.

Flow:

```
Hydra Backend
       |
       v
ZMQ
       |
       v
External Application
```

---

# 16. Starting Hydra

Function:

```cpp
void HydraRosPipeline::start()
```

calls:

```cpp
HydraPipeline::start();
```

which starts Hydra modules.

Then:

```cpp
status_monitor_->start();
```

starts monitoring.

Workflow:

```
start()
 |
 +--> Input Module
 |
 +--> Active Window
 |
 +--> Frontend
 |
 +--> Backend
 |
 +--> Status Monitor
```

---

# 17. Stopping Hydra

Function:

```cpp
void HydraRosPipeline::stop()
```

stops modules in order:

```
Input
 |
 v
Active Window
 |
 v
Frontend
 |
 v
Backend
```

Why this order?

Because data must finish processing.

Example:

```
Camera Data
     |
     v
Input stops first

No new data arrives

Existing data finishes:

Active Window
      |
      v
Frontend
      |
      v
Backend
```

---

# 18. Complete Hydra ROS Data Flow

Final architecture:

```
                 ROS 2

       RGB Image
       Depth Image
       Odometry
           |
           |
           v

     RosInputModule
           |
           |
           v

      InputPacket

           |
           |
           v

    Active Window
    Reconstruction

           |
           |
     +-----+------+
     |            |
     v            v

 Frontend      Backend

 Graph        Optimization

     |            |

     v            v

RosFrontend   RosBackend
 Publisher    Publisher

     |            |

     +------------+

            |

            v

          ROS Topics

```

---

# Main Idea

`hydra_ros_pipeline.cpp` is the **bridge between ROS 2 and Hydra**.

It does not perform mapping itself.

Instead, it connects:

```
ROS World
    |
    |
    v
RosInputModule

    |
    |
    v

Hydra Algorithms

    |
    |
    v

ROS Visualization / Output
```

The file's responsibility is:

1. Create Hydra modules
2. Connect module queues
3. Connect ROS subscribers
4. Connect ROS publishers
5. Control startup and shutdown

```
```
