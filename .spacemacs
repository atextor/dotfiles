;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs
   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused
   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation t ;; If non-nil layers with lazy install support are lazy installed.
   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()
   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(
     ;; ----------------------------------------------------------------
     ;; Example of useful layers you may want to use right away.
     ;; Uncomment some layer names and press <SPC f e R> (Vim style) or
     ;; <M-m f e R> (Emacs style) to install them.
     ;; ----------------------------------------------------------------
     helm
     (auto-completion :variables
                       auto-completion-complete-with-key-sequence "jk"
                       auto-completion-return-key-behavior nil
                       auto-completion-tab-key-behavior 'cycle)
     ;; better-defaults
     emacs-lisp
     colors
     git
     org
     (shell :variables
             shell-default-height 30
             shell-default-position 'bottom
			 shell-default-shell 'eshell)
     (spell-checking :variables
			 spell-checking-enable-by-default nil)
     c-c++
     syntax-checking
     evil-commentary
     emoji
     html
     java
     latex
     markdown
     nginx
     scala
     shell-scripts
     yaml
     smex
     semantic
	 ranger
	 search-engine
	 pdf-tools
     )
   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   dotspacemacs-additional-packages '(
     tabbar-ruler
     latex-preview-pane
   )
   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()
   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '()
   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and uninstall any
   ;; unused packages as well as their unused dependencies.
   ;; `used-but-keep-unused' installs only the used packages but won't uninstall
   ;; them if they become unused. `all' installs *all* packages supported by
   ;; Spacemacs and never uninstall them. (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration.
You should not put any user code in there besides modifying the variable
values."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t
   ;; Maximum allowed time in seconds to contact an ELPA repository.
   dotspacemacs-elpa-timeout 5
   ;; If non nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil
   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'.
   dotspacemacs-elpa-subdirectory nil
   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style 'vim
   ;; If non nil output loading progress in `*Messages*' buffer. (default nil)
   dotspacemacs-verbose-loading nil
   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner nil
   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `bookmarks' `projects' `agenda' `todos'."
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   dotspacemacs-startup-lists '((recents . 5)
                                (bookmarks . 5)
                                (projects . 7))
   ;; True if the home buffer should respond to resize events.
   dotspacemacs-startup-buffer-responsive t
   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode
   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press <SPC> T n to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(material
                         spacemacs-dark
                         spacemacs-light
                         solarized-dark
                         monokai
                         leuven
                         zenburn)
   ;; If non nil the cursor color matches the state color in GUI Emacs.
   dotspacemacs-colorize-cursor-according-to-state t
   ;; Default font, or prioritized list of fonts. `powerline-scale' allows to
   ;; quickly tweak the mode-line size to make separators look not too crappy.
   dotspacemacs-default-font '("Source Code Pro"
                               :size 16
                               :weight normal
                               :width normal
                               :powerline-scale 1.1)
   ;; The leader key
   dotspacemacs-leader-key "SPC"
   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"
   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","
   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m)
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   ;; The key used for Emacs commands (M-x) (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"
   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs C-i, TAB and C-m, RET.
   ;; Setting it to a non-nil value, allows for separate commands under <C-i>
   ;; and TAB or <C-m> and RET.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil
   ;; If non nil `Y' is remapped to `y$' in Evil states. (default nil)
   dotspacemacs-remap-Y-to-y$ nil
   ;; If non-nil, the shift mappings `<' and `>' retain visual state if used
   ;; there. (default t)
   dotspacemacs-retain-visual-state-on-shift t
   ;; If non-nil, J and K move lines up and down when in visual mode.
   ;; (default nil)
   dotspacemacs-visual-line-move-text nil
   ;; If non nil, inverse the meaning of `g' in `:substitute' Evil ex-command.
   ;; (default nil)
   dotspacemacs-ex-substitute-global nil
   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"
   ;; If non nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil
   ;; If non nil then the last auto saved layouts are resume automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil
   ;; Size (in MB) above which spacemacs will prompt to open the large file
   ;; literally to avoid performance issues. Opening a file literally means that
   ;; no major mode or minor modes are active. (default is 1)
   dotspacemacs-large-file-size 1
   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location nil
   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5
   ;; If non nil, `helm' will try to minimize the space it uses. (default nil)
   dotspacemacs-helm-resize nil
   ;; if non nil, the helm header is hidden when there is only one source.
   ;; (default nil)
   dotspacemacs-helm-no-header nil
   ;; define the position to display `helm', options are `bottom', `top',
   ;; `left', or `right'. (default 'bottom)
   dotspacemacs-helm-position 'bottom
   ;; Controls fuzzy matching in helm. If set to `always', force fuzzy matching
   ;; in all non-asynchronous sources. If set to `source', preserve individual
   ;; source settings. Else, disable fuzzy matching in all sources.
   ;; (default 'always)
   dotspacemacs-helm-use-fuzzy 'always
   ;; If non nil the paste micro-state is enabled. When enabled pressing `p`
   ;; several times cycle between the kill ring content. (default nil)
   dotspacemacs-enable-paste-transient-state nil
   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4
   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom
   ;; If non nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t
   ;; If non nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil
   ;; If non nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil
   ;; If non nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup t
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90
   ;; If non nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t
   ;; If non nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t
   ;; If non nil unicode symbols are displayed in the mode line. (default t)
   dotspacemacs-mode-line-unicode-symbols nil
   ;; If non nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t
   ;; If non nil line numbers are turned on in all `prog-mode' and `text-mode'
   ;; derivatives. If set to `relative', also turns on relative line numbers.
   ;; (default nil)
   dotspacemacs-line-numbers nil
   ;; Code folding method. Possible values are `evil' and `origami'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil
   ;; If non-nil smartparens-strict-mode will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil
   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc…
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis nil
   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all
   ;; If non nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil
   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `ag', `pt', `ack' and `grep'.
   ;; (default '("ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
   ;; The default package repository used if no explicit repository has been
   ;; specified with an installed package.
   ;; Not used for now. (default nil)
   dotspacemacs-default-package-repository nil
   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed'to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup nil
   ))

(defun dotspacemacs/user-init ()
  "Initialization function for user code.
It is called immediately after `dotspacemacs/init', before layer configuration
executes.
 This function is mostly useful for variables that need to be set
before packages are loaded. If you are unsure, you should try in setting them in
`dotspacemacs/user-config' first."

    ;; Squish warning about MANPATH https://github.com/syl20bnr/spacemacs/issues/3920
	(setq exec-path-from-shell-check-startup-files nil)
  )

(defun dotspacemacs/user-config ()
  "Configuration function for user code.
This function is called at the very end of Spacemacs initialization after
layers configuration.
This is the place where most of your configurations should be done. Unless it is
explicitly specified that a variable should be set before a package is loaded,
you should place your code here."

  ; Keybindings
  (define-key evil-normal-state-map (kbd "C-j") 'evil-scroll-down)
  (define-key evil-normal-state-map (kbd "C-k") 'evil-scroll-up)

  (define-key evil-normal-state-map (kbd "C-h") 'tabbar-ruler-backward)
  (define-key evil-normal-state-map (kbd "C-l") 'tabbar-ruler-forward)

  ; SPC b l to list buffers
  (evil-leader/set-key "bl" 'ibuffer)

  ; C-w is normally bound to evil-window-map
  (define-key evil-normal-state-map (kbd "C-w") 'kill-this-buffer)
  (global-set-key (kbd "C-w") 'kill-this-buffer)

  (define-key evil-normal-state-map (kbd "<f9>") 'delete-trailing-whitespace)

  ; LaTeX stuff
  ; Hide latex preview pane from minor modes list
  (diminish 'latex-preview-pane-mode)

  (defun next-pdf-page ()
	"Searches for the window with the open pdf document and scrolls down in it if available."
	(interactive)
	(mapc (lambda (window) (with-selected-window window (pdf-view-next-page-command 1)))
		  (-filter (lambda (window) (string= "pdf" (substring (buffer-name (window-buffer window)) -3))) (window-list))))

  (defun previous-pdf-page ()
	"Searches for the window with the open pdf document and scrolls up in it if available."
	(interactive)
	(mapc (lambda (window) (with-selected-window window (pdf-view-previous-page-command 1)))
		  (-filter (lambda (window) (string= "pdf" (substring (buffer-name (window-buffer window)) -3))) (window-list))))

  (define-key evil-normal-state-map (kbd "M-j") 'next-pdf-page)
  (define-key evil-normal-state-map (kbd "M-k") 'previous-pdf-page)

  ; Settings
  (setq-default
   tab-width 4
   c-basic-offset 4
   indent-tabs-mode t
   evil-move-beyond-eof nil
   compilation-window-height 13
   evil-shift-round nil
  )

  ; Enable line numbers
  (global-linum-mode)

  ; Set scrollof
  (setq scroll-margin 10)
  (add-hook 'term-mode-hook (lambda () (set (make-local-variable 'scroll-margin) 0)))
  (add-hook 'shell-mode-hook (lambda () (set (make-local-variable 'scroll-margin) 0)))
  (add-hook 'compilation-mode-hook (lambda () (set (make-local-variable 'scroll-margin) 0)))
  ;; (add-hook 'eshell-mode-hook (lambda () (setq-default 'scroll-margin 0)))
  ;; (add-hook 'messages-buffer-mode-hook (lambda () (setq-default 'scroll-margin 0)))
  ;; (add-hook 'inferior-emacs-lisp-mode-hook (lambda () (setq-default 'scroll-margin 0)))
  ;; (add-hook 'erc-mode-hook (lambda () (setq-local 'scroll-margin 0)))

  ; Set external browser
  (setq browse-url-browser-function 'browse-url-generic
		engine/browser-function 'browse-url-generic
        browse-url-generic-program "vivaldi")

  ; Add search engines
  (push '(dictcc
          :name "dict.cc"
          :url "http://www.dict.cc/?s=%s")
         search-engine-alist)

  ; Configure powerline
  (setq powerline-default-separator 'arrow-fade)

  ; Configure tabbar-ruler
  (setq mode-icons-change-mode-name nil)
  (mode-icons-mode)
  (tabbar-mode 1)
  (tabbar-ruler-forward)
  (setq tabbar-ruler-global-tabbar t)
  (setq tabbar-ruler-global-ruler nil)
  (setq tabbar-ruler-popup-menu nil)
  (setq tabbar-ruler-popup-toolbar nil)
  (setq tabbar-ruler-popup-scrollbar nil)
  (tabbar-ruler-group-buffer-groups)

  ; But don't use mode icons in helm buffers
  (remove-hook 'helm-mode-hook 'mode-icons-mode)
  (remove-hook 'helm-minibuffer-set-up-hook 'mode-icons-mode)

  ; Setup various mode specific settings
  (add-hook 'text-mode-hook 'auto-fill-mode)
  (add-hook 'makefile-mode-hook 'whitespace-mode)
  (add-hook 'c-mode-hook (lambda () (setq flycheck-clang-language-standard "c11")))
  (add-hook 'c-mode-hook (lambda () (setq flycheck-gcc-language-standard "c11")))
  (add-hook 'c-mode-hook (lambda () (setq flycheck-clang-include-path (list "/usr/include/SDL2"))))
  (add-hook 'pdf-view-mode-hook (lambda () (linum-mode 0)))

  ; Setup spell checking
  ; Use en_US and de_DE dictionaries
  (setq ispell-program-name "hunspell")
  (setq ispell-local-dictionary "de_DE")
  (setq ispell-local-dictionary-alist '(("de_DE" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "de_DE,en_US") nil utf-8)))

  ; Stop AUCTeX from creating 'auto' directory
  ; Somehow doesn't work this way. Need to investigate
  ;(setq TeX-auto-local nil)

  (org-babel-do-load-languages 'org-babel-load-languages
	 '((R . t) (sh . t) (shell . t) (emacs-lisp . t) (sparql . t)))

  ; Configure fill column indicator
;  (add-hook 'text-mode-hook (lambda ()
;                            (turn-on-auto-fill)
;                            (fci-mode)
;                            (set-fill-column 100)))
;
;  (add-hook 'LaTeX-mode-hook (lambda ()
;                              (turn-on-auto-fill)
;                              (fci-mode)
;                              (set-fill-column 85)))

)

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ispell-local-dictionary "de_DE")
 '(ispell-personal-dictionary "~/.dictionary")
 '(mode-icons
   (quote
	(("\\`CSS\\'" "css" xpm)
	 ("\\`Coffee\\'" "coffee" xpm-bw)
	 ("\\`Compilation\\'" "compile" xpm)
	 ("\\`Emacs-Lisp\\'" "emacs" xpm)
	 ("\\`Lisp Interaction\\'" "emacs" xpm)
	 ("\\`HTML\\'" "html" xpm)
	 ("\\`Haml\\'" "haml" xpm)
	 ("\\`Image\\[imagemagick\\]\\'" "svg" xpm)
	 ("\\`Inf-Ruby\\'" "infruby" xpm)
	 ("\\`Java[Ss]cript\\'" "js" xpm)
	 ("\\`Lisp\\'" "cl" xpm)
	 ("\\`nXML\\'" "xml" xpm)
	 ("\\`Org\\'" "org" xpm)
	 ("\\`PHP\\(\\|/.*\\)\\'" "php" xpm)
	 ("\\`Projectile Rails Server\\'" "rails" xpm)
	 ("\\`Python\\'" "python" xpm)
	 ("\\`Ruby\\'" "ruby" xpm)
	 ("\\`ESS\\[S\\]\\'" "R" xpm)
	 ("\\`ESS\\[SAS\\]\\'" "sas" xpm)
	 ("\\`ESS\\[BUGS\\]\\'" 61832 FontAwesome)
	 ("\\`iESS\\'" "R" xpm)
	 ("\\`SCSS\\'" "sass" xpm)
	 ("\\`Sass\\'" "sass" xpm)
	 ("\\`Scheme" "scheme" xpm-bw)
	 ("\\`Shell-script" "bash" xpm-bw)
	 ("\\`Slim" "slim" xpm-bw)
	 ("\\`Snippet" "yas" xpm)
	 ("\\`Term\\'" "term" xpm)
	 ("\\`Web\\'" "html" xpm)
	 ("\\`XML\\'" "xml" xpm)
	 ("\\`YAML\\'" "yaml" xpm)
	 ("\\` ?YASnippet\\'" "yas" xpm)
	 ("\\` ?yas\\'" "yas" xpm)
	 ("\\` ?hs\\'" "hs" xpm)
	 ("\\`Markdown\\'" 61641 github-octicons)
	 ("\\`GFM\\'" 61641 github-octicons)
	 ("\\`Scala\\'" 61787 font-mfizz)
	 ("\\`Magit\\'" 61906 FontAwesome)
	 ("\\` Pulls\\'" 61586 FontAwesome)
	 ("\\`Zip-Archive\\'" 61894 FontAwesome)
	 ("\\` ARev\\'" 61473 FontAwesome)
	 ("\\`Calc\\(ulator\\)?\\'" 61932 FontAwesome)
	 ("\\`Debug.*\\'" 61832 FontAwesome)
	 ("\\`Debug.*\\'" 61832 FontAwesome)
	 ("\\`Calendar\\'" 61555 FontAwesome)
	 ("\\`Help\\'" 61529 FontAwesome)
	 ("\\`WoMan\\'" 61530 FontAwesome)
	 ("\\`C\\(/.*\\|\\)\\'" 61703 font-mfizz)
	 ("\\`Custom\\'" 61459 FontAwesome)
	 ("\\`Go\\'" "go" xpm)
	 ("\\` ?Rbow\\'" "rainbow" xpm)
	 ("\\` ?ICY\\'" "icy" xpm)
	 ("\\` ?Golden\\'" "golden" xpm-bw)
	 ("\\`BibTeX\\'\\'" "bibtex" xpm-bw)
	 ("\\`C[+][+]\\(/.*\\|\\)\\'" 61708 font-mfizz)
	 ("\\`C[#]\\(/.*\\|\\)\\'" 61709 font-mfizz)
	 ("\\`Elixir\\'" 61717 font-mfizz)
	 ("\\`Erlang\\'" 61718 font-mfizz)
	 ("\\`Haskell\\'" 61734 font-mfizz)
	 ("\\`Clojure\\'" 61707 font-mfizz)
	 ("\\`Java\\(/.*\\|\\)\\'" 61739 font-mfizz)
	 ("\\`C?Perl\\'" 61768 font-mfizz)
	 ("\\`Octave\\'" "octave" xpm)
	 ("\\`AHK\\'" "autohotkey" xpm)
	 ("\\`Info\\'" 61530 FontAwesome)
	 ("\\` ?Narrow\\'" 61542 FontAwesome)
	 ("\\`Dockerfile\\'" "docker" xpm)
	 ("\\`Spacemacs buffer\\'" "spacemacs" png)
	 ("\\` ?emoji\\'" "emoji" png)
	 ("\\`Org-Agenda" 61510 FontAwesome)
	 ("\\`PS\\'" "powershell" xpm)
	 (mode-icons-powershell-p "powershell" xpm)
	 (mode-icons-cmd-p "cmd" xpm-bw)
	 (mode-icons-msys-p "msys" xpm)
	 (mode-icons-cygwin-p "cygwin" xpm)
	 (read-only 61475 FontAwesome)
	 (writable 61596 FontAwesome)
	 (save 61639 FontAwesome)
	 (saved "" nil)
	 (modified-outside 61553 FontAwesome)
	 (steal 61979 FontAwesome)
	 (apple 60095 IcoMoon-Free)
	 (apple 61817 FontAwesome)
	 (win 61818 FontAwesome)
	 (unix 60093 IcoMoon-Free)
	 (unix 61798 font-mfizz)
	 (unix 61820 FontAwesome)
	 (undecided 61736 FontAwesome)
	 ("Text\\'" 61686 FontAwesome)
	 ("\\` ?company\\'" 61869 FontAwesome)
	 ("\\` ?AC\\'" 61838 FontAwesome)
	 ("\\` ?Fly\\'" 59922 IcoMoon-Free)
	 ("\\` ?Ergo" 61724 FontAwesome)
	 ("\\` ?drag\\'" 61511 FontAwesome)
	 ("\\` ?Helm\\'" "helm" xpm-bw)
	 ("\\`Messages\\'" 62075 FontAwesome)
	 ("\\`Conf" 61918 FontAwesome)
	 ("\\`Fundamental\\'" 61462 FontAwesome)
	 ("\\`Javascript-IDE\\'" "js" xpm)
	 ("\\` Undo-Tree\\'" ":palm_tree:" emoji)
	 ("\\`LaTeX\\(/.*\\|\\)\\'" "tex" ext)
	 ("\\`Image\\[xpm\\]\\'" "xpm" ext)
	 ("\\`Image\\[png\\]\\'" "png" ext)
	 ("\\` ?AI\\'" 61500 FontAwesome)
	 ("\\` ?Isearch\\'" 61442)
	 ("\\`PDFView\\'" 61889 FontAwesome)
	 ("\\`EShell\\'" 61728 FontAwesome)
	 ("\\`GNUmakefile\\'" 61459 FontAwesome)
	 ("\\`N3/Turtle mode\\'" 61920 FontAwesome)
	 (default 61529 FontAwesome)
	 ("\\` ?\\(?:ElDoc\\|Anzu\\|SP\\|Guide\\|PgLn\\|Undo-Tree\\|Ergo.*\\|,\\|Isearch\\|Ind\\)\\'" nil nil))))
 '(pdf-latex-command "xxtex"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
