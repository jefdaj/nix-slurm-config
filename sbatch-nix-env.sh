#!/usr/bin/env bash

#SBATCH --job-name=nix
#SBATCH --output=/global/home/users/jefdaj/nix.log
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --time=00:30:00
#SBATCH --account=co_rosalind
#SBATCH --partition=savio
#SBATCH --qos=rosalind_savio_normal

module load gcc/4.8.1
module load glib/2.32.4

source /global/home/users/jefdaj/.nix-profile/etc/profile.d/nix.sh
export TMPDIR=/clusterfs/rosalind/users/jefdaj/nix/tmp

# this works around a nix bug. see:
#   https://github.com/NixOS/nixpkgs/issues/16769
#   https://github.com/NixOS/nix/issues/902
unset LD_LIBRARY_PATH

# sometimes downloads fail randomly, so we retry up to 10 times
for n in {1..10}; do

  # this makes it easier to edit .nixpkgs/config.nix between builds
  echo -n "next build in 10 seconds"
  for s in {1..10}; do
    sleep 1; echo -n "."
  done
  echo ""

  # TODO break after one success, except not yet because editing config
  nix-env -j6 -i all --show-trace --keep-going # && break
done
