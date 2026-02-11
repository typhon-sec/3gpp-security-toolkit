# I.10	Security for access to SNPN services via Non-3GPP access


### I.10.1	General

Access to SNPN services via Non-3GPP access is described in TS 23.501 [2], sub-clauses of clause 5.30.2. Security for non-3GPP access to the 5G core network of PLMN is described in clause 7 and Annex S of this specification. The present clause describes changes and additions that apply in the SNPN case.

### I.10.2	Security for access to SNPN services via Untrusted non-3GPP access


#### I.10.2.0	General

The decision to use a Credentials Holder using AAA is taken by the UDM. The selection criteria is described in step 4 of Annex I.2.2.2.2.

#### I.10.2.1	Untrusted non-3GPP access support in SNPN without CH

Procedures for untrusted non-3GPP access authentication are described in clause 7.2.1. For SNPN the procedures are modified as follows:
Steps 1-4 are performed as described in clause 7.2.1.
In step 5, the SUCI can be an onboarding SUCI.
Further in step 5, the SUCI can be of type anonymous SUCI if the construction of SUCI as described in clause 6.12 cannot be used and if the employed EAP method supports SUPI privacy.
Step 6 is performed as described in clause 7.2.1.
In step 7 of clause 7.2.1, in case the AUSF receives an onboarding indication, the AUSF shall perform steps 6-10 and 14-17 as described in Annex I.2.2.2.
In the selection of UE authentication method in step 7 of clause 7.2.1, 5G AKA, EAP-AKA’, or any other key-generating EAP authentication method apply. When the "username" part of the SUPI is "anonymous" or omitted, the UDM may select an authentication method based on the "realm" part of the SUPI or on the UDM local policy.
In case the AUSF received an anonymous SUCI in step 7 (but no onboarding indication was received) the AUSF shall perform steps 11-13 of Annex I.2.2.2 after a successful authentication to inform the UDM of the actual SUPI. In case anonymous SUCI and onboarding indication was received in step 7, steps 11-13 of Annex I.2.2.2 can be skipped.
In step 8 of clause 7.2.1 in case an EAP method is used for primary authentication, the AMF shall encapsulate the EAP-Success received from AUSF within the SMC message.
Steps 9-16 are performed as described in clause 7.2.1.

#### I.10.2.2	Untrusted non-3GPP access support in SNPN with CH

UE may use the credentials from a Credentials Holder AAA server to access SNPN services via Untrusted non-3GPP access.
Figure I.10.2.2-1: Procedure for Untrusted non-3GPP Access using Credentials Holder AAA Server
0  prior conditions and assumptions are described in step 0 in clause I.2.2.2.2.
1a-6b as specified in clause 7.2.1. In addition, if the construction of SUCI as described in clause 6.12 cannot be used and if the employed EAP method supports SUPI privacy, the UE may send an anonymous SUPI based on configuration.
7  authentication and key agreement procedure between the UE and the AAA server, as specified in steps 2-15 in clause I.2.2.2.2.
8-17  as specified in clause I.10.2.1 .

### I.10.3	Security for access to SNPN services via Trusted non-3GPP access


#### I.10.3.0	General

The decision to use a Credentials Holder using AAA is taken by the UDM. The selection criteria is described in step 4 of Annex I.2.2.2.2.

#### I.10.3.1	Trusted non-3GPP access support in SNPN without CH

