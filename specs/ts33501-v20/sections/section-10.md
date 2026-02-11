# 10	Security aspects of IMS emergency session handling


### 10.1	General

This clause addresses security procedures for IMS emergency session handling.

### 10.2	Security procedures and their applicability


#### 10.2.1	Authenticated IMS Emergency Sessions


##### 10.2.1.1	General

Authenticated emergency services are provided to UEs in the following scenarios:
a)	A UE in RM-DEREGISTERED state requests IMS Emergency services
In this scenario, the UE has a valid subscription and is authenticated when it registers with the network.
b)	A UE in RM-REGISTERED state initiates a PDU Session request to setup an IMS Emergency Session
In this scenario, the UE is already registered with the network and share a security context with the AMF. The UE initiates a session management message to setup a new bearer for emergency services. The request for emergency services is sent protected by the current security context. The AMF may decide to re-authenticate the UE.
If there is a redirection of the UE to EUTRAN for IMS Emergency services, the redirect command from the gNB to the UE shall be protected by the UE’s AS security context. The AMF shall send the ‘NG AP UE Initial Context setup’ message to enable the AS security context set up.

##### 10.2.1.2	UE in RM-DEREGISTERED state requests a PDU Session for IMS Emergency services

The UE shall first initiate a normal initial registration procedure to register with the 5G network. Upon successful normal registration, the UE initiates the UE requested PDU session establishment procedure to establish a PDU Session to receive emergency services as specified in TS 23.502 [8].
At the time of registration, the security mode control procedure shall be applied to authenticate the UE and setup NAS and AS security. Thus, integrity protection (and optionally ciphering) shall be applied to the emergency bearers as for normal bearers.
If authentication fails for any reason, it shall be treated the same way as any registration. Once the IMS Emergency Session is in progress with NAS and AS integrity protection (and optionally ciphering) applied, failure of integrity checking or ciphering (for both NAS and AS) is an unusual circumstance and shall be treated as in the case of a normal bearer.

##### 10.2.1.3	UE in RM-REGISTERED state requests a PDU Session for IMS Emergency services

The UE initiates the UE requested PDU session establishment procedure to receive emergency services as specified in clause 5.16.4 in TS 23.501 [2]. Since the UE already has a current 5G security context when it attempts to set up an IMS Emergency Session, the UE shall use this 5G security context to protect NAS, RRC and UP traffic. If the AMF successfully validates the PDU Session request for emergency bearer services using the current 5G security context, the AMF may accept this request and setup a PDU session.
If the AMF attempts to re-authenticate the UE after receiving a correctly integrity protected request for emergency bearer services based on the current NAS security context and the authentication failed and if the serving network policy does not allow unauthenticated IMS Emergency Sessions, the UE and AMF shall proceed as for the initial registration error scenario as described in clause 6.1.3.
If the AMF attempts to re-authenticate the UE after receiving a correctly integrity protected request for emergency bearer services based on the current NAS security context and the authentication failed and the serving network policy allows unauthenticated IMS Emergency Sessions, then the set up of the emergency bearers shall proceed in one of the two ways:
a)	The set-up proceeds according to clause 10.2.2. In this case, there is no need for the UE to re-attach, and the AMF requests the use of the NULL ciphering and integrity algorithms in the same way as described in clause 10.2.2.2 for the case of Emergency registration by UEs in limited service state.
NOTE 1:	If the authentication failure is detected in the AMF then the UE is not aware of the failure in the AMF, but still needs to be prepared, according to the conditions specified in TS 24.301, to accept a NAS SMC from the AMF requesting the use of the NULL ciphering and integrity algorithms.
NOTE 2:	Regardless of if the authentication failed in the UE or in the AMF, the AMF can assume that the UE will accept that NULL integrity and ciphering algorithms are selected in the security mode control procedure
b)	The UE and the AMF continues using the current security context as described below for the case when primary authentication is executed while setting up a PDU session for emergency services.
If primary authentication procedure is executed while setting up a PDU Session for emergency bearer services, the AMF and UE shall behave as follows:
UE behavior:
-	Upon successful authentication verification in the UE, the UE shall continue using the current security context.
-	Alternatively, upon authentication verification failure in the UE, the UE shall send a failure message to the AMF and shall continue using the current security context. If the UE receives a NAS security mode command selecting NULL integrity and ciphering algorithms, the UE shall accept this as long as the IMS Emergency session progresses.
AMF behavior:
-	If the serving network policy allows unauthenticated IMS Emergency Sessions, the AMF, after the unsuccessful authentication verification of the UE, should not send a reject an Authentication Reject message and continue using the current security context with the UE.
-	After receiving both, the EC Indication and the failure message from the UE, the AMF shall continue using the current security context with the UE for establishing an emergency bearer.

