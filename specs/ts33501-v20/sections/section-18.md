# 18	Protection of XRM media related information


### 18.1	General

This clause describes how media related information is protected when transferred from an external Application Server to the UPF. For more information, see clause 5.37.9 of TS 23.501 [2].
The media related information is transferred together with the e2e encrypted data sent between AS and the UE. The media related information is encrypted and integrity protected between the AS and the UPF.
Clause 18.2 describes the procedures when connect-UDP is used, in both variants Tunnelling and Forwarded Modes.
Clause 18.3 describes the procedures when UDP options are used.

### 18.2	Protection of media related information when using connect-UDP


#### 18.2.1	Using Tunnelling mode

End-to-end encrypted XRM application data is sent between an Application Server (AS) and a UE.
For the purpose of enabling the transmission of the XRM Media related information, the UPF is configured to establish a connection with an HTTP/3 [128] AS proxy using connect-UDP according to IETF RFC 9298 [125]. The Media Related Information (MRI) is sent by the AS within HTTP datagrams which contain both the AS’s end-to-end UDP payload and the MRI and is secured by the security of the QUIC connection established between the UPF and the AS proxy, see Figure 18.2.1-1. The UPF removes and processes the MRI before forwarding the end-to-end UDP payload within an UDP/IP datagram to the UE.
Figure 18.2.1-1: Overview of the connect-UDP Tunnelling mode architecture for protection of XRM Media related information

#### 18.2.2	Security of the QUIC connection between UPF and AS proxy

The UPF acts as HTTP/3 client and establishes a QUIC connection the AS HTTP/3 proxy. IETF RFC 9001 [116] mandates the use of TLS to secure QUIC. The TLS 1.3 handshake and negotiated cipher suites shall adhere to the TLS 1.3 profile described in clause 6.2.2 of TS 33.210 [3].
The AF shall send the necessary parameters such as AS proxy connect address to the UPF (via NEF/PCF/SMF). The connect address is the URL for the HTTP/3 tunnel server.
The UPF shall match the host component of the URL against the identifier of the server certificate as described in RFC 9114 [128] and RFC 9525 [127]. The certificates shall adhere to the certificate profiles described in clause 6.1.3a of TS 33.310 [5].
NOTE: It is assumed that there is a business relationship between the application provider and the operator, based on which the authentication aspects of the TLS connection (e.g., certificate management) are managed, thus mutual authentication is supported according to the security considerations provided in IETF RFC 9298 [125] and to deployment specific service level agreements.

#### 18.2.3	Using Forwarded mode

When the end-to-end traffic is using QUIC, the Forward Mode in draft-ietf-masque-quic-proxy [126] can be used as an optimisation. In forward mode, end-to-end QUIC packets can be sent in parallel to the tunnel, which has the benefit of not having to encrypt the e2e encrypted data twice, see Figure 18.2.3-1. In case this option is used, forwarded packets are transformed with a packet transform mechanism that is negotiated in the CONNECT request. For XRM data, a packet transform is used where the media related information is protected and appended to the packet. The AS shall append and encrypt the media related information according to the negotiated transform, the UPF shall decrypt and consumes the media related information and removes it before forwarding the end-to-end packet towards the UE.
The QUIC aware Forwarded mode [126] negotiates a packet transform that modifies the packet in addition to the minimal necessary to make the forwarding work. In the QUIC-aware Forwarded mode the AS proxy replaces the Connection ID (CID) field with the virtual CID (VCID) field and rewrites the IP/UDP header so that the packet arrives at the tunnel endpoint (UPF). More details on how the vCID is created is provided in clause 18.2.7.
NOTE 1: 	The transform has a dedicated encryption mode. Cipher algorithm agility is handled by defining a new packet transform name indicating a different cipher algorithm.
The defined packet transform below is named 3GPP_MRI_AESCCM_8 in the extended connect HTTP request negotiating the Forward Mode.
The packet transform needs to add the following data:
Media related information (MRI) Length field: The length of the protected Media related information (including integrity tag).
Nonce Counter field: Contains the 16-bit least significant bits of a 64-bit counter used to construct the nonce to the AEAD protection. The 64-bit counter is incremented with one for each payload protected by the transform for the current VCID. The 64-bit counter is initialized to zero (0) for each VCID. For more information about the counter, see clause 18.2.6.
Protected Media related information field: The N bytes of AEAD output after protection operation using the below defined AEAD algorithm.
If there is no Media related information, the transform shall set the length field to zero (0), and no other additional fields (Nonce Counter field or Protected Media related information field) are inserted into those packets.
Figure 18.2.3-1: Overview of the connect-UDP Forward mode architecture for protection of XRM Media related information

