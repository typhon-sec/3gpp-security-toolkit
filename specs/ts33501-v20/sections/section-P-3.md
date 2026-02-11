# P.3	Security aspects of ICMP

ICMP (Internet Control Message Protocol) is part of the internet protocol (IP) suite. The lack of security in ICMP may be exploited to launch further attacks on the 3GPP system. To mitigate such attacks, it is recommended that the use of ICMP is restricted in the UE and the UPF (e.g., by default, use of ICMP is not allowed). In scenarios where the use of ICMP is required, it is recommended that one or more of following mitigations be enforced:
-	Disable the UE from responding to ICMP requests received over 3GPP network interface(s).
-	Install IP filter(s) at the UPF in order to block ICMP messages. This filter can be activated either on a per N4 Session basis or on a UPF basis. For ICMPv6, the recommendations in RFC 4890 [85] can be used for filtering ICMPv6 messages.
-	Limit the maximum size of ICMP messages (e.g., to 64 bytes). Any ICMP messages that are greater than this limit needs to be dropped by the UE as well as by the UPF.

######### Annex Q (normative):
Security and privacy in 5G system location services

