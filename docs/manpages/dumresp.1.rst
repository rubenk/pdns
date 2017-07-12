NAME
====

**dumresp** - A dumb DNS responder

SYNOPSIS
========

**dumresp** *LOCAL-ADDRESS* *LOCAL-PORT* *NUMBER-OF-PROCESSES*

DESCRIPTION
===========

**dumresp** accepts DNS packets on *LOCAL-ADDRESS*:*LOCAL-PORT* and
simply replies with the same query, with the QR bit set. When
*NUMBER-OF-PROCESSES* is set to anything but 1, **dumresp** will spawn
*NUMBER-OF-PROCESSES* forks and use the SO\_REUSEPORT option to bind to
the port.

OPTIONS
=======

None

SEE ALSO
========

socket(7)
