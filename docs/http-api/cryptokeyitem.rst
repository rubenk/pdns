Cryptokeys
==========

CryptoKey
---------

.. json:object:: CryptoKey

  :param string type: "Cryptokey"

      "id": <int>,
      "active": <bool>,
      "keytype": <keytype>,
      "dnskey": <string>,
      "privatekey": <string>,
      "ds": [ <ds>,
              <ds>,
              .... ]
    }

Parameters:
'''''''''''

``id``: read-only.

``keytype``: ``<keytype>`` is one of the following: ``ksk``, ``zsk``,
``csk``.

``dnskey``: the DNSKEY for this key

``ds``: an array with all DSes for this key

``privatekey``: private key data (in ISC format).
