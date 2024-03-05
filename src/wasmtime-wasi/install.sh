#!/usr/bin/env bash
set -e

WASI_VERSION="${VERSION:-"21"}"
WASI_VERSION_FULL="${WASI_VERSION}.0"
WIT_VERSION="${WIT_VERSION:-"0.18.0"}"
WASMTIME_VERSION="${WASMTIME_VERSION:-"v18.0.2"}"
WASM_TOOLS_VERSION="${WASM_TOOLS_VERSION:-"1.200.0"}"
WASI_LOCATION="${LOCATION:-"/usr/local"}/lib"
MAKE_VERSION="4.4"

# TODO: Support Windows someday?
FILE="wasi-sdk-${WASI_VERSION_FULL}-linux.tar.gz"

# Maybe install curl
which curl > /dev/null || (apt update -y && apt install curl -y -qq)

# Maybe install xz
which xz > /dev/null || (apt update -y && apt install xz-utils -y -qq)

apt install -y -qq libc6

# Install wasmtime
INSTALLER=./wasmtime-install.sh
curl https://wasmtime.dev/install.sh -L --output ${INSTALLER}
chmod a+x ${INSTALLER}
${INSTALLER} --version ${WASMTIME_VERSION}
cp ${HOME}/.wasmtime/bin/wasmtime /usr/bin/wasmtime

# Install wasi-sdk
curl https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-${WASI_VERSION}/${FILE} -L --output ${FILE}

# Install to location
tar -C ${WASI_LOCATION} -xvf ${FILE}
rm ${FILE}

# Install wit-bindgen
curl https://github.com/bytecodealliance/wit-bindgen/releases/download/v${WIT_VERSION}/wit-bindgen-${WIT_VERSION}-x86_64-linux.tar.gz -L --output wit-bindgen-${WIT_VERSION}-x86_64-linux.tar.gz

# Install to location
tar -xvzf wit-bindgen-${WIT_VERSION}-x86_64-linux.tar.gz
cp wit-bindgen-${WIT_VERSION}-x86_64-linux/wit-bindgen ${LOCATION}/bin/wit-bindgen
rm -r wit-bindgen-${WIT_VERSION}-x86_64-linux*

# Install wasm-tools
curl https://github.com/bytecodealliance/wasm-tools/releases/download/wasm-tools-${WASM_TOOLS_VERSION}/wasm-tools-${WASM_TOOLS_VERSION}-x86_64-linux.tar.gz -L --output wasm-tools-${WASM_TOOLS_VERSION}-x86_64-linux.tar.gz

# Install to location
tar -xvzf wasm-tools-${WASM_TOOLS_VERSION}-x86_64-linux.tar.gz
cp wasm-tools-${WASM_TOOLS_VERSION}-x86_64-linux/wasm-tools ${LOCATION}/bin/wasm-tools
rm -r wasm-tools-${WASM_TOOLS_VERSION}-x86_64-linux*

# Install make
curl http://ftp.gnu.org/gnu/make/make-4.4.tar.gz -L --output make-${MAKE_VERSION}.tar.gz

# Install to location
tar -xvf make-${MAKE_VERSION}.tar.gz 
cd make-${MAKE_VERSION}/
./configure --prefix=/usr/bin  # Or your preferred place
make
make install

