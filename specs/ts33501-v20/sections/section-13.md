# 13	Service Based Interfaces (SBI)


### 13.1	Protection at the network or transport layer


#### 13.1.0	General

All network functions shall support mutually authenticated TLS and HTTPS as specified in RFC 9113 [47] and RFC 9110 [113]. The identities in the end entity certificates shall be used for authentication and policy checks. Network functions shall support both server-side and client-side certificates. TLS client and server certificates shall be compliant with the SBA certificate profile specified in clause 6.1.3c of TS 33.310 [5].
The TLS profile shall follow the profile given in clause 6.2 of TS 33.210 [3] with the restriction that it shall be compliant with the profile given by HTTP/2 as defined in RFC 9113 [47]. TLS clients shall include the SNI extension as specified in RFC 9113 [47].
TLS shall be used for transport protection within a PLMN unless network security is provided by other means.
NOTE 1: 	Regardless of whether TLS is used or not, NDS/IP as specified in TS 33.210 [3] and TS 33.310 [5] can be used for network layer protection.
NOTE 2:	If interfaces are trusted (e.g. physically protected), it is for the PLMN-operator to decide whether to use cryptographic protection.
NOTE 3:	It is a vendor implementation decision how the SNI extension is being used in TLS servers.

#### 13.1.1	TLS protection between NF and SEPP


##### 13.1.1.0	General

To allow for TLS protection between the SEPP and Network Functions or SCPs within a PLMN, the SEPP shall support:
-	TLS wildcard certificate for its domain name and generation of telescopic FQDN based on an FQDN obtained from the received N32-f message as specified in clause 13.1.1.1.
-	using the custom HTTP header 3gpp-Sbi-Target-apiRoot, defined in clause 5.2.3.2.4 of TS 29.500[74], in the HTTP request originated by the NF within the SEPP’s PLMN, to forward the protected HTTP Request message towards the remote PLMN as specified in clause 13.1.1.2.
NOTE: Whether the SEPP and NFs within the SEPP’s PLMN use telescopic FQDN or the custom HTTP header is based on PLMN operator’s policy.

##### 13.1.1.1	TLS protection based on telescopic FQDN and wildcard certificate

A telescopic FQDN is an FQDN with a single label as the first element and the SEPP’s domain as the trailer component. The label uniquely represents the original FQDN.
NOTE 3: The structure of telescopic FQDN is defined in 3GPP TS 23.003 [19], clause 28.5.2.
The SEPP shall generate a telescopic FQDN for the following messages received over N32-f:
a. Nnrf_NFDiscovery_Get response HTTP message with FQDNs of a set of the discovered NF or NF service instance(s) (see TS 29.510 [68]). The cSEPP generates a telescopic FQDN for each target Network Function FQDN in the Discovery response, rewrites the original FQDN with the telescopic FQDN and forwards the modified Discovery response to the NRF.
b. Subscription message with the Callback URI in the payload of the message (see TS 29.501 [94]). The pSEPP generates a telescopic FQDN from the Callback URI in the Subscription message, rewrites the original FQDN in the callback URI, and forwards the modified Subscription message to the producer Network Function.
c. Nsmf_PDUSession_POST HTTP message from a V-SMF with PduSessionCreateData containing the URI representing the PDU session in the V-SMF (see TS 29.502 [95]). The pSEPP generates a telescopic FQDN from the Callback URI in the message, rewrites the original FQDN in the callback URI, and forwards the modified message to the target H-SMF.
The following procedure illustrates how SEPPs use telescopic FQDN and wildcard certificate to establish a TLS connection between a Network Function or a SCP and the SEPP:
1.	When the SEPP receives one of the messages identified in a-c above, it shall rewrite the FQDN from the received message with a telescopic FQDN and it forwards the modified HTTP message to the target Network Function or SCP inside the PLMN.
2.	When the Network Function or SCP that received the telescopic FQDN in step 1 is ready to communicate with the target Network Function or SCP in another PLMN, it uses the telescopic FQDN in the Request URI of the HTTP Request. When communication between the Network Function or SCP and the SEPP that generated the telescopic FQDN is based on using the 3gpp-Sbi-Target-apiRoot custom HTTP header as specified in TS 29.500 [74], clause 5.2.3.2.4, the Network Function or SCP uses the telescopic FQDN in the 3gpp-Sbi-Target-apiRoot custom HTTP header of the HTTP Request. During TLS setup between the Network Function and the SEPP, the SEPP shall authenticate towards the Network Function or SCP using the wildcard certificate.
3. 	When the SEPP receives a HTTP request from the Network Function or SCP, the SEPP shall rewrite the telescopic FQDN with the original FQDN by replacing the unique delimiter in the label with the period character and removing its own suffix part.

##### 13.1.1.2	TLS protection based on 3gpp-Sbi-Target-apiRoot HTTP header

The NF uses the 3gpp-Sbi-Target-apiRoot HTTP header in the HTTP Request to convey the target FQDN to the SEPPs.
If PRINS is used on the N32-f interface, the following applies: The sending SEPP shall use the 3gpp-Sbi-Target-apiRoot header to obtain the apiRoot to be used in the request URI of the protected HTTP Request. It removes the 3gpp-Sbi-Target-apiRoot header before forwarding the protected HTTP Request on the N32-f interface.
If TLS is used on the N32 interface, the following applies: The sending SEPP shall replace the authority header in the HTTP Request with the FQDN of the receiving SEPP before forwarding the protected HTTP Request on the N32 interface. The sending SEPP shall not change the 3gpp-Sbi-Target-apiRoot header.
NOTE: This solution does not require the SEPP to support TLS wildcard certificate for its domain name during TLS setup, nor the SEPP to generate a telescopic FQDN for the target FQDN.

#### 13.1.2	Protection between SEPPs

TLS shall be used for N32-c connections between the SEPPs.
If the N32-c TLS is established between the SEPPs over one or more Roaming Intermediaries using HTTP CONNECT, as specified in clause 5.5.2.1 of TS 29.573 [73], the HTTP CONNECT request headers including the 3gpp-Connect-Req-Info header and the HTTP CONNECT response headers including the 3gpp-Connect-Res-Info header shall support integrity protection and replay protection using JWS [45].
Transport layer protection of HTTP CONNECT between the initiating SEPP and the first Roaming Intermediary shall be NDS/IP, TLS VPN, or HTTPS with mutual authentication.
The SEPP shall maintain a set of trust anchors. For N32-c and N32-f when the selected security method is "TLS", each trust anchor consists of a list of trusted root certificates and a list of corresponding PLMN-IDs. For NDS/IP, TLS VPN, or HTTPS used for N32-f when the selected security method is "PRINS", each trust anchor consists of a list of trusted root certificates and a list of unique identifiers for a given Roaming Intermediary (RI). Any given PLMN-ID and any given RI identifier shall appear in at most one trust anchor.
The SEPP should maintain an ‘RI-to-PLMN mapping’, i.e. a local configuration for each RI that lists the PLMN-IDs of the PLMNs for which roaming via that particular RI has been enabled contractually.
NOTE 3: Void
During N32-c connection setup, the SEPP shall map the PLMN-IDs as extracted from the remote SEPP end entity certificate to the associated trust anchor for the purposes of certificate chain verification. Only the root certificates in the associated list shall be treated as trusted during certificate chain verification. If the remote SEPP end entity certificate contains multiple PLMN-IDs that are mapped to different trust anchors, then that certificate shall be rejected.
Operator Group Roaming Hubs SEPPs are equivalent to a network operator SEPP when they are in the same security domain and are not considered Roaming Intermediaries as detailed in this clause. The communication between a group network operator's SBA network border element and the Operator Group Roaming Hub SEPP is out of scope of the present document.
If there are no Roaming Intermediaries between the SEPPs, TLS shall be used for N32-f connections between the SEPPs. Different TLS connections are used for N32-c and N32-f. If there are Roaming Intermediaries which only offer IP routing service between SEPPs, either TLS or PRINS (application layer security) shall be used for protection of N32-f connections between the SEPPs. PRINS is specified in clause 5.9.3 (requirements) and clause 13.2 (procedures).
If TLS is selected, the SEPP shall correlate the N32-f TLS connection with the N32-c connection. If the peer network is a PLMN, the SEPP compares the PLMN-IDs contained in the SEPP TLS certificates used to establish the N32-c and N32-f connections. Specifically, if the certificate used for N32-f contains one or more PLMN-IDs that are not contained in the TLS certificate used for the corresponding N32-c, the N32-f certificate shall be rejected. If the peer network is an SNPN, the SEPP compares the SNPN-ID contained in the SEPP TLS certificates used to establish the N32-c and N32-f connections.
The SEPP shall check whether the PLMN-IDs in the header and JSON fields, if any, of incoming N32-f messages are abnormal by matching the PLMN-ID(s) in the relevant trust anchor, remote PLMN-ID(s) in the N32-f context, or in the relevant RI-to-PLMN mapping. More precisely, if TLS is used for N32-f, then the relevant trust anchor is the one selected during the setup of the correlated N32-c connection and, if PRINS via an RI is used, then the matching is performed against the relevant RI-to-PLMN mapping whichwhere the RI is the remote endpoint of the NDS/IP, TLS VPN or HTTPS connection. The SEPP should support a mode of logging where mismatches are logged.
If there are Roaming Intermediaries which, in addition to IP routing, offer other services that require modification or observation of the information and/or additions to the information sent between the SEPPs, PRINS shall be used for protection of N32-f connections between the SEPPs.
NOTE 1a:	The procedure specified in clause 13.5 for security mechanism selection between SEPPs allows SEPPs to negotiate which security mechanism to use for protecting NF service-related signalling over N32, and provides robustness and future-proofness, e.g. in case new algorithms are introduced in the future.
If PRINS is the selected security method for N32-f interface, one of the following additional transport protection methods shall be applied between SEPP and Roaming Intermediary for confidentiality and integrity protection:
-	NDS/IP as specified in TS 33.210 [3] and TS 33.310 [5], or
-	TLS VPN with mutual authentication following the profile given in clause 6.2 of TS 33.210 [3] and clause clause 6.1.3a of TS 33.310 [5]. The identities in the end entity certificates shall be used for authentication and policy checks, with the restriction that it shall be compliant with the profile given by HTTP/2 as defined in RFC 9113 [47].
-	HTTP over TLS (HTTPS) as defined in RFC 9110 [113] with mutual authentication.
During NDS/IP, TLS VPN, or HTTPS connection setup with an RI for the purpose of establishing N32-f or N32-c via the HTTP CONNECT method, the SEPP shall map the RI identifiers as extracted from the RI end entity  certificate to the associated trust anchor for the purposes of certificate chain verification. Only the root certificates in the associated list shall be treated as trusted during certificate chain verification. If the RI end entity certificate contains multiple RI identifiers that are mapped to different trust anchors, then that certificate shall be rejected.
NOTE 1:	Void
NOTE 2:	Void.
NOTE 4: Whether or not a given RI identifier includes the PLMN-IDs that correspond to the roaming partners that are reachable via that RI, is not specified in 3GPP.

### 13.2	Application layer security on the N32 interface


#### 13.2.1	General

The internetwork interconnect allows secure communication between service-consuming and a service-producing NFs in different PLMNs. Security is enabled by the Security Edge Protection Proxies of both networks, henceforth called cSEPP and pSEPP respectively. The SEPPs enforce protection policies regarding application layer security thereby ensuring integrity and confidentiality protection for those elements to be protected.
NOTE: In the following the descriptions are provided for IPXs providers as types of Roaming Intermediaries, but equally apply to Roaming Hubs as types of Roaming Intermediaries.
It is assumed that there are interconnect providers between cSEPP and pSEPP. The interconnect provider with which the cSEPP's operator has a business relationship with is called cIPX, while the interconnect provider with which the pSEPP's operator has a business relationship with is called pIPX. There could be further interconnect providers in between cIPX and pIPX, but they are assumed to be transparent and simply forward the communication.
The SEPPs use JSON Web Encryption (JWE, specified in RFC 7516 [59]) for protecting messages on the N32-f interface, and the Roaming Intermediaries use JSON Web Signatures (JWS, specified in RFC 7515 [45]) for signing their modifications needed for their mediation services.
For illustration, consider the case where a service-consuming NF sends a message to a service-producing NF. If this communication is across PLMN operators over the N32-f interface, as shown in Figure 13.2.1-1 below, the cSEPP receives the message and applies symmetric key based application layer protection, as defined in clause 13.2 of the present document. The resulting JWE object is forwarded to roaming intermediaries. The Roaming Intermediaries (e.g., pIPX and cIPX as shown in Figure 13.2.1-1) can offer services that require modifications of the messages transported over the interconnect (N32) interface. These modifications are appended to the message as digitally signed JWS objects which contain the desired changes. The pSEPP, which receives the message from the Roaming Intermediary, validates the JWE object, extracts the original message sent by the NF, validates the signature in the JWS object and applies patches corresponding to the modifications by roaming intermediaries. The pSEPP then forwards the message to the destination NF.
The N32 interface consists of:
-	N32-c connection, for management of the N32 interface, and
-	N32-f connection, for sending of JWE and JWS protected messages between the SEPPs.
The application layer security protocol for the N32 interface described in clause 13.2 of the present document is called PRINS.
Figure 13.2.1-1: Overview of PRINS (IPX as the exemplary Roaming Intermediary)

#### 13.2.2	N32-c connection between SEPPs


##### 13.2.2.1	General

