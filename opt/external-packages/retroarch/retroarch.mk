################################################################################
# retroarch
################################################################################

RETROARCH_VERSION = 1.22.2
RETROARCH_SOURCE = retroarch-sourceonly-$(RETROARCH_VERSION).tar.xz
RETROARCH_SITE = https://github.com/libretro/RetroArch/releases/download/v$(RETROARCH_VERSION)
RETROARCH_LICENSE = GPL-3.0+
RETROARCH_LICENSE_FILES = COPYING
RETROARCH_DEPENDENCIES = sdl2 zlib host-pkgconf

RETROARCH_CONF_OPTS = \
	--host=$(GNU_TARGET_NAME) \
	--prefix=/usr \
	--sysconfdir=/etc \
	--enable-floathard \
	--enable-sdl2 \
	--enable-rgui \
	--enable-dynamic \
	--disable-sdl \
	--disable-alsa \
	--disable-accessibility \
	--disable-audiomixer \
	--disable-blissbox \
	--disable-bsv_movie \
	--disable-builtinzlib \
	--disable-builtinmbedtls \
	--disable-cdrom \
	--disable-cheevos \
	--disable-chd \
	--disable-discord \
	--disable-dsp_filter \
	--disable-egl \
	--disable-ffmpeg \
	--disable-freetype \
	--disable-gfx_widgets \
	--disable-glsl \
	--disable-imageviewer \
	--disable-kms \
	--disable-langextra \
	--disable-libretrodb \
	--disable-libusb \
	--disable-materialui \
	--disable-microphone \
	--disable-networking \
	--disable-networkgamepad \
	--disable-netplaydiscovery \
	--disable-online_updater \
	--disable-opengl \
	--disable-opengl1 \
	--disable-opengl_core \
	--disable-overlay \
	--disable-ozone \
	--disable-patch \
	--disable-pulse \
	--disable-qt \
	--disable-rewind \
	--disable-runahead \
	--disable-screenshots \
	--disable-shaderpipeline \
	--disable-ssl \
	--disable-systemd \
	--disable-translate \
	--disable-udev \
	--disable-update_assets \
	--disable-update_core_info \
	--disable-update_cores \
	--disable-v4l2 \
	--disable-vg \
	--disable-videocore \
	--disable-videoprocessor \
	--disable-video_filter \
	--disable-vulkan \
	--disable-wayland \
	--disable-x11 \
	--disable-xmb

RETROARCH_CONF_ENV = \
	PKG_CONF_PATH="$(HOST_DIR)/bin/pkg-config" \
	CC="$(TARGET_CC)" \
	CXX="$(TARGET_CXX)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	CXXFLAGS="$(TARGET_CXXFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)"

RETROARCH_MAKE_ENV = $(TARGET_MAKE_ENV)
RETROARCH_MAKE_OPTS = \
	CC="$(TARGET_CC)" \
	CXX="$(TARGET_CXX)" \
	AR="$(TARGET_AR)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	CXXFLAGS="$(TARGET_CXXFLAGS)" \
	CPPFLAGS="-I$(@D) -I$(@D)/libretro-common/include -I$(@D)/deps -I$(STAGING_DIR)/usr/include/SDL2" \
	LDFLAGS="$(TARGET_LDFLAGS)"

# RetroArch's configure script is custom rather than Autoconf.
define RETROARCH_CONFIGURE_CMDS
	(cd $(@D) && $(RETROARCH_CONF_ENV) ./configure $(RETROARCH_CONF_OPTS))
endef

define RETROARCH_BUILD_CMDS
	$(RETROARCH_MAKE_ENV) $(MAKE) $(RETROARCH_MAKE_OPTS) -C $(@D)
endef

define RETROARCH_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/retroarch $(TARGET_DIR)/usr/bin/retroarch
endef

$(eval $(generic-package))
