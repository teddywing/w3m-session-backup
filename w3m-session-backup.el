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

(defun save-backup ()
  "TODO"
  (with-temp-file "tmp-w3m-session.txt"
    (string-join
     (mapcar
      (lambda (page)
        (format "%s\n%s"
                (first page)
                (first (last page))))
      (my-w3m-session-backup))
     "\n\n")))
    ; (format
    ;  "%s\n%s\n\n"
    ;  )))

(save-backup)
