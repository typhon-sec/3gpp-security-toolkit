# X.12	Security for Vertical Federated Learning among NWDAFs and AFs


### X.12.1	General

This clause outlines the security considerations for vertical federated learning (VFL) where both AFs and NWDAF can act as VFL participants (i.e., either VFL servers or clients), as described in clause 6.2H of TS 23.288 [105]. According to TS 23.288 [105], when an AF acts as VFL server, only NWDAFs can be VFL clients.
The authorization of prospective VFL participants, as described in clause X.12.2, is conducted for the cases that NWDAF serves as the VFL server, external AF acts as the VFL server, and internal AF acts as the VFL server.
Clause X.12.3 outlines the general NEF security requirements related to the privacy aspects of VFL.
Clause X.12.4 addresses the protection of communication data used in the VFL process and will reuse SBA security measures as detailed in clause 13.

### X.12.2	Authorization of candidate VFL participants


#### X.12.2.1	Authorization of candidate VFL participants for VFL when NWDAF or Internal AF is acting as the VFL server

Figure X.12.2.1-1 depicts the authorization mechanism for NWDAF or internal as VFL Server. The authorization is based upon the VFL capability information per supported analytics ID which includes VFL capability type (VFL server and/or VFL client), Analytics ID and VFL Interoperability Indicator per analytics ID provided by VFL members during registration.
Figure X.12.2.1-1: Authorization of VFL participants (NWDAF or Internal AF acts as VFL Server)
1. In case of external AF as VFL Client, the NEF updates its NF profile at the NRF with AF’s VFL capability information per supported analytics ID which includes VFL Capability type i.e., VFL Client and VFL interoperability indicator(s) per analytics ID and associated AF ID. In all cases where a NWDAF or Internal AF acts as VFL Client or VFL Server, it registers its NF profile at the NRF as described in clause 5.2 or 6.2H.2.1.1 of TS 23.288[105].
2. The NWDAF or Internal AF acting as VFL Server discovers VFL Client(s) from NRF by invoking the NFDiscovery Request service operation with VFL capability information per supported Analytics ID that includes VFL capability type (i.e., VFL client), VFL interoperability indicator per analytics ID, Analytics ID(s) as specified in clause 6.2H.2.1.1 of TS 23.288[105]. When an Internal AF is acting as a VFL server, only NWDAF(s) are discovered as VFL clients.
3. The NWDAF or Internal AF acting as VFL Server sends Nnrf_AccessToken_Get request to NRF as specified in clause 13.4.1. For NWDAF as server, the message additionally includes the Analytics ID, AF ID (for external AF as client) and optionally VFL interoperability indicator per analytics ID. For internal AF as server, the message additionally includes the Analytics ID and optionally VFL interoperability indicator per analytics ID.
4. The NRF checks whether the NWDAF or Internal AF acting as VFL Server is authorized to access the NEF or NWDAF or Internal AF (VFL Client(s)) for VFL service(s) respectively as specified in clause 13.4.1, optionally verifying the VFL interoperability indicator(s) per analytics ID in the token request is in the VFL interoperability indicator(s) per analytics ID as received from VFL server and VFL client in Step 1. If the server NWDAF or Internal AF acting as server is authorized by the NRF, the NRF will issue access token(s) as specified in clause 13.4.1. For external AF as VFL client the token claim may additionally include VFL interoperability indicator for that particular analytics ID, Analytics ID and the AF ID. For NWDAF or Internal AF as VFL Client the token claim may additionally include VFL interoperability indicator for that particular analytics ID and Analytics ID.
5. The NRF sends the access token(s) to the NWDAF or Internal AF acting as VFL Server, or the NRF rejects the request in case of failed authorization, as described in clause 13.4.1.
6a. External AF as VFL client: The NWDAF as VFL Server may send VFL Service Request (e.g. VFL Training, VFL Inference) to NEF and the token received in Step 5. The service request includes the Analytics ID, AF ID and optionally VFL interoperability indicator per analytics ID.
6b. NWDAF or internal AF as VFL client: The Internal AF or NWDAF acting as VFL Server may send VFL Service Request to NWDAF or Internal AF as VFL client and the token received in Step 5. The service request includes the Analytics ID and optionally VFL interoperability indicator per analytics ID.
7a. External AF as VFL client: The NEF verifies the access token received from the NWDAF to check whether the NWDAF is allowed to access the external AF for the requested analytics as specified in clause 13.4.1. The NEF extracts the Analytics ID from the access token and check whether it matches the Analytics ID received in step 6a. If the AF ID is included in the token, the NEF also verifies that the AF ID matches the AF ID requested in step 6a. If the VFL interoperability indicator(s) per analytics ID are included in the token, the NEF also verifies that interoperability indicator(s) per analytics ID match the VFL interoperability indicator(s) per analytics ID in step 6a.
7b. NWDAF or internal AF as VFL client: The NWDAF or Internal AF as VFL client verifies whether the access token received from the NWDAF or Internal AF as VFL Server includes Analytics ID and optionally VFL interoperability indicator per analytics ID received in step 6b.
8. External AF as VFL client: The NEF sends the VFL Service Request to the external AF as VFL client that includes the Analytics ID, AF ID and optionally VFL interoperability indicator per analytics ID. The AF performs authorization of VFL service request based on its local policy and implementation. Protection of NEF-AF interface is as specified in clause 12.
9a. External AF as VFL client: The external AF as VFL client sends VFL Service response (success or failure) to the NEF.
9b. External AF as VFL client: The NEF forwards the VFL Service response to the NWDAF acting as the VFL server.
10. NWDAF or internal AF as VFL client: The NWDAF or Internal AF acting as VFL Client sends the VFL Service response to the NWDAF/Internal AF acting as VFL server.

