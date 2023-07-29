(use-modules
 ((guix licenses) #:prefix license:)
 (guix packages)
 (guix download)
 (guix git-download)
 (guix build-system cmake)
 (guix build-system gnu)
 (guix build-system meson)
 (gnu packages qt)
 (guix build-system trivial)
 (guix build-system python)
 (guix build-system qt)
 (guix gexp)
 (guix packages)
 (guix deprecation)
 (guix utils)
 (gnu packages)
 (gnu packages bash)
 (gnu packages base)
 (gnu packages bison)
 (gnu packages check)
 (gnu packages cmake)
 (gnu packages compression)
 (gnu packages cpp)
 (gnu packages cups)
 (gnu packages curl)
 (gnu packages databases)
 (gnu packages documentation)
 (gnu packages elf)
 (gnu packages enchant)
 (gnu packages fontutils)
 (gnu packages flex)
 (gnu packages freedesktop)
 (gnu packages gcc)
 (gnu packages gdb)
 (gnu packages ghostscript)
 (gnu packages gl)
 (gnu packages glib)
 (gnu packages gnome)
 (gnu packages gnupg)
 (gnu packages gperf)
 (gnu packages graphics)
 (gnu packages gstreamer)
 (gnu packages gtk)
 (gnu packages icu4c)
 (gnu packages image)
 (gnu packages kde-frameworks)
 (gnu packages libevent)
 (gnu packages linux)
 (gnu packages llvm)
 (gnu packages maths)
 (gnu packages markup)
 (gnu packages networking)
 (gnu packages ninja)
 (gnu packages node)
 (gnu packages nss)
 (gnu packages pciutils)
 (gnu packages pcre)
 (gnu packages perl)
 (gnu packages pkg-config)
 (gnu packages pulseaudio)
 (gnu packages protobuf)
 (gnu packages python)
 (gnu packages python-build)
 (gnu packages python-xyz)
 (gnu packages python-web)
 (gnu packages regex)
 (gnu packages ruby)
 (gnu packages sdl)
 (gnu packages serialization)
 (gnu packages sqlite)
 (gnu packages telephony)
 (gnu packages tls)
 (gnu packages valgrind)
 (gnu packages video)
 (gnu packages vulkan)
 (gnu packages xdisorg)
 (gnu packages xiph)
 (gnu packages xorg)
 (gnu packages xml)
 (srfi srfi-1))



(package
 (name "qtwebkit")
 (version "5.212.0-alpha4")
 (source
  (origin
   (method url-fetch)
   (uri (string-append "https://github.com/qtwebkit/qtwebkit/releases/download/qtwebkit-" version "/qtwebkit-" version ".tar.xz"))
   (sha256
    (base32
     "1rm9sjkabxna67dl7myx9d9vpdyfxfdhrk9w7b94srkkjbd2d8cw"))
   (patches (map (lambda (x) (string-append "/home/thiago/guix/patches/" x))
                 (list "qtwebkit-pbutils-include.patch"
                 "qtwebkit-fix-building-with-bison-3.7.patch"
                 "qtwebkit-fix-building-with-glib-2.68.patch"
                 "qtwebkit-fix-building-with-icu-68.patch"
                 "qtwebkit-fix-building-with-python-3.9.patch")))
   ))
 (build-system cmake-build-system)
 (native-inputs
  (list perl
        python
        ruby
        bison
        flex
        gperf
        pkg-config))
 (inputs
  `(("icu" ,icu4c)
    ("glib" ,glib)
    ("gst-plugins-base" ,gst-plugins-base)
    ("libjpeg" ,libjpeg-turbo)
    ("libpng" ,libpng)
    ("libwebp" ,libwebp)
    ("sqlite" ,sqlite)
    ("fontconfig" ,fontconfig)
    ("libxrender" ,libxrender)
    ("qtbase" ,qtbase-5)
    ("qtdeclarative-5" ,qtdeclarative-5)
    ("qtlocation" ,qtlocation)
    ("qtmultimedia-5" ,qtmultimedia-5)
    ("qtsensors" ,qtsensors)
    ("qtwebchannel-5" ,qtwebchannel-5)
    ("libxml2" ,libxml2)
    ("libxslt" ,libxslt)
    ("libx11" ,libx11)
    ("libxcomposite" ,libxcomposite)))
 (arguments
  `(#:tests? #f ; no apparent tests; it might be necessary to set
                                        ; ENABLE_API_TESTS, see CMakeLists.txt

    ;; Parallel builds fail due to a race condition:
    ;; <https://bugs.gnu.org/34062>.
    #:parallel-build? #f

    #:configure-flags (list ;"-DENABLE_API_TESTS=TRUE"
                       "-DPORT=Qt"
                       "-DUSE_LIBHYPHEN=OFF"
                       "-DUSE_SYSTEM_MALLOC=ON"
                       ;; XXX: relative dir installs to build dir?
                       (string-append "-DECM_MKSPECS_INSTALL_DIR="
                                      %output "/lib/qt5/mkspecs/modules")
                       ;; Sacrifice a little speed in order to link
                       ;; libraries and test executables in a
                       ;; reasonable amount of memory.
                       "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,--no-keep-memory"
                       "-DCMAKE_EXE_LINKER_FLAGS=-Wl,--no-keep-memory"

                       ;; Added from the ArchLinux version
                       "-DENABLE_TOOLS=OFF"
                       "-DCMAKE_CXX_FLAGS=\"-DNDEBUG\""
                       )))
 (home-page "https://www.webkit.org")
 (synopsis "Web browser engine and classes to render and interact with web
content")
 (description "QtWebKit provides a Web browser engine that makes it easy to
embed content from the World Wide Web into your Qt application.  At the same
time Web content can be enhanced with native controls.")
 ;; Building QtWebKit takes around 13 hours on an AArch64 machine.  Give some
 ;; room for slower or busy hardware.
 (properties '((timeout . 64800)))   ;18 hours

 ;; XXX: This consumes too much RAM to successfully build on AArch64 (e.g.,
 ;; SoftIron OverDrive with 8 GiB of RAM), so instead of wasting resources,
 ;; disable it on non-Intel platforms.
 (supported-systems '("x86_64-linux" "i686-linux"))

 (license license:lgpl2.1+))
