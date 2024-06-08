Math Library Readme
===================

This folder defines a minimal math library for R6RS Scheme. It doesn't aim to be fast or exhaustive. Instead it defines a collection of mathematics libraries that I've used on various projects.

This projecthas been tested using Guile Scheme. To use this library from Guile run the following:

```bash
$ cd ..
$ ls
... math ...
$ guile -L .
scheme@(guile-user)> (import (math evidence))
```
