# C.1	Introduction

The present Annex specifies the protection schemes for concealing the subscription permanent identifier. Each protection scheme is identified  by a Protection Scheme Identifier. The Protection Scheme Identifiers are as follows:
null-scheme         0x0;
Profile <A>         0x1;
Profile <B>         0x2.
The values 0x3 - 0xB are reserved for future standardized protection schemes. The values 0xC - 0xF are reserved for proprietary protection schemes specified by the home operator.
Care should be taken when using unique schemes for small groups of users, as this may impact the effectiveness of the privacy scheme for these users.
The size of the Scheme Output of the protection schemes is as follows:
null-scheme         size of input, i.e., size of username used in case of NAI format or MSIN in case of IMSI;
Profile <A>         total of 256-bit public key, 64-bit MAC, plus size of input;
Profile <B>         total of 264-bit public key, 64-bit MAC, plus size of input.
The maximum size of a Scheme Output for proprietary protection schemes shall be total of 3000 octets plus size of input .
NOTE 1: The maximum size of scheme-output was chosen to allow the introduction of quantum-resistant protection schemes.
The UE shall not send, and the network may reject SUCIs larger than the maximum size of scheme-output.
