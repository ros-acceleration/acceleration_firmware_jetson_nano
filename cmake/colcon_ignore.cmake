# Copyright (c) 2022, Acceleration Robotics. All Rights Reserved.
#
# create COLCON_IGNORE file for the firmware directory

# message("Adding COLCON_IGNORE to firmware")  # debug
set(CMD "${TESTFIRMWARE} touch ${FIRMWARE_DIR}/COLCON_IGNORE")
execute_process(COMMAND bash -c ${CMD})
