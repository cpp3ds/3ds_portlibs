3DS Portlibs
============

Here is a Makefile for building various portlibs for 3DS. You need to first
build zlib and install it. Then you can build the other portlibs.

    $ make zlib
    $ make install-zlib
    $ make <targets>
    $ make install

This will install the portlibs to `$DEVKITPRO/portlibs/armv6k`. If this is a
privileged location, you will need to `sudo make install-zlib` and `sudo make
install` in order for the portlibs to be installed.

Currently supports the following portlibs:

* freetype (requires zlib)
* libexif
* libjpeg-turbo
* libpng (requires zlib)
* sqlite
* zlib
* mxml
* expat
* libxml2
* jansson
* physfs
* libmad
* libogg
* libvorbis

Download links:

* [freetype-2.5.4.tar.bz2] (http://download.savannah.gnu.org/releases/freetype/freetype-2.5.4.tar.bz2)
*  [libexif-0.6.21.tar.bz2] (http://sourceforge.net/projects/libexif/files/libexif/0.6.21/libexif-0.6.21.tar.bz2/download)
* [libjpeg-turbo-1.3.1.tar.gz] (http://sourceforge.net/projects/libjpeg-turbo/files/1.3.1/libjpeg-turbo-1.3.1.tar.gz/download)
* [libpng-1.6.15.tar.xz] (http://prdownloads.sourceforge.net/libpng/libpng-1.6.15.tar.xz?download)
* [sqlite-autoconf-3080704.tar.gz] (http://www.sqlite.org/2014/sqlite-autoconf-3080704.tar.gz)
* [zlib-1.2.8.tar.gz] (http://prdownloads.sourceforge.net/libpng/zlib-1.2.8.tar.gz?download)
* [mxml-2.9.tar.gz] (http://www.msweet.org/files/project3/mxml-2.9.tar.gz)
* [expat-2.1.0.tar.gz] (http://sourceforge.net/projects/expat/files/expat/2.1.0/expat-2.1.0.tar.gz/download)
* [libxml2-2.9.2.tar.gz] (http://xmlsoft.org/sources/libxml2-2.9.2.tar.gz)
* [jansson-2.7.tar.gz] (http://www.digip.org/jansson/releases/jansson-2.7.tar.gz)
* [physfs-2.0.3.tar.bz2] (http://icculus.org/physfs/downloads/physfs-2.0.3.tar.bz2)
* [libmad-0.15.1b.tar.gz] (http://sourceforge.net/projects/mad/files/libmad/0.15.1b/libmad-0.15.1b.tar.gz/download)
* [libogg-1.3.2.tar.xz] (http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.xz)
* [libvorbis-1.3.5.tar.xz] (http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.5.tar.xz)