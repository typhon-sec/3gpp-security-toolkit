# 7A	Security for trusted non-3GPP access to the 5G core network


### 7A.1	General

Security for trusted non-3GPP access to the 5G Core network is achieved when the UE registers to the 5GC via the TNAN. The UE registers to 5GC and, at the same time, it authenticates with the TNAN by using the EAP-5G procedure, similar to the one used with the registration procedure for untrusted non-3GPP access.
The link between the UE and the TNAN can be any data link (L2) that supports EAP encapsulation. The requirement on the Ta interface between the TNAP and TNGF can be found in clause 4.2.8.3.2 of TS 23.501[2]. The TNGF terminates the EAP-5G signalling andfowards the NAS message to the 5GC when the UE attempts to register to 5GC via the TNAN. The security relies on Layer-2 security between UE and TNAP, which is a trusted entity so that no IPSec encryption would be necessary between UE and TNGF, i.e. NULL encryption is sufficient for the user plane and signalling. However, integrity protection would be provided.
NOTE: The encryption protection over Layer-2 between UE and TNAP is assumed to be enabled.
During IPSec IKE negotiations the UE and TNGF may negotiate MOBIKE support as specified in RFC 4555[111], this would facilitate quick re-establishment IPSec connection and any associated SAs later if needed. Separate IPSec SAs may be used for NAS transport and PDU Sessions. At the end of the UE’s registration to 5GC, an IPSec SA (NWt) is established between the UE and TNGF. This is used to protect NAS messages between the UE and TNGF. Later when the UE initiates a PDU session establishment, the TNGF initiates establishment of one or more IPSec child SAs per PDU session. This results in additional IPSec SA’s (NWt) to be setup between the UE and TNGF-UP which are then for user plane transport between the two.
Clause 7A.2.1.2 describes when UE reconnects from one TNAP to another TNAP connecting to the same TNGF, authentication of UE from the previous context without performing the full primary authentication.
Clause 7A.2.4 describes how WLAN UEs that do not support 5GC NAS (N5CW) register via trusted non-3GPP access. Those N5CW devices are able to authenticate to the network with 3GPP credentials and register with the help of an interworking function (TWIF) that provides the 5GC NAS protocol stack towards the AMF.
Clause 7A.2.4.2 describes how WLAN UEs that do not support 5GC NAS (N5CW) moves from one TNAP to another TNAP connecting to the same TWIF without performing the full primary authentication.
As defined in clause 7.1, it is the home operator policy decision if a non-3GPP access network is treated as trusted non-3GPP access network. When all of the security domains in clause 4.1 of the present specification related to the non-3GPP access network are considered sufficiently secure by the home operator, the non-3GPP access may be identified as a trusted non-3GPP access for that operator. However, this policy decision may additionally be based on reasons not related to security feature groups.
NOTE: It is specified in clause 7.1a of the current document how the UE gets the operator policy and how it will behave accordingly.

### 7A.2	Security procedures


#### 7A.2.1	Authentication for trusted non-3GPP access


##### 7A.2.1.1	General

