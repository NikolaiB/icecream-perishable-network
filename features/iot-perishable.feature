Feature: IoT Ice Cream Perishable Network
 
    Background:
        Given I have deployed the business network definition ..
        And I have added the following participants
        """
        [
        {"$class":"org.acme.shipping.perishable.Manufacturer", "email":"manufacturer@email.com", "address":{"$class":"org.acme.shipping.perishable.Address", "country":"USA"}, "accountBalance":0},
        {"$class":"org.acme.shipping.perishable.Retailer", "email":"retailer@email.com", "address":{"$class":"org.acme.shipping.perishable.Address", "country":"USA"}, "accountBalance":0},
        {"$class":"org.acme.shipping.perishable.Shipper", "email":"shipper@email.com", "address":{"$class":"org.acme.shipping.perishable.Address", "country":"USA"}, "accountBalance":0}
        ]
        """
        And I have added the following asset of type org.acme.shipping.perishable.Contract
            | contractId | manufacturer           | shipper               | retailer           | arrivalDateTime  | unitPrice | minTemperature | maxTemperature | minPenaltyFactor | maxPenaltyFactor |
            | CON_001    | manufacturer@email.com | shipper@email.com |retailer@email.com | 10/27/2018 00:00 | 0.5       | -30              | -18             | 0.2              | 0.1              |
         
        And I have added the following asset of type org.acme.shipping.perishable.Shipment
            | shipmentId | type    | status     | unitCount | contract |
            | SHIP_001   | ICE_CREAM | IN_TRANSIT | 5000      | CON_001  |
        When I submit the following transactions of type org.acme.shipping.perishable.TemperatureReading
            | shipment | centigrade |
            | SHIP_001 | -18          |
            | SHIP_001 | -24          |
            | SHIP_001 | -30         |

    Scenario: When the temperature range is within the agreed-upon boundaries
    When I submit the following transaction of type org.acme.shipping.perishable.ShipmentReceived
        | shipment |
        | SHIP_001 |

    Then I should have the following participants
    """
    [
    {"$class":"org.acme.shipping.perishable.Manufacturer", "email":"manufacturer@email.com", "address":{"$class":"org.acme.shipping.perishable.Address", "country":"USA"}, "accountBalance":2500},
    {"$class":"org.acme.shipping.perishable.Retailer", "email":"retailer@email.com", "address":{"$class":"org.acme.shipping.perishable.Address", "country":"USA"}, "accountBalance":-2500},
    {"$class":"org.acme.shipping.perishable.Shipper", "email":"shipper@email.com", "address":{"$class":"org.acme.shipping.perishable.Address", "country":"USA"}, "accountBalance":0}
    ]
    """

    Scenario: When the low/min temperature threshold is breached by 2 degrees C
    Given I submit the following transaction of type org.acme.shipping.perishable.TemperatureReading
        | shipment | centigrade |
        | SHIP_001 | -32          |

    When I submit the following transaction of type org.acme.shipping.perishable.ShipmentReceived
        | shipment |
        | SHIP_001 |

    Then I should have the following participants
    """
    [
    {"$class":"org.acme.shipping.perishable.Manufacturer", "email":"manufacturer@email.com", "address":{"$class":"org.acme.shipping.perishable.Address", "country":"USA"}, "accountBalance":500},
    {"$class":"org.acme.shipping.perishable.Retailer", "email":"retailer@email.com", "address":{"$class":"org.acme.shipping.perishable.Address", "country":"USA"}, "accountBalance":-500},
    {"$class":"org.acme.shipping.perishable.Shipper", "email":"shipper@email.com", "address":{"$class":"org.acme.shipping.perishable.Address", "country":"USA"}, "accountBalance":0}
    ]
    """

    Scenario: When the hi/max temperature threshold is breached by 2 degrees C
    Given I submit the following transaction of type org.acme.shipping.perishable.TemperatureReading
        | shipment | centigrade |
        | SHIP_001 | -16          |

    When I submit the following transaction of type org.acme.shipping.perishable.ShipmentReceived
        | shipment |
        | SHIP_001 |

    Then I should have the following participants
    """
    [
    {"$class":"org.acme.shipping.perishable.Manufacturer", "email":"manufacturer@email.com", "address":{"$class":"org.acme.shipping.perishable.Address", "country":"USA"}, "accountBalance":1500},
    {"$class":"org.acme.shipping.perishable.Retailer", "email":"retailer@email.com", "address":{"$class":"org.acme.shipping.perishable.Address", "country":"USA"}, "accountBalance":-1500},
    {"$class":"org.acme.shipping.perishable.Shipper", "email":"shipper@email.com", "address":{"$class":"org.acme.shipping.perishable.Address", "country":"USA"}, "accountBalance":0}
    ]
    """

    Scenario: When the min temperature threshold is breached by 2 degree and max temperature threshold is breached by 1 degree
    Given I submit the following transaction of type org.acme.shipping.perishable.TemperatureReading
        |shipment|centigrade|
        |SHIP_001|-16|
        |SHIP_001|-31|

        When I submit the following transaction of type org.acme.shipping.perishable.ShipmentReceived
        |shipment|
        |SHIP_001|

        Then I should have the following participants
        """
    [
    {"$class":"org.acme.shipping.perishable.Manufacturer", "email":"manufacturer@email.com", "address":{"$class":"org.acme.shipping.perishable.Address", "country":"USA"}, "accountBalance":500},
    {"$class":"org.acme.shipping.perishable.Retailer", "email":"retailer@email.com", "address":{"$class":"org.acme.shipping.perishable.Address", "country":"USA"}, "accountBalance":-500},
    {"$class":"org.acme.shipping.perishable.Shipper", "email":"shipper@email.com", "address":{"$class":"org.acme.shipping.perishable.Address", "country":"USA"}, "accountBalance":0}
    ]
    """

    Scenario: Test TemperatureThresholdEvent is emitted when the min temperature threshold is violated
    When I submit the following transactions of type org.acme.shipping.perishable.TemperatureReading
        | shipment | centigrade |
        | SHIP_001 | -32          |

    Then I should have received the following event of type org.acme.shipping.perishable.TemperatureThresholdEvent
        | message                                                                          | temperature | shipment |
        | Temperature threshold violated! Emitting TemperatureEvent for shipment: SHIP_001 | -32           | SHIP_001 |


    Scenario: Test TemperatureThresholdEvent is emitted when the max temperature threshold is violated
    When I submit the following transactions of type org.acme.shipping.perishable.TemperatureReading
        | shipment | centigrade |
        | SHIP_001 | -17         |

    Then I should have received the following event of type org.acme.shipping.perishable.TemperatureThresholdEvent
        | message                                                                          | temperature | shipment |
        | Temperature threshold violated! Emitting TemperatureEvent for shipment: SHIP_001 | -17          | SHIP_001 |


     Scenario: Test ShipmentTerminalEvent is emitted when GpsReading indicates arrival at terminal
    When I submit the following transaction of type org.acme.shipping.perishable.GpsReading
        | shipment | readingTime | readingDate | latitude | latitudeDir | longitude | longitudeDir |
        | SHIP_001 | 160000      | 20180625    | 37.7749  | N           | 122.4194   | W            |

    Then I should have received the following event of type org.acme.shipping.perishable.ShipmentTerminalEvent
        | message                                                                           | shipment |
        | Shipment has reached the terminal of /LAT:37.7749N/LONG:122.4194W | SHIP_001 |