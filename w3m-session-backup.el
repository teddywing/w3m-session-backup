(defun my-w3m-session-backup ()
  "TODO"
  (mapcar
   (lambda (buffer)
     buffer)
   (nth 2
        (first
         (w3m-load-list w3m-session-file)))))

;; (first (nth 2
;;     (first
;;      (w3m-load-list w3m-session-file))))

(first (my-w3m-session-backup))
