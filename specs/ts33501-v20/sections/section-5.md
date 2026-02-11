# 5	Security requirements and features


### 5.1	General security requirements


#### 5.1.1	Mitigation of bidding down attacks

An attacker could attempt a bidding down attack by making the UE and the network entities respectively believe that the other side does not support a security feature, even when both sides in fact support that security feature. It shall be ensured that a bidding down attack, in the above sense, can be prevented.

#### 5.1.2	Authentication and Authorization

The 5G system shall satisfy the following requirements.
Subscription authentication: The serving network shall authenticate the Subscription Permanent Identifier (SUPI) in the process of authentication and key agreement between UE and network.
Serving network authentication: The UE shall authenticate the serving network identifier through implicit key authentication.
NOTE 1: 	The meaning of 'implicit key authentication' here is that authentication is provided through the successful use of keys resulting from authentication and key agreement in subsequent procedures.
NOTE 2: 	The preceding requirement does not imply that the UE authenticates a particular entity, e.g. an AMF, within a serving network.
UE authorization: The serving network shall authorize the UE through the subscription profile obtained from the home network. UE authorization is based on the authenticated SUPI.
Serving network authorization by the home network: Assurance shall be provided to the UE that it is connected to a serving network that is authorized by the home network to provide services to the UE. This authorization is 'implicit' in the sense that it is implied by a successful authentication and key agreement run.
Access network authorization: Assurance shall be provided to the UE that it is connected to an access network that is authorized by the serving network to provide services to the UE. This authorization is 'implicit' in the sense that it is implied by a successful establishment of access network security. This access network authorization applies to all types of access networks.
Unauthenticated Emergency Services: In order to meet regulatory requirements in some regions, the 5G system shall support unauthenticated access for emergency services. This requirement applies to all MEs and only to those serving networks where regulatory requirements for unauthenticated emergency services exist. Serving networks located in regions where unauthenticated emergency services are forbidden shall not support this feature.

#### 5.1.3	Requirements on 5GC and NG-RAN related to keys

The 5GC and NG-RAN shall allow for use of encryption and integrity protection algorithms for AS and NAS protection having keys of length 128 bits. The network interfaces shall support the transport of 256 bit keys.
The keys used for UP, NAS and AS protection shall be dependent on the algorithm with which they are used.

### 5.2	Requirements on the UE


#### 5.2.1	General

The support and usage of ciphering and integrity protection between the UE and the ng-eNB is identical to the support and usage of ciphering and integrity protection between the UE and the eNB as specified in TS 33.401 [10] with the following additional requirement(s):
-	The UE shall support the use of integrity protection with the ng-eNB over the Uu interface if it supports E-UTRA connected to 5GC.
-	The UE shall indicate its support of integrity protection with the ng-eNB if it supports E-UTRA connected to 5GC.
The PEI shall be securely stored in the UE to ensure the integrity of the PEI.

#### 5.2.2	User data and signalling data confidentiality

The UE shall support ciphering of user data between the UE and the gNB.
The UE shall activate ciphering of user data based on the indication sent by the gNB.
The UE shall support ciphering of RRC and NAS-signalling.
The UE shall implement the following ciphering algorithms:
NEA0, 128-NEA1, 128-NEA2 as defined in Annex D of the present document.
The UE may implement the following ciphering algorithm:
128-NEA3 as defined in Annex D of the present document.
The UE shall implement the ciphering algorithms as specified in TS 33.401 [10] if it supports E-UTRA connected to 5GC.
Confidentiality protection of the user data between the UE and the gNB is optional to use.
Confidentiality protection of the RRC-signalling, and NAS-signalling is optional to use.
Confidentiality protection should be used whenever regulations permit.

#### 5.2.3	User data and signalling data integrity

The UE shall support integrity protection and replay protection of user data between the UE and the gNB. The UE shall support integrity protection of user data at any data rate, up to and including, the highest data rate supported by the UE.
The UE shall activate integrity protection of user data based on the indication sent by the gNB.
The UE shall support integrity protection and replay protection of RRC and NAS-signalling.
The UE shall implement the following integrity protection algorithms:
NIA0, 128-NIA1, 128-NIA2 as defined in Annex D of the present document.
The UE may implement the following integrity protection algorithm:
128-NIA3 as defined in Annex D of the present document.
The UE shall implement the integrity algorithms as specified in TS 33.401 [10] if it supports E-UTRA connected to 5GC.
Integrity protection of the user data between the UE and the gNB is optional to use.
NOTE:	Integrity protection of user plane adds the overhead of the packet size and increases the processing load both in the UE and the gNB.
Integrity protection of the RRC-signalling, and NAS-signalling is mandatory to use, except in the following cases:
All NAS signalling messages except those explicitly listed in TS 24.501 [35] as exceptions shall be integrity-protected.
All RRC signalling messages except those explicitly listed in TS 38.331 [22] as exceptions shall be integrity-protected with an integrity protection algorithm different from NIA0, except for unauthenticated emergency calls.
The UE shall implement NIA0 for integrity protection of NAS and RRC signalling. NIA0 is only allowed for unauthenticated emergency session as specified in clause 10.2.2.

