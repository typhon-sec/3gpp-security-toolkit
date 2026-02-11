# X.11	Security for UE positioning based on a ML model at the LMF


### X.11.1	General

This clause outlines the security considerations for UE positioning based on a ML model at the LMF. According to TS 23.273 [86], UE positioning based on a ML model at the LMF procedures include data collection procedure and AIML model for positioning retrieval procedure.
Clause X.11.2 outlines the general requirements related to those data collection procedures.
Clause X.11.3 outlines the authorization aspects of LMF retrieval of a trained AI/ML model for positioning.

### X.11.2	Security for data collection for the LMF-based AI/ML positioning

User consent for model training as per 6.1.6.3.20 of 29.503 [93] and performance monitoring for LMF-based AI/ML positioning as specified in clause 6.22 of TS 23.273 [86] is required based on regional regulations or operator’s local policy, for which Annex V of the present document applies. For UE location determination utilizing the trained model, LCS privacy profile is sufficient, and Annex V of the present document is not required. The LMF is deemed as enforcement point as specified in clause 6.22.3 of TS 23.273 [86].

### X.11.3	Authorization of LMF retrieval of a trained AI/ML model for positioning

For authorization of LMF retrieval of AI/ML model for positioning, the security for AI/ML model storage and sharing as described in clause X.10 shall apply.
The NWDAF containing MTLF shall register ML model interoperability ID per LMF-based AI/ML Positioning indication (supporting model training for LMF-based AI/ML Positioning) if supported.
The LMF shall register at the NRF including its Vendor ID.
NOTE: How to implement the indication of supporting model training for LMF-based AI/ML positioning in a backward-compatible and extensible manner is up to stage 3.
