ARCHS = armv7 arm64
TARGET = iphone:clang:latest:latest
THEOS_BUILD_DIR = Packages

include theos/makefiles/common.mk

TWEAK_NAME = JellyLockClock8
JellyLockClock8_FILES = Tweak.xm
JellyLockClock8_FRAMEWORKS = Foundation UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd" || "killall -9 SpringBoard"
