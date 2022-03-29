# Copyright (c) 2022, Acceleration Robotics. All Rights Reserved.
#
# create install SDK, deploy sysroot and apply fixes
message(STATUS "Starting with SDK deployment")

set(TARGET_SYSROOT_DIR ${FIRMWARE_DIR}/sysroots/armv8a-oe4t-linux)

# install the Yocto SDK
run("${TESTFIRMWARE} chmod +x ${FIRMWARE_DIR}/sdk.sh")
run("${TESTFIRMWARE} ${FIRMWARE_DIR}/sdk.sh -d ${FIRMWARE_DIR} -y")

# # FIXME, CMake configuration issues with libfoonathan_memory
# # see https://gitlab.com/xilinxrobotics/docs/-/issues/15
# echo "FIX: Manually deploying libfoonathan_memory."
# cp lib/libfoonathan_memory-0.6.2.a $target_sysroot_dir/usr/lib/
message(STATUS "FIX: Manually deploying libfoonathan_memory")
run("${TESTFIRMWARE} cp ${FIRMWARE_DIR}/lib/libfoonathan_memory-0.6.2.a ${TARGET_SYSROOT_DIR}/usr/lib/")

# # FIXME, Copy libstdc++fs.a
# # see https://gitlab.com/xilinxrobotics/docs/-/issues/39#note_664125180
message(STATUS "FIXME, copy libstdc++fs.a.")
run("${TESTFIRMWARE} cp ${FIRMWARE_DIR}/lib/libstdc++fs.a ${TARGET_SYSROOT_DIR}/usr/lib/")

message(STATUS "SDK setup done.")

# # FIXME, Absolute paths in cmake file created by rcl_yaml_param_parser
# # see https://gitlab.com/xilinxrobotics/docs/-/issues/14
message(STATUS "FIX: Fixing issue with rcl_yaml_param_parser.")
execute_process(
    COMMAND
        sed -i "s:;/media/xilinx/hd3/tegra-demo-distro-honister/build-testdistro/tmp/work/armv8a-oe4t-linux/rcl-yaml-param-parser/1.1.11-1-r0/recipe-sysroot/usr/lib/libyaml.so::"
            ${TARGET_SYSROOT_DIR}/usr/share/rcl_yaml_param_parser/cmake/rcl_yaml_param_parserExport.cmake
)

# FIXME, issues with NVIDIA sysroot, libcudart
run("${TESTFIRMWARE} ln -s ${TARGET_SYSROOT_DIR}/usr/local/cuda-10.2/lib/libcudart.so.10.2 ${TARGET_SYSROOT_DIR}/usr/lib/libcudart.so.10.2")
# FIXME, issues with NVIDIA sysroot, libcublasLt
run("${TESTFIRMWARE} ln -s ${TARGET_SYSROOT_DIR}/usr/local/cuda-10.2/lib/libcublasLt.so.10 ${TARGET_SYSROOT_DIR}/usr/lib/libcublasLt.so.10")
# FIXME, issues with NVIDIA sysroot, libnvvpi
run("${TESTFIRMWARE} ln -s ${TARGET_SYSROOT_DIR}/opt/nvidia/vpi1/lib64/libnvvpi.so.1 ${TARGET_SYSROOT_DIR}/usr/lib/libnvvpi.so.1")
