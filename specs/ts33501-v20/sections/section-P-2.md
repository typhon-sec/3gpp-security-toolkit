# P.2	Security aspects of DNS

It is recommended that the UE and DNS server(s) support DNS over (D)TLS as specified in RFC 7858 [83] and RFC 8310 [84]. The DNS server(s) that are deployed within the 3GPP network can enforce the use of DNS over (D)TLS. The UE can be pre-configured with the DNS server security information (out-of-band configurations specified in the IETF RFCs like, credentials to authenticate the DNS server, supported security mechanisms, port number, etc.), or the core network can configure the DNS server security information to the UE.
NOTE:	The use of DNS over (D)TLS with DNS server(s) that are deployed outside the 3GPP network is outside the scope of this document.
When DNS over (D)TLS is used, a TLS cipher suite that supports integrity protection needs to be negotiated.
