# System Configuration

## Hardware

| Component | Specification |
|---|---|
| CPU | Intel i7-13650HX |
| GPU | NVIDIA GeForce RTX 5060 |
| RAM | 23 GB |

---

## Operating System

Ubuntu:


Ubuntu 24.04.3 LTS


---

## GPU Environment

NVIDIA Driver:


580.95.05


CUDA:


13.0


---

## Purpose

This file records the hardware environment used for Hydra reproduction.

The hardware information is important because Hydra performs:

- 3D reconstruction
- TSDF/ESDF processing
- semantic inference
- scene graph generation

which can be affected by GPU memory and computing resources.