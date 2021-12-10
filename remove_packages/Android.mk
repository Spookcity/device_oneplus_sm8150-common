LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := RemovePackages
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_TAGS := optional
LOCAL_OVERRIDES_PACKAGES := SafetyHubPrebuilt TipsPrebuilt AmbientSensePrebuilt CarrierSetup MyVerizonServices OBDM_Permissions SprintDM SprintHM VzwOmaTrigger YouTube YouTubeMusicPrebuilt Drive GoogleCamera Maps Photos PrebuiltGmail Videos SecurityHubPrebuilt
LOCAL_UNINSTALLABLE_MODULE := true
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_SRC_FILES := /dev/null
include $(BUILD_PREBUILT)