Procedures for trusted non-3GPP access authentication are described in clause 7A.2.1. For SNPN the procedures are re-used with the following modifications:
Steps 0-4 are performed as described in clause 7A.2.1.
In step 5, the SUCI can be an onboarding SUCI.
Further in step 5, the SUCI carried in AN parameter and NAS-PDU can be of type anonymous SUCI if the construction of SUCI as described in clause 6.12 cannot be used and if the employed EAP method supports SUPI privacy. If anonymous SUCI is used, the UE shall include a 64-bit random number as part of the “username” in the anonymous SUCI which is used as UE identity element as a key identifier in the AN parameters. The random number generation should follow the recommendations given in SP 800-90A [110] or equivalent. If the UE provides a SUCI already stored in the TNGF, the UE will be rejected.
Step 6-7 is performed as described in clause 7A.2.1.
In step 8 of clause 7A.2.1, in case the AUSF receives an onboarding indication, the AUSF shall perform steps 6-10 and 14-17 as described in Annex I.2.2.2.
In the selection of UE authentication method in step 8 of clause 7A.2.1, 5G AKA, EAP-AKA’, or any other key-generating EAP authentication method apply. When the "username" part of the SUPI is "anonymous" or omitted, the UDM may select an authentication method based on the "realm" part of the SUPI or on the UDM local policy.
In case the AUSF received an anonymous SUCI in step 7 (but no onboarding indication was received) the AUSF shall perform steps 11-13 of Annex I.2.2.2 after a successful authentication to inform the UDM of the actual SUPI. In case anonymous SUCI and onboarding indication was received in step 7, steps 11-13 of Annex I.2.2.2 can be skipped.
Steps 9-19 are performed as described in clause 7A.2.1.

#### I.10.3.2	Trusted non-3GPP access support in SNPN with CH

UE may use the credentials from a Credentials Holder AAA server to access SNPN services via Trusted Non-3GPP access.
Figure I.10.3.2-1: Procedure for Trusted Non-3GPP Access using Credentials Holder AAA Server
0  prior conditions and assumptions are described in step 0 in clause I.2.2.2.2.
1-7a as specified in clause 7A.2.1. In addition, if the construction of SUCI as described in clause 6.12 cannot be used and if the employed EAP method supports SUPI privacy, the UE may send an anonymous SUPI based on configuration.
8  authentication and key agreement procedure between the UE and the AAA server, as specified in steps 2-15 in clause I.2.2.2.2.
9-19  as specified in clause I.10.3.1.

### I.10.4	Security for access to SNPN services for N5CW devices


#### I.10.4.0	General

The decision to use a Credentials Holder using AAA is taken by the UDM. The selection criteria is described in step 4 of Annex I.2.2.2.2.

#### I.10.4.1	Support for N5CW devices in SNPN without CH

Procedures for authentication for devices that do not support 5GC NAS over WLAN access are described in clause 7A.2.4. For SNPN the procedures are modified as follows:
Steps 0-1 are performed as described in clause 7A.2.4.
In step 2 of clause 7A.2.4 the SUCI can be of type anonymous SUCI if the construction of SUCI as described in clause 6.12 cannot be used and if the employed EAP method supports SUPI privacy.
Step 3-6 is performed as described in clause 7A.2.4.
In the selection of UE authentication method in step 7 of clause 7A.2.4, any key-generating EAP authentication method apply. When the "username" part of the SUPI is "anonymous" or omitted, the UDM may select an authentication method based on the "realm" part of the SUPI or on the UDM local policy.
In step 8 of clause 7A.2.4, in case the AUSF received an anonymous SUCI in step 7, the AUSF shall perform steps 11-13 of Annex I.2.2.2 after a successful authentication to inform the UDM of the actual SUPI.
Steps 9-14 are performed as described in clause 7A.2.4.

#### I.10.4.2	Support for N5CW devices in SNPN with CH

N5CW devices may use the credentials from a Credentials Holder AAA server to access SNPN services via trusted WLAN access.
Figure I.10.4.2-1: Procedure for trusted WLAN access using Credentials Holder AAA Server
0  prior conditions and assumptions are described in step 0 in clauses 7A.2.4 and I.2.2.2.2.
1-5 as specified in clause 7A.2.4. In addition, if the construction of SUCI as described in clause 6.12 cannot be used and if the employed EAP method supports SUPI privacy, the UE may send an anonymous SUCI based on configuration..
6-8  are replaced by the steps 3-15 in clause I.2.2.2.2.
9-14  as specified in clause 7A.2.4.

