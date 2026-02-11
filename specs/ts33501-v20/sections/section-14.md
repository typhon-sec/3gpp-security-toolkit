# 14	Security related services


### 14.1	Services provided by AUSF


#### 14.1.1	General

The AUSF provides UE authentication service to the requester NF by Nausf_UEAuthentication. For AKA based authentication, this operation can be also used to recover from synchronization failure situations. Clause 14.1.2 describes the Nausf_UEAuthentication service. The service operations listed here are used in procedures that are described in clause 6 of the present document and in TS 33.503 [109].
Clause 14.1.3 describes the Nausf_SoRProtection service used in procedures that are described in clause 6.14 of the present document.
Clause 14.1.4 describes the Nausf_UPUProtection service used in procedures that are described in clause 6.15 of the present document.
Since AUSF is completely security-related, all service operations are described in the present document. TS 23.501 [2], clause 7.2.7, only lists the services and TS 23.502 [8], clause 5.2.10, provides the reference to the present document.

#### 14.1.2	Nausf_UEAuthentication service


##### 14.1.2.1	Nausf_UEAuthentication_Authenticate service operation

Service operation name: Nausf_UEAuthentication_authenticate.
Description: Authenticate the UE and provides related keying material.
Input, Required: One of the options below.
1.	In the initial authentication request: SUPI or SUCI, serving network name.
2.	In the subsequent authentication requests depending on the authentication method:
a.	5G AKA: Authentication confirmation message with RES* as described in clause 6.1.3.2 or Synchronization Failure indication and related information (i.e. RAND/AUTS).
b.	EAP-AKA’: 	EAP packet as described in RFC 4187 [21] and RFC 5448 [12], and Annex F.
Input, Optional: Disaster Roaming service indication, NSWO indicator.
NOTE:	If NSWO indicator is present then the serving network name contains "5G:NSWO".
Output, Required: One of the options below.
1.	Depending on the authentication method:
a.	5G AKA: authentication vector, as described in clause 6.1.3.2 or Authentication confirmation acknowledge message.
b.	EAP-AKA’:	EAP packet as described in RFC 4187 [21] and RFC 5448 [12], and Annex F.
2.	Authentication result and if success the master key which are used by AMF to derive NAS security keys and other security key(s).
Output, Optional: SUPI if the authentication was initiated with SUCI, MSK if either NSWO indicator was received as input or MSK indicator was received from UDM.

##### 14.1.2.2	Nausf_UEAuthentication_deregister service operation

Service operation name: Nausf_UEAuthentication_deregister
Description: Deletion of stale security parameters (KAUSF, SOR counter and UE parameter update counter) in AUSF. UDM uses this service operation to request the AUSF to clear the stale security parameters, after the UE has been successfully (re)authenticated in different AUSF Instance.
Input, Required: SUPI
Input, Optional: None
Output, Required: None
Output, Optional: None

##### 14.1.2.3	Nausf_UEAuthentication_ProseAuthenticate service operation

See TS 33.503 [109].

#### 14.1.3	Nausf_SoRProtection service

The following table illustrates the security related services for SoR that AUSF provides.
Table 14.1.3-1: NF services for SoR provided by AUSF
Service operation name: Nausf_SoRProtection.
Description: The AUSF calculates the SoR-MAC-IAUSF as specified in the Annex A.17 of this document using UE specific home key (KAUSF), the Steering Information List and ACK Indication  received from the requester NF and delivers the SoR-MAC-IAUSF and CounterSoR to the requester NF. If the ACK Indication input is set to indicate that the acknowledgement is requested, then the AUSF shall compute the SoR-XMAC-IUE as specified in Annex A.18 of the present document, and return it in the response.
NOTE:	At reception of Nausf_SoRProtection_Protect request from the UDM, the AUSF constructs the SOR header, as described in clause 9.11.3.51 of TS 24.501 [35], based on the information received from the requester NF, i.e. ACK Indication and list of preferred PLMN/access technology combinations or a secured packet (if provided).
Input, Required: Requester ID, SUPI, service name, ACK Indication.
Input, Optional: list of preferred PLMN/access technology combinations or secured packet or SoR transparent container.
Output, Required: SoR-MAC-IAUSF, CounterSoR or error (counter_wrap).
Output, Optional: SoR-XMAC-IUE (if the ACK Indication input is set to indicate that the acknowledgement is requested, then the SoR-XMAC-IUE shall be computed and returned).

#### 14.1.4	Nausf_UPUProtection service

