# W.4	Security mechanisms for MBS traffic transmission


### W.4.1	Key derivation, management and distribution


#### W.4.1.1	General

If the security protection of MBS traffic is required, confidentiality and integrity protection as specified in clause 5.3 of TS 33.246 [102] apply. The control-plane procedure and user-plane procedure are optionally supported in service layer. The control-plane procedure is only applicable for multicast sessions, while the user-plane procedure is applicable for both multicast sessions and broadcast sessions. The user plane  security between UE and RAN shall be deactivated  when 5GC shared MBS traffic delivery method for MBS data transmission is used to avoid redundant protection.
The MBS Security Function (MBSSF) is a logical function, which needs to be collocated with either MBSF or MBSTF and the according interfaces are up to the implementation of the deployment options. In case of the control-plane procedure, the key derivation, management and distribution in MBSF and MBSTF can be achieved in MBSSF.

#### W.4.1.2	Control-plane procedure

The multicast session security context consists of the MBS session ID, MBS keys and the corresponding key ID. The MBS keys include MBS Service Key (MSK) and MBS Traffic Key (MTK). MBS traffic is protected with the MTK. The MSK is used to protect the MTK when the MTK is delivered to the UE. The identification for every MSK and MTK are determined as specified in Clause 6.3.2.1 and clause 6.3.3.1 of TS 33.246 [102].
The MBSF determines whether security protection to be applied or not for the MBS session based on locally configured policy or based on the information provided by the AF. If security protection to be applied, then the MBSF shall create the multicast session security context by generating the MSK and its key ID for a MBS session. Afterwards, the MBSF distributes the MSK with MBS session ID and its key ID to the MB-SMF and MBSTF. The MBSF shall also distribute them to MB-SMF either upon request by the MB-SMF (i.e., pull) or when a new MSK is generated (i.e., push). The MBSF may also include the MSK lifetime when it distributes the MSK to MBSTF.
Upon receiving the MSK from the MBSF, the MBSTF generates the MTK and its key ID for the MBS traffic protection. A new MTK may be generated based on the MBS session security policy. When the MBSTF generates a new MTK, the MBSTF shall multicast the MTK and its key ID after protecting it using the MSK as specified in TS 33.246 [102]. The MBSTF shall also provide the new MTK and its key ID to the MBSF.
During the MBS session creation for multicast communication as specified in clause 7.1.1 of TS 23.247 [103], after receiving the description for an MBS session from the AF of content provider, the MBSF shall create the multicast session security context by generating an MSK and acquiring an MTK from the MBSTF. Afterwards, the MBSF distributes the muticast session security context to the MB-SMF via the Nmbsmf_MBSSession_Create Request message.
In the multicast session join and session establishment procedure, the SMF interacts with the MB-SMF to obtain the multicast session security context with Nmbsmf_MBSSession_ContextStatusSubscribe service. Absence of the multicast security context indicates that security protection is not applied for the MBS session. The SMF shall provide the multicast session security context in the N1 SM container (PDU Session Modification Command) to the UE if received from the MB-SMF and the UE is authorized to use the required multicast service. The UE shall use the MTK in the received multicast session security context, to process the protected MBS traffic until it receives a new MTK update over the user-plane.
The MSK update may be triggered by MB-SMF based on the request from AS or based on the local policy (e.g., key lifetime expiration). When the MSK is updated, the MBSF shall send the new MSK with MBS session ID and its key ID to the MB-SMF and then the MB-SMF shall trigger the session update as specified in clause 7.2.6 in TS 23.247 [103]. The MSK with MBS session ID and the corresponding key ID are delivered to the UEs that has joined the multicast session.  The MBSF shall also send the new MSK with MBS session ID and its key ID to the MBSTF. The MBSTF may request a MSK to the MBSF when it does not have a valid MSK (e.g., due to the current MSK expiration).
NOTE 1: For an inactive MBS session, MBSTF defers MSK distribution until the MBS session is re-activated.
The MTK may be updated based on the change of the authorization information or based on the local policy (e.g. key lifetime expiration). In such cases, the MBSF or MB-SMF may trigger the MTK update to the MBSTF. The key update request message shall include the MBS session ID. If the MBSTF has generated a new MTK, the MBSTF shall provide the new MTK to the MBSF. To improve the efficiency of MTK update, the updated MTK is delivered from MBSTF to the UE using MIKEY over UDP as specified in clause 6.3.3.2 in TS 33.246 [102]. The MSK is used to protect the updated MTK. The UE shall not send an error message to the MBSTF as a result of receiving an MTK message.
NOTE 2: For an inactive MBS session, MBSTF defers the MTK distribution until the session in re-activated.

