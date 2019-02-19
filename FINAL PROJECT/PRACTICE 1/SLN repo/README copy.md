# time-tracker
Java (Maven) application for tracking time on the job.

## Purpose

This purpose of this project is to show how to use Maven and Jenkins together.

## Added

yaml file for Ansible deployment,
jenkins file with full pipeline

## Prerequisites

1. Install Maven on node where you run Jenkins pipeline.
2. Jenkins > Configure Jenkins > Global Tools > Maven Name M3, check Install automatically
3. Docker by default runs as root, so if running docker commands from Jenkins (with user jenkins) it fails on unsufficient permissions. Do some magic
