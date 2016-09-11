;;
;; File:     fix-omdoc.el
;; Purpose:  emacs macros to fix some translation errors
;;           
;; use in batch mode: 
;;          emacs -batch  <omdoc-file>  -l fix-omdoc.el -f save-buffer
;;
;; 



(defun fix-omdoc()
  (interactive)

  (fix-omdoc-OMS)
)


(defun fix-omdoc-OMS()
  (interactive)

  (beginning-of-buffer)
  (replace-string "\\[RawTab]" "")

  (replace-string "&#119987;" "X")

  (beginning-of-buffer)
  (while (re-search-forward "<OMS" nil 0) (delete-indentation t)
    )
  )

(fix-omdoc)

;; the end
