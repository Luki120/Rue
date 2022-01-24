ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:latest
INSTALL_TARGET_PROCESSES = SpringBoard

TWEAK_NAME = Rue

Rue_FILES = Tweak.m Views/RueSearchView.m
Rue_CFLAGS = -fobjc-arc
RUE_LIBRARIES = gcuniversal

SUBPROJECTS = RuePrefs

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
