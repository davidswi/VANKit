//
//  MailingAddress.swift
//  AlamoVANClient
//
//  Created by David Switzer on 1/23/18.
//  Copyright © 2018 MadisonLabs. All rights reserved.
//

import Foundation
import SwiftyJSON

class MailingAddress{
    var streetAddress : String?
    var addressLine2 : String?
    var addressLine3 : String?
    var city : String?
    var state : String?
    var zipCode : String?
    var isPreferred : Bool
    
    init(addressJSON : JSON){
        self.streetAddress = addressJSON["addressLine1"].string
        self.addressLine2 = addressJSON["addressLine2"].string
        self.addressLine3 = addressJSON["addressLine3"].string
        self.city = addressJSON["city"].string
        self.state = addressJSON["stateOrProvince"].string
        self.zipCode = addressJSON["zipOrPostalCode"].string
        self.isPreferred = addressJSON["isPreferred"].boolValue
    }
}
