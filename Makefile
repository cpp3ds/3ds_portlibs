FREETYPE             := freetype
FREETYPE_VERSION     := $(FREETYPE)-2.6.1
FREETYPE_SRC         := $(FREETYPE_VERSION).tar.bz2
FREETYPE_DOWNLOAD    := "http://download.savannah.gnu.org/releases/freetype/freetype-2.6.1.tar.bz2"

LIBJPEGTURBO         := libjpeg-turbo
LIBJPEGTURBO_VERSION := $(LIBJPEGTURBO)-1.4.2
LIBJPEGTURBO_SRC     := $(LIBJPEGTURBO_VERSION).tar.gz
LIBJPEGTURBO_DOWNLOAD:= "http://sourceforge.net/projects/libjpeg-turbo/files/1.4.2/libjpeg-turbo-1.4.2.tar.gz"

LIBPNG               := libpng
LIBPNG_VERSION       := $(LIBPNG)-1.6.19
LIBPNG_SRC           := $(LIBPNG_VERSION).tar.xz
LIBPNG_DOWNLOAD      := "http://prdownloads.sourceforge.net/libpng/libpng-1.6.19.tar.xz"

ZLIB                 := zlib
ZLIB_VERSION         := $(ZLIB)-1.2.8
ZLIB_SRC             := $(ZLIB_VERSION).tar.gz
ZLIB_DOWNLOAD        := "http://prdownloads.sourceforge.net/libpng/zlib-1.2.8.tar.gz"

LIBMAD               := libmad
LIBMAD_VERSION       := $(LIBMAD)-0.15.1b
LIBMAD_SRC           := $(LIBMAD_VERSION).tar.gz
LIBMAD_DOWNLOAD      := "http://sourceforge.net/projects/mad/files/libmad/0.15.1b/libmad-0.15.1b.tar.gz"

LIBOGG               := libogg
LIBOGG_VERSION       := $(LIBOGG)-1.3.2
LIBOGG_SRC           := $(LIBOGG_VERSION).tar.xz
LIBOGG_DOWNLOAD      := "http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.xz"

TREMOR                := tremor
TREMOR_VERSION        := $(TREMOR)-2a1a8f6
TREMOR_SRC            := $(TREMOR_VERSION).tar.gz
TREMOR_DOWNLOAD       := "https://git.xiph.org/?p=tremor.git;a=snapshot;h=2a1a8f621e500fdf0749f115e2206f82919560a3;sf=tgz"

export PORTLIBS        := $(DEVKITPRO)/portlibs/3ds
export PATH            := $(DEVKITARM)/bin:$(PATH)
export PKG_CONFIG_PATH := $(PORTLIBS)/lib/pkgconfig
export CFLAGS          := -march=armv6k -mtune=mpcore -mfloat-abi=hard -O2 \
                          -mword-relocations -ffunction-sections -fdata-sections
export CPPFLAGS        := -I$(PORTLIBS)/include
export LDFLAGS         := -L$(PORTLIBS)/lib

.PHONY: all install install-zlib clean \
	$(FREETYPE) \
	$(LIBJPEGTURBO) \
	$(LIBPNG) \
	$(ZLIB) \
	$(LIBMAD) \
	$(LIBOGG) \
	$(TREMOR)

all:
	@echo "Please choose one of the following targets:"
	@echo "  $(FREETYPE) (requires zlib to be installed)"]
	@echo "  $(LIBJPEGTURBO)"
	@echo "  $(LIBPNG) (requires zlib to be installed)"]
	@echo "  $(ZLIB)"
	@echo "  $(LIBMAD)"
	@echo "  $(LIBOGG)"
	@echo "  $(TREMOR) (requires libogg to be installed)"

$(FREETYPE): $(FREETYPE_SRC)
	@[ -d $(FREETYPE_VERSION) ] || tar -xaf $<
	@cd $(FREETYPE_VERSION) && \
	 ./configure --prefix=$(PORTLIBS) --host=arm-none-eabi --disable-shared --enable-static --without-harfbuzz
	@$(MAKE) -C $(FREETYPE_VERSION)

