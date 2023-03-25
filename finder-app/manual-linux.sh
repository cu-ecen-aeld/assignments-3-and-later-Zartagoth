#!/bin/bash
# Script outline to install and build kernel.
# Author: Siddhant Jajoo.

set -e
set -u

OUTDIR=/tmp/aeld
KERNEL_REPO=git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
KERNEL_VERSION=v5.1.10
BUSYBOX_VERSION=1_33_1
FINDER_APP_DIR=$(realpath $(dirname $0))
ARCH=arm64
CROSS_COMPILE=aarch64-none-linux-gnu-

if [ $# -lt 1 ]
then
	echo "Using default directory ${OUTDIR} for output"
else
	OUTDIR=$1
	echo "Using passed directory ${OUTDIR} for output"
fi

mkdir -p ${OUTDIR}

# Save current dir
current_dir=$(pwd)

cd "$OUTDIR"
if [ ! -d "${OUTDIR}/linux-stable" ]; then
    #Clone only if the repository does not exist.
	echo "CLONING GIT LINUX STABLE VERSION ${KERNEL_VERSION} IN ${OUTDIR}"
	git clone ${KERNEL_REPO} --depth 1 --single-branch --branch ${KERNEL_VERSION}
fi
if [ ! -e ${OUTDIR}/linux-stable/arch/${ARCH}/boot/Image ]; then
    cd linux-stable
    echo "Checking out version ${KERNEL_VERSION}"
    git checkout ${KERNEL_VERSION}

    # TODO: Add your kernel build steps here
    make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} mrproper
    make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} defconfig
    make -j4 ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} all
    make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} modules
    make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} dtbs
fi

echo "Adding the Image in outdir"

echo "Creating the staging directory for the root filesystem"
cd "$OUTDIR"
if [ -d "${OUTDIR}/rootfs" ]
then
	echo "Deleting rootfs directory at ${OUTDIR}/rootfs and starting over"
    sudo rm  -rf ${OUTDIR}/rootfs
fi

# TODO: Create necessary base directories
mkdir -p rootfs
cd rootfs
mkdir -p bin dev etc home lib lib64 proc sbin sys tmp usr var
mkdir -p usr/bin usr/sbin
mkdir -p var/log

cd "$OUTDIR"
if [ ! -d "${OUTDIR}/busybox" ]
then
    git clone git://busybox.net/busybox.git
    cd busybox
    git checkout ${BUSYBOX_VERSION}
    # TODO:  Configure busybox
else
    cd busybox
fi

# TODO: Make and install busybox
make distclean
make defconfig
make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE}
make CONFIG_PREFIX=$OUTDIR/rootfs ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} install

# TODO: Add library dependencies to rootfs
echo "Library dependencies"
cd $OUTDIR/rootfs
program_interpreter=$(${CROSS_COMPILE}readelf -a bin/busybox | grep "program interpreter")
shared_library=$(${CROSS_COMPILE}readelf -a bin/busybox | grep "Shared library")

program_interpreter=$(echo $program_interpreter | cut -d ":" -f2 | cut -d "]" -f1 | cut -d "/" -f3)

sysroot_dir=$(aarch64-none-linux-gnu-gcc -print-sysroot)

cp $sysroot_dir/lib/$program_interpreter lib/

while IFS= read -r line; do
    line=$(echo $line | cut -d "[" -f2 | cut -d "]" -f1)
    cp $sysroot_dir/lib64/$line lib64/
done <<< "$shared_library"

# TODO: Make device nodes
if [ ! -e "dev/null" ]
then
    sudo mknod -m 666 dev/null c 1 3
fi
if [ ! -e "dev/console" ]
then
    sudo mknod -m 666 dev/console c 5 1
fi

# TODO: Clean and build the writer utility
cd $current_dir
make clean
make

# TODO: Copy the finder related scripts and executables to the /home directory
# on the target rootfs
cp $current_dir/writer $OUTDIR/rootfs/home/
cp $current_dir/autorun-qemu.sh $OUTDIR/rootfs/home/
cp $current_dir/finder.sh $OUTDIR/rootfs/home/
cp $current_dir/finder-test.sh $OUTDIR/rootfs/home/
cp -r $current_dir/conf/ $OUTDIR/rootfs/home/

# TODO: Chown the root directory
sudo chown -R root:root $OUTDIR/rootfs

# TODO: Create initramfs.cpio.gz
cd $OUTDIR
find . | cpio -H newc -ov --owner root:root > $OUTDIR/initramfs.cpio
gzip -f initramfs.cpio