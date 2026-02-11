# 16	Security procedures for network slices


### 16.1	General

This clause specifies the security procedures for network slices.

### 16.2	Authorization for network slice access

This clause specifies the relationship between primary authentication (as described in Clause 6.1) and authorization for network slice access (as described in TS 23.502 [8]) for a UE. Authorization from a home/serving PLMN is required for a UE to gain access to a network slice, identified by an S-NSSAI. An authorized S-NSSAI (i.e. allowed S-NSSAI) shall be granted to a UE only after the UE has completed successfully primary authentication. At the end of the primary authentication, the AMF and UE may receive a list of allowed S-NSSAI, which the UE is authorized to access.
For certain S-NSSAIs, additional Network Slice Specific Authentication and Authorization (NSSAA) is required. This clause in addition specifies the pre-requisite for an NSSAA procedure that is described in clause 16.3, with reference to the following figure 16.2-1.
Figure 16.2-1: Relationship between primary authentication and NSSAA
1. UE sends a Registration Request with a list of S-NSSAIs. UE shall not include those S-NSSAIs for which NSSAA procedures are ongoing, regardless of access types (c.f. TS 23.501[2], clause 5.15.5.2.1 and TS 23.502[8], clause 4.2.2.2.2).
2. For an initial Registration Request, the AMF/SEAF shall invoke Primary authentication as described in clause 6.1.2 of the present document. For a subsequent Registration Request, the Primary authentication may be skipped if the UE has already been authenticated and the AMF has valid security context.
3. AMF shall determine whether NSSAA is required for each of S-NSSAIs, based on information stored locally or from UDM. For example, the NSSAA for an S-NSSAI may be omitted
1) if it is not required based on the subscription information,
2) if UE has previously performed NSSAA successfully, regardless of access type and the result is still valid, or
3) NSSAA for UE is ongoing
4. AMF sends the Registration Accept message to the UE (c.f. TS 23.501[2], clause 5.15.5.2.1 and TS 23.502[8], clause 4.2.2.2.2, step 21). Optionally UE sends a Registration Complete.
5. The EAP based NSSAA procedure for each S-NSSAI if required, as determined in step 3, is executed in this step.
6. Based on the results of step 5, AMF sends UE Configuration Update to update the requested S-NSSAI status based on the NSSAA results.
The procedure for step 5, i.e., the NSSAA procedure is specified in clause 16.3.

### 16.3	Network slice specific authentication and authorization

