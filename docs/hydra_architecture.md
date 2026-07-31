# Hydra System Architecture



## 1. Overview: Motivation Behind Hydra

Before reproducing Hydra, I investigated the development of robotic environment representations and the limitations that motivated semantic 3D scene graph generation.


### Question 1: How did traditional robotic mapping represent environments?

Traditional robotic mapping methods mainly focused on metric representations, including volumetric models, point clouds, and 3D meshes.

These approaches provide accurate geometric information for reconstruction, localization, and navigation. However, they mainly represent low-level spatial structures and do not explicitly model higher-level semantic information, such as objects, rooms, and spatial relationships.

Therefore, dense geometric maps alone are insufficient for semantic reasoning and high-level robot decision-making.

### Question 2: Why are object-based representations insufficient?

Object-based mapping approaches represent environments using detected objects and their relationships.

Compared with dense geometric maps, object-based representations provide semantic information. However, they usually lack detailed geometric structures required for precise navigation, manipulation, and spatial understanding.

This creates a fundamental trade-off between:

- Dense representations: accurate geometry but limited semantic abstraction
- Object-based representations: semantic understanding but limited geometric information

### Question 3: Why are hierarchical 3D scene graphs introduced?

Hierarchical representations aim to combine metric and semantic information by organizing the environment at multiple abstraction levels.

A 3D scene graph represents the environment using different layers:

- Metric-semantic mesh: low-level geometric representation
- Objects: semantic entities extracted from the environment
- Places: topological representation of navigable regions
- Rooms: high-level spatial organization

This hierarchical structure enables robots to perform both geometric reasoning and semantic understanding within a unified representation.

### Question 4: What limitations existed in previous scene graph approaches?

Previous 3D scene graph methods demonstrated the potential of hierarchical representations, but many approaches were designed for offline operation.

These methods typically required constructing a complete environment model before performing higher-level reasoning and optimization. Although they achieved rich scene understanding, the computational and memory requirements limited their application to real-time robotic exploration.

Therefore, the key challenge was achieving:

- Hierarchical semantic representation
- Real-time incremental construction
- Computational efficiency
- Global consistency after exploration

### Question 5: How does Hydra address these limitations?

Hydra introduces a real-time incremental framework for semantic 3D scene graph generation.

Instead of maintaining a complete global volumetric model, Hydra uses a spatially bounded active window to maintain TSDF and ESDF representations around the robot. This reduces memory consumption while supporting continuous scene graph updates during exploration.

Hydra incrementally constructs multiple scene graph layers, including metric-semantic mesh, objects, places, and rooms. The place layer is generated through Generalized Voronoi Diagram (GVD)-based incremental extraction and sparsification.

To maintain global consistency, Hydra integrates loop closure detection and graph optimization. The optimized pose graph is used to correct accumulated drift and update the scene graph after revisiting previously observed areas.

Through these mechanisms, Hydra achieves a balance between:

- Dense geometric reconstruction
- Semantic understanding
- Hierarchical scene representation
- Real-time robotic operation




## 2. Input Data and Pre-processing


## 2.1 RGB-D Sensor Input

Hydra takes RGB-D observations as the primary input for constructing a semantic 3D representation of the environment. During the reproduction process, I investigated how raw sensor data is transformed into a hierarchical semantic scene graph through several key questions.

### Question 1: What information does Hydra receive from the robot?

An RGB-D sensor provides three main types of information: RGB images, depth measurements, and camera poses.

RGB images provide visual information for semantic understanding, such as identifying object categories. Depth images provide distance measurements between the camera and the environment, allowing the system to recover 3D geometric structures. Camera poses describe the position and orientation of the sensor, enabling observations from different timestamps to be aligned into a consistent coordinate system.

### Question 2: How are 2D images transformed into a 3D representation?

I investigated how Hydra converts raw depth observations into a geometric representation of the environment. By combining depth measurements with camera intrinsic parameters and pose information, individual pixels can be projected into 3D points.

These measurements are integrated into volumetric representations such as the Truncated Signed Distance Field (TSDF) and Euclidean Signed Distance Field (ESDF), which are used for mesh reconstruction and spatial understanding.

### Question 3: What role does previous research play in Hydra?

The RGB-D processing and volumetric reconstruction pipeline are not introduced by Hydra itself. Hydra builds upon previous semantic mapping frameworks, particularly Kimera, which provides methods for TSDF/ESDF-based reconstruction.

Through studying Hydra, I found that the main contribution of Hydra is not converting raw sensor data into 3D geometry, but building a higher-level hierarchical scene graph on top of these geometric and semantic representations.

### Question 4: How does sensor data flow through the ROS2 system?

During the reproduction process, I investigated the software implementation of this pipeline through ROS2 communication. This included understanding how image data is transmitted through ROS2 topics, how camera poses are provided through TF transformations, and how different modules interact to transform sensor observations into the final scene graph.




## 2.2 Data Processing Pipeline

### Research Question: How are raw RGB-D observations transformed into a hierarchical semantic scene graph?

During the reproduction process, I was interested in understanding the complete transformation pipeline from low-level sensor measurements to high-level scene understanding. Instead of treating Hydra as a black-box system, I investigated how each intermediate representation is generated, what tools are involved, and how geometric information is progressively converted into semantic and hierarchical representations.

The RGB-D input is processed through multiple stages before generating the final hierarchical scene graph.

### Step 1: RGB-D Data Acquisition