#### 18.2.4	Security parameters to be used in the Forwarded mode

When the Forwarded mode is used, Media related information (MRI) is encrypted and integrity protected using a separate security context from that being used in the QUIC tunnel between AS and UPF.
Media related information shall be encrypted and integrity protected using AES with 128-bit keys in CCM mode. The integrity tag shall be truncated to 64 bits.
NOTE 1: The choice of CCM mode is made to enable a short tag of 64 bits. As comparison, GCM allows a tag of 96 bits.
Unique keys shall be used per direction. In the present document data is only transmitted in one direction is used. The encryption key is derived as described in clause 18.2.5. Nonce is created as described in clause 18.2.6.

#### 18.2.5	Key derivation in the Forwarded mode

The keys shall be extracted from the QUIC connection between UPF and AS proxy using the TLS 1.3 key exporter defined in RFC 8446 [77].
The following input shall be used for the TLS 1.3 key exporter:
Label: 'EXPORTER_3GPP_MRI_AESCCM_8'
Context_value: The VCID value || The forty (40) most significant bits of the counter
Key_length: 16 bytes
To ensure that the key invocation limit for the XRM meta data protection is not reached, a new key shall be exported every 2^24 invocations. This is well within the current recommended limit of 2^61 blocks [129].

#### 18.2.6	Nonce and counter values in the Forwarded mode

For each invocation of AES, a 96 bit nonce shall be created by concatenating the  least significant 32 bits of the VCID (VCID’) with the 64-bit counter C: VCID’||C.
To maintain synchronization even for large burst losses of XRM transformed packets, the full 64-bit counter is sent every time the 16-bit Least Significant Bit counter wraps. The counter is sent reliably on the corresponding HTTP/3 QUIC stream.
The receiver of the transformed packet, i.e. the UPF for AS to UE traffic, shall perform replay protection to ensure that each 64-bit counter is only accepted once. In case the receiver detects reuse of the counter, the e2e packet shall be discarded (i.e. not forwarded).

#### 18.2.7	VCID uniqueness in the forwarding mode

The VCID value shall never be reused for a particular HTTP/3 sessions’ QUIC connection.

### 18.3	Protection of Media related information when using UDP Options

The transport of the MRI in UDP Options is specified in TS 23.501 [2]. A Connect-UDP tunnel between the UPF and AS proxy transports DL UDP media packets encrypted end-to-end between AS proxy and UE. The inner UDP datagram between AS proxy and UPF contains the DL UDP media payloads and the outer UDP datagram between AS proxy and UPF contains an UDP-Option carrying encrypted MRI.
NOTE:	In order to protect the MRI in the UDP Option, the TLS functionality of the QUIC layer is reused. The encryption and decryption is performed with the same selected cipher suite, including the same security keys, applied to the QUIC connection application data of the Connect-UDP tunnel. The MRI ciphertext content is transported in the UDP Option alongside the UDP datagram encapsulating the associated Connect-UDP packet as shown in Figure W-1 in TS 23.501 [2]. Further details are implementation specific.

######### Annex A (normative): 
Key derivation functions

