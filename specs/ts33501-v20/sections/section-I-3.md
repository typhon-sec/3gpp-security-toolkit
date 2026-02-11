# I.3	Serving network name for standalone non-public networks


### I.3.1	General

The identification of standalone non-public networks uses Network Identifier (NID) in addition to PLMN ID. This means the definition of SN Id in clause 6.1.1.4.1 for the derivation of KSEAF for all authentication methods, CK' and IK' for EAP-AKA', and KAUSF and (X)RES* for 5G AKA needs modification for standalone non-public networks.

### I.3.2	Definition of SN Id for standalone non-public networks

For standalone non-public networks, the SN Id (used in the input for various key/parameter derivations) identifies the serving SNPN.
It is defined as follows:
SN Id = PLMN ID:NID
and is specified in detail in TS 24.501 [35].