When the negotiated security mechanism to use over N32, according to the procedure in clause 13.5, is PRINS (described in clause 13.2), the SEPPs use the established TLS connection (henceforth referred to as N32-c connection) to negotiate the N32-f specific associated security configuration parameters required to enforce application layer security on HTTP messages exchanged between the SEPPs. A second N32-c connection is established by the receiving SEPP to enable it to not only receive but also send HTTP Requests.
The N32-c connection is used for the following purposes:
-	Key agreement: The SEPPs independently export keying material associated with the first N32-c connection between them and use it as the pre-shared key for generating the shared session key required.
-	Parameter exchange: The SEPPs exchange security related configuration parameters that they need to protect HTTP messages exchanged between the two Network Functions (NF) in their respective networks.
-	Error handling: The receiving SEPP sends an error signalling message to the peer SEPP when it detects an error on the N32-f interface.
The following security related configuration parameters may be exchanged between the two SEPPs:
a.	Modification policy. A modification policy, as specified in clause 13.2.3.4, indicates which IEs can be modified by a Roaming Intermediary (RI) of the sending SEPP.
b. 	Data-type encryption policy. A data-type encryption policy, as specified in 13.2.3.2, indicates which types of data will be encrypted by the sending SEPP.
c.	Cipher suites for confidentiality and integrity protection, when application layer security is used to protect HTTP messages between them.
d.	N32-f context ID. As specified in clause 13.2.2.4.1, N32-f context ID identifies the set of security related configuration parameters applicable to a protected message received from a SEPP in a different PLMN.

##### 13.2.2.2	Procedure for Key agreement and Parameter exchange

1. The two SEPPs shall perform the following cipher suite negotiation to agree on a cipher suite to use for protecting NF service related signalling over N32-f.
1a. The SEPP which initiated the first N32-c connection shall send a Security Parameter Exchange Request message to the responding SEPP including the initiating SEPP’s supported cipher suites. The cipher suites shall be ordered in initiating SEPP’s priority order. The SEPP shall provide an initiating SEPP’s N32-f context ID for the responding SEPP.
1b. The responding SEPP shall compare the received cipher suites to its own supported cipher suites and shall select, based on its local policy, a cipher suite, which is supported by both initiating SEPP and responding SEPP.
1c. The responding SEPP shall send a Security Parameter Exchange Response message to the initiating SEPP including the selected cipher suite for protecting the NF service-related signalling over N32. The responding SEPP shall provide a responding SEPP’s N32-f context ID for the initiating SEPP.
2. The two SEPPs may perform the following exchange of Data-type encryption policies and Modification policies. Both SEPPs shall store protection policies sent by the peer SEPP.
2a. The SEPP which initiated the first N32-c connection shall send a Security Parameter Exchange Request message to the responding SEPP including the initiating SEPP’s Data-type encryption policies, as described in clause 13.2.3.2, and Modification policies, as described in clause 13.2.3.4.
2b. The responding SEPP shall store the policies if sent by the initiating SEPP.
2c. The responding SEPP shall send a Security Parameter Negotiation Response message to the initiating SEPP with the responding SEPP’s suite of protection policies.
2d. The initiating SEPP shall store the protection policy information if sent by the responding SEPP.
Alternatively to exchanging complete policies in steps 2a and 2c, the SEPPs may indicate a security profile.
NOTE 1:	A security profile can for example include default modification policies and default data_type encryption policies and/or a list of IEs to be protected, during the N32-c negotiation process. PRINS security profile specification is out of scope of 3GPP.
3. The two SEPPs shall exchange Roaming Intermediary (RI) security information lists that contain information on RI public keys or certificates that are needed to verify RI modifications at the receiving SEPP.
4. The two SEPPs shall export keying material from the TLS session established between them using the TLS export function. For TLS 1.2, the exporter specified in RFC 5705 [61] shall be used. For TLS 1.3, the exporter described in section 7.5 of RFC 8446 [60] shall be used. The exported key shall be used as the master key to derive session keys and IVs for the N32-f context as specified in clause 13.2.4.4.1.
5. When the responding SEPP needs to initiate traffic, e.g., error reporting, in the reverse direction to the sending SEPP, the responding SEPP in the first N32-c connection shall now setup a second N32-c connection by establishing a mutually authenticated TLS connection with the peer SEPP.
NOTE 2:	The second N32-c connection setup by the responding SEPP does not perform the negotiation of steps 1-4.
6.	The two SEPPs start exchanging NF to NF service-related signalling over N32-f and tear down the N32-c connection.
7.	Depending on operator configuration, if the initiating SEPP determines that any of the security related configuration parameters from the N32-c parameter exchange are relevant for the Roaming Intermediaries, it shall send the parameters over N32-f in clear text with integrity protection to the responding SEPP; and the responding SEPP shall send the relevant security related configuration parameters in clear text with integrity protection in its response to the initiating SEPP over N32-f.
8.	The SEPPs may initiate new N32-c TLS sessions for any further N32-c communication that may occur over time while application layer security is applied to N32-f.

##### 13.2.2.3	Procedure for error detection and handling in SEPP

Errors can occur on an active N32-c connection or on one or more N32-f connections between two SEPPs.
When an error is detected, the SEPP shall map the error to an appropriate cause code. The SEPP shall create a signalling message to inform the peer SEPP, with cause code as one of its parameters.
The SEPP shall use the N32-c connection to send the signalling message to the peer SEPP. If the old N32-c connection has been terminated, it uses a new N32-c connection instead. If errors are relevant for the Roaming intermediaries, the error message shall be sent over N32-f to the peer SEPP, and shall be sent over N32-c if delivery over N32-f failed.
If the error occurred in the processing of the one or more N32-f message(s), the SEPP shall include the corresponding message ID (s), obtained from the metadata section of the N32-f message, as a parameter in the signalling message. This allows the peer SEPP to identify the source message(s) (HTTP Request or Response) on which the other SEPP found the error.
NOTE:	Local action taken by either SEPP is out of 3GPP scope.

##### 13.2.2.4	N32-f Context


###### 13.2.2.4.0	N32-f parts

The N32-f context consists of the following main parts as illustrated in Figure 13.2.2.4.0-1:
1.	N32-f context ID
2.	N32-f peer information
3.	N32-f security context
4.	N32-f context information
Figure 13.2.2.4.0-1: N32-f context overview

###### 13.2.2.4.1	N32-f context ID

The N32-f context ID is used to refer to an N32-f context. The SEPPs shall create the N32-f context ID during the N32-c negotiation and use it over N32-f to inform the receiving peer which security context to use for decryption of a received message.
The initiating SEPP shall send the initiating SEPP’s N32-f context ID to the responding SEPP which the responding SEPP shall use to identify the N32-f connection with this initiating SEPP. Vice versa, the responding SEPP shall send the responding SEPP’s N32-f context ID to the initiating SEPP which the initiating SEPP shall use to identify the N32-f connection with this responding SEPP. To avoid collision of the N32-f context ID value, the SEPPs shall select the N32-f context ID as a random value during the exchange over N32-c.
During transfer of application data over N32-f, the SEPP shall include the N32-f context ID in a separate IE in the metadata part of the JSON structure, see clause 13.2.4.2. The receiving SEPP shall use this information to apply the correct key and parameters during decryption and validation.

###### 13.2.2.4.2	N32-f peer information

The N32-f connection between SEPPs is bidirectional and consists of the two SEPP endpoints and possibly up to two Roaming Intermediaries. The SEPPs are identified by the PLMN ID and additionally a SEPP ID to distinguish between several SEPPs in the same PLMN. The remote SEPP address is necessary for routing the messages to the correct destination.
The N32-f peer information shall consist of the following parameters:
-	Remote PLMN ID;
-	Remote SEPP ID;
-	Remote SEPP address.

###### 13.2.2.4.3	N32-f security context

The N32-c initial handshake described in clause 13.2.2.2 establishes session keys, IVs and negotiated cipher suites. Counters are used for replay protection. Modification policies are identified by modification policy IDs, to be able to verify received messages that have undergone RI modifications.
The N32-f security context shall consist of the following parameters:
-	Session keys
-	Negotiated cipher suites
-	Data type encryption policy IDs
-	Modification policy list (if RIs are used)
-	Modification policy IDs
-	RI provider identifier
-	Counters
-	IVs
-	List of security information of the Roaming Intermediaries connected to the SEPPs (RI security information list)
-	RI provider identifier
-	List of raw public keys or certificates for that Roaming Intermediary

###### 13.2.2.4.4	N32-f context information

The N32-f context information shall consist of the following parameters:
-	Validity.
-	Usage (PRINS).

#### 13.2.3	Protection policies for N32 application layer solution


##### 13.2.3.1	Overview of protection policies

The protection policy suite is comprised of a data-type encryption policy and a modification policy. Together, these policies determine which part of a certain message shall be confidentiality protected and which part of a certain message shall be modifiable by Roaming Intermediaries. The SEPP shall apply the protection policies for application layer protection of messages on the N32-f interface.
There are two types of protection policies, namely:
-	Data-type encryption policy: specifies which data types need to be confidentiality protected;
-	Modification policy: specifies which IEs are modifiable by roaming intermediaries.
In addition, there is a mapping between the data-types in the data-type encryption policy and the IEs in NF API descriptions which is given in a NF-API data-type placement mapping.

##### 13.2.3.2	Data-type encryption policy

The SEPP shall contain an operator-controlled protection policy that specifies which types of data shall be encrypted. The data-types defined are the following:
-	Data of the type 'SUPI';
-	Data of the type 'authentication vector';
-	Data of the type 'location data';
-	Data of the type 'cryptographic material';
-	Data of the type 'authorization token'.
The policy shall be specific per roaming partner. The policy shall contain a policy identifier and a release number referring to the release it is applicable for.
The data-type encryption policies in the two partner SEPPs shall be equal to enforce a consistent ciphering of IEs on N32-f.

##### 13.2.3.3	NF API data-type placement mapping

Each NF API data-type placement mapping shall contain the following:
-	Which IEs contain data of the type 'SUPI' or type 'NAI'.
-	Which IEs contain data of the type 'authentication vector’.
-	Which IEs contain data of the type 'location data'.
-	Which IEs contain data of the type 'cryptographic material'.
-	Which IEs contain data of the type 'authorization token'.
The location of the IEs refers to the location of the IEs after the SEPP has rewritten the message for transmission over N32-f.
An NF API data-type placement mapping shall furthermore contain data that identifies the NF API, namely
-	The name of the NF;
-	The API version;
-	An identifier for the NF API data-type placement mapping;
- 	The NF’s 3GPP Release version.
NOTE: 	Larger networks can contain multiple NFs with the same API, e.g. three AMFs. The NF API policy applies to all NFs with the same API.
The NF API data-type placement mapping shall reside in the SEPP.

##### 13.2.3.4	Modification policy

The SEPP shall contain an operator-controlled policy that specifies which IEs can be modified by the RI provider directly related to this particular SEPP. These IEs refer to the IEs after the sending SEPP has rewritten the message.
Each PLMN-operator shall agree the modification policy with the RI provider it has a business relationship with prior to establishment of an N32 connection. Each modification policy applies to one individual relation between PLMN-operator and RI provider. To cover the whole N32 connection, both involved roaming partners shall exchange their modification policies.
NOTE 1: 	In order to validate modifications for messages received on the N32-f interface, the operator’s roaming partners will have to know the overall modification policy, e.g., via an API that supports authentication and authorization.
NOTE 2: Modification includes removal and addition of new IE. IEs therefore may not be present in the rewritten message.
The IEs that the RI is allowed to modify shall be specified in a list giving an enumeration of JSON paths within the JSON object created by the SEPP. Wildcards may be used to specify paths.
This policy shall be specific per roaming partner and per RI provider that is used for the specific roaming partner.
The modification policy shall reside in the SEPP.
For each roaming parter, the SEPP shall be able to store a policy for receiving.
The following basic validation rules shall always be applied irrespective of the policy exchanged between two roaming partners:
-	IEs requiring encryption shall not be inserted at a different location in the JSON object.

##### 13.2.3.5	Provisioning of the policies in the SEPP

The SEPP shall contain an interface that the operator can use to manually configure the protection policies in the SEPP.
The SEPP shall be able to store and process the following policies for outgoing messages:
-	A generic data-type encryption policy;
-	Roaming partner specific data-type encryption policies that will take precedence over a generic data-type encryption policy if present;
-	NF API data-type placement mappings;
-	Multiple modification policies, to handle modifications that are specific per RI provider and modification policies that are specific per RI provider and roaming partner.
The SEPP shall also be able to store and process the following policies for incoming messages during the initial connection establishment via N32-c:
-	Roaming partner specific data-type encryption policies;
-	Roaming partner specific modification policies that specify which fields can be modified by which of its RI providers.

##### 13.2.3.6	Precedence of policies in the SEPP

