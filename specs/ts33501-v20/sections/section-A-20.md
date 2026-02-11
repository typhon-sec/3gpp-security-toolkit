# A.20	UPU-MAC-IUE/UPU-XMAC-IUE generation function

When deriving a UPU-MAC-IUE/UPU-XMAC-IUE from KAUSF, the following parameters shall be used to form the input S to the KDF.
-	FC = 0x7C,
-	P0 = 0x01 (UPU Acknowledgement: Verified the UE Parameters Update Data successfully)
-	L0 = length of UPU Acknowledgement (i.e. 0x00 0x01)
- 	P1 = CounterUPU
-	L1 = length of CounterUPU
The input key Key shall be KAUSF.
The UPU-MAC-IUE/UPU-XMAC-IUE is identified with the 128 least significant bits of the output of the KDF.
