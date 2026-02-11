# A.6	KSEAF derivation function

When deriving a KSEAF from KAUSF, the following parameters shall be used to form the input S to the  KDF:
-	FC = 0x6C,
-	P0 = <serving network name>,
-	L0 = length of <serving network  name>.
The input key KEY shall be KAUSF.
The serving network name shall be constructed as specified in clause 6.1.1.4.
