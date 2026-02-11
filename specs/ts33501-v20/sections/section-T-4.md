# T.4	Security of EAS discovery procedure via V-EASDF in roaming Scenario

DNS over TLS as specified in IETF RFC 7858 [83] and RFC 8310 [84] shall be supported by the UE and the V-EASDF. The DNS connection shall be authenticated and encrypted.
NOTE a: Other DNS protection mechanisms are subject to implementation.
The security information of the V-EASDF can be preconfigured in the UE by using out of band mechanisms; or if the core network is used to configure the security information, the V-SMF either is preconfigured with the V-EASDF security information (authentication information, supported security mechanisms, port number, etc.), or the V-SMF retrieves the V-EASDF security information from the V-EASDF, and provides the security information to the UE as follows:
-	In the case of LBO roaming, the V-SMF provides the V-EASDF security information to the UE via PCO.
-	In the case of HR with Session Breakout (HR-SBO) roaming scenarios, during the PDU session establishment or modification procedure, the V-SMF provides the V-EASDF security information via Nsmf_PDUSession_Create/ Nsmf_PDUSession_Update to H-SMF when the V-SMF determines to use a V-EASDF for EAS discovery, and the H-SMF provides the V-EASDF security information to UE via PCO if HR SBO is authorized.
NOTE: The security information of V-EASDF provided to the UE is only related with the VPLMN parameter.
According to the clause 6.4.1.3 of TS 24.501 [35], upon receiving the DNS server security information, the UE passes it to the upper layer. The UE uses this information to send the DNS over TLS. Additionally, the clause 10.5.6.3 of TS 24.008 [112] provides the configuration of the different options of DNS over TLS specified in the RFC 7858 [83].
