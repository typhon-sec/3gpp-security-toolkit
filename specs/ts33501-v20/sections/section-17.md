# 17	Protection of 5GC Signalling Traffic Monitoring


### 17.1	General

The protection of the Signalling Monitoring functionality aims to provide the security mechanisms on the interfaces between the 5GC trust zones and the trust zone where the Management/Monitoring Systems reside. The architecture of the Signalling Monitoring for configuration, authorisation controls, enablement and disablement requests as well as for the transfer of the signalling monitoring data can be found in clause 5 of TS 28.560 [121].
Figure 17.1-1 provides an example of trust zones in the overall architecture of Signalling Traffic Monitoring.
Figure 17.1-1 Signalling Traffic Monitor trust zones example
NOTE: The final definition of the trust zones is to be established by the PLMN-operator.

### 17.2	Protection for the configuration and enabling/disabling of signalling monitoring

TLS shall be supported and shall be used to provide mutual authentication, integrity protection, replay protection and confidentiality protection for the interface between the STM Management Producer and the STM Management Consumer handling the configuration and the enabling/disabling requests.
NOTE 1: If interface between the STM Management Producer and the STM Management Consumer is trusted (e.g. physically protected), it is for the PLMN-operator to decide whether to apply integrity protection, replay protection and confidentiality protection for communication.
Security profiles for TLS implementation and usage shall follow the TLS profile given in clause 6.2 of TS 33.210 [3] and the certificate profile given in clause 6.1.3a of TS 33.310 [5]. The identities in the end entity certificates shall be used for authentication and policy checks.
NOTE 2: A PLMN-operator policy may determine to use dedicated certificates for this secure communication, separated from those used in SBI interfaces.

### 17.3	Protection for the streaming of signalling monitoring data

The protection mechanism to provide mutual authentication, integrity protection, replay protection and confidentiality protection is to be implemented at transport layer.
NOTE 1: If interface between the STM Data Producer and the STM Data Consumer is trusted (e.g. physically protected), it is for the PLMN-operator to decide whether to apply integrity protection, replay protection and confidentiality protection for communication.
When UDP is used as transport protocol for the streaming of monitoring data, DTLS shall be supported and shall be used to provide mutual authentication, integrity protection, replay protection and confidentiality protection between the STM Data Producer at the 5GC and at the STM Data Consumer.
When TCP is used as transport protocol for the streaming of signalling monitoring data, TLS shall be supported and shall be used to provide mutual authentication, integrity protection, replay protection and confidentiality protection between the STM Data Producer at the 5GC and at the STM Data Consumer.
Security profiles for DTLS and TLS implementations and usage shall follow the TLS profile given in clause 6.2 of TS 33.210 [3] and the certificate profile given in clause 6.1.3a of TS 33.310 [5]. The identities in the end entity certificates shall be used for authentication and policy checks.
NOTE 2: A PLMN-operator policy may determine to use dedicated certificates for this secure communication, separated from those used in SBI interfaces.
