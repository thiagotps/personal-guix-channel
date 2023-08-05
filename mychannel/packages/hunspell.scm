(define-module (mychannel packages hunspell)
  :use-module  (guix packages)
  :use-module  (guix download)
  :use-module  (guix gexp)
  :use-module  (guix build-system copy)
  :use-module  (gnu packages compression)
  :use-module  (guix licenses))


(define-public hunspell-la
  (package

    (name "hunspell-la")
    (version "2013.03.31")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://extensions.libreoffice.org/assets/downloads/z/dict-la-2013-03-31.oxt"))
              (sha256
               (base32
                "1ln26aka37j7vmmh4cmvfbqzp0k4hw6s1271mvxir2l57rpwcc6q"))))
    (build-system copy-build-system)
    (native-inputs (list unzip))
    (arguments `(#:phases (modify-phases %standard-phases (replace 'unpack
                                                            (lambda* (#:key source #:allow-other-keys)
                                                              "Unpack SOURCE in the working directory, and change directory within the source."
                                                              (begin
                                                                (invoke "unzip" source))
                                                              #true)
                                                            ))


                 #:install-plan ,#~'(("la/universal/la.aff" "share/hunspell/la_LA.aff") ("la/universal/la.dic" "share/hunspell/la_LA.dic"))))
    (synopsis "Latin hunspell dictionary")
    (description "Latin hunspell dictionary")
    (home-page "https://extensions.libreoffice.org/extensions/latin-spelling-and-hyphenation-dictionaries")
    (license gpl2+)))
