# A.10	NH derivation function

When deriving a NH from KAMF the following parameters shall be used to form the input S to the KDF.
-	FC = 0x6F
-	P0 = SYNC-input
-	L0 = length of SYNC-input (i.e. 0x00 0x20)
The SYNC-input parameter shall be the newly derived KgNB for the initial NH derivation, and the previous NH for all subsequent derivations. This results in a NH chain, where the next NH is always fresh and derived from the previous NH.
The input key KEY shall be the 256-bit KAMF.