This clause specifies the order of precedence of data-type encryption policies and modification policies available in a SEPP.
In increasing order of precedence, the following policies apply for a message to be sent on N32:
1.	The set of default rules specified in the present specification:
-	For the data-type encryption policy, the rules on data-types that are mandatory to be encrypted according to clause 5.9.3.3.
-	For the modification policy, the basic validation rules defined in clause 13.2.3.4.
2.	Manually configured policies:
-	For the data-type encryption policy: rules according to clause 13.2.3.2, on a per roaming partner basis.
-	For the modification policy: rules according to clause 13.2.3.4, per roaming partner and per RI provider that is used for the specific roaming partner.
NOTE 1: 	It is assumed that operators agree both data-type encryption and modification policy in advance, for example as part of their bilateral roaming agreement. The protection policies exchanged via N32-c during the initial connection establishment only serve the purpose of detecting possible misconfigurations.
NOTE 2:	It is assumed that the default rules and manually configured policies do not overlap or contradict each other. The manually configured policies are used to extend the protection by the default rules in the present document and are applied on top of them.
When a SEPP receives a data-type encryption or modification policy on N32-c as specified in clause 13.2.2.2, it shall compare it to the one that has been manually configured for this specific roaming partner and RI provider. If a mismatch occurs for one of the two policies, the SEPP shall perform one of the following actions, according to operator policy:
-	Send the error message as specified in TS 29.573 [73], clause 6.1.4.3.2,  to the peer SEPP.
-	Create a local warning.

#### 13.2.4	N32-f connection between SEPPs


##### 13.2.4.1	General

The SEPP receives HTTP/2 request/response messages from the Network Function. It shall perform the following actions on these messages before they are sent on the N32-f interface to the SEPP in the other PLMN:
a)	It parses the incoming message and, if present, rewrites the telescopic FQDN of the receiving NF to obtain the original FQDN as described in clause 13.1.
b) 	It reformats the message to produce the input to JSON Web Encryption (JWE) [59] as described in clause 13.2.4.3.
c)	It applies JWE to the input created in b) to protect the reformatted message as described in clause 13.2.4.4.
d)	It encapsulates the resulting JWE object into a HTTP/2 message (as the body of the message) and sends the HTTP/2 message to the SEPP in the other PLMN over the N32-f interface.
The message may be routed via the one or two Roaming Intermediaries, e.g., cIPX and pIPX. These RIs may modify messages as follows:
a) The RI recovers the cleartext part of the HTTP message from the JWE object, modifies it according to the modification policy, and calculates an "operations" JSON Patch object. It then creates a temporary JSON object with the "operators" JSON Patch object and some other parameters for replay protection etc. as described in clause 13.2.4.5.1.
b) The RI uses the temporary JSON object as input into JSON Web Signature (JWS) [45] to create a JWS object, as described in clause 13.2.4.5.2.
c) The RI appends the JWS object to the received message and sends it to the next hop.
The JWS objects generated by the two RI providers form an auditable chain of modifications that to the receiving SEPP shall apply to the parsed message after verifying that the patches conform to the modification policy.
Encryption of IEs shall take place end to end between cSEPP and pSEPP.
A SEPP shall not include IEs in the clear that are encrypted elsewhere in the JSON object.
A SEPP shall verify that an intermediate RI has not moved or copied an encrypted IE to a location that would be reflected from the producer NF in an IE without encryption.

##### 13.2.4.2	Overall Message payload structure for message reformatting at SEPP

The SEPP reformats an HTTP message received from an internal Network Function into two temporary JSON objects that will be intput to JWE:
a. The dataToIntegrityProtect, containing information that is only integrity protected. It consists of the following:
-	clearTextEncapsulationMessage: contains the complete original HTTP message, excluding attribute values which require encryption and, including the pseudo-header fields, HTTP headers and HTTP message body.
-	metadata: contains SEPP generated information i.e. authorizedIPX ID, N32-f message ID and N32-f context ID.
b. The dataToIntegrityProtectAndCipher: contains attribute values of the original message that require both encryption and integrity protection.
For the details of JSON representation of a reformatted HTTP message, refer to TS 29.573 [92].

##### 13.2.4.3	Message reformatting in sending SEPP


###### 13.2.4.3.1	dataToIntegrityProtect


####### 13.2.4.3.1.1	clearTextEncapsulatedMessage

The clearTextEncapsulatedMessage is a JSON object that contains the non-encrypted portion of the original message.Specifically, it consists of the following objects:
1.a) Pseudo_Headers – the JSON object that includes all the Pseudo Headers in the message.
- For HTTP Request messages, the object contains one entry for each of the ":method", ":path", ":scheme" and ":authority" pseudo headers. If the ":path" pseudoheader contains multiple parts separated by a slash (/) or includes a query parameter (following a "?"), an array is used to represent :path, with one element per part of the path (i.e. per "directory").
NOTE:	This enables encryption of individual elements of the path (e.g. if SUPI is passed).
- For HTTP Response messages, the object contains the ":status" pseudo header.
1.b) HTTP_Headers – the JSON object that includes all the Headers in the message.
All the headers of the request are put into a JSON array called HTTP_Headers.Each entry contains a header name and value, where the value part can be an encoded index to the dataToIntegrityProtectAndCipher block, if the header value is encrypted.
1.c) Payload – the JSON object that includes the content of the payload of the HTTP message.
Each attribute or IE in the payload shall form a single entry in the Payload JSON object. If there is any attribute value that requires encryption, it shall be moved into the dataToIntegrityProtectAndCipher JSON object (clause 13.2.4.2), and the original value in this element shall be replaced by the index in the form {"encBlockIdx": <num>} where "num" is the index of the corresponding entry in the dataToIntegrityProtectAndCipher array.

####### 13.2.4.3.1.2	metadata

The JSON object containing information added by the sending SEPP. It shall contain:
a) N32-f message ID: Unique identifier (64-bit integer) representing a HTTP Request/Response transaction between two SEPPs. The N32-f message ID is generated by the sending SEPP and included in the HTTP Request sent over the N32 interface. The receiving SEPP uses the same N32-f message ID when it responds back with a HTTP Response. The N32-f message ID is included in the metadata portion of the JSON structure.
b) authorizedIPX ID: String identifying the first hop RI (e.g., cIPX or pIPX) that is authorized to update the message. This field shall always be present. When there is no RI that is authorized to update, the value of this field is set to  null. The sending SEPP selects one of the RI providers from the list exchanged with the other SEPP during parameter exchange over N32-c and includes its identifier value in this field.
c) N32-f context ID: Unique identifier representing the N32-f context information used for protecting the message. This is exchanged during parameter exchange over N32-c (clause 13.2.2.4.1).

###### 13.2.4.3.2	dataToIntegrityProtectAndCipher

The dataToIntegrityProtectAndCipher is a JSON patch document as per RFC 6902 [64] that contains all the attribute values that require both encryption and integrity protection. Attribute values may come from any part of the original HTTP message – Pseudo_Headers, HTTP_Headers and Payload.
The JSON array shall contain one array entry per attribute value that needs encryption. Each array entry represents the value of the attribute to be protected, and the index in the array is used to reference the protected value within the dataToIntegrityProtect block. This associates each attribute in the dataToIntegrityProtectAndCipher block with the original attribute in the dataToIntegrityProtect block. This is needed to reassemble the original message at the receiving SEPP.

##### 13.2.4.4	Protection using JSON Web Encryption (JWE)


###### 13.2.4.4.0	General

The SEPP shall use JSON Web Encryption (JWE) as specified in RFC 7516 [59] for the protection of reformatted HTTP messages between the SEPPs. All encryption methods supported by JWE are AEAD methods, i.e. methods that encrypt and integrity protect  in one single operation and can additionally integrity protect additional data.
The dataToIntegrityProtectAndCipher and dataToIntegrityProtect blocks shall be input to JWE as plaintext and JWE Additional Authenticated Data (AAD) respectively. The JWE AEAD algorithm generates JWE encrypted text (ciphertext) and a JWE Authentication Tag (Message Authentication Code). The ciphertext is the output from symmetrically encrypting the plaintext, while the authentication tag is a value that verifies the integrity of both the generated ciphertext and the Additional Authenticated Data.
The Flattened JWE JSON Serialization syntax shall be used to represent JWE as a JSON object.
The session key shared between the two SEPPs, as specified in clause 13.2.4.4.1, shall be used as the Content Encryption Key (CEK) value to the algorithm indicated in the Encryption algorithm ("enc") parameter in the JOSE header. The algorithm ("alg") parameter in the JOSE header denoting the key exchange method shall be set to "dir", i.e. "Direct use of a shared symmetric key as the CEK".
The 3GPP profile for supported cipher suites in the "enc" parameter is described in clause 13.2.4.9.
The generated JWE object shall be transmitted on the N32-f interface in the payload body of a SEPP to SEPP HTTP/2 message.

###### 13.2.4.4.1	N32-f key hierarchy

The N32-f key hierarchy is based on the N32-f master key generated during the N32-c initial handshake by TLS key export. The N32-f key hierarchy consists of two pairs of session keys and two pairs of IV salts, which are used in two different HTTP/2 sessions. In one Session the N32-c initiator acts as the HTTP client and in the second the N32-c responder acts as the client.
If the exported master secret is reused to set up multiple HTTP sessions or to set up new HTTP sessions on stream ID exhaustion, a new, unique, N32-f Context ID shall be generated to avoid key and IV re-use.
The master key shall be obtained from the TLS exporter. The export function takes 3 arguments: Label, Context, Length (in octets) of the desired output. For the N32 Master key derivation, the Label shall be the IANA registered label "EXPORTER_3GPP_N32_MASTER" [89], the Context shall be "" (the empty string) and the Length shall be 64.
The N32 key derivation function N32-KDF shall be based on HKDF [62] and shall use only the HKDF-Expand function as the initial key material has been generated securely:
N32-KDF (label, L) = HKDF-Expand (N32-f master key, "N32" || N32-Context-ID || label, L),
where
-	label is a string used for key separation,
-	L is the length of output keying material in octets.
Each run of N32-KDF (label, L) produces either one session key or one IV salt.
There are two pairs of session keys and IV salts to be derived.
NOTE:	In AES-GCM re-use of one IV may reveal the integrity key (Joux’s Forbidden attack). The binding of session keys and IV salts to N32-f context IDs and labels is essential to protect against inadvertent use of the same key with a repeated IV.
The labels for the JWE keys are:
-	"parallel_request_key"
-	"parallel_response_key"
-	"reverse_request_key", and
-	"reverse_response_key".
The keys derived with labels starting parallel shall be used for request/responses in an HTTP session with the N32-c initiating SEPP acting as the client (i.e. in parallel to the N32-c connection). The keys derived with the labels starting reverse shall be used for an HTTP session with the N32-c responding SEPP acting as the client.
To generate the IV salts, the length is 8 and the labels are:
-	"parallel_request_iv_salt",
-	"parallel_response_iv_salt",
-	"reverse_request_iv_salt", and
-	"reverse_response_iv_salt".
The 96-bit nonce for AES_GCM shall be constructed as the concatenation of the IV salt (8 octets, 64-bits) and the sequence counter, SEQ, following section 8.2.1 of NIST Special Publication 800-38D [63]:
Nonce = IV salt || SEQ.
The sequence counter shall be a 32-bit unsigned integer that starts at zero and is incremented for each invocation of the encryption.  A different sequence counter shall be maintained for each IV salt.

##### 13.2.4.5	Message modifications by roaming intermediary


###### 13.2.4.5.1	modifiedDataToIntegrityProtect

Figure 13.2.4.5.1-1 Example of JSON representation for RI with modifications by IPX1
This is a temporary JSON object generated by a RI provider as it modifies the original message. It shall contain the following:
a)	Operations – This is a JSON patch document that captures RI modifications based on RFC 6902 [64]. If no patch is required, the operations element shall be set to null.
b)	Identity – This is the identity of the RI performing the modification.
c)	Tag – A JSON string element to capture the "tag" value (JWE Authentication tag) in the JWE object generated by the sending SEPP. This is required for replay protection.
NOTE:	Since there is no central registry that can ensure unique RI Identities, it is expected that an RI will include its Fully Quantified Domain Name (FQDN) in the JSON modification object.

###### 13.2.4.5.2	Modifications by RIs

NOTE 1: 	It is assumed that operators act as a certification authority for RI providers they have a direct business relationship with. In order to authorize N32-f message modifications, operators sign a digital certificate for each of these RI providers and provide it to both the RI provider itself as well as their roaming partners to enable them to validate any modifications by this RI provider.
Only the maximum two RIs, e.g., cRI and pRI shall be able to modify messages between cSEPP and pSEPP. In cases of messages from cSEPP to pSEPP, the cRI is the first RI, while the pRI is the second RI. In cases of messages from pSEPP to cSEPP the pRI is the first RI, while the cRI is the second RI.
The first RI shall parse the encapsulated request (i.e. the clearTextEncapsulationMsg in the dataToIntegrityProtect block) and determine which changes are required. The first RI creates an  Operations JSON patch document to describe the differences between received and desired message, using the syntax and semantic from RFC 6902 [64], such that, when applying the JSON patch to the encapsulated request the result will be the desired request. If no patch is required, the operations element is null.
NOTE 2:	It is necessary to create a JWS object even if no patch is required to prevent deletion of modifications.
The first RI shall create a modifiedDataToIntegrityProtect JSON object as described in clause 13.2.4.5.1. The JSON object shall include the RI’s identity and the JWE authentication tag, which associates this update by the RI with the JWE object created by the sending SEPP.
The first RI shall use the modifiedDataToIntegrityProtect JSON object as input to JWS to create a JWS object. The first RI shall append the generated JWS object to the payload in the HTTP message and then send the messageto the next hop.
The second RI shall parse the encapsulated request, apply the modifications described in the JSON patch appended by the first RI and determine further modifications required for obtaining the desired request. The second RI shall record these modifications in an additional JSON patch against the JSON object resulting from application of the first RI's JSON patch. If no patch is required, the operations element for the second JSON patch is null.
The second RI shall create a modifiedDataToIntegrityProtect JSON object as described in clause 13.2.4.5.1. It shall include its identity and the JWE authentication tag, which associates this update by the second RI with the JWE object created by the sending SEPP.
The second RI shall use the modifiedDataToIntegrityProtect JSON object as input to JWS to create a JWS object. The second RI shall append the generated JWS object to the payload in the HTTP message and then send the message to the receiving SEPP.

