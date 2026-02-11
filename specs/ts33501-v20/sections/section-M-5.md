# M.5	IAB inter-CU topology adaptation and backhaul RLF recovery procedure

In case of the inter-CU migration as specified in TS 38.401 [78], the IAB-MT is migrated from a source IAB-donor-CU to a target IAB-donor-CU. The migrating IAB-node becomes a boundary IAB-node since its IAB-DU retains F1AP with the source IAB-donor-CU after its IAB-MT obtains RRC connectivity with the target IAB-donor-CU (c.f. TS 38.401 [78]).
In case IPsec tunnel mode is used for F1 interface protection, the migrating/descendant/Recovery IAB-node may use MOBIKE (IETF RFC 4555 [111]) to migrate the IPsec tunnel to the new IP outer addresses as specified in TS 38.401 [78].
In IPsec transport mode for the non-dynamic PSK case, the establishment of the IPsec SAs follows the procedures in Annex M.3.3.2 of the present document. In IPsec transport mode for the dynamic PSK case, the establishment of the IPsec SAs may be performed by initiating new IKEv2 procedure using the stored KIAB associated with the old IP address as the PSK for the corresponding new IP address. The identical mapping between the old IP address with the new IP address between the IAB-node and the IAB-donor-CU is performed using the old IP address present in the IDi payload and the new IP address in the IP header of the IKEv2_AUTH request message or provided by the target/new IAB-donor-CU. In case of multiple IP addresses for IAB-node, the IKEv2 procedure is performed for each IP address. Once the IKEv2 authentication is successful, the KIAB is associated with the new IAB-node DU IP address in the IAB-donor.

######### Annex N (normative):
Security for URLLC services

