# T.5	Security of N6 delay measurements

N6 delay measurement between UPF and endpoint at application side (i.e., EAS IP address(es)/Designated IP (range)) may be performed for L-PSA UPF (re)selection and EAS (re) discovery as specified in clause 6.2.3.2 of TS 23.548 [98]. The candidate UPF(s) may be configured by the SMF, as described in clause 5.8.2.23 of TS 23.501 [2] to measure the N6 delay. The UPF levarages IETF defined measurement protocols such as TWAMP (RFC 5357 [122]), OWAMP (RFC 4656 [123]) and STAMP (RFC 8762 [124]), or other protocols, to measure the N6 delay.
The N6 delay measurement mechanism should satisfy the following requirements to protect the interface between UPF and endpoint at application side.
- 	Measurement protocols should support authentication, integrity, and anti-replay protection.
- 	Delay measurement mechanism that requires sensitive information exchange but does not support confidentiality by the measurement protocols should not be used.
NOTE 1: The exchanged sensitive information is subject to operator’s local security policies.
- 	Measurement protocol should not be used without authentication, integrity and anti-replay protection in place.
- 	Measurement protocol with disclosed vulnerabilities which may be exploited for attack or blocked by the operators should not be used.
NOTE 2: The disclosed vulnerabilities are subject to operator’s local security policies.
NOTE 3: The enablement of the security mechanisms available in the selected measurement protocol, i.e., the configuration and provision of corresponding security protocol-specific configuration parameters, makes use of existing procedures to enable N6 delay measurement defined in TS 23.548 [98] and TS 23.502 [8].

######### Annex U (informative): 
Primary authentication using EAP-TTLS in SNPNs