###### 13.2.4.5.2a	Error messages originated  by Roaming Hub

In case a roaming hub needs to originate an error message, then clause 13.2.4.5.2 shall also apply with the following addition: If an error message needs to be sent, the originating roaming hub shall insert a reformattedData JSON element including only the metadata IE as defined in TS 29.573 [73], Table 6.2.5.2.2 for the Request, and Table 6.2.5.2.3 for the response, and the patches shall be based on a  reformattedData JSON element including only the metadata.
The reformattedData JSON element shall only contain metadata with N32-f message ID and N32-f context ID.

##### 13.2.4.6	Protecting RI modifications using JSON Web Signature (JWS)

The RI providers shall use JSON Web Signature (JWS) as specified in RFC 7515 [45] for the protection of RI provider modified attributes. The mechanism described in this clause uses signatures, i.e. asymmetric methods, with private/public key pairs.
More specifically, when an RI node modifies one or more attributes of the original HTTP message and creates a modifiedDataToIntegrityProtect object to record its modifications, it shall use JWS to integrity protect the modifiedDataToIntegrityProtect object.
The RI provider shall use its private key as input to JWS for generating the signature representing the contents of the modifiedDataToIntegrityProtect object.
The "alg" parameter in the JOSE header indicates the chosen signature algorithm. The 3GPP profile for supported algorithms is described in clause 13.2.4.9.
The Flattened JWS JSON Serialization syntax shall be used to represent JWS as a JSON object.

##### 13.2.4.7	Message verification by the receiving SEPP

The receiving SEPP determines that the received message is an error message generated by the Roaming Hub as Roaming Intermediary based on the reformattedData IE.
If the received messages is not generated by a Roaming Hub :
-	The receiving SEPP shall decrypt the JWE ciphertext using the shared session key and the following parameters obtained from the JWE object – Initialization Vector, Additional Authenticated Data value (clearTextEncapsulatedMessage in "aad") and JWE Authentication Tag ("tag").
-	The receiving SEPP shall check the integrity and authenticity of the clearTextEncapsulatedMessage and the encrypted text by verifying the JWE Authentication Tag in the JWE object with the JWE AAD algorithm. The algorithm returns the decrypted plaintext (dataToIntegrityProtectAndCipher) only if the JWE Authentication Tag is correct.
-	The receiving SEPP refers to the NF API in clearTextEncapsulatedMessage with values in the dataToIntegrityProtectAndCipher array.
-	The receiving SEPP shall next verify RI provider updates, if included, by verifying the JWS signatures added by the Roaming Intermediaries. The SEPP shall verify the JWS signature, using the corresponding raw public key or certificate that is contained in the Roaming Intermediary’s security information list obtained during parameter exchange in the related N32-c connection setup or, alternatively, has been configured for the particular peer SEPP.
-	The receiving SEPP shall then check that the raw public key or certificate of the JWS signature RI's Identity in the modifiedDataToIntegrity block matches to the RI provider referred to in the "authorizedIPX ID" field added by the sending SEPP, based on the information given in the RI provider security information list.
-	The receiving SEPP shall check whether the modifications performed by the Roaming Intermediaries, i.e. cRI and pRI, were permitted by the respective modification policies. The receiving SEPP shall use the modification policy of the cRI obtained during parameter exchange in the related N32-c connection setup, and use the modification policy of pRI configured within the receiving SEPP.
-	If this is the case, the receiving SEPP shall apply the patches in the Operations field in order, perform plausibility checks, and create a new HTTP request according to the "patched" clearTextEncapsulatedMessage.
-	The receiving SEPP shall verify that the PLMN-ID contained in the headers and JSON elements of the incoming N32-f message, if any, matches the PLMN-ID in the related N32-f context. The receiving SEPP should also verify that the PLMN-ID contained in the incoming N32-f message matches the PLMN-ID in the trust anchor selected during the setup of the TLS VPN, if any. In case of a mismatch the SEPP should log the event.
NOTE 1:	The above mismatch logging can be seen as an anomaly detection mechanism. It can both miss logging some anomalous events (false negatives) and log events that do not represent anomalies (false positives). False negatives occur, for example, when attack signalling carrying a particular PLMN-ID arrives over the TLS VPN or NDS/IP connection that is indeed associated with that PLMN-ID (e.g. generated by a compromised SEPP or an attacker with a fraudulently issued certificate), and false positives occur if signalling for a given PLMN-ID that previously arrived over a particular TLS VPN or NDS/IP connection starts arriving over a different one without this representing an attack. Such a change could be, for example, a result of contractual changes between PLMNs and RIs that were not configured before coming into effect. Dealing with false negatives and false positives is subject to operator policy and outside 3GPP scope.
If the received message is an error message generated by a Roaming Hub:
-	The receiving SEPP shall check that the raw public key or certificate of the JWS signature RI's identity in the modifiedDataToIntegrityProtect block matches the adjacent Roaming Hub identity.
-	The receiving SEPP dertermines the message in which the error occurred, based on the N32-f message ID.
-	If the receiving SEPP determines from the error message that the Roaming Hub requires a modified request message, it can modify if allowed by the MNO's policy, and can resend the modified request message.

##### 13.2.4.8	Procedure

