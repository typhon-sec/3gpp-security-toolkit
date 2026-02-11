# A.7	KAMF derivation function


### A.7.0	Parameters for the input S to the KDF

When deriving a KAMF from KSEAF the following parameters shall be used to form the input S to the KDF.
-	FC = 0x6D
-	P0 = IMSI or NAI or GCI or GLI
-	L0 = P0 length - number of octets in P0
-	P1 = ABBA parameter
-	L1 = P1 length - number of octets in P1
The input key KEY shall be the 256-bit KSEAF.
For P0, when the SUPI type is IMSI, P0 shall be set to IMSI as defined in clause 2.2 of TS 23.003 [19]. For P0, when the SUPI type is network specific identifier, the P0 shall be set to Network Access Identifier (NAI) as defined in clause 28.7.2 of TS 23.003 [19]. When the SUPI type is GLI, P0 shall be set to GLI taking format of NAI as defined in clause 28.16.2 of TS 23.003 [19]. When the SUPI type is GCI, P0 shall be set to GCI taking format of NAI as defined in clause 28.15.2 of TS 23.003 [19]. P0 shall be represented as a character string as specified in B.2.1.2 of TS 33.220 [28], for both SUPI types.
For ABBA parameter values please refer to clause A.7.1.

### A.7.1	ABBA parameter values

ABBA parameter is provided to the UE from SEAF and shall be used as an input parameter for KAMF derivation. To support flexible set of security features ABBA parameter is defined when security features change. To ensure forward compatibility, the ABBA parameter is a variable length parameter.
The SEAF shall set the ABBA parameter to 0x0000. The UE shall use the ABBA parameter provided by the SEAF in the calculation of KAMF.
The following values have been defined for this parameter.
Table A.7.1-1: ABBA parameter definitions