#### 5.2.4	Secure storage and processing of subscription credentials

The following requirements apply for the storage and processing of the subscription credentials used to access the 5G network:
The subscription credential(s) shall be integrity protected within the UE using a tamper resistant secure hardware component.
The long-term key(s) of the subscription credential(s) (i.e. K) shall be confidentiality protected within the UE using a tamper resistant secure hardware component.
The long-term key(s) of the subscription credential(s) shall never be available in the clear outside of the tamper resistant secure hardware component.
The authentication algorithm(s) that make use of the subscription credentials shall always be executed within the tamper resistant secure hardware component.
It shall be possible to perform a security evaluation / assessment according to the respective security requirements of the tamper resistant secure hardware component.
NOTE:	The security assessment scheme used for the security evaluation of the tamper resistant secure hardware component is outside the scope of 3GPP specifications.

#### 5.2.5	Subscriber privacy

The UE shall support 5G-GUTI.
The SUPI should not be transferred in clear text over NG-RAN except routing information, e.g. Mobile Country Code (MCC) and Mobile Network Code (MNC).
The Home Network Public Key shall be stored in the USIM.
The protection scheme identifier shall be stored in the USIM.
The Home Network Public Key Identifier shall be stored in the USIM.
The SUCI calculation indication, either USIM or ME calculating the SUCI, shall be stored in USIM.
The ME shall support the null-scheme.If the home network has not provisioned the Home Network Public Key in USIM, the SUPI protection in initial registration procedure is not provided. In this case, the null-scheme shall be used by the ME.
Based on home operator's decision, indicated by the USIM, the calculation of the SUCI shall be performed either by the USIM or by the ME.
NOTE 1: 	If the SUCI calculation indication is not present, the calculation is in the ME.
In case of an unauthenticated emergency call, privacy protection for SUPI is not required.
Provisioning, and updating the Home Network Public Key, Home Network Public Key Identifier, protection scheme identifier, Routing Indicator, and SUCI calculation indication in the USIM shall be in the control of the home network operator.
NOTE 2:	The provisioning and updating of the Home Network Public Key, Home Network Public Key Identifier, protection scheme identifier, and SUCI calculation indication is out of the scope of the present document. It can be implemented using, e.g. the Over the Air (OTA) mechanism. Routing Indicator can be updated, e.g., by OTA or as defined in clause 6.15.
Subscriber privacy enablement shall be under the control of the home network of the subscriber.
The UE shall only send the PEI in the NAS protocol after NAS security context is established, unless during emergency registration when no NAS security context can be established.
The Routing Indicator shall be stored in the USIM. If the Routing Indicator is not present in the USIM, the ME shall set it to a default value as defined in TS 23.003 [19].

### 5.3	Requirements on the gNB


#### 5.3.1	General

The security requirements given in this clause apply to all types of gNBs. More stringent requirements for specific types of gNBs may be defined in other 3GPP specifications.

#### 5.3.2	User data and signalling data confidentiality

The gNB shall support ciphering of user data between the UE and the gNB.
The gNB shall activate ciphering of user data based on the security policy sent by the SMF.
The gNB shall support ciphering of RRC-signalling.
The gNB shall implement the following ciphering algorithms:
-	NEA0, 128-NEA1, 128-NEA2 as defined in Annex D of the present document.
The gNB may implement the following ciphering algorithm:
-	128-NEA3 as defined in Annex D of the present document.
Confidentiality protection of user data between the UE and the gNB is optional to use.
Confidentiality protection of the RRC-signalling is optional to use.
Confidentiality protection should be used whenever regulations permit.

#### 5.3.3	User data and signalling data integrity

The gNB shall support integrity protection and replay protection of user data between the UE and the gNB.
The gNB shall activate integrity protection of user data based on the security policy sent by the SMF.
The gNB shall support integrity protection and replay protection of RRC-signalling.
The gNB shall support the following integrity protection algorithms:
-	NIA0, 128-NIA1, 128-NIA2 as defined in Annex D of the present document.
The gNB may support the following integrity protection algorithm:
-	128-NIA3 as defined in Annex D of the present document.
Integrity protection of the user data between the UE and the gNB is optional to use, and shall not use NIA0.
NOTE: 	Integrity protection of user plane adds the overhead of the packet size and increases the processing load both in the UE and the gNB. NIA0 will add an unnecessary overhead of 32-bits MAC with no security benefits.
All RRC signalling messages except those explicitly listed in TS 38.331 [22] as exceptions shall be integrity-protected with an integrity protection algorithm different from NIA0, except for unauthenticated emergency calls.
NIA0 shall be disabled in gNB in the deployments where support of unauthenticated emergency session is not a regulatory requirement.

#### 5.3.4	Requirements for the gNB setup and configuration

