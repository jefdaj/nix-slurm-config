#! /bin/sh

#SBATCH --job-name=nix
#SBATCH --output=/global/home/users/jefdaj/nix.log
#SBATCH --time=01:00:00
#SBATCH --account=co_rosalind
#SBATCH --partition=savio2_htc
#SBATCH --qos=rosalind_htc2_normal
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12

module load gcc/4.8.1
module load glib/2.32.4
export TMPDIR=/clusterfs/rosalind/users/jefdaj/nix/tmp

# this works around a nix bug. see:
#   https://github.com/NixOS/nixpkgs/issues/16769
#   https://github.com/NixOS/nix/issues/902
# unset LD_LIBRARY_PATH

# retry a few times to get around any failed downloads
for n in {1..10}; do

  # Need to clone my nix-no-root repo before running this
  /global/home/users/jefdaj/nix-no-root/nix-no-root.sh \
    /clusterfs/rosalind/users/jefdaj/nix-boot \
    /clusterfs/rosalind/users/jefdaj/nix -j$SLURM_CPUS_PER_TASK && break

  sleep 10

done
