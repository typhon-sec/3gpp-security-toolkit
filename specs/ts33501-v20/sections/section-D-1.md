# D.1	Null ciphering and integrity protection algorithms

The NEA0 algorithm shall be implemented such that it generates a KEYSTREAM of all zeroes (see sub-clause D.2.1). The length of the KEYSTREAM generated shall be equal to the LENGTH input parameter. The generated KEYSTREAM requires no other input parameters but the LENGTH. Apart from this, all processing performed in association with ciphering shall be exactly the same as with any of the ciphering algorithms specified in this Annex.
The NIA0 algorithm shall be implemented in such way that it shall generate a 32 bit MAC-I/NAS-MAC and XMAC-I/XNAS-MAC of all zeroes (see sub-clause D.3.1). Replay protection shall not be activated when NIA0 is activated. All processing performed in association with integrity (except for replay protection) shall be exactly the same as with any of the integrity algorithms specified in this annex except that the receiver does not check the received MAC.
NOTE 1: 	The reason for mentioning the replay protection here is that replay protection is associated with integrity.
The NIA0 shall not be used for signalling radio bearers (SRBs) except for unauthenticated emergency sessions for unauthenticated UEs in LSM.
The NIA0 shall not be used for data radio bearers (DRBs).
NOTE 2: 	A UE with a 2G SIM is considered to be in LSM in NR.
NOTE 3: 	NEA0 and NIA0 provide no security.
