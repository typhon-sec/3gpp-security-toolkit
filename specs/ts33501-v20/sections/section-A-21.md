# A.21	KAMF to KASME_SRVCC derivation for interworking

This input string is used when there is a need to derive KASME_SRVCC from KAMF during SRVCC from 5G to UTRAN CS. The following input parameters shall be used.
-	FC = 0x7D
-	P0 = NAS Downlink COUNT value
-	L0 = length of NAS Downlink COUNT value (i.e. 0x00 0x04)
The input key KEY shall be KAMF.
