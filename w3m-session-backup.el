;;; w3m-session-backup.el --- Backup the current W3m session to a file

;; Copyright (c) 2018  Teddy Wing

;; Author: Teddy Wing
;; Version: 0.0.1
;; Package-Requires: ((w3m "TODO"))
;; Keywords: 
;; URL: 

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

(defgroup w3m-session-backup nil
  "TODO")

;; Configurable save directory, default to current path
(defcustom w3m-session-backup-save-directory "."
  "Directory where backup files are saved."
  :type 'directory
  :group 'w3m-session-backup
  :package-version '(w3m-session-backup . "0.0.1"))

(defcustom w3m-session-backup-filename-function 'filename
  "Function that generates a filename for the session backup."
  :type 'function
  :group 'w3m-session-backup
  :package-version '(w3m-session-backup . "0.0.1"))


(defun w3m-session-backup--buffers ()
  "TODO"
  (nth 2
       (first
        (w3m-load-list w3m-session-file))))

(defun w3m-session-backup--page-list ()
  "TODO"
  (mapcar
   (lambda (buffer)
     (cons
      ;; URL
      (first buffer)

      ;; Page title
      (last buffer)))
   (w3m-session-backup--buffers)))

;; (first (nth 2
;;     (first
;;      (w3m-load-list w3m-session-file))))

(w3m-session-backup--page-list)

;; Write to file
  ;; https://stackoverflow.com/questions/2321904/elisp-how-to-save-data-in-a-file#2322164
;; Format some YAML text to write to the file
;; Configurable dynamic filename based on date-time

(defun w3m-session-backup--yml-escape (str)
  "YAML escape single quotes by doubling them."
  (replace-regexp-in-string
   (regexp-quote "'")
   "''"
   str
   'fixedcase
   'literal))

(defun w3m-session-backup--save-backup ()
  "TODO"
  (with-temp-file
      (concat
       (file-name-as-directory w3m-session-backup-save-directory)
       (funcall w3m-session-backup-filename-function))
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

(w3m-session-backup--save-backup)

;; Make filename customisable

;; Make M-x command to write session backup

(defun w3m-session-backup ()
  "TODO"
  (interactive)
  (w3m-session-backup--save-backup))

;;; w3m-session-backup.el ends here
