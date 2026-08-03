# Hydra System Architecture

## 1. Overview: Motivation Behind Hydra

Before reproducing Hydra, I investigated the evolution of robotic environment representations and the limitations that motivated semantic 3D scene graph generation.

<br>
<br>


### Question 1: How did traditional robotic mapping represent environments?

Traditional robotic mapping mainly focused on metric representations, including volumetric maps, point clouds, and 3D meshes.

| Representation | Advantage | Limitation |
|---|---|---|
| Volumetric maps | Accurate geometric structure | Limited semantic information |
| Point clouds | Detailed spatial measurements | Difficult high-level reasoning |
| 3D meshes | Surface reconstruction | Lack of object-level understanding |

These methods provide accurate geometric information for reconstruction, localization, and navigation. However, they mainly describe low-level spatial structures and do not explicitly represent semantic concepts such as objects, rooms, and spatial relationships. Furthermore, dense geometric representations require significant computation and memory, making them difficult to scale to large and complex environments. Therefore, geometric maps alone are insufficient for efficient semantic reasoning and high-level robot decision-making.

Therefore, dense geometric maps alone are insufficient for semantic reasoning and high-level robot decision-making.


<br>
<br>

### Question 2: Why are object-based representations insufficient?

Object-based mapping represents environments using detected objects and their relationships.

Compared with dense geometric maps, object-based representations provide semantic information, but they usually lack detailed geometric structures required for accurate navigation, manipulation, and spatial reasoning.

| Representation | Advantage | Limitation |
|---|---|---|
| Dense representation | Accurate geometry | Weak semantic abstraction |
| Object representation | Semantic understanding | Limited geometric details |

This creates a fundamental trade-off between geometric accuracy and semantic understanding.


<br>
<br>

### Question 3: Why are hierarchical 3D scene graphs introduced?

Hierarchical 3D scene graphs aim to combine metric and semantic information by representing environments at multiple abstraction levels.

| Layer | Representation | Function |
|---|---|---|
| Layer 1 | Metric-semantic mesh | Low-level geometric reconstruction |
| Layer 2 | Objects | Semantic entities |
| Layer 3 | Places | Topological navigation structure |
| Layer 4 | Rooms | High-level spatial organization |

Therefore, hierarchical 3D scene graphs bridge the gap between low-level perception and high-level decision-making, enabling robots to understand commands expressed in human semantic terms and execute complex tasks in real-world environments.


<br>
<br>

### Question 4: What limitations existed in previous scene graph approaches?


#### Limitations of Previous Scene Graph Approaches

| Challenge | Why it is a limitation |
|---|---|
| Complete environment reconstruction | Previous methods often required the entire environment to be captured before constructing the scene graph. This requires storing large amounts of sensor data and performing expensive global optimization, resulting in high memory and computation costs. |
| Offline optimization | Scene graphs were usually generated after exploration. The robot could not update the representation continuously, making them unsuitable for real-time applications or changing environments. |
| Long exploration | During long-term navigation, small localization errors accumulate. Without global correction, the reconstructed scene may become inconsistent, leading to inaccurate object positions and spatial relationships. |

---

#### Requirements for Practical Robotic Scene Graphs

| Requirement | Why it is needed |
|---|---|
| Hierarchical semantic representation | Robots need multiple abstraction levels to understand human commands, such as reasoning from rooms → objects → locations. |
| Real-time incremental construction | Robots need to update the scene representation while exploring instead of waiting until the entire environment is reconstructed. |
| Computational efficiency | Large-scale environments generate massive sensor data; efficient representations reduce memory usage and processing requirements. |
| Global consistency after exploration | Robots must maintain accurate spatial relationships even after long navigation trajectories with accumulated localization errors. |

<br>
<br>

### Question 5: How does Hydra address these limitations?

Hydra introduces a real-time incremental framework for semantic 3D scene graph generation.

Instead of maintaining a complete global volumetric model, Hydra uses a spatially bounded active window to maintain TSDF and ESDF representations around the robot.

| Problem | Hydra Solution |
|---|---|
| Large volumetric memory usage | Active window TSDF/ESDF |
| Continuous exploration | Incremental scene graph construction |
| Accumulated drift | Loop closure detection and graph optimization |

Hydra constructs hierarchical layers including:

- Metric-semantic mesh
- Objects
- Places
- Rooms

The place layer is generated through Generalized Voronoi Diagram (GVD)-based extraction and sparsification.

