# A.11	KNG-RAN* derivation function for target gNB

When deriving a KNG-RAN* from current KgNB or from fresh NH and the target physical cell ID in the UE and NG-RAN  for handover purposes and transition from RRC_INACTIVE to RRC_CONNECTED states the following parameters shall be used to form the input S to the KDF.
-	FC = 0x70
-	P0 = PCI (target physical cell id)
-	L0 = length of PCI (i.e. 0x00 0x02)
-	P1 = ARFCN-DL (the absolute frequency of SSB of the target PCell as specified in clause 13.3 of TS 38.300 [52])
-	L1 = length of ARFCN-DL (i.e. 0x00 0x03)
The input key KEY shall be the 256-bit NH when the index NCC in the handover increases, otherwise the current 256-bit KgNB(when source is gNB) or KeNB (when source is ng-eNB).