This clause specifies how a UE is authenticated to 5G network via a trusted non-3GPP access network.
This is based on the specified procedure in TS 23.502 [8] clause 4.12a.2.2 "Registration procedure for trusted non-3GPP access". The authentication procedure is similar to the authentication procedure for Untrusted non-3GPP access defined in clause 7.2.1 with few differences, which are mentioned below:
Figure 7A.2.1-1: Registration \ Authentication and PDU Session establishment for trusted non-3GPP access
0.	The UE selects a PLMN and a TNAN for connecting to this PLMN by using the Trusted Non-3GPP Access Network selection procedure specified in TS 23.501 [2] clause 6.3.12. During this procedure, the UE discovers the PLMNs with which the TNAN supports trusted connectivity (e.g. "5G connectivity").
1.	A layer-2 connection is established between the UE and the TNAP. In case of IEEE 802.11 [80], this step corresponds to an 802.11 [80] Association. In case of PPP, this step corresponds to a PPP LCP negotiation. In other types of non-3GPP access (e.g. Ethernet), this step may not be required.
2-3.	An EAP authentication procedure is initiated. EAP messages shall be encapsulated into layer-2 packets, e.g. into IEEE 802.3/802.1x packets, into IEEE 802.11/802.1x packets, into PPP packets, etc. The UE provides a NAI that triggers the TNAP to send a AAA request to a TNGF. Between the TNAP and TNGF the EAP packets are encapsulated into AAA messages.
4-10.	An EAP-5G procedure is executed as specified in clause 7.2.1with the following modifications:
-	The EAP-5G packets shall not be encapsulated into IKEv2 packets. The UE shall also include a UE Identity Id in the AN parameter i.e., . a 5G-GUTI  or a SUCI. The value in the UE identity shall be stored at TNGF to as key identifier as described in step 13.
-	A KTNGF as specified in clause Annex A.9 (equivalent to KN3IWF) is created in the UE and in the AMF after the successful authentication. The KTNGF is transferred from the AMF to TNGF in step 10a (within the N2 Initial Context Setup Request).
-	The TNAP is a trusted entity. The TNGF shall generate the KTNAP as specified in Annex A.22 and transfers it from TNGF to TNAP in step 10b (within a AAA message).
-	After receiving the TNGF key from AMF in step 10a, the TNGF shall send to UE an EAP-Request/5G-Notification packet containing the "TNGF Contact Info", which includes the IP address of TNGF. After receiving an EAP-Response/5G-Notification packet from the UE, the TNGF shall send message 10d containing the EAP-Success packet.
11.	The common TNAP key is used by the UE and TNAP to derive security keys according to the applied non-3GPP technology and to establish a security association to protect all subsequent traffic. In case of IEEE 802.11 [80], the KTNAP is the Pairwise Master Key (PMK) and a 4-way handshake is executed (see IEEE 802.11 [80]) which establishes a security context between the WLAN AP and the UE that is used to protect unicast and multicast traffic over the air. All messages between UE and TNAP are encrypted and integrity protected from this step onwards.
NOTE 1: whether step 11 is performed out of the scope of this document. The current procedure assumes the encryption protection over Layer-2 between UE and TNAP is to be enabled.
12.	The UE receives IP configuration from the TNAN, e.g. with DHCP.
13.	The UE shall initiate an IKE_INIT exchange with the TNGF. The UE has received the IP address of TNGF during the EAP-5G signalling in step 9b, subsequently, the UE shall initiate an IKE_AUTH exchange and shall include the same UE Id (i.e. SUCI or 5G-GUTI) as in the UE Id provided in step 5. The common KTIPSe is used for mutual authentication. The key KTIPSec is derived as specified in Annex A.22.NULL encryption is negotiated as specified in RFC 2410 [81]. After step 13c, an IPsec SA is established between the UE and TNGF (i.e. a NWt connection) and it is used to transfer all subsequent NAS messages. This IPsec SA does not apply encryption but only apply integrity protection.
14.	After the NWtp connection is successfully established, the TNGF responds to AMF with an N2 Initial Context Setup Response message.
14a. The AMF may determine whether the TNGF is appropriate for the slice selected as defined in clause 4.12.2.2 of TS 23.502[8]. If it is compatible with the selected TNGF, then proceed with steps 15 to step 19. Otherwise, the AMF shall proceed with step 20 to step 22, and step 15 to step 19 are skipped.
Case a):
15.	Finally, the NAS Registration Accept message is sent by the AMF and is forwarded to UE via the established NWt connection.
16-18. The UE initiates a PDU session establishment. This is carried out exactly as specified in TS 23.502 [8] clause 4.12a.5. The TNGF may establish one or more IPSec child SA’s per PDU session.
19. User plane data for the established PDU session is transported between the UE and TNGF inside the established IPSec child SA
Case b:)
20. The AMF may trigger the UE policy update procedure and update the UE policy as defined in step 17 and step 18 in clause 4.12a.2.2 of TS 23.502[8].
21. The AMF shall send a Registration Reject message via TNGF to the UE as defined in step 19 to step21 in clause 4.12a.2.2 of TS 23.502[8]. The Registration Reject message is ciphered and integrity protected.
22. The UE shall decipher and verify the integrity of the Registration Reject message. If verification is successful, then the UE proceeds with step 21 in clause 4.12.2.2 of TS 23.502[8], and sends a Registration request message to the AMF via a new selected TNGF.
NOTE a: When the UE is attached to TNGF and the re-authentication is performed, the AMF provides the KTNGF to TNGF via UE CONTEXT MODIFICATION REQUEST. However, TNGF does not use this key for rekeying IPSec. The IPSec rekeying uses DH key material as defined in RFC 7296 [25].

##### 7A.2.1.2	Re-authentication for UE moving from one TNAP to another TNAP connecting to the same TNGF

