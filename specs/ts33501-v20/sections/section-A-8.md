# A.8	Algorithm key derivation functions

When deriving keys for NAS integrity and NAS encryption algorithms from KAMF in the AMF and UE or ciphering and integrity keys from KgNB/ KSN in the gNB and UE, the following parameters shall be used to form the string S.
-	FC = 0x69
-	P0 = algorithm type distinguisher
-	L0 = length of algorithm type distinguisher (i.e. 0x00 0x01)
-	P1 = algorithm identity
-	L1 = length of algorithm identity (i.e. 0x00 0x01)
The algorithm type distinguisher shall be N-NAS-enc-alg for NAS encryption algorithms and N-NAS-int-alg for NAS integrity protection algorithms. The algorithm type distinguisher shall be N-RRC-enc-alg for RRC encryption algorithms, N-RRC-int-alg for RRC integrity protection algorithms, N-UP-enc-alg for UP encryption algorithms and N-UP-int-alg for UP integrity protection algorithms (see table A.8-1). The values 0x00 and 0x07 to 0xf0 are reserved for future use, and the values 0xf1 to 0xff are reserved for private use.
Table A.8-1: Algorithm type distinguishers
The algorithm identity (as specified in clause 5) shall be put in the four least significant bits of the octet. The two least significant bits of the four most significant bits are reserved for future use, and the two most significant bits of the most significant nibble are reserved for private use. The entire four most significant bits shall be set to all zeros.
For the derivation of integrity and ciphering keys used between the UE and gNB, the input key shall be the 256-bit KgNB// KSN. For the derivation of integrity and ciphering keys used between the UE and AMF, the input key shall be the 256-bit KAMF.
For an algorithm key of length n bits, where n is less or equal to 256, the n least significant bits of the 256 bits of the KDF output shall be used as the algorithm key.