This clause specifies the optional-to-use NSSAA between a UE and an AAA server (AAA-S) which may be owned by an external 3rd party enterprise. NSSAA uses a User ID and credentials, different from the 3GPP subscription credentials (e.g. SUPI and credentials used for PLMN access) and takes place after the primary authentication.
The EAP framework specified in RFC 3748 [27] shall be used for NSSAA between the UE and the AAA server. The SEAF/AMF shall perform the role of the EAP Authenticator and communicates with the AAA-S via the NSSAAF. The NSSAAF undertakes any AAA protocol interworking with the AAA-S. Multiple EAP methods are possible for NSSAA. If the AAA-S belongs to a third party the NSSAAF contacts the AAA-S via a AAA-P. The NSSAAF and the AAA-P may be co-located.
To protect privacy of the EAP ID used for the EAP based NSSAA, a privacy-protection capable EAP method is recommended, if privacy protection is required.
The steps involved in NSSAA are described below.
Figure 16.3-1: NSSAA procedure
1.	For S-NSSAIs that are requiring NSSAA, based on change of subscription information, or triggered by the AAA-S, the AMF may trigger the start of the NSSAA procedure.
If NSSAA is triggered as a result of Registration procedure, the AMF may determine, based on UE Context in the AMF, that for some or all S-NSSAI(s) subject to NSSAA, the UE has already been authenticated following a Registration procedure on a first access. Depending on NSSAA result (e.g. success/failure) from the previous Registration, the AMF may decide, based on Network policies, to skip NSSAA for these S-NSSAIs during the Registration on a second access.
If the NSSAA procedure corresponds to a re-authentication and re-authorization procedure triggered as a result of AAA Server-triggered UE re-authentication and re-authorization for one or more S-NSSAIs, as described in clause 16.4, or triggered by the AMF based on operator policy or a subscription change and if S-NSSAIs that are requiring Network Slice-Specific Authentication and Authorization are included in the Allowed NSSAI for each Access Type, the AMF selects an Access Type to be used to perform the NSSAA procedure based on network policies.
2.	The AMF may request the UE User ID for EAP authentication (EAP ID) for the S-NSSAI in a NAS MM Transport message including the S-NSSAI.
3.	The UE provides the EAP ID for the S-NSSAI alongside the S-NSSAI in an NAS MM Transport message towards the AMF.
4.	The AMF sends the EAP ID to the NSSAAF which provides interface with the AAA, in an Nnssaaf_NSSAA_Authenticate Request (EAP ID Response, GPSI, S-NSSAI).
5.	If the AAA-P is present (e.g. because the AAA-S belongs to a third party and the operator deploys a proxy towards third parties), the NSSAAF forwards the EAP ID Response message to the AAA-P, otherwise the NSSAAF forwards the message directly to the AAA-S. NSSAAF routes to the AAA-S based on the S-NSSAI. The NSSAAF/AAA-P forwards the EAP Identity message to the AAA-S together with S-NSSAI and GPSI. The AAA-S stores the GPSI to create an association with the EAP ID in the EAP ID response message so the AAA-S can later use it to revoke authorisation or to trigger reauthentication. The AAA-S uses the EAP-ID and S-NSSAI to identify for which UE and slice authorisation is requested.
NOTE :	If the AAA-S belongs to the 3rd party, the NSSAAF optionally maps the S-NSSAI to External Network Slice Information (ENSI), and forwards the EAP Identity message to the AAA-S together with ENSI and GPSI. In this case, the AAA-S uses the EAP-ID and ENSI to identify the UE for which slice authorisation is requested.
6 -11.	EAP-messages are exchanged with the UE. One or more than one iterations of these steps may occur.
12.	EAP authentication completes. An EAP-Success/Failure message is delivered to the NSSAAF/AAA-P along with GPSI and S-NSSAI/ENSI.
13.	The NSSAAF sends the Nnssaaf_NSSAA_Authenticate Response (EAP-Success/Failure, S-NSSAI, GPSI) to the AMF.
14.	The AMF transmits a NAS MM Transport message (EAP-Success/Failure) to the UE.
15. Based on the result of Slice specific authentication (EAP-Success/Failure), if a new Allowed NSSAI or new Rejected NSSAIs needs to be delivered to the UE, or if the AMF re-allocation is required, the AMF initiates the UE Configuration Update procedure, for each Access Type, as described in clause 4.2.4.2 of TS 23.502 [8].
If the NSSAA procedure can not be completed (e.g. due to server error or UE becoming unreachable), the AMF sets the status of the corresponding S-NSSAI subject to Network Slice-Specific Authentication and Authorization in the UE context as defined in  TS 29.526 [96], so that an NSSAA is executed next time the UE requests to register with the S-NSSAI.

### 16.4	AAA Server triggered Network Slice-Specific Re-authentication and Re-authorization procedure

