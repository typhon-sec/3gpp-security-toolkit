# A.15	KASME to KAMF' derivation for interworking


### A.15.1	Idle mode mobility

This input string is used when there is a need to derive  KAMF' from KASME during mapping of security contexts from EPS to 5G at idle mode mobility. The following input parameters shall be used.
-	FC = 0x75
-	P0 = NAS Uplink COUNT value of the TAU message included in the Registration Request message
-	L0 = length of NAS Uplink COUNT value of the TAU message included in the Registration Request message (i.e. 0x00 0x04)
The input key KEY shall be KASME.

### A.15.2	Handover

This input string is used when there is a need to derive KAMF' from KASME during mapping of security contexts from EPS to 5G at handovers. The following input parameters shall be used.
-	FC = 0x76
-	P0 = NH value
-	L0 = length of NH value (i.e. 0x00 0x20)
The input key KEY shall be KASME.