The following clause illustrates the message flow between the two SEPPs with modifications from RIs, e.g., cRI and pRI.
Figure 13.2.4.8-1 Message flow between two SEPPs
1.	The cSEPP receives an HTTP request message from a network function. If the message contains a telescopic FQDN, the cSEPP removes its domain name from this FQDN to obtain the original FQDN as described in clause 13.1.
2.	The cSEPP shall reformate the HTTP Request message as follows:
a. The cSEPP shall generate blocks (JSON objects) for integrity protected data and encrypted data, and protecting them:
The cSEPP shall encapsulate the HTTP request into a clearTextEncapsulatedMessage block containing the following child JSON objects:
-	Pseudo_Headers
-	HTTP_Headers with one element per header of the original request.
-	Payload that contains the message body of the original request.
For each attribute that require end-to-end encryption between the two SEPPs, the attribute value is copied into a dataToIntegrityProtectAndCipher JSON object and the attribute's value in the clearTextEncapsulatedMessage is replaced by the index of attribute value in the dataToIntegrityProtectAndCipher block.
The cSEPP shall create a metadata block that contains the N32-f context ID, message ID generated by the cSEPP for this request/response transaction and next hop identity.
The cSEPP shall protect the dataToIntegrityProtect block and the dataToIntegrityProtectAndCipher block as per clause 13.2.4.4. This results in a single JWE object representing the protected HTTP Request message.
b. The cSEPP shall generate payload for the SEPP to SEPP HTTP message:
The JWE object becomes the payload of the new HTTP message generated by cSEPP.
3.	The cSEPP shall use HTTP POST to send the HTTP message to the first Roaming Intermediary.
4.	The first Roaming Intermediary (e.g. visited network's IPX provider) shall create a new modifiedDataToIntegrityProtect JSON object with three elements:
a. The Operations JSON patch document contains modifications performed by the first Roaming Intermediary as per RFC 6902 [64].
b. The first Roaming Intermediary shall include its own identity in the Identity field of the modifiedDataToIntegrityProtect.
c. The first Roaming Intermediary shall copy the "tag" element, present in the JWE object generated by the cSEPP, into the modifiedDataToIntegrityProtect object. This acts as a replay protection for updates made by the first Roaming Intermediary.
The Roaming Intermediary shall execute JWS on the modifiedDataToIntegrityProtect JSON object and append the resulting JWS object to the message.
5.	The first Roaming Intermediary shall send the modified HTTP message request to the second Roaming Intermediary (e.g. home network's IPX) as in step 3.
6.	The second Roaming Intermediary shall perform further modifications as in step 4 if required. The second Roaming Intermediary shall further execute JWS on the modifiedDataToIntegrityProtect JSON object and shall append the resulting JWS object to the message.
7.	The second Roaming Intermediary shall send the modified HTTP message to the pSEPP as in step 3.
NOTE 1:	The behaviour of the Roaming Intermediaries is not normative, but the pSEPP assumes that behaviour for processing the resulting request.
8.	The pSEPP receives the message and shall perform the following actions:
-	The pSEPP extracts the serialized values from the components of the JWE object.
- 	The pSEPP invokes the JWE AEAD algorithm to check the integrity of the message and decrypt the dataToIntegrityProtectAndCipher block. This results in entries in the encrypted block becoming visible in cleartext.
-	The pSEPP updates the clearTextEncapsulationMessage block in the message by replacing the references to the dataToIntegrityProtectAndCipher block with the referenced decrypted values from the dataToIntegrityProtectAndCipher block.
-	The pSEPP then verifies Roaming Intermediary updates of the attributes in the modificationsArray. It checks whether the modifications performed by the Roaming Intermediaries were permitted by policy.
The pSEPP further verifies that the PLMN-ID contained in the message is equal to the "Remote PLMN-ID" in the related N32-f context.
-	The pSEPP updates the modified values of the attributes in the clearTextEncapsulationMessage in order.
The pSEPP shall re-assemble the full HTTP Request from the contents of the clearTextEncapsulationMessage.
9.	The pSEPP shall send the HTTP request resulting from step 8 to the home network's NF.
10.-18.	These steps are analogous to steps 1.-9.

##### 13.2.4.9	JOSE profile

SEPPs shall follow the JWE profile and the corresponding restrictions defined in TS 33.210 [3].
SEPPs and Roaming Intermediaries shall follow the JWS profile as defined in TS 33.210 [3] with the restriction that they shall only use ES256 algorithm.

### 13.3	Authentication and static authorization


#### 13.3.0	Static authorization

Static authorization is based on local authorization policy at the NRF and the NF Service Producer. It can be used when token-based authorization is not used.
During the Nnrf_NFDiscovery procedure, the NRF ensures that the NF Service Consumer is authorized to discover the NF Service Producer service(s) as specified in clause 13.3.1.3 of this document.
If token-based authorization is not used within one PLMN and the NF Service Producer receives a service request, the NF Service Producer shall check authorization of the NF Service Consumer based on its local policy. If the NF Service Consumer is authorized to receive the service requested, the NF Service Producer shall grant the NF Service Consumer access to the service API.

#### 13.3.1	Authentication and authorization between network functions and NRF


##### 13.3.1.1	Direct communication

NRF and NF shall authenticate each other during discovery, registration, and access token request.
In direct communication, NF and NRF shall use one of the following methods for authentication:
-	If the PLMN uses protection at the transport layer as described in clause 13.1, authentication provided by the transport layer protection solution shall be used for mutual authentication of the NRF and NF.
-	If the PLMN does not use protection at the transport layer, mutual authentication of NRF and NF may be implicit by NDS/IP or physical security (see clause 13.1).

##### 13.3.1.2	Indirect communication

In indirect communication, NF and NRF shall use one of the following methods for authentication:
-	Mutual authentication between NF and NRF provided by the transport layer protection solution.
-	Client credentials assertion (CCA) based authentication as specified in clause 13.3.8.
NOTE 1:	Client credentials assertion authentication is based on a CCA token sent by the NF Service Consumer to the NRF via an intermediate such as the SCP. CCA based authentication does not provide authentication of the NRF towards the NF Service Consumer or protection of the service request sent by the NF Service Consumer to the NRF.
-	Implicit, i.e. by relying on authentication between NF Service Consumer and SCP, and between SCP and NRF, provided by the hop-by-hop security protection at the transport layer, NDS/IP, or physical security.
NOTE 2:	Mutual authentication between NF Service Consumer and NRF is not achieved with hop-by-hop security.
NOTE 3:	If only hop-by-hop security is used in a PLMN, the NRF is not able to verify that an access token request sent by SCP on behalf of a certain NF Service Consumer, is actually authorized by this consumer.

##### 13.3.1.3	Authorization of discovery request and error handling

When NRF receives message from unauthenticated NF, NRF shall support error handling, and may send back an error message. The same procedure shall be applied vice versa.
After successful authentication between NRF and NF, the NRF shall decide whether the NF is authorized to perform discovery and registration.
NOTE 1a: 	The NRF verifies that the values of the parameters in the Nnrf_NFDiscovery_Request received from the NF Service Consumer match with the values of those parameters in the profile of the NF Service Consumer stored at the NRF. This verification is implementation specific.
The NRF shall check that the values of the authorization parameters in the NF (Service) Profile of an NF Service Producer allows an NF Service Consumer to discover the NF Service Producer. In the response message, the NRF shall only return information of those NF Service Producer instances that the NF Service Consumer is authorized to discover.
NOTE 2: The authorization parameters in NF Profile are those used by NRF to determine whether a given NF Instance/NF Service Instance can be discovered by an NF Service Consumer.
In the non-roaming scenario, the NRF authorizes the Nnrf_NFDiscovery_Request based on the profile of the expected NF/NF service and the type of the NF Service Consumer, as described in clause 4.17.4 of TS23.502 [8].
In the roaming scenario, the NRF of the NF Service Producer shall authorize the Nnrf_NFDiscovery_Request based on the profile of the expected NF/NF Service, the type of the NF Service Consumer and the serving network ID.
NOTE 1b:	In the roaming scenario, the NRF verifies that the values of the parameters in the Nnrf_NFDiscovery_Request from the NF Service Consumer match with the values of those parameters in the profile of the NF Service Consumer stored at the NRF before sending the discovery request to the NRF of the NF Service Producer. This verification is implementation specific.
If the NRF finds NF Service Consumer is not allowed to discover the expected NF instances(s) as described in clause 4.17.4 of TS 23.502[8], NRF shall support error handling, and may send back an error message.
NOTE 1: 	Void.
When a NF consumes the Nnrf_NFManagement or the Nnrf_NFDiscovery services provided by the NRF, the usage of the OAuth 2.0 access token for authorization between the NF and the NRF is optional.

#### 13.3.2	Authentication between network functions


##### 13.3.2.1	Direct communication

In direct communication, authentication between network functions within one PLMN shall use one of the following methods:
-	If the PLMN uses protection at the transport layer as described in clause 13.1, authentication provided by the transport layer protection solution shall be used for authentication between NFs.
-	If the PLMN does not use protection at the transport layer, authentication between NFs within one PLMN may be implicit by NDS/IP or physical security (see clause 13.1).
If the PLMN uses token-based authorization, the network shall use protection at the transport layer as described in clause 13.1.

##### 13.3.2.2	Indirect communication

In indirect communication scenarios, the NF Service Producer and NF Service Consumer shall use implicit authentication by relying on authentication between NF Service Consumer and SCP, and between SCP and NF Service Producer, provided by the transport layer protection solution, NDS/IP, or physical security.
NOTE 0: Mutual authentication between NF Service Consumer and NF Service Producer is not achieved with hop-by-hop security.
If the PLMN uses token-based authorization as specified by clause 13.4.1.2 and the PLMN’s policy mandates that the NRF authenticates the NF Service Consumer before granting an access token, the access token indicates to the NF Service Producer that the NF Service Consumer has been authenticated by the NRF.
If additional authentication of the NF Service Consumer is required, the NF Service Producer authenticates the NF Service Consumer at the application layer using CCA based authentication as specified in clause 13.3.8.
The NF Service Consumer authentication based on CCA based authentication is optional to use, and based on operator policy.

##### 13.3.2.3	Inter-PLMN NF to NF communication

NOTE 1: Void
NOTE 2: Void
The Inter-PLMN UP Security functionality (IPUPS) as described in clauses 4.2.2 and 5.9.3.4 provide a standardised solution for binding 5G SBA REST Service Operations between the PLMN V-SMF and H-SMF over N16 / N32 to GTP-U over N9 in roaming scenarios.

##### 13.3.2.4	Error handling

When an NF receives a message from an unauthenticated NF, the receiving NF shall support error handling, and may send back an error message.

#### 13.3.3	Authentication between SEPP and network functions

NOTE 1: This clause also describes authentication between SEPP and NRF, because the NRF is a network function.
Authentication between SEPP and network functions within one PLMN shall use one of the following methods:
-	If the PLMN uses protection at the transport layer, authentication provided by the transport layer protection solution shall be used for authentication between SEPP and NFs.
-	If the PLMN does not use protection at the transport layer, authentication between SEPP and NFs within one PLMN may be implicit by NDS/IP or physical security (see clause 13.1).
A network function and the SEPP shall mutually authenticate before the SEPP forwards messages sent by the network function to network functions in other PLMN, and before the SEPP forwards messages sent by other network functions in other PLMN to the network function.

#### 13.3.4	Authentication and authorization between SEPPs

Authentication and authorization between SEPPs in different PLMNs is defined in clause 13.2.
13.3.5	Authentication between SEPP and SCP
Authentication between SEPP and SCP within one PLMN shall use one of the following methods:
-	If the PLMN uses protection at the transport layer, authentication provided by the transport layer protection solution shall be used for authentication between SEPP and SCP.
-	If the PLMN does not use protection at the transport layer, authentication between SEPP and SCP within one PLMN may be implicit by NDS/IP or physical security (see clause 13.1).
A SCP and the SEPP shall mutually authenticate before forwarding incoming or outgoing requests.

#### 13.3.6	Authentication and static authorization between SCP and network functions

The SCP and network functions shall use one of the following methods described in clause 13.1 to mutually authenticate each other before service layer messages can be exchanged on that interface:
-	If the PLMN uses protection at the transport layer, authentication provided by the transport layer protection solution shall be used for mutual authentication of the SCP and the network functions.
-	If the PLMN does not use protection at the transport layer, mutual authentication of the SCP and network functions may be implicit by NDS/IP or physical security.
Authentication between the SCP and the Network Function may be implicit by co-location.
Authorization between the SCP and NFs is based on local authorization policy. Regarding the authorization of access token requests sent by an SCP on behalf of an NF Service Consumer, NOTE 3 in clause 13.3.1.2 applies.

#### 13.3.7	Authentication and static authorization between SCPs

SCPs shall use one of the following methods as described in 13.1 to mutually authenticate each other before service layer messages can be exchanged on that interface:
-	If the PLMN uses protection at the transport layer, authentication provided by the transport layer protection solution shall be used for mutual authentication of the SCPs.
-	If the PLMN does not use protection at the transport layer, mutual authentication of the two SCPs may be implicit by NDS/IP or physical security.
Authorization between SCPs is based on local authorization policy.

#### 13.3.8	Client credentials assertion based authentication


##### 13.3.8.1	General

The Client credentials assertion (CCA) is a token signed by the NF Service Consumer. It enables the NF Service Consumer to authenticate towards the receiving end point (NRF, NF Service Producer) by including the signed token in a service request.
It includes the NF Service Consumer’s NF Instance ID that can be checked against the certificate by the NF Service Producer. The CCA includes a timestamp as basis for restriction of its lifetime.
CCAs are expected to be more short-lived than NRF generated access tokens. So, they can be used in deployments with requirements for tokens with shorter lifetime for NF-NF communication. There is a trade-off that when the lifetime of the CCA is too short, it requires the NF Service Consumer to generate a new CCA for every new service request.
The CCA cannot be used in the roaming case, as the NF Service Producer in the home PLMN will not be able to verify the signature of the NF Service Consumer in the visited PLMN unless cross-certification process is established between the two PLMNs through one of the mechanisms specified in TS 33.310.
CCA does not provide integrity protection on the full service request. Neither does it provide a mechanism for the NF Service Consumer to authenticate the NF Service Producer.
In this clause, CCAs are described generally for both NF-NRF communication and NF-NF communication.

##### 13.3.8.2	Client credentials assertion

CCAs shall be JSON Web Tokens as described in RFC 7519 [44] and are secured with digital signatures based on JSON Web Signature (JWS) as described in RFC 7515 [45].
The CCA shall include:
-	the NF instance ID of the NF Service Consumer (subject);
-	A timestamp (iat) and an expiration time (exp), and
-	The NF type of the expected audience (audience), i.e. the type "NRF" and/or the NF type of the NF Service Producer.
The NF Service Consumer shall digitally sign the generated CCA based on its private key as described in RFC 7515 [45]. The signed CCA shall include one of the following fields:
-	the X.509 URL (x5u) to refer to a resource for the X.509 public key certificate or certificate chain used for signing the client authentication assertion, or
-	the X.509 Certificate Chain (x5c) include the X.509 public key certificate or certificate chain used for signing the client authentication assertion.

##### 13.3.8.3	Verification of Client credentials assertion

The verification of the CCA shall be performed by the receiving node, i.e., NRF or NF Service Producer in the following way:
It validates the signature of the JWS as described in RFC 7515 [45].
It validates the timestamp (iat) and/or the expiration time (exp) as specified in RFC 7519 [44].
If the receiving node is the NRF, the NRF validates the timestamp (iat) and the expiration time (exp).
If the receiving node is the NF Service Producer, the NF Service Producer validates the expiration time and it may validate the timestamp.
It checks that the audience claim in the the CCA matches its own type.
It verifies that the NF instance ID of the NFc in the CCA matches the NF instance ID in the public key certificate used for signing the CCA.

### 13.4	Authorization of NF service access


#### 13.4.1	OAuth 2.0 based authorization of Network Function service access


##### 13.4.1.0	General

The authorization framework described in clause 13.4.1 allows NF Service Producers to authorize the requests from NF Service requestors. Subscription requests are also service requests.
The authorization framework uses the OAuth 2.0 framework as specified in RFC 6749 [43]. Grants shall be of the type Client Credentials Grant, as described in clause 4.4 of RFC 6749 [43]. Access tokens shall be JSON Web Tokens as described in RFC 7519 [44] and are secured with digital signatures or Message Authentication Codes (MAC) based on JSON Web Signature (JWS) as described in RFC 7515 [45]. The Access token shall follow the JWS profile specified in the clause 6.3.3 of TS 33.210 [3].
NOTE 1a: Securing the access token using Message Authentication Codes (MAC) based on JSON Web Signature (JWS) as described in RFC 7515 [45] requires a pairwise pre-shared symmetric key between the NRF and the NF Service Producer. MAC is not recommended due to the complexity related to provisioining and managing pre-shared symmetric key, and the provisioning of such pre-shared symmetric key is outside the scope of this document.
NOTE 1b: Securing the access token using digital signature based on JSON Web Signature (JWS) as described in RFC 7515 [45] requires a public/private key pair at the NRF and the public key of NRF at the NF Service Producer to allow the NF Service Producer to verify the digital signature of the access token.
The provisioning of the NF Service Producer with the public key of the NRF (either raw public key or through an X.509 certificate) to the NF Service Producer can be done for example by OAM, by using the service operation specified in clause 14.3.3 or in any other implementation specific way outside the scope of the present document.
The basic extent provided by the authorization token is at service level (i.e. the "scope" claim includes allowed services per NF type). Depending on the NF Service Producer configuration, higher level of granularity for the authorization token can be defined adding "additional scope" information within the token e.g. to authorize specific service operations and/or resources/data sets within service operations per NF Service Consumer type.
NOTE 1: The additional scope(s) included within the access token add additional security checks at the NF Service Producer that authorizes the services operations, resources and NF Service Consumer type related to the additional scope(s).
The authorization framework described in clause 13.4.1 is mandatory to support for NRF and NF.
The OAuth 2.0 framework does not apply to the notification operation.
Extensions to the authorization framework specific for the security of enablers for Network Automation by 5GS are described in Annex X.

##### 13.4.1.1	Service access authorization within the PLMN


###### 13.4.1.1.1	OAuth 2.0 roles

OAuth 2.0 roles, as defined in clause 1.1 of RFC 6749 [43], are as follows:
a.	The Network Repository Function (NRF) shall be the OAuth 2.0 Authorization server.
b.	The NF Service Consumer shall be the OAuth 2.0 client.
c.	The NF Service Producer shall be the OAuth 2.0 resource server.
OAuth 2.0 client (NF Service Consumer) registration with the OAuth 2.0 authorization server (NRF)
The NF Service registration procedure, as defined in clause 4.17.1 of TS 23.502 [8], may be used to register the OAuth 2.0 client (NF Service Consumer) with the OAuth 2.0 Authorization server (NRF), as described in clause 2.0 of RFC 6749 [43]. The client id, used during OAuth 2.0 registration, shall be the NF Instance Id of the NF. OAuth2.0 clients may also register with the NRF using OAM.
A Network Function that does not implement this option shall be able to get an access token from the NRF as long as the NRF is able to authenticate and authorize the Network Function during the NF access token get service request.
OAuth 2.0 resource server (NF Service Producer) registration with the OAuth 2.0 authorization server (NRF)
The NF Service registration procedure, as defined in clause 4.17.1 of TS 23.502 [8], shall be used to register the OAuth 2.0 resource server (NF Service Producer) with the OAuth 2.0 Authorization server (NRF). The NF Service Producer, as part of its NF profile, may include "additional scope" information related to the allowed service operations and resources per NF Service Consumer type.
Figure 13.4.1.1-1b NF Service Producer registers in NRF
1)	The NF Service Producer registers as OAuth 2.0 resource server in the NRF. The NF profile configuration data of the NF Service Producer may include the "additional scope". The "additional scope" information indicates the resources and the actions (service operations) that are allowed on these resources for the NF Service Consumer. These resources may be per NF type of the NF Service Consumer or per NF instance ID of the NF Service Consumer.
NOTE 1:	When the NF Service Producer registers at an NRF belonging to a NRF Set, any NRF within the NRF Set  can take the role of the authorization server of the NF Service Producer.
NOTE 2:	The handling of authorization server for NF type level access tokens is not addressed yet.
2-3)	After storing the NF Profile, NRF responds successfully.

###### 13.4.1.1.2	Service Request Process