$(LIBJPEGTURBO): $(LIBJPEGTURBO_SRC)
	@[ -d $(LIBJPEGTURBO_VERSION) ] || tar -xaf $<
	@cd $(LIBJPEGTURBO_VERSION) && \
	 ./configure --prefix=$(PORTLIBS) --host=arm-none-eabi --disable-shared --enable-static
	@$(MAKE) CFLAGS+="\"-Drandom()=rand()\"" -C $(LIBJPEGTURBO_VERSION)

$(LIBPNG): $(LIBPNG_SRC)
	@[ -d $(LIBPNG_VERSION) ] || tar -xaf $<
	@cd $(LIBPNG_VERSION) && \
	 ./configure --prefix=$(PORTLIBS) --host=arm-none-eabi --disable-shared --enable-static
	@$(MAKE) -C $(LIBPNG_VERSION)

$(ZLIB): $(ZLIB_SRC)
	@[ -d $(ZLIB_VERSION) ] || tar -xaf $<
	@cd $(ZLIB_VERSION) && \
	 CHOST=arm-none-eabi ./configure --static --prefix=$(PORTLIBS)
	@$(MAKE) -C $(ZLIB_VERSION)

$(LIBMAD): $(LIBMAD_SRC)
	@[ -d $(LIBMAD_VERSION) ] || tar -xaf $<
	@cd $(LIBMAD_VERSION) && \
	 patch -Np1 -i ../libmad-0.15.1b.patch && \
	 ./configure --prefix=$(PORTLIBS) --host=arm-none-eabi --disable-shared --enable-static
	@$(MAKE) -C $(LIBMAD_VERSION)

$(LIBOGG): $(LIBOGG_SRC)
	@[ -d $(LIBOGG_VERSION) ] || tar -xaf $<
	@cd $(LIBOGG_VERSION) && \
	 ./configure --prefix=$(PORTLIBS) --host=arm-none-eabi --disable-shared --enable-static
	@$(MAKE) -C $(LIBOGG_VERSION)

$(TREMOR): $(TREMOR_SRC)
	@[ -d $(TREMOR_VERSION) ] || tar -xzf $<
	@cd $(TREMOR_VERSION) && \
	 ./autogen.sh --prefix=$(PORTLIBS_PATH)/armv6k --host=arm-none-eabi --disable-shared --disable-oggtest
	@$(MAKE) -C $(TREMOR_VERSION)

# Downloads
$(ZLIB_SRC):
	wget -O $@ $(ZLIB_DOWNLOAD)
$(FREETYPE_SRC):
	wget -O $@ $(FREETYPE_DOWNLOAD)
$(LIBJPEGTURBO_SRC):
	wget -O $@ $(LIBJPEGTURBO_DOWNLOAD)
$(LIBPNG_SRC):
	wget -O $@ $(LIBPNG_DOWNLOAD)
$(LIBMAD_SRC):
	wget -O $@ $(LIBMAD_DOWNLOAD)
$(LIBOGG_SRC):
	wget -O $@ $(LIBOGG_DOWNLOAD)
$(TREMOR_SRC):
	wget -O $@ $(TREMOR_DOWNLOAD)

install-zlib: 
	@$(MAKE) -C $(ZLIB_VERSION) install

install:
	@[ ! -d $(FREETYPE_VERSION) ] || $(MAKE) -C $(FREETYPE_VERSION) install
	@[ ! -d $(LIBJPEGTURBO_VERSION) ] || $(MAKE) -C $(LIBJPEGTURBO_VERSION) install
	@[ ! -d $(LIBPNG_VERSION) ] || $(MAKE) -C $(LIBPNG_VERSION) install
	@[ ! -d $(LIBMAD_VERSION) ] || $(MAKE) -C $(LIBMAD_VERSION) install
	@[ ! -d $(LIBOGG_VERSION) ] || $(MAKE) -C $(LIBOGG_VERSION) install
	@[ ! -d $(TREMOR_VERSION) ] || $(MAKE) -C $(TREMOR_VERSION) install

clean:
	@$(RM) -r $(FREETYPE_VERSION)
	@$(RM) -r $(LIBJPEGTURBO_VERSION)
	@$(RM) -r $(LIBPNG_VERSION)
	@$(RM) -r $(ZLIB_VERSION)
	@$(RM) -r $(LIBMAD_VERSION)
	@$(RM) -r $(LIBOGG_VERSION)
	@$(RM) -r $(TREMOR_VERSION)
