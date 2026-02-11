# E.2	Examples of using measurement reports

The received-signal strength and location information in measurement reports can be used to detect a false base station which attract the UEs by transmitting signal with higher power. They can also be used to detect a false base station which replays the genuine MIB/SIB without modification.
In order to detect a false base station which replays modified version of broadcast information to prevent victim UEs from switching back and forth between itself and genuine base stations (e.g. modifying neighbouring cells, cell reselection criteria, registration timers, etc. to avoid the so called ping-pong effect), information on broadcast information can be used to detect inconsistency from the deployment information.
Further, a false base station which uses inconsistent cell identifier or operates in inconsistent frequency than the deployment of the genuine base stations, can be detected respectively by using the cell identifier or the frequency information in the measurement reports.
Measurement reports collected from multiple UEs can be used to filter out incorrect reports sent by a potential rogue UE.
Upon detection of the false base station, the operator can take further actions, e.g. informing legal authorities or contacting the victim UE.

######### Annex F (normative):
3GPP 5G profile for EAP-AKA'

