(defmacro unit-of-time (value unit)
  `(* ,value
      ,(case unit
         ((s) 1)
         ((m) 60)
         ((h) 3600)
         ((d) 86400)
         ((ms) 1/1000)
         ((us) 1/1000000))))


(defunits% time s
  m 60
  h (60 m)
  d (24 h)
  ms (1/1000 s) 
  us (1/1000 ms))


(defun mkstr (&rest args)
  (with-output-to-string (s)
    (dolist (a args) (princ a s))))


(defun symb (&rest args)
  (values (intern (apply #'mkstr args))))


(macroexpand-1 '(defmacro! defunits% (quantity base-unit &rest units)
                 `(defmacro ,(symb 'unit-of- quantity) (,g!val ,g!un)
                    `(* ,,g!val
                        ,(case ,g!un
                           ((,base-unit) 1)
                           ,@(mapcar (lambda (x)
                                       `((,(car x)) ,(cadr x)))
                              (group units 2)))))))
