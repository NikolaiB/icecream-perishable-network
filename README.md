# Ice Cream Perishable Network

The business network defines a contract between manufacturer and retailer. The contract stipulates 
that: On receipt of the shipment the retailer pays the manufacturer the unit price x the number of 
units in the shipment. Shipments that arrive late are free. Shipments that have breached the low 
temperate threshold have a penalty applied proportional to the magnitude of the breach x a penalty 
factor. Shipments that have breached the high temperate threshold have a penalty applied proportional 
to the magnitude of the breach x a penalty factor.

This business network defines:

**Participants**
`Manufacturer` `Retailer` `Shipper`

**Assets**
`Contract` `Shipment`

**Transactions**
`TemperatureReading` `GpsReading` `ShipmentReceived` `SetupDemo`