Setting up and configuring gNBs by O&M systems shall be authenticated and authorized by gNB so that attackers shall not be able to modify the gNB settings and software configurations via local or remote access.
-	The certificate enrolment mechanism specified in TS 33.310 [5] for base station should be supported for gNBs. The decision on whether to use the enrolment mechanism is left to operators.
-	Communication between the O&M systems and the gNB shall be confidentiality, integrity and replay protected from unauthorized parties. The security associations between the gNB and an entity in the 5G Core or in an O&M domain trusted by the operator shall be supported. These security association establishments shall be mutually authenticated. The security associations shall be realized according to TS 33.210 [3] and TS 33.310 [5].
-	The gNB shall be able to ensure that software/data change attempts are authorized.
-	The gNB shall use authorized data/software.
-	Sensitive parts of the boot-up process shall be executed with the help of the secure environment.
-	Confidentiality of software transfer towards the gNB shall be ensured.
-	Integrity protection of software transfer towards the gNB shall be ensured.
-	The gNB software update shall be verified before its installation (cf. sub-clause 4.2.3.3.5 of TS 33.117 [24]).

#### 5.3.5	Requirements for key management inside the gNB

The 5GC provides subscription specific session keying material for the gNBs, which also hold long term keys used for authentication and security association setup purposes. Protecting all these keys is important. The following requirements apply:
-	Any part of a gNB deployment that stores or processes keys in cleartext shall be protected from physical attacks. If not, the whole entity is placed in a physically secure location, then keys in cleartext shall be stored and processed in a secure environment. Keys stored inside a secure environment in any part of the gNB shall never leave the secure environment except when done in accordance with this or other 3GPP specifications.

#### 5.3.6	Requirements for handling user plane data for the gNB

The following requirements apply:
-	Any part of a gNB deployment that stores or processes user plane data in cleartext shall be protected from physical attacks. If not, the whole entity is placed in a physically secure location, then user plane data in cleartext shall be stored and processed in a secure environment.

#### 5.3.7	Requirements for handling control plane data for the gNB

The following requirements apply:
-	Any part of a gNB deployment that stores or processes control plane data in cleartext shall be protected from physical attacks. If not, the whole entity is placed in a physically secure location, then control plane data in cleartext shall be stored and processed in a secure environment.

#### 5.3.8	Requirements for secure environment of the gNB

The secure environment is logically defined within the gNB. It ensures protection and secrecy of all sensitive information and operations from any unauthorized access or exposure. The following list defines the requirements of the secure environment:
-	The secure environment shall support secure storage of sensitive data, e.g. long-term cryptographic secrets and vital configuration data.
-	The secure environment shall support the execution of sensitive functions, e.g. en-/decryption of user data and the basic steps within protocols which use long term secrets (e.g. in authentication protocols).
-	The secure environment shall support the execution of sensitive parts of the boot process.
-	The secure environment's integrity shall be assured.
-	Only authorised access shall be granted to the secure environment, i.e. to data stored and used within it, and to functions executed within it.

#### 5.3.9	Requirements for the gNB F1 interfaces

Requirements given below apply to gNBs with split DU-CU implementations using F1 interface defined in TS 38.470 [31]. Signalling traffic (i.e. both F1-C interface management traffic defined in TS 38.470 [31] and F1-C signalling bearer defined in TS 38.472 [32]) and user plane data can be sent on the F1 interface between a given DU and its CU.
-	F1-C interface shall support confidentiality, integrity and replay protection.
-	All management traffic carried over the CU-DU link shall be integrity, confidentiality and replay protected.
-	The gNB shall support confidentiality, integrity and replay protection on the gNB DU-CU F1-U interface [33] for user plane.
-	F1-C and management traffic carried over the CU-DU link shall be protected independently from F1-U traffic.
NOTE:	The above requirements allow to have F1-U protected differently (including turning integrity and/or encryption off or on for F1-U) from all other traffic on the CU-DU (e.g. the traffic over F1-C).

#### 5.3.10	Requirements for the gNB E1 interfaces

Requirements given below apply to gNBs with split DU-CU implementations, particularly with an open interface between CU-CP and CU-UP using the E1 interface defined in TS 38.460 [41].
-	The E1 interface between CU-CP and CU-UP shall be confidentiality, integrity and replay protected.

### 5.4	Requirements on the ng-eNB

The security requirements for ng-eNB are as specified for eNB in TS 33.401 [10] with the following additional requirement:
-	ng-eNB shall support the use of integrity protection with the UE over the Uu interface.

### 5.5	Requirements on the AMF


#### 5.5.1	Signalling data confidentiality

The AMF shall support ciphering of NAS-signalling.
The AMF shall support the following ciphering algorithms:
-	NEA0, 128-NEA1, 128-NEA2 as defined in  Annex D of the present document.
The AMF may support the following ciphering algorithm:
-	128-NEA3 as defined in Annex D of the present document.
Confidentiality protection NAS-signalling is optional to use.
Confidentiality protection should be used whenever regulations permit.

#### 5.5.2	Signalling data integrity

