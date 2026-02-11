# N.2	Security support on redundant transmission


### N.2.1	Redundant user plane paths based on dual connectivity


#### N.2.1.1	Introduction

In order to support URLLC services, a UE sets up two redundant PDU sessions over the 5G network, such that the 5GS sets up the user plane paths of the two redundant PDU Sessions to be disjoint as described in clause 5.33 in TS 23.501 [2]. However, NG-RAN may realize redundant user plane resources for the two PDU sessions with a single NG-RAN node, or by Dual Connectivity with two NG-RAN nodes, i.e. one PDU session spans from the UE via the MN to a first UPF and the second PDU session spans from the same UE via the SN to a second UPF. Based on the two PDU sessions, the redundant data sent between the UE and the DN takes different paths in the 3GPP network.
The security aspects for redundant PDU sessions transmission by Dual Connectivity are based on the security procedures and description described in clause 6.10 of the present specification. This clause only describes the additional security features.

#### N.2.2.2	Security policy aspects

When dual connectivity is used for redundant transmission, both of the two PDU sessions are initially established via the MN. The SMF(s) shall provide a UP security policy for each of the two PDU sessions to the MN during the PDU session establishment procedure as described in clause 6.6.1. The UP security policy from the SMF(s) for the two PDU sessions used for redundant data transmission shall have the same setting for encryption and for integrity protection. The network (UDM and/or SMF) shall ensure that all the redundant PDU sessions based on the information sent by the UE as described in TS 23.501 [2] shall have same UP security policy setting.
The MN shall be preconfigured or shall have access to the supported security capabilities in the available SN(s), (i.e. to whether UP integrity protection is supported in the SN or not). The MN shall take the received UP security policy into account when selecting the SN.
MN shall ensure that the first and the redundant PDU sessions shall have the same UP security activation status. If the "Preferred" option of the UP security policy is not allowed to be used for URLLC service at the SMF or UDM, which means the SMF or UDM can guaranteethe UP security policy for the first and the redundant PDU sessions are the same and only contains "Not needed", or "Required", then the MN shall forward the UP security policy to the SN as described in clause 6.10.
If the "Preferred" option of the UP security policy is allowed to be used for URLLC services, the following enhancements for the mechanism as described in clause 6.10 for Dual Connectivity shall be applied：
-	The MN shall make the decision on UP encryption protection and integrity protection according to the UP security policy for these two redundant data transmissions. The MN shall store the applied UP security activation status used for the DRB’s established for the first PDU session between the MN and the UE. Then, the MN shall provide the UP security activation status applied for the first PDU session to the SN, when offloading the DRB’s for the second PDU session to the SN.
-	The SN shall use the UP security activation status received from the MN to activate the UP security for the DRB’s established for the redundant PDU session between the SN and the UE.

### N.2.2	Redundant transmission on N3/N9 interfaces

If the user data redundancy is fulfilled by means of two duplicated N3 tunnels, the redundant packets will be transferred between UPF and RAN via two independent N3 tunnels, which are associated with a single PDU Session, over different transport layer path to enhance the reliability of service.
Figure N.2.2-1: Redundant transmission with two N3 tunnels between the UPF and a single NG-RAN node
In order to protect the redundant traffic on the N3 reference point, the current mechanism defined in clause 9.3 of the present document shall be reused. The added path for redundancy shall provide equal level of security compared to single path.
In case two N9 tunnels are involved to fulfil the redundancy for one NG-RAN, the security mechanism defined in clause 9.9 shall be used for protecting the redundant data transferring via two N9 tunnels as described above.

######### Annex O (Informative):
Authentication for non-5G capable devices behind residential gateways