#### 10.2.2	Unauthenticated IMS Emergency Sessions


##### 10.2.2.1	General

There are many scenarios when an unauthenticated Emergency Session may be established without the network having to authenticate the UE or apply ciphering or integrity protection for either AS or NAS. For example:
a)	UEs that are in Limited service state UEs, as specified in clause 3.5 in TS 23.122 [53].
b)	UEs that have valid subscription but SN cannot complete authentication because of network failure or other reasons
TS 23.401 [114] clause 4.3.12.1 identifies four possible network behaviours of emergency bearer support. Amongst these, the following two cases are applicable for unauthenticated emergency sessions:
a.	IMSI required, authentication optional. These UEs shall have a SUPI. If authentication fails, the UE is granted access and the unauthenticated SUPI retained in the network for recording purposes. The PEI is used in the network as the UE identifier. PEI only UEs will be rejected (e.g. UICCless UEs).
b.	All UEs are allowed. Along with authenticated UEs, this includes UEs with a SUPI that cannot be authenticated and UEs with only an PEI. If an unauthenticated SUPI is provided by the UE, the unauthenticated SUPI is retained in the network for recording purposes. The PEI is used in the network to identify the UE.
The network policy is configured to one of the above, and accordingly determine how emergency requests from the UE are treated.
If the ME receives a NAS SMC selecting NIA0 (NULL integrity) for integrity protection, and NEA0 (NULL ciphering) for encryption protection, then:
- 	the ME shall mark any stored native 5G NAS security context on the USIM /non-volatile ME memory as invalid; and
- 	the ME shall not update the USIM/non-volatile ME memory with the current 5G NAS security context.
These two rules override all other rules regarding updating the 5G NAS security context on the USIM/non-volatile ME memory, in the present document.
If NIA0 is used, and the NAS COUNT values wrap around, and a new KAMF has not been established before the NAS COUNT wrap around, the NAS connection shall be kept.
NOTE:	For unauthenticated IMS emergency sessions, NIA0, i.e., null integrity algorithm, is used for integrity protection. Additionally, as the NAS COUNT values can wrap around, the initialization of the NAS COUNT values are not crucial. Uplink and downlink NAS COUNT are incremented for NAS message that use NIA0, as for any other NAS messages.
A UE without a valid 5G subscription shall at an IRAT handover to 5G, when an IMS Emergency Service is active, be considered by the AMF to be unauthenticated. In such a scenario, NIA0 shall be used in 5G after handover if the target network policy allows unauthenticated IMS Emergency Sessions.
A handover from 5G to another RAT, of an unauthenticated IMS Emergency Session, shall result in an unauthenticated IMS Emergency Session in the other RAT.

##### 10.2.2.2	UE sets up an IMS Emergency session with emergency registration