Figure 16.4-1: AAA Server initiated Network Slice-Specific Re-authentication and Re-authorization procedure
0.	The UE is registered in 5GC via an AMF. The AMF ID is stored in the UDM.
1.	The AAA-S requests the re-authentication and re-authorization for the Network Slice specified by the S-NSSAI/ENSI in the Re-Auth Request message, for the UE identified by the GPSI in this message. This message is sent to an AAA-P, if the AAA-P is used (e.g. the AAA Server belongs to a third party), otherwise it may be sent directly to the NSSAAF. If an AAA-P is present, the AAA-P relays the Reauthentication Request to the NSSAAF.
2.	The NSSAAF checks whether the AAA-S is authorized to request the re-authentication and re-authorization by checking the local configuration of AAA-S address per S-NSSAI. If success,the NSSAAF requests UDM for the AMF serving the UE using the Nudm_UECM_Get (GPSI, AMF Registration) service operation. The UDM provides the NSSAAF with the AMF ID of the AMF serving the UE.
3.	The NSSAAF provides an acknowledgement to the AAA protocol Re-Auth Request message. If the AMF is not registered in UDM the procedure is stopped here.
4.	If the AMF is registered in UDM, the NSSAAF requests the relevant AMF to re-authenticate/re-authorize the S-NSSAI for the UE using the Nnssaaf_NSSAA_Re-authenticationNotification service operation. The AMF is implicitly subscribed to receive Nnssaaf_NSSAA_Re-authenticationNotification service operations. The NSSAAF may discover the Callback URI for the Nnssaaf_NSSAA_Re-authenticationNotification service operation exposed by the AMF via the NRF.
The AMF acknowledges the notification of Re-authentication request.
5.	If the UE is registered with the S-NSSAI in the Mapping Of Allowed NSSAI, the AMF triggers the NSSAA procedure defined in clause 16.3 for the UE identified by the GPSI and the Network Slice identified by the S-NSSAI received from the NSSAAF.
If the UE is registered but the S-NSSAI is not in the Mapping Of Allowed NSSAI, the AMF removes any status of the corresponding S-NSSAI subject to Network Slice-Specific Authentication and Authorization in the UE context it may have kept, so that an NSSAA is executed next time the UE requests to register with the S-NSSAI.

### 16.5	AAA Server triggered Slice-Specific Authorization Revocation

Figure 16.5-1: AAA Server-initiated Network Slice-Specific Authorization Revocation procedure
0.	The UE is registered in 5GC via an AMF. The AMF ID is stored in the UDM.
1.	The slice specific AAA-S requests the revocation of authorization for the Network Slice identified by the GPSI in the AAA Protocol Revoke Authorization Request message. This message is sent to NSSAAF instance interfacing with AAA-S or AAA-P if it is used.
The AAA-P, if present, relays the request to the NSSAAF.
2.	The NSSAAF checks whether the AAA-S is authorized to request the revocation by checking the local configuration of AAA-S address per S-NSSAI. If success,the NSSAAF requests UDM for the AMF serving the UE using the Nudm_UECM_Get (GPSI, AMF Registration) service operation. The UDM provides the NSSAAF with the AMF ID of the AMF serving the UE.
3. The NSSAAF sends an acknowledgement to the the AAA-S/AAA-P with AAA Protocol Revoke Authorization Response message. If the AMF is not registered in UDM the procedure is stopped here.
4.	If the AMF is registered in UDM, the NSSAAF request the relevant AMF to revoke the S-NSSAI authorization for the UE using the Nnssaaf_NSSAA_RevocationNotification service operation.
The AMF is implicitly subscribed to receive Nnssaaf_NSSAA_RevocationNotification service operations. The NSSAAF may discover the Callback URI for the Nnssaaf_NSSAA_RevocationNotification service operation exposed by the AMF via the NRF.  The AMF acknowledges the Notification of Revocation request.
5.	The AMF removes any status it may have kept of the corresponding S-NSSAI subject to Network Slice-Specific Authentication and Authorisation in the UE context and sends the UE Configuration Update message to revoke the S-NSSAI from the current Allowed NSSAI, for any Access Type for which NSSAA had been successfully run on this S-NSSAI. The AMF provides a new Allowed NSSAI to the UE by removing the S-NSSAI for which authorization has been revoked. The AMF provides new rejected NSSAIs to the UE including the S-NSSAI for which authorization has been revoked. If no S-NSSAI is left in Allowed NSSAI for an access after the revocation, and a Default NSSAI exists that requires no NSSAA or for which a NSSAA did not previously fail over this access, then the AMF may provide a new Allowed NSSAI to the UE containing the Default NSSAI. If no S-NSSAI is left in Allowed NSSAI for an access after the revocation, and no Default NSSAI can be provided to the UE in the Allowed NSSAI or a previous NSSAA failed for the Default NSSAI over this access, then the AMF shall execute the Network-initiated Deregistration procedure for the access as described in subclause 4.2.2.3.3 in TS 23.502 [8], and it shall include in the explicit De-Registration Request message the list of Rejected S-NSSAIs, each of them with the appropriate rejection cause value.

