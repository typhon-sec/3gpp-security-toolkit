# U.1	Introduction

In SNPN, when a credential holder is located outside of the 5GC of the SNPN, EAP-TTLS can be used to authenticate the UE.  EAP-TTLS consists of two phases of authentication. In the first phase, a TLS tunnel is established between the UE and the EAP-TTLS server on AUSF. In the second phase, a legacy authentication protocol can be run between the UE and the credential holder (namely AAA) through the established TLS tunnel.
After the successful completion of EAP-TTLS, the AUSF and the UE derive the KAUSF from the EMSK.
UE is provisioned with a trust anchor to enable verification of the EAP-TTLS server certificate. The provisioning of trust anchor on the UE is outside the scope of this document.
