################################################################################
# libretro-gambatte
################################################################################

LIBRETRO_GAMBATTE_VERSION = d9d6cd06382d1ced30de34d56d3609452323dab1
LIBRETRO_GAMBATTE_SITE = $(call github,libretro,gambatte-libretro,$(LIBRETRO_GAMBATTE_VERSION))
LIBRETRO_GAMBATTE_LICENSE = GPL-2.0
LIBRETRO_GAMBATTE_LICENSE_FILES = COPYING

define LIBRETRO_GAMBATTE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) platform=rpi1 \
		CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" AR="$(TARGET_AR)" \
		LDFLAGS="$(TARGET_LDFLAGS)"
endef

define LIBRETRO_GAMBATTE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/gambatte_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/gambatte_libretro.so
endef

$(eval $(generic-package))
