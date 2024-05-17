
DESCRIPTION = "Image with Sato, a mobile environment and visual style for \
mobile devices. The image supports X11 with a Sato theme, Pimlico \
applications, and contains terminal, editor, and file manager."
HOMEPAGE = "https://www.yoctoproject.org/"

IMAGE_FEATURES += "splash package-management x11-base x11-sato ssh-server-dropbear hwcodecs"

LICENSE = "MIT"

inherit core-image

TOOLCHAIN_HOST_TASK:append = " nativesdk-intltool nativesdk-glib-2.0"
TOOLCHAIN_HOST_TASK:remove:task-populate-sdk-ext = " nativesdk-intltool nativesdk-glib-2.0"

QB_MEM = '${@bb.utils.contains("DISTRO_FEATURES", "opengl", "-m 512", "-m 256", d)}'
QB_MEM:qemuarmv5 = "-m 256"
QB_MEM:qemumips = "-m 256"


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
IMAGE_INSTALL:remove = " networkmanager"
IMAGE_INSTALL:remove = " packagegroup-core-x11-sato-base packagegroup-core-x11-sato"

# # Set the password for the root user, and create a new user nambed 'technexion`
# EXTRA_USERS_PARAMS = " \
#     usermod -P rootpasswd root; \
#     useradd -p '' technexion \
# "

# Define a variable to hold the list of systemd unit config files to be modified.
# Modify the serial console config and the video console config files.

# Filename: secure-sync-shield.bb

# # Include the base minimal image
# #require recipes-core/images/core-image-minimal.bb
# require recipes-sato/images/core-image-sato.bb

# # Append any additional packages you want to include
# IMAGE_INSTALL:append = " openssh"

# # Ensure the sshd service starts at boot
# inherit update-rc.d
# INITSCRIPT_PACKAGES = "openssh"
# INITSCRIPT_NAME_openssh-server = "sshd"
# INITSCRIPT_PARAMS_openssh-server = "defaults"

