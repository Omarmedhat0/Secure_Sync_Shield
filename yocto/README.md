# Secure-Sync-Shield (Custom Image )

## Introduction

This project is built using the [Yocto Project](https://www.yoctoproject.org/), an open-source collaboration project that provides templates, tools, and methods to help you create custom Linux-based systems for embedded products, regardless of the hardware architecture. It's a complete embedded Linux development environment with tools, metadata, and documentation - everything you need.

The core part of the Yocto Project is [Poky](https://www.yoctoproject.org/docs/latest/overview-manual/overview-manual.html#poky), a reference distribution of the Yocto Project. It contains the OpenEmbedded Build System (BitBake and OpenEmbedded Core) as well as a set of metadata to get you started building your own distro.



The aim of project is to build an GUI using QT creator running on Raspberry 3b+ which has custom Linux image with the following features : 

* Auto Login 
* Support QT5 applications
* Support Wifi and Bluetooth 

## Project Details

This project includes the following features:

- OpenSSH server and SFTP server for secure file transfer
- Rsync for fast incremental file transfer
- X11vnc, a VNC server for real X displays
- Linux firmware and various utilities like i2c-tools, python3-smbus, bridge-utils, hostapd, iptables, iw, wpa-supplicant, and kernel-modules
- Development tools like make and cmake
- Coreutils and libunistring libraries
- Qt base tools and libraries, including qtbase, qtdeclarative, qtimageformats, qtmultimedia, qtquickcontrols2, qtquickcontrols, and qtbase-plugins
- Cinematicexperience and liberation-fonts for improved UI experience
- Systemd for system and service management
- Bluetooth and WiFi support
- IPv4 support
- Fontconfig support for qtbase
- Multi threading support with 4 threads

## Project Tree 

![tree](README.assets/tree.png)

## Building the Project

> **CAUTION : Make sure you have an almost 100 GB free space on your hard disk as the building process take too much memory**

### Download Required Layers

First of all download Poky kirkstone branch as this version has Long-Term Support unit now and It's preferred  that to download all the following layers in the Poky directory after you clone it  

```bash
git clone -b kirkstone git://git.yoctoproject.org/poky.git
cd poky/
```

Download RPI BSP on  kirkstone branch

```bash
git clone -b kirkstone https://github.com/agherzan/meta-raspberrypi.git 
```

Download openembedded layer on  kirkstone branch

```bash
git clone -b kirkstone https://github.com/openembedded/meta-openembedded.git
```

Download QT5 layer on  kirkstone branch

```bash
git clone -b kirkstone https://github.com/meta-qt5/meta-qt5.git
```

### Setup The Environment For The Building Process 

* Run **oe-init-build-env** script for bitbake commands to another important environment variables 

  ```bash
  source oe-init-build-env
  ```

  ![image-20240528150417143](README.assets/image-20240528150417143.png)

#### Adding The Downloaded Layers To The Project 

* You have 2 Options : 

  * Option 1 : 

    *  You add manually each downloaded layer except layers which downloaded by **Poky** by this command 

      ```bash
      bitbake-layers add-layer /path/to/layer 
      #Example for add meta-qt5 to my project 
      bitbake-layers add-layer /home/omar/ITI/yocto/poky/meta-qt5 
      ```

      and do this for all layers 

  * Option 2 : 

    * Open **bblayers.conf** and add them once in the file by this following steps : 

      > NOTE : ***bitbake-layers add-layer*** command  append the layer automatically in this file 

      ```bash
      #After you you source oe-init-build-env it automatically dircet you to thi path # /yocto/poky/build  
      nano conf/bblayers.conf 
      #or if you have VS open files from it 
      cd conf
      code . 
      ```

      Now add all new layers to it as following  and save it 

      ```bash
      # POKY_BBLAYERS_CONF_VERSION is increased each time build/conf/bblayers.conf
      # changes incompatibly
      POKY_BBLAYERS_CONF_VERSION = "2"
      
      BBPATH = "${TOPDIR}"
      BBFILES ?= ""
      BBLAYERS ?= " \
        /home/omar/ITI/yocto/poky/meta \
        /home/omar/ITI/yocto/poky/meta-poky \
        /home/omar/ITI/yocto/poky/meta-yocto-bsp \
        /home/omar/ITI/yocto/poky/meta-raspberrypi \
        /home/omar/ITI/yocto/poky/meta-secure-sync-shield \
        /home/omar/ITI/yocto/poky/meta-openembedded/meta-oe \
        /home/omar/ITI/yocto/poky/meta-openembedded/meta-python \
        /home/omar/ITI/yocto/poky/meta-openembedded/meta-networking \
        /home/omar/ITI/yocto/poky/meta-openembedded/meta-multimedia \
        /home/omar/ITI/yocto/poky/build/workspace \
        /home/omar/ITI/yocto/poky/meta-qt5 \
        "
      ```

#### Select the required features from the layers that will be exciting  in the image

* Now open **local.conf** by ant Text Editor and edit the following 

  ```bash
  nano conf/local.conf
  ```
  
* Edit the default machine by commented it add our the required machine that you build the image for it which will be  **raspberrypi3-64** at our case 

  ```bash
  #Comment qemux86-64"
  #MACHINE ?= "qemux86-64"
  
  #Add the required new machine 
  MACHINE ?= "raspberrypi3-64"
  ```

* Set a directory for downloads as you will download any dependencies for one time and re-use them every time you will build the image for any new features without re-download them again 

  > **CAUTION : Don't write any  a relative paths and put only an absolute paths **

  ```bash
  DL_DIR ?= "/home/omar/ITI/yocto/downloads"
  ```

* Set a directory for SSTATE to build any dependencies for one time and re-use them every time you will build the image for any new features without re-build them again 

  ```bash
  SSTATE_DIR ?= "/home/omar/ITI/yocto/sstate-cache"
  ```

* Now add those variables at the end of the filefor all features that you need at the current state to match the requirements

  ```bash
  
  ### Image Size and cores for build ### 
  IMAGE_ROOTFS_EXTRA_SPACE = "5242880"
  BB_NUMBER_THREADS = "4"
  PARALLEL_MAKE = "-j 4"
  ###SSH and VNC ### 
  EXTRA_IMAGE_FEATURES += "ssh-server-openssh"
  IMAGE_INSTALL:append = " openssh-sftp-server rsync x11vnc "
  
  #Blutooth and wifi### 
  IMAGE_INSTALL:append = " linux-firmware bluez5 i2c-tools python3 python3-smbus bridge-utils hostapd iptables iw wpa-supplicant kernel-modules "
  
  ### Bluetooth  ###
  MACHINE_FEATURES += " bluetooth"
  DISTRO_FEATURES:append = " pi-bluetooth bluez5 bluetooth "
  IMAGE_INSTALL:append = " pi-bluetooth bluez5 bluez5-testtools udev-rules-rpi  "
  ENABLE_UART = "1"
  
  
  #Make AND CMAKE
  IMAGE_INSTALL:append = " make cmake ldd coreutils connman connman-client "
  #QT
  IMAGE_INSTALL:append = " qtbase-tools qtbase qtdeclarative qtsvg qtlocation  libunistring"
  IMAGE_INSTALL:append = " qtimageformats qtmultimedia qtquickcontrols2 qtquickcontrols qtbase-plugins "
  IMAGE_INSTALL:append = " cinematicexperience liberation-fonts qtscript qtgraphicaleffects qtvirtualkeyboard" 
  
  
  ### Sound ###
  IMAGE_INSTALL:append = " gstreamer1.0-plugins-good gstreamer1.0-plugins-base gstreamer1.0-plugins-ugly"
  LICENSE_FLAGS_ACCEPTED:append = " commercial  commercial_gstreamer1.0-plugins-ugly commercial_gstreamer1.0-plugins-ugly"
  PACKAGECONFIG:append-pn-qtmultimedia = " gstreamer alsa"
  
  ### Audio Streaming ###
  DISTRO_FEATURES_:append = " pulseaudio"
  IMAGE_INSTALL:append = " pulseaudio pulseaudio-module-dbus-protocol pulseaudio-server pulseaudio-module-bluetooth-discover pulseaudio-module-bluetooth-policy pulseaudio-module-bluez5-device pulseaudio-module-bluez5-discover alsa-utils alsa-plugins"
  IMAGE_INSTALL:append = " alsa-utils alsa-plugins alsa-lib alsa-state dbus"
  
  
  # Ensure your kernel configuration includes the necessary drivers for your audio hardware.
  # This might involve customizing the kernel recipe to enable specific CONFIG_ options related to your audio hardware.
  #wifi and blutooth and sysytemd
  DISTRO_FEATURES:append = " systemd usrmerge debug-tweaks bluez5 bluetooth wifi ipv4"
  PACKAGECONFIG_FONTS:append_pn-qtbase = " fontconfig"
  DISTRO_FEATUR/ES_BACKFILL_CONSIDERED += "sysvinit"
  VIRTUAL-RUNTIME_init_manager = "systemd"
  VIRTUAL-RUNTIME_initscripts = "systemd-compat-units"
  
  #### plash Screen ### 
  CORE_IMAGE_EXTRA_INSTALL += " plymouth"
  RPI_EXTRA_CONFIG = "disable_splash=1"
  
  #### Vsome IP### 
  IMAGE_INSTALL:append = " boost vsomeip "
  
  #### Custome Recipes ### 
  IMAGE_INSTALL:append = " guiboard autostart"
  
  ```

* If required this lines for configure auto login for root user add those lines at the end of the file 

  ```bash
  IMAGE_FEATURES_REMOVE += " \
      debug-tweaks \
  "
   
  root_LOCAL_GETTY ?= " \
       ${IMAGE_ROOTFS}${systemd_system_unitdir}/serial-getty@.service \
       ${IMAGE_ROOTFS}${systemd_system_unitdir}/getty@.service \
  "
  # Define a function that modifies the systemd unit config files with the autologin arguments
  local_autologin () {
      sed -i -e 's/^\(ExecStart *=.*getty \)/\1--autologin root /' ${root_LOCAL_GETTY}
  }
  
  # Add the function so that it is executed after the rootfs has been generated
  ROOTFS_POSTPROCESS_COMMAND += "local_autologin; "
  ```

#### Build you image 

To build the project, use the `bitbake` command followed by the name of your image. and i will use sato image to build the image by at as it supports graphic requirements 

```bash
bitbake core-image-sato -k
```

> **Note** : For the first time the building process take too much time from 5 hrs or above according to your machine capabilities and your network speed 

* At the building process if any task failed to be built use this command to delete it's binaries and re-build it 

  ```bash
  bitbake -c cleansstate <Name of failed task>
  ```

  Example : 

  ![image-20240528174754634](README.assets/image-20240528174754634.png)

  ```bash
  bitbake -c cleansstate input-utils
  bitbake core-image-sato -k
  #And so on
  ```

* At the end of build process you can run this command to delete duplication in binaries for sstate

  ```bash
  #as this directory in poky directory
  cd .. 
  
  ./scripts/sstate-cache-management.sh --cache-dir=../sstate-cache --remove-duplicated
  ```

  Now you should build your image successfully and you can find it under this path 

  ```bash
  cd ~/ITI/yocto/poky/build/tmp/deploy/images/raspberrypi3-64/
  ```

   ![image-20240528181122215](README.assets/image-20240528181122215.png)

### Burn The image to SD Card

* from al files the you can see in th build directory we want the file which ended with extention **wic.bz2** to use it for burning the image to SD card 

  ![image-20240528181550707](README.assets/image-20240528181550707.png)

* De compress it according to it's name(this name my change according to your image name put the extension is unique and will find one file with it  ) to .wic

  ```bash
  bunzip2 "secure-sync-shield-raspberrypi3-64-20240520142954.rootfs.wic.bz2" -d -c > "secure-sync-shield-raspberrypi3-64.rootfs.wic"
  ```

* Now you de compress the binaries and you will find it name at the same directory with  "Image Name".wic example **secure-sync-shield-raspberrypi3-64.rootfs.wic** now put your memory card into the build machine 

  * First the should know the name of the memory card for interfacing using ``` lsblk``` command

    ![image-20240528183107472](README.assets/image-20240528183107472.png)

    You can notice that it's name is ***mmcblk0***

  * int the directory for the build you will use ```dd``` commnad for  for build the image on **mmcblk0**

  ```bash
  sudo dd if="secure-sync-shield-raspberrypi3-64.rootfs.wic" of="/dev/mmcblk0" bs=4M status=progress
  ```
  
  * Now you fill find that you have the SD is divided into 2 portions  boot and root and they have the image
  
    ![image-20240528184027669](README.assets/image-20240528184027669.png)

### Connect with the target for the first time using ssh 

* Put SD card in Raspberrypi and connect Raspberrypi with power source and connect an Ethernet wire between it and the local machine 

* On Ubuntu you need to make some configurations for Ethernet port to establish the connection successfully   

  * Choose wired connection -> wired settings

    ![image-20240528184816977](README.assets/image-20240528184816977.png)

  * Click on setting icon

    ![image-20240528185012989](README.assets/image-20240528185012989.png)

  * change IPv4 and IPv6  method yo shared to other computers 

    ![image-20240528185116716](README.assets/image-20240528185116716.png)

* Now we need to know IP address for Ethernet interface by ```ifconfig``` command 

  ```bash
  ifconfig
  ```

   ![image-20240528185755159](README.assets/image-20240528185755159.png)

* Now we will use ```nmap``` command to search on the ip address for the target using inet of Ethernet 

  ```bash
sudo nmap -sn 10.42.0.0/16
```

​	![image-20240528185923480](README.assets/image-20240528185923480.png)

* connect on target using ssh 

  ```bash
  ssh root@10.42.0.151
```

  ![image-20240528190048622](README.assets/image-20240528190048622.png)

* Now you are connected with the target 

### Initiate VNC server 

You have to steps 

* For Target : 

  * Initiate display 0 by this command to use it from developing machine

    ```bash
    x11vnc --display :0 --forever
    ```

     ![image-20240528190557158](README.assets/image-20240528190557158.png)

* For developing machine 

  * Download VNC viewer from this link and setup it 

    https://www.realvnc.com/en/connect/download/viewer/

  * Connect with the target using it by the following steps : 

    * Inter the Raspberrypi following by :0 in the search bar and click enter 

      ![image-20240528191204399](README.assets/image-20240528191204399.png)

    * Click continue and now you can see a real screen form the target output 

      ![image-20240528191323922](README.assets/image-20240528191323922.png)
