################################################################################
# fbcp-st7789
################################################################################

FBCP_ST7789_VERSION = d0ebacf7c1f30b19b50997ebb67ba4f70ab95368
FBCP_ST7789_SITE = $(call github,juj,fbcp-ili9341,$(FBCP_ST7789_VERSION))
FBCP_ST7789_LICENSE = MIT
FBCP_ST7789_LICENSE_FILES = LICENSE.txt
FBCP_ST7789_DEPENDENCIES = rpi-userland host-cmake
FBCP_ST7789_CONF_OPTS = \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_TOOLCHAIN_FILE=$(HOST_DIR)/share/buildroot/toolchainfile.cmake \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) -I$(STAGING_DIR)/usr/include" \
	-DCMAKE_EXE_LINKER_FLAGS="$(TARGET_LDFLAGS) -L$(STAGING_DIR)/usr/lib" \
	-DSINGLE_CORE_BOARD=ON \
	-DARMV6Z=ON \
	-DWAVESHARE_ST7789VW_HAT=ON \
	-DSPI_BUS_CLOCK_DIVISOR=40 \
	-DUSE_DMA_TRANSFERS=OFF \
	-DSTATISTICS=0

define FBCP_ST7789_FIX_VIDEOCORE_LINK
	$(SED) 's/pthread bcm_host atomic/pthread bcm_host vchostif vchiq_arm vcos atomic/' \
		$(@D)/CMakeLists.txt
endef
FBCP_ST7789_POST_PATCH_HOOKS += FBCP_ST7789_FIX_VIDEOCORE_LINK

define FBCP_ST7789_CONFIGURE_CMDS
	mkdir -p $(@D)/build
	(cd $(@D)/build && $(HOST_DIR)/bin/cmake $(FBCP_ST7789_CONF_OPTS) ..)
endef

define FBCP_ST7789_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/build
endef

define FBCP_ST7789_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/build/fbcp-ili9341 \
		$(TARGET_DIR)/usr/bin/fbcp-st7789
endef

$(eval $(generic-package))
