# O.2	Baseline for using non-5G capable devices with 5GC

N5GC devices lack some key 5G capabilities, including NAS and the derivation of 5G key hierarchy. Those devices exist in wireline networks and need to be able to access the converged 5G core. The authentication of N5GC devices can be based on additional EAP methods other than EAP-AKA’. The procedure in O.3 uses EAP-TLS as in Annex B as an example, but it differs from the Annex B in the following:
a) the W-AGF creates the registration request on behalf of the N5GC device,
b) 5G related parameters (including ngKSI and ABBA) are not sent to the N5GC device. When received from the AMF, these parameters are ignored by the W-AGF, and
c) Neither the N5GC device nor the AUSF derives any 5G related keys after EAP authentication.
