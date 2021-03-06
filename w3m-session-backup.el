;;; w3m-session-backup.el --- Backup the current W3m session to a file

;; Copyright (c) 2018–2019  Teddy Wing

;; Author: Teddy Wing
;; Version: 0.0.3
;; Package-Requires: ((w3m "1.4.609"))
;; Keywords: tools
;; URL: https://github.com/teddywing/w3m-session-backup

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Saves a YAML file backup of the current W3m "Crash recovery session".
;;
;; Tabs are saved in the following format:
;;
;;     - page_title: 'Title'
;;       url: 'http://example.com'

;;; Code:

(require 'subr-x)

(defgroup w3m-session-backup nil
  "w3m-session-backup customisations.")

;; Configurable save directory, default to current path
(defcustom w3m-session-backup-save-directory "."
  "Directory where backup files are saved. Defaults to the current path."
  :type 'directory
  :group 'w3m-session-backup
  :package-version '(w3m-session-backup . "0.0.1"))

(defcustom w3m-session-backup-filename-function 'w3m-session-backup--filename
  "Function that generates a filename for the session backup."
  :type 'function
  :group 'w3m-session-backup
  :package-version '(w3m-session-backup . "0.0.1"))


(defun w3m-session-backup--buffers ()
  "Crash recovery session list from `~/.w3m/.sessions`."
  (nth 2
       (first
        (w3m-load-list w3m-session-file))))

(defun w3m-session-backup--page-list ()
  "List of URL and page title tuples."
  (mapcar
   (lambda (buffer)
     (cons
      ;; URL
      (first buffer)

      ;; Page title
      (last buffer)))
   (w3m-session-backup--buffers)))

(defun w3m-session-backup--yml-escape (str)
  "YAML escape single quotes by doubling them."
  (replace-regexp-in-string
   (regexp-quote "'")
   "''"
   str
   'fixedcase
   'literal))

(defun w3m-session-backup--save-backup ()
  "Save the current w3m crash recovery session to a new YAML file."
  (with-temp-file
      (w3m-session-backup--save-to)
    (insert
     (string-join
      (mapcar
       (lambda (page)
         (format "- page_title: '%s'
  url: '%s'"
                 (w3m-session-backup--yml-escape (first (last page)))
                 (first page)))
       (w3m-session-backup--page-list))
      "\n"))))

(defun w3m-session-backup--filename ()
  "Generates a default filename using the current date & time."
  (format "w3m-tabs-%s.yml"
          (format-time-string "%Y%m%d-%Hh%Mm%S")))

(defun w3m-session-backup--save-to ()
  "Path to the file that the session YAML will be saved to."
  (concat
   (file-name-as-directory w3m-session-backup-save-directory)
   (funcall w3m-session-backup-filename-function)))


;;;###autoload
(defun w3m-session-backup ()
  "Save the current w3m crash recovery session to a new YAML file."
  (interactive)
  (w3m-session-backup--save-backup)
  (minibuffer-message
   (concat
    "Session saved to "
    (w3m-session-backup--save-to))))

(provide 'w3m-session-backup)

;;; w3m-session-backup.el ends here
