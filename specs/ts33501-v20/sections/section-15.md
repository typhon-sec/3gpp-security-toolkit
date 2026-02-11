# 15	Management security for network slices


### 15.1	General

The creation, modification, and termination of a Network Slice Instance (NSI) is part of the Management Services provided by the 5G management systems. A management service is accessed by management service consumers via standardized service interfaces given in 3GPP TS 28.533 [54]. The typical service consumers for the above NSI provisioning and NSI provisioning exposure are operators and vertical industry respecitively, as described in 3GPP TS 28.531 [55]. These management services are securely protected through mutual authentication and authorization below.

### 15.2	Mutual authentication

If a management service consumer resides outside the 3GPP operator’s trust domain, mutual authentication shall be performed between the management service consumer and the management service producer using TLS. TLS shall follow, the profile given in TS 33.210 [3], clause 6.2 and either 1) the client and server certificates with the profiles given in 3GPP TS 33.310 [5], clause 6.1.3a or 2) pre-shared keys following RFC 5489for TLS 1.2 and RFC 8446 [60] for TLS 1.3. The structure of the PKI used for the certificates is out of scope of the present document. The identities in the end entity certificates shall be used for authentication and policy checks. The key distribution of pre-shared keys for TLS is up to the operator’s security policy and out of scope of the present document.

### 15.3	Protection of management interactions between the management service consumer and the management service producer

TLS shall be used to provide mutual authentication, integrity protection, replay protection and confidentiality protection for the interface between the management service producer and the management service consumer residing outside the 3GPP operator’s trust domain. Security profiles for TLS implementation and usage shall follow the TLS profile given in clause 6.2 of TS 33.210 [3] and the certificate profile given in clause 6.1.3a of TS 33.310 [5]. The identities in the end entity certificates shall be used for authentication and policy checks.

### 15.4	Authorization of management service consumer’s request

After the mutual authentication, the management service producer determines whether the management service consumer is authorized to send requests to the management service producer. The management service producer shall authorize the requests from the management service consumer using the one of the following two options: 1) OAuth-based authorization mechanism following RFC 6749 [43]; 2) based on the local policy of the management service producer.
