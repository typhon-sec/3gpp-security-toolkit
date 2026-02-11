# A.19	UPU-MAC-IAUSF generation function

When deriving a UPU-MAC-IAUSF from KAUSF, the following parameters shall be used to form the input S to the KDF.
-	FC = 0x7B,
-	P0 = UE Parameters Update Data, i.e. UE parameters update list as given in clause 9.11.3.53A of TS 24.501 [35] (starting from octet 23),
-	L0 = length of UE Parameters Update Data
- 	P1 = CounterUPU
-	L1 = length of CounterUPU
The input key Key shall be KAUSF.
The UPU-MAC-IAUSF is identified with the 128 least significant bits of the output of the KDF.
