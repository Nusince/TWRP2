ifneq ($(TARGET_SIMULATOR),true)
ifeq ($(TARGET_ARCH),arm)

LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

commands_recovery_local_path := $(LOCAL_PATH)

LOCAL_MODULE := recovery

LOCAL_C_INCLUDES += bionic external/stlport/stlport

LOCAL_SRC_FILES := \
    recovery.cpp \
    bootloader.cpp \
    install.cpp \
    roots.cpp \
    ui.cpp \
    verifier.cpp \
    encryptedfs_provisioning.cpp \
    extra-functions.cpp \
    backstore.cpp \
    themes.cpp \
    format.cpp \
    data.cpp

ifeq ($(TARGET_RECOVERY_REBOOT_SRC),)
  LOCAL_SRC_FILES += reboot.c
else
  LOCAL_SRC_FILES += $(TARGET_RECOVERY_REBOOT_SRC)
endif

RECOVERY_API_VERSION := 2
LOCAL_CFLAGS += -DRECOVERY_API_VERSION=$(RECOVERY_API_VERSION)


# This binary is in the recovery ramdisk, which is otherwise a copy of root.
# It gets copied there in config/Makefile.  LOCAL_MODULE_TAGS suppresses
# a (redundant) copy of the binary in /system/bin for user builds.
# TODO: Build the ramdisk image in a more principled way.

LOCAL_MODULE_TAGS := eng

LOCAL_STATIC_LIBRARIES :=
LOCAL_SHARED_LIBRARIES :=

LOCAL_STATIC_LIBRARIES += libmounts libminzip libunz libmincrypt libstlport_static
LOCAL_STATIC_LIBRARIES += libminui libpixelflinger_static libpng

LOCAL_SHARED_LIBRARIES += libjpeg libz libmtdutils libc libcutils libstdc++

ifeq ($(TARGET_RECOVERY_UI_LIB),)
  LOCAL_SRC_FILES += default_recovery_ui.c
else
  LOCAL_STATIC_LIBRARIES += $(TARGET_RECOVERY_UI_LIB)
endif

ifeq ($(TARGET_RECOVERY_GUI),true)
  LOCAL_STATIC_LIBRARIES += libgui
else
  LOCAL_SRC_FILES += gui_stub.c
endif

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := verifier_test.c verifier.c

LOCAL_MODULE := verifier_test

LOCAL_FORCE_STATIC_EXECUTABLE := true

LOCAL_MODULE_TAGS := tests

LOCAL_STATIC_LIBRARIES := libmincrypt libcutils libstdc++ libc

include $(BUILD_EXECUTABLE)

include $(commands_recovery_local_path)/tw_busybox/Android.mk
include $(commands_recovery_local_path)/mounts/Android.mk
include $(commands_recovery_local_path)/minui/Android.mk
include $(commands_recovery_local_path)/minelf/Android.mk
ifeq ($(TARGET_RECOVERY_GUI),true)
include $(commands_recovery_local_path)/gui/Android.mk
endif
include $(commands_recovery_local_path)/minzip/Android.mk
include $(commands_recovery_local_path)/mmcutils/Android.mk
include $(commands_recovery_local_path)/mtdutils/Android.mk
include $(commands_recovery_local_path)/bmlutils/Android.mk
include $(commands_recovery_local_path)/flashutils/Android.mk
include $(commands_recovery_local_path)/tools/Android.mk
include $(commands_recovery_local_path)/edify/Android.mk
include $(commands_recovery_local_path)/prebuilt/Android.mk
include $(commands_recovery_local_path)/updater/Android.mk
include $(commands_recovery_local_path)/applypatch/Android.mk
include $(commands_recovery_local_path)/htc-offmode-charge/Android.mk
commands_recovery_local_path :=

endif   # TARGET_ARCH == arm
endif    # !TARGET_SIMULATOR

