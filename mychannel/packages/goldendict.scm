(define-module (mychannel packages goldendict)
  :use-module ((guix licenses) #:prefix license:)
  :use-module (guix packages)
  :use-module (guix download)
  :use-module (guix git-download)
  :use-module  (guix build-system copy)
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
  :use-module (gnu packages compression)
  :use-module (gnu packages hunspell)
  :use-module (gnu packages education)
  :use-module (gnu packages qt)
  :use-module (gnu packages version-control)
  :use-module (gnu packages textutils)
  :use-module (mychannel packages qtwebkit)
  :use-module (srfi srfi-1)
  )

(define-public goldendict
  (package
    (name "goldendict")
    (version "1.5.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/goldendict/goldendict/archive/refs/tags/" version  ".tar.gz"))
       (sha256
        (base32
         "0z1c86pcw52crmy1kiwp1kkv8a324handxf5zlkc0k77xilf1y7r"))))
    (build-system gnu-build-system)
    (native-inputs (list git pkg-config))
    (inputs
     (list bzip2 ffmpeg gcc glibc hunspell ao libeb libtiff libvorbis libx11 libxtst lzo opencc qtbase-5 qtmultimedia-5 qtsvg-5 qttools-5 qtwebkit qtx11extras xz zlib `(,zstd "lib")))

    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (replace 'configure
           (lambda* (#:key outputs inputs #:allow-other-keys)
             (invoke "qmake"
                     (string-append "QMAKE_LRELEASE=" (which "lrelease"))
                     (string-append "PREFIX=" (assoc-ref outputs "out"))
                     "CONFIG+=chinese_conversion_support"
                     "CONFIG+=zim_support"
                     "goldendict.pro")))
         )))
    (home-page "http://goldendict.org/")
    (synopsis "Feature-rich dictionary lookup program")
    (description "GoldenDict is a feature-rich dictionary lookup program, supporting multiple dictionary formats (StarDict/Babylon/Lingvo/Dictd/AARD/MDict/SDict) and online dictionaries, featuring perfect article rendering with the complete markup, illustrations and other content retained, and allowing you to type in words without any accents or correct case.")
    (license license:gpl3+)))


(define guixlicense (@@ (guix licenses) license))

(define* (unknow uri #:optional (comment ""))
  "Return a unknow license."
  (guixlicense "Unknow" uri comment))



(define-public latin-blatt1997
  (package
    (name "latin-blatt1997")
    (version "1.0")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://github.com/latin-dict/Blatt1997/releases/download/v1.0/Blatt1997-slob.zip"))
              (sha256
               (base32
                "153yfpa25s1j49hl2mfqg0bqyyzxni4j7dn9d7b9k4d5nr3jnb5b"))))
    (build-system copy-build-system)
    (native-inputs (list unzip))

    (arguments `(#:install-plan ,#~'(("Blatt1997-lat-lat.slob" "share/dict/") )))
    (synopsis "Vademecum in opus Saxonis et alia opera Danica compendium ex indice verborum")
    (description "Vademecum in opus Saxonis et alia opera Danica compendium ex indice verborum")
    (home-page "https://latin-dict.github.io/dictionaries/Blatt1997.html")
    ;; NOTE: The license of the work is unknow, but I'll put as public-domain for now.
    (license (unknow home-page "Authorship belongs to Franz Blatt (1903-1979) and Reimer Hemmingsen (1922-1998)."))))

(define-public latin-forcellini
  (package
    (name "latin-forcellini")
    (version "1.3")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://github.com/latin-dict/Forcellini/releases/download/v1.3/Forcellini-html.zip"))
              (sha256
               (base32
                "1r50730sh61f0bibvf7c3f44n7gip7cki2x5g1prv9rmqip0c5va"))))
    (build-system copy-build-system)
    (native-inputs (list unzip))

    (arguments `(#:install-plan ,#~'(("index.html" "share/dict/forcellini/") ("assets" "share/dict/forcellini/") )))
    (synopsis "Forcellinus Electronicus Novus")
    (description "Forcellinus Electronicus Novus (see Sources) is a monolingual Latin dictionary, but most of the articles additionally have short translations into Italian, French, Spanish, German and English languages.")
    (home-page "https://latin-dict.github.io/dictionaries/Forcellini.html")
    (license license:public-domain)))

(define-public latin-popma1865
  (package
    (name "latin-popma1865")
    (version "1.0")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://github.com/latin-dict/Popma1865/releases/download/v1.0/Popma1865-slob.zip"))
              (sha256
               (base32
                "00d2d4lh6wgw069p4biqdkxmmy16xvy91rh0vrgb7rw8y5ssh32s"))))
    (build-system copy-build-system)
    (native-inputs (list unzip))

    (arguments `(#:install-plan ,#~'(("Popma1865-lat-lat.slob" "share/dict/"))))
    (synopsis "De differentiis verborum, Popma (1865)")
    (description "Dictionary of Latin synonyms (“osculum” vs “suavium”), homonyms (“arundo” vs “hirundo”), or paronymous words (“cedere” vs “accedere”) explained in Latin. There are rare articles dedicated to Ancient Greek (Ἔπαινος vs Ἐγκώμιον), and sparse Italian, French, or German commentaries.")
    (home-page "https://latin-dict.github.io/dictionaries/Popma1865.html")
    (license license:public-domain)))

(define-public latin-richter1750
  (package
    (name "latin-richter1750")
    (version "1.0")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://github.com/latin-dict/Richter1750/releases/download/v1.0/Richter1750-slob.zip"))
              (sha256
               (base32
                "1cvb2v97bgc8bxix875s83kipv639czwi3cggln2spgx39hbjll3"))))
    (build-system copy-build-system)
    (native-inputs (list unzip))

    (arguments `(#:install-plan ,#~'(("Richter1750-lat-lat.slob" "share/dict/"))))
    (synopsis "Differentias quae in Ausonii Popmae De differentiis verborum libris amissae sunt")
    (description "Adam Daniel Richter (1709-1782) was an editor of the Popma’s dictionary printed in 1741. In 1750, he published an addition with list of 62 groups of Latin “synonyms” (in wide sense of the word).")
    (home-page "https://latin-dict.github.io/dictionaries/Richter1750.html")
    (license license:public-domain)))
