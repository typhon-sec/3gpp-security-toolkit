# G.1	Introduction

The SEPP as described in clause 4.2.1 is the entity that sits at the perimeter of the network and performs application layer security on the HTTP message before it is sent externally over the roaming and interconnect interface.
The application layer traffic comprises all the IEs in the HTTP message payload, sensitive information in HTTP message header and Request URI. Not all the IEs get the same security treatment in SEPP. Some IEs require e2e encryption, some only require e2e integrity protection, while other IEs may require e2e integrity protection but modifiable by Roaming Intermediary while in-transit.
NOTE: In the following, the descriptions are provided for IPXs as one example of Roaming Intermediary, but equally apply to Roaming Hubs as Roaming Intermediaries.
Figure G.1-1: Signaling message from AMF (vPLMN) to AUSF (hPLMN) traversing the respective SEPPs
In the above figure, an example is shown where the AMF NF in the visited PLM network (vPLMN) invokes an API request on the AUSF NF in the home PLM network (hPLMN) using the following message flow:
-	The AMF NF first sends the HTTP Request message to its local SEPP (i.e. vSEPP).
-	The vSEPP applies application layer security (PRINS) and sends the secure message on the N32 interface to AUSF NF of the hPLMN.
-	The hSEPP at the edge of the hPLMN, receives all incoming HTTP messages from its roaming partners. It verifies the message, removes the protection mechanism applied at the application layer, and forwards the resulting HTTP message to the corresponding AUSF NF.
To allow for the Roaming Intermediary to see what the two PLMNs have negotiated by policy to be visible, and possibly to modify specific IEs in the HTTP message, while completely protecting all sensitive information end to end between SEPPs, the SEPP implements application layer security in such a way that:
-	Sensitive information such as authentication vectors are fully e2e confidentiality protected between two SEPPs. This ensures that no Roaming Intermediary in the RI network shall be able to view such information while in-transit.
-	IEs that are subject to modification by Roaming Intermediaries are integrity protected and can only be modified in a verifiable way by authorized Roaming Intermediaries.
-	Receiving SEPP can detect modification by unauthorized Roaming Intermediaries.
