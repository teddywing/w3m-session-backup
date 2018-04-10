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
