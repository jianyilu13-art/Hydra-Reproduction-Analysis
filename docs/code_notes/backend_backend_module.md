
# Hydra Backend Module Explanation

## 1. Overview

This document explains the workflow of the Hydra `BackendModule` and how it communicates with other Hydra modules.

The source code is:

```

hydra/backend/backend_module.cpp

```

The Backend Module is responsible for:

- Receiving updates from the frontend pipeline
- Adding pose graph and deformation graph factors
- Handling loop closures
- Performing global optimization
- Deforming the reconstructed mesh
- Updating the Dynamic Scene Graph (DSG)

The backend is the **global optimization layer** of Hydra.

The code includes the BackendModule implementation and connects with components such as Kimera PGMO, pose graph tools, pipeline queues, and DSG utilities. :contentReference[oaicite:0]{index=0}


---

# 2. Position of Backend Module in Hydra

The overall Hydra workflow is:

```

Sensors
|
v
ROS Input Node
|
v
Frontend Module
|
|  BackendInput
v
Backend Module
|
+----------------------+
|                      |
v                      v
Pose Graph          Scene Graph / Mesh
Optimization        Update
|
v
Optimized DSG + Mesh
|
v
Visualization / Saving

````

The backend does not directly process raw sensor data.

It does not receive:

- Images
- LiDAR scans
- Depth data

Instead:

- Frontend creates local estimates.
- Backend receives these estimates.
- Backend performs global correction.

---

# 3. BackendModule Class

The main class is:

```cpp
class BackendModule
````

The constructor is:

```cpp
BackendModule(
    const Config& config,
    const SharedDsgInfo::Ptr& dsg,
    const SharedModuleState::Ptr& state
)
```

The backend receives three important objects.

---

## 3.1 Configuration

```cpp
config
```

Contains backend parameters:

* PGMO configuration
* Loop closure settings
* Optimization options
* Output sinks

The configuration is declared in:

```cpp
declare_config()
```

where fields such as:

```cpp
pgmo
optimize_on_lc
external_loop_closures
sinks
```

are registered. 

---

## 3.2 Shared Dynamic Scene Graph

```cpp
SharedDsgInfo::Ptr dsg
```

The DSG stores:

* Objects
* Places
* Rooms
* Mesh information

The backend keeps a private copy:

```cpp
unmerged_graph_ = private_dsg_->graph->clone();
```

This allows the backend to optimize without directly interfering with the frontend.

---

## 3.3 Shared Module State

```cpp
SharedModuleState::Ptr state
```

This is used to communicate with other modules.

The backend reads frontend updates from:

```cpp
state_->backend_graph
```

---

# 4. Backend Initialization Workflow

When Hydra starts:

```
HydraPipeline

      |
      v

Create BackendModule

      |
      v

BackendModule Constructor

      |
      v

Create graph copy

      |
      v

Create mesh

      |
      v

Create DSG updater

      |
      v

start()

      |
      v

Create backend thread
```

---

## Constructor Operations

### 1. Copy the graph

```cpp
unmerged_graph_ = private_dsg_->graph->clone();
```

The backend creates its own graph copy.

Reason:

Frontend continues building the scene while backend performs optimization.

---

### 2. Create mesh

```cpp
private_dsg_->graph->setMesh(...)
```

The backend initializes the mesh structure used for optimization.

---

### 3. Create DSG updater

```cpp
dsg_updater_
```

The updater applies optimized information back into the scene graph.

---

# 5. Backend Execution Loop

The backend runs continuously.

Main function:

```cpp
BackendModule::spin()
```

Workflow:

```
while running

      |
      v

Check backend queue

      |
      v

Receive BackendInput

      |
      v

Process update

      |
      v

Optimize if needed

```

The communication queue is:

```cpp
PipelineQueues::instance().backend_queue
```

The backend waits for new frontend information through this queue. 

---

# 6. Communication Between Frontend and Backend

The main communication object is:

```cpp
BackendInput
```

The data flow is:

```
Frontend Module

       |
       |
       v

backend_queue

       |
       |
       v

BackendModule

```

BackendInput contains:

```
BackendInput
 |
 +-- timestamp
 |
 +-- deformation graph
 |
 +-- pose graph updates
 |
 +-- mesh update
 |
 +-- agent updates
```

The backend receives it in:

```cpp
spinOnce()
```

where it reads:

```cpp
queue.front()
```

