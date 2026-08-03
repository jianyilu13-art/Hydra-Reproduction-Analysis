# Hydra ROS Input Module (`ros_input_module.cpp`) Workflow Explanation

File:

```
hydra_ros/input/ros_input_module.cpp
```

---

# 1. Purpose of This File

`ros_input_module.cpp` implements the bridge between ROS input and Hydra's internal input system.

The main responsibility of `RosInputModule` is:

```
ROS Sensor Configuration

        |
        v

Create Hydra-compatible sensor objects

        |
        v

Receive sensor data

        |
        v

Get robot pose from TF

        |
        v

Send synchronized input into Hydra
```

This file does not perform reconstruction itself.

Instead, it prepares the input information that Hydra needs.

The role of this module:

```
ROS
 |
 | sensor data
 | robot pose
 v
RosInputModule
 |
 | processed input
 v
Hydra Input Pipeline
```

---

# 2. Overall Workflow

The execution flow of this file is:

```
Hydra starts

      |
      v

Read configuration

      |
      v

declare_config()

      |
      v

Create RosInputModule

      |
      v

remapSensors()

      |
      v

Create sensor objects

      |
      v

ROS provides sensor measurements

      |
      v

getBodyPose(timestamp)

      |
      v

TF provides robot pose

      |
      v

Sensor data + robot pose

      |
      v

Hydra processing pipeline
```

---

# 3. Header Files and Their Roles


## ros_input_module.h

```cpp
#include "hydra_ros/input/ros_input_module.h"
```

This contains the definition of:

```
RosInputModule
```

It defines:

- Configuration structure
- Constructor
- Pose retrieval function
- ROS input interface


Relationship:

```
ros_input_module.h

        |
        v

ros_input_module.cpp

        |
        v

Implementation
```


---

## Configuration Utilities


```cpp
#include <config_utilities/config.h>
#include <config_utilities/printing.h>
#include <config_utilities/validation.h>
```

Hydra uses configuration utilities to connect YAML parameters with C++ variables.


Workflow:

```
YAML file

    |
    v

Config object

    |
    v

RosInputModule
```


Example:

```
tf_lookup

```

in YAML becomes:

```
config.tf_lookup
```

in C++.


---

## Hydra Global Information


```cpp
#include <hydra/common/global_info.h>
```

Provides Hydra system utilities.

In this file it is mainly used for logging:

```cpp
LOG(WARNING)
```

Example:

```
Invalid sensor name

        |
        v

Print warning message
```

---

## ROS Sensors


```cpp
#include "hydra_ros/input/ros_sensors.h"
```

Provides sensor creation functions.

Important function:

```
input::loadSensor()
```

Its job is to create the correct sensor object.

Workflow:

```
Sensor configuration

        |
        v

loadSensor()

        |
        v

Create sensor class
```

Example:

```
RGBD sensor

      |
      v

RGBDSensor object


LiDAR sensor

      |
      v

LidarSensor object
```

---

# 4. Namespace Structure


```cpp
namespace hydra {

}
```

The code belongs to Hydra.


The anonymous namespace:

```cpp
namespace {

}
```

contains helper functions that are only used inside this file.

Example:

```
isNumber()
```

is private to this `.cpp` file.

---

# 5. Helper Function: isNumber()


Function:

```cpp
inline bool isNumber(const std::string& name)
```


Purpose:

Check whether a sensor name contains only numbers.


Example:

```
"0"
"1"
"123"
```

returns:

```
true
```


Example:

```
"camera"
"lidar"
```

returns:

```
false
```


Why is this needed?

ROS names cannot be only numbers.

Example YAML:

```yaml
inputs:
  0:
    type: camera
```

creates:

```
sensor name = "0"
```

which is invalid.


Therefore Hydra changes it:

```
0

 |

 v

sensor0
```

---

# 6. Configuration Declaration


Function:

```cpp
void declare_config(RosInputModule::Config& config)
```


Purpose:

Connect configuration parameters with the C++ object.


Workflow:

```
YAML

 |
 v

RosInputModule::Config

 |
 v

RosInputModule
```


---

## Give Configuration a Name


```cpp
name("RosInputModule::Config");
```


Used for:

- Debugging
- Printing
- Validation


---

## Inherit InputModule Configuration


```cpp
base<InputModule::Config>(config);
```


Relationship:

```
InputModule::Config

        |
        v

RosInputModule::Config
```


Meaning:

RosInputModule uses all normal InputModule settings plus ROS-specific settings.


