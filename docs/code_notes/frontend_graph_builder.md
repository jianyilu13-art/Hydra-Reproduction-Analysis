
# Hydra Frontend GraphBuilder Workflow Analysis

File:


hydra/frontend/graph_builder.cpp


This file implements the **Hydra Frontend Module**. The main class is:

```
hydra::GraphBuilder

```

GraphBuilder is responsible for converting the output from the Reconstruction Module into a structured Dynamic Scene Graph (DSG). It does not directly communicate with ROS topics. Instead, it communicates with other Hydra modules using internal C++ objects, queues, and shared states.

The overall workflow is:

```

ROS Sensors
|
v
hydra_ros package
|
v
ROS Input Node
|
v
InputPacket
|
v
Reconstruction Module
|
v
ActiveWindowOutput
|
v
=


 Frontend Module
GraphBuilder.cpp


==========================
|
|
+----------------+
|                |
v                v

Dynamic Scene Graph    Backend Module
(DSG update)           Optimization


 |
 |
 v


LCD Module
Loop Closure Detection

```

---

# 1. Role of GraphBuilder

GraphBuilder is the main processing unit of the Hydra frontend.

The Reconstruction Module creates geometric information:

- TSDF map
- mesh
- robot pose
- sensor information

However, this is only raw geometry.

GraphBuilder converts this into semantic and structural information:

- objects
- rooms/places
- frontiers
- robot trajectory
- graph relationships


The idea:

```

Reconstruction Module:

"I see a 3D surface."

```
    |

    v
```

Frontend GraphBuilder:

"This surface belongs to a wall/object/place."

```
    |

    v
```

Dynamic Scene Graph:

Wall
|
contains
|
Chair
|
located in
|
Room

```

---

# 2. How GraphBuilder receives data

GraphBuilder does not receive ROS messages.

Instead:

```

Reconstruction Module
|
|
v

ActiveWindowOutput

```
      |
      |
      v
```

GraphBuilder InputQueue

```
      |
      |
      v
```

spin()

```
      |
      |
      v
```

Process data

````

The constructor creates an input queue:

```cpp
queue_(std::make_shared<InputQueue>())
````

This queue stores incoming reconstruction results.

The data type is:

```
ActiveWindowOutput
```

which contains:

* updated mesh
* graph updates
* robot pose
* sensor data

---

# 3. Starting GraphBuilder

When Hydra starts:

```
GraphBuilder::start()
```

creates a new thread:

```
start()

   |
   v

create frontend thread

   |
   v

spin()

```

The frontend runs continuously in the background.

---

# 4. Main frontend loop

The main loop is:

```
spin()
```

Workflow:

```
while running:

        |
        v

Check InputQueue

        |
        |
        +---- no data
        |
        v

Wait

        |
        |
        +---- new ActiveWindowOutput
                     |
                     v

              process packet

```

The frontend keeps waiting for new reconstruction outputs.

---

# 5. Processing one packet

When a new packet arrives:

```
ActiveWindowOutput

        |
        v

processNextInput()

        |
        v

spinOnce()

```

The main function:

```
spinOnce()
```

does the frontend update.

---

# 6. Frontend internal workflow

Inside spinOnce:

```
ActiveWindowOutput

        |
        v

updateImpl()

        |
        |
        +-------------------+
        |                   |
        v                   v

Update DSG          Run frontend modules


        |
        v

Create BackendInput


        |
        v

Send result to Backend

```

---

# 7. Updating the Dynamic Scene Graph

The first step:

```
graph_updater_.update()
```

updates the DSG.

Input:

```
graph_update
```

Output:

```
updated scene graph
```

Example:

Before:

```
Unknown mesh
```

After:

```
Room
 |
 Object
 |
 Chair
```

---

# 8. Frontend callback system

During initialization, GraphBuilder registers several callbacks:

```
updateMesh()

updateDeformationGraph()

updatePoseGraph()

updatePlaces()

updateFrontiers()
```

