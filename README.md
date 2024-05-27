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

## Using Docker
### Build the vlc with Docker
You can build and use the container as follows:<br/>
1. Build the Docker Image:
   ```
   $ docker build -f ./docker/Dockerfile-win32 -t vlc-build-win32 .
   ```
2. Run the Docker Container:
   ```
   $ docker run --name vlc-container vlc-build-win32
   ```
3. Copy VLC Binaries to Host:<br/>
   After the container has been executed, you can copy the VLC binaries from the container to your host machine.
   ```
   $ docker cp vlc-container:/vlc-build/win32/vlc-2.2.8 /path/to/local/directory
   ```
   for example:
   ```
   $ docker cp vlc-container:/vlc-build/win32/vlc-2.2.8 ../win32-app
   ```

If you encounter a problem when building the Docker image, please run the following command in the step 1:
```
$ docker build --progress=plain -f ./docker/Dockerfile-win32 -t vlc-build-win32 .
```

Also, for debugging, you can run the following command after creating the Docker image:
```
$ docker run -it --name vlc-container vlc-build-win32 /bin/bash
```

### Save/Load of Docker image
You can save a Docker image to your local disk using the `docker save` command.<br/>
This command exports your Docker image to a *tarball* file, which can then be stored, transferred, or backed up.

#### Without compression
Save:
```
$ docker save -o vlc-build-win32.tar vlc-build-win32:latest
```
Load:
```
$ docker load -i vlc-build-win32.tar
```

#### With compression
Save:
```
$ docker save vlc-build-win32:latest | gzip > vlc-build-win32.tar.gz
```
Load:
```
$ zcat vlc-build-win32.tar.gz | docker load
```
or
```
$ gunzip -c vlc-build-win32.tar.gz | docker load
```

### Connecting to the Docker container exited by you
#### Step 1: List Exited Containers
First, you need to find the container ID or name of the exited container. You can list all containers, including the exited ones, using the following command:
```
$ docker ps -a
```
This command will display a list of all containers along with their status.<br/>
Look for the container you want to restart by checking its status.

#### Step 2: Restart the Exited Container
Once you have identified the container ID or name, you can restart it using the `docker start` command.<br/>
For example, if your container name is `vlc-container`, you would run:
```
$ docker start vlc-container
```
If you prefer to use the container ID, replace `vlc-container` with the container ID.

#### Step 3: Attach to the Container
After restarting the container, you can attach to it using `docker attach`:
```
$ docker attach vlc-container
```
This will connect your terminal to the container, allowing you to interact with it as if you were inside the container’s terminal.<br/>
**Or, run a command in the container (e.g., open a bash shell):**
```
$ docker exec -it vlc-container /bin/bash
```

### Downloading the Docker image from Docker Hub
You can download the proper docker image from **[Docker Hub](https://hub.docker.com/)** to use if for building the vlc for Windows 32-bit.<br/>
```
$ docker pull jimmy0519/vlc-build-win32:v1.0.0
```
For more information, please refer to https://hub.docker.com/repository/docker/jimmy0519/vlc-build-win32/general.