The AMF shall support integrity protection and replay protection of NAS-signalling.
The AMF shall support the following integrity protection algorithms:
-	NIA-0, 128-NIA1, 128-NIA2 as defined in  Annex D of the present document.
The AMF may support the following integrity protection algorithm:
-	128-NIA3 as defined in  Annex D of the present document.
NIA0 shall be disabled in AMF in the deployments where support of unauthenticated emergency session is not a regulatory requirement.
All NAS signalling messages except those explicitly listed in TS 24.501 [35] as exceptions shall be integrity-protected with an algorithm different to NIA-0 except for emergency calls.

#### 5.5.3	Subscriber privacy

The AMF shall support to trigger primary authentication using the SUCI.
The AMF shall support assigning 5G-GUTI to the UE.
The AMF shall support reallocating 5G-GUTI to UE.
The AMF shall be able to confirm SUPI from UE and from home network. The AMF shall deny service to the UE if this confirmation fails.

### 5.6	Requirements on the SEAF

The security anchor function (SEAF) provides the authentication functionality via the AMF in the serving network. The SEAF shall fulfil the following requirements:
The SEAF shall support primary authentication using SUCI.

### 5.7	Void


### 5.8	Requirements on the UDM


#### 5.8.1	Generic requirements

The long-term key(s) used for authentication and security association setup purposes shall be protected from physical attacks and shall never leave the secure environment of the UDM/ARPF unprotected.
NOTE 1: Security mechanisms for protection of subscription credentials in ARPF are left to implementation.
NOTE 2: Security mechanisms for storage of subscription credentials in the UDR and for the transfer of authentication subscription data (as specified in 3GPP TS 29.505 [70]) between UDR and ARPF are left to implementation.

#### 5.8.2	Subscriber privacy related requirements to UDM and SIDF

The SIDF is responsible for de-concealment of the SUCI and shall fulfil the following requirements:
-	The SIDF shall be a service offered by UDM.
-	The SIDF shall resolve the SUPI from the SUCI based on the protection scheme used to generate the SUCI.
The Home Network Private Key used for subscriber privacy shall be protected from physical attacks in the UDM.
The UDM shall hold the Home Network Public Key Identifier(s) for the private/public key pair(s) used for subscriber privacy.
The algorithm used for subscriber privacy shall be executed in the secure environment of the UDM.

### 5.8a	Requirements on AUSF

The Authentication server function (AUSF) shall handle authentication requests for both, 3GPP access and non-3GPP access.
The AUSF shall provide SUPI to the VPLMN only after authentication confirmation if authentication request with SUCI was sent by VPLMN.
The AUSF shall inform the UDM that a successful or unsuccessful authentication of a subscriber has occurred.

### 5.8b	Requirements on the UDR

The UDR shall prevent unauthorized access to the stored UE authentication data.
Only the UDM shall be able to update the security related information in the UDR, such as the SQN for resynchronization.
NOTE: 	The requirements stated only apply in the case where UDR and UDM are implemented as separate network functions (non-colocated).

### 5.9	Core network security


#### 5.9.1	Trust boundaries

It is assumed for the set of requirements in this sub-clause that mobile network operators subdivide their networks into trust zones. Subnetworks of different operators are assumed to lie in different trust zones. Messages that traverse trust boundaries shall follow the requirements in sub-clause 5.9.2 to 5.9.4 of the present document, if not protected end to end by NDS/IP as specified in TS 33.210 [3].

#### 5.9.2	Requirements on service-based architecture


##### 5.9.2.1	Security Requirements for service registration, discovery and authorization

NF Service based discovery and registration shall support confidentiality, integrity, and replay protection.
NRF shall be able to ensure that NF Discovery and registration requests are authorized.
NF Service based discovery and registration shall be able to hide the topology of the available / supported NF's in one administrative/trust domain from entities in different trust/administrative domains (e.g. between NFs in the visited and the home networks.)
NF Service Request and Response procedure shall support mutual authentication for direct communication between NF Service Consumer and NF Service Producer.
NOTE:	There is no mutual authentication between NF Service Consumer and NF Service Producer in case of indirect communication via SCP or SEPP.
Each NF shall validate all incoming messages. Messages that are not valid according to the protocol specification and network state shall be either rejected or discarded by the NF.

##### 5.9.2.2	NRF security requirements

The Network Repository Function (NRF) receives NF Discovery Requests from an NF instance, provides the information of the discovered NF instances / NF service instance to the requesting NF instance or SCP, and maintains NF profiles.
NOTE:	While registering and updating NF profile, the NRF verifies that the values of parameters that are present both in the NF profile and in the public key certificate of the NF instance match. This verification is implementation specific.
The NRF receives from NF Service Consumers or SCPs access token requests for service consumption and provides authorization tokens.
The NRF shall act as authorization server.
The following NRF service-based architecture security requirements shall apply:
NRF and NFs that are requesting service shall be mutually authenticated.
NRF may provide authentication and authorization to NFs for establishing secure communication between each other.

##### 5.9.2.3	NEF security requirements

