FREETYPE             := freetype
FREETYPE_VERSION     := $(FREETYPE)-2.5.4
FREETYPE_SRC         := $(FREETYPE_VERSION).tar.bz2

LIBEXIF              := libexif
LIBEXIF_VERSION      := $(LIBEXIF)-0.6.21
LIBEXIF_SRC          := $(LIBEXIF_VERSION).tar.bz2

LIBJPEGTURBO         := libjpeg-turbo
LIBJPEGTURBO_VERSION := $(LIBJPEGTURBO)-1.3.1
LIBJPEGTURBO_SRC     := $(LIBJPEGTURBO_VERSION).tar.gz

LIBPNG               := libpng
LIBPNG_VERSION       := $(LIBPNG)-1.6.15
LIBPNG_SRC           := $(LIBPNG_VERSION).tar.xz

SQLITE               := sqlite
SQLITE_VERSION       := $(SQLITE)-autoconf-3080704
SQLITE_SRC           := $(SQLITE_VERSION).tar.gz

ZLIB                 := zlib
ZLIB_VERSION         := $(ZLIB)-1.2.8
ZLIB_SRC             := $(ZLIB_VERSION).tar.gz

MXML                 := mxml
MXML_VERSION         := $(MXML)-2.9
MXML_SRC             := $(MXML_VERSION).tar.gz

EXPAT                := expat
EXPAT_VERSION        := $(EXPAT)-2.1.0
EXPAT_SRC            := $(EXPAT_VERSION).tar.gz

LIBXML2              := libxml2
LIBXML2_VERSION      := $(LIBXML2)-2.9.2
LIBXML2_SRC          := $(LIBXML2_VERSION).tar.gz

OPENAL               := openal-soft
OPENAL_VERSION       := $(OPENAL)-1.16.0
OPENAL_SRC           := $(OPENAL_VERSION).tar.bz2

JANSSON              := jansson
JANSSON_VERSION      := $(JANSSON)-2.7
JANSSON_SRC          := $(JANSSON_VERSION).tar.gz

PHYSFS               := physfs
PHYSFS_VERSION       := $(PHYSFS)-2.0.3
PHYSFS_SRC           := $(PHYSFS_VERSION).tar.bz2

LIBMAD               := libmad
LIBMAD_VERSION       := $(LIBMAD)-0.15.1b
LIBMAD_SRC           := $(LIBMAD_VERSION).tar.gz

LIBOGG               := libogg
LIBOGG_VERSION       := $(LIBOGG)-1.3.2
LIBOGG_SRC           := $(LIBOGG_VERSION).tar.xz

LIBVORBIS            := libvorbis
LIBVORBIS_VERSION    := $(LIBVORBIS)-1.3.5
LIBVORBIS_SRC        := $(LIBVORBIS_VERSION).tar.xz



export PORTLIBS        := $(DEVKITPRO)/portlibs/armv6k
export PATH            := $(DEVKITARM)/bin:$(PATH)
export PKG_CONFIG_PATH := $(PORTLIBS)/lib/pkgconfig
export CFLAGS          := -march=armv6k -mtune=mpcore -mfloat-abi=hard -O3 \
                          -mword-relocations -fomit-frame-pointer -ffast-math
export CPPFLAGS        := -I$(PORTLIBS)/include
export LDFLAGS         := -L$(PORTLIBS)/lib

.PHONY: all install install-zlib clean \
	$(FREETYPE) \
	$(LIBEXIF) \
	$(LIBJPEGTURBO) \
	$(LIBPNG) \
	$(SQLITE) \
	$(ZLIB) \
	$(MXML) \
	$(EXPAT) \
	$(LIBXML2) \
	$(OPENAL) \
	$(JANSSON) \
	$(PHYSFS) \
	$(LIBMAD) \
	$(LIBOGG) \
	$(LIBVORBIS)

all:
	@echo "Please choose one of the following targets:"
	@echo "  $(FREETYPE) (requires zlib to be installed)"
	@echo "  $(LIBEXIF)"
	@echo "  $(LIBJPEGTURBO)"
	@echo "  $(LIBPNG) (requires zlib to be installed)"
	@echo "  $(SQLITE)"
	@echo "  $(ZLIB)"
	@echo "  $(MXML)"
	@echo "  $(EXPAT)"
	@echo "  $(LIBXML2)"
	@echo "  $(OPENAL)"
	@echo "  $(JANSSON)"
	@echo "  $(PHYSFS) (requires zlib to be installed)"
	@echo "  $(LIBMAD)"
	@echo "  $(LIBOGG)"
	@echo "  $(LIBVORBIS) (requires libogg to be installed)"

