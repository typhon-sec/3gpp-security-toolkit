# A.4	RES* and XRES* derivation function

When deriving RES* from RES, RAND, and serving network name in the UE and when deriving XRES* from XRES, RAND, and the serving network name in the ARPF, the following parameters shall be used to form the input S to the KDF.
-	FC = 0x6B,
-	P0 = serving network name,
-	L0 = length of the serving network name (variable length as specified in 24.501 [35]),
-	P1 = RAND,
-	L1 = length of RAND (i.e. 0x00  0x10),
-	P2 = RES or XRES,
-	L2 = length RES or XRES (i.e. variable length between 0x00 0x04 and 0x00  0x10).
The input key KEY shall be equal to the concatenation CK || IK of CK and IK.
The serving network name shall be constructed as specified in clause 6.1.1.4.
The (X)RES* is identified with the 128 least significant bits of the output of the KDF.
