# J.2	Emergency call in SRVCC from NR to UTRAN


#### J.2.1	General

IMS Emergency Sessions can be authenticated or unauthenticated depending on the serving network policy (or regulatory requirements) if unauthenticated IMS Emergency Sessions are allowed. Any behaviour not explicitly specified as being special to IMS Emergency Sessions is handled in accordance to normal procedures.

#### J.2.2	Procedure

When the SVRCC is for an emergency session, the security procedure in clause J.1.2 is applied.
However, in the case when the SRVCC is for an unauthenticated emergency session, since the derived keys have no ability to affect the output of the NULL algorithms, call set up needs to continue even though the network and the UE derive different keys.

######### Annex K (normative):
Security for 5GLAN services

