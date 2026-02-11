# Y.5	Authentication and authorization between message Gateway and MSGin5G server

The authentication and authorization between Message Gateway and the MSGin5G Server can reuse the authentication and authorization between network functions in 13.3.2 in this document.
In direct communication, authentication between message gateway and MSGin5GServer shall use one of the following methods:
-	If the PLMN uses protection at the transport layer as described in clause 13.1, authentication provided by the transport layer protection solution shall be used for authentication between message gateway and MSGin5GServer.
-	If the PLMN does not use protection at the transport layer, authentication between message gateway and MSGin5GServer may be implicit by NDS/IP or physical security.
If the PLMN uses token-based authorization, the network shall use protection at the transport layer as described in clause 13.1.
In indirect communication scenarios, 13.3.2 in this document also applies.
