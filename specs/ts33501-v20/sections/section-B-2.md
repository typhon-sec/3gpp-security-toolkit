# B.2	Primary authentication and key agreement


### B.2.1	EAP TLS


#### B.2.1.1	Security procedures

EAP-TLS is a mutual authentication EAP method that can be used by the EAP peer and the EAP server to authenticate each other. It is specified in RFC 5216 [38] and  RFC 9190 [76]. The 3GPP TLS protocol profile related to supported TLS versions and supported TLS cipher suites in 3GPP networks is specified in clause 6.2 of TS 33.210 [3]. The 3GPP profile of TLS certificates is specified in clause 6.1.3a of TS 33.310 [5]. Guidance on the use of certificates in EAP-TLS is specified in RFC 9191 [119].
EAP-TLS supports several TLS versions, and the negotiation of the TLS version is part of EAP-TLS. The main principle of negotiation goes as follows. The EAP server indicates the support for EAP-TLS in the EAP-Request. If the peer chooses EAP-TLS, it responds with an EAP-Response indicating in the ClientHello message which TLS versions the peer supports. The EAP server chooses the TLS version, and indicates the chosen version in the ServerHello message.
The EAP-TLS procedure described in the RFC 5216 [38] is applicable to TLS 1.2 defined in RFC 5246 [40]. The EAP-TLS procedure described in the RFC 9190 [76] is applicable to TLS 1.3 defined in RFC 8446 [77].
The procedure below is based on the unified authentication framework from the present document, procedures from TS 23.502 [8] and RFC 5216 [38]. The procedure for EAP-TLS 1.2 and EAP-TLS 1.3 are presented here as examples, and other potential procedures are possible, e.g. if TLS resumption is used, or if EAP-TLS 1.2 is used with privacy.
Figure B.2.1.1-1: Using EAP-TLS 1.2 Authentication Procedures over 5G Networks for initial authentication
Figure B.2.1.1-2: Using EAP-TLS 1.3 Authentication Procedures over 5G Networks for initial authentication
1.	The UE sends the Registration Request message to the SEAF, containing SUCI. If the SUPI is in NAI format, only the username part of the NAI is encrypted using the selected protection scheme and included in the SUCI, together with the realm part in the NAI needed for UDM routing.
Privacy considerations are described in Clause B.2.1.2.
2.	The SEAF sends Nausf_UEAuthentication_Authenticate Request message to the AUSF. The SUCI and the serving network name (as described in clause 6.1.1.4) are included in the message.
3.	AUSF sends the the Nudm_UEAuthentication_Get Request, containing SUCI and the serving network name, to UDM. The general rules for UDM selection apply.
4.	The SIDF located within the UDM de-conceals the SUCI to SUPI if SUCI is received in the message. The UDM then selects the primary authentication method.
5. If the UDM chooses to use EAP-TLS, it sends the SUPI and an indicator to choose EAP-TLS to AUSF in the Nudm_UEAuthentication_Get Response.
6. With the received SUPI and the indicator, the AUSF chooses EAP-TLS as the authentication method. The AUSF sends thea Nausf_UEAuthentication_Authenticate Response message containing EAP-Request/EAP-TLS [TLS start] message to the SEAF.
7.	The SEAF forwards the EAP-Request/EAP-TLS [TLS start] in the Authentication Request message to the UE. This message also includes the ngKSI and the ABBA parameter. In fact, the SEAF shall always include the ngKSI and ABBA parameter in all EAP-Authentication request message. ngKSI will be used by the UE and AMF to identify the partial native security context that is created if the authentication is successful. The SEAF shall set the ABBA parameter as defined in Annex A.7.1. During an EAP authentication, the value of the ngKSI and the ABBA parameter sent by the SEAF to the UE shall not be changed.
8.	After receiving the EAP-TLS [TLS-start] message from SEAF, the UE replies with an EAP-Response/EAP-TLS [client_hello] to the SEAF in the Authentication Response message. The contents of TLS client_hello are defined in the TLS specification of the TLS version in use.
NOTE1:	The EAP framework supports negotiation of EAP methods. If the UE does not support EAP-TLS, it should follow the rule described in RFC 3748 [27] to negotiate another EAP method. In 5G system, UDM typically knows which EAP method and credentials are supported by the subscriber, and consequently EAP based negotiation may never be used.
9.	The SEAF forwards the EAP-Response/EAP-TLS [client hello] message to AUSF in the Nausf_UEAuthentication_Authenticate Request.
10.	The AUSF replies to the SEAF with EAP-Request/EAP-TLS in the Nausf_UEAuthentication_Authenticate Response, which further includes information elements such as server_hello, server_certificate, certificate_request etc. depending on the TLS version. These information elements are defined in the RFCs for the corresponding TLS version in use.
11.	The SEAF forwards the EAP-Request/EAP-TLS message with server_hello and other information elements to the UE through Authentication Request message. This message also includes the ngKSI and the ABBA parameter. The SEAF shall set the ABBA parameter as defined in Annex A.7.1.
12.	The UE authenticates the server with the received message from step 11.
NOTE 2: 	The UE is required to be pre-configured with a UE certificate and also certificates that can be used to verify server certificates.
13.	If the TLS server authentication is successful, then the UE replies with EAP-Response/EAP-TLS in Authentication Response message, which further contains information element such as client_certificate, client_certificate_verify, client_finished etc. depending on the TLS version. Privacy considerations are described in Clause B.2.1.2.
14.	The SEAF forwards the message with EAP-Response/EAP-TLS message with client_certificate and other information elements to the AUSF in the Nausf_UEAuthentication_Authenticate Request.
15.	The AUSF authenticates the UE based on the message received. The AUSF verifies that the client certificate provided by the UE belongs to the subscriber identified by the SUPI. If there is a miss-match in the subscriber identifiers in the SUPI, the AUSF does not accept the client certificate. If the AUSF has successfully verified this message, the AUSF continues to step 16, otherwise it returns an EAP-failure.
NOTE 2:	The AUSF is required to be pre-configured with the root or any intermediary CA certificates that can be used to verify UE certificates. Deployment of certificate revocation lists (CRLs) and online certificate status protocol (OCSP) are described in clause B.2.2.
16.	The AUSF sends EAP-Request/EAP-TLS message with information elements that depend on the TLS version  to the SEAF in the Nausf_UEAuthentication_Authenticate Response.
17.	The SEAF forwards EAP-Request/EAP-TLS message from step 16 to the UE with Authentication Request message. This message also includes the ngKSI and the ABBA parameter. The SEAF shall set the ABBA parameter as defined in Annex A.7.1.
18.	The UE sends an empty EAP-TLS message to the SEAF in Authentication Response message.
19.	The SEAF further forwards the EAP-Response/EAP-TLS message to the AUSF in the Nausf_UEAuthentication_Authenticate Request.
20.	The AUSF uses the most significant 256 bits of EMSK as the KAUSF and then calculates KSEAF from KAUSF as described in Annex A.6. The AUSF sends an EAP-Success message to the SEAF together with the SUPI and the derived anchor key in the Nausf_UEAuthentication_Authenticate Response.
21.	The SEAF forwards the EAP-Success message to the UE and the authentication procedure is finished. This message also includes the ngKSI and the ABBA parameter. The SEAF shall set the ABBA parameter as defined in Annex A.7.1. Then the SEAF derives the KAMF from the KSEAF, the ABBA parameter and the SUPI according to Annex A.7, and provides the ngKSI and the KAMF to the AMF.
On receiving the EAP-Success message, the UE derives EMSK and uses the most significant 256 bits of the EMSK as the KAUSF and then calculates KSEAF in the same way as the AUSF. The UE derives the KAMF from the KSEAF, the ABBA parameter and the SUPI according to Annex A.7.
NOTE 3:	Step 21 could be NAS Security Mode Command or Authentication Result.
NOTE 4: 	The ABBA parameter is included to enable the bidding down protection of security features that may be introduced later.
NOTE 5: As an implementation option, the UE creates the temporary security context as described in step 21 after receiving the EAP message that allows EMSK to be calculated. The UE turns this temporary security context into a partial security context when it receives the EAP Success. The UE removes the temporary security context if the EAP authentication fails.

