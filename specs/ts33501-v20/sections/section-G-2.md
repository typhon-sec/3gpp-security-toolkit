# G.2	Structure of HTTP Message

Following is a typical structure of the HTTP Message:
Figure G.2-1 Typical structure of the HTTP message received by SEPP
It consists of:
-	HTTP Message payload with JSON based IEs
-	HTTP Headers with or without sensitive elements
-	HTTP Request-URI with or without sensitive elements such as SUPI.
In the outgoing direction, i.e. towards the N32 interface, the SEPP shall parse the HTTP message fully and apply protection on each part as required.
In the incoming direction, i.e. towards the Network Function, the SEPP shall verify the message, and if successful reassemble the original message and send it to the destined Network Function.

######### Annex H (informative):
Void


######### Annex I (normative):
Non-public networks

