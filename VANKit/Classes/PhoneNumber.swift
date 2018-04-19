//
//  PhoneNumber.swift
//  AlamoVANClient
//
//  Created by David Switzer on 1/23/18.
//  Copyright © 2018 MadisonLabs. All rights reserved.
//

import Foundation
import SwiftyJSON

class PhoneNumber{
    var number : String
    var isMobile : Bool
    var isPreferred : Bool
    
    init(phoneJSON : JSON){
        self.number = phoneJSON["phoneNumber"].stringValue
        if let type = phoneJSON["phoneType"].string{
            if (type == "C" || type == "M"){
                isMobile = true
            }
            else{
                isMobile = false
            }
        }
        else{
            isMobile = false
        }
        
        self.isPreferred = phoneJSON["isPreferred"].boolValue
    }
}
