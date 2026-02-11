# A.18	SoR-MAC-IUE/SoR-XMAC-IUE generation function

When deriving a SoR-MAC-IUE/SoR-XMAC-IUE from KAUSF, the following parameters shall be used to form the input S to the KDF.
-	FC = 0x78,
-	P0 = 0x01 (SoR Acknowledgement: Verified the Steering of Roaming Information  successfully),
-	L0 = length of SoR Acknowledgement (i.e. 0x00 0x01),
- 	P1 =  CounterSoR,
-	L1 = length of  CounterSoR.
The input key KEY shall be KAUSF.
The SoR-MAC-IUE/SoR-XMAC-IUE is identified with the 128 least significant bits of the output of the KDF.