#### W.4.1.3	User-plane procedure

The UE registers to the MBS service and receives the MBS traffic as specified in TS 33.246 [102] with the following changes.
-	MBSSF takes the role of the BM-SC in TS 33.246 [102].
-	The UE authenticates to the MBSSF (i.e. MBSF or MBSTF) based on the GBA as in MBMS security (see TS 33.246 [102]) or based on the AKMA (see TS 33.535 [104]). When the AKMA is used, the MRK is derived from the KAF as specified in Annex F of TS 33.246 [102] by replacing the Ks_NAF for the GBA_ME run with KAF. Furthermore, when the AKMA is used, the MUK is set to KAF. When the authorization of MBS service to the UE is required, the user id (e.g., GPSI) provided to the MBSSF by the AAnF shall be used.
NOTE a:	Void
-	The identifier(s) of MBS user service(s) in TS 26.502[108] is included in local configuration in MBSSF or in UDM as part of MBS subscription data for a UE, which identifies the user service(s) that the UE is allowed to join. After receiving the HTTP POST message (see clause 6.3.2 of TS 33.246 [102]) that] includes the identifier(s) of MBS user service(s), MBSSF shall authorize the UE based on local configuration if available. If no local configuration is available, the MBSSF should send verification request with user id (e.g., IMPI in GBA or GPSI in AKMA) and identifier(s) of MBS user service(s) to UDM to acquire the authorization result. If the UE is authorized, the MBSSF registers the UE to the MBS user service(s).
NOTE: the local configuration in MBSSF may be preconfigured or provided by AF.

### W.4.2	Protection of the traffic transmission

The traffic may require some protection depending on the sensitivity of the data being transmitted. For example, it is possible that the data being transmitted is actually protected by the application layer security and hence might not require additional protection. However, the protection in service layer is independent of application layer security.
The service protection description in the Service Announcement implies the protection requirement of the traffic transmission in case the security protection is provided in service layer. It may include indications for which security procedures are supported by the network: control-plane procedure or user-plane procedure. If the support for user-plane procedure is indicated then the description should include also an indication of whether GBA or/and AKMA is supported.
NOTE: If the security protection in service layer is not required, the service protection description is not present in the Service Announcement. If the UE does not support the network selected MBS security procedure at the service layer, then the UE can obtain the service via unicast delivery.
The actual method of protection may vary depending on the type of data being transmitted, e.g. media streaming application or file download. Clause 6.6.2 and clause 6.6.3 in TS 33.246 [102] apply to the protection of streaming data and protection of download data, respectively.

### W.4.3	Authentication and authorization aspects for the multicast session

The support for the optional-to-use authentication and authorization procedure for a 5G multicast session is specified in this clause.
AKMA/GBA is supported for authentication and authorization in user-plane procedure for security protection of MBS traffic, as specified in clause W.4.1.3 of the present document.

### W.4.4	Security handling in network sharing scenario

In Multiple-Operator Core Network (MOCN) network sharing scenarios, if MBS content protection is needed, then the content may be protected at the application layer (c.f., W.4.2).
NOTE 1:	The content protection mechanism used at the application layer is outside the scope of 3GPP.
If service-layer security specified in clause W.4.1.3 of the present document is used in MOCN network sharing scenarios, the AF may be required to generate the MSK, MSK ID, MTK and MTK ID common to the participating PLMNs. The AF provides the generated MSK, MSK ID, MTK and MTK ID to the MBSSF(s) of the participating PLMNs, when creating broadcast MBS sessions and also when key update is required. Furthermore, it is up to the AF to select a MCC and MNC among the PLMNs for the Key Domain ID. As mentioned in clause 6.3.2.1 of TS 33.246 [102], the UE should not try to use the MCC and MNC in another context, e.g., the UE should not compare the received MCC || MNC to parameters in radio level.
NOTE 2: Security aspects between the AF and the MBSSF(s) is outside the scope of 3GPP.
NOTE 3: If the MBSSF uses MSK and MTK generated by itself to protect the traffic, the resource sharing during network sharing will not be used.