The Network Exposure Function (NEF) supports external exposure of capabilities of Network Functions to Application Functions, which interact with the relevant Network Functions via the NEF.
The interface between the NEF and the Application Function shall fulfil the following requirements:
-	Integrity protection, replay protection and confidentiality protection for communication between the NEF and Application Function shall be supported.
-	Mutual authentication between the NEF and Application Function shall be supported.
-	Internal 5G Core information such as DNN, S-NSSAI etc., shall not be sent outside the 3GPP operator domain.
-	SUPI shall not be sent outside the 3GPP operator domain by NEF.
The NEF shall be able to determine whether the Application Function is authorized to interact with the relevant Network Functions..

##### 5.9.2.4	Requirements on the Service Communication Proxy (SCP)

The SCP has interfaces with Network Functions (NF) and peer SCPs within the PLMN (or SNPN). The interface between the SCP and the NFs and between the two SCPs shall fulfil the following requirements:
-	Mutual authentication shall be performed between the SCP and NFs, and between the two SCPs within the PLMN (or SNPN).
-	All communication between the SCP and NFs and between SCPs shall be confidentiality, integrity and replay protected.
If SCP endpoints are co-located with the NFs, the above two requirements may be satisfied by colocation.
The SCP shall provide confidentiality, integrity and replay protection for its internal communication over SCP internal network interfaces.
NOTE 1: All parties communicating through the SCP need to trust the SCP to correctly handle the messages passing through it.
If the signalling message (service/subscription request or notification message) from the sending NF does not include the PLMN ID or SNPN ID in the 3gpp-Sbi-Originating-Network-Id header and the sending SCP can determine the PLMN ID or SNPN ID value to be included in the 3gpp-Sbi-Originating-Network-Id header, the sending SCP should include it.

#### 5.9.3	Requirements for e2e core network interconnection security


##### 5.9.3.1	General

The present sub-clause contains requirements common to sub-clauses 5.9.2 and 5.9.3.
A solution for e2e core network interconnection security shall satisfy the following requirements.
The solution shall support application layer mechanisms for addition, deletion and modification of message elements by Roaming intermediaries except for specific message elements described in the present document.
NOTE:	Typical examples are IPX providers or Roaming Hubs modifying messages for routing purposes.
The solution shall provide confidentiality and/or integrity end-to-end between source and destination network for specific message elements identified in the present document. For this requirement to be fulfilled, the SEPP – cf [2], clause 6.2.17 shall be present at the edge of the source and destination networks dedicated to handling e2e Core Network Interconnection Security. The confidentiality and/or integrity for the message elements is provided between two SEPPs of the source and destination PLMN.
The destination network shall be able to determine the authenticity of the source network that sent the specific message elements protected according to the preceding bullet. For this requirement to be fulfilled, it shall suffice that a SEPP in the destination network that is dedicated to handling e2e Core Network Interconnection Security can determine the authenticity of the source network.
The solution should have minimal impact and additions to 3GPP-defined network elements.
The solution should be using standard security protocols.
The solution shall cover interfaces used for roaming purposes.
The solution should take into account considerations on performance and overhead.
The solution shall cover prevention of replay attacks.
The solution shall cover algorithm negotiation and prevention of bidding down attacks.
The solution should take into account operational aspects of key management.

##### 5.9.3.2	Requirements for Security Edge Protection Proxy (SEPP)

