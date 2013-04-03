
# GalaxyAPI version 0.01
The [Galaxy](http://www.galaxyproject.org) application provides an application programming 
interface ([API](http://wiki.galaxyproject.org/Learn/API)) to export the data structures for 
external use.  This software provides programmatic access for Perl developers without the 
need to author their own custom solution.

## Installation

To install this module type the following:

```bash
perl Makefile.PL
make
make test
make install
```

## Dependencies

This module requires these other modules and libraries:
```text
Exporter
HTTP::Cookies
HTTP::Status
JSON
REST::Client
Scalar:Util
URI::Split
```
and very possibly others on which they depend...

## Copyright and Licence

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

Above all, make sure it copied right and lies make sense.

