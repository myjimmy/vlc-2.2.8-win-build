# vlc-2.2.8-win-build
This project provides a method to build the vlc 2.2.8 for Windows on Ubuntu 16.04.<br/>
Also, it provides the `Dockerfile` as well.<br/>
For more detail, please refer to https://wiki.videolan.org/Win32Compile/.

## Source code
The source code came from http://download.videolan.org/pub/videolan/vlc/2.2.8/vlc-2.2.8.tar.xz.

## The 3rd party libraries (External packages)
Most of external packages were manually downloaded from https://download.videolan.org/contrib/.<br/>
All the external packages are located in the `vlc-2.2.8/tarballs` path.<br/>

*Please note that the `qt-4.8.5.tar.gz` package was split into several files (`qt-4.8.5.tar.gz.00*`) due to the limitation of the large file at GitHub.<br/>
So, when following the **[Manually built (slow)](#manually-built-slow)** step,  first of all , you SHOULD run the following shell script file to merge them to the `qt-4.8.5.tar.gz` file:*
```
$ cd vlc-2.2.8/contrib/tarballs
$ cd ./qt-4.8.5-merge.sh
```

## Compiler and binary toolchain
### Mingw-w64
To compile VLC for Windows (32-bits or 64-bits), the Mingw-w64 toolchain is required.<br/>
For the 32-bit version, run this:
```
$ sudo apt-get install gcc-mingw-w64-i686 g++-mingw-w64-i686
```

For the 64-bit version, this becomes:
```
$ sudo apt-get install gcc-mingw-w64-x86-64 g++-mingw-w64-x86-64 mingw-w64-tools
```

### Development tools
Please install the following tools:
```
$ sudo apt-get install autoconf libtool
```

## Prepare the 3rd party libraries (external packages)
### Prebuilt (fast)
```
$ cd vlc-2.2.8
$ cd contrib/win32
$ ../bootstrap --host=HOST-TRIPLET
$ make prebuilt
```
Please make sure that you replace the keyword `HOST-TRIPLET` with either of the following values adapted to your target Windows version (32-bit or 64-bit, respectively):
* `i686-w64-mingw32` for Windows 32-bits, using the Mingw-w64 toolchain
* `x86_64-w64-mingw32` for Windows 64-bits, using the Mingw-w64 toolchain

Each prebuilt zip file for the target Windows version is located in the `vlc-2.2.8/contrib/win32` sub-folder.<br/>
Those prebuilt zip files follow as below:
* **32-bit**<br/>
  zip file: `vlc-contrib-i686-w64-mingw32-latest.tar.bz2`<br/>
  download URL: ftp://ftp.videolan.org/pub/videolan/contrib/i686-w64-mingw32/vlc-contrib-i686-w64-mingw32-latest.tar.bz2
* **64-bit**<br/>
  zip file: `vlc-contrib-x86_64-w64-mingw32-latest.tar.bz2`<br/>
  download URL: ftp://ftp.videolan.org/pub/videolan/contrib/x86_64-w64-mingw32/vlc-contrib-x86_64-w64-mingw32-latest.tar.bz2

### Manually built (slow)
Or, if you want to compile the 3rd party libraries yourself and are feeling adventurous and have lots of time to burn:
```
$ sudo apt-get install subversion yasm cvs cmake ragel autopoint
$ cd vlc-2.2.8
$ mkdir -p contrib/win32
$ cd contrib/win32
$ ../bootstrap --host=HOST-TRIPLET
$ make fetch
$ make
```

### Linux 64-bit
If you are on Linux **64-bit** and build the vlc for the Windows 64-bit version, you **SHOULD** remove the following files:
```
$ rm -f ../i686-w64-mingw32/bin/moc ../i686-w64-mingw32/bin/uic ../i686-w64-mingw32/bin/rcc
```

### Go Back
Go back to the VLC source directory (`vlc-2.2.8`):
```
$ cd -
```
or
```
$ cd ../..
```

## Configuring the build
### Bootstrap
First, prepare the tree:
```
$ ./bootstrap
```

### Configure
Then you can to configure the build with the `./configure` script.<br/>
Please create a subfolder:
```
$ mkdir win32 && cd win32
```

Execute the build configuration script:
```
$ ../extras/package/win32/configure.sh --host=HOST-TRIPLET --build=x86_64-pc-linux-gnu
```

Alternatively, you can run configure manually:
```
$ ../configure --host=HOST-TRIPLET --build=x86_64-pc-linux-gnu
```
See `../configure --help` for more information.

## Building VLC
Once configured, to build VLC, just run:
```
$ make
```

## Packaging VLC
Once the compilation is done, you can build self-contained VLC packages with the following make rules:
| Command                 | Description |
| ----------------------- | ----------- |
| make package-win-common | Creates a subdirectory named `vlc-x.x.x` with all the binaries. You can run VLC directly from this directory. |
| make package-win-strip  | Same as above but will create 'stripped' binaries (that is, smallest size, unusable with a debugger). |
| make package-win32-7zip | Same as above but will package the directory in a 7z file. |
| make package-win32-zip  | Same as above but will package the directory in a zip file. |
| make package-win32      | Same as above but will also create an auto-installer package. You must have `NSIS` installed in its default location for this to work. |

**But, this projects supports ONLY `make package-win-common` rule.**<br/>

## Test result
The build instructions described here are *successfully* tested on the following environment:
* Target App: `Windows 32-bit`
* Host OS for building: `Ubuntu 16.04.7 LTS (64-bit)`

***Well done—you're ready to use VLC!***
