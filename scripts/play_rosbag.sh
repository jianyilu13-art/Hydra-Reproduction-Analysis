#!/bin/bash

ros2 bag play ~/datasets/uhumans2/uHumans2_office_s1_00h_v2 \
--clock \
--qos-profile-overrides-path ~/.tf_overrides.yaml