The feature of supporting Roaming Hubs by SEPPs introduced in Release 18 of the present document and TS 29.573 [73], addresses the requirements that may be applicable to SEPPs starting from Release 16.
In order to support PRINS functionality using Roaming Intermediaries, the feature specified in this document may be supported by Release 16 and 17 implementations of SEPPs.
NOTE: 	It is implementation specific on how to support the scenario where the Rel 16 and 17 SEPP of the roaming partners are not aligned regarding the support of Roaming Intermediaries.
The SEPP shall act as a non-transparent proxy node.
The SEPP shall protect application layer control plane messages between two NFs belonging to different PLMNs or SNPNs that use the N32 interface to communicate with each other.
The SEPP shall perform mutual authentication with the SEPP in the other network.
The SEPP shall perform negotiation of cipher suites with the SEPP in the other network.
The SEPP shall handle key management aspects that involve setting up the required cryptographic keys needed for securing messages on the N32 interface between two SEPPs.
The SEPP shall perform topology hiding by limiting the internal topology information visible to external parties.
As a reverse proxy the SEPP shall provide a single point of access and control to internal NFs.
The receiving SEPP shall be able to verify whether the sending SEPP is authorized to use the PLMN ID or SNPN ID in the received N32 message.
The SEPP to SEPP communication may go via up to two Roaming Intermediaries.  The changes made by Roaming Intermediaries to messages originated by a SEPP, based on the originating PLMNs policy, shall be identifiable by the receiving SEPP.
The SEPP shall be able to clearly differentiate between certificates used for authentication of peer SEPPs and certificates used for authentication of Roaming Intermediaries performing message modifications. The SEPP shall support multiple trust anchors.
NOTE 1: Such a differentiation and support of multiple trust anchors could be done, e.g. , by implementing separate certificate storages.
The SEPP shall discard malformed N32 signaling messages.
The sending SEPP shall reject messages received from the NF (directly or via SCP) with JSON including "encBlockIndex" (regardless of the encoding used for that JSON request).
The receiving SEPP shall reject any message in which a Roaming Intermediary has inserted or relocated references to encBlockIndex.
The SEPP shall implement rate-limiting functionalities to defend itself and subsequent NFs against excessive CP signaling. This includes SEPP-to-SEPP signaling messages.
The SEPP shall implement anti-spoofing mechanisms that enable cross-layer validation of source and destination address and identifiers (e.g. FQDNs or PLMN IDs).
NOTE 2: An example for such an anti-spoofing mechanism is the following: If there is a mismatch between different layers of the message or the destination address does not belong to the SEPP’s own PLMN (or SNPN), the message is discarded.
The SEPP shall be able to use one or more PLMN IDs (or SNPN IDs). In the situation that a PLMN  (or SNPN) is using more than one PLMN ID (or SNPN ID), this PLMN’s SEPP (or SNPN’s SEPP) may use the same N32-connection for all of the networks PLMN IDs (or SNPN IDs), with each of the PLMN’s (or SNPN’s) remote partners. If different PLMNs (or SNPNs) are represented by the PLMN IDs  (or SNPN IDs) supported by a SEPP, the SEPP shall use separate N32-connections for each pair of home and visited PLMN (or SNPN).
NOTE 3: 	If a given PLMN uses a Roaming Hub (RH) for the purposes of roaming with multiple other PLMNs, then a single TLS connection between the PLMN’s SEPP and the RH can be used for carrying the N32-f PRINS signalling for some or all the other PLMNs.
NOTE 4: void
Error messages may be originated from either PLMN SEPPs or Roaming Hubs to adjacent Roaming Hubs or adjacent PLMN SEPPs, in an identifiable way.
If allowed by the PLMN policy, the SEPP shall be able to send error messages on the N32 interface to a Roaming Hub.
Specific error messages relevant to Roaming Hubs shall be supported (such as 'an IE is encrypted while it was expected to be available in the clear', 'an IE is not encrypted while its availability in the clear is not required', 'the N32 connection cannot be setup due to contractual reasons', 'the N32 connection cannot be setup due to a connectivity issue' and 'the message was not delivered due to contractual reasons'). See details in clause 5.9.3.2a.
Sending SEPP behavior for the 3gpp-Sbi-Originating-Network-Id header:
- 	If the sending NF or the SCP has inserted the 3gpp-Sbi-Originating-Network-Id header in the signaling message (service/subscription request or notification message), the sending SEPP shall compare the PLMN ID or SNPN ID in the 3gpp-Sbi-Originating-Network-Id header in the received signaling message with the PLMN ID(s) or SNPN ID(s) that the sending SEPP represents by its certificate.
- 	If the PLMN ID or SNPN ID does not match with any of the PLMN IDs that the sending SEPP represents, the sending SEPP shall discard the received signaling message.
-	If the PLMN ID or SNPN ID matches with any of the PLMN IDs that the sending SEPP represents, the sending SEPP shall forward the signaling message to the receiving SEPP.
-	If the sending NF and the SCP have not included the 3gpp-Sbi-Originating-Network-Id header in the signalling message, the sending SEPP shall include the 3gpp-Sbi-Originating-Network-Id header and send the updated signaling message to the receiving SEPP.
-	If the sending SEPP only represents one PLMN ID or SNPN ID, the sending SEPP shall insert the 3gpp-Sbi-Originating-Network-Id header with this ID.
-	If the sending SEPP represents multiple PLMN IDs or SNPN IDs, it is up to configuration and deployment to determine which PLMN ID or SNPN ID value should be included in the header.
Receiving SEPP behavior for the 3gpp-Sbi-Originating-Network-Id header:
- 	The receiving SEPP shall check whether the 3gpp-Sbi-Originating-Network-Id header included in the signalling message belongs to the sending SEPP’s own PLMN or SNPN. It does this by verifying that the asserted PLMN ID in the 3gpp-Sbi-Originating-Network-Id header matches one of the sending SEPP's own PLMN ID(s) or SNPN ID(s) either in the N32-f context, the sending SEPP's certificate, or a locally configured list of PLMN IDs or SNPN-IDs that the sending SEPP represents.
- 	If the 3gpp-Sbi-Originating-Network-Id header does not match with any of the PLMN IDs or SNPN IDs belonging to the peer sending SEPP, the receiving SEPP shall discard the received signaling message.
- 	If the 3gpp-Sbi-Originating-Network-Id header matches with any PLMN ID of the PLMN or SNPN IDs belonging to the peer sending SEPP, the header is successfully verified, and the receiving SEPP shall forward the received signaling message to the target NF.
NOTE 5: Details on SEPP behaviour are specified in TS 29.500 [74].

##### 5.9.3.2a	Support for Messages generated by Roaming Intermediaries

