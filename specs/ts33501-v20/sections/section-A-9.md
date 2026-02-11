# A.9	KgNB, KWAGF, KTNGF, KTWIF and KN3IWF derivation function

When deriving the keys KgNB, KWAGF, KTNGF, KTWIF and KN3IWF from KAMF and the uplink NAS COUNT in the UE and the AMF the following parameters shall be used to form the input S to the KDF.
-	FC = 0x6E
-	P0 = Uplink NAS COUNT
-	L0 = length of uplink NAS COUNT (i.e. 0x00 0x04)
- 	P1 = Access type distinguisher
-	L1 = length of Access type distinguisher  (i.e. 0x00 0x01)
The values for the access type distinguisher are defined in table A.9-1. The values 0x00 and 0x03 to 0xf0 are reserved for future use, and the values 0xf1 to 0xff are reserved for private use.
The access type distinguisher shall be set to the value for 3GPP (0x01) when deriving KgNB. The access type distinguisher shall be set to the value for non-3GPP (0x02) when deriving KN3IWF, KWAGF, KTWIF or KTNGF..
Table A.9-1: Access type distinguishers
The input key KEY shall be the 256-bit KAMF.
This function is applied when cryptographically protected 5G radio bearers are established and when a key change on-the-fly is performed.
As N5CW devices do not support NAS over non-3GPP access, the Uplink NAS COUNT shall be set to 0 for KTWIF key generation, see clause 7A.2.4. Similarly, the AUN3 devices do not support NAS over non-3GPP access, the Uplink NAS COUNT shall be set to 0 for KWAGF key generation, see clause 7B.7.3.
