# M.3	IAB-node Integration Procedure


### M.3.1	General

IAB-node, consists of a UE function (referred to as IAB-UE) and gNB-DU function [2]. IAB integration procedure consists of 3 phases detailed in TS 38.401 [78].
Phase-1: IAB-UE part setup:
The IAB-UE performs registration procedure to the network as a UE as described in TS 23.501 [2] and TS 23.502 [8] in order to register to the 5GC and consequently, the NAS and AS security are established between the IAB-node and 5GC.
Phase-2: BH RLC channel establishment and routing update:
The BH RLC channels and the BAP layer are established and configured in the IAB-node by the IAB-donor using the secured RRC signalling to support routing between the IAB-node and the IAB-donor.
Phase-3: gNB -DU part setup:
F1 security establishment for IAB is performed over the RLC channel.
The Phase-1 results in IAB-UE registration and consequently, AS security establishment between the IAB donor and IAB-node, Phase-2 results in configuration of the IAB-node securely using the established AS security and Phase-3 results in the establishment of secure F1 interface between the IAB-donor and IAB-node.

### M.3.2	Authentication and Authorization of IAB-node (Phase-1)

The IAB-UE function shall behave as a UE, and shall reuse the UE procedures specified in this document for the primary authentication (see clause 6), key derivation and distribution scheme, subscription credential(s) storage requirements, NAS security and AS security.
NOTE 1: For isolated deployment scenarios, Annex B describes how additional EAP methods can be used.
NOTE 2: Storage of subscription credentials for EAP AKA’ and 5G AKA is described in clause 6 of the present document.
Authorization of IAB-nodes shall be performed by the 5G core network supporting IAB architecture as described in TS 23.501 [2].

### M.3.3	Security mechanisms for F1 interface between the IAB-node (gNB-DU) and the IAB-donor-CU (Phase-3)


#### M.3.3.1	General

The following clause applies to F1 interface between the IAB-node (gNB-DU) and the IAB-donor-CU.

#### M.3.3.2	Security mechanisms for the F1 interface

The F1 interface connects the IAB-node (gNB-DU) to the IAB-donor-CU. It consists of the F1-C for control plane and the F1-U for the user plane.
F1 security for IAB is established using the security mechanisms for the F1 interface as specified in clause 9.8.2 of the present document, with IAB node taking the role of gNB-DU and IAB-donor-CU taking the role of gNB-CU.
In addition to the security mechanisms specified in clause 9.8.2 of the present document for the F1 interface, the IKEv2 Pre-shared Secret Key (PSK) authentication shall be supported. When IKEv2 performs a PSK authentication, in the IKE_AUTH request message, the IAB node shall set the ID type to ID_KEY-ID and set its value to PSK ID.
NOTE 1:	The PSK and PSK ID (for IKEv2 PSK authentication) can be preconfigured at the IAB node and IAB donor. Pre-configuration of the PSK(s) is out of the scope of the present document.
Additionally, to support a flexible plug and play of IAB-node and IAB-donor without a pre-configuration of the PSK(s), dynamic PSK computation for IKEv2 PSK authentication may also be supported. When dynamic PSK is used, the IAB-node and the IAB-donor shall calculate the PSK (KIAB) as specified in the Annex A.23 of this document. The IAB-donor shall uniquely identify the IAB-node’s security context (KgNB) using the IAB-node DU IP address. The IAB-donor shall use KIAB as PSK for IKEv2 between IAB-node and the IAB-donor. KIAB is stored in the IAB-node and in the IAB-donor. This key KIAB and the IPsec SA cryptographic keys are taken into use with the establishment of IPsec Security Association (SA) between the IAB-node and the IAB-donor. KIAB remains valid as long as the IAB-node is connected to the IAB-donor or until the IAB-node is re-authenticated. The KIAB is associated with the IAB-node DU IP address in the IAB-donor. In the IKE_AUTH request message, the IAB node shall set the ID type to ID_IPV4_ADDR/ID_IPV6_ADDR and set its value to the IAB-node DU IP address in the Idi payload. In case of CP-UP separation of IAB-donor-CU (IAB-donor-CU contains IAB-donor-CU-CP and IAB-donor-CU-UP that use different IP address) then, IAB-donor-CU-CP and IAB-node DU shall generate KIAB-CU-CP and KIAB-CU-UP as specified in the Annex A.23 of this document. The key KIAB-CU-CP shall be used for establishment of secure F1 interface between the IAB-node DU and IAB-donor-CU-CP. The IAB-donor-CU-CP shall provide KIAB-CU-UP to the IAB-donor-CU-UP via E1 interface and KIAB-CU-UP shall be used for establishment of secure F1 interface between the IAB-node DU and IAB-donor-CU-UP.
NOTE 2:	KIAB is used as the PSK for IKEv2 authentication, the interface between the IAB-donor-CU and the SEG to provision the key KIAB in the SEG is implementation specific and out of the scope of the present document.