A PLMN SEPP that makes use of Roaming Intermediaries shall be able to handle error messages generated by Roaming Intermediaries, delivered over the N32 connection.
The following error messages relevant to Roaming Hub shall be supported,
-	'an IE is encrypted while it was expected to be available in the clear',
-	'an IE is not encrypted while its availability in the clear is not required',
-	'the N32 connection cannot be setup due to contractual reasons',
-	'the N32 connection cannot be setup due to a connectivity issue', and
-	'the message was not delivered due to contractual reasons'.
The mechanism used by the SEPP for setting up N32-c via a chain of Roaming Intermediaries shall contain sufficient information such that the target PLMN and the Roaming Intermediaries can determine the identities of the initiating PLMN and the target PLMN.
NOTE 1: The Roaming Intermediary can reject the N32-c connection if no roaming relation exists. In this case, the expected error is "the N32 connection cannot be setup due to contractual reasons".
Additionally, it shall be possible for the Roaming Hubs to generate application layer control plane messages in order to reject traffic. Application layer control plane messages may be generated by the Roaming Hubs in order to reject registration attempts (refer to TS 23.502 [8] clause 4.2.2.2), to terminate sessions (see TS 23.502 [8] clause 4.3.4.3) and/or deregister the UE (refer to TS 23.502 [8] clause 4.2.2.3.3) and shall be sent using the corresponding NF Service operation to the NF, when relevant decisions are enforced by the Roaming Hub.
In this case, such messages are transparent to the SEPP and the SEPP shall act on them as any other message on the N32-f interface not making use of Roaming Intermediaries. How the SEPP authorizes such messages is left to implementation.

##### 5.9.3.3	Protection of attributes

Integrity protection shall be applied to all attributes transferred over the N32-f interface.
Confidentiality protection shall be applied to all attributes specified in SEPP's Data-type Encryption Policy (clause 13.2.3.2). The following attributes shall be confidentiality protected when being sent over the N32-f interface, irrespective of the Data-type Encryption Policy:
-	Authentication Vectors.
-	Cryptographic material.
-	Location data, e.g. Cell ID and Physical Cell ID.
-	Content of SMS in case of SMS over SBI over N32.
-	Authorization token.
The following attributes should additionally be confidentiality protected when being sent over the N32-f interface:
-	SUPI.

##### 5.9.3.4	Requirements for IPUPS functionality

The IPUPS shall only forward GTP-U packets that contain an F-TEID that belongs to an active PDU session and discard all others.
The IPUPS shall discard malformed GTP-U messages.

##### 5.9.3.5	Requirements for Network Functions (NF)

The NF that sends a signalling message (service/subscription request or notification message) shall include its PLMN ID or SNPN ID in the 3gpp-Sbi-Originating-Network-Id header.
If an NF supports multiple PLMN IDs or SNPN IDs, the sending NF shall include the PLMN ID or SNPN ID in the 3gpp-Sbi-Originating-Network-Id header on behalf of which the message is sent.
The handling of the PLMN ID or SNPN ID in the 3gpp-Sbi-Originating-Network-Id header at the receiving NF is up to configuration and deployment.
NOTE:	A misconfigured PLMN ID or SNPN ID in the 3gpp-Sbi-Originating-Network-Id header can lead to service interruption.

#### 5.9.4	Requirements for monitoring 5GC signaling traffic


##### 5.9.4.1	Security requirements for the configuration of signalling monitoring

The 5G shall support mutual authentication between the STM Management Producer at the 5GC (for configuration/activation of the functionality) and the STM Management Consumer.
The 5G shall support authorization to the STM Management Consumer.
NOTE 1: Local policy-based authorization should be supported by the STM Management Producer, according to TS 28.533 [54].
The 5G shall support integrity protection, replay protection and confidentiality protection for communication between the STM Management Producer at the 5GC and the STM Management Consumer.
NOTE 2: If interface between the STM Management Producer and the STM Management Consumer is trusted (e.g. physically protected), it is for the PLMN-operator to decide whether to apply integrity protection, replay protection and confidentiality protection for communication.

##### 5.9.4.2	Security requirements for the streaming of signalling monitoring data

The 5G shall support mutual authentication between the STM Data Producer at the 5GC and the STM Data Consumer at the Monitoring system.
NOTE: The Monitoring system is outside the scope of the present document.
The 5G shall provide confidentiality protection, integrity protection and replay protection of the interface between the STM Data Producer at the 5GC and the STM Data Consumer at the Monitoring system.
Keys stored inside a 5GC NF shall never leave a secure environment within the 5GC NF for Signalling Traffic Monitoring purposes. As the STM Data Consumer may reside outside the operator’s secure 5GC domain, when security key(s) transported on SBA control plane signalling messages are included in the copies of SBA control plane signalling traffic to the STM Data Consumer at the Monitoring system, the key value(s) shall be masked with a string by preserving the length of the key value (s).

### 5.10	Visibility and configurability


#### 5.10.1	Security visibility

