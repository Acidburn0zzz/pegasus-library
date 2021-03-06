(import (rnrs)
	(pegasus config)
	(pegasus formula)
	(pegasus package)
	(clos user)
	(util file)
	(getopt))

(define (main args)
  (with-args (cdr args)
      ((libs (#\l "lib") * '())
       (work (#\w "work-dir") #t ".")
       (target (#\t "target") #t "install"))
    (define install (make <install> :directories (map list libs)))
    (define formula (make <formula> :name "pegasus" :install install
			  :dependencies '()))
    (for-each (lambda (d)
		(copy-directory d (build-path (work-directory) d))) libs)
    (if (string=? target "remove")
	(remove-package formula)
	(install-package formula work))
    (delete-directory* (work-directory))))