# AA.2	Server authentication for MPQUIC in ATSSS

When multipath QUIC (MPQUIC) [115, 116, 117] steering functionality is used for ATSSS, RFC 9001 [x2] mandates the use of TLS to secure QUIC.
NOTE: TLS server authentication based on X.509 certificates can be selected for authentication of the MPQUIC Proxy in the UPF, which is to be performed by the MPQUIC Client in the UE. Self-signed end entity certificates and hard-coded pre-shared keys need to be avoided. Establishing the trust anchor in the UE is left to deployment. If no trust anchor is provisioned in the UE, the entire certificate chain including the root CA certificate needs to be provided to the UE by the UPF during TLS handshake, and the root CA certificate is implicitly trusted.

######### Annex AB (Informative):
Security for PLMN hosting a NPN through SBA interface