Although in general the security features should be transparent to the user or application, for certain events and according to the user's or application's concern, greater visibility of the operation of following security feature shall be provided:
-	AS confidentiality: (AS confidentiality, Confidentiality algorithm, bearer information)
-	AS integrity: (AS integrity, Integrity algorithm, bearer information)
-	NAS confidentiality: (NAS confidentiality, Confidentiality algorithm)
-	NAS integrity: (NAS integrity, Integrity algorithm)
The UE shall provide above security information to the applications in the UE (e.g. via APIs), on a per PDU session granularity.
The serving network identifier shall be available for applications in the UE.

#### 5.10.2	Security configurability

Security configurability lets a user to configure certain security feature settings on a UE that allows the user to manage additional capability or use certain advanced security features.
The following configurability feature should be provided:
-	Granting or denying access to USIM without authentication as described in TS 33.401 [10].

### 5.11	Requirements for algorithms, and algorithm selection


#### 5.11.1	Algorithm identifier values


##### 5.11.1.1	Ciphering algorithm identifier values

All identifiers and names specified in this sub-clause are for 5G NAS and New Radio. In relation to AS capabilities, the identifiers and names for E-UTRAN connected to 5GC are specified in TS 33.401 [10].
Each encryption algorithm will be assigned a 4-bit identifier. The following values for ciphering algorithms are defined:
"00002"         NEA0			Null ciphering algorithm;
"00012"         128-NEA1		128-bit SNOW 3G based algorithm;
"00102"         128-NEA2		128-bit AES based algorithm; and
"00112"         128-NEA3		128-bit ZUC based algorithm.
128-NEA1 is based on SNOW 3G (see TS 35.215 [14]).
128-NEA2 is based on 128-bit AES [15] in CTR mode [16].
128-NEA3 is based on 128-bit ZUC (see TS 35.221 [18]).
Full details of the algorithms are specified in Annex D.

##### 5.11.1.2	Integrity algorithm identifier values

All identifiers and names specified in the present sub-clause are for 5G NAS and New Radio. In relation to AS capabilities, the identifiers and names for E-UTRAN connected to 5GC are specified in TS 33.401 [10].
Each integrity algorithm used for 5G will be assigned a 4-bit identifier. The following values for integrity algorithms are defined:
"00002"         NIA0			Null Integrity Protection algorithm;
"00012"         128-NIA1		128-bit SNOW 3G based algorithm;
"00102"         128-NIA2		128-bit AES based algorithm; and
"00112"         128-NIA3		128-bit ZUC based algorithm.
128-NIA1 is based on SNOW 3G (see TS 35.215 [14]).
128-NIA2 is based on 128-bit AES [15] in CMAC mode [17].
128-NIA3 is based on 128-bit ZUC (see TS 35.221 [18]).
Full details of the algorithms are specified in Annex D.

#### 5.11.2	Requirements for algorithm selection

a)	UE in RRC_Connected and a serving network shall have agreed upon algorithms for
-	Ciphering and integrity protection of RRC signalling and user plane (to be used between UE and gNB)
-	Ciphering and integrity protection of RRC signalling and  user plane (to be used between UE and ng-eNB)
-	NAS ciphering and NAS integrity protection (to be used between UE and AMF)
b)	The serving network shall select the algorithms to use dependent on
-	the UE security capabilities of the UE,
-	the configured allowed list of security capabilities of the currently serving network entity
c)	The UE security capabilities shall include NR NAS algorithms for NAS level, NR AS algorithms for AS layer and LTE algorithms for AS level if the UE supports E-UTRAN connected to 5GC.
NOTE:	If the UE supports both E-UTRAN and NR connected to 5GC, the UE 5G security capabilities include both the LTE and NR algorithms.
d)	Each selected algorithm shall be indicated to a UE in a protected manner such that a UE is ensured that the integrity of algorithm selection is protected against manipulation.
e)	The UE security capabilities shall be protected against "bidding down attacks".
f)	It shall be possible that the selected AS and NAS algorithms are different at a given point of time.

### 5.12	Requirements on 5G-RG

The 5G-RG shall be equipped with UICC where the subscription credentials resides. If provisioned by the home operator, the 5G-RG shall store the Home Network Public Key required for concealing the SUPI in the UICC.
The 5G-RG shall support all the security requirements and features of the UE defined in clause 5.2.

### 5.13	Requirements on NSSAAF

The Network slice specific and SNPN authentication and authorization function (NSSAAF) shall handle the Network Slice Specific Authentication requests from the serving AMF as specified in clause 16.The NSSAAF shall also support functionality for access to SNPN using credentials from Credentials Holder using AAA Server as specified in clause I.2.2.2.
The NSSAAF is responsible to send the NSSAA requests to the appropriate AAA-S.
The NSSAAF shall support AAA-S triggered Network Slice-Specific Re-authentication and Re-authorization and Slice-Specific Authorization Revocation and translate any AAA protocol into a Service Based format.
NSSAAF shall translate the Service based messages from the serving AMF or AUSF to AAA protocols towards AAA-P/AAA-S.
