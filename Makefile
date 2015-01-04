include theos/makefiles/common.mk

TWEAK_NAME = WhatsthissongSiri
WhatsthissongSiri_FILES = Tweak.xm
WhatsthissongSiri_FRAMEWORKS = UIKit
WhatsthissongSiri_LDFLAGS = -lactivator

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