Input:

- RGB images
- Depth images
- Camera poses

Tools:

- ROS 2 topics (`sensor_msgs/Image`)
- TF transformation system

Function:

RGB-D observations are collected from the robot sensor and synchronized with camera poses to provide both visual and geometric information.

During reproduction, I investigated how sensor data is transmitted through ROS2 communication and how coordinate transformations are handled before entering the perception pipeline.

↓

### Step 2: Depth Projection and Point Cloud Generation

Input:

- Depth image
- Camera intrinsic parameters

Tools:

- Camera projection model
- Image processing libraries

Function:

Depth pixels are projected into 3D points using camera calibration parameters:

3D point = Depth × Camera Intrinsic Parameters

The generated point cloud provides the geometric observations required for volumetric reconstruction.

I investigated how 2D sensor measurements are transformed into 3D geometric information, forming the connection between visual perception and spatial reconstruction.

↓

### Step 3: TSDF Integration

Input:

- 3D point cloud
- Camera poses

Tools:

- Voxblox-based volumetric mapping
- TSDF representation

Function:

Depth observations from multiple viewpoints are integrated into a Truncated Signed Distance Field (TSDF).

TSDF represents the distance between voxel locations and observed surfaces, allowing continuous surface reconstruction.

This stage is inherited from previous semantic mapping frameworks such as Kimera and forms the geometric foundation for Hydra's scene graph generation.

↓

### Step 4: ESDF Generation

Input:

- TSDF

Tools:

- Voxblox ESDF integration

Function:

The TSDF is converted into an Euclidean Signed Distance Field (ESDF).

ESDF stores the distance from each voxel to the nearest obstacle and provides free-space information for navigation and place extraction.

I investigated how volumetric representations are not only used for reconstruction, but also provide structural information for higher-level scene understanding.

↓

### Step 5: Active Window Management

Input:

- TSDF
- ESDF

Tool:

- Hydra active window mechanism

Function:

Unlike Kimera, which maintains a complete volumetric model, Hydra limits volumetric reconstruction to a local region around the robot.

Only the surrounding area within a predefined radius is maintained, reducing memory consumption and enabling real-time operation.

This design choice represents one of Hydra's key contributions: balancing detailed geometric reconstruction with computational efficiency during exploration.

↓

### Step 6: Scene Graph Layer Extraction

Input:

- Metric-semantic mesh
- ESDF
- Semantic information

Tool:

- Hydra scene graph frontend

Function:

The local geometric representation is converted into hierarchical scene graph layers:

Layer 1:
Metric-semantic mesh

Layer 2:
Objects

Layer 3:
Places

Layer 4:
Rooms

Through this pipeline, Hydra transforms raw RGB-D sensor observations into a structured representation that combines geometry, semantics, and spatial hierarchy.



## 3. Hydra 3D Scene Graph Layers

Hydra represents the environment using four hierarchical layers:

Layer 1:
Metric-semantic mesh

Layer 2:
Objects

Layer 3:
Places

Layer 4:
Rooms


## 3.1 Layer 1: Metric-Semantic Mesh Reconstruction

The first layer represents the geometric structure of the environment.

Hydra extends Kimera's mesh reconstruction pipeline by integrating RGB-D measurements into TSDF and ESDF representations.

Using the active volumetric window, Hydra extracts a 3D metric-semantic mesh using the marching cubes algorithm.

An additional modification is introduced to maintain relationships between mesh vertices and ESDF voxels. Surface voxels are tracked as parent voxels, allowing later association between free-space regions and reconstructed surfaces.


## 3.2 Layer 2: Object Extraction

The object layer is generated by clustering semantic mesh vertices.

Hydra performs Euclidean clustering separately for each semantic class. For example, vertices classified as chairs or tables are clustered independently.

Each cluster is represented as an object node containing:

- semantic label
- centroid position
- bounding box
- associated mesh vertices

During incremental operation:

If a newly detected object overlaps with an existing object node of the same semantic class, Hydra merges the observations.

Otherwise, a new object node is created.


## 3.3 Layer 3: Place Representation

The place layer represents navigable spatial regions.

Instead of extracting places from a complete ESDF after mapping, Hydra incrementally constructs the place graph during ESDF integration.

Hydra uses the Generalized Voronoi Diagram (GVD), which represents the skeleton of free space between obstacles.

The GVD is sparsified into a graph containing:

- place nodes
- connectivity edges

This provides a compact representation of the environment topology for later room detection and optimization.


## 3.4 Layer 4: Room Detection

The room layer represents high-level semantic regions.

Unlike Kimera, which relies on full volumetric representations and assumptions about room geometry, Hydra detects rooms directly from the place graph.

Hydra applies dilation operations to the environment representation. As obstacles are expanded, narrow connections such as doorways disappear, causing the place graph to separate into connected components.

These connected components are interpreted as rooms.

A graph-based community detection method is then applied to assign remaining place nodes to corresponding rooms.


## 4. Scene Graph Optimization

Hydra performs optimization to maintain global consistency.

When loop closures are detected, previously observed areas can be aligned and the scene graph can be corrected.

This allows Hydra to reduce accumulated errors during long-term exploration and maintain a globally consistent representation.


## 5. Visualization and Output

The final output is a hierarchical 3D scene graph containing:

- reconstructed mesh
- semantic objects
- place connectivity
- room structure

The scene graph can be visualized using RViz and used for downstream robotic tasks such as navigation and planning.