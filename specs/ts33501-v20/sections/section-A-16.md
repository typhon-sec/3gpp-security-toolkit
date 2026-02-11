# A.16	Derivation of KSN for dual connectivity

This input string is used when the MN and UE derive KSN during dual connectivity. The following input parameters shall be used:
-	FC =0x79,
-	P0 = Value of the SN Counter as a non-negative integer,
-	L0 = length of the SN Counter value (i.e. 0x00 0x02).
The input key KEY shall be KeNB when the MN is an ng-eNB and KgNB when the MN is a gNB.
NOTE: The same input string is used for both DC and SCPAC. Therefore, it is crucial that the SN Counter value input is never reused for the same KEY.
