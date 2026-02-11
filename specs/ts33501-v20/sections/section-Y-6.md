# Y.6	Authentication and authorization in bulk registration scenarios

For MSGin5G UEs in bulk, the MSGin5G Gateway UE shall perform authentication and authorization on behalf of the MSGin5G UEs behind the MSGin5G Gateway UE with MSGin5G Server based on AKMA as specified above in clause Y.2.
The authentication and authorization between the MSGin5G UEs behind the MSGin5G Gateway UE and the MSGin5G Gateway UE shall be based on the security procedures of the Unicast mode 5G ProSe Direct Communication specified in TS 33.503 [109].
For Non-MSGin5G UEs bulk registration/de-registration, the Message Gateway performs the authentication and authorization on behalf of the Non-MSGin5G UE, The authentication and authorization between Message Gateway and the MSGin5G Server as specified above in clause Y.5 also applies. In some scenarios, if the Message Gateway is trusted by the MSGin5G Server, then the non-MSGin5G UEs are trusted by the MSGin5G Server after the authentication and authorization between the non-MSGin5G UE and the Message Gateway, without the need of authentication between the Message Gateway and the MSGin5G Server.

######### Annex Z (normative): 
Authentication of AUN3 devices using additional EAP methods