When a UE associates with a TNAP in a TNAN connected to a TNGF, if the TNAP and TNGF in TNAN support FT, the TNAP in the TNAN advertises the FT capability as in IEEE 802.11 [80]. During the IKE process, the UE also indicates MOBIKE indication if it supports MOBIKE and TNGF acknowledges it if supported.
NOTE 1: It is assumed that TNGF is aware of the FT capabilities of the TNAP in the TNAN. Whether this is done by configuration or signalling internal to the TNAN is left to operator implementations.
The UE and TNGF perform the following in addition to the procedures specified in clause 7A.2.1.1 of the present document. If the TNAP supports FT, the TNGF shall derive a fresh key to enable re-authentication based on FT procedure, i.e. KFT, from KTNGF as specified in A.22 of the present document and either keep KFT if the TNGF acts as the R0KH or send the KFT to the R0KH otherwise. If the UE supports FT and connects to the TNAN supporting the FT, the UE shall determine to enable re-authentication based on FT procedure and derive an FT key, KFT, from KTNGF as specified in A.22 of the present document.
NOTE 2: Where the entity R0 key holder (R0KH) is located in the TNAN is outside the scope of 3GPP.
The UE and R0KH use KFT as Master PMK (MPMK) to construct the FT key hierarchy as specified in IEEE 802.11 [80] to perform re-authentication and security (re-)establishment while the UE switches between different TNAPs within the same mobility domain (i.e., identified by the MDID specified by IEEE 802.11 [80]) connected to the same TNGF. To perform such a switch the UE performs the FT procedure as specified in IEEE 802.11 [80]. The R0KH derives a key PMK-R1 from PMK-R0 and provides the key PMK-R1 to the new TNAP in TNAN during the FT procedure.
After the UE switch between TNAPs is complete, if MOBIKE is supported, the UE may send the request to restore the IPSec connectivity, and all IPSec SAs as defined in RFC 4555 [111].
NOTE 3: How to configure the MDID used for FT within the TNGF domain is left to Operator’s implementation and deployment. How the 3GPP-defined TNGF domain and IEEE-defined MDID co-exist/work is outside the scope of the present document.

#### 7A.2.2	Void


#### 7A.2.3	Key hierarchy for trusted non-3GPP access

The key hierarchy described in clause 6.2.1 applies, with the following changes:
The key derived for non-3GPP access is called KTNGF in the context of trusted access.
The key KTNGF received from AMF is used for three different purposes; to setup IPSec SAs between the UE and the TNGF and to create WLAN keys between the UE and the TNAP and to create the root key for IEEE 802.11 Fast BSS Transition (FT).
To separate the keys for these purposes, the key hierarchy in Figure 7A.2.3-1 shall be used. The KTIPSec key is used to setup IPSec SAs, the KTNAP key is used to setup access security and the KFT key is used as the root key for FT.
The keys KTIPSec, KTNAP and KFT are derived as described in Clause A.22.
Figure 7A.2.3-1 Key hierarchy for trusted non-3GPP access

#### 7A.2.4	Authentication for devices that do not support 5GC NAS over WLAN access


##### 7A.2.4.1	General