UEs that are in limited service state (LSM) request emergency services by initiating the Registration procedure with the indication that the registration is to receive emergency services, referred to as Emergency Registration.
UEs that had earlier registered for normal services but now cannot be authenticated by the serving network, shall initiate Emergency Registration procedure to request emergency services.
It shall be possible to configure whether the network allows or rejects an emergency registration request and whether it allows unauthenticated UEs to establish bearers for unauthenticated IMS emergency sessions or not.
The AMF may attempt to authenticate the UE after receiving the emergency registration request.
If authentication failed in the UE during an emergency registration request, the UE shall wait for a NAS SMC command to set up an unauthenticated emergency bearer.
If authentication failed in the serving network and if the serving network policy does not allow unauthenticated IMS Emergency Sessions, the UE and AMF shall proceed as with the normal initial registration requests. The AMF shall reject the unauthenticated emergency bearer setup request from the UE.
If authentication failed in the serving network and if the serving network policy allow unauthenticated IMS Emergency Sessions, then the AMF shall support unauthenticated emergency bearer setup and the behaviours of the UE and the AMF are as described below.
a) UE behaviour:
After sending Emergency Registration request to the serving network the UE shall know of its own intent to establish an unauthenticated IMS Emergency Session.
The UE shall proceed as specified for the non-emergency case in except that the UE shall accept a NAS SMC selecting NEA0 and NIA0 algorithms from the AMF. If the UE accepts a NAS SMC selecting NEA0 and NIA0 algorithms from the AMF as part of Emergency Registration request, then the primary authentication performed if any shall be considered as unsuccessful and the newly generated KAUSF is not stored.
NOTE: 	In case of authentication success the AMF will send a NAS SMC selecting algorithms with a non-NULL integrity algorithm, and the UE will accept it.
b) AMF behavior:
After receiving Emergency Registration request from the UE, the AMF knows of that UE's intent to establish an unauthenticated IMS Emergency Session.
-	If the AMF cannot identify the subscriber, or cannot obtain authentication vector (when SUPI is provided), the AMF shall send NAS SMC with NULL algorithms to the UE regardless of the supported algorithms announced previously by the UE.
-	After the unsuccessful verification of the UE, the AMF shall send NAS SMC with NULL algorithms to the UE regardless of the supported algorithms announced previously by the UE.
-	If both, the Emergency Registration request and an AUTHENTICATION FAILURE  message with error code as defined in 24.501 [35] clauses 5.4.1.2.4.5 (for EAP based authentication) or 5.4.1.3.7 (for 5G AKA based authentication) are received by the AMF from the UE, then the AMF shall send NAS SMC with NULL algorithms to the UE regardless of the supported algorithms announced previously by the UE.
If the UE has initiated a PDU session establishment procedure to establish bearers for unauthenticated IMS emergency sessions and the AMF has indicated to the SMF that this is an unauthenticated emergency call, then the SMF shall indicate 'Not Needed' in the UP security policy for both UP confidentiality and UP integrity protection to the ng-eNB/gNB.

##### 10.2.2.3	Key generation for Unauthenticated IMS Emergency Sessions


###### 10.2.2.3.1	General

An unauthenticated UE does not share a complete 5G NAS security context with the network as there has been no successful primary authentication run between the UE and the AMF. When the UE and the AMF does not share the security context the only possibility for an AMF that allows unauthenticated IMS Emergency Sessions is to run with the NULL integrity algorithm NIA0 and the NULL ciphering algorithm NEA0.
When there has been no successful run of Primary authentication of the UE, the UE and the AMF independently generate the KAMF in an implementation defined way and populate the 5G NAS security context with this KAMF to be used when activating a 5G NAS security context. All key derivations proceed as if they were based on a KAMF generated from a successful Primary authentication run.
Even if no confidentiality or integrity protection is provided by NIA0 and NEA0, the UE and the network treat the 5G security context with the independently generated KAMF as if it contained a normally generated KAMF.

###### 10.2.2.3.2	Handover

When UE attempts to make Xn/N2 handover, UE and gNB derive and transfer the keys as normal to re-use the normal handover mechanism. Since the derived keys have no ability to affect the output of the NULL algorithms it is irrelevant that the network and the UE derive different keys. This implies that source gNB will forward UE 5G security capability which contains NIA0 and NEA0 to target gNB. So the target gNB can only select NIA0 for integrity protection and NEA0 for confidential protection. If the UE does not receive any selection of new AS security algorithms during a intra-gNB-CU handover, the UE continues to use the same algorithms as before the handover (see TS 38.331 [22]).
