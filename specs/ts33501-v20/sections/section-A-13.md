# A.13	KAMF to KAMF'  derivation in mobility

Derivation of KAMF'  from KAMF during mobility shall use the following input parameters.
-	FC = 0x72
-	P0 =  DIRECTION
-	L0 = length of DIRECTION (i.e. 0x00 0x01)
-	P1 = COUNT,
-	L1 = length of COUNT (i.e. 0x00 0x04)
The input key KEY shall be KAMF.
When KAMF' is derived in handover, DIRECTION shall be 0x01 and COUNT shall be the downlink NAS COUNT of the 3GPP access.
When KAMF' is derived in idle mode mobility (i.e., mobility registration update), DIRECTION shall be 0x00 and COUNT shall be the uplink NAS COUNT of the 3GPP access used in the Registration Request.