A N5CW device is capable to register to 5GC with 3GPP credentials and to establish 5GC connectivity via a trusted WLAN access network. The reference architecture is captured in clause 4.2.8.5.2 of TS 23.501[2]. The 3GPP credentials are stored as defined in clause 6.1.1.1. The Trusted WLAN Interworking Function (TWIF) provides interworking functionality that enables connectivity with 5GC and implements the NAS protocol stack and exchanges NAS messages with the AMF on behalf of the N5CW device. A single EAP-AKA’ authentication procedure is executed for connecting the N5CW device both to the trusted WLAN access network and to the 5G core network.
Figure 7A.2.4-1: Authentication Procedure for N5CW
0.	The N5CW device selects a PLMN and a trusted WLAN that supports "5G connectivity-without-NAS" to this PLMN by using the procedure specified in TS 23.501 [2] clause 6.3.12a, "Access Network selection for devices that do not support 5GC NAS over WLAN".
Steps 1-10:	Initial registration to 5GC.
1.	The N5CW device associates with the trusted WLAN network and the EAP-AKA’ authentication procedure is initiated.
2.	The N5CW device shall provide its Network Access Identity (NAI) The Trusted WLAN Access Point (TWAP) selects a Trusted WLAN Interworking Function (TWIF), e.g. based on the received realm, and sends an AAA request to the selected TWIF.
If the N5CW device registers to 5GC over 3GPP access for the first time when the above procedure is initiated, then the NAI shall include the SUCI. The SUCI shall be constructed as specified in clause 6.12.2.
If the N5CW device has registered to 5GC over 3GPP access when the above procedure is initiated, then the NAI includes the 5G-GUTI assigned to the N5CW device over 3GPP access. This enables the TWIF in step 4a below to select the same AMF as the one serving the N5CW device over 3GPP access.
3.	The TWIF shall create a 5GC Registration Request message on behalf of the N5CW device. The TWIF shall use default values to populate the parameters in the Registration Request message, which are the same for all N5CW devices that do not support 5G NAS. The Registration type indicates "Initial Registration".
4.	The TWIF shall select an AMF (e.g. by using the 5G-GUTI in the NAI, if provided by the N5CW device) and shall send an N2 message to the AMF including the Registration Request, the User Location and an AN Type.
5.	In case the AMF triggers an authentication procedure, it sends a request to AUSF by sending Nausf_UEAuthentication_Authenticate Request message. The Nausf_UEAuthentication_Authenticate Request message contains SUCI or SUPI (in case of a valid 5G-GUTI is received by the AMF). The request message contains also an indication that the request is from a N5CW device.
Even if the AMF already has a security context identified by 5G-GUTI, the AMF shall initiate the primary authentication.
NOTE 1:	To avoid key stream reuse when deriving KTWIF from KAMF, the KAMF always needs to be refreshed by a renewed primary authentication.
6. The AUSF shall send Nudm_UEAuthentication_Get Request to the UDM including SUCI or SUPI and the N5CW indication.
7. Upon reception of the Nudm_UEAuthentication_Get Request, the UDM shall invoke SIDF if a SUCI is received. SIDF shall de-conceal SUCI to gain SUPI before UDM can process the request. The UDM may select an authentication method based on the "realm" part of the SUPI, the N5CW device indicator, a combination of the "realm" part and the N5CW device indicator, or the UDM local policy.
8. The EAP-AKA’ procedure will be trigged to perform mutual authentication between the N5CW device and the home network as specified in clause 6.1.3.1.
EAP-AKA' takes place between the N5CW device and AUSF. Over the N2 interface, the EAP messages are encapsulated within NAS Authentication messages. The EAP-AKA’ messages exchanged between the N5CW Device and the TWIF shall be encapsulated into the layer-2 packets, e.g. into IEEE 802.3/802.1x packets, into IEEE 802.11/802.1x packets, into PPP packets, etc.
9.	The NAS security context is not required in this scenario. The AMF shall derive an KTWIF key from the received KAMF key as specified in Annex A.9. NAS security between AMF and TWIF is established similar to unauthenticated emergency calls, i.e. with NULL encryption and NULL integrity protection.
NOTE 2:	N5CW device does not support NAS; therefore, using the NAS counter is not possible on N5CW device.
10a.	The AMF shall send NAS Security Mode Command to the TWIF. The NAS Security Mode Command shall contain the EAP-Success message and the NULL security algorithms.
10b. The TWIF shall not forward the EAP-Success to the N5CW directly, instead, it shall store the EAP-Success message and wait for KTWIF.
10c. The TWIF shall send the NAS Security Mode Complete message to the AMF.
11.	The AMF sends an N2 Initial Context Setup Request and provides the KTWIF key to TWIF.
12.		The TWIF shall derive a TNAP key, KTNAP, from the KTWIF key as specified in Appendix A.22 and send the TNAP key and the EAP-Success message to the Trusted WLAN Access Point, which forwards the EAP-Success to the N5CW device. The TNAP key corresponds to the PMK (Pairwise Master Key) which is  used to secure the WLAN air-interface communication according to IEEE 802.11 [80]. A layer-2 or layer-3 connection is established between the Trusted WLAN Access Point and the TWIF for transporting all user-plane traffic of the N5CW device to TWIF. This connection is later bound to an N3 connection that is created for this N5CW device.
13. The TWIF shall send N2 Initial Context Setup Response message to the AMF.
14. The following steps are captured in clause 4.12b.2 of TS 23.502[8].

##### 7A.2.4.2	Re-authentication for UE moving from one TNAP to another TNAP connecting to the same TWIF

The FT procedures given in clause 7A.2.1.2 are followed with TNGF being replaced by TWIF and KTNGF being replaced by KTWIF .
NOTE: The MOBIKE procedures are not applicable.
