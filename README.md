nix-slurm-config
================

This is my [Nix][1] config for use with the [Berkeley High-Performance compute
cluster][2]. I mainly made the repo so I don't forget how it works, but also as
an example of how to run Nix on [SLURM][3] cluster. Hopefully it's useful! I
haven't made much of an attempt to generalize it, so you'll need to hard-code
your own paths.

Install
-------

First, you might as well clone/fork your own copy of [nixpkgs][5] now, because
a non-root install is unable to use the binary cache. I still use [the
nixpgs-unstable channel branch][6] instead of `master` though, for stability.
That may not be necessary.

Either create your own `~/.nixpkgs/config.nix` or symlink/copy the one in this
repo and edit it.

Next, use [nix-no-root][4] to install Nix in the directory of your choice. I
used `/clusterfs/rosalind/users/jefdaj/nix`. Think about this beforehand,
because changing it will mean recompiling everything! You'll need to set it in
your `config.nix` too.

Once it finishes, add something like this to your `.bashrc`:

    # Ensures consistent versions across nodes. May not be needed?
    module load gcc/4.8.5
    module load glib/2.32.4

    # Use your nixpkgs clone for everything
    export NIX_PATH=nixpkgs=/global/home/users/jefdaj/nixpkgs
    source $HOME/.nix-profile/etc/profile.d/nix.sh

    # This works around a Nix bug. Does it break anything else?
    unset LD_LIBRARY_PATH

The last step is to symlink `~/.nix-profile` to the default profile dir, which
in my case was `/clusterfs/rosalind/users/jefdaj/nix/var/nix/profiles/default`.

Run commands
------------

After sourcing your `.bashrc` you should be able to run `nix-env` to check that
everything works. Modify the included scripts to run longer SLURM jobs.

Random tips
-----------

I only use `nix-env -i` to test installing new packages. Then if they work I
`--uninstall` them, add them to the `all` package in `config.nix`, and re-run
`sbatch-nix-env.sh`. That way I only have two packages permanently installed:
`nix` and `all`.

To prevent corrupting the Nix database:

* Make regular backups in case of power outages or similar.
  I go into the nix install dir occasionally and run `tar -cvf var_$(date '+%Y-%m-%d').tar var`.

* Only run one instance of Nix at a time, even if you have lots of machines available.
  Set `-j` to the number of cores as you want, but stick to one node.
  (Email me if you figure out how to distribute over more than one!)

[1]: https://nixos.org/nix
[2]: http://research-it.berkeley.edu/services/high-performance-computing/cgrl-vectorrosalind-user-guide
[3]: https://slurm.schedmd.com
[4]: https://github.com/jefdaj/nix-no-root
[5]: https://github.com/nixos/nixpkgs
[6]: https://github.com/NixOS/nixpkgs-channels/tree/nixpkgs-unstable
