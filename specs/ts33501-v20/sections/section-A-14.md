# A.14	KAMF to KASME' derivation for interworking


### A.14.1	Idle mode mobility

This input string is used when there is a need to derive K'ASME from KAMF during mapping of security contexts from 5G to EPS at idle mode mobility. The following input parameters shall be used.
-	FC = 0x73
-	P0 = NAS Uplink COUNT value
-	L0 = length of NAS Uplink COUNT value (i.e. 0x00 0x04)
The input key KEY shall be KAMF.

### A.14.2	Handover

This input string is used when there is a need to derive KASME' from KAMF during mapping of security contexts from 5G to EPS at handovers. The following input parameters shall be used.
-	FC = 0x74
-	P0 = NAS Downlink COUNT value
-	L0 = length of NAS Downlink COUNT value (i.e. 0x00 0x04)
The input key KEY shall be KAMF.
