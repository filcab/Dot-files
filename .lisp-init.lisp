;; -*- mode: common-lisp -*-

#+(and (not asdf) (or allegro sbcl openmcl))
(require :asdf)
#-(and asdf allegro sbcl openmcl)
(load #p"/Users/filcab/dev/lisp/packages/asdf/asdf.lisp")

(pushnew #P"/Users/filcab/dev/lisp/aml/systems/"
         asdf:*central-registry* :test #'equal)
(pushnew #P"/Users/filcab/.asdf-install-dir/systems/"
         asdf:*central-registry* :test #'equal)
(pushnew #P"/Users/filcab/dev/lisp/packages/clsql-3.8.4/"
         asdf:*central-registry* :test #'equal)

(asdf:oos 'asdf:load-op :asdf-binary-locations)
(setq asdf:*centralize-lisp-binaries* t)

;; For cl-sql + PostgreSQL on Mac. Add the dir to the dyld search path
#+nil
(defmethod asdf:perform :after ((o asdf:load-op)
                                (c (eql (asdf:find-system 'clsql))))
  (let ((push-l-path (find-symbol (symbol-name '#:push-library-path)
				  (find-package 'clsql))))
    (dolist (path '(#p"/usr/lib/" #p"/Library/PostgreSQL8/lib/"))
      (funcall push-l-path path))))

;;; If the fasl was stale, try to recompile and load (once). Since only SBCL
;;; has a separate condition for bogus fasls we retry on any old error
;;; on other lisps. Actually, Allegro has a similar condition, but it's 
;;; unexported.  Works nicely for the ACL7 upgrade, though.
;;; CMUCL has an invalid-fasl condition as of 19c.
(defmethod asdf:perform :around ((o asdf:load-op) (c asdf:cl-source-file))
  (handler-case (call-next-method o c)
    (#+sbcl sb-ext:invalid-fasl 
     #+allegro excl::file-incompatible-fasl-error
     #+lispworks conditions:fasl-error
     #+cmu ext:invalid-fasl
     #-(or sbcl allegro lispworks cmu) error ()
     (asdf:perform (make-instance 'asdf:compile-op) c)
     (call-next-method))))