The complete service request is a two-step process including requesting an access token by NF Service Consumer (Step 1, i.e. 1a or 1b), and then verification of the access token by NF Service Producer (Step 2).
NOTE 1a: The service request process regarding the enabler for network automation is specified in Annex X.
NOTE 1b: How the requested NRF finds the target NRF when multiple NRFs are deployed in one PLMN is described in clauses 5.4.2.2.2 and 5.4.2.2.3 of TS 29.510 [68].
Step 1: Access token request
Pre-requisite:
- The NF Service consumer (OAuth2.0 client) is registered with the NRF (Authorization Server).
- The NF Service Producer (OAuth2.0 resource server) is registered with the NRF (Authorization Server) with optionally "additional scope" information per NF type.
- The NRF and NF Service Producer share the required credentials.
- The NRF and NF have mutually authenticated each other – where the NF Service Consumer is identified by the NF Instance ID of the public key certificate of the NF Service Consumer.
1a. Access token request for accessing services of NF Service Producers of a specific NF type
The following procedure describes how the NF Service Consumer obtains an access token before service access to NF Service Producers of a specific NF type.
Figure 13.4.1.1.2-1: NF Service Consumer obtaining access token before NF Service access
1.	The NF Service Consumer shall request an access token from the NRF in the same PLMN using the Nnrf_AccessToken_Get request operation. The message shall include the NF Instance Id(s) of the NF Service Consumer, the requested "scope" including the expected NF Service name(s) and optionally "additional scope" information (i.e. requested resources and requested actions (service operations) on the resources).
The message shall include the NF type of the expected NF Service Producer instance and NF Service Consumer. The NF Service Consumer may also include a list of S-NSSAIs or list of NSI IDs for the expected NF Service Producer instances in the access token request. The message may include the NF Set ID and/or NF Service Set Id of the expected NF Service Producer instances.
The message may include a list of S-NSSAIs of the NF Service Consumer.The message may also include the PLMN ID(s) of the NF Service Consumer.
2.	The NRF shall verify that the input parameters NF Instance ID and NF type as well as PLMN ID(s), if available, in the access token request match with the corresponding ones in the public key certificate of the NF Service Consumer or those in the NF profile of the NF Service Consumer. If the verification of the parameters in the access token request fails, the access token request is not further processed.
The NRF shall additionally verify the S-NSSAIs of the NF Service Consumer and check whether there are restrictions on the NF Service Consumer to access NF Service Producers' services of a specific NF type depending on the slices for which they offer their services. The NRF checks whether the NF Service Consumer is authorized to access the requested service(s). For example, the NRF may verify that the NF Service Consumer can serve a slice which is included in the allowed slices for the NF Service Producer of a specific NF type. If the NF Service Consumer is authorized, the NRF shall then generate an access token with appropriate claims included. The NRF shall protect the access token as described in RFC 7515 [45] with a digital signature or a MAC.. If the NF Service Consumer is not authorized, the NRF shall not issue an access token to the NF Service Consumer.
The claims in the token shall include the NF Instance Id of NRF (issuer), NF Instance Id of the NF Service Consumer (subject), NF type of the NF Service Producer (audience), expected service name(s) (scope), expiration time (expiration) and optionally issued at (iat) and "additional scope" information (allowed resources and allowed actions (service operations) on the resources).
The claims may include a list of S-NSSAIs or NSI IDs for the expected NF Service Producer instances. The claims may include the NF Set ID and/or NF Service Set Id of the expected NF Service Producer instances.
NOTE a: If any, only slices supported by the NF Producer and authorized for the particular NF Consumer are included in the list of S-NSSAIs or list of NSI IDs for the expected NF Service Producer instances.
NOTE 1: If the claims do not include a list of NSSAIs or NSI IDs for the target NF type, it implies the token can be used to access expected NF services of all expected NF Service Producers of the NF type based on local configuration and operator policy.
NOTE 2: The expiration time claim (expiration) of the token is to impose time limits on the access token in use. It is carefully chosen based on the operator’s policy to allow flexibility and cost effectiveness, taking into consideration different threat situations and network complexities etc. In the present document, token revocation is not supported.
3.	If the authorization is successful, the NRF shall send access token to the NF Service Consumer in the Nnrf_AccessToken_Get response operation, otherwise it shall reply based on Oauth 2.0 error response defined in RFC 6749 [43]. The other parameters (e.g., the expiration time, allowed scope) sent by NRF in addition to the access token are described in TS 29.510 [68]. The NF Service Consumer may store the received token(s). Stored tokens may be re-used for accessing service(s) from NF Service Producer NF type listed in claims (scope, audience) during their validity time.
1b. Access token request for accessing services of a specific NF Service Producer instance / NF Service Producer service instance
The following steps describes how the NF Service Consumer obtains an access token before service access to a specific NF Service Producer instance / NF Service Producer service instance.
1. The NF Service Consumer shall request an access token from the NRF for a specific NF Service Producer instance / NF Service Producer service instance. The request shall include the NF Instance Id(s) of the requested NF Service Producer, the expected NF Service name, optionally "additional scope" information (allowed resources and allowed actions (service operations) on the resources) and NF Instance Id of the NF Service Consumer. The request may also include the PLMN ID(s) of the NF Service Consumer.
2.	The NRF shall verify that the input parameters in the access token request, i.e. NF Instance ID and, if available, PLMN ID(s) and NF type, match with the corresponding ones in the public key certificate of the NF Service Consumer or those in the NF profile of the NF Service Consumer. If the verification of the parameters in the access token request fails, the access token request is not further processed.
The NRF checks whether the NF Service Consumer is authorized to access the requested services from the NF Service Producer instance/NF Service Producer service instance. The NRF shall additionally verify the S-NSSAIs of the NF Service Consumer and check whether there are restrictions on the NF Service Consumer to access NF Service Producers' services depending on the NF Service Producer's allowed slices for which they offer their services. For example, the NRF may verify that the NF Service Consumer can serve a slice which is included in the allowed slices for the NF Service Producer instance / NF Service Producer service instance. If the NF Service Consumer is authorized, the NRF proceeds to generate an access token with the appropriate claims included. The NRF shall protect the access token as described in RFC 7515 [45] with a digital signature or a MAC. If the NF Service Consumer is not authorized, the NRF shall not issue an access token to the NF Service Consumer.
The claims in the token shall include the NF Instance Id of NRF (issuer), NF Instance Id of the NF Service Consumer (subject), NF Instance Id or several NF Instance Id(s) of the requested NF Service Producer (audience), expected service name(s) (scope), optionally issued at (iat) and "additional scope" information (allowed resources and allowed actions (service operations) on the resources), and expiration time (expiration).
The claims may include a list of S-NSSAIs or NSI IDs for the expected NF Service Producer instance or the expected NF Service Producer service instance.
NOTE b: If any, only slices supported by the NF Producer and authorized for the particular NF Consumer are included in the list of S-NSSAIs or list of NSI IDs for the expected NF Service Producer instances.
NOTE c: If the claims do not include a list of NSSAIs or NSI IDs, it implies the token can be used to access all NSSAIs or NSIs of the expected NF Service Producer instance or the expected NF Service Producer service instance based on local configuration and operator policy.
3.	The token shall be included in the Nnrf_AccessToken_Get response sent to the NF Service Consumer. The NF Service Consumer may store the received token(s). Stored tokens may be re-used for accessing service(s) from NF Instance Id or several NF Instance Id(s) of the requested NF Service Producer instance listed in claims (scope, audience) during their validity time.
Step 2: Service access request based on token verification
The following figure and procedure describe how authorization is performed during Service request of the NF Service Consumer. Prior to the request, the NF Service Consumer may perform Nnrf_NFDiscovery_Request operation with the requested additional scopes to select a suitable NF Service Producer (resource server) which is able to authorize the Service Access request.
Figure 13.4.1.1.2-2: NF Service Consumer requesting service access with an access token
Pre-requisite: The NF Service Consumer is in possession of a valid access token before requesting service access from the NF Service Producer.
1.	The NF Service Consumer requests service from the NF Service Producer. The NF Service Consumer shall include the access token.
The NF Service Consumer and NF Service Producer shall authenticate each other following clause 13.3.
2.	The NF Service Producer shall verify the token as follows:
-	The NF Service Producer shall check that the identity in the issuer claim in the access token matches the identity of the OAuth 2.0 authorization server(s) (NRF or NRF Set) that is allowed to issue access tokens to this NF Service Producer.
-	The NF Service Producer ensures the integrity of the token by verifying the signature using NRF’s public key or checking the MAC value using the shared secret.
NOTE 2a: The NF Service Producer needs the required root certificate to validate the NRF’s OAuth 2.0 Access Token certificate (chain).
NOTE 2b: To validate the access token, the NF Service Producer needs the public key identified by the header 	parameter. If the NF Service Producer does not have the public key, the NF retrieves the key using the service operation specified in clause 14.3.3 or another means of retrieval out of scope of the present document.
NOTE 2c: Certificate validation procedures are specified in clauses 6.3 and 10.4 of TS 33.310 [5].  The permitted header parameters are specified in clause 6.3.3 of TS 33.210 [3].
-	If integrity check is successful, the NF Service Producer shall verify the claims in the token as follows:
-	In the direct communication case, it checks that the NF Instance ID in the subject claim within the access token matches the NF Instance ID in the subjectAltName in the NF Service Consumer's TLS client certificate.
NOTE 3: Void.
-	It checks that the audience claim in the access token matches its own identity or the NF type of NF Service Producer. If a list of S-NSSAIs or list of NSI IDs of the NF type of the NF Service Producer is present in the access token, the NF Service Producer shall check that at least one of the S-NSSAIs or NSI IDs served by the NF Service Producer is included in the list. If applicable (e.g., when the request is for information related to a specific UE), the NF Service Producer may check that the NF Service Consumer is allowed to access (as indicated by the NF Service Producer’s S-NSSAIs in the access token presented by the NF Service Consumer) at least one slice(s) that the UE is currently registered to, e.g., by verifying that the UE’s allowed NSSAI(s) intersect with the NF Service Producer's S-NSSAIs in the access token.
-	If an NF Set ID present, the NF Service Producer shall check the NF Set ID in the claim matches its own NF Set ID.
If an NF Service Set ID present, the NF Service Producer shall check if the NF Service Consumer is authorized to access the requested service according to NF Service Producer Service Set ID in the access token claim.
-	If scope is present, it checks that the scope matches the requested service operation.
- 	If the access token contains "additional scope" information (i.e. allowed resources and allowed actions (service operations) on the resources), it checks that the additional scope matches the requested service operation.
-	It checks that the access token has not expired by verifying the expiration time in the access token against the current data/time It may decide to reject the issued access token based on "issued at" (iat) claim and local policy.
-	If the CCA is present in the service request, it may verify the CCA as specified in clause 13.3.8.3 and that the subject claim (i.e., the NF Instance Id of the NF Service Consumer) in the access token matches the subject claim in the CCA.
3.	If the verification is successful, the NF Service Producer shall execute the requested service and responds back to the NF Service Consumer. Otherwise, it shall reply based on Oauth 2.0 error response defined in RFC 6749 [43]. The valid error codes are maintained by IANA in the OAuth Parameters registry.

###### 13.4.1.1.3	Access token requests in deployments with several NRFs

As described in clause 6.2.6.1 of TS 23.501 [1], an operator network can deploy multiple NRFs, for example due to network slicing or network segmentation.
An NF Service Consumer shall send its access token requests to the NRF where it is registered as OAuth 2.0 client.  The NRF authenticates the NF Service Consumer, and shall verify the input parameters in the access token request as described under Step 1 in clause 13.4.1.1.2. If the verification of the parameters in the access token request fails, the access token request is not further processed. After successful authentication and verification of the input parameters, the NRF may forward the access token request to another NRF.
If an NRF receives an access token request for an NF Service Producer that is not registered at this NRF, the NRF determines the target NRF where the NF Service Producer is registered as specified in TS 29.510 [68] clause 5.4.2.2.2 step 2a, and forwards the access token request to the target NRF. There can also be several hops of NRFs between the NRF that receives the access token request from the NF Service Consumer and the target NRF where the NF Service Producer is registered.
One possible hierarchical NRF deployment is the local NRF deployment. An NF Service Producer’s local NRF is the NRF where the NF Service Producer registered its NF profile. In the local NRF deployment, the NF Service Producer is configured with the public key which corresponds to the private key that its local NRF uses for signing the access token. Thus, when the local NRF receives an access token request from an NF Service Consumer, the local NRF checks if the NF Service Consumer is authorized to receive the requested service and, if yes, issues and signs the access token. In the case when the access token request from the NF Service Consumer was forwarded by another NRF, the local NRF of the NF Service Producer needs to trust the NRF which forwarded the access token request.

##### 13.4.1.1A	Service access authorization in interconnect scenarios

In the inter-PLMN interconnect scenario, OAuth 2.0 roles are as follows:
a.	The NF Service Consumer's Network Repository Function (cNRF) shall be the OAuth 2.0 Authorization server for the PLMN of the NF Service Consumer (cPLMN) and authenticates the NF Service Consumer.
b.	The NF Service Producer's Network Repository Function (pNRF) shall be OAuth 2.0 Authorization server for the PLMN of the NF Service Producer (pPLMN) and generates the access token.
c.	The NF Service Consumer in the cPLMN shall be the OAuth 2.0 client.
d.	The NF Service Producer in the pPLMN shall be the OAuth 2.0 resource server.
As an example of the inter-PLMN interconnect use case, service access authorization in the roaming scenario where the service consumer NF is located in the visited PLMN and the service producer NF is located in the home PLMN is specified in clause 13.4.1.2.
An NF Service Consumer shall send its access token requests to the NRF in the consumer PLMN where it is registered as OAuth 2.0 client. The NRF in consumer PLMN authenticates the NF Service Consumer, and shall verify the input parameters in the access token request as described for the vNRF under Step 1 in clause 13.4.1.2.2. If the verification of the parameters in the access token request fails, the access token request is not further processed. After successful authentication and verification of the input parameters, the NRF in the consumer PLMN forwards the access token request to the NRF in the producer PLMN as described for the vNRF and hNRF under Step 1 in clause 13.4.1.2.2. The NRF in the producer PLMN checks whether the NF Service Consumer is authorized to access the requested service(s) as described for the hNRF under Step 1 in clause 13.4.1.2.2.

