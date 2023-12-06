LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := RemovePackages
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_TAGS := optional
LOCAL_OVERRIDES_PACKAGES := AmbientSensePrebuilt Aperture bcr Camera2 CarrierSetup GoogleCamera Maps MyVerizonServices OBDM_Permissions Papers Photos RecorderPrebuilt SafetyHubPrebuilt SprintDM SprintHM Stk TipsPrebuilt VzwOmaTrigger YouTube YouTubeMusicPrebuilt Videos
LOCAL_UNINSTALLABLE_MODULE := true
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_SRC_FILES := /dev/null
include $(BUILD_PREBUILT)