#### X.12.2.2	Authorization of candidate VFL participants for vertical federated learning when external AF is acting as the VFL server

Figure X.12.2.2-1 depicts the authorization mechanism for NWDAF as VFL Client and external AF as VFL server. The authorization is based upon the VFL capability information per supported analytics ID which includes VFL capability type (VFL server and/or VFL client), Analytics ID and VFL Interoperability Indicator per analytics ID provided by VFL members during registration.
Figure X.12.2.2-1: Authorization of candidate VFL participants for VFL when external AF is acting as the VFL server
1. In case of AF as VFL Server, the NEF updates its NF profile as specified in clause 6.2H.2.1.2 of TS 23.288[105], which includes AF’s VFL capability information per supported analytics ID which includes VFL Capability type, i.e., VFL Client and VFL interoperability indicator(s) per analytics ID and associated AF ID. In case of NWDAF as VFL Client, it shall register to NRF with its NF profile as specified in clause 6.2H.2.1.2 of TS 23.288[105].
2. The AF sends a Nnef_NFDiscovery_Request to the NEF with information Analytics ID, VFL capability type (VFL Client), VFL interoperability indicator to discover for VFL Client. The NEF discovers NWDAF as VFL client from the NRF by invoking the Nnrf_NFDiscovery_Request as specified in 6.2H.2.1.2 of TS 23.288[105]. The NEF checks based on configured policies whether the AF is entitled to discover service to a VFL client as specified in clause 12.
NOTE: Handling of temporary NWDAF instance ID (s) is specified in clause 6.2H.2.1.2 of TS 23.288 [105].
3. The AF acting as VFL server sends VFL Service Request (e.g., VFL Training, VFL Inference) towards NEF. The Service request shall contain the analytics ID and optionally VFL interoperability indicator per analytics ID.
4. The NEF requests an access token from the NRF as specified in clause 13.4.1 to perform VFL service towards the VFL clients (NWDAF). The Nnrf_AccessToken_Get request shall additionally contain the Analytics ID, AF ID and optionally VFL interoperability indicator per analytics ID.
5. The NRF checks whether NEF on behalf of VFL Server AF is authorized to access the VFL client NWDAF for the VFL service(s) as specified in clause 13.4.1, optionally verifying the VFL interoperability indicator in the token request is in the VFL interoperability indicator(s) as received from VFL server and VFL client in Step 1.
6. If the NEF is authorized, the NRF will issue an access token(s) in response as specified in clause 13.4.1. The token claim may additionally include VFL interoperability indicator for that particular analytics ID, Analytics ID and AF ID.
7. The NEF sends VFL Service Request to NWDAF (VFL Client) and the token includes the Analytics ID, AF ID and optionally VFL interoperability indicator per analytics ID as token received in Step 6.
8. The NWDAF verifies the received access token as specified in clause 13.4.1 and checks for the token claims as received in step 7. The NWDAF extracts the Analytics ID, AF ID and VFL interoperability indicator(s) per analytics ID from the access token and check whether it matches the Analytics ID, AF ID and VFL interoperability indicator(s) per analytics ID received in step 7.
9a. In case of successful access token verification, the NWDAF (VFL as client) sends a VFL Service Response to the NEF.
9b. The NEF sends the VFL Service Response to the AF (VFL as Server). Protection of NEF-AF interface is as specified in clause 12.

### X.12.3	NEF security requirements

In case NEF is involved, NF instance ID shall not be transmitted outside the 3GPP operator domain via NEF.
The NEF can be responsible for performing UE ID mapping, converting internal UE IDs (i.e., SUPI) to external UE IDs in accordance with the security requirement outlined in clause 5.9.2.3 of the present document.

### X.12.4	Protection of communication data used in VFL process.

The current SBA mechanisms as defined in clauses 12.2 and 12.3 of the present document for the NEF-AF interface and clause 13.1 of the present document for communication among VFL participants shall be used.

######### Annex Y (normative): 
Security aspects of the Message Service for MIoT over the 5G System (MSGin5G)

