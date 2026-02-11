# C.2	Null-scheme

The null-scheme shall be implemented such that it returns the same output as the input, which applies to both encryption and decryption.
When using the null-scheme, the SUCI does not conceal the SUPI and therefore the newly generated SUCIs do not need to be fresh.
NOTE 1:	The reason for mentioning the non-freshness is that, normally, in order to attain unlinkability (i.e., to make it infeasible for over-the-air attacker to link SUCIs together), it is necessary for newly generated SUCIs to be fresh. But, in case of the null-scheme, the SUCI does not conceal the SUPI. So unlinkability is irrelevant.
NOTE 2:	The null-scheme provides no privacy protection.
