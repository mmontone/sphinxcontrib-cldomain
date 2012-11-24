;; cldomain is a Common Lisp domain for the Sphinx documentation tool.
;; Copyright (C) 2011-2012 Russell Sim <russell.sim@gmail.com>

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(in-package :cl-user)

(defpackage :sphinxcontrib.cldomain
  (:use #:common-lisp #:getopt #:json)
  (:export #:main))

(in-package :sphinxcontrib.cldomain)

(defun argv ()
  (or
   #+SBCL sb-ext:*posix-argv*
   #+LISPWORKS system:*line-arguments-list*
   #+CMU extensions:*command-line-words*
   nil))

(defun print-message (message)
  (format t "~A~%" message))

(defun print-usage ()
  (format t "./cldomain.lisp --package <package name> --path <package path> ~%"))

(defun convert-classes-to-names (sym)
  (cond
    ((equal "EQL-SPECIALIZER" (symbol-name (class-name (class-of sym))))
     (slot-value sym 'SB-PCL::%TYPE))
    (t
     (swank-mop:class-name sym))))

(defun specializers (gf)
  (loop :for syms
        :in (mapcar #'swank-mop:method-specializers
                    (sb-mop:generic-function-methods gf))
        :collect (format nil "~S" (mapcar #'convert-classes-to-names syms))))

(defun intern* (symbol)
  "Take a symbol in the form of a string e.g. \"CL-GIT:GIT-AUTHOR\"
  and return the interned symbol."
  (destructuring-bind (package name)
      (loop :for i = 0 :then (1+ j)
            :as j = (position #\: symbol :start i)
            :when (subseq symbol i j)
              :collect (subseq symbol i j)
            :while j)
    (intern name package)))

(defun encode-when-object-member (type value)
  (when value (encode-object-member type value)))

(defun symbols-to-json (package)
  (let ((my-package (string-upcase package)))
    (let* ((swank::*buffer-package* (find-package 'CL-USER))
           (swank::*buffer-readtable* (copy-readtable)))
      (let ((package-symbols nil)
            (*json-output* *standard-output*))
        (with-object ()
          (dolist (sym (swank:apropos-list-for-emacs "" t nil my-package) package-symbols)
            (destructuring-bind  (&key designator macro function generic-function setf variable type)
                sym
                (let* ((symbol (intern* designator)))
                  (when (string= (package-name (symbol-package symbol))
                                 (string-upcase my-package))
                    (as-object-member ((symbol-name symbol))
                      (with-object ()
                        (dolist (sym `((macro ,macro)
                                       (function ,function)
                                       (generic-function ,generic-function)
                                       (setf ,setf)
                                       (variable ,variable)
                                       (type ,type)))
                          (let ((doc (if (eq (cadr sym) :not-documented)
                                         ""
                                         (cadr sym))))
                            (when doc
                              (encode-object-member (car sym) doc))))
                        (when (or function macro generic-function)
                          (encode-object-member 'arguments (format nil "~S" (swank::arglist symbol))))
                        (when generic-function
                          (let ((classes (specializers (symbol-function symbol))))
                            (encode-object-member 'specializers classes))))))))))))))

(defun main ()
  (multiple-value-bind (unused-args args invalid-args)
      (getopt:getopt (argv) '(("package" :required)("path" :required)))
    (cond
      (invalid-args
       (print-message "Invalid arguments")
       (print-usage))
      ((< 1 (length unused-args))
       (print-message "Unused args")
       (print-usage))
      ((= 2 (length args))
       (let ((package-path (truename (pathname (cdr (assoc "path" args :test #'equalp)))))
             (my-package (cdr (assoc "package" args :test #'equalp))))
         (push package-path asdf:*central-registry*)
         (let ((*standard-output* *error-output*))
           #+quicklisp
           (ql:quickload my-package :prompt nil)
           #-quicklisp
           (asdf:oos 'asdf:load-op my-package))
         (symbols-to-json my-package)))
      (t
       (print-message "missing args")
       (print-usage)))))
