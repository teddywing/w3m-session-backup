(defgroup w3m-session-backup nil
  "TODO")

;; Configurable save directory, default to current path
(defcustom save-directory "."
  "Directory where backup files are saved."
  :type 'directory
  :group 'w3m-session-backup
  :package-version '(w3m-session-backup . "0.0.1"))

(defcustom filename-function 'filename
  "Function that generates a filename for the session backup."
  :type 'function
  :group 'w3m-session-backup
  :package-version '(w3m-session-backup . "0.0.1"))


(defun buffers ()
  "TODO"
  (nth 2
       (first
        (w3m-load-list w3m-session-file))))

(defun my-w3m-session-backup ()
  "TODO"
  (mapcar
   (lambda (buffer)
     (cons
      ;; URL
      (first buffer)

      ;; Page title
      (last buffer)))
   (buffers)))

;; (first (nth 2
;;     (first
;;      (w3m-load-list w3m-session-file))))

(my-w3m-session-backup)

;; Write to file
  ;; https://stackoverflow.com/questions/2321904/elisp-how-to-save-data-in-a-file#2322164
;; Format some YAML text to write to the file
;; Configurable dynamic filename based on date-time

(defun yml-escape (str)
  "YAML escape single quotes by doubling them."
  (replace-regexp-in-string
   (regexp-quote "'")
   "''"
   str
   'fixedcase
   'literal))

(defun save-backup ()
  "TODO"
  (with-temp-file
      (concat
       (file-name-as-directory save-directory)
       (funcall filename-function))
    (insert
     (string-join
      (mapcar
       (lambda (page)
         (format "- page_title: '%s'
  url: '%s'"
                 (yml-escape (first (last page)))
                 (first page)))
       (my-w3m-session-backup))
      "\n"))))

(defun filename ()
  "Generates a default filename using the current date & time."
  (format "w3m-tabs-%s.yml"
          (format-time-string "%Y%m%d-%Hh%Mm%S")))

(save-backup)

;; Make filename customisable
