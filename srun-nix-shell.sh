#!/usr/bin/env bash

srun \
  --job-name nixsh --time=00:01:00 \
  --account=co_rosalind --partition=savio --qos=rosalind_savio_normal \
  --ntasks=1 --cpus-per-task=20 \
  --pty bash -i
