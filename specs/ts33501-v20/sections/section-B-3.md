# B.3	Key derivation

When EAP methods are used with 5G system, the serving network name is always bound to the anchor key derivation as required in clause 6.1.1.3.
When SEAF acts as a pass-through EAP authenticator, it always includes the serving network name (constructed as specified in clause 6.1.1.4) into the authentication request to the AUSFduring the initial authentication procedure as specified in clause 6.1.2. The AUSF verifies that the SEAF is authorized to use the serving network name, before it uses the serving network name to calculate the KSEAF from the KAUSF as described in Annex A.6. The AUSF always uses the most significant 256 bits of EMSK as the KAUSF.
When EAP-TLS as specified in RFC 5216 [38] and  RFC 9190 [76] is used for authentication, key materials are derived during authentication and key agreement procedure, which are further split into MSK and EMSK. Both UE and AUSF share a 512 bits EMSK key and use the most significant 256 bits of the EMSK as the KAUSF. The KSEAF is derived based on the rules specified in Annex A.6.

######### Annex C (normative):
Protection schemes for concealing the subscription permanent identifier