#### B.2.1.2	Privacy considerations


##### B.2.1.2.1	EAP TLS without subscription identifier privacy

For EAP TLS, if the operator determines to not provide subscription identifier privacy for the UE in TLS layer (e.g., in TLS 1.2 without privacy option), the subscription identifier protection in NAS layer, i.e., in Step 1 of Figure B.2.1-1, becomes ineffective privacy-wise. Therefore, the operator may just choose that UE uses "null-scheme" for calculation of SUCI which is sent in NAS layer. However, the operator may anyway use other than null-schemes (e.g., one of ECIES schemes) for simplification of having single scheme for all UEs in NAS layer even though privacy is not enhanced in this particular case.
The operator could also determine not to provide subscription identifier privacy for the UE in NAS layer even though the TLS layer inherently provides subscription identifier privacy (e.g., in TLS 1.3). In such case, the operator may just choose that UE uses "null-scheme" for calculation of SUCI which is sent in NAS layer.

##### B.2.1.2.2	EAP TLS with subscription identifier privacy

For EAP TLS, if the operator determines to provide subscription identifier privacy for the UE in TLS layer, the the EAP TLS server needs to support privacy either inherently (e.g., in TLS 1.3) or via separate privacy option (e.g., in TLS 1.2). If privacy is an option in TLS layer, then the operator needs to configure UE with the information that privacy-on-TLS layer is enabled. Further, following considerations need to be taken.
In Step 1 of Figure B.2.1-1, it is important that calculation of SUCI, which is sent in NAS layer, is done using schemes other than "null-scheme". Otherwise, the subscription identifier protection provided by TLS layer becomes ineffective privacy-wise. Nevertheless, the "null-scheme" could be used in NAS layer while still preserving subscription identifier privacy, by omitting the username part from NAI as described in RFC 4282 clause 2.3 [y]. It would be analogous to using anonymous identifier in EAP, meaning that only realm part from NAI is included in SUCI which is sent in NAS layer. Thus formed SUCI can still be used to route the authentication request to AUSF.
In Step 13 and 14 of Figure B.2.1-1, when TLS 1.2 is used, the UE would need to behave as described in "Section 2.1.4. Privacy" of RFC 5216 [38] where instead of sending the client certificate in cleartext over the air, the UE first sends TLS certificate (no cert) and only later sends TLS certificate after a TLS is setup.

#### B.2.2	Revocation of subscriber certificates

Subscriber certificates that are used with EAP-TLS typically include static validity times. A certificate revocation list (CRL) as specified in RFC 5280 [48] and online certificate status protocol (OCSP) as specified in RFC 6960 [49] are means for the issuing certificate authority (CA) to revoke the certificates before their scheduled expiration date. In 5G security architecture, the UDM/ARPF is responsible for such subscriber status information. EAP-TLS peers and servers may also support Certificate Status Requests (OCSP stapling) as specified in RFC6066 [50] which allows peers to request the server's copy of the current status of certificates.
The deployment of CRLs is demonstrated in figure B.2.2-1. When the UDM/ARPF maintains the CRLs, the lists may be periodically updated to AUSFs, and stored locally in AUSF.
Figure B.2.2-1: AUSF requests CRL from UDM/ARPF
The deployment of OSCP is demonstrated in figure B.2.2-2. When the UDM/ARPF supports OCSP, the AUSF may check the certificate status online.
Figure B.2.2-2: AUSF requests the status of TLS certificate from UDM/ARPF
