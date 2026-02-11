# V.4	User consent revocation

Any NF that is deemed an enforcement point for user consent shall support subscription to the user consent parameter change notification provided by the UDM.
Consumer NFs (processing the data pertaining to user consent) shall subscribe to UDM for user consent parameter change notification, except if the consent enforcement NF that is deemed an enforcement point is tracking of those NFs and is actively informing those consumer NFs in case of user consent revocation.
NOTE: 	When authorization consumer NFs for data processing subject to user consent, care needs to be taken to not authorize requests by those consumers that do not support the necessary services or related parameters for revocation. This is important because the user consent may change in the future.
Upon notification of user consent revocation, any NF that is deemed an enforcement point for user consent shall no longer accept any service request for data processing subject to a revoked user consent.
Upon notification of user consent revocation, any NF that is deemed an enforcement point for user consent may notify other NFs to halt the processing of the data subject to the revoked user consent.
Upon notification of user consent revocation, NFs (processing the data pertaining to the revoked consent) shall halt processing and collection of the data.
Upon notification of user consent revocation, NFs may delete, quarantine, or temporarily retain the data pertaining to the revoked user consent based on local policies and legal constraints.

######### Annex W (normative): 
Security for multicast/broadcast service for 3GPP service

