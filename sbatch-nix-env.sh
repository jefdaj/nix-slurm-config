#!/usr/bin/env bash

#SBATCH --job-name=nix
#SBATCH --output=/global/home/users/jefdaj/nix.log
#SBATCH --time=03:00:00
#SBATCH --account=co_rosalind
#old --partition=savio2_htc
#old --qos=rosalind_htc2_normal
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --partition=savio
#SBATCH --qos=rosalind_savio_normal

[[ -z $@ ]] && (echo "usage: sbatch-nix-env.sh <nix-env args>"; exit 1)

module load gcc/4.8.1
module load glib/2.32.4

source /global/home/users/jefdaj/.nix-profile/etc/profile.d/nix.sh
export TMPDIR=/clusterfs/rosalind/users/jefdaj/nix/tmp

# this works around a nix bug. see:
#   https://github.com/NixOS/nixpkgs/issues/16769
#   https://github.com/NixOS/nix/issues/902
unset LD_LIBRARY_PATH

# sometimes downloads fail randomly, so we retry up to 10 times
for n in {1..100}; do

  echo "starting build $n"
  nix-env -j$SLURM_CPUS_PER_TASK --show-trace --keep-going $@ # && break

  # this makes it easier to edit .nixpkgs/config.nix between builds
  echo -n "next build in 10 seconds"
  for s in {1..10}; do sleep 1; echo -n "."; done; echo ""

done
