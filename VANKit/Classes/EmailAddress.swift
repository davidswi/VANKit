//
//  EmailAddress.swift
//  VANKit
//
//  Created by David Switzer on 1/23/18.
//  Copyright © 2018 MadisonLabs. All rights reserved.
//

import Foundation
import SwiftyJSON

class EmailAddress{
    var address : String
    var isPreferred : Bool
    
    init(emailJSON : JSON){
        self.address = emailJSON["email"].stringValue
        self.isPreferred = emailJSON["isPreferred"].boolValue
    }
}
