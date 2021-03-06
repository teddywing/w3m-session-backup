w3m-session-backup.el
=====================

Save a list of [emacs-w3m][1] tabs from the “Crash recovery session” to a YAML
backup file. The format is similar to the one used in [Chrome Copy URLs From All
Tabs][2]. This provides a way to get the current list of ‘w3m’ tabs in a
portable format that can be searched or used elsewhere.


## Usage
Save a backup using:

	M-x w3m-session-backup

This can be bound to a key mapping in `w3m-mode` for faster access:

	(defun w3m-mode-config ()
	  (local-set-key (kbd "L") 'w3m-session-backup))
	
	(add-hook 'w3m-mode-hook 'w3m-mode-config)

The resulting file will look like:

	- page_title: 'Example'
	  url: 'http://example.com'
	- page_title: 'teddywing/w3m-session-backup'
	  url: 'https://github.com/teddywing/w3m-session-backup'


## Customise
By default, backup files get saved to the current directory. This can be changed
by setting the `w3m-session-backup-save-directory` variable:

	(setq w3m-session-backup-save-directory "~/backups")

The backup filename is generated by a function. By default, files will be named
using the current date, like this: `w3m-tabs-20180411-22h42m08.yml`. A custom
function can be used instead. For example:

	(setq w3m-session-backup-filename-function
	      (lambda ()
	        (format "w3m-tabs-%s.yml"
	                (format-time-string "%Y%m%d-%Hh%Mm%S"))))


## Requirements

* [emacs-w3m][1]


## Install
Download the [w3m-session-backup.el][3] file. Run

	M-x package-install-file

with the downloaded file.


## License
Copyright © 2018 Teddy Wing. Licensed under the GNU GPLv3+ (see the included
COPYING file).


[1]: https://github.com/ecbrown/emacs-w3m/
[2]: https://github.com/teddywing/chrome-copy-urls-from-all-tabs
[3]: https://raw.githubusercontent.com/teddywing/w3m-session-backup/master/w3m-session-backup.el
