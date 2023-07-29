(use-modules (guix packages)
             (guix git-download)
             (guix gexp)
             (guix build-system copy)
             (guix licenses))

(let ((version "0.1")
      (revision "1")
      (commit "447bfd96f664458ea976f16121faeefd6b6ff2e0"))
  (package

    (name "passmenu-otp")
    (version (git-version version revision commit))
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/thiagotps/passmenu-otp")
                    (commit commit)))
              (sha256
               (base32
                "00xkca7dljjsacqhs3xybpzj4pslas0f3pf7d1ywxyn1iim65h5z"))))
    (build-system copy-build-system)
    (arguments (list
                #:install-plan
                #~'(("passmenu-otp" "bin/"))
                ))
    (synopsis "My version of passmenu with support to OTP")
    (description
     "My version of passmenu with support to OTP")
    (home-page "https://github.com/thiagotps/passmenu-otp")
    (license gpl2)))