$(FREETYPE): $(FREETYPE_SRC)
	@[ -d $(FREETYPE_VERSION) ] || tar -xaf $<
	@cd $(FREETYPE_VERSION) && \
	 ./configure --prefix=$(PORTLIBS) --host=arm-none-eabi --disable-shared --enable-static --without-harfbuzz
	@$(MAKE) -C $(FREETYPE_VERSION)

$(LIBEXIF): $(LIBEXIF_SRC)
	@[ -d $(LIBEXIF_VERSION) ] || tar -xaf $<
	@cd $(LIBEXIF_VERSION) && \
	 ./configure --prefix=$(PORTLIBS) --host=arm-none-eabi --disable-shared --enable-static
	@$(MAKE) -C $(LIBEXIF_VERSION)

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

# sqlite won't work with -ffast-math
$(SQLITE): $(SQLITE_SRC)
	@[ -d $(SQLITE_VERSION) ] || tar -xaf $<
	@cd $(SQLITE_VERSION) && \
	 CFLAGS="$(filter-out -ffast-math,$(CFLAGS)) -DSQLITE_OS_OTHER=1" ./configure --disable-shared --disable-threadsafe --disable-dynamic-extensions --host=arm-none-eabi --prefix=$(PORTLIBS)
	# avoid building sqlite3 shell
	@$(MAKE) -C $(SQLITE_VERSION) libsqlite3.la

$(ZLIB): $(ZLIB_SRC)
	@[ -d $(ZLIB_VERSION) ] || tar -xaf $<
	@cd $(ZLIB_VERSION) && \
	 CHOST=arm-none-eabi ./configure --static --prefix=$(PORTLIBS)
	@$(MAKE) -C $(ZLIB_VERSION)

$(MXML): $(MXML_SRC)
	@[ -d $(MXML_VERSION) ] || tar -xaf $<
	@cd $(MXML_VERSION) && \
	 ./configure --prefix=$(PORTLIBS) --host=arm-none-eabi --disable-shared --disable-threads
	@$(MAKE) -C $(MXML_VERSION) libmxml.a

$(EXPAT): $(EXPAT_SRC)
	@[ -d $(EXPAT_VERSION) ] || tar -xaf $<
	@cd $(EXPAT_VERSION) && \
	 ./configure --prefix=$(PORTLIBS) --host=arm-none-eabi --disable-shared --enable-static
	@$(MAKE) -C $(EXPAT_VERSION)

$(LIBXML2): $(LIBXML2_SRC)
	@[ -d $(LIBXML2_VERSION) ] || tar -xaf $<
	@cd $(LIBXML2_VERSION) && \
	 ./configure --prefix=$(PORTLIBS) --host=arm-none-eabi --disable-shared --enable-static
	@$(MAKE) -C $(LIBXML2_VERSION) libxml2.la

$(OPENAL): $(OPENAL_SRC)
	@[ -d $(OPENAL_VERSION) ] || tar -xaf $<
	@cd $(OPENAL_VERSION)/build && \
	cmake -DCMAKE_TOOLCHAIN_FILE=../../arm.cmake ..
	# ./configure --prefix=$(PORTLIBS) --host=arm-none-eabi --disable-shared --enable-static
	@$(MAKE) -C $(OPENAL_VERSION)

$(JANSSON): $(JANSSON_SRC)
	@[ -d $(JANSSON_VERSION) ] || tar -xaf $<
	@cd $(JANSSON_VERSION) && \
	 ./configure --prefix=$(PORTLIBS) --host=arm-none-eabi --disable-shared --enable-static
	@$(MAKE) -C $(JANSSON_VERSION)

$(PHYSFS): $(PHYSFS_SRC)
	@[ -d $(PHYSFS_VERSION) ] || tar -xaf $<
	@cd $(PHYSFS_VERSION) && \
	cmake -DCMAKE_TOOLCHAIN_FILE=../arm.cmake -DPHYSFS_HAVE_THREAD_SUPPORT=FALSE -DCMAKE_INSTALL_PREFIX=$(PORTLIBS) -DPHYSFS_BUILD_TEST=FALSE -DPHYSFS_BUILD_SHARED=FALSE -DPHYSFS_BUILD_STATIC=TRUE .
	# ./configure --prefix=$(PORTLIBS) --host=arm-none-eabi --disable-shared --enable-static
	@$(MAKE) -C $(PHYSFS_VERSION)

