;; Configurable save directory, default to current path
(setq save-directory ".")

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
       (filename))
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