### I.10.5	Security for NSWO support in SNPN


#### I.10.5.1	NSWO support in SNPN using CH with AAA server


##### I.10.5.1.1	NSWO support in SNPN using CH with AAA server via AAA Proxies

The reference architecture to support authentication for Non-seamless WLAN offload using SNPN credentials from Credentials Holder using AAA Server is specified in Figure 4.2.15-3b of TS 23.501 [2].
This clause applies to UEs that support NSWO in SNPN with any key generating EAP method by using the SNPN credentials with CH AAA server (i.e., the MSK indication described in step 0 of clause I.2.2.2.2 is configured on the UE). The UE shall reuse 5G NSWO procedures defined in Annex S.3.2 with WLAN access network for NSWO authentication with the same key generating EAP method that is used by the SNPN over 3GPP access with the following exception:
-	 The EAP authentication is performed between the UE and the CH AAA with no involvement of NSWOF/AUSF/UDM.
-	The construction of SUCI described in this document is not applicable.
NOTE: The requirement to use the same key generating EAP method includes the EAP identity privacy mechanism used by the SNPN over 3GPP access. This implies that for NSWO support in SNPN using CH with AAA server the identity privacy is achieved at the EAP layer via EAP method specific means.

##### I.10.5.1.2	NSWO support in SNPN using CH with AAA server via 5GC

Figure I.10.5.1.2-1 - Procedure for NSWO authentication using CH with AAA server via 5GC
1-5. Same as steps 1-5 of clause S.3.2, except that SUCI is replaced with SUPI. If the EAP method supports privacy and the UE is configured to use anonymous SUPI, the UE sends an anonymous SUPI.
6. Same as steps 3 of clause I.2.2.2, except that SUCI is replaced with SUPI and NSWO_indicator is also sent to the UDM by the AUSF.
7-13. Same as steps 4-10 of clause I.2.2.2.2.
14-16. Same as steps 11-13 of clause I.2.2.2.2 except that the AUSF shall include the NSWO indicator in step 14. Based on the NSWO indicator received in step 14, the UDM shall not perform the linking increased home control to subsequent procedures (as stated in present document clause 6.1.4) since there is no subsequent procedures after NSWO procedure.
Remaining steps are performed as described in steps 16-18d of clause S.3.2.

#### I.10.5.2	NSWO support in SNPN without CH

5G NSWO procedures are defined in Annex S.3.2. For SNPN the procedures are extended to usage of any key-generating EAP-method as follows:
Steps 1-2 are performed as described in Annex S.3.2.
In step 3, the SUCI can be of type anonymous SUCI if the construction of SUCI as described in clause 6.12 cannot be used and if the employed EAP method supports SUPI privacy.
Steps 4-6 are performed as described in Annex S.3.2.
7. Upon reception of the Nudm_UEAuthentication_Get Request, the UDM invokes SIDF to de-conceal SUCI to gain SUPI if the received SUCI is not an anonymous SUCI. For selection of authentication methods, the statements in Annex I.2.2.1 apply. In case of SNPN, the UDM selects authentication method based on the NSWO indicator, subscription data and/or local configuration. The authentication method may include EAP-AKA’ or any other key-generating EAP authentication method. The UDM returns the selected authentication method to the AUSF.
8. Authentication is performed between the AUSF and UE using the selected EAP method. After a successful authentication the AUSF derives the MSK key and does not generate the KAUSF, as indicated by the NSWO indicator and as described for the PLMN case in Annex S.3.2.
Steps 9-11 are performed as described in steps 16-18 of Annex S.3.2.

#### I.10.5.3	NSWO support in SNPN using CH with AUSF/UDM

The architecture for 5G NSWO in SNPN using CH AUSF/UDM is defined in clause 4.2.15 of TS 23.501 [2].
The procedures are the same as those defined in Annex I.10.5.2.
