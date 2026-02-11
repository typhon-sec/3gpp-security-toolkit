# O.3	Authentication procedure

Figure O.3-1 shows the details of the authentication procedure as part of the initial registration procedure specified in clause 4.10a of TS 23.316 [79] following the principles listed in clause O.2. It uses EAP-TLS as an example, but other EAP methods can also be supported. The W-AGF acts on behalf of the N5GC device during the registration process. The link between the N5GC device and the RG, and between the RG and the W-AGF can be any data link (L2) that supports EAP encapsulation.
Figure O.3-1: Registration and authentication of a non-5G capable device to the 5GC
In the following, the procedure for registration and authentication of an N5GC device to the 5GC is described:
1.  The N5GC device connects to the W-AGF via a RG which is configured as a layer 2 bridge. The W-AGF is associated with a 5GC and acts on behalf of the N5GC device during its registration process.
2a. The W-AGF initiates the EAP authentication procedure by sending an EAP request/Identity to the N5GC device via the RG, which acts as an L2 bridge device and forwards the ethernet frame to the N5GC device. The EAP message is encapsualted inside an L2 frame (e.g., EAPOL).
2b. In response, the N5GC device sends back an EAP response/Identity including its Network Access Identifier (NAI) in the form of username@realm.
NOTE 1: If TLS subscription identifier privacy protection is supported , as in "Section 2.1.4. Privacy" of RFC 5216 [38] for TLS 1.2 or in RFC 8446 [60] for TLS 1.3, the "username" part must be is either omitted or "anonymous".
3. The W-AGF creates a registration request on behalf of the N5GC device with an indication that the registration is on behalf of an N5GC device. The SUPI of the N5GC device is the NAI as received from the device, and the W-AGF constructs the SUCI from this SUPI using the NULL scheme.
4a. The W-AGF selects the AMF/SEAF.
4b. The W-AGF sends to the AMF/SEAF a registration request on behalf of the N5GC device. The registration request includes the NAI SUCI, wireline network name if available, and a device capability indicator (e.g., the device is non-5G capable).
4c. The AMF/SEAF selects the AUSF based on the SUCI in the received registration request and sends a Nausf_UEAuthentication_Authenticate Request message to the AUSF. It contains the SUCI of the N5GC device, and an indicator that the request is on behalf of the N5GC device.
5a. The AUSF sends a Nudm_UEAuthentication_Get Request to the UDM. It contains the SUCI of the N5GC device and the N5GC device indicator.
5b. The UDM invokes the SIDF to map the SUCI to the SUPI and selects an authentication method, e.g., EAP-TLS, based on the SUPI. When the "username" part of the SUPI is "anonymous" or omitted, the UDM may select an authentication method based on the “realm” part of the SUPI, the N5GC device indicator, a combination of the "realm" part and the N5GC device indicator, or the UDM local policy.
5c. The UDM sends a Nudm_UEAuthentication_Get Response to the AUSF, which contains the SUPI of the N5GC device and an indicator of the selected authentication method, e.g., EAP-TLS. According to the N5GC device subscription data, the UDM shall also send the MSK indicator to the AUSF to indicate that the N5GC device does not support the 5G key hirerachy.
NOTE 2: Steps 6a-14c describe the exchange of EAP-TLS between the AUSF and the N5GC device, based on TLS 1.2 without subscription identifier privacy protection. If the operator determines to provide subscription identifier privacy for the N5GC in TLS layer, the EAP TLS server needs to support privacy either inherently (e.g., in TLS 1.3) or via separate privacy option (e.g., in TLS 1.2). When TLS 1.2 is used, the N5GC device would need to behave as described in "Section 2.1.4. Privacy" of RFC 5216 [38] where instead of sending the client certificate in cleartext over the air, the N5GC device sends TLS certificate (no cert) during the first TLS handshake and sends TLS certificate (client certificate) during the second TLS handshake within the TLS session negotiated form the first TLS handshake.
6a.  The AUSF starts EAP-TLS by sending to the AMF/SEAF a Nausf_UEAuthentication_Authenticate Response message containing an EAP-Request message of EAP-type=EAP-TLS with the Start (S) bit set, denoted as EAP-Request/EAP-TLS [TLS start].
6b.	The AMF/SEAF forwards the EAP-Request/EAP-TLS [TLS start] in the Authentication Request message to the W-AGF.
6c. After receiving the EAP-Request/EAP-TLS [TLS start] message from AMF/SEAF, the W-AGF forwards the EAP-Request/EAP-TLS [TLS start] message to the N5GC device in an L2 message, leaving out the ABBA and ngKSI parameters.
7a. After receiving the EAP-Request/EAP-TLS [TLS start] message from the W-AGF, the N5GC device replies to the W-AGF with an EAP-Response/EAP-TLS message whose data field encapsulates a TLS client_hello message. Such EAP-Response message, denoted as EAP-Response/EAP-TLS [client_hello], is encapsulated in an L2 message.
7b.	The W-AGF forwards the EAP-Response/EAP-TLS [client_hello] to the AMF/SEAF in an Authentication Response message.
7c.	The AMF/SEAF forwards the EAP-Response/EAP-TLS [client_hello] message to the AUSF in a Nausf_UEAuthentication_Authenticate Request message.
8a.	The AUSF replies to the AMF/SEAF with EAP-Request/EAP-TLS message whose data field encapsulates a TLS server_hello message, a TLS server certificate message, a TLS server_key_exchange message, a TLS client certificate_request message, and a TLS server_hello_done message. Such EAP-Request message, denoted as EAP-Request/EAP-TLS [server_hello], is encapsulated in a Nausf_UEAuthentication_Authenticate Response message.
8b.	The AMF/SEAF forwards the EAP-Request/EAP-TLS [server_hello] message to the W-AGF in an Authentication Request message.
8c. The W-AGF forwards the EAP-Request/EAP-TLS [server_hello] to the N5GC device in an L2 message.
9.	The N5GC device authenticates the AUSF by validating the server certificate included in the EAP-Request/EAP-TLS [server_hello] message received in step 8c. The N5GC device needs to be provisioned with certificates of a trust anchor to validate the AUSF server certificate. In addition, the N5GC device also needs to be provisioned with its own client certificate.
10a. If the TLS server authentication is successful, then the N5GC device replies to the W-AGF with EAP-Response/EAP-TLS in an L2 message. The data field of the EAP-Response/EAP-TLS message contains a TLS client certificate message, a TLS client_key_exchange message, a TLS certificate_verify message, a TLS change_cipher_spec message, and TLS finished message. This EAP-Response message is denoted as EAP-Response/EAP-TLS [client_certificate].
10b. The W-AGF forwards to the AMF/SEAF the EAP-Response/EAP-TLS [client_certificate] in an Authentication Response message.
10c. The AMF/SEAF forwards the EAP-Response/EAP-TLS [client_certificate] message to the AUSF in a Nausf_UEAuthentication_Authenticate Request message.
11.	The AUSF authenticates the N5GC device by verifying the client certificate received in the EAP-Response/EAP-TLS [client_certificate] message. Among other validations, the AUSF verifies that the client certificate is issued by a certificate authority trusted by the AUSF. If the client certificate is verified successfully, the AUSF continues to step 12a. Otherwise the AUSF returns an EAP-failure message. The AUSF needs to be provisioned with certificates of trust anchor to verify client certificates.
12a. The AUSF sends to the AMF/SEAF an EAP-Request/EAP-TLS message with its data field encapsulating a TLS change_cipher_spec message and a TLS server finished. This EAP-Request message, denoted as EAP-Request/EAP-TLS [server_finished], is encapsulated in a Nausf_UEAuthentication_Authenticate Response message.
12b. The AMF/SEAF forwards EAP-Request/EAP-TLS [server_finished] message to the W-AGF in an Authentication Request message.
12c. The W-AGF forwards EAP-Request/EAP-TLS [server_finished] message to the N5GC device in an L2 message.
13a. The N5GC sends to the W-AGF an EAP-Response/EAP-TLS message with its data field set to empty, denoted as EAP-Response/EAP-TLS [empty], in an L2 message
13b. The W-AGF forwards to the AMF/SEAF the EAP-Response/EAP-TLS [empty] message in an Authentication Response message.
13c. The AMF/SEAF forwards the EAP-Response/EAP-TLS [empty] message to the AUSF in a Nausf_UEAuthentication_Authenticate Request message.
14a. The AUSF sends to the AMF/SEAF an EAP-Success message and the MSK along with the SUPI in a Nausf_UEAuthentication_Authenticate Response message. If the SUPI received from the UDM in step 5c is anonymous, the AUSF derives the SUPI from the client identifier in the TLS client certificate. AUSF does not perform the derivation of KAUSF nor KSEAF based on the MSK indicator received in step 5c.
NOTE 2a:	It is left to implementation if the AUSF verifies that the SUPI derived from the client certificate belongs to a valid susbcription in the network and returns an EAP-failure message if there is a miss-match.
14b. The AMF/SEAF forwards to the W-AGF the EAP-Success message and the MSK in an Authentication Result message or a Security Mode Command message.
14c. The W-AGF forwards to the N5GC device the EAP-Success message in an L2 message, and the authentication procedure is finished.
NOTE 3:	Neither the AUSF nor the N5GC device performs further 5G related key derivation from EMSK, since neither 5G AS nor 5G NAS security is used in this setting.
15. The AUSF sends a UDM_Nudm_UEAuthentication_ResultConfirmation Request message to the UDM, including the SUPI obtained from the TLS client certificate, SN-name, the authentication method (i.e., EAP-TLS), the authentication result, and a timestamp.
16. The UDM stores the authentication result accordingly.
17. The UDM sends a UDM_Nudm_UEAuthentication_ResultConfirmation Response message to the AUSF.
18. The AMF sends a Nudm_UEContextManagement_Registration Request message to the UDM.
19. The UDM authorizes the registration request based on authentication result stored in step 16 and other information (e.g., UE subscription profile).
20. The UDM sends a Nudm_UEContextManagement_Registration Response message to the AMF.
21. The AMF sends Registration Accept message to the W-AGF

######### Annex P (informative):
Security Aspects of DNS and ICMP

