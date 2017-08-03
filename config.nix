{

  # TODO should nix itself be in here? currently in user env i think

  nix.extraOptions = ''
    # set to match slurm's --ncpus-per-task=20 and nix's -j20
    binary-caches-parallel-connections = 20
    connect-timeout = 30
  '';

  packageOverrides = pkgs: with pkgs; {

    # gnutls = pkgs.gnutls.override {
    #   guileBindings = false;
    # };

    nix = pkgs.nix.override {
      storeDir = "/clusterfs/rosalind/users/jefdaj/nix/store";
      stateDir = "/clusterfs/rosalind/users/jefdaj/nix/var";
    };

    all = with pkgs; let

      # things i packaged but haven't added to nixpkgs
      shortcut  = import /global/home/users/jefdaj/shortcut;
      # tnseq7942 = callPackage ./tnseq7942 {};

      myCustom = [
        # not sure yet:
        FEBA
        aliview
        emboss
        igvtools

        # build/dependency errors:
        # shortcut # TODO need to fix texlive URL first?
        # tnseq7942

        # working:
        clustal-omega
        kallisto
        ncbi-blast
        raxml
        trimal
        viennarna
      ];

      myMisc = [
        # not sure yet:
        ghostscript
        jdk
        libxml2
        maven
        ruby

        # working:
        rubber
        pandoc
        automake
        cmake
        curl
        git
        gnumake
        graphviz
        gzip
        htop
        less
        makeWrapper
        # nix # TODO replace the one from user env
        nix-repl
        parallel
        perl
        procps
        ranger
        readline
        tree
        unzip
        zlib
      ];

      myHaskell = [
        # build errors:
        stack

        # working:
        (haskellPackages.ghcWithPackages (hsPkgs: with hsPkgs; [
          cabal-install
        ]))
      ];

      myPython = with pythonPackages; [
        # build errors:
        # ipython
        # pillow

        # not sure yet:
        # gdata # just takes over an hour?
        wxPython
        matplotlib

        # working:
        pandas
        numpy
        biopython # one of mine!
        docopt
        pip 
        progressbar
        python
        scipy
        tkinter
        virtualenv
      ];  

      myR = with rPackages; [
        # build errors:
        # AnnotationDBI

        # not sure yet:
        R
        edgeR
        ggtree
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
        ggplot2
        ggrepel
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
  
    in buildEnv {
      name = "all";
      paths = myCustom ++ myHaskell ++ myMisc ++ myPython ++ myR;
    };
  };

}