Therefore every new packet triggers:

```
ActiveWindowOutput

        |
        |
        +--> Mesh update

        |
        +--> Deformation graph update

        |
        +--> Pose graph update

        |
        +--> Place detection

        |
        +--> Frontier detection

```

---

# 9. Mesh update workflow

Function:

```
updateMesh()
```

Purpose:

Update the 3D mesh inside the scene graph.

Workflow:

```
Reconstruction Module

        |
        v

TSDF Mesh

        |
        v

Mesh Compression

        |
        v

Mesh Delta Update

        |
        v

DSG Mesh

```

The mesh update is later sent to Backend.

---

# 10. Object detection workflow

Function:

```
updateObjects()
```

Only runs when mesh object detection is enabled.

Workflow:

```
Mesh

 |
 v

MeshSegmenter

 |
 v

Object clusters

 |
 v

DSG object nodes

```

Example:

Input:

```
3D mesh
```

Output:

```
Chair object
Table object
Wall object
```

---

# 11. Place detection workflow

Function:

```
updatePlaces()
```

Detects free-space areas.

Workflow:

```
Map

 |
 v

Free-space detector

 |
 v

Place nodes

 |
 v

DSG

```

Example:

```
Kitchen
Bedroom
Hallway
```

---

# 12. Frontier detection workflow

Function:

```
updateFrontiers()
```

Used for exploration.

A frontier is the boundary between:

```
known space

      |

      |

unknown space
```

Workflow:

```
Current map

      |
      v

Find unknown boundary

      |
      v

Create frontier nodes

      |
      v

DSG
```

---

# 13. Pose graph update

Function:

```
updatePoseGraph()
```

Handles robot trajectory.

Workflow:

```
Robot movement

        |
        v

Pose Graph Packet

        |
        v

Agent nodes

        |
        v

Dynamic Scene Graph

```

The robot trajectory becomes part of the scene graph.

---

# 14. Communication with Backend

After frontend processing:

```
BackendInput
```

is created.

Then:

```
queues.backend_queue.push()
```

sends data.

Communication:

```
Frontend

   |
   |
backend_queue

   |
   v

Backend Module

```

The Backend receives:

* graph updates
* mesh updates
* deformation graph
* pose information

Backend then performs global optimization.

---

# 15. Communication with LCD

LCD means:

```
Loop Closure Detection
```

If enabled:

```
Frontend

    |
    |
lcd_queue

    |
    v

LCD Module

```

LCD searches for previously visited places.

Example:

Robot returns to an old room:

```
Current place

      |

      compare

      |

Previous place

```

---

# 16. Complete Hydra communication workflow

```
                 ROS2

                  |

                  v

          hydra_ros package

                  |

                  v

           Input Node

                  |

                  v

        Reconstruction Module

          (TSDF + Mesh)

                  |

                  v

          ActiveWindowOutput

                  |

                  v

================================

          Frontend Module

        GraphBuilder.cpp

================================

                  |

        +---------+---------+

        |         |         |

        v         v         v

      Mesh    Objects    Places

        |

        v

 Dynamic Scene Graph (DSG)

        |

        +-------------+

        |             |

        v             v

    Backend          LCD

 Optimization    Loop Closure

```

---

# Key conclusion

`graph_builder.cpp` is NOT a ROS node.

It is a C++ frontend module inside Hydra.

Its job is:

```
Receive reconstruction results

        ↓

Update Dynamic Scene Graph

        ↓

Add semantic information

        ↓

Send optimized graph information to Backend and LCD

```

The communication method is:

```
ROS topics:
        ROS Input only


Hydra internal communication:
        Queues
        Shared states
        C++ objects
        Callbacks
```

So the complete chain is:

```
ROS
 ↓
hydra_ros node
 ↓
Reconstruction Module
 ↓
GraphBuilder (Frontend)
 ↓
DSG
 ↓
Backend + LCD + Visualization
```

```
```
