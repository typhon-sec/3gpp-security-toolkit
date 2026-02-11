# 4	Overview of security architecture


### 4.1	Security domains

Figure 4-1 gives an overview of security architecture.
Figure 4-1: Overview of the security architecture
The figure illustrates the following security domains:
-	Network access security (I): the set of security features that enable a UE to authenticate and access services via the network securely, including the 3GPP access and Non-3GPP access, and in particularly, to protect against attacks on the (radio) interfaces. In addition, it includes the security context delivery from SN to AN for the access security.
-	Network domain security (II): the set of security features that enable network nodes to securely exchange signalling data and user plane data.
-	User domain security (III): the set of security features that secure the user access to mobile equipment.
-	Application domain security (IV): the set of security features that enable applications in the user domain and in the provider domain to exchange messages securely. Application domain security is out of scope of the present document.
-	SBA domain security (V): the set of security features that enables network functions of the SBA architecture to securely communicate within the serving network domain and with other network domains . Such features include network function registration, discovery, and authorization security aspects, as well as the protection for the service-based interfaces. SBA domain security is a new security feature compared to TS 33.401 [10].
-	Visibility and configurability of security (VI): the set of features that enable the user to be informed whether a security feature is in operation or not.
NOTE:	The visibility and configurability of security is not shown in the figure.

### 4.2	Security at the perimeter of the 5G Core network


#### 4.2.0	General

The security specified in this document applies to both roaming and PLMN interconnect.

#### 4.2.1	Security Edge Protection Proxy (SEPP)

The 5G System architecture introduces a Security Edge Protection Proxy (SEPP) as an entity sitting at the perimeter of the PLMN for protecting control plane messages.
The SEPP enforces inter-PLMN security on the N32 interface.

#### 4.2.2	Inter-PLMN UP Security (IPUPS)

The 5G System architecture introduces Inter-PLMN UP Security (IPUPS) at the perimeter of the PLMN for protecting user plane messages.
The IPUPS is a functionality of the UPF that enforces GTP-U security on the N9 interface between UPFs of the visited and home PLMNs.
NOTE: 	IPUPS can be activated with other functionality in a UPF or activated in a UPF that is dedicated to be used for IPUPS functionality (see also TS 23.501 [2], clause 5.8.2.14).

### 4.3	Security entities in the 5G Core network

The 5G System architecture introduces the following security entities in the 5G Core network:
AUSF: 	AUthentication Server Function;
ARPF: 	Authentication credential Repository and Processing Function;
SIDF:		Subscription Identifier De-concealing Function;
SEAF:		SEcurity Anchor Function.
