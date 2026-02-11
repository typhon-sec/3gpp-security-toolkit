# I.2	Authentication in standalone non-public networks


### I.2.1	General

One of the major differences of non-public networks is that authentication methods other than AKA based ones may be used in a standalone non-public network (SNPN). When an AKA-based authentication method is used, clause 6.1 shall apply. When an authentication method other than 5G AKA or EAP-AKA' is used, only the non-AKA specific parts of clause 6.1 shall apply. An example of running such an authentication method is given in Annex B with EAP-TLS.
The choice of the supported authentication methods for access to SNPNs follows the principles described in clauses I.2.2 and I.2.3.
The authentication server can be an internal authentication server or an external authentication server. The internal authentication server is the AUSF, and the authentication method can be 5G-AKA or EAP-AKA´ as described in clause 6.1, or can be EAP-TLS as described in Annex B. When external authentication server is the AAA, the primary authentication procedure is described in Annex I.2.2.2.2. When external authentication server is an AUSF, then the primary authentication procedure is described in Annex I.2.4. The UDM decides to run primary authentication with internal authentication server or external authentication server.

### I.2.2	EAP framework, selection of authentication method, and EAP method credentials


#### I.2.2.1	General

The EAP authentication framework is supported by the 5GS as described in clause 6.1.1.2.
The UE and the SNPN may support 5G AKA, EAP-AKA', or any other key-generating EAP authentication method.
Selection of the authentication methods is dependent on NPN configuration.
NOTE 1: For EAP-AKA' (as well as 5G AKA), the selection is described in clause 6.1.2. For authentication,  that is not using EAP-AKA' (or 5G AKA), the selection is NPN operator deployment specific and out of scope of this specification.
When an EAP authentication method other than EAP-AKA' is selected, the chosen method determines the credentials needed in the UE and network. These credentials, called the EAP-method credentials, shall be used for authentication.
NOTE 2: How credentials for EAP methods other than EAP-AKA' are stored and processed within the UE is out of the scope for standalone non-public networks.
NOTE 3:	Storage and processing of credentials for EAP-AKA' (as well as 5G AKA) is described in clause 6 of the present document.

#### I.2.2.2	Credentials holder using AAA server for primary authentication


##### I.2.2.2.1	General

The procedures described in this clause enables UEs to access an SNPN which makes use of a credential management system managed by a credential provider external to the SNPN.
In this scenario the authentication server role is taken by the AAA Server. The AUSF acts as EAP authenticator and interacts with the AAA Server to execute the primary authentication procedure.
The architecture for SNPN access using credentials from a Credentials Holder using AAA Server is described in clause 5.30.2.9.2 of TS 23.501 [2].

##### I.2.2.2.2	Procedure

Figure: I.2.2.2.2-1: Primary authentication with external domain
0.	The UE shall be configured with credentials from the Credentials holder e.g. SUPI containing a network-specific identifier and credentials for the key-generating EAP-method used. As part of configuration of the credentials, the UE shall also be configured with an indication that the UE shall use MSK for the derivation of KAUSF after the success of the primary authentication.  The exact procedures used to configure the UE are not specified in the present document.
It is further assumed that there exists a trust relation between the SNPN and the Credentials holder AAA Server. These entities need to be mutually authenticated, and the information transferred on the interface need to be confidentiality, integrity and replay protected. 

When the procedures of this clause are used for onboarding purposes, the onboarding specific adaptations includes: the 'credentials' used is 'Default credentials', the 'SUPI' used is 'onboarding SUPI', the 'SUCI' used is 'onboarding SUCI' respectively.
1.	The UE shall select the SNPN and initiate UE registration in the SNPN.
For construction of the SUCI, existing methods in clause 6.12 can be used. Otherwise, if the EAP method supports SUPI privacy, the UE may send an anonymous value SUCI based on configuration.
2.	The AMF within the SNPN shall initiate a primary authentication for the UE using a Nausf_UEAuthentication_Authenticate service operation with the AUSF. The AMF shall discover and select an AUSF based  on criterions specified in TS 23.501 [2] clause 5.30.2.9.2.
3.	In the case of onboarding, steps 3-5 are omitted. If steps 3-5 are not omitted, the AUSF shall initiate a Nudm_UEAuthentication_Get service operation. The AUSF shall discover and select a UDM based on criterions specified in TS 23.501 [2] clause 5.30.2.9.
NOTE 1: 	SUPI will be used instead of SUCI in the case of a re-authentication.
4. 	In case the UDM receives a SUCI, the UDM shall resolve the SUCI to the SUPI before checking the authentication method applicable for the SUPI. The UDM decides to run primary authentication with an external entity based on subscription data.
In case the UDM receives an anonymous SUCI, the UDM decides to run primary authentication with an external entity based the realm part of the SUPI in NAI format.
NOTE 1a: The UDM needs to be configured with a list of realms and the intended authentication server
In case the UDM receives an anonymous SUCI that does not contain the realm part, the UDM shall abort the procedure. Otherwise, the UDM authorizes the UE based on realm part of SUCI and send the anonymous SUPI and the indicator to the AUSF as described in step5.
The anonymous SUPI shall be a NAI format.
5.	In case the UDM received a SUCI in previous steps, the UDM shall provide the AUSF with the SUPI or anonymous SUPI and shall indicate to the AUSF to run primary authentication with a AAA Server in an external Credentials holder.
When a Credentials Holder using AAA Server is used for primary authentication, the AUSF uses the MSK to derive KAUSF. It is strongly recommended that the same credentials that are used for authentication between UE and the 5G SNPN are not used for the authentication between the UE and a non-5G network, assuming that 5G SNPN and non-5G network are in different security domains.
NOTE 2: 	MSKs obtained from the non-5G network could be used to impersonate the 5G SNPN towards the UE.
6.	Based on the indication from the UDM, the AUSF shall select an NSSAAF as defined in  TS 23.501 [2] and initiate a Nnssaaf_AIWF_Authenticate service operation towards that NSSAAF as defined in clause 14.4.2.
7.	The NSSAAF shall select AAA Server based on the domain name corresponding to the realm part of the SUPI. The NSSAAF shall perform related protocol conversion and relay EAP messages to the AAA Server.
NOTE 3:  The interface and protocol between NSSAAF and AAA is out of scope of the present document and existing AAA protocols such as RADIUS or Diameter can be used.
8.	The UE and AAA Server shall perform mutual authentication. The AAA Server shall act as the EAP Server for the purpose of primary authentication. The EAP Identity received by the AAA Server in the EAP-Response/Identity message in step 7 may contain anonymised SUPI. In such cases, AAA Server uses the EAP-method specific EAP Identity request/response messages to obtain the UE identifier as part of the EAP authentication between the UE and the AAA Server.
9.	After successful authentication, the MSK and the SUPI (i.e., the UE identifier that is used for the successful EAP authentication) shall be provided from the AAA Server to the NSSAAF.
10.	The NSSAAF returns the MSK and the SUPI to the AUSF using the Nnssaaf_AIWF_Authenticate service operation response message. The SUPI received from the AAA shall be used when deriving 5G keys (e.g., KAMF) that requires SUPI as an input for the key derivation.
11-13. In case of onboarding or SUCI received in step 2 is not anonymous, steps 11-13 are omitted. Otherwise, the AUSF verifies that the SUPI corresponds to a valid subscription in the SNPN by informing the UDM about the authentication result for the received SUPI using a Nudm_UEAuthentication_ResultConfirmation service operation. The UDM stores the authentication state for the SUPI and if there is not a subscription corresponding to the SUPI, the UDM shall return an error.
If the verification of the SUPI is not successful, then the AUSF rejects the UE access to the SNPN.

