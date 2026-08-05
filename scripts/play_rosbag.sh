#!/bin/bash

ros2 bag play ~/datasets/uhumans2/office \
--clock \
--qos-profile-overrides-path ~/.tf_overrides.yaml