##### 13.4.1.2	Service access authorization in roaming scenarios


###### 13.4.1.2.1	OAuth 2.0 roles

In the roaming scenario, OAuth 2.0 roles are as follows:
a.	The visited Network Repository Function (vNRF) shall be the OAuth 2.0 Authorization server for vPLMN and authenticates the NF Service Consumer.
b.	The home Network Repository Function (hNRF) shall be OAuth 2.0 Authorization server for hPLMN and generates the access token.
c.	The NF Service Consumer in the visited PLMN shall be the OAuth 2.0 client.
d.	The NF Service Producer in the home PLMN shall be the OAuth 2.0 resource server.
OAuth 2.0 client (NF Service Consumer) registration with the OAuth 2.0 authorization server (NRF) in the vPLMN
Same as in the non-roaming scenario in 13.4.1.1.
OAuth 2.0 resource server (NF Service Producer) registration with the OAuth 2.0 authorization server (NRF) in the hPLMN
Same as in the non-roaming scenario in 13.4.1.1.

###### 13.4.1.2.2	Service Request Process

The complete service request is two-step process including requesting an access token by NF Service Consumer (Step 1, i.e. 1a or 1b), and then verification of the access token by NF Service Producer (Step 2).
Step 1: Access token request
Pre-requisite:
- The NF Service consumer (OAuth2.0 client) is registered with the vNRF (Authorization Server in the vPLMN).
- The hNRF and NF Service Producer share the required credentials. Additionally, the NF Service Producer (OAuth2.0 resource server) is registered with the hNRF (Authorization Server in the hPLMN) with optionally "additional scope" information per NF type.
- The two NRFs are implicitly authenticated via N32 mutual authentication of SEPPs.
NOTE 1: 	vSEPP to hSEPP communication is secured via N32. Only transitive trust between vNRF and hNRF can be achieved: The vNRF and vSEPP mutually authenticate, the vSEPP and hSEPP mutually authenticate, and the hSEPP and hNRF mutually authenticate. Hence, vNRF and hNRF can only implicitly authenticate each other.
- The NRF in the visited PLMN (vNRF) has authenticated the NF Service Consumer. –  where the NF Service Consumer is identified by the NF Instance ID of the public key certificate of the NF Service Consumer.
For SNPNs with Credentials Holder using AUSF and UDM for primary authentication, the NF Service Consumer and the vNRF are located in the SNPN while the hNRF is located in the Credentials Holder.
1a. Access token request for accessing services of NF Service Producers of a specific NF type
The following procedure describes how the NF Service Consumer obtains an access token for NF Service Producers of a specific NF type for use in the roaming scenario.
Figure 13.4.1.2.2-1: NF Service Consumer obtaining access token before NF Service access (roaming)
1.	The NF Service Consumer shall invoke Nnrf_AccessToken_Get Request (NF Instance Id of the NF Service Consumer, the requested "scope" including the  expected NF Service Name (s) and optionally "additional scope" information (i.e. requested resources and requested actions (service operations) on the resources), NF Type of the expected NF Service Producer instance, NF type of the NF Service Consumer, home PLMN ID and serving PLMN ID, optionally list of S-NSSAIs or list of NSI IDs for the expected NF Service Producer instances, optionally NF Set ID and/or the NF Service Set ID of the expected NF Service Producer) from NRF in the same PLMN.
For SNPNs with Credentials Holder using AUSF and UDM for primary authentication, the SNPN ID of the serving SNPN is included instead of the serving PLMN ID and the SNPN ID or the PLMN ID of the Credentials Holder is included instead of the home PLMN ID.
2.	The NRF in visited PLMN shall verify the input parameters in the access token request as described under Step 1 in clause 13.4.1.1.2. If the verification of the parameters in the access token request fails, the access token request is not further processed. After successful verification of the input parameters, the vNRF shall identify the NRF in home PLMN (hNRF) based on the home PLMN ID, and request an access token from hNRF as described in clause 4.17.5 of TS 23.502 [8]. The vNRF shall forward the parameters it obtained from the NF Service Consumer, including NF Service Consumer type, to the hNRF.
3.	The hNRF checks whether the NF Service Consumer is authorized to access the requested service(s). If the NF Service Consumer is authorized, the hNRF shall generate an access token with appropriate claims included as defined in clause 13.4.1.1. The hNRF shall digitally sign the generated access token based on a shared secret or private key as described in RFC 7515 [45]. If the NF service consumer is not authorized, the hNRF shall not issue an access token to the NF Service Consumer.
The claims in the token shall include the NF Instance Id of NRF (issuer), NF Instance Id of the NF Service Consumer appended with its PLMN ID (subject), NF type of the NF Service Producer appended with its PLMN ID (audience), expected services name(s), (scope) and expiration time (expiration), and optionally issued at (iat) and "additional scope" information (allowed resources and allowed actions (service operations) on the resources). The claims may include a list of S-NSSAIs or NSI IDs for the expected NF Service Producer instances. The claims may include the NF Set ID and/or the NF Service Set ID of the expected NF Service Producer instances.
NOTE 2: If any, only slices supported by the NF Producer and authorized for the particular NF Consumer are included in the list of S-NSSAIs or list of NSI IDs for the expected NF Service Producer instances.
NOTE 3: If the claims do not include a list of NSSAIs or NSI IDs for the target NF type, it implies the token can be used to access expected NF services of all expected NF Service Producers of the NF type based on local configuration and operator policy.
For SNPNs with Credentials Holder using AUSF and UDM for primary authentication, the SNPN ID of the serving SNPN is included instead of the NF Service Consumer's PLMN ID and the SNPN ID or the PLMN ID of the Credentials Holder is included instead of the NF Service Producer's PLMN ID.
4.	If the authorization is successful, the access token shall be included in Nnrf_AccessToken_Get Response message to the vNRF. Otherwise it shall reply based on Oauth 2.0 error response defined in RFC 6749 [43].
5.	The vNRF shall forward the Nnrf_AccessToken_Get Response or error message to the NF Service Consumer. The NF Service Consumer may store the received token(s). Stored tokens may be re-used for accessing service(s) from NF Service Producer NF type listed in claims (scope, audience) during their validity time. The other parameters (e.g., the expiration time, allowed scope) sent by NRF in addition to the access token are described in TS 29.510 [68].
1b. Obtain access token for accessing services of a specific NF Service Producer instance / NF Service Producer service instance
The following steps describes how the NF Service Consumer obtains an access token before service access to a specific NF Service Producer instance / NF Service Producer service instance.
1. The NF Service Consumer shall request an access token from the NRF for a specific NF Service Producer instance / NF Service Producer service instance. The request shall include the NF Instance Id of the requested NF Service Producer, appended with its PLMN ID, the expected NF service name and NF Instance Id of the NF Service Consumer, appended with its PLMN ID.
For SNPNs with Credentials Holder using AUSF and UDM for primary authentication, the SNPN ID of the serving SNPN is included instead of the NF Service Consumer's PLMN ID and the SNPN ID or the PLMN ID of the Credentials Holder is included instead of the NF Service Producer's PLMN ID.
2. The NRF in serving PLMN shall verify the input parameters in the access token request as described under Step 1 in clause 13.4.1.1.2. If the verification of the parameters in the access token request fails, the access token request is not further processed. After successful verification of the input parameters, the NRF in the visited PLMN shall forward the request to the NRF in the home PLMN.
3. The NRF in the home PLMN checks whether the NF Service Consumer is authorized to access the requested services from the NF Service Producer instance/NF Service Producer service instance and shall then proceed to generate an access token with the appropriate claims included. If the NF Service Consumer is not authorized, the NRF in the home PLMN shall not issue an access token to the NF Service Consumer.
The claims in the token shall include the NF Instance Id of NRF (issuer), NF Instance Id of the NF Service Consumer appended with its PLMN ID (subject), NF Instance Id of the requested NF Service Producer appended with its PLMN ID (audience), expected service name(s) (scope) and expiration time (expiration) and optionally issued at (iat). The claims may include a list of S-NSSAIs or NSI IDs for the expected NF Service Producer instance or the expected NF Service Producer service instance.
NOTE 4: If any, only slices supported by the NF Producer and authorized for the particular NF Consumer are included in the list of S-NSSAIs or list of NSI IDs for the expected NF Service Producer instances.
NOTE 5: If the claims do not include a list of NSSAIs or NSI IDs, it implies the token can be used to access all NSSAIs or NSI IDs of the expected NF Service Producer instance / NF Service Producer service instance based on local configuration and operator policy.
For SNPNs with Credentials Holder using AUSF and UDM for primary authentication, the SNPN ID of the serving SNPN is included instead of the NF Service Consumer's PLMN ID and the SNPN ID or the PLMN ID of the Credentials Holder is included instead of the NF Service Producer's PLMN ID.
4. The token shall be included in the Nnrf_AccessToken_Get response sent to the NRF in the visited PLMN.
5. The NRF in the visited PLMN shall forward the Nnrf_AccessToken_Get response message to the NF Service Consumer. The NF Service Consumer may store the received token(s). Stored tokens may be re-used for accessing service(s) from NF Instance Id or several NF Instance Id(s) of the requested NF Service Producer listed in claims (scope, audience) during their validity time.
Step 2: Service access request based on token verification
In addition to the steps described in the non-roaming scenario in 13.4.1.1, the NF Service Producer shall verify that the PLMN-ID (or SNPN ID) contained in the API request is equal to the one inside the access token.
Figure 13.4.1.2.2-2: NF Service Consumer requesting service access with an access token in roaming case
The NF Service Producer shall check that the home PLMN ID of audience claim in the access token matches its own PLMN identity.
For SNPNs with Credentials Holder using AUSF and UDM for primary authentication, the NF Service Producer verifies the SNPN ID of the serving SNPN contained in the API request instead of the PLMN-ID, and the SNPN ID or the PLMN ID of the Credentials Holder instead of the home PLMN ID.
The pSEPP shall check that the serving PLMN ID of subject claim in the access token matches the remote PLMN ID. If PRINS is used, this can be achieved by the pSEPP checking the PLMN ID of the serving network in the access token against the PLMN ID(s) in the N32-f context.
If the peer network is an SNPN, the pSEPP shall check that the SNPN ID of the NF Service Consumer in the access token matches the SNPN ID of the peer network.

##### 13.4.1.3	Service access authorization in indirect communication scenarios


###### 13.4.1.3.1	Authorization for indirect communication without delegated discovery procedure


####### 13.4.1.3.1.1	With mutual authentication between NF Service Consumer and NRF at the transport layer

This clause covers the scenario where the NF Service Consumer and the NRF are connected over a mutually authenticated TLS connection.
Figure 13.4.1.3.1.1-1: Authorization and service invocation procedure, for indirect communication without delegated discovery, with mutual authentication between NF and NRF at the transport layer
Discovery of the NF Service Producer:
0.	Optionally, the NF Service Consumer may discover the NF Service Producer before requesting authorization to invoke the services of the NF Service Producer. E.g. if the NF Service Consumer has not yet discovered the NF Service Producer, then it may run the discovery procedure.
NF Service Consumer authorization:
1-2.
After mutual authentication between NF Service Consumer and NRF at the transport layer, the NF Service Consumer and NRF perform the "Access token request before service access" procedure as described in clause 13.4.1.1. If the NF Service Consumer has already discovered the NF Service Producer, it can also perform the "Access token request for a specific NF Service Producer/NF Service Producer instance" procedure as described in clause 13.4.1.1.
Service request:
The NF Service Consumer, SCP, NRF and NF Service Producer perform the procedure "Indirect Communication without delegated discovery Procedure" described in clause 4.17.11 of TS 23.502 [8]. The following steps describe how the access token received from steps 1 and 2 is used in this procedure.
3.	If no cached data is available, the NF Service Consumer discovers the NF Service Producer via the SCP.
4.	The NF Service Consumer sends a service request for the specific service to the SCP. The service request includes the access token as received in step 2, and may include the NF Service Consumer CCA as defined in clause 13.3.8.
If the CCA is included, the NF type of the expected audience in the CCA shall contain the NF type of the NF Service Producer .
If the NF Service Consumer allows reselection of a target NF Service Producer by the SCP, the expected audience in the CCA shall also contain NF type "NRF".
NOTE:	In the same deployment, the NF Service Consumer can delegate the reselection of the target NF Service Producer to the SCP for some requests, and not for other requests.
5.	The SCP selects a NF Service Producer instance, performs the API root modifications and forwards the received request to the selected NF Service Producer instance. The request contains the access token and may contain the NF Service Consumer CCA if received in step 4.
6.	To authorize the access, the NF Service Producer authenticates the service consumer NF using one of the methods described in clause 13.3.2.2 and if successful, it validates the access token as described in clause 13.4.1.1 by verifying the signature and checking if the requested service is part of the token's scope.
7.   If the checks in step 6 are successful, the NF Service Producer processes the service request and provides a service response.
8.	The SCP performs reverse API root modifications and forwards the service response.

####### 13.4.1.3.1.2	Without mutual authentication between NF and NRF at the transport layer