The following table illustrates the security related services for UE Parameters Update that AUSF provides.
Table 14.1.4-1: NF services for UE Parameters Update provided by AUSF
Service operation name: Nausf_UPUProtection.
Description: The AUSF calculates the UPU-MAC-IAUSF as specified in the Annex A.19 of this document using UE specific home key (KAUSF) along with the UE Parameters Update Data received from the requester NF (see clause A.19) and delivers the UPU-MAC-IAUSF and CounterUPU to the requester NF. If the ACK Indication input is present, then the AUSF shall compute the UPU-XMAC-IUE and return the computed UPU-XMAC-IUE as specified in Annex A.20 of the present document, in the response. The details of the UE Parameters Update Data is specified in TS 24.501 [35].
Input, Required: Requester ID, SUPI, service name, UE Parameters Update Data.
Input, Optional: ACK Indication.
Output, Required: UPU-MAC-IAUSF, CounterUPU or error (counter_wrap).
Output, Optional: UPU-XMAC-IUE (if the ACK Indication input is present, then the UPU-XMAC-IUE shall be computed and returned).

#### 14.1.5	Void


### 14.2	Services provided by UDM


#### 14.2.1	General

UDM provides within Nudm_UEAuthentication service all authentication-related service operations, which are Nudm_UEAuthentication_Get (clause 14.2.2) , Nudm_UEAuthentication_ResultConfirmation (clause 14.2.3), Nudm_UEAuthentication_GetProseAv (clause 14.2.4), Nudm_UEAuthentication_GetGbaAv (clause 14.2.5), Nudm_UECM_AuthTrigger service operation (clause 14.2.6) and Nudm_UECM_Re-AuthenticationNotification service operation (clause 14.2.7).
The complete list of UDM services is defined in TS 23.501 [2], clause 7.2.5, and further refined in TS 23.502 [8], clause 5.2.3.1.

#### 14.2.2	Nudm_UEAuthentication_Get service operation

Service operation name: Nudm_UEAuthentication_Get
Description: Requester NF gets the authentication data from UDM. For AKA based authentication, this operation can be also used to recover from synchronization failure situations. If SUCI is included, this service operation returns the SUPI.
Inputs, Required: SUPI or SUCI, serving network name.
Inputs, Optional: Synchronization Failure indication and related information (i.e. RAND/AUTS) , Disaster Roaming service indication, NSWO indicator.
NOTE:	If NSWO indicator is present then the serving network name contains "5G:NSWO".
Outputs, Required: Authentication method.
Outputs, Optional: SUPI if SUCI was used as input. Depending on the authentication method, authentication data (e.g. AKA authentication vector) for the SUPI. AKMA Indication and Routing indicator, if the subscriber has an AKMA subscription (see TS 33.535 [91]). MSK indicator.

#### 14.2.3	Nudm_UEAuthentication_ResultConfirmation service operation

Service operation name: UEAuthentication_ResultConfirmation
Description: Requester NF informs UDM about the result of an authentication procedure with a UE.
Inputs, Required: SUPI, timestamp of the authentication, the authentication type (e.g. EAP method or 5G-AKA), and the serving network name.
Inputs, Optional: NSWO indicator.
Outputs, Required: None.
Outputs, Optional: None.

#### 14.2.4	Nudm_UEAuthentication_GetProseAv service operation

See TS 33.503 [109].

#### 14.2.5	Nudm_UEAuthentication_GetGbaAv service operation

See TS 33.220 [28], Annex N.

#### 14.2.6	Nudm_UECM_AuthTrigger service operation

Service operation name: Nudm_UECM_AuthTrigger.
Description: This service operation allows the NF to request UDM to trigger a primary (re-)authentication as described in clause 6.1.5.
Input, Required: SUPI.
Input, Optional: None.
Output, Required: None.
Output, Optional: None.

#### 14.2.7	Nudm_UECM_Re-AuthenticationNotification service operation

Service operation name: Nudm_UECM_Re-AuthenticationNotification
Description: The UDM requests the AMF to perform a primary authentication for a specific UE.
Inputs, Required: SUPI
Inputs, Optional: None.
Outputs, Required: Success/Failure cause.
Outputs, Optional: None.

### 14.3	Services provided by NRF


#### 14.3.1	General

The following table illustrates the security related services for OAuth 2.0 that NRF provides. OAuth 2.0 based authorization is described in clause 13.4.1.
The complete list of NRF services is defined in TS 23.501 [2], clause 7.2.6, and further refined in TS 23.502 [8], clause 5.2.7.

#### 14.3.2	Nnrf_AccessToken_Get Service Operation

