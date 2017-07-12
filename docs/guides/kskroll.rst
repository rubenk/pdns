KSK Rollover
============

Before attempting a KSK rollover, please read `RFC 6581 "DNSSEC
Operational Practices, Version 2", section
4 <https://tools.ietf.org/html/rfc6781#section-4>`__ carefully to
understand the terminology, actions and timelines (TTL and RRSIG expiry)
involved in rolling a KSK.

This How To describes the "Double-Signature Key Signing Key Rollover"
from the above mentioned RFC.

To start the rollover, add an **active** new KSK to the zone
(example.net in this case):

::

    pdnsutil add-zone-key example.net ksk active

Note that a key with same algorithm as the KSK to be replaced should be
created, as this is not an algorithm roll over.

If this zone is of the type 'MASTER', increase the SOA serial. The
rollover is now in the "New KSK" stage. Retrieve the DS record(s) for
the new KSK:

::

    pdnsutil show-zone example.net

And communicate this securely to your registrar/parent zone. Now wait
until the new DS is published in the parent zone and at least the TTL
for the DS records has passed. The rollover is now in the "DS Change"
state and can continue to the "DNSKEY Removal" stage by actually
deleting the old KSK.

**Note**: The key-id for the old KSK is shown in the output of
``pdnsutil show-zone example.net``.

::

    pdnsutil remove-zone-key example.net KEY-ID

The rollover is now complete.
