Using ALIAS records
===================

The ALIAS record provides a way to have CNAME-like behaviour on the zone
apex.

In order to correctly serve ALIAS records in PowerDNS Authoritative
Server 4.1.0 or higher, set the ```resolver`` <settings.md#resolver>`__
setting to an existing resolver and enable
```expand-alias`` <settings.md#expand-alias>`__:

::

    resolver=[::1]:5300
    expand-alias=yes

**note**: If ``resolver`` is unset, ALIAS expension is disabled!

**note**: In PowerDNS Authoritative Server 4.0.x, the setting
```recursor`` <settings.md#recursor>`__ is used instead, and you should
omit the ```expand-alias`` <settings.md#expand-alias>`__ setting. Note
that setting ```recursor`` <settings.md#recursor>`__ will allow
recursive queries to all clients by default, which you likely do not
want for security reasons, so you should restrict this:

::

    recursor=[::1]:5300
    allow-recursion=::1, 127.0.0.1

Then add the ALIAS record to your zone apex. e.g.:

::

    $ORIGIN example.net
    $TTL 1800

    @ IN SOA ns1.example.net. hostmaster.example.net. 2015121101 1H 15 1W 2H

    @ IN NS ns1.example.net.

    @ IN ALIAS mywebapp.paas-provider.net.

When the authoritative server receives a query for the A-record for
``example.net``, it will resolve the A record for
``mywebapp.paas-provider.net`` and serve an answer for ``example.net``
with that A record.

When a zone containing ALIAS records is transferred over AXFR, the
```outgoing-axfr-expand-alias`` <settings.md#outgoing-axfr-expand-alias>`__
setting controls the behaviour of ALIAS records. When set to 'no' (the
default), ALIAS records are sent as-is (RRType 65401 and a DNSName in
the RDATA) in the AXFR. When set to 'yes', PowerDNS will lookup the A
and AAAA records of the name in the ALIAS-record and send the results in
the AXFR.

Set ``outgoing-axfr-expand-alias`` to 'yes' if your slaves don't
understand ALIAS or should not look up the addresses themselves. Note
that slaves will not automatically follow changes in those A/AAAA
records unless you AXFR regularly.

**note:** The ``expand-alias`` setting does not exist in PowerDNS
Authoritative Server 4.0.x. Hence, ALIAS records are always expanded on
a direct A or AAAA query.

ALIAS and DNSSEC
----------------

Starting with the PowerDNS Authoritative Server 4.0.0, DNSSEC 'washing'
of ALIAS records is supported on AXFR (**not** on live-signing). Set
``outgoing-axfr-expand-alias`` to 'yes' and enable DNSSEC for the zone
on the master. PowerDNS will sign the A/AAAA records during the AXFR.


