# 9	Security procedures for non-service based interfaces


### 9.1	General


#### 9.1.1	Use of NDS/IP

The protection of IP based interfaces for 5GC and 5G-AN according to NDS/IP is specified in TS 33.210 [3]. Traffic on interfaces carrying control plane signalling can be both integrity and confidentiality protected according to NDS/IP.
NOTE 1:	Void.

#### 9.1.2	Implementation requirements

IPsec ESP implementation shall be done according to RFC 4303 [4] as profiled by TS 33.210 [3]. For IPsec implementation, tunnel mode is mandatory to support while transport mode is optional.
IKEv2 certificate-based authentication implementation shall be done according to TS 33.310 [5]. The certificates shall be supported according to the profile described by TS 33.310 [5]. IKEv2 shall be supported conforming to the IKEv2 profile described in TS 33.310 [5].

#### 9.1.3	QoS considerations

If the sender of IPsec traffic uses DiffServ Code Points (DSCPs) to distinguish different QoS classes, either by copying DSCP from the inner IP header or directly setting the encapsulating IP header's DSCP, the resulting traffic may be reordered to the point where the receiving node's anti-replay check discards the packet. If different DSCPs are used on the encapsulating IP header, then to avoid packet discard under one IKE SA and with the same set of traffic selectors, distinct Child-SAs should be established for each of the traffic classes (using the DSCPs as classifiers) as specified in RFC 4301 [6].

### 9.2	Security mechanisms for the N2 interface

N2 is the reference point between the AMF and the 5G-AN. It is used, among other things, to carry NAS signalling traffic between the UE and the AMF over 3GPP and non-3GPP accesses.
The transport of control plane data over N2 shall be integrity, confidentiality and replay-protected.
In order to protect the N2 reference point, it is required to implement IPsec ESP and IKEv2 certificates-based authentication as specified in sub-clause 9.1.2 of the present document. IPsec is mandatory to implement on the gNB and the ng-eNB. On the core network side, a SEG may be used to terminate the IPsec tunnel.
In addition to IPsec, DTLS shall be supported as specified in RFC 6083 [58] to provide mutual authentication, integrity protection, replay protection and confidentiality protection. Security profiles for DTLS implementation and usage shall follow the TLS profile given in clause 6.2 of TS 33.210 [3] and the certificate profile given in clause 6.1.3a of TS 33.310 [5]. The identities in the end entity certificates shall be used for authentication and policy checks.
Mutual authentication shall be supported over the N2 interface between the AMF and the 5G-AN using DTLS and/or IKEv2.
NOTE 1: 	The use of transport layer security, via DTLS, does not rule out the use of network layer protection according to NDS/IP as specified in TS 33.210 [3]. In fact, IPsec has the advantage of providing topology hiding.
NOTE 2: 	The use of cryptographic solutions to protect N2 is an operator's decision. In case the NG-RAN node (gNB or ng-eNB) has been placed in a physically secured environment then the 'secure environment' includes other nodes and links beside the NG-RAN node.
NOTE 3: 	DTLS over SCTP as described in RFC 6083 [53] has message size limitations.

### 9.3	Security requirements and procedures on N3

N3 is the reference point between the 5G-AN and UPF. It is used to carry user plane data from the UE to the UPF.
The transport of user data over N3 shall be integrity, confidentiality and replay-protected.
In order to protect the traffic on the N3 reference point, it is required to implement IPsec ESP and IKEv2 certificate-based authentication as specified in sub-clause 9.1.2 of the present document with confidentiality, integrity and replay protection. IPsec is mandatory to implement on the gNB and the ng-eNB. On the core network side, a SEG may be used to terminate the IPsec tunnel.
NOTE: 	The use of cryptographic solutions to protect N3 is an operator's decision. In case the NG-RAN node (gNB or ng-eNB) has been placed in a physically secured environment then the 'secure environment' includes other nodes and links beside the NG-RAN node.
QoS related aspects are further described in sub-clause 9.1.3 of the present document.

### 9.4	Security mechanisms for the Xn interface

