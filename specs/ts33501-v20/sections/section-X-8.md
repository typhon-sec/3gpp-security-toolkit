# X.8	Protection of data and analytics exchange in roaming case


### X.8.1	General

The protection of data and analytics exchange in roaming case including authorization and anonymization of data/analytics:
-	Authorization at data and analytics level is enforced by the roaming entry NWDAF producer. The parameters used by NWDAF service consumer to request/subscribe to the services provided by NWDAF producer are defined in TS 23.288 [105], clause 6.1.5. Accordingly, the operator authorization policies can be configured locally in the NWDAF producer.  Also, when the NWDAF in one PLMN requests an access token from the NRF in the peer PLMN, the access token request and the access token claims may contain the Analytics ID.
-	The roaming entry NWDAF producer is responsible to control the amount of exposed data/analytics and to abstract or hide internal network aspects in the exposed data/analytics. The corresponding mechanisms used to restrict the data/analytics and/or anonymization are subject to the implementation.

### X.8.2	Procedure for protection of analytics exchange in roaming case


#### X.8.2.1	Policies configured locally in Roaming entry NWDAF producer

Figure X.8.2.1-1: Protection of analytics exchange when policies configured locally in Roaming entry NWDAF
Pre-requisites:
-	Roaming entry NWDAF producer, i.e. NWDAFp shall be pre-configured with a list of allowed analytics per PLMN.
-	If token-based authorization is used, NWDAFc shall have acquired an access token from the PLMN2 to consume the services exposed in Nwdaf_RoamingAnalytics_Subscribe/Request APIs.
Step 1: NWDAFc sends Nnwdaf_RoamingAnalytics_Subscribe/Request message to NWDAFp to request analytics.
Step 2: The roaming entry NWDAFp shall verify the service request, including verifying token and the visited PLMN ID and determine whether the requested analytics are allowed to be exposed to NWDAFc in PLMN1 by pre-configured policies.
Step 3: The roaming entry NWDAFp shall apply the security policies per consumer (PLMN) to the requested analytics and decide on their anonymization, restriction or desensitization based on operator’s policy.
NOTE: The anonymization, restriction or desensitization mechanisms of analytics are left for implementation.
Step 4: NWDAFp returns the requested and processed analytics to NWDAFc.

#### X.8.2.2	Policies configured as extended claims in access token

Figure X.8.2.2-1: Protection of analytics exchange when policies configured as extended claims in access token
Pre-requisite:
-	The producer NRF has the NF profile of the NF Service Producer including the list of allowed Analytics ID(s) per PLMN. According to TS 29.510 [68] clause 5.2.1, the NF profile can be configured in the NRF by other means such as O&M.
Step 1: NWDAFc sends an Nnrf_AccessToken_Get request to the consumer NRF as specified in clause 13.4.1. The access token request may contain the Analytics ID.
Step 2: vNRF forwards the token request message to hNRF as specified in clause 13.4.1.
Step 3: The home network hNRF shall verify the Nnrf_AccessToken_Get request as specified 13.4.1, and determine whether the requested analytics implied by the Analytics ID(s) can be obtained by the visited PLMN according to the allowed Analytics ID(s) of the visited PLMN.
Step 4: If the verification is successful, hNRF issues the token as specified in clause 13.4.1. The allowed Analytics ID(s) of the visited PLMN may be included in the token.
Step 5: The vNRF forwards the Nnrf_AccessToken_Get Response to NWDAFc as specified in clause 13.4.1.
Step 6: If the requested analytics is within the claim of token, the NWDAFc sends Nnwdaf_RoamingAnalytics_Subscribe/Request with the issued token to NWDAFp.
Step 7: The roaming entry NWDAFp verifies the service request, including verifying token as specified in clause 13.4.1, and whether the requested analytics is within the allowed Analytics ID(s) in the token.
Step 8: The roaming entry NWDAFp shall apply the security policies per consumer (PLMN) to the requested analytics and decide on their anonymization, restriction or desensitization based on operator’s policy.
NOTE: The anonymization, restriction or desensitization mechanisms of data / analytics are left for implementation.
Step 9: The Roaming entry NWDAFp returns the requested and processed analytics to the NWDAFc.
