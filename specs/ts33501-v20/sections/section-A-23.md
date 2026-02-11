# A.23	KIAB generation function

This input string is used when the IAB-node and the IAB-donor derive KIAB (PSK) for establishment of secure F1 interface. The following parameters shall be used to form the input S to the KDF:
-	FC = 0x83,
-	P0 = IAB-donor-CU IP address,
-	L0 = length of IAB-donor-CU IP address,
- 	P1 = IAB-node DU IP address,
-	L1 = length of IAB-node DU IP address.
The input key KEY shall be KgNB, if the key KgNB is in possession of the IAB-UE functionality in the IAB-node and in the IAB-donor-CU (also when acts as MN for NR-DC scenario), after the IAB-UE setup procedure (Phase-1).
The input key KEY shall be S-KgNB, if the key S-KgNB is in possession of the IAB-UE functionality in the IAB-node and in the IAB-donor-CU (acts as a SN for EN-DC scenario), after dual connectivity procedure.
The input key KEY shall be KSN, if the key KSN is in possession of the IAB-UE functionality in the IAB-node and in the IAB-donor-CU (acts as a SN for NR-DC scenario), after dual connectivity procedure.
For P0, in case of CP-UP separation of IAB-donor-CU,
- 	P0 shall be set to IAB-donor-CU-CP IP address for deriving KIAB-CU-CP.
- 	P0 shall be set to IAB-donor-CU-UP IP address for deriving KIAB-CU-UP.
The entire output of the KDF (256 bits) is used as the KIAB or KIAB-CU-CP or KIAB-CU-UP..

######### Annex B (informative):
Using additional EAP methods for primary authentication