Xn is the interface connecting NG-RAN nodes. It consists of Xn-C and Xn-U. Xn-C is used to carry signalling and Xn-U user plane data.
The transport of control plane data and user data over Xn shall be integrity, confidentiality and replay-protected.
In order to protect the traffic on the Xn reference point, it is required to implement IPsec ESP and IKEv2 certificate- based authentication as specified in sub-clause 9.1.2 of the present document with confidentiality, integrity and replay protection. IPsec shall be supported on the gNB and ng-eNB.
In addition to IPsec, for the Xn-C interface, DTLS shall be supported as specified in RFC 6083 [58] to provide mutual authentication, integrity protection, replay protection and confidentiality protection. Security profiles for DTLS implementation and usage shall follow the TLS profile given in clause 6.2 of TS 33.210 [3] and the certificate profile given in clause 6.1.3a of TS 33.310 [5]. The identities in the end entity certificates shall be used for authentication and policy checks.
Mutual authentication shall be supported over the Xn interface between the NG-RAN nodes using DTLS and/or IKEv2.
NOTE 1: 	The use of transport layer security, via DTLS, does not rule out the use of network layer protection according to NDS/IP as specified in TS 33.210 [3]. In fact, IPsec has the advantage of providing topology hiding..
NOTE 2: 	The use of cryptographic solutions to protect Xn is an operator's decision. In case the NG-RAN node (gNB or ng-eNB) has been placed in a physically secured environment then the 'secure environment' includes other nodes and links beside the NG-RAN node.
NOTE 3: 	DTLS over SCTP as described in RFC 6083 [53] has message size limitations.
QoS related aspects are further described in sub-clause 9.1.3 of the present document.

### 9.5	Interfaces based on DIAMETER or GTP

This clause applies to all DIAMETER or GTP-based interfaces between the 5G Core and other network entities that are not part of the 5G System. These includes the Rx interface between the PCF and the IMS System and the N26 interface between the AMF and the MME.
The protection of these interfaces shall be supported according to NDS/IP as specified in TS 33.210 [3], unless security is provided by other means, e.g. physical security. If (D)TLS is used, implementation and usage shall follow the profile given in clause 6.2 of TS 33.210 [3] and clause 6.1.3a of TS 33.310 [5]. The cipher suites in RFC 6733 shall not be supported. A SEG may be used to terminate the NDS/IP IPsec tunnels.

#### 9.5.1	Void


### 9.6	Void


### 9.7	Void


### 9.8	Security mechanisms for protection of the gNB internal interfaces


#### 9.8.1	General

The following clause applies to the gNB supporting the split architecture.

#### 9.8.2	Security mechanisms for the F1 interface

The F1 interface connects the gNB-CU to the gNB-DU. It consists of the F1-C for control plane and the F1-U for the user plane. The security mechanisms for the F1 interface connecting the IAB-node to the IAB-donor-CU are detailed in clause M.3.3 of this document.
In order to protect the traffic on the F1-U interface, IPsec ESP and IKEv2 certificates-based authentication shall be supported as specified in sub-clause 9.1.2 of the present document with confidentiality, integrity and replay protection.
In order to protect the traffic on the F1-C interface, IPsec ESP and IKEv2 certificates-based authentication shall be supported as specified in sub-clause 9.1.2 of the present document with confidentiality, integrity and replay protection.
IPsec is mandatory to implement on the gNB-DU and on the gNB-CU. On the gNB-CU side, a SEG may be used to terminate the IPsec tunnel.
In addition to IPsec, for the F1-C interface, DTLS shall be supported as specified in RFC 6083 [58] to provide mutual authentication, integrity protection, replay protection and confidentiality protection. Security profiles for DTLS implementation and usage shall follow the TLS profile given in clause 6.2 of TS 33.210 [3] and the certificate profile given in clause 6.1.3a of TS 33.310 [5]. The identities in the end entity certificates shall be used for authentication and policy checks..
Mutual authentication shall be supported over the F1-C interface between the gNB-CU and the gNB-DU using DTLS and/or IKEv2.
NOTE 1: 	The use of transport layer security, via DTLS, does not rule out the use of network layer protection according to NDS/IP as specified in TS 33.210 [3]. In fact, IPsec has the advantage of providing topology hiding.
NOTE 2: 	The use of cryptographic solutions to protect F1 is an operator's decision. In case the gNB or the IAB-node has been placed in a physically secured environment then the 'secure environment' includes other nodes and links beside the gNB or the IAB-node.
NOTE 3: 	The security considerations for DTLS over SCTP are documented in RFC 6083 [58].
NOTE 4:	The support of DTLS (with mutual authentication) for F1-C, between the IAB-node (gNB-DU) and the IAB-donor-CU, is optional for the IAB-node and the IAB-donor-CU.
NOTE 5: 	DTLS over SCTP as described in RFC 6083 [53] has message size limitations.

