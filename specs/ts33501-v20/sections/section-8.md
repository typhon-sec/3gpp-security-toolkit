# 8	Security of interworking


### 8.1	General

As described in TS 23.501 [2], in order to interwork with EPC, the UE can operate in Single Registration or Dual Registration mode.
When operating in Dual Registration mode, the UE shall independently maintain and use two different security contexts, an EPS security context to interact with the Evolved Packet System and a 5G security context to interact with the 5G System. Therefore, during inter-system mobility, when the target system is EPS, the UE shall take into use the EPS security context and hence all the security mechanisms described in TS 33.401 [10] are applicable. In the other direction, i.e. when the target system is the 5GC, the UE shall take into use the 5G security context and hence all the security mechanisms described in the present document are applicable.
When operating in Single Registration mode, there are two cases depending on the support of the N26 interface between the AMF and the MME. In both cases the security mechanisms described in all the subsequent sub-clauses are applicable.
Upon registration during mobility from EPS to 5GS, the UDM may decide to trigger the procedure defined in clause 6.1.5 based on the local operator authentication policy.

### 8.2	Registration procedure for mobility from EPS to 5GS over N26

During mobility from EPS to 5GS, the security handling described below shall apply.
When the UE performs idle mode mobility from EPS to 5GS, and if the UE has a native non-current 5G context, then the UE shall make the native non-current 5G context as the current one. The UE shall discard any mapped 5G security context.
The UE shall include the UE 5G security capability alongside the mapped 5G GUTI in the Registration Request message. The UE shall also include the 5G GUTI and the ngKSI that identify a current 5G security context if available, e.g. established during an earlier visit to 5G, and integrity protect the Registration Request using the selected security algorithms in the current 5G NAS security context as it is performed for a 5G NAS message over a 3GPP access. If the UE has no current 5G security context then the UE shall send the Registration Request message without integrity protection. As per clause 5.5.1.2.2 in 3GPP 24.501, the Registration Request shall contain the TAU request or ATTACH request integrity protected using the EPS NAS security context shared with the source MME as it is performed for a LTE NAS message, then the UE shall increment its stored uplink EPS NAS COUNT value by one.
NOTE: The enclosed TAU request or ATTACH request in the Registration Request contains a complete TAU Request or ATTACH request.
Upon receipt of the Registration Request, the AMF shall interact with the MME identified by the mapped 5G GUTI to retrieve the UE context. The AMF shall include the enclosed TAU request or ATTACH request in the Context Request message to the MME. The MME shall verify the TAU request or ATTACH request using the stored UE security context and if the verification is successful, the MME shall send the UE context to the AMF.
The AMF shall verify the integrity of the Registration Request message if the AMF obtained the 5G security context identified by the 5G GUTI. In case the verification succeeds then the AMF shall then dispose of any EPS security parameters received from the source MME in the Context Response message. In case the verification fails or the 5G UE context is not available then the AMF shall treat the Registration Request message as if it was unprotected. In such case, the AMF may either derive a mapped 5G security context from the EPS context received from the source MME as described in clause 8.6.2 or initiate a primary authentication procedure to create a new native 5G security context. If triggered by home network, the AMF performs the primary authentication as described in clause 6.1.5.
If the AMF derives a mapped 5G security context from the EPS security context, then the ngKSI associated with the newly derived mapped 5G security context and the uplink and downlink 5G NAS COUNTs are defined and set as described in clause 8.6.2. If the Registration Request contains a TAU Request or ATTACH request message, the network shall use the uplink EPS NAS COUNT corresponding to the TAU Request or ATTACH request message for deriving the KAMF' from the KASME. The AMF shall use and include the ngKSI to the UE in NAS SMC procedure, for the UE to identify the EPS security context used for the derivation of a mapped 5G security context.  If a mapped 5G security context is created or the native 5G security context has been changed (e.g., due to a new KAMF' derivation or NAS algorithm change), the AMF shall activate the resulting 5G security context by a NAS SMC procedure. When a mapped 5G security context is created, the AMF shall store the selected EPS NAS security algorithms in the mapped 5G security context and include them in the NAS Security Mode Command.
If the AMF wants to continue to use the native 5G security context used by the UE to protect the Registration Request, the AMF may skip the NAS SMC procedure and send the Registration Accept message protected using the native 5G security context identified by the 5G-GUTI and the ngKSI included in the Registration Request message.
In case the type value in the received ngKSI in NAS SMC indicates a mapped security context, then the UE shall use the value field in the received ngKSI to identify the EPS security context from which the UE derives the mapped 5G security context as described in clause 8.6.2. The UE shall activate the mapped 5G security context to verify the integrity protection of the NAS SMC as it is performed for a 5G NAS message over a 3GPP access.
The Registration Accept message shall be protected by the new mapped 5G security context (if a mapped 5G security context was activated by NAS SMC) or by the new native 5G security context (if a new native 5G security context was activated by NAS SMC) as it is performed for a 5G NAS message over a 3GPP access. Otherwise, the current native 5G security context shall be used. If the AMF chooses to derive an initial KgNB from a new KAMF key (either the mapped KAMF' key or the native KAMF key), then the initial KgNB is derived as specified in Annex A.9 using the start value of the uplink 5G NAS COUNT protecting the NAS Security Mode Command Complete message and an access type distinguisher set to "3GPP access". If the UE receives an AS SMC message, then the UE shall derive an initial KgNB from a new KAMF key in the same way as the AMF.

### 8.3	Handover procedure from 5GS to EPS over N26


#### 8.3.1	General

This subclause covers the case of handover from 5GS to EPS, as defined in TS 23.502 [8].

#### 8.3.2	Procedure

Figure 8.3.2-1 Handover from 5GS to EPC over N26
NOTE 1:	This procedure is based on clause 4.11.1.2.1 in TS 23.502 and only includes steps and description that are relevant to security.
If the UE is initially registered and connected to the 5GC, the 5GC has a current security context for the UE. The current 5G security context may be a mapped 5G security context resulting from a previous mobility from EPC, or a native 5G security context resulting from a primary authentication with the 5GC.
1.	The gNB/ng-eNB sends a Handover Required message to the AMF, including UE’s identity .
2.	When the source AMF performs a handover procedure to the EPC, after checking the UE's access rights and security capabilities, the source AMF shall prepare a UE context including a mapped EPS security context for the target MME. To construct the mapped EPS security context, the source AMF shall derive a K’ASME using the KAMF key and the current downlink 5G NAS COUNT of the current 5G security context as described in clause 8.6.1 and then increments its stored downlink 5G NAS COUNT value by one.
The source AMF shall select the EPS NAS algorithms identifiers (it has stored) to be used in the target MME at interworking handover to EPS, for encryption and integrity protection.
NOTE 2: 	A legacy target MME is expecting to receive the selected EPS NAS algorithms identifiers over N26 from the source AMF as the target MME believes the source AMF is another MME. The source AMF has therefore provisioned the EPS NAS security algorithms identifiers to be used at interworking handover to EPS to the UE in the 5G NAS SMC in 5G access as described in clause 6.7.2. The target MME could re-select different EPS NAS algorithms though to be used with the UE by running a NAS SMC in the following Tracking Area Update procedure.
The uplink and downlink EPS NAS COUNT associated with the newly derived KASME' key are set to the values as described in clause 8.6.1. The eKSI for the newly derived KASME' key is defined as described in clause 8.6.1.
The source AMF shall also derive the initial KeNB key from the KASME' key and the uplink NAS COUNT as specified in Annex A.3 of TS 33.401 [10] using 232-1 as the value of the uplink NAS COUNT parameter.
NOTE 3:	The source AMF and the UE only uses the 232-1 as the value of the uplink NAS COUNT for the purpose of deriving KeNB and do not actually set the uplink NAS COUNT to 232-1. The reason for choosing such a value not in the normal NAS COUNT range, i.e., [0, 224-1] is to avoid any possibility that the value may be used to derive the same KeNB again.
The source AMF subsequently derives NH two times as specified in clause A.4 of TS 33.401 [10]. The {NH, NCC=2} pair is provided to the target MME as a part of UE security context in the Forward Relocation Request message.
3.	The source AMF shall transfer the UE security context (including new KASME', eKSI, uplink and downlink EPS NAS COUNT’s, UE EPS security capabilities, selected EPS NAS algorithms identifiers) to the target MME in the Forward Relocation Request message. The UE NR security capabilities may be sent by the source AMF as well.
4.	When the target MME receives Forward Relocation Request message from source AMF, then the target MME shall derive EPS NAS keys (i.e., KNASenc and KNASint) from the received KASME' key with the received EPS NAS security algorithm identifiers as input, to be used in EPC as described in Annex A.7 in TS 33.401 [10]. The target MME needs to include the {NH, NCC=2} pair and the UE security capabilities in the S1 HANDOVER REQUEST message to the target LTE eNB. The UE security capabilities include the UE EPS security capabilities received from the source AMF.
5.	Upon receipt of the S1 HANDOVER REQUEST from the target MME, the target LTE eNB selects AS security algorithmsfrom the UE EPS security capabilities as described in clause 7.2.4.2.3 in TS 33.401 [10] and computes the KeNB to be used with the UE and proceed as described in clause 7.2.8.4.3 in TS 33.401[10]. The target LTE eNB then sends the selected AS security algorithms in the target to source transparent container in the S1 Handover Request Ack Message to the target MME.
6.	The target MME shall include the target to source transparent container received from the target LTE eNB in the Forward Relocation Response message sent to the source AMF.
7.	The source AMF shall include the target to source transparent container and the 8 LSB of the downlink NAS COUNT value used in KASME’ derivation in step 2, in the Handover command sent to the source gNB/ng-eNB.
8.	The source gNB/ng-eNB shall include the target to source transparent container and the 8 LSB of the downlink NAS COUNT value in the Handover command sent to the UE.
Upon the reception of the Handover Command message, the UE shall estimate the downlink NAS COUNT value using the received 8 LSB of the downlink NAS COUNT value and its stored downlink NAS COUNT value. The UE shall ensure that the estimated downlink NAS COUNT value is greater than the stored downlink NAS COUNT value. Then, the UE shall derive the mapped EPS security context, i.e. derive KASME' from KAMF as described in clause 8.6.1 using the estimated downlink 5G NAS COUNT value. After the derivation the UE shall set the downlink NAS COUNT value in the 5G NAS security context to the received downlink NAS COUNT value.
9.	The eKSI for the newly derived KASME' key is defined as described in clause 8.6.1. The UE shall also derive the EPS NAS keys (i.e. KNASenc and KNASint) as the MME did in step 4 using the EPS NAS security algorithms identifiers stored in the ME and provisioned by the AMF to the UE in 5G NAS SMC in earlier 5G access. The UE shall also derive the initial KeNB from the KASME' and the uplink NAS COUNT as specified in Annex A.3 of TS 33.401 [10] using 232-1 as the value of the uplink NAS COUNT parameter.
The UE shall also derive the {NH, NCC=2} pair as described in A.4 of TS 33.401 [10] and further derive the KeNB to be used with the UE by performing the key derivation defined in Annex A.5 in TS 33.401[10]. The UE shall derive the AS RRC keys and the AS UP keys based on the KeNB and the received AS EPS security algorithms identifiers selected by the target eNB as described in Annex A.7 in TS 33.401 [10]. The uplink and downlink EPS NAS COUNT associated with the derived EPS NAS keys are set to the values as described in clause 8.6.1. The UE shall immediately take into use the newly created mapped EPS security context, both for NAS and AS communication.
10.  The UE sends the Handover Complete message to the target LTE eNB. The UE shall cipher and integrity protect this message using the newly created mapped EPS security context.
11.  The target LTE eNB notifies the target MME with a Handover Notify message.
After successful completion of the Handover procedure, the UE shall delete any mapped 5G security context.
After deleting the mapped 5G security context, if the UE has a full non-current native 5G NAS security context then the UE shall make the non-current native 5G NAS security context the current one.

### 8.4	Handover from EPS to 5GS over N26


#### 8.4.1	General

This clause covers the case of handoff from EPS to 5GS, as defined in TS 23.502 [8].

#### 8.4.2	Procedure

Figure 8.4.2-1: Handover from EPS to 5GS over N26
NOTE 1:	This procedure is based on clause 4.11.1.2.2 in TS 23.502 [8] and only includes steps and description that are relevant to security.
As the UE is connected to the EPS, the source MME has a current EPS security context for the UE. The current EPS security context may be a mapped EPS security context resulting from a previous mobility from 5GC, or a native EPS security context resulting from a primary authentication with the EPS.
1.	The source eNB sends a Handover Required message to the source MME, including UE's identity .
NOTE 2:	The source MME checks whether the UE's security capabilities and access rights are valid in order to decide whether it can initiate handover to 5GS.
2.	The source MME selects the target AMF and sends a Forward Relocation Request to the selected target AMF. The source MME includes UE's EPS security context including KASME, eKSI, UE EPS security capabilities, selected EPS NAS algorithm identifiers, uplink and downlink EPS NAS COUNTs, {NH, NCC} pair, in this message. If the source MME has the UE NR security capabilities stored, then it will forward the UE NR security capabilities as well to the target AMF.
3.	The target AMF shall construct a mapped 5G security context from the EPS security context received from the source MME. The target AMF shall derive a mapped KAMF' key from the received KASME and the NH value in the EPS security context received from the source MME as described in clause 8.6.2.
If the target AMF receives the UE 5G security capabilities, then the target AMF shall select the 5G NAS security algorithms (to be used in the target AMF for encryption and integrity protection) which have the highest priority from its configured list.
If the target AMF does not receive the UE 5G security capabilities from the source MME, then the target AMF shall assume that the following default set of 5G security algorithms are supported by the UE (and shall set the UE 5G security capabilities in the mapped 5G NAS security context according to this default set):
a.	NEA0, 128-NEA1 and 128-NEA2 for NAS signalling ciphering, RRC signalling ciphering and UP ciphering;
b.	128-NIA1 and 128-NIA2 for NAS signalling integrity protection, RRC signalling integrity protection and UP integrity protection.
The target AMF then derives the complete mapped 5G security context. The target AMF shall derive the 5G NAS keys (i.e., KNASenc and KNASint) from the new KAMF' with the selected 5G NAS security algorithm identifiers as input, to be used in AMF as described in clause A.8. The uplink and downlink 5G NAS COUNTs associated with the derived 5G NAS keys are set to the value as described in clause 8.6. 2. The ngKSI for the newly derived KAMF' key is defined such as the value is taken from the eKSI of the KASME key (i.e. included in the received EPS security context) and the type is set to indicate a mapped security context. The target AMF shall store the EPS NAS security algorithms received from the source MME in the mapped 5G security context. Similar to N2-Handover defined in Clause 6.9.2.3.3, the target AMF shall also set the NCC to zero and shall further derive the temporary KgNB using the mapped KAMF' key and the uplink NAS COUNT value of 232-1 as specified in Annex A.9.
The target AMF associates this mapped 5G Security context with ngKSI.
NOTE 3:	The target AMF derives a temporary KgNB using the mapped KAMF' instead of using the {NH, NCC} pair received from the MME. The uplink NAS COUNT value for the initial KgNB derivation is set to 232-1. The reason for choosing such a value is to avoid any possibility that the value may be used to derive the same KgNB again.
The target AMF shall create a NAS Container to signal the necessary security parameters to the UE. The NAS Container shall include a NAS MAC, the selected 5G NAS security algorithms, the ngKSI associated with the derived KAMF' and the NCC value associated with the NH parameter used in the derivation of the KAMF'.  The target AMF shall calculate the NAS MAC as described in clause 6.9.2.3.3. with the COUNT parameter set to the maximal value of 232-1.
The target AMF shall increment the downlink NAS COUNT by one after creating a NAS Container.
4.	The target AMF requests the target gNB/ng-eNB to establish the bearer(s) by sending the Handover Request message.
The target AMF sends the NAS Container created in step 3 along with, the {NCC=0, NH=derived temporary KgNB}, the New Security Context Indicator (NSCI), and the UE security capabilities in the Handover Request message to the target gNB/ng-eNB. The target AMF shall further set the NCC to one and shall further compute a NH as specified in Annex A.10. The target AMF shall further store the {NCC=1, NH} pair.
5.	The target gNB/ng-eNB shall selects the 5G AS security algorithms from the list in the UE security capabilities
The target gNB/ng-eNB shall compute the KgNB to be used with the UE by performing the key derivation defined in Annex A.11 with the {NCC, NH} pair received in the Handover Request message and the target PCI and its frequency ARFCN-DL. The target gNB/ng-eNB shall associate the NCC value received from AMF with the KgNB.The target gNB /ng-eNB shall then derive the 5G AS security context, by deriving the 5G AS keys (KRRCint, KRRCenc, KUPint, and KUPenc) from the KgNB and the selected 5G AS security algorithm identifiers as described in Annex A.8 for gNB and in Annex A.7 in TS 33.401[10].
The target gNB/ng-eNB sends a Handover Request Ack message to the target AMF. Included in the Handover Request Ack message is the Target to Source Container, which contains the selected 5G AS algorithms, the keySetChangeIndicator, the NCC value from the received {NH, NCC} pair, and the NAS Container received from the target AMF. If the target gNB/ng-eNB had received the NSCI, it shall set the keySetChangeIndicator field to true, otherwise it shall set the keySetChangeIndicator field to false.
6.	The target AMF sends the Forward Relocation Response message to the source MME. The required security parameters obtained from gNB/ng-eNB in step 5 as the Target to Source Container are forwarded to the source MME.
7.	The source MME sends the Handover Command to the source eNB. The source eNB commands the UE to handover to the target 5G network by sending the Handover Command. This message includes all the security related parameters in the NAS Container obtained from the target AMF in step 6.
8.	The UE derives a mapped KAMF' key from the KASME in the same way the AMF did in step 3. It shall also derive the 5G NAS keys and KgNB corresponding to the AMF and the target gNB/ng-eNB in step 3 and step 5. The UE shall further set the selected EPS NAS security algorithms in the 5G security context to the NAS security algorithms used with the source MME. It associates this mapped 5G security context with the ngKSI included in the NAS Container. The UE shall verify the NAS MAC in the NAS Container.
If verification of the NAS MAC fails, the UE shall abort the handover procedure. Furthermore, the UE shall discard the new NAS security context if it was derived and continue to use the existing NAS and AS security contexts.
NOTE 4: 	Void.
The mapped 5G security context shall become the current 5G security context.
9.	The UE sends the Handover Complete message to the target gNB/ng-eNB. This shall be ciphered and integrity protected by the AS keys in the current 5G security context.
10.	The target gNB/ng-eNB notifies the target AMF with a Handover Notify message.
If the UE has a native 5G security context established during the previous visit to 5GS, then the UE shall provide the associated the 5G GUTI as an additional GUTI in the Registration Request following the handover procedure. The UE shall use the mapped 5G security context to protect the subsequent Registration Request message over 3GPP access. The target AMF shall validate the integrity of the Registration Request message using the mapped security context. Upon successful validation, the target AMF shall send a context request message to the old AMF and shall include the additional GUTI and an indication that the UE is validated. Upon receiving the context request message with the indication that the UE is validated, the old AMF shall skip the integrity check and transfer the native 5G security context to the target AMF.The AMF shall retrieve the native security context using the 5G GUTI. If the AMF determines to activate the native security context, the AMF shall perform a NAS SMC procedure.
NOTE 5: It is up to AMF when to activate the native 5G security context.
If the handover is not completed successfully, the new mapped 5G security context cannot be used in the future. In this case, the AMF shall delete the new mapped 5G security context.
If the AMF has no native 5G security context available when the UE performs the Registration Request (protected by the mapped 5G security context) following the handover procedure, then the AMF via the SEAF should run a primary authentication depending on local operator policy.
The handling of security contexts in the case of multiple active NAS connections in the same PLMN’s serving network is given in clasue 6.4.2.2.

### 8.5	Idle mode mobility from 5GS to EPS over N26


#### 8.5.1	General

This clause covers the case of idle mode mobility from 5GS to EPS over N26, as defined in TS 23.502 [8].The UE performs either Tracking Area Update (TAU) procedure or Initial Attach procedure in this scenario.

#### 8.5.2	TAU Procedure

NOTE:	This procedure is based on clause 4.11.1.3.2 in TS 23.502 [8] and only includes steps and descriptions that are relevant to security.
Figure 8.5.2-1: Idle mode mobility from 5G to 4G
1.	The UE initiates the TAU procedure by sending a TAU Request to the MME with a mapped EPS GUTI derived from the 5G GUTI and its EPS security capabilities. The mapped EPS GUTI contains the information of the AMF that has the latest UE context in the 5G network.
The UE integrity protects the TAU Request message using the current 5G NAS security context identified by the 5G GUTI used to derive the mapped EPS GUTI. More precisely, the UE shall compute the NAS MAC for the TAU request as it is done for a 5G NAS message over a 3GPP access. The NAS Uplink COUNT for integrity protection of the TAU request shall use the same value as the 5G NAS Uplink COUNT. Consequently, this results in an increase of the stored NAS Uplink COUNT value in the NAS COUNT pair associated with the 3GPP access. The corresponding ngKSI value of the 5G Security context is included in the eKSI parameter of the TAU Request message.
2.	Upon receipt of the TAU Request, the MME obtains the AMF address from the mapped EPS GUTI value.
3.	The MME forwards the complete TAU Request message including the eKSI, NAS-MAC and mapped EPS GUTI in the Context Request message.
4.	The AMF shall use the eKSI value field to identify the 5G NAS security context and use it to verify the TAU Request message as if it was a 5G NAS message received over 3GPP access.
5.	If the verification is successful, the AMF shall derive a mapped EPS NAS security context as described in clause 8.6.1. The AMF shall set the EPS NAS algorithms to the ones indicated earlier to the UE in a NAS SMC as described in clause 6.7.2.
The AMF shall include the mapped EPS NAS security context in the Context Response message it sends to the MME. The AMF shall never transfer 5G security parameters to an entity outside the 5G system.
6.	The UE shall derive a mapped EPS NAS security context as described in clause 8.6.1. The UE shall select the EPS algorithms using the ones received in an earlier NAS SMC from the AMF as described in clause 6.7.2. The UE shall immediately activate the mapped EPS security context and be ready to use it for the processing of the TAU Accept message in step 7.
7.	The MME compares the UE security algorithms to its configured list after it receives the Context Response message. If an algorithm change is required, the MME shall select the NAS algorithm which has the highest priority from its configured list and is also present in the UE 5G security capabilities and initiate an NAS SMC to the UE. Otherwise, step 8~10 shall be skipped.
8 - 10.	The MME and the UE performs an NAS SMC to derive new NAS keys with the new algorithms as described in Clause 7.2.8.1.2 of TS 33.401[10].
11.	The MME completes the procedure with a TAU Accept message.
After successful completion of the TAU procedure, the UE shall delete any mapped 5G security context. After deleting the mapped 5G security context, if the UE has a full non-current native 5G NAS security context then the UE shall make the non-current native 5G NAS security context the current one.
8.5.3	Initial Attach Procedure
NOTE:	This procedure is based on clause 4.11.1.5.2 in TS 23.502 [8].
The Initial Attach procedure shall use the security mechanism for the TAU procedure in clause 8.5.2.

### 8.6	Mapping of security contexts


#### 8.6.1	Mapping of a 5G security context to an EPS security context

The derivation of a mapped EPS security context from a 5G security context is done as described below:
-	The KASME' key, taken as the KASME, shall be derived from the KAMF using the 5G NAS Uplink COUNT value derived from the TAU Request message or Attach Request message in idle mode mobility or the 5G NAS Downlink COUNT value in handovers as described in Annex A.14.
-	The eKSI for the newly derived KASME key shall be defined such as the value field is taken from the ngKSI and the type field is set to indicate a mapped security context.
-	The EPS uplink and downlink NAS COUNT values in the mapped context shall be set to the uplink and downlink NAS COUNT values of the current 5G security context respectively.
-	The selected EPS NAS algorithms shall be set to the EPS algorithms signalled to the UE by the AMF during an early authentication procedure followed by a NAS SMC as described in clause 6.7.2.
NOTE:	Whenever an algorithm change is required, the target MME initiates an NAS SMC to select other algorithms as described in TS 33.401 [10].

#### 8.6.2	Mapping of an EPS security context to a 5G security context

The derivation of a mapped 5G security context from an EPS security is done as described below.
-	The KAMF' key, taken as the KAMF, shall be derived from the KASME using the EPS NAS Uplink COUNT of the TAU message included in the Registration Request message in idle mode mobility or the NH value in handovers as described in clause A.15.
-	The ngKSI for the newly derived KAMF key shall be defined such as the value field is taken from the eKSI and the type field is set to indicate a mapped security context.
-	The 5G NAS COUNT values in the mapped 5G security context shall be set to 0.
NOTE:	The selection of the 5G NAS algorithms is performed by the AMF and signalled to the UE either in the NAS Container during handovers as described in clause 8.4, or in a NAS SMC during idle mode mobility as described in clause 8.2.

### 8.7	Interworking without N26 interface in single-registration mode

When the UE supports single-registration mode and network supports interworking procedure without N26 interface:
-	For mobility from 5GC to EPC, if the UE has a current EPS NAS security context, the UE shall start using the EPS security context as defined in TS 33.401 [10].
-	For mobility from EPC to 5GC, if the UE has a current 5G NAS security context, the UE shall start using the 5G NAS security context as defined in the present document.
