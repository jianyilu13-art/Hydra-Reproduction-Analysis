# Parameter Analysis

## Objective

This document investigates important Hydra parameters and their influence on reconstruction and scene graph generation.

---

# Active Window

## Function

The active window defines the local region currently processed by Hydra.

## Related Module

Frontend / Reconstruction

## Expected Influence

Increasing the active window size may:

- increase memory usage,
- increase computation time,
- improve local consistency.

Reducing the active window may:

- reduce computational cost,
- decrease reconstruction context.

---

# Semantic Inference

## Function

Controls whether semantic information is generated and integrated into the scene graph.

## Related Module

Semantic inference / Frontend

## Expected Influence

Changing this parameter affects:

- object recognition,
- semantic labels,
- scene graph richness.

---

# Loop Closure

## Function

Controls detection and optimization of previously visited locations.

## Related Module

Backend / LCD

## Expected Influence

Changing this parameter affects:

- global map consistency,
- trajectory optimization,
- large-scale reconstruction quality.

---

# Label Space

## Function

Defines the semantic categories available to Hydra.

## Related Files


hydra/config/label_spaces/


## Expected Influence

Different label spaces affect:

- object categories,
- semantic nodes,
- hierarchical scene graph interpretation.

---

# Visualization

## Function

Controls RViz display settings.

## Related Files


hydra_visualizer/config/


## Expected Influence

Affects:

- displayed markers,
- visualization layers.

Does not directly affect reconstruction.