NOTE 4: If the above failure happens, the error is no failed authentication but lacking subscription in the SNPN.
14. The AUSF shall use the most significant 256 bits of MSK as the KAUSF. The AUSF shall also derive KSEAF from the KAUSF as defined in Annex A.6.
15. The AUSF shall send the successful indication together with the SUPI of the UE to the AMF/SEAF together with the resulting KSEAF.
16. The AMF shall send the EAP success in a NAS message.
17. The UE shall derive the KAUSF from MSK as described in step 11 according to the pre-configured indication as described in step 0.

### I.2.3	Key hierarchy, key derivation and key distribution


#### I.2.3.1	General

The text in clauses 6.2.1 and 6.2.2 cannot apply directly for an EAP authentication method other than EAP-AKA' as these clauses assume that an AKA-based authentication method is used. The major differences are the way in which KAUSF is calculated and that the UDM/ARPF is not necessarily involved in the key derivation or distribution.
Depending on the selected authentication method, the KAUSF is generated as follows:
-	For 5G AKA and EAP-AKA' refer to clause 6.2.1.
-	When using a key-generating EAP authentication method other than EAP-AKA', the key derivation of KAUSF is based on the EAP-method credentials in the UE and AUSF and shall be done as shown in Figure I.2.3-1.
NOTE: For EAP authentication methods other than EAP-AKA', this key derivation replaces clauses 6.2.1 and 6.2.2 for the generation of KAUSF .
Figure I.2.3.1-1: KAUSF derivation for key-generating EAP authentication methods other than EAP-AKA'
KAUSF shall be derived by the AUSF and UE from the EMSK created by the EAP authentication as for EAP-AKA'.
All of figures 6.2.1-1, 6.2.2.1-1 and 6.2.2.2.2-1 from the KAUSF downwards are used without modification. Similarly, text relating to the key hierarchy, key derivation and key distribution in clauses 6.2.1, 6.2.2.1 and 6.2.2.2 for keys derived from KAUSF (e.g. KSEAF, KAMF, KgNB etc) apply without modification.

#### I.2.3.2	Credentials holder using AAA server for primary authentication

When running primary authentication towards an external Credentials holder using AAA server for authentication as specified in clause I.2.2.2 the derivation of KAUSF is based on the EAP-method credentials in the UE and AAA-S and shall be done as shown in Figure I.2.3.2-1.
Figure I.2.3.2-1: KAUSF derivation for primary authentication towards an external Credentials holder using AAA server
KAUSF shall be derived by the AUSF and UE from the MSK derived during the EAP authentication as specified in clause I.2.2.2.1.
All of figures 6.2.1-1, 6.2.2.1-1 and 6.2.2.2.2-1 from the KAUSF downwards are used without modification. Similarly, text relating to the key hierarchy, key derivation and key distribution in clauses 6.2.1, 6.2.2.1 and 6.2.2.2 for keys derived from KAUSF (e.g. KSEAF, KAMF, KgNB etc) apply without modification.

#### I.2.4	Credentials Holder using AUSF and UDM for primary authentication

The 5G System architecture for SNPN with Credentials Holder using AUSF and UDM for primary authentication and authorization is described in clause 5.30.2.9.3 of TS 23.501 [2].
The requirements and procedures for primary authentication using AUSF and UDM as described in the present document apply, for 5G AKA, EAP-AKA', EAP-TLS or any other key-generating EAP method.
