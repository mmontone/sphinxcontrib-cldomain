Release 0.14 2019-01-05
-----------------------

* lisp docstring collector was separated into a `cldomain utility`_
* fixed to work on Sphinx >= 1.8.
* fixed a warning that default value type for cl_systems is dictionary,
  but list is expected.

.. _cldomain utility: http://40ants.com/cldomain/

Release 0.13 2015-09-06
-----------------------
* updated com.dvlsoft.clon to net.didierverna.clon.

Release 0.12 2015-02-24
-----------------------
* fixed argument generation bug.

Release 0.11 2014-12-30
-----------------------
* support loading symbol information from multiple packages.

Release 0.10 2014-06-12
-----------------------
* added back parentheses to parameter lists.
* added type information to parameter list of methods.
* added links to other methods from a method docstring.
* fixed bug with macro documentation strings.
* added better keyword detection in documentation strings.
* fixed bug where symbols at the end of documentation
  strings were ignored.

Release 0.9 2014-02-10
----------------------
* fixed problem with version number generation.

Release 0.8 2014-02-10
----------------------
* fixed bug with lisps argument.
* removed dependency on swank.
* remove specializers symbols package if it's the current
  package.

Release 0.7 2013-06-12
----------------------
* started to make internals more modular.
* print specialisation for methods.
* add links to method specializers.
* added methods to index.

Release 0.6 2013-04-22
----------------------
* added more documentation.
* added better error handling when json fails to parse.
* methods can now pull documentation from their generic.

Release 0.5 2013-04-20
----------------------
* inherit environment when calling subprocesses.
* better handling of symbols in doc strings.

Release 0.4 2013-04-19
----------------------
* fixed some packaging bugs.
* made the data model more tolerant to missing symbols.
* fixed symbol resolving bug.
* added output of unused symbols.

Release 0.3 2013-04-16
-----------------------
* cleaned up specializer output.
* fixed bug when rendering specializers that have the form :KEYWORD
  SYMBOL.
* updated documentation.
* split out package code from lisp program.

Release 0.2 2013-04-14
-----------------------

* link between generics and specializers.
* ignore symbols in documentation if they are in the arg list.
* better Quicklisp support.
* handling of symbols that boarder on punctuation.

Release 0.1 UNRELEASED
----------------------

* initial prototype
