# A.17	SoR-MAC-IAUSF generation function

When deriving a SoR-MAC-IAUSF from KAUSF, the following parameters shall be used to form the input S to the KDF.
-	FC = 0x77,
-	P0 = SoR  header,
-	L0 = length of SoR header,
- 	P1 =  CounterSoR,
-	L1 = length of  CounterSoR,
- 	P2 = octets included in SoR transparent container (in clause 9.11.3.51 of TS 24.501 [35]) beyond (and not including) octet 22,
-	L2 = length of list data included in P2
The input key KEY shall be KAUSF.
The selection of parameters included in P2 shall be the same as the selection of input to the Nausf_SoRProtection service operation. If none of these parameters are included in Nausf_SoRProtection service operation, P2 and L2 are not included for SoR-MAC-IAUSF generation.
The SOR header is either received from the requester NF (e.g UDM), or constructed by the AUSF, as described in clause 9.11.3.51 of TS 24.501 [35], based on the information received from the requester NF (e.g. UDM), i.e. ACK Indication and List of preferred PLMN/access technology combinations or secured packet (if provided).
The SoR-MAC-IAUSF is identified with the 128 least significant bits of the output of the KDF.