#### 9.8.3	Security mechanisms for the E1 interface

The E1 interface connects the gNB-CU-CP to the gNB-CU-UP. It is only used for the transport of signalling data.
In order to protect the traffic on the E1 interface, IPsec ESP and IKEv2 certificates-based authentication shall be supported as specified in sub-clause 9.1.2 of the present document with confidentiality, integrity and replay protection.
In addition to IPsec, DTLS shall be supported as specified in RFC 6083 [58] to provide mutual authentication, integrity protection, replay protection and confidentiality protection. Security profiles for DTLS implementation and usage shall follow the TLS profile given in clause 6.2 of TS 33.210 [3] and the certificate profile given in clause 6.1.3a of TS 33.310 [5]. The identities in the end entity certificates shall be used for authentication and policy checks.
Mutual authentication shall be supported over the E1interface between the gNB-CU-CP and the gNB-CU-UP using DTLS and/or IKEv2.
IPsec is mandatory to support on the gNB-CU-UP and the gNB-CU-CP. Observe that on both the gNB-CU-CP and the gNB-CU-UP sides, a SEG may be used to terminate the IPsec tunnel.
NOTE 1: 	The use of transport layer security, via DTLS, does not rule out the use of network layer protection according to NDS/IP as specified in TS 33.210 [3]. In fact, IPsec has the advantage of providing topology hiding.
NOTE 2: 	The use of cryptographic solutions to protect E1 is an operator's decision. In case the gNB has been placed in a physically secured environment then the 'secure environment' includes other nodes and links beside the gNB.
NOTE 3: 	DTLS over SCTP as described in RFC 6083 [53] has message size limitations.

### 9.9	Security mechanisms for non-SBA interfaces internal to the 5GC and between PLMNs

Non-SBA interfaces internal to the 5G Core such as N4 and N9 can be used to transport signalling data as well as privacy sensitive material, such as user and subscription data, or other parameters, such as security keys. Therefore, these interfaces shall be confidentiality, integrity, and replay protected.
Roaming and interconnect interfaces between PLMNs except for N32, shall be confidentiality, integrity, and replay protected. Protection for the N32 interface is specified in clauses 13.1 and 13.2..
For the protection of the above-mentioned non-SBA internal and roaming and interconnect interfaces except N32, IPsec ESP and IKEv2 certificate-based authentication shall be supported as specified in sub-clauses 9.1.2 of the present document with confidentiality, integrity and replay protection. This security mechanism shall be used, unless security is provided by other means, e.g. physical security. A SEG may be used to terminate the IPsec tunnels.
QoS related aspects are further described in sub-clause 9.1.3 of the present document.
NOTE:	It is up to the operator choice to use cryptographic solutions or other mechanisms to protect internal non-SBA interfaces such as N4 and N9.

### 9.10	Security mechanisms for the interface between W-5GAN and 5GC

The W-AGF function in Wireline 5G Access network (W-5GAN) terminates the following interfaces:
- N2 interface between the W-5GAN and the AMF.
-N3 interface between the W-5GAN and the UPF.
The security of the N2 interface between the W-5GAN and the AMF is as defined in clause 9.2 of the present document.
The security of the N3 interface between the W-5GAN and the UPF is as defined in clause 9.3 of the present document.
On the W-AGF side a SEG may be used to terminate the IPsec tunnels.
NOTE:	Clauses 9.2 and 9.3 require that the N2 and N3 interfaces are integrity, confidentiality, and replay protected. The same protection can be achieved by placing the AGF in the same trust domain as the AMF and the SMF.
