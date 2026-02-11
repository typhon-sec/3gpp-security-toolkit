# A.5	HRES* and HXRES* derivation function

When deriving HRES* from RES* in the SEAF and when deriving HXRES* from XRES* in the AUSF the following parameters shall be used to form the input S to the SHA-256 hashing algorithm:
-	P0 = RAND,
-	P1 = RES* or XRES*,
The input S shall be equal to the concatenation P0||P1 of the P0 and P1.
The H(X)RES* is identified with the 128 least significant bits of the output of the SHA-256 function.
