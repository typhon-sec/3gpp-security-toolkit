# A.22	KTIPSec, KTNAP and KFT derivation function

When deriving a KTIPSec from KTNGF and when deriving a KTNAP or KFT from KTWIF or KTNGF the following parameters shall be used to form the input S to the KDF.
-	FC = 0x84
-	P0 = Usage type distinguisher
-	L0 = length of Usage type distinguisher (i.e. 0x00 0x01)
The values for the Usage type distinguisher are defined in table A.22-1. The values 0x00 and 0x03 to 0xf0 are reserved for future use, and the values 0xf1 to 0xff are reserved for private use.
The Usage type distinguisher shall be set to the value for IPSec (0x01) when deriving KTIPSec. The Usage type distinguisher shall be set to the value for TNAP (0x02) when deriving KTNAP. The Usage type distinguisher shall be set to the value for TNAP Key-refresh using FT (0x03) when deriving KFT.
The input key KEY shall be the 256-bit KTNGF or KTWIF.
Table A.22-1: Usage type distinguishers
