# U.2	Procedure

Figure: U.2-1: Primary authentication using EAP-TTLS and AAA
0.	The UE is configured with the trust anchor needed to authenticate the certificate of the EAP-TTLS server running on the AUSF. Further, the UE is configured with the credentials required to authenticate with the AAA server.
Steps 1-17 are same as the steps 1-17 in clause B.2.2.1 in Annex B, except in the following steps:
1.	The SUPI in the NAI format, i.e., username@realm, is used.
5.	EAP-TTLS is selected by the UDM as the authentication method.
6-17. EAP-TTLS phase 1 is executed between the AUSF and the UE. EAP-Type is set to EAP-TTLS and the authentication of the UE using TLS client certificate is skipped. Since TLS client certificate is not used in EAP-TTLS, the UE need not be configured with UE certificate.
18-27.  After EAP-TTLS phase 1 is successfully completed, the UE runs EAP-TTLS phase 2 authentication with the AAA as specified in RFC 5281 [99] and RFC 9427 [120] via NSSAAF. The phase 2 authentication method used is outside the scope of the present document but MS-CHAPv2 is depicted here as an example to show that the Nnssaaf_AIW_Authentication service offered by NSSAAF carries AVPs if the phase 2 authentication method is non-EAP.
NOTE: 	As referenced in section 14.1.11 of RFC 5281 [99], allowing the use of phase 2 (inner) authentication method outside of tunnelled protocol leads to Man-in-the-Middle (MitM) vulnerability. Thus, it is assumed that the UE does not allow the use of phase 2 authentication method outside of TLS tunnel (i.e., the UE does not respond to requests for phase 2 authentication outside of the TLS tunnel). In environments where the use of phase 2 authentication outside of the tunnelled protocol cannot be prevented, EAP-TTLS implementations need to address this vulnerability by using EAP channel binding or cryptographic binding described in RFC 6678 [100].
28-31. After EAP-TTLS phase 2 authentication is successfully completed, the rest of the procedures are same as steps 18- 21 described in clause B.2.1.1, except that the EAP-Type is set to EAP-TTLS in the EAP Response message from the UE to the AUSF.

######### Annex V (normative): 
User consent requirements and mechanisms

