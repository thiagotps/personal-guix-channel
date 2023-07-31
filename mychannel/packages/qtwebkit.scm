(define-module (mychannel packages qtwebkit)
  :use-module ((guix licenses) #:prefix license:)
  :use-module (guix packages)
  :use-module (guix download)
  :use-module (guix git-download)
  :use-module (guix build-system cmake)
  :use-module (guix build-system gnu)
  :use-module (guix build-system meson)
  :use-module (gnu packages qt)
  :use-module (guix build-system trivial)
  :use-module (guix build-system python)
  :use-module (guix build-system qt)
  :use-module (guix gexp)
  :use-module (guix packages)
  :use-module (guix deprecation)
  :use-module (guix utils)
  :use-module (gnu packages)
  :use-module (gnu packages bash)
  :use-module (gnu packages base)
  :use-module (gnu packages bison)
  :use-module (gnu packages check)
  :use-module (gnu packages cmake)
  :use-module (gnu packages compression)
  :use-module (gnu packages cpp)
  :use-module (gnu packages cups)
  :use-module (gnu packages curl)
  :use-module (gnu packages databases)
  :use-module (gnu packages documentation)
  :use-module (gnu packages elf)
  :use-module (gnu packages enchant)
  :use-module (gnu packages fontutils)
  :use-module (gnu packages flex)
  :use-module (gnu packages freedesktop)
  :use-module (gnu packages gcc)
  :use-module (gnu packages gdb)
  :use-module (gnu packages ghostscript)
  :use-module (gnu packages gl)
  :use-module (gnu packages glib)
  :use-module (gnu packages gnome)
  :use-module (gnu packages gnupg)
  :use-module (gnu packages gperf)
  :use-module (gnu packages graphics)
  :use-module (gnu packages gstreamer)
  :use-module (gnu packages gtk)
  :use-module (gnu packages icu4c)
  :use-module (gnu packages image)
  :use-module (gnu packages kde-frameworks)
  :use-module (gnu packages libevent)
  :use-module (gnu packages linux)
  :use-module (gnu packages llvm)
  :use-module (gnu packages maths)
  :use-module (gnu packages markup)
  :use-module (gnu packages networking)
  :use-module (gnu packages ninja)
  :use-module (gnu packages node)
  :use-module (gnu packages nss)
  :use-module (gnu packages pciutils)
  :use-module (gnu packages pcre)
  :use-module (gnu packages perl)
  :use-module (gnu packages pkg-config)
  :use-module (gnu packages pulseaudio)
  :use-module (gnu packages protobuf)
  :use-module (gnu packages python)
  :use-module (gnu packages python-build)
  :use-module (gnu packages python-xyz)
  :use-module (gnu packages python-web)
  :use-module (gnu packages regex)
  :use-module (gnu packages ruby)
  :use-module (gnu packages sdl)
  :use-module (gnu packages serialization)
  :use-module (gnu packages sqlite)
  :use-module (gnu packages telephony)
  :use-module (gnu packages tls)
  :use-module (gnu packages valgrind)
  :use-module (gnu packages video)
  :use-module (gnu packages vulkan)
  :use-module (gnu packages xdisorg)
  :use-module (gnu packages xiph)
  :use-module (gnu packages xorg)
  :use-module (gnu packages xml)
  :use-module (srfi srfi-1)

  )


(define-public qtwebkit
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
     (patches (search-patches
               "qtwebkit-pbutils-include.patch"
               "qtwebkit-fix-building-with-bison-3.7.patch"
               "qtwebkit-fix-building-with-glib-2.68.patch"
               "qtwebkit-fix-building-with-icu-68.patch"
               "qtwebkit-fix-building-with-python-3.9.patch"))
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

  )
