with import <nixpkgs> {}; {
    vitanimEnv = stdenv.mkDerivation {
        name = "vitanim-env";
        buildInputs = [ stdenv
                        gcc
                        SDL2
                        pkgconfig
                        freetype
                        libGLU
                        nim
                      ];
        LD_LIBRARY_PATH="${SDL2}/lib;${libGLU}/lib";
    };
}
