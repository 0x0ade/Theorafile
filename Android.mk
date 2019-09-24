LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := theorafile

LOCAL_C_INCLUDES := \
	$(LOCAL_PATH) \
	$(LOCAL_PATH)/lib \
	$(LOCAL_PATH)/lib/ogg \
	$(LOCAL_PATH)/lib/vorbis \
	$(LOCAL_PATH)/lib/theora

LOCAL_SRC_FILES := \
	$(wildcard $(LOCAL_PATH)/*.c) \
	$(wildcard $(LOCAL_PATH)/lib/ogg/*.c) \
	$(wildcard $(LOCAL_PATH)/lib/vorbis/*.c) \
	$(wildcard $(LOCAL_PATH)/lib/theora/*.c)

# If your targets don't support these extensions,
# please question your life decisions.
# -ade

ifeq ($(TARGET_ARCH_ABI),x86)
	LOCAL_CFLAGS += -DOC_X86_ASM
	LOCAL_SRC_FILES += $(wildcard $(LOCAL_PATH)/lib/theora/x86/*.c)
endif

ifeq ($(TARGET_ARCH_ABI),x86_64)
	LOCAL_CFLAGS += -DOC_X86_ASM
	LOCAL_SRC_FILES += $(wildcard $(LOCAL_PATH)/lib/theora/x86/*.c)
endif

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
	LOCAL_ARM_MODE := arm
	LOCAL_ARM_NEON := true
	LOCAL_CFLAGS += -DOC_ARM_ASM -DOC_ARM_ASM_EDSP -DOC_ARM_ASM_MEDIA -DOC_ARM_ASM_NEON
	LOCAL_C_INCLUDES += $(LOCAL_PATH)/lib/theora/arm
	LOCAL_SRC_FILES += $(wildcard $(LOCAL_PATH)/lib/theora/arm/*.c) $(wildcard $(LOCAL_PATH)/lib/theora/arm/*-v7a.gen.S)
	LOCAL_SRC_FILES := $(filter-out $(LOCAL_PATH)/lib/theora/arm/armopts-v7a.gen.S, $(LOCAL_SRC_FILES))
endif

ifeq ($(TARGET_ARCH_ABI),arm64-v8a)
	LOCAL_ARM_MODE := arm
	LOCAL_ARM_NEON := true
	# lol no
endif

LOCAL_LDLIBS += -lm

include $(BUILD_SHARED_LIBRARY)
