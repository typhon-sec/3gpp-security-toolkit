# J.1 	SRVCC from NR to UTRAN


#### J.1.1	General

5G Single Radio Voice Call Continuity (SRVCC) is specified in 3GPP TS 23.216 [72], TS 23.501 [2] and TS 23.502 [8]. This clause specifies the security aspect to support SRVCC from 5G to UTRAN. SRVCC from UTRAN to 5G shall not be allowed. After a 5G to UTRAN SRVCC session has terminated, a UE shall run a successfully (re)authentication in 5GS before allowed to access 5G.
During SRVCC from 5G to UTRAN CS, the MSC server should never know the KAMF nor should the KAMF be revealed to an entity other than an AMF.
The AMF derives new key(s) to create a mapped SRVCC security context for the MSC server instead of sending KAMF to the MSC server.

#### J.1.2	Procedure

As described in TS 23.216[72], there is no direct interface between the AMF in 5G and the MSC in UTRAN to support SRVCC, so the keys used to protect the SRVCC session once the UE is handed over to UTRAN are derived by MME based on security context mapping from 5G to E-UTRAN and then forwarded to the MSC during the HO procedure.
The procedure is initiated when the gNB wants to trigger a 5G SRVCC handover to UTRAN.
Figure J.1.2-1: Key derivation of 5G SRVCC from NR to UTRAN
1. The gNB sends Handover required message to the AMF.
2. The AMF shall derive a new KASME_SRVCC key using the KAMF key and the current downlink 5G NAS COUNT of the current 5G security context as described in clause A.21. The AMF increases the downlink 5G NAS COUNT by one.
3. The AMF shall assign the value of ngKSI to the eKSI (maps ngKSI to eKSI) and shall transfer the new KASME_SRVCC key and the UE security capability to the MME_SRVCC via Forward relocation request message.
4. The MME_SRVCC shall derive the CKSRVCC, IKSRVCC based on the new KASME_SRVCC key as in clause A.12 in TS 33.401 [10] using a downlink NAS COUNT of zero.
5. The MME_SRVCC assigns the value of eKSI to KSISRVCC (maps eKSI to KSISRVCC) and transfers CKSRVCC, IKSRVCC with KSISRVCC and the UE security capability to the MSC server in PS to CS HO request message.
6. The MSC server sends the PS to CS HO response message to the MME_SRVCC.
7. The MME_SRVCC sends the Forward relocation response message to the AMF.
8. The AMF sends the HO command to the gNB, in which the AMF shall include the 4 LSBs of the downlink NAS COUNT used to calculate KASME_SRVCC.
9. The gNB sends the HO command to the UE, in which the gNB shall include the 4 LSB of the downlink NAS COUNT received from the AMF.
10. When the UE receives the message, the UE shall derive the new KASME_SRVCC key as described in Annex A.21 using the KAMF key and the downlink 5G NAS COUNT estimated from the 4 LSB received form the AMF. The UE shall further derive CKSRVCC, IKSRVCC based on the new KASME_SRVCC key as described in the clause A.12 in TS 33.401 [10] using a downlink NAS COUNT of zero. The UE shall identify the CKSRVCC and IKSRVCC from eKSI (= ngKSI) as the MME_SRVCC does.
If the SRVCC handover is not completed successfully, the new mapped CKSRVCC, IKSRVCC and KSISRVCC cannot be used. In this case, the MSC server enhanced for SRVCC shall delete the newly mapped SRVCC security context for the UE, including CKSRVCC, IKSRVCC and KSISRVCC.
