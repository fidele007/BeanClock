ARCHS = armv7 arm64
TARGET = iphone:clang:latest:latest

include theos/makefiles/common.mk

BUNDLE_NAME = JellyLockClock8
JellyLockClock8_FILES = JellyLockClock8.mm
JellyLockClock8_INSTALL_PATH = /Library/PreferenceBundles
JellyLockClock8_FRAMEWORKS = UIKit
JellyLockClock8_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/JellyLockClock8.plist$(ECHO_END)
