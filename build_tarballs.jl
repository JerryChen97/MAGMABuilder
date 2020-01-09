using BinaryBuilder

# Collection of sources required to build Nettle
name = "MAGMA"
version = v"2.5.2"
sources = [
    "https://github.com/Roger-luo/MAGMA/archive/v2.5.2.tar.gz" =>
#    "ce32c199131515336b30c92a907effe0c441ebc5c5bdb255e4b06b2508de109f", #the sha256 need to be found
#    "./bundled",
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/MAGMA
export CUDADIR="${prefix}"
export OPENBLASDIR="${prefix}"
make lib -j${nproc}
make install -j${nproc}
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:x86_64),
    Windows(:x86_64),
    MacOS(:x86_64),
]
platforms = expand_gcc_versions(platforms)

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libmagma", :libmagma),
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/JuliaPackaging/Yggdrasil/releases/download/CUDA-v10.1.168%2B2/build_CUDA.v10.1.168.jl",
    "https://github.com/JuliaPackaging/Yggdrasil/releases/download/OpenBLAS-v0.3.5-1/build_OpenBLAS.v0.3.5.jl",
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
