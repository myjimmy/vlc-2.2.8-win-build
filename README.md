# vlc-2.2.8-win-build
This project provides a method to build the vlc 2.2.8 for Windows.<br/>
Also, it provides the `Dockerfile` as well.<br/>
For more detail, please refer to https://wiki.videolan.org/Win32Compile/.

## Source code
The source code came from http://download.videolan.org/pub/videolan/vlc/2.2.8/vlc-2.2.8.tar.xz.

## The 3rd party libraries (External packages)
The external packages were manually downloaded from https://download.videolan.org/contrib/.<br/>
Those packages are located in the `vlc-2.2.0-git/tarballs` path.<br/>
*Please note that the following some external packages are chosen from one among several possible URLs:*
- contrib/src/x264<br/>
  x264-git.tar.bz2: https://download.videolan.org/x264/snapshots/x264-snapshot-20140614-2245-stable.tar.bz2

<br/>

## Compiler and binary toolchain
### Mingw-w64
To compile VLC for Windows (32-bits or 64-bits), the Mingw-w64 toolchain is required.<br/>
For the 32-bit version, run this:
```
$ sudo apt-get install gcc-mingw-w64-i686 g++-mingw-w64-i686 mingw-w64-tools
```

For the 64-bit version, this becomes:
```
$ sudo apt-get install gcc-mingw-w64-x86-64 g++-mingw-w64-x86-64 mingw-w64-tools
```

### Development tools
Please install the following tools:
```
$ sudo apt-get install lua5.2 libtool automake autoconf autopoint make gettext pkg-config
$ sudo apt-get install qt4-dev-tools qt5-default git subversion cmake cvs
$ sudo apt-get install wine64-development-tools zip p7zip nsis bzip2
$ sudo apt-get install yasm ragel ant default-jdk protobuf-compiler dos2unix
```
Also, please install the following packages as well:
```
$ sudo apt-get install liblua5.2-dev libvorbis-dev libmad0-dev
$ sudo apt-get install --allow-downgrades -y libavutil-ffmpeg54=7:2.8.6-1ubuntu2 libavutil-dev=7:2.8.6-1ubuntu2
$ sudo apt-get install --allow-downgrades -y libswresample-ffmpeg1=7:2.8.6-1ubuntu2 libswresample-dev=7:2.8.6-1ubuntu2
$ sudo apt-get install --allow-downgrades -y libavcodec-ffmpeg56=7:2.8.6-1ubuntu2 libavcodec-dev=7:2.8.6-1ubuntu2
$ sudo apt-get install --allow-downgrades -y libavformat-ffmpeg56=7:2.8.6-1ubuntu2 libavformat-dev=7:2.8.6-1ubuntu2
$ sudo apt-get install --allow-downgrades -y libswscale-ffmpeg3=7:2.8.6-1ubuntu2 libswscale-dev=7:2.8.6-1ubuntu2
$ sudo apt-get install -y gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-libav \
  gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-pulseaudio
$ sudo apt install -y liba52-0.7.4-dev
$ sudo apt install -y libxcb-shm0-dev libxcb-composite0-dev libxcb-xv0-dev
$ sudo apt install -y libalsa-ocaml-dev libgcrypt11-dev
```

## Prepare the 3rd party libraries (external packages)
### Prebuilt (fast)
```
$ cd vlc-2.2.0-git
$ cd contrib/win32
$ ../bootstrap --host=HOST-TRIPLET
$ make prebuilt
```
Please make sure that you replace the keyword `HOST-TRIPLET` with either of the following values adapted to your target Windows version (32-bit or 64-bit, respectively):
* `i686-w64-mingw32` for Windows 32-bits, using the Mingw-w64 toolchain
* `x86_64-w64-mingw32` for Windows 64-bits, using the Mingw-w64 toolchain

Each prebuilt zip file for the target Windows version is located in the `vlc-2.2.0-git/contrib/win32` sub-folder.<br/>
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
$ cd vlc-2.2.0-git
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
Go back to the VLC source directory (`vlc-2.2.0-git`):
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

