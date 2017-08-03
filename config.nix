{
  nix.extraOptions = ''
    # set to match slurm's --ncpus-per-task=20 and nix's -j20
    binary-caches-parallel-connections = 20
    connect-timeout = 30
  '';

  packageOverrides = pkgs: with pkgs; {

    nix = pkgs.nix.override {
      storeDir = "/clusterfs/rosalind/users/jefdaj/nix/store";
      stateDir = "/clusterfs/rosalind/users/jefdaj/nix/var";
    };

    all = let

      myNix = with pkgs; [
        # TODO why does this need to be duplicated here??
        (pkgs.nix.override {
          storeDir = "/clusterfs/rosalind/users/jefdaj/nix/store";
          stateDir = "/clusterfs/rosalind/users/jefdaj/nix/var";
        })
        nix-repl
        makeWrapper
      ];

      # biology stuff, most of which i wrote or packaged
      shortcut  = import /global/home/users/jefdaj/shortcut;
      tnseq7942 = import /global/home/users/jefdaj/tnseq7942;
      myBio = with pkgs; [
        # broken:
        # aliview # can't find file
        # shortcut
        # tnseq7942

        # working:
        FEBA
        clustal-omega
        emboss
        igvtools
        kallisto
        ncbi-blast
        raxml
        trimal
        viennarna
      ];

      myMisc = with pkgs; [
        ghostscript
        jdk
        libxml2
        maven
        ruby
        automake
        cmake
        curl
        git
        gnumake
        graphviz
        gzip
        htop
        less
        parallel
        perl
        procps
        ranger
        readline
        tree
        unzip
        zlib
      ];

      myHaskell = with pkgs; [
        # broken:
        # stack

        # working:
        pandoc
        (haskellPackages.ghcWithPackages (hsPkgs: with hsPkgs; [
          cabal-install
        ]))
      ];

      myPython = with pkgs.pythonPackages; [
        # build errors:
        # gdata # just takes over an hour?
        # ipython
        # pillow
        # wxPython

        # working:
        biopython # one of mine!
        docopt
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

      myTex = with pkgs; [
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
