# T.3	Security of EAS discovery procedure via EASDF in non-roaming Scenario

DNS over TLS as specified in IETF RFC 7858 [83] and RFC 8310 [84] shall be supported by the UE and the EASDF. The DNS connection shall be authenticated and encrypted.
NOTE 1: Other DNS protection mechanisms are subject to implementation.
The security information of the EASDF can be preconfigured in the UE by using out of band mechanisms; or if the core network is used to configure the security information, the SMF either is preconfigured with the EASDF security information (authenticat ion information, supported security mechanisms, port number, etc.), or the SMF retrieves the EASDF security information from the EASDF, and provides the security information to the UE as follows:
The SMF provides the EASDF security information to the UE via PCO.
According to the clause 6.4.1.3 of TS 24.501 [35], upon receiving the DNS server security information, the UE passes it to the upper layer. The UE uses this information to send the DNS over TLS. Additionally, the clause 10.5.6.3 of TS 24.008 [112] provides the configuration of the different options of DNS over TLS specified in the RFC 7858 [83].
