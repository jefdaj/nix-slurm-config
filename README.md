nix-slurm-config
================

This is my [Nix][1] config for use with the [Berkeley High-Performance compute
cluster][2]. I mainly made the repo so I don't forget how it works, but also as
an example of how to run Nix on a cluster with [SLURM][3]. Hopefully it's
useful! I haven't made much of an attempt to generalize it though, so you'll
need to hard-code your own paths.

Install
-------

First, you might as well clone/fork your own copy of [nixpkgs][5] now, because
a non-root install is unable to use the binary cache. I still use [the
nixpgs-unstable channel branch][6] instead of `master` though, for stability.

Either create `~/.nixpkgs/config.nix` or symlink it to the one in this repo.

Next, use [nix-no-root][4] to bootstrap Nix in the install directory of your
choice. I used `/clusterfs/rosalind/users/jefdaj/nix`. Think about this
beforehand, because changing it will mean recompiling everything! You'll need
to set it in your `config.nix` too.

Finally, add something like this to your `.bashrc`:

    # May not be needed?
    module load gcc/4.8.5
    module load glib/2.32.4

    # Use your nixpkgs clone only
    export NIX_PATH=nixpkgs=/global/home/users/jefdaj/nixpkgs
    source $HOME/.nix-profile/etc/profile.d/nix.sh

    # This works around a Nix bug. Does it break anything else?
    unset LD_LIBRARY_PATH

Run commands
------------

After sourcing your `.bashrc` you should be able to run `nix-env` to check that
everything works on your login node. Modify the included scripts to run SLURM
jobs elsewhere.

Random tips
-----------

I like to do all my package management by editing the `all` package in
`config.nix` and re-running `sbatch-nix-env.sh` (so no manual `nix-env -i`).

To prevent corrupting the Nix database:

* Make regular backups in case of power outages or similar

* Only run one instance of Nix at a time, even if you have lots of machines available.
  Set `-j` to the number of cores as you want, but stick to one node.
  (Email me if you figure out how to distribute over more than one!)

[1]: https://nixos.org/nix
[2]: http://research-it.berkeley.edu/services/high-performance-computing
[3]: https://slurm.schedmd.com
[4]: https://github.com/jefdaj/nix-no-root
[5]: https://github.com/nixos/nixpkgs
[6]: https://github.com/NixOS/nixpkgs-channels/tree/nixpkgs-unstable
