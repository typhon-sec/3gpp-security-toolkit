# A.2	KAUSF derivation function

This clause applies to 5G AKA only.
When deriving a KAUSF from CK, IK and the serving network name when producing authentication vectors, and when the UE computes KAUSF during 5G AKA, the following parameters shall be used to form the input S to the  KDF:
-	FC =  0x6A;
-	P0 = serving network  name;
-	L0 = length of the serving network name (variable length as specified in 24.501  [35]);
-	P1 = SQN   AK,
-	L1 = length of SQN  AK (i.e. 0x00 0x06).
The XOR of the Sequence Number (SQN) and the Anonymity Key (AK) is sent to the UE as a part of the Authentication Token (AUTN), see TS 33.102. If AK is not used, AK shall be treated in accordance with TS 33.102, i.e. as 000…0.
The serving network name shall be constructed as specified in clause 6.1.1.4.
The input key KEY shall be equal to the concatenation CK || IK of CK and IK.
