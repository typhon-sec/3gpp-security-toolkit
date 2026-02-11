# Z.2	Authentication of AUN3 devices by 5GC

Figure Z.2-1 Authentication Procedure for AUN3 devices by 5GC using key-generating EAP method
This authentication procedure is based on clause 7B.7.3 but differs in some steps.
Steps 1-6 are the same as steps 1-6 in clause 7B.7.3.
7.  Upon reception of the Nudm_UEAuthentication_Get Request, the UDM shall invoke the SIDF to map the SUCI to the SUPI and select an authentication method based on the SUPI and the AUN3 device indicator. When the "username" part of the SUPI is "anonymous" or omitted, the UDM may select an authentication method based on the “realm” part of the SUPI, the AUN3 device indicator, a combination of the "realm" part and the AUN3 device indicator, or the UDM local policy. When EAP-AKA´ authentication method is selected, the UDM/ARPF shall generate an authentication vector using the Access Network Identity as the KDF input parameter.
8. The UDM shall send to the AUSF a Nudm_UEAuthentication_Get Response message, including the SUPI and EAP-AKA’ authentication vector if EAP-AKA’ is selected or the selected authentication method if other key generating EAP method (e.g., EAP-TLS, EAP-TTLS, etc) is selected. According to the AUN3 subscription data, the UDM shall also send the MSK indicator to AUSF.
9. The AUN3 device and the AUSF perform the selected EAP authentication method.
Steps 10-15 are the same as steps 17-22 in clause 7B.7.3.
