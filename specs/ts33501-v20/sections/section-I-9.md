# I.9	Security of UE onboarding in SNPNs


### I.9.1	General

Onboarding of UEs for SNPNs is specified in clause 5.30.2.10 of TS 23.501 [2].
Onboarding of UEs for SNPNs allows the UE to access an Onboarding Network (ONN) based on Default UE credentials for the purpose of provisioning the UE with SNPN credentials and any other necessary information. The Default UE credentials are pre-configured on the UE. Default UE credentials consist of credentials for primary authentication and optionally credentials for secondary authentication.
To provision SNPN credentials in a UE that is configured with Default UE credentials, the UE selects an SNPN as ONN and establishes a secure connection  with that SNPN referred to as Onboarding SNPN (ON-SNPN).
The present clause specifies security of UE onboarding.

### I.9.2	Authentication


#### I.9.2.1	Requirements

The primary authentication shall be performed before UE onboarding is allowed. For primary authentication, the UE shall use Default UE credentials for primary authentication. Credentials or means used to authenticate the UE based on Default UE credentials for primary authentication may be stored within the ON-SNPN or in a Default Credentials Server (DCS) that is external to the ON-SNPN.
The UE shall use Onboarding SUPI and Onboarding SUCI as specified in TS 24.501 [35] during Onboarding Registration.

#### I.9.2.2	Primary authentication without using DCS

When the primary authentication is performed between the UE and the ON-SNPN, any one of the existing authentication methods defined in the present document may be used, i.e., 5G AKA, EAP-AKA’ or any other key-generating EAP authentication method (e.g., EAP-TLS).
The choice of primary authentication method used is left to the decision of the ON-SNPN.
Credentials required to authenticate the UE using default UE credentials for primary authentication, are provisioned at the AUSF or AUSF/UDM of the ON-SNPN. The provisioning of this information is out of scope of this document.

#### I.9.2.3	Primary authentication using DCS

When the primary authentication is performed between the UE and the DCS, the authentication requirements and procedures defined in clause I.2 for Credential Holder shall apply with the DCS taking the role of the Credentials Holder. When the DCS uses AAA Server for primary authentication, AUSF directly selects the NSSAAF as specified in 23.501 [2]. In this case, the UDM is not involved in the procedure defined in clause I.2.2.2.2, and the step 3 to step 5 shall be skipped. When 5G AKA or EAP-AKA’ is used, the DCS shall act as a AUSF/UDM.
The choice of primary authentication method used between the UE and the DCS is left to the decision of the DCS.
When the primary authentication is performed between the UE and the DCS via the AUSF using EAP-TTLS, Annex U can be used.

#### I.9.2.4	Secondary authentication


##### I.9.2.4.1	Secondary authentication using DCS

After successful primary authentication as described in I.9.2.2 (i.e. primary authentication without using DCS), upon the establishment of the Onboarding PDU Session, the ON-SNPN may trigger secondary authentication procedure with the DCS using  Default UE credentials for secondary authentication, as described in clause 11.1.
NOTE:	If both primary and secondary authentication use a certificate-based authentication method like e.g. EAP-TLS, and if required by the use case, it is possible to configure the UE with the same client certificates for Default UE credentials for secondary authentication as for the Default UE credentials for primary authentication.

##### I.9.2.4.2	Secondary authentication using DN-AAA

After successful primary authentication as described in I.9.2.2 or I.9.2.3, upon the establishment of the Onboarding PDU Session, the ON-SNPN may trigger secondary authentication procedure with a DN-AAA server using Default UE credentials for secondary authentication, as described in clause 11.1.
