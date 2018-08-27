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

**Run the Ice Cream Perishable Network**

Navigate to the directory where the `icecream-perishable-network` code lives

Use nvm to install Node.js

`nvm install --lts`

Install Composer command-line interface (CLI)

`npm install -g composer-cli`

**Now the test project installed and it's time to build and test it.**

Use the Node.js package manager (npm) to run a build, and then execute the unit tests I have provided. Execute these commands:

`npm install && npm test`

The first thing you see here are Mocha tests, indicating the tests were successful.

**You can read the full description here:**
https://medium.com/quality-is-everything/how-to-test-hyperledger-blockchain-business-model-unit-testing-and-bdd-cucumber-and-gherkin-5a7e16b561d 