When there is no  mutual authentication between NF Service Consumer and NRF at the transport layer, the NF Service Consumer performs the following procedure to obtain the access token from NRF and uses it for service access at the NF Service Producer. In this clause, the authentication of NF Service Consumer by the NRF and by the NF Service Producer is based on any of the methods described in clauses 13.3.1.2 and 13.3.2.2.
Figure 13.4.1.3.1.2-1: Authorization and service invocation procedure, for indirect communication without delegated discovery, without mutual authentication between NF and NRF at the transport layer
0.	Optionally, the NF Service Consumer may discover the NF Service Producer before requesting authorization to invoke the services of the NF Service Producer.
1. 	The NF Service Consumer sends an access token request (Nnrf_AccessToken_Get Request) to the SCP with parameters as specified in 13.4.1.1.  The access token request may additionally include the NF Service Consumer CCA as defined in clause 13.3.8.
If the CCA is included, the NF type of the expected audience in CCA shall contain NF type "NRF".
2. 	The SCP forwards the access token request (Nnrf_AccessToken_Get Request) to the NRF. The request may include the NF Service Consumer CCA if received in step 1.
3.	The NRF authenticates the service consumer NF using one of the methods described in clause 13.3.1.2. If the NF Service Consumer authentication is successful and the NF Service Consumer is authorized based on the NRF policy, the NRF issues an access token as described in clause 13.4.1.1. The NRF uses the NF Service Consumer NF Instance ID as the subject of the access token.
4.   The NRF sends the access token to the SCP in an access token response (Nnrf_AccessToken_Get Response).
5.	The SCP forwards the access token response (Nnrf_AccessToken_Get Response) to the NF Service Consumer, including the access token.
6.   The NF Service Consumer sends the service request to the SCP. The service request includes the access token received in Step 5 and may include the NF Service Consumer CCA.
If the CCA is included, the NF type of the expected audience in CCA shall contain the NF type of the NF Service Producer .
If the NF Service Consumer allows reselection of a target NF Service Producer by the SCP, the expected audience in the CCA shall also contain NF type "NRF".
NOTE: 	In the same deployment, the NF Service Consumer can delegate the reselection of the target NF Service Producer to the SCP for some requests, and not for other requests.
7.  The SCP forwards the service request to the NF Service Producer. The service request includes the access token received in step 6, and may include the NF Service Consumer CCA if received in step 6.
8.	The NF Service Producer authenticates the NF Service Consumer by one of the methods described in clause 13.3.2.2 and if successful, it validates the access token as described in clause 13.4.1.1.
9.	If the validation of the access token is successful, the NF Service Producer sends the service response to the SCP.
10.	The SCP forwards the service response to the NF Service Consumer.

###### 13.4.1.3.2	Authorization for indirect communication with delegated discovery procedure

This clause covers the scenario where the NF Service Consumer use the SCP to discover and select the NF Service Producer instance that can process the service request.
Figure 13.4.1.3.2-1: Authorization and service invocation procedure, for indirect communication with delegated discovery
1.	The NF Service Consumer sends a service request to the SCP. The service request may include the NF Service Consumer's CCA as defined in clause 13.3.8.The NF Service Consumer may include an access token in the service request if it has received an access token in a previous service response. If a previously received access token has expired, the NF Service Consumer may include discovery parameters as specified in TS 29.500 [74] clause 5.2.3.2.7 in the service request.
If the CCA is included, the NF type of the expected audience in CCA shall contain NF type of "NRF" and the NF type of the NF Service Producer .
2.	The SCP may perform a service discovery with the NRF. If NF Service Consumer has included an access token in step 1, or if the SCP has a cached granted access token, then SCP may reuse the access token and proceeds to step 6.
3. 	The SCP sends an access token request (Nnrf_AccessToken_Get Request) to the NRF. The access token request includes parameters as defined in clause 13.4.1.1. The access token request may include the NF Service Consumer's CCA if received in Step 1.
4.	The NRF authenticates the NF Service Consumer using one of the methods described in clause 13.3.1.2. If NF Service Consumer authentication is successful and the NF Service Consumer is authorized based on the NRF policy, the NRF issues an access token as described in clause 13.4.1.1. The NRF uses the NF Service Consumer instance ID as the subject of the access token.
5.	The NRF sends the access token to the SCP in an access token response (Nnrf_AccessToken_Get Response).
6.	The SCP sends the service request to the NF Service Producer. The service request includes an access token (i.e., received in Step 1, received in Step 5, or previously cached), and may include the NF Service Consumer's CCA if received in Step 1.
7.	The NF Service Producer authenticates the NF Service Consumer by one of the methods described in clause 13.3.2.2 and if successful, it validates the access token as described in clause 13.4.1.1.
8.	If the validation of the access token is successful, the NF Service Producer sends the service response to the SCP.
9.	The SCP forwards the service response to the NF Service Consumer. The SCP may include the access token in the service response to NF Service Consumer for possible re-use in subsequent service requests.

##### 13.4.1.4	Service access authorization in inter NF mobility scenario

During inter-NF mobility, i.e., AMF to AMF mobility and/or NWDAF to NWDAF mobility, subscriptions at the source NF are transferred to the target NF as part of the context transfer. The source NF may store the access token along with the created subscriptions and forward the access token to the target NF as a part of context transfer. The target NF authorizes the subscription based on its local policy. The target NF may use the received token from the source NF for authorizing the subscription.

##### 13.4.1.5	Service access authorization in interconnect and roaming scenarios with indirect communication


###### 13.4.1.5.1	General

This clause specifies specific requirements to support indirect communication with or without delegated discovery between different PLMNs as specified in clause 6.3.1 of 3GPP TS 23.501 [2] and clause 4.17.10a of 3GPP TS 23.502 [8].
The terms "source PLMN" and "target PLMN" throughout this clause refer respectively to the PLMN originating the request (i.e. the PLMN of the NF Service Consumer) and the PLMN receiving/serving the request (i.e. the PLMN of the NF Service Producer).
The OAuth 2.0 roles for interconnection scenario are described in clause 13.4.1.1A.

##### 13.4.1.5.2	Authorization with NF selection at source network


###### 13.4.1.5.2.1	General

In the scenario where NF Service Consumer and NF Service Producer are in different PLMNs and indirect communication (with or without delegated discovery) is deployed in the source network, the NF selection is performed at the source PLMN regardless of whether indirect communication is deployed in the target network or not. The SCP at the source PLMN sends an access token request to the target PLMN. The architecture is described in clause 4.17.10a of TS 23.502 [8].

###### 13.4.1.5.2.2	Authorization for indirect communication with or without delegated discovery procedure

Figure 13.4.1.5.2.2-1: Service access authorization in indirect communication (with or without delegated discovery) when NF Service Consumer and NF Service Producer are in different PLMNs and NF selection is at the source PLMN
Steps 1 and 2 of figure 13.4.1.5.2.2-1 correspond to one of the following:
-	Steps 0 to 4 in clause 13.4.1.3.1.1 (Authorization for indirect communication scenarios without delegated discovery, with mutual authentication between NF Service Consumer and NRF at the transport layer),
-	Steps 0 to 6 in clause 13.4.1.3.1.2 (Authorization for indirect communication scenarios without delegated discovery, without mutual authentication between NF Service Consumer and NRF at the transport layer), or
-	Steps 1 to 5 in clause 13.4.1.3.2 (Authorization for indirect communication with delegated discovery procedure),
with the following differences:
-	The NRF in the source PLMN itself does not perform the authorization of the NF Service Consumer. Instead, the NRF in the source PLMN forwards the access token request to an NRF in the target PLMN, via the SEPPs of the source PLMN and target PLMN.
-	The NRF in the target PLMN authorizes the NF Service Consumer as described for the hNRF in clause 13.4.1.2.2 (Service access authorization in roaming scenarios, service request process).
Steps 3 to 6 of figure 13.4.1.5.2.2-1 correspond to one of the following:
-	Steps 5 to 8 in clause 13.4.1.3.1.1 (Authorization for indirect communication scenarios without delegated discovery, with mutual authentication between NF Service Consumer and NRF at the transport layer),
-	Steps 7 to 10 in clause 13.4.1.3.1.2 (Authorization for indirect communication scenarios without delegated discovery, without mutual authentication between NF Service Consumer and NRF at the transport layer), or
-	Steps 6 to 9 in clause 13.4.1.3.2 (Authorization for indirect communication with delegated discovery procedure)
with the following differences:
-	The SCP in the source PLMN forwards the service request to the selected NF Service Producer in the target PLMN.
NOTE 1: The NRF in the target PLMN and NF Service Producer cannot authenticate the NF Service Consumer unless the NRF in the target PLMN and the NF Service Producer are provisioned with the required certificates to authenticate the NF Service Consumer.

##### 13.4.1.5.3	Authorization with NF selection at target network


####### 13.4.1.5.3.1	General

In scenarios where NF Service Consumer and NF Service Producer are in different PLMNs, when indirect communication is deployed in both source and target network, it is possible to delegate NF selection to the target network as described in clause 4.17.10a of TS 23.502 [8].
The present clause describes token-based authorization for the scenario where NF Service Consumer and NF Service Producer are in different PLMNs with indirect communication deployed (with or without delegated discovery), and NF selection is performed at the target PLMN.

####### 13.4.1.5.3.2	Authorization for indirect communication without delegated discovery procedure

Figure 13.4.1.5.3.2-1: Service access authorization when NF Service Consumer and NF Service Producer are in different PLMNs with indirect communication without delegated discovery and NF selection is at target PLMN
Steps 1 to 10 of Figure 13.4.1.5.3.2-1 for discovery and service access authorization correspond to one of the following:
-	Steps 0 to 8 in clause 13.4.1.3.1.1 (Authorization for indirect communication scenarios without delegated discovery, with mutual authentication between NF Service Consumer and NRF at the transport layer), or
-	Steps 0 to 10 in clause 13.4.1.3.1.2 (Authorization for indirect communication scenarios without delegated discovery, without mutual authentication between NF Service Consumer and NRF at the transport layer),
with the following differences in Step 2 of figure 13.4.1.5.3.2-1:
-	The NRF in the source PLMN (NRF1) does not perform the authorization of the NF Service Consumer but forwards the access token request to an NRF in the target PLMN (NRF2), via the SEPPs of the source PLMN and the target PLMN.
-	The NRF in the target PLMN (NRF2) authorizes the NF Service Consumer as described for the hNRF in clause 13.4.1.2.2 (Service access authorization in roaming scenarios, service request process).
NOTE: The NRF in the target PLMN and NF Service Producer cannot authenticate the NF Service Consumer unless the NRF in the target PLMN and the NF Service Producer are provisioned with required certificate to authenticate the NF Service Consumer.

####### 13.4.1.5.3.3	Authorization for indirect communication with delegated discovery procedure

Figure 13.4.1.5.3.3-1: Service access authorization when NF Service Consumer and NF Service Producer are in different PLMNs with indirect communication with delegated discovery and NF selection is at target PLMN
Steps 1 to 9 of figure 13.4.1.5.3.3-1 for service access authorization correspond to:
-	Steps 1 to 9 in clause 13.4.1.3.2 (Authorization for indirect communication with delegated discovery procedure)
with the following differences:
-	The Service Request (Step 1 in figure 13.4.1.5.3.3-1) and Service Response (Step 9 in figure 13.4.1.5.3.3-1) are sent between the NF Service Consumer in the source PLMN and SCP2 in the target PLMN, via SCP1 in the source PLMN and via the SEPPs in the source PLMN and target PLMN.
NOTE: The NRF in the target PLMN and NF Service Producer cannot authenticate the NF Service Consumer unless the NRF in the target PLMN and the NF Service Producer is provisioned with required certificates to authenticate the NF Service Consumer.

### 13.5	Security capability negotiation between SEPPs

The security capability negotiation over N32-c allows the SEPPs to negotiate which security mechanism to use for protecting NF service-related signalling over N32-f. There shall be an agreed security mechanism between a pair of SEPPs before conveying NF service-related signalling over N32-f.
When a SEPP notices that it does not have an agreed security mechanism for N32-f protection with a peer SEPP or if the security capabilities of the SEPP have been updated, the SEPP shall perform security capability negotiation with the peer SEPP over N32-c in order to determine, which security mechanism to use for protecting NF service-related signalling over N32-f. Certificate based authentication shall follow the profiles given in 3GPP TS 33.210 [3], clause 6.2.
A mutually authenticated TLS connection as defined in clause 13.1 shall be used for protecting security capability negotiation over N32-c. The TLS connection shall provide integrity, confidentiality and replay protection.
Figure 13.5-1 Security capability negotiation
1.	The SEPP which initiated the TLS connection shall issue a POST request to the exchange-capability resource of the responding SEPP including the initiating SEPP’s supported security mechanisms for protecting the NF service-related signalling over N32-f (see Table 13.5-1). The security mechanisms shall be ordered in the initiating SEPP’s priority order.
2.	The responding SEPP shall compare the received security capabilities to its own supported security capabilities and selects, based on its local policy (e.g. based on whether there are RI providers on the path between the SEPPs), a security mechanism, which is supported by both initiating SEPP and responding SEPP.
3.	The responding SEPP shall respond to the initiating SEPP with the selected security mechanism for protecting the NF service-related signalling over N32.
Table 13.5-1: NF service-related signalling traffic protection mechanisms over N32
If the selected security mechanism is PRINS, the SEPPs shall behave as specified in clause 13.2.
If the selected security mechanism is TLS, the SEPPs shall behave as specified in clause 13.1.2, tear down the N32-c connection and forward the NF service-related signalling over N32-f using a TLS connection.
If the selected security mechanism is a mechanism other than the ones specified in Table 13.5-1, the two SEPPs shall terminate the N32-c TLS connection.