---

## TF Configuration


```cpp
field(config.tf_lookup, "tf_lookup");
```


Connects:

```
YAML:

tf_lookup

      |

      v

C++:

config.tf_lookup
```


Used later for robot pose retrieval.


---

## Queue Clearing Configuration


```cpp
field(config.clear_queue_on_fail,
      "clear_queue_on_fail");
```


Controls what happens when robot pose is unavailable.


Logic:

```
No robot pose

      |
      v

Should queue be cleared?

      |
      v

clear old sensor data
```

---

# 7. Sensor Remapping


Function:

```cpp
InputModule::Config RosInputModule::Config::remapSensors()
```


Purpose:

Convert configuration sensors into actual Hydra sensor objects.


Workflow:

```
Sensor configuration

        |
        v

Check sensor name

        |
        v

Fix invalid ROS names

        |
        v

Create sensor object

        |
        v

Return InputModule configuration
```

---

# 8. Loop Through Sensors


Code:

```cpp
for (const auto& [name, input_pair] : inputs)
```


Meaning:

Go through every sensor defined in the configuration.


Example:

YAML:

```yaml
inputs:

 camera:
    type: RGBD

 lidar:
    type: Lidar
```


The loop processes:

```
camera

then

lidar
```

---

# 9. Sensor Name Correction


Logic:

```
Check sensor name

        |
        v

Is it only numbers?

        |
        +------ No
        |
        v

Use original name


        |
        +------ Yes
        |
        v

Rename sensor
```

Example:


Before:

```
0
```

After:

```
sensor0
```


A warning is printed:

```
Invalid ROS name found
```

---

# 10. Creating Sensor Objects


Code:

```cpp
input::loadSensor()
```


This is the connection between configuration and actual sensor classes.


Workflow:

```
Sensor type from YAML

        |
        v

loadSensor()

        |
        v

Create object
```


Example:

```
YAML:

type: RGBD


        |
        v


RGBDSensor created
```


After this:

Hydra has objects that understand how to process each sensor.

---

# 11. RosInputModule Constructor


Function:

```cpp
RosInputModule(
const Config& config,
const OutputQueue::Ptr& queue)
```


Purpose:

Create the ROS input module.


When this happens:

```
Hydra starts

      |
      v

Create RosInputModule object
```

---

# 12. Constructor Initialization Logic


The initialization list:

```cpp
: InputModule(config.remapSensors(), queue),
  config(config),
  lookup_(config.tf_lookup),
  have_first_pose_(false)
```


It performs four actions.


---

## 1. Initialize Parent InputModule


```
RosInputModule

      |
      v

InputModule
```


It gives InputModule:

- Sensor configuration
- Output queue


---

## 2. Store Configuration


```cpp
config(config)
```


The object keeps its configuration internally.

---

## 3. Create TF Lookup


```cpp
lookup_(config.tf_lookup)
```


Creates the object responsible for finding robot poses.


Flow:

```
Timestamp

      |
      v

TF system

      |
      v

Robot pose
```

---

## 4. Initialize Pose State


```cpp
have_first_pose_(false)
```


At startup:

```
No valid robot pose received
```

After first successful pose:

```
true
```

---

# 13. Print Information


Function:

```cpp
printInfo()
```


Purpose:

Show current configuration.


Example:

```
RosInputModule

tf_lookup = true

clear_queue_on_fail = true
```

Used for debugging.

---

# 14. Getting Robot Pose


Function:

```cpp
PoseStatus getBodyPose(uint64_t timestamp_ns)
```


Purpose:

Find where the robot was at a specific time.


Input:

```
timestamp
```


Output:

```
PoseStatus
```


Meaning:

```
success:
robot pose found


failure:
robot pose unavailable
```

---

# 15. TF Lookup Workflow


Code:

```cpp
lookup_.getBodyPose(timestamp_ns)
```


Process:

```
Sensor timestamp

        |
        v

TF lookup

        |
        v

Robot transformation

        |
        v

PoseStatus
```

---

# 16. First Pose Detection


Logic:

```
Pose available?

        |
        v

Yes

        |
        v

Have first pose?

        |
        v

No

        |
        v

Set:

have_first_pose = true
```


Meaning:

Hydra has started receiving valid robot motion information.

---

# 17. Pose Failure Handling


Condition:


```
Pose unavailable

AND

No previous pose received

AND

clear_queue_on_fail enabled
```


Then:


```
Clear sensor queues
```


Why?

Because:


```
Sensor data without robot pose

        =

Incorrect mapping information
```


Workflow:

```
Sensor data arrives

        |
        v

TF lookup fails

        |
        v

Remove waiting data

        |
        v

Wait for valid pose
```

---

# 18. Complete ROS-Hydra Connection


Final workflow:


```
                ROS

        Camera / LiDAR Topics

                 |
                 v

        RosInputModule

                 |
        +--------+--------+
        |                 |
        v                 v

 Sensor Objects       TF Lookup

        |                 |
        +--------+--------+

                 |
                 v

        Valid Sensor Input

                 |
                 v

           Hydra InputModule

                 |
                 v

          Hydra Pipeline
```


---

# Main Understanding


`RosInputModule` is the translator between ROS and Hydra.


ROS provides:

```
Sensor measurements
Robot transformations
```

RosInputModule performs:

```
Configuration loading

Sensor creation

Data management

Pose synchronization
```

Hydra receives:

```
Sensor data + robot pose
```

and can continue:

```
Mapping

Reconstruction

Scene Graph Generation
```

The key idea:

**ROS provides the information.  
RosInputModule organizes and converts it.  
Hydra uses it to understand the environment.**




# C++ Inheritance in Hydra ROS: `class RosInputModule : public InputModule`

## Meaning of `:`

In C++, the `:` in:

```cpp
class RosInputModule : public InputModule
```

means **inheritance**.

It means:

> `RosInputModule` is a child class of `InputModule`.

Another way to understand it:

```
RosInputModule IS-A InputModule
```

---

# Without inheritance

If we write:

```cpp
class InputModule
{
    // Hydra input functions
};


class RosInputModule
{
    // ROS input functions
};
```

These are two separate classes:

```
InputModule

RosInputModule
```

Hydra does not know that `RosInputModule` can be used as an input module.

---

# With inheritance

When we write:

```cpp
class RosInputModule : public InputModule
```

The relationship becomes:

```
          InputModule
               |
               |
               v
        RosInputModule
```

Now:

- `RosInputModule` receives the functions and properties of `InputModule`
- `RosInputModule` can add its own ROS-specific functions

---

# What does `public` mean?

The complete syntax:

```cpp
class Child : public Parent
```

means:

- `Child` inherits from `Parent`
- The public parts of `Parent` remain public in `Child`

Example:

```cpp
class InputModule
{
public:
    void start();
    void process();
};


class RosInputModule : public InputModule
{

};
```

Now:

```cpp
RosInputModule ros;

ros.start();
ros.process();
```

works.

Because `RosInputModule` inherited these functions from `InputModule`.

---

# Hydra Example

The class relationship:

```
                 InputModule
                      |
                      |
                      v
              RosInputModule
```

`InputModule` is the general Hydra input interface.

It handles common input functions such as:

- sensor management
- input queues
- common input processing

`RosInputModule` adds ROS-specific functions:

- ROS sensor connection
- ROS message receiving
- TF lookup
- ROS sensor initialization

So:

```
InputModule
"I know how Hydra receives sensor inputs"

              +

RosInputModule
"I know how to get those inputs from ROS"

              |

              v

      ROS-compatible Hydra Input System
```

---

# Why use inheritance?

Hydra Core does not need to know about ROS.

Hydra only needs something that behaves like an:

```
InputModule
```

Instead of directly using:

```
RosInputModule
```

Hydra can use the parent type:

```cpp
InputModule* input;
```

Then we provide:

```cpp
RosInputModule
```

because:

```
RosInputModule IS-A InputModule
```

Therefore Hydra can use it.

---

# Simple Analogy

Think about vehicles:

```
          Vehicle
             |
             |
             v
            Car
```

A car inherits from vehicle.

Every car is a vehicle, but a car has extra functions.

Similarly:

```
        InputModule
             |
             |
             v
      RosInputModule
```

Every `RosInputModule` is an `InputModule`, but it has additional ROS communication abilities.

---

# Communication Summary

In Hydra ROS:

```
ROS Communication

Camera / LiDAR
       |
       v
ROS Receivers
       |
       v
RosInputModule
       |
       v
InputModule
       |
       v
Hydra Core
```

The inheritance relationship allows:

```
RosInputModule
        |
        |
        v
InputModule interface
        |
        |
        v
Hydra Core
```

Hydra only cares that it receives an `InputModule`. It does not need to know that the actual implementation is ROS-based.