Loop closure detection and pose graph optimization allow Hydra to correct accumulated errors and maintain global consistency after revisiting previously observed areas.

Through these mechanisms, Hydra balances:

- Dense geometric reconstruction
- Semantic understanding
- Hierarchical representation
- Real-time operation

<br>
<br>

# 2. Input Data and Pre-processing

<br>
<br>

## 2.1 RGB-D Sensor Input

Hydra takes RGB-D observations as the primary input for constructing semantic 3D representations.

During reproduction, I investigated how raw sensor data is transformed into a hierarchical scene graph instead of treating Hydra as a black-box system.


<br>
<br>

### Question 1: What information does Hydra receive from the robot?

An RGB-D sensor provides:

| Input | Function |
|---|---|
| RGB image | Semantic perception and object recognition |
| Depth image | 3D geometric reconstruction |
| Camera pose | Coordinate transformation between observations |

#### How Hydra Converts Sensor Data into a 3D Scene Model


| Step | Process | Tool / Module | Explanation |
|---|---|---|---|
| 1 | Sensor input | RGB-D Camera | RGB images provide visual information, while depth images provide distance measurements for 3D reconstruction. |
| 2 | Pose estimation | Kimera-VIO | Estimates camera movement to align observations from different timestamps into a consistent coordinate frame. |
| 3 | 3D reconstruction | Kimera-Semantics / Kimera-PGMO | Combines depth information to build a consistent 3D mesh representation. |
| 4 | Semantic extraction | Semantic Segmentation + Hydra Frontend | Identifies objects and places from the reconstructed environment. |
| 5 | Scene graph construction | Hydra + SPARK-DSG | Converts the environment into a hierarchical graph of objects, places, and rooms for navigation and reasoning. |

Hydra incrementally builds the scene graph during exploration instead of waiting for complete mapping. This creates a compact representation that supports efficient navigation and room-level understanding.

#### Hydra Pipeline

```text
RGB Image + Depth Image
          |
          v
Camera Pose Estimation
(Kimera-VIO)
          |
          v
3D Reconstruction
(Depth Integration → TSDF / Mesh)
(Kimera-Semantics)
          |
          v
Semantic Understanding
(Object Detection + Segmentation)
          |
          v
Hierarchical Scene Graph
(Hydra + SPARK-DSG)
          |
          v
Objects → Places → Rooms

```

Note:
- TSDF (Truncated Signed Distance Field) is used for dense local surface reconstruction from depth measurements.
- ESDF (Euclidean Signed Distance Field) provides distance information for navigation and planning.
- They represent metric geometry, while Hydra's final output is a hierarchical semantic scene graph.


<br>
<br>


### Question 2: How are 2D images transformed into 3D representation?

Pipeline:

RGB-D Input → Camera Projection → 3D Points → TSDF/ESDF → Scene Graph

Depth measurements are converted into 3D points using:

- Depth values
- Camera intrinsic parameters
- Sensor pose

The generated geometric observations are integrated into volumetric representations:

| Representation | Function |
|---|---|
| TSDF | Surface reconstruction |
| ESDF | Distance-to-obstacle and free-space representation |

During reproduction, I investigated how raw sensor measurements are transformed from image-level information into geometric representations used by Hydra.


<br>
<br>

### Question 3: What role does previous research play in Hydra?

Hydra builds upon previous semantic mapping frameworks, especially Kimera and Voxblox.

| Component | Related Technology |
|---|---|
| TSDF integration | Voxblox / Kimera |
| ESDF generation | Voxblox |
| Semantic mapping | Previous semantic SLAM frameworks |

The main contribution of Hydra is not RGB-D processing itself, but constructing a hierarchical semantic scene graph on top of existing geometric and semantic representations.


<br>
<br>

### Question 4: How does sensor data flow through ROS2?

During reproduction, I investigated how different modules communicate through ROS2.

| Component | Function |
|---|---|
| ROS2 topics | RGB-D data transmission |
| TF system | Coordinate transformation |
| Hydra nodes | Scene graph generation |

The investigation focused on understanding how raw sensor streams are transformed into the final structured scene representation.

<br>
<br>

## 2.2 Data Processing Pipeline

Research Question:

How are RGB-D observations transformed into a hierarchical semantic scene graph?

Overall pipeline:

RGB-D Sensor Input  
↓  
3D Point Generation  
↓  
TSDF Integration  
↓  
ESDF Generation  
↓  
Active Window Management  
↓  
Scene Graph Construction

