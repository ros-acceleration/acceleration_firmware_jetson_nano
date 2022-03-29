# Copyright (c) 2022, Acceleration Robotics. All Rights Reserved.
#
# create install SDK, deploy sysroot and apply fixes
message(STATUS "Starting with SDK deployment")

set(TARGET_SYSROOT_DIR ${FIRMWARE_DIR}/sysroots/cortexa72-cortexa53-xilinx-linux)

# extract the sysroot
run("${TESTFIRMWARE} tar -xzf ${FIRMWARE_DIR}/l4t-gcc-toolchain-64-bit-28-3.tar.gz -C ${FIRMWARE_DIR}")
# # clean up tar.gz file
# run("${TESTFIRMWARE} rm ${FIRMWARE_DIR}/l4t-gcc-toolchain-64-bit-28-3.tar.gz")

message(STATUS "SDK setup done.")
