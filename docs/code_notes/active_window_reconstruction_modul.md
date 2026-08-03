# Hydra Reconstruction Module (`reconstruction_module.cpp`) Code Analysis

File:

```
hydra/active_window/reconstruction_module.cpp
```

---

# 1. Overview

## Purpose of this file

`reconstruction_module.cpp` implements the **Reconstruction Module** inside Hydra.

The job of this module is:

> Convert incoming sensor data (RGB-D / depth / semantic information) into a 3D reconstruction representation.

The reconstruction pipeline mainly contains:

```
Sensor Input
     |
     v
Input Conversion
     |
     v
Semantic Filtering
     |
     v
TSDF Integration
     |
     v
Mesh Generation
     |
     v
Active Window Output
```

In simple words:

The module receives:

- Camera pose
- Depth image
- RGB image
- Semantic labels

Then it builds:

- TSDF volumetric map
- 3D mesh
- Free-space information
- Updated map blocks

---

# 2. Where does this module belong in Hydra?

Hydra architecture:

```
                  Sensor Data
                       |
                       v
                 InputPacket
                       |
                       v
                Active Window
                       |
          +------------+------------+
          |                         |
          v                         v
     Reconstruction             Frontend
          |                         |
          |                         |
          v                         |
       TSDF/Mesh                   |
          |                         |
          +------------+------------+
                       |
                       v
                  Backend
                       |
                       v
              Dynamic Scene Graph

```
```
hydra
 |
 +-- active_window
       |
       +-- reconstruction_module.cpp
```

It is NOT a ROS node.

It is a C++ module/class used internally by the Hydra pipeline.

The workflow:
```
InputPacket
     |
     v
ReconstructionModule
     |
     +--> TSDF Integrator
     |
     +--> Mesh Integrator
     |
     v
Updated Mesh
```

---

# 3. Header Include

```cpp
#include "hydra/active_window/reconstruction_module.h"
```

This includes the class declaration.

The header file contains:

- Class definition
- Member variables
- Function declarations

Example:

```cpp
class ReconstructionModule : public ActiveWindowModule
{
    ...
};
```

The `.cpp` file provides the implementation.

---

# 4. External Libraries

## Config utilities

```cpp
#include <config_utilities/config.h>
#include <config_utilities/printing.h>
#include <config_utilities/validation.h>
```

Hydra uses configuration objects.

Example:

YAML:

```yaml
ReconstructionModule:
  full_update_separation_s: 1.0
  max_input_queue_size: 10
```

becomes:

```cpp
ReconstructionModule::Config
```

---

## Timing

```cpp
#include <chrono>
#include <iomanip>
```

Used for:

- Measuring time
- Printing timestamps
- Profiling performance

---

# 5. Hydra Internal Components

## Global information

```cpp
#include "hydra/common/global_info.h"
```

Stores global settings.

Example:

Semantic label definitions:

```
chair -> 5
table -> 6
wall -> 7
```

---

## Input conversion

```cpp
#include "hydra/input/input_conversion.h"
```

Converts raw input:

```
InputPacket
      |
      v
InputData
```

InputPacket is the message from previous modules.

---

## Robot footprint

```cpp
#include "hydra/places/robot_footprint_integrator.h"
```

Tracks where the robot has moved.

Used for:

```
Robot position
      |
      v
Mark free space
```

Example:

Robot travels:

```
##########
#        #
#  R --->#
#        #
##########
```

The path becomes known free space.

---

## Reconstruction algorithms

```cpp
#include "hydra/reconstruction/mesh_integrator.h"
#include "hydra/reconstruction/projective_integrator.h"
```

Two major components:

---

## ProjectiveIntegrator

Responsible for:

```
Depth Image
      |
      v
TSDF Volume
```

It performs volumetric fusion.

Example:

Camera sees:

```
Depth image

100cm
120cm
150cm
```

Integrates them into:

```
3D voxel map
```

---

## MeshIntegrator

Responsible for:

```
TSDF
 |
 v
Triangle Mesh
```

Usually uses Marching Cubes.

Output:

```
Voxel map

   |
   v

3D surface mesh
```

---

# 6. Namespace

```cpp
namespace hydra {
```

Everything belongs to the Hydra namespace.

It prevents name conflicts.

Example:

Without namespace:

```cpp
ReconstructionModule
```

could conflict with another library.

With namespace:

```cpp
hydra::ReconstructionModule
```

---

# 7. Anonymous Namespace

```cpp
namespace {
```

Functions inside here are only visible in this file.

They are private helper functions.

---

# 8. Module Registration

```cpp
static const auto registration =
    config::RegistrationWithConfig<
        ActiveWindowModule,
        ReconstructionModule,
        ReconstructionModule::Config,
        ActiveWindowModule::OutputQueue::Ptr>(
        "ReconstructionModule");
```

This registers the module into Hydra.

Meaning:

Hydra can create it using configuration.

Example:

YAML:

```yaml
active_window:
  module: ReconstructionModule
```

Hydra sees:

```
"ReconstructionModule"
        |
        v
C++ class
```

Similar to ROS plugin systems.

---

# 9. Time Difference Function

```cpp
double diffInSeconds(uint64_t lhs, uint64_t rhs)
```

Purpose:

Calculate timestamp difference.

Input:

```
lhs = current timestamp

rhs = previous update timestamp
```

Example:

```
current:
10 seconds

previous:
8 seconds


difference:

2 seconds
```

---

# 10. Rotation Printing

```cpp
std::string printRotation(
    const Eigen::Matrix3d& rot)
```

Converts rotation matrix:

```
3x3 Matrix
```

into quaternion:

```
x,y,z,w
```

Example output:

```
{w:1,x:0,y:0,z:0}
```

Used only for debugging.

---

# 11. Configuration Declaration

Function:

```cpp
void declare_config(
    ReconstructionModule::Config& config)
```

Purpose:

Define parameters that Hydra can load.

---

## Module name

```cpp
name("ReconstructionModule::Config");
```

Names this configuration.

---

## Inherit ActiveWindow configuration

```cpp
base<ActiveWindowModule::Config>(config);
```

Means:

```
ReconstructionModule::Config

inherits

ActiveWindowModule::Config
```

Structure:

```
ActiveWindowModule
        |
        |
ReconstructionModule
```

---

## Full update interval

```cpp
field(
config.full_update_separation_s,
"full_update_separation_s",
"s");
```

Controls:

How often Hydra creates a complete mesh update.

Example:

```
0 sec

update every frame


1 sec

update every second
```

---

## Input queue size

```cpp
field(config.max_input_queue_size,
"max_input_queue_size");
```

Controls:

How many sensor messages can wait.

Example:

```
Camera messages:

1
2
3
4

queue size = 10
```

---

## TSDF configuration

```cpp
field(config.tsdf,"tsdf");
```

Controls volumetric reconstruction.

---

## Mesh configuration

```cpp
field(config.mesh,"mesh");
```

Controls mesh generation.

---

# 12. Constructor

```cpp
ReconstructionModule::ReconstructionModule(...)
```

Creates the module.

---

## Parent constructor

```cpp
ActiveWindowModule(config, queue)
```

Calls the base class.

Hierarchy:

```
ActiveWindowModule

        |
        v

ReconstructionModule
```

---

## Validate configuration

```cpp
config(config::checkValid(config))
```

Checks:

Are parameters valid?

Example:

Invalid:

```
voxel_size = -1
```

---

## Create TSDF integrator

```cpp
tsdf_integrator_ =
std::make_unique<ProjectiveIntegrator>
```

Creates:

```
ReconstructionModule

      |
      v

ProjectiveIntegrator
```

---

## Create mesh integrator

```cpp
mesh_integrator_ =
std::make_unique<MeshIntegrator>
```

Creates:

```
TSDF

 |

Mesh
```

---

## Robot footprint

```cpp
footprint_integrator_(
config.robot_footprint.create())
```

Creates free-space tracker.

---

# 13. printInfo()

```cpp
std::string ReconstructionModule::printInfo()
```

Returns:

```
configuration information
+
sink information
```

Used for debugging.

---

# 14. shouldUpdate()

```cpp
bool ReconstructionModule::shouldUpdate(
uint64_t timestamp_ns)
```

Determines:

Should Hydra create a full mesh update?

---

First update:

```cpp
if(!last_update_ns_)
{
    return true;
}
```

No previous update:

```
YES
```

---

Later:

```cpp
diff_s >= config.full_update_separation_s
```

Example:

Configuration:

```
full_update_separation_s = 1
```

Current:

```
5 sec
```

Previous:

```
3 sec
```

Difference:

```
2 sec
```

Therefore:

```
Update mesh
```

---

# 15. Main Function: spinOnce()

```cpp
ActiveWindowOutput::Ptr
ReconstructionModule::spinOnce(
const InputPacket& msg)
```

This is the core loop.

Every sensor message calls this function.

Flow:

```
InputPacket

   |

   v

Check data

   |

   v

Convert input

   |

   v

Semantic filtering

   |

   v

TSDF update

   |

   v

Mesh update

   |

   v

Return output
```

---

# 16. Check Input

```cpp
if(!msg.sensor_input)
```

If no sensor data:

```
Error
return
```

---

# 17. Get Robot Pose

```cpp
const auto world_T_body =
msg.world_T_body();
```

Gets:

Robot pose in world frame.

Transformation:

```
World

 |

 |

Robot
```

Contains:

- Translation
- Rotation

---

# 18. Decide Update Type

```cpp
const auto do_full_update =
shouldUpdate(timestamp_ns);
```

Two possibilities:

```
Partial update

or

Full update
```

---

# 19. Convert Input

```cpp
InputData::Ptr data =
conversions::parseInputPacket(
msg,
false,
map_.hasSemantics());
```

Converts:

Before:

```
InputPacket
```

After:

```
InputData
```

Contains:

```
RGB image

Depth image

Labels

Camera information
```

