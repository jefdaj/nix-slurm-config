{
  nix.extraOptions = ''
    # set to match slurm's --ncpus-per-task=20 and nix's -j20
    binary-caches-parallel-connections = 20
    connect-timeout = 30
  '';

  packageOverrides = pkgs: with pkgs; {

    nix = pkgs.nix.override {
      stateDir = "/clusterfs/rosalind/users/jefdaj/nix/var";
      storeDir = "/clusterfs/rosalind/users/jefdaj/nix/store";
    };

    all = let

      myNix = with pkgs; [
        # Note: nix itself is installed separately with `nix-env -i`
        # cabal2nix
        # nix-prefetch-hg
        # nix-prefetch-scripts
        makeWrapper
        nix-generate-from-cpan
        nix-prefetch-bzr
        nix-prefetch-cvs
        nix-prefetch-git
        nix-prefetch-svn
        nix-repl
      ];

      # biology stuff, most of which i wrote or packaged
      shortcut  = import /global/home/users/jefdaj/shortcut;
      tnseq7942 = import /global/home/users/jefdaj/tnseq7942;
      myBio = with pkgs; [
        # aliview # can't find file
        # tnseq7942
        FEBA
        clustal-omega
        emboss
        igvtools
        kallisto
        ncbi-blast
        raxml
        shortcut
        trimal
        viennarna
      ];

      myHaskell = with pkgs; [
        # gitAndTools.gitAnnex
        pandoc
        stack
        (haskellPackages.ghcWithPackages (hsPkgs: with hsPkgs; [
          cabal-install
          # TODO yesod-bin?
        ]))
      ];

      myMisc = with pkgs; [
        automake
        cmake
        curl
        fontconfig
        git # should this be part of gitAndTools?
        gnumake
        graphviz
        gzip
        htop
        less
        libxml2
        maven   # TODO myJava?
        openjdk # TODO myJava?
        parallel
        perl
        procps
        ranger
        readline
        rsync
        ruby
        tree
        unzip
        zlib
      ];

      myPython = with pkgs.pythonPackages; [
        # ipython
        # pillow
        # wxPython
        biopython # one of mine!
        docopt
        gdata # just takes over an hour?
        matplotlib
        numpy
        pandas
        pip 
        progressbar
        python
        scipy
        tkinter
        virtualenv
      ];  

      myR = with pkgs.rPackages; [
        R
        AnnotationDbi
        Biobase
        BiocInstaller
        IRanges
        ape
        biomartr
        data_table
        devtools
        directlabels
        docopt
        dplyr
        edgeR
        ggplot2
        ggrepel
        ggtree
        gridExtra
        locfit
        mgcv
        optparse
        phangorn
        primerTree
        reshape2
        tidyr
        xml2
      ];

      # TODO add dependencies for dissertation? or is that separate?
      myTex = with pkgs; [
        ghostscript
        rubber
        (texlive.combine {
          inherit (texlive) scheme-small;
        })
      ];
  
    in buildEnv {
      name = "all";
      paths = myNix ++ myBio ++ myHaskell ++ myMisc ++ myPython
                    ++ myR ++ myTex;
    };
  };
}