Service Operation name: Nnrf_AccessToken_Get.
Description: NF Service Consumer requests NRF to provide an Access Token.
Inputs, Required: the NF Instance Id of the NF Service Consumer, the requested "scope" including the expected NF service name(s).
Inputs, Optional: PLMN ID (or SNPN ID) of the requester NF Service Consumer, PLMN ID  (or SNPN ID)of the requested NF Service Producer, NF Instance Id(s) of the requested NF Service Producer, NF type of the expected NF Service Producer instance and NF Service Consumer, "additional scope" information (i.e. requested resources and requested actions (service operations) on the resources), list of S-NSSAIs or list of NSI IDs for the expected NF Service Producer instances, NF Set ID of the expected NF Service Producer instances, list of S-NSSAIs of the NF Service Consumer.
Outputs, Required: Access Token with appropriate claims, where the claims shall include NF Instance Id of NRF (issuer), NF Instance Id of the NF Service Consumer potentially appended with its PLMN ID (or SNPN ID) (subject), NF type of the NF Service Producers or NF Instance Id or several NF Instance Id(s) of the requested NF Service Producer, potentially appended with PLMN ID (or SNPN ID) (audience), expected service name (scope), optionally issued at (iat), and "additional scope" information (allowed resources and allowed actions (service operations) on the resources) and expiration time (expiration), may include list of S-NSSAIs or NSI IDs for the expected NF Service Producer instances, and may include the NF Set ID of the expected NF Service Producer instances.
Outputs, Optional: None.

#### 14.3.3	Nnrf_AccessToken_RetrieveKey Service Operation

Service Operation name: Nnrf_AccessToken_RetrieveKey.
Description: the requesting NF retrieves from the NRF the key (one of raw public key, or X.509 certificate) required to validate the signature of the Access Token.
Inputs, Required: the NF Instance Id of the token issuer NRF, header parameter identifying the key to use to validate the signature of the access token.
Inputs, Optional: None.
Outputs, Required: The key (one of raw public key, or X.509 certificate, or certificate chain) required to validate the signature of the access token.
Outputs, Optional: None.

### 14.4	Services provided by NSSAAF


#### 14.4.1	Nnssaaf_NSSAA services


##### 14.4.1.1	General

The following table illustrates the security related services for Network Slice Specific Authentication and Authorisation that NSSAAF provides.
Table 14.4.1.1-1: NF services for the NSSAA service provided by NSSAAF

##### 14.4.1.2	Nnssaaf_NSSAA_Authenticate service operation

Service operation name: Nnssaaf_NSSAA_Authenticate
Description: NF consumer requires the NSSAAF to relay Network Slice specific authentication messages towards the corresponding AAA-S handling the Network Slice specific authentication for the requested S-NSSAI (see clause 16).
Input, Required:
1) In the initial NSSAA requests: EAP ID Response, GPSI, S-NSSAI
2) In subsequent NSSAA requests: EAP message, GPSI, S-NSSAI
Input, Optional: None
Output, Required: EAP message, GPSI, S-NSSAI
Output, Optional: None

##### 14.4.1.3	Nnssaaf_NSSAA_Re-AuthenticationNotification service operation

Service operation name: Nnssaaf_NSSAA_Re-AuthenticationNotification
Description: NSSAAF notifies the NF consumer to trigger a Network Slice specific reauthentication procedure for a given UE and S-NSSAI.
NOTE:	The AMF is implicitly subscribed to receive Nnssaaf_NSSAA_Re-authenticationNotification service operation.
Input, Required: GPSI, S-NSSAI
Input, Optional: None
Output, Required: None
Output, Optional: None

##### 14.4.1.4	Nnssaaf_NSSAA_RevocationNotification service operation

Service operation name: Nnssaaf_NSSAA_RevocationNotification
Description: NSSAAF notifies the NF consumer to trigger a Network Slice specific revocation procedure for a given UE and S-NSSAI.
NOTE:	The AMF is implicitly subscribed to receive Nnssaaf_NSSAA_RevocationNotification service operation.
Input, Required: GPSI, S-NSSAI
Input, Optional: None
Output, Required: None
Output, Optional: None

#### 14.4.2	Nnssaaf_AIW services


##### 14.4.2.1	General

The following table illustrates the security related services provided by the NSSAAF for primary authentication in SNPN with Credentials holder using AAA server (see clause I.2.2.2).
Table 14.4.2.1-1: NF services for CH using AAA for primary authentication provided by NSSAAF

##### 14.4.2.2	Nnssaaf_AIW_Authenticate service operation

Service operation name: Nnssaaf_AIW_Authenticate
Description: The NSSAAF provides Authentication and Authorization service to the consumer NF by relaying EAP or EAP-TTLS inner method messages towards a AAA Server and performing related protocol conversion as needed. Input, Required:
1) In EAP Authentication:
a) In the initial authentication request: SUPI.
b) In subsequent authentication requests: EAP message.
2) In case EAP-TTLS mechanisms are implemented: inner method container.
Input, Optional: None
Output, Required:
1) In EAP authentication: EAP message, authentication result and if success MSK and SUPI.
2) In case EAP-TTLS mechanisms are implemented: inner method container.
Output, Optional: None