and processes the packet. 

---

# 7. Main Backend Workflow

The central function is:

```cpp
BackendModule::spinOnce()
```

The workflow is:

```
Receive BackendInput

        |
        v

Update Factor Graph

        |
        v

Process Loop Closures

        |
        v

Update DSG

        |
        v

Optimize

        |
        v

Update Mesh

        |
        v

Send Result
```

---

# 8. Updating the Factor Graph

Function:

```cpp
updateFactorGraph(input)
```

Purpose:

Convert frontend information into optimization constraints.

It processes:

* Deformation graph edges
* Pose graph edges
* Loop closures

---

## Deformation Graph

Frontend sends:

```
deformation graph
```

Backend processes it using:

```cpp
processIncrementalMeshGraph()
```

The deformation graph represents mesh deformation constraints.

It allows Hydra to move the mesh after global correction.

---

## Pose Graph

Frontend sends:

```
pose graph messages
```

Backend receives:

```cpp
input.agent_updates.pose_graphs
```

Then:

```cpp
processIncrementalPoseGraph()
```

adds these constraints into the optimizer. 

---

# 9. Loop Closure Communication

Loop closures are additional constraints that correct drift.

There are two sources.

---

## 9.1 Frontend LCD Loop Closures

The loop closure detector sends results into:

```cpp
backend_lcd_queue
```

Workflow:

```
Loop Closure Detection

        |
        v

backend_lcd_queue

        |
        v

updateFromLcdQueue()

        |
        v

addLoopClosure()

```

The backend converts loop closures into optimization factors. 

---

## 9.2 External Loop Closures

External systems can also provide loop closures.

The backend receives them using:

```cpp
external_lc_receiver_
```

and adds them into the deformation graph. 

---

# 10. Optimization Workflow

Optimization happens when:

```
New loop closure detected
```

or forced optimization is requested.

Condition:

```cpp
if(config.optimize_on_lc && have_loopclosures_)
```

Workflow:

```
Loop Closure

      |
      v

Add Constraints

      |
      v

Kimera PGMO Optimization

      |
      v

Update Node Poses

      |
      v

Deform Mesh

      |
      v

Update DSG
```

The optimization function:

```cpp
optimize()
```

calls:

```cpp
KimeraPgmoInterface::optimize()
```

to perform global optimization. 

---

# 11. Mesh Update Workflow

After optimization:

```
Optimized deformation graph

          |
          v

deformPoints()

          |
          v

Updated Mesh

```

Function:

```cpp
updateDsgMesh()
```

updates the reconstructed mesh using optimized deformation values. 

---

# 12. Dynamic Scene Graph Update

After optimization:

```cpp
dsg_updater_->callUpdateFunctions()
```

is called.

The backend sends:

```
UpdateInfo
```

containing:

* Optimized values
* Loop closure information
* Deformation graph information

Flow:

```
Backend Optimization

        |
        v

UpdateInfo

        |
        v

DsgUpdater

        |
        v

Updated Dynamic Scene Graph

```

---

# 13. Complete Communication Diagram

```
                 Frontend Module
                       |
                       |
                 BackendInput
                       |
                       v
              backend_queue
                       |
                       v
              BackendModule
                       |
        +--------------+--------------+
        |                             |
        v                             v
 updateFactorGraph              LCD Queue
        |                             |
        v                             v
 Pose Graph +                 Loop Closures
 Deformation Graph                 |
        |                          |
        +-------------+------------+
                      |
                      v
                Optimization
                      |
        +-------------+-------------+
        |                           |
        v                           v
  Optimized Pose              Mesh Deformation
        |                           |
        +-------------+-------------+
                      |
                      v
                DSG Update
                      |
                      v
             Visualization / Save
```

---

# 14. Summary

The Backend Module is Hydra's global correction system.

The complete workflow is:

```
Frontend
   |
   |  BackendInput
   v
Backend Queue
   |
   v
Backend Module
   |
   +--> Add Graph Factors
   |
   +--> Handle Loop Closures
   |
   +--> Optimize Pose Graph
   |
   +--> Deform Mesh
   |
   +--> Update DSG
   |
   v
Global Consistent Map
```

In simple words:

* Frontend builds a local map.
* Backend receives frontend results.
* Backend finds global consistency.
* Loop closures correct drift.
* Optimization updates the mesh and scene graph.
* The final output is a globally optimized 3D scene graph.

```
```