| Stage | Technique | Function |
|---|---|---|
| Depth processing | Camera projection | Convert 2D measurements into 3D points |
| Surface reconstruction | TSDF | Model observed surfaces |
| Free-space representation | ESDF | Represent obstacle distance |
| Memory optimization | Active window | Enable real-time operation |
| Semantic abstraction | Scene graph | Generate hierarchical understanding |

Compared with Kimera:

| Method | Volumetric Model |
|---|---|
| Kimera | Complete global volumetric representation |
| Hydra | Local active window around robot |

Hydra maintains only the surrounding environment within a predefined radius. Regions outside the active window are transferred into higher-level scene graph processing, reducing memory usage while supporting continuous exploration.


<br>
<br>


# 3. Hydra 3D Scene Graph Layers

Hydra represents the environment using four hierarchical layers:

| Layer | Representation |
|---|---|
| Layer 1 | Metric-semantic mesh |
| Layer 2 | Objects |
| Layer 3 | Places |
| Layer 4 | Rooms |


## 3.1 Layer 1: Metric-Semantic Mesh Reconstruction

Purpose:

Generate a geometric representation of the environment.

Pipeline:

RGB-D + Pose  
↓  
TSDF / ESDF Integration  
↓  
Marching Cubes  
↓  
Metric-Semantic Mesh

Hydra extends Kimera's reconstruction pipeline by integrating RGB-D measurements into TSDF and ESDF representations.

The metric-semantic mesh is extracted using marching cubes inside the active volumetric window.

Hydra additionally maintains relationships between mesh vertices and ESDF voxels through parent voxel association, allowing geometric surfaces to be connected with free-space information.

<br>
<br>

## 3.2 Layer 2: Object Extraction

Purpose:

Convert the semantic mesh into object-level representations.

Pipeline:

Metric-Semantic Mesh  
↓  
Semantic-Class-Based Euclidean Clustering  
↓  
Object Nodes

Hydra performs Euclidean clustering on mesh vertices belonging to the same semantic class.

| Object Node Information | Description |
|---|---|
| Semantic label | Object category |
| Centroid | Object position |
| Bounding box | Object size |
| Mesh vertices | Associated geometry |

During incremental operation:

New observation  
↓  
Object matching  
↓  
Update existing object / Create new object

If a detected object overlaps with an existing object node of the same semantic class, Hydra merges the observations. Otherwise, a new object node is created.


<br>
<br>


## 3.3 Layer 3: Place Representation

Purpose:

Represent navigable spatial regions.

Pipeline:

ESDF  
↓  
Generalized Voronoi Diagram (GVD)  
↓  
Graph Sparsification  
↓  
Place Graph

Hydra uses GVD to represent the skeleton of free space between obstacles.

| Component | Function |
|---|---|
| GVD | Free-space topology |
| Place nodes | Important locations |
| Edges | Connectivity |

Unlike approaches that extract places after complete mapping, Hydra incrementally constructs the place graph during ESDF integration.

The resulting sparse graph provides a compact representation for navigation and room detection.

<br>
<br>


## 3.4 Room Detection

Purpose:

Extract high-level spatial regions.

Pipeline:

Place Graph  
↓  
Graph Dilation  
↓  
Connected Components  
↓  
Room Segmentation

Hydra detects rooms directly from the place graph instead of relying on complete volumetric models.

The key idea is:

- Increase obstacle size through dilation
- Narrow passages such as doorways disappear
- The graph separates into connected components
- Components correspond to rooms

A graph-based community detection method assigns remaining place nodes to corresponding rooms.


<br>
<br>


# 4. Scene Graph Optimization

Purpose:

Maintain global consistency during exploration.

| Technique | Function |
|---|---|
| Loop closure detection | Identify previously visited areas |
| Pose graph optimization | Correct accumulated drift |
| Scene graph update | Maintain consistency |

When loop closures are detected, Hydra optimizes the pose graph and updates the scene graph representation.

This allows long-term exploration while maintaining a globally consistent environment model.


<br>
<br>


# 5. Visualization and Output

Final output:

| Component | Representation |
|---|---|
| Mesh | 3D geometric reconstruction |
| Objects | Semantic entities |
| Places | Navigation topology |
| Rooms | High-level spatial structure |

The final scene graph is visualized using RViz and provides structured environmental information for downstream robotic tasks such as navigation and planning.