$(LIBMAD): $(LIBMAD_SRC)
	@[ -d $(LIBMAD_VERSION) ] || tar -xaf $<
	@cd $(LIBMAD_VERSION) && \
	 ./configure --prefix=$(PORTLIBS) --host=arm-none-eabi --disable-shared --enable-static
	@$(MAKE) -C $(LIBMAD_VERSION)

$(LIBOGG): $(LIBOGG_SRC)
	@[ -d $(LIBOGG_VERSION) ] || tar -xaf $<
	@cd $(LIBOGG_VERSION) && \
	 ./configure --prefix=$(PORTLIBS) --host=arm-none-eabi --disable-shared --enable-static
	@$(MAKE) -C $(LIBOGG_VERSION)

$(LIBVORBIS): $(LIBVORBIS_SRC)
	@[ -d $(LIBVORBIS_VERSION) ] || tar -xaf $<
	@cd $(LIBVORBIS_VERSION) && \
	 ./configure --prefix=$(PORTLIBS) --host=arm-none-eabi --disable-shared --enable-static
	@$(MAKE) -C $(LIBVORBIS_VERSION)

install-zlib: 
	@$(MAKE) -C $(ZLIB_VERSION) install

install:
	@[ ! -d $(FREETYPE_VERSION) ] || $(MAKE) -C $(FREETYPE_VERSION) install
	@[ ! -d $(LIBEXIF_VERSION) ] || $(MAKE) -C $(LIBEXIF_VERSION) install
	@[ ! -d $(LIBJPEGTURBO_VERSION) ] || $(MAKE) -C $(LIBJPEGTURBO_VERSION) install
	@[ ! -d $(LIBPNG_VERSION) ] || $(MAKE) -C $(LIBPNG_VERSION) install
	@[ ! -d $(SQLITE_VERSION) ] || $(MAKE) -C $(SQLITE_VERSION) install-libLTLIBRARIES install-data
	@[ ! -d $(MXML_VERSION) ] || $(MAKE) -C $(MXML_VERSION) install-libmxml.a
	@[ ! -d $(EXPAT_VERSION) ] || $(MAKE) -C $(EXPAT_VERSION) install
	@[ ! -d $(LIBXML2_VERSION) ] || $(MAKE) -C $(LIBXML2_VERSION) install
	@[ ! -d $(OPENAL_VERSION) ] || $(MAKE) -C $(OPENAL_VERSION) install
	@[ ! -d $(JANSSON_VERSION) ] || $(MAKE) -C $(JANSSON_VERSION) install
	@[ ! -d $(PHYSFS_VERSION) ] || $(MAKE) -C $(PHYSFS_VERSION) install
	@[ ! -d $(LIBMAD_VERSION) ] || $(MAKE) -C $(LIBMAD_VERSION) install
	@[ ! -d $(LIBOGG_VERSION) ] || $(MAKE) -C $(LIBOGG_VERSION) install
	@[ ! -d $(LIBVORBIS_VERSION) ] || $(MAKE) -C $(LIBVORBIS_VERSION)/lib install-libLTLIBRARIES install-data

clean:
	@$(RM) -r $(FREETYPE_VERSION)
	@$(RM) -r $(LIBEXIF_VERSION)
	@$(RM) -r $(LIBJPEGTURBO_VERSION)
	@$(RM) -r $(LIBPNG_VERSION)
	@$(RM) -r $(SQLITE_VERSION)
	@$(RM) -r $(ZLIB_VERSION)
	@$(RM) -r $(MXML_VERSION)
	@$(RM) -r $(EXPAT_VERSION)
	@$(RM) -r $(LIBXML2_VERSION)
	@$(RM) -r $(OPENAL_VERSION)
	@$(RM) -r $(JANSSON_VERSION)
	@$(RM) -r $(PHYSFS_VERSION)
	@$(RM) -r $(LIBMAD_VERSION)
	@$(RM) -r $(LIBOGG_VERSION)
	@$(RM) -r $(LIBVORBIS_VERSION)