---

# 20. Semantic Filtering

```cpp
invalid_labels.insert(
label_config.invalid_labels);
```

Collect labels that should NOT be reconstructed.

Example:

Invalid:

```
unknown
background
dynamic objects
```

---

Dynamic objects:

```cpp
invalid_labels.insert(
label_config.dynamic_labels);
```

Example:

Remove:

```
person
car
animal
```

because they move.

---

# 21. Create Integration Mask

```cpp
maskInvalidSemantics(
data->label_image,
invalid_labels,
integration_mask);
```

Creates:

```
Semantic Image

       |

       v

Mask

0 = ignore

1 = integrate
```

Example:

Image:

```
chair person wall
```

Mask:

```
1      0      1
```

---

# 22. TSDF Integration

```cpp
tsdf_integrator_->updateMap(
*data,
map_,
true,
integration_mask);
```

Main reconstruction step.

Input:

```
Depth image
+
Pose
+
Mask
```

Output:

```
TSDF volume
```

---

# 23. Robot Free Space

```cpp
footprint_integrator_->markFreespace(
world_T_body.cast<float>(),
map_);
```

Marks:

```
Robot travelled area
```

as free.

---

# 24. Check Mesh Update

```cpp
if(tsdf.numBlocks()==0
|| !do_full_update)
{
    return nullptr;
}
```

If:

- No map exists
- Not time for full update

stop here.

---

# 25. Generate Mesh

```cpp
mesh_integrator_->generateMesh(
map_,
true,
true);
```

Converts:

```
TSDF

 |

 v

Triangle mesh
```

---

# 26. Create Output

```cpp
auto output =
ActiveWindowOutput::fromInput(msg);
```

Creates output message.

Contains:

```
Original input

+
Reconstructed map
```

---

# 27. Archive Old Blocks

```cpp
map_window_->archiveBlocks()
```

Active window management.

Old blocks:

```
Active area

      |
      v

Archive
```

Used for large environments.

---

# 28. Clone Updated Map

```cpp
output->setMap(
map_.cloneUpdated());
```

Only sends changed blocks.

Instead of:

```
Whole map
```

send:

```
Updated blocks only
```

Improves efficiency.

---

# 29. Clear Update Flags

```cpp
block.clearUpdated();
```

After sending:

```
Block status:

updated
     |
     v
not updated
```

---

# 30. Complete Reconstruction Workflow

```
                 ROS Sensors
                     |
                     v
              Input Module
                     |
                     v
              InputPacket
                     |
                     v
          ReconstructionModule
                     |
                     |
          +----------+----------+
          |                     |
          v                     v
    Semantic Mask          Robot Pose
          |
          v
    ProjectiveIntegrator
          |
          v
        TSDF Map
          |
          v
     MeshIntegrator
          |
          v
      3D Mesh
          |
          v
     ActiveWindowOutput
          |
          v
       Hydra Backend
```

---

# 31. Important C++ Concepts Used

## `::`

Scope resolution operator.

Example:

```cpp
hydra::ReconstructionModule
```

means:

```
ReconstructionModule
inside namespace hydra
```

---

## `&`

Reference.

Example:

```cpp
Config& config
```

Means:

Use the original object.

No copying.

---

## `*`

Pointer.

Example:

```cpp
tsdf_integrator_->updateMap()
```

Means:

Access object through pointer.

---

## `std::make_unique`

Creates a managed pointer.

Example:

```cpp
std::make_unique<MeshIntegrator>()
```

creates:

```
MeshIntegrator object
```

and automatically deletes it later.

---

# 32. Summary

`reconstruction_module.cpp` is the part of Hydra responsible for converting sensor observations into a 3D geometric model.

Its main job:

```
Sensor Data

    |
    v

Semantic Filtering

    |
    v

TSDF Reconstruction

    |
    v

Mesh Generation

    |
    v

Send Updated Map
```

It is NOT a ROS node.

It is a C++ module/class running inside Hydra's Active Window system.

The module communicates with other Hydra modules through:

```
InputPacket
        |
        v
ReconstructionModule
        |
        v
ActiveWindowOutput
```

and provides the geometric foundation for later modules:

```
Reconstruction
        |
        v
Frontend / Backend
        |
        v
3D Scene Graph
```
```
                Sensors
                  |
                  v
              hydra_ros
                  |
                  v
             InputPacket
                  |
                  v
================================================
 Layer 1: Geometry Reconstruction
================================================
        ReconstructionModule
                  |
                  |
        +---------+---------+
        |                   |
        v                   v
      TSDF                Mesh
        |
        v
      ESDF / GVD (if enabled)
                  
================================================
 Layer 2: Semantic Understanding
================================================
        Semantic Module
                  |
                  v
        Object / Class Labels


================================================
 Layer 3: Scene Graph
================================================
          Frontend
                  |
                  v
        Objects + Places + Rooms
                  |
                  v
              Scene Graph


================================================
 Layer 4: Optimization
================================================
          Backend
                  |
                  v
     Optimized poses + graph

```