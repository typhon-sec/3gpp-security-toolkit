# AB.3	Proxy entity at the border

It is recommended to deploy one or more proxy entities at the border between PLMN and PNI-NPN operational domains. The security capabilities of these proxy entities are listed below.
a)	Transport layer protection solution (as defined in clause 13.3) is supported for mutual authentication between the proxy entities and between each proxy entity and the NFs they serve.
b)	SBA authorization framework (as defined in clause 13.4) is reused for authorization between NFs in the PLMN and PNI-NPN operational domains.
c)	Topology hiding to IP level (e.g., IP address or FQDN) and application level (e.g., target NFs in the discovery response, Callback URI in the payload of the messages) is supported.
d)	Message inspection and filtering, malformed message handling are supported.
NOTE: Specific method for above security capabilities c) and d) is left to implementation.
Besides the security capabilities listed above, the part of the routing functionalities listed below also needs to be supported:
a)	Indirect Communication (see TS 23.501[2] clause 7.1.1 for details).
b)	Delegated Discovery (see TS 23.501[2] clauses 7.1.1 and 6.3.1 for details).
c)	Message forwarding and routing to destination NF/NF service.
d)	Message forwarding and routing to a next hop. (Required for bi-directional protection).
