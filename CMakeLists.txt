cmake_minimum_required(VERSION 3.5)
project(acceleration_firmware_jetson_nano)

# Default to C++14
if(NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 14)
endif()

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

find_package(ament_cmake REQUIRED)
include(cmake/firmware_setup.cmake)  # define only once, here

if (NOT EXISTS ${FIRMWARE_DIR})
  # Deploy firmware directory into "firmware" directory, file by file
  #
  # NOTE that "${CMAKE_INSTALL_PREFIX}/../firmware" will be at the same
  #  level as "install", "build" or "log"  if "--merge-install" option is used.
  #  Otherwise, it'll reside within "install"
  install(
    DIRECTORY
      firmware/
    DESTINATION
      ${FIRMWARE_DIR}
  )
endif()  # NOT EXISTS ${FIRMWARE_DIR}

# NOTE:
# The following scripts avoid the use of CMake EXISTS
# due to undefined behavior. Refer to the development
# notes for more details https://gitlab.com/xilinxrobotics/docs/-/issues/9#note_505935065
# For more details, refer to the xilinx_vitis package.

# To execute logic after the install() CMake command, embed
# follow-up actions into CMake scripts which get added to the
# "cmake_install.cmake" script in order
#     See https://stackoverflow.com/a/10000327
install(SCRIPT "${CMAKE_SOURCE_DIR}/cmake/firmware_setup.cmake")
# install(SCRIPT "${CMAKE_SOURCE_DIR}/cmake/sysroot.cmake")  # using the L4T cross-compilation toolchain
install(SCRIPT "${CMAKE_SOURCE_DIR}/cmake/sdk.cmake")  # using Yocto-generated SDK

# Generate toolchain, first install template, then execute
install(
  FILES
    "${CMAKE_SOURCE_DIR}/scripts/jetson_nano.mixin.template"
    "${CMAKE_SOURCE_DIR}/scripts/index.yaml.template"
  DESTINATION
    ${CMAKE_BINARY_DIR}
)
install(SCRIPT "${CMAKE_SOURCE_DIR}/cmake/generate_mixin.cmake")
install(SCRIPT "${CMAKE_SOURCE_DIR}/cmake/colcon_ignore.cmake")


# kept so that other packages can depend on it
ament_package()