### 16.6	AF Authorization for network slice quota-usage information notification/retrieval


#### 16.6.1	Introduction

This clause specifies the AF Authorization procedures when AF subscribes/unsubscribes to network slice quota-usage information and when AF retrieves network slice quota-usage information.

#### 16.6.2	General

If an AF is deployed within the 3GPP operator domain, an S-NSSAI is allowed to be sent to the AF. The baseline procedure for notifying the AF slice usage information (e.g. number of UEs and PDU Sessions in the slice indicated by the S-NSSAI) and the procedure for retrieving slice usage information by the AF are defined in TS 23.502 [8].
If an AF is deployed outside the 3GPP operator domain, an S-NSSAI is not allowed to be sent to the AF as required in clasue 5.9.2.3. The procedure for notifying the AF slice usage information (e.g. number of UEs and PDU Sessions in the slice indicated by the S-NSSAI) and the procedure for retrieving slice usage information by the AF are described in clause 16.6.3.

#### 16.6.3	Subscription/unsubscription procedure of NSACF notification service

Figure 16.6.3-1: Subscription/unsubscription of NSACF notification procedure
0.	Authentication of the AF: the AF is authenticated based on the description in clause 13 or clause 12. The AF authorization is based on clause 13 or clause 12 or local configuration at the NEF. If a token based authorization mechanism is used, a token is generated for the AF after authentication and authorization.
1.	To subscribe or unsubscribe for the number of UEs or the number of PDU Sessions per network slice notification with the NSACF, the AF sends Nnef_EventExposure_Subscribe/Unsubscribe Request (Event ID, Event Filter, Event Reporting information) message to the NEF as described in TS 23.502 [8]. The Event Filter parameter shall be AF-Service-Identifier for an AF deployed outside the 3GPP operator domain. Other parameters are specified in TS 23.502 [8].
2.	The NEF confirms with Nnef_ SliceStatusEventExposure _Subscribe/Unsubscribe Response message to the AF.
The Event Filter parameter is the mapped AF-Service-Identifier for the AF deployed outside the 3GPP operator domain.
3.	The NEF checks whether the AF is authorised for the requested subscription based on the AF token. It needs to check whether the token claims match the AF’s identity and the Event Filter parameter. If authorised, the NEF may query the NRF to find the NSACF responsible for the requested S-NSSAI (NEF needs to map to S-NSSAI based on AF-Service-Identifier for the AF deployed outside the 3GPP operator domain).
4.  The NEF forwards the request to the NSACF with Nnsacf_SliceEventExposure_Subscribe/Unsubscribe Request (Event ID, Event Filter, Event Reporting information). The Event Filter parameter shall be the mapped S-NSSAI for the AF deployed outside the 3GPP operator domain.
5.	The NSACF confirms with Nnsacf_SliceEventExposure_Subscribe/Usubscribe Response message to the NEF as in TS 23.502 [8].
6-7a.	The NSACF triggers a notification towards the AF and sends the Nnsacf_SliceEvent Exposure_Notify (Event ID, Event Filter, Event Reporting information) message to the NEF as described in TS 23.502 [8].
7b-9.	The NEF forwards the message to the AF for single NSACF or aggregates reporting information for multiple NSACFs in the Nnef_EventExposure_Notify (Event ID, Event Filter, Event Reporting information) message as described in TS 23.502 [8]. The Event Filter parameter shall be the mapped AF-Service-Identifier from the S-NSSAI for the AF deployed outside the 3GPP operator domain.
