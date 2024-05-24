#!/bin/bash

# Navigate to the VLC source directory
cd /vlc-build

# Prepare the 3rd party libraries
cd contrib/win32 && \
   ../bootstrap --host=i686-w64-mingw32 && \
   make prebuilt

# Configure VLC for Windows 32-bit compilation
cd - && \
   ./bootstrap && \
   mkdir win32 && cd win32 && \
   ../extras/package/win32/configure.sh --host=i686-w64-mingw32 --build=x86_64-pc-linux-gnu

# Build VLC
make package-win-common

# Keep the container running (if needed)